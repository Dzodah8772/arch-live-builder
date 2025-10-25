# 🧩 04 — Виртуализация: VirtualBox / QEMU / VMware

**Цель:** Обеспечить совместимость ArchFlux OS с популярными гипервизорами и подготовить образы для Vagrant/Cloud-init при необходимости.  
**Статус:** 🚧 План  
**Приоритет:** средний

## Описание
Подготовить инструкции и образы, которые будут корректно работать в VirtualBox, QEMU/KVM и VMware. Включить гостевые дополнения (Guest Additions / QEMU guest tools) и оптимизации.

## Компоненты
- VirtualBox Guest Additions / VBoxService
- QEMU virtio-drivers и cloud-init (если нужно)
- VMware tools (open-vm-tools)
- Преднастроенные OVF/OVA или QCOW2 образы

## Этапы реализации
- [ ] Тестовые образы для каждого гипервизора
- [ ] Скрипты конвертации/упаковки (qcow2 -> vmdk/ova)
- [ ] Документация по запуску и настройке

---