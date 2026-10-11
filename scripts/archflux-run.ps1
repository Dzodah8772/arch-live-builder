# archflux-run.ps1
# Обновляет репозиторий, запускает сборку ISO и стартует VM в VirtualBox.

param(
    [string]$RepoPath   = "$env:USERPROFILE\Documents\arch-live-builder",
    [string]$VMName     = "ArchFluxOS",
    [int]$MemoryMB      = 2048,
    [int]$CPUs          = 2,
    [int]$VRAM          = 16,
    [int]$DiskSizeMB    = 20000,
    [string]$OutDir     = "out",
    [switch]$SkipBuild
)

function Write-Info($msg) { Write-Host "==> $msg" -ForegroundColor Cyan }
function Write-Warn($msg) { Write-Host "==> $msg" -ForegroundColor Yellow }
function Write-Err($msg)  { Write-Host "❌ $msg" -ForegroundColor Red }

$ErrorActionPreference = 'Stop'

$gitCmd  = Get-Command git -ErrorAction SilentlyContinue
$vboxCmd = Get-Command VBoxManage -ErrorAction SilentlyContinue
$bashCmd = Get-Command bash -ErrorAction SilentlyContinue
$wslCmd  = Get-Command wsl -ErrorAction SilentlyContinue

if (-not $gitCmd)  { Write-Err "git не найден в PATH."; exit 1 }
if (-not $vboxCmd) { Write-Err "VBoxManage не найден в PATH."; exit 1 }

$RepoPath = (Resolve-Path -Path $RepoPath).Path
Set-Location -Path $RepoPath

Write-Info "Репозиторий: $RepoPath"

Write-Info "Обновляю репозиторий..."
git pull --recurse-submodules

git submodule update --init --recursive

if (-not $SkipBuild) {
    $buildScript = Join-Path $RepoPath "scripts\build.sh"
    if (Test-Path $buildScript) {
        Write-Info "Собираю ISO через $buildScript"
        if ($bashCmd) {
            & bash $buildScript
        } elseif ($wslCmd) {
            $drive = $RepoPath.Substring(0,1).ToLower()
            $pathWithoutDrive = $RepoPath.Substring(2).Replace('\\','/')
            $wslPath = "/mnt/$drive/$pathWithoutDrive/scripts/build.sh"
            & wsl bash -lc "$wslPath"
        } else {
            Write-Err "Не найден bash/wsl для запуска scripts/build.sh"
            exit 1
        }
    } else {
        Write-Err "Скрипт сборки не найден: $buildScript"
        exit 1
    }
}

$isoSearchPath = Join-Path $RepoPath $OutDir
$iso = Get-ChildItem -Path $isoSearchPath -Filter *.iso -File -ErrorAction SilentlyContinue |
       Sort-Object LastWriteTime -Descending |
       Select-Object -First 1

if (-not $iso) {
    Write-Err "ISO не найден в каталоге: $isoSearchPath"
    exit 1
}

$isoPath = $iso.FullName
Write-Info "Использую ISO: $isoPath"

$vmExists = $false
try {
    & VBoxManage showvminfo $VMName *> $null
    if ($LASTEXITCODE -eq 0) { $vmExists = $true }
} catch { $vmExists = $false }

if (-not $vmExists) {
    Write-Info "Создаю VM '$VMName'"
    & VBoxManage createvm --name $VMName --register --ostype "Linux_64" | Out-Null
    & VBoxManage modifyvm $VMName --memory $MemoryMB --cpus $CPUs --vram $VRAM --graphicscontroller vmsvga --audio none
}

$sataName = "SATA Controller"
$hasController = & VBoxManage showvminfo $VMName --machinereadable | Select-String -Pattern "storagecontrollername" | Select-String -Pattern $sataName
if (-not $hasController) {
    & VBoxManage storagectl $VMName --name $sataName --add sata --controller IntelAhci
}

$vdiPath = Join-Path $RepoPath "$VMName.vdi"
if (-not (Test-Path $vdiPath)) {
    & VBoxManage createmedium disk --filename $vdiPath --size $DiskSizeMB --format VDI | Out-Null
}

& VBoxManage storageattach $VMName --storagectl $sataName --port 0 --device 0 --type hdd --medium $vdiPath
& VBoxManage storageattach $VMName --storagectl $sataName --port 1 --device 0 --type dvddrive --medium $isoPath

Write-Info "Запускаю VM '$VMName'"
& VBoxManage startvm $VMName
