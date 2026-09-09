#!/bin/bash
set -e
sudo pacman -S --needed archiso
rm -rf work out
sudo mkarchiso -v -w work -o out .
( cd out && sha256sum *.iso > SHA256SUMS )
echo "Готово: ISO в out/"
