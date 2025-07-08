#!/bin/bash

set -e

# === Settings ===
DEFAULT_IMAGE="https://sourceforge.net/projects/nixpoin/files/windows2019DO.gz"
RDP_PORT=3389   # Bisa diganti jadi 22 kalau mau

# === Pilihan OS ===
echo "Pilih versi Windows yang ingin diinstall:"
echo " 1) Windows Server 2019 (default)"
echo " 2) Windows Server 2016"
echo " 3) Windows Server 2012"
echo " 4) Windows 10 Lite"
echo " 5) Masukkan link image sendiri"

read -p "Pilihan [1]: " pilih
case "$pilih" in
  1|"") IMAGE="$DEFAULT_IMAGE" ;;
  2) IMAGE="https://sourceforge.net/projects/win-gz/files/2024-08-17/win-server-2016.gz" ;;
  3) IMAGE="https://sourceforge.net/projects/nixpoin/files/windows2012DO.gz" ;;
  4) IMAGE="https://umbel.my.id/wedus10lite.gz" ;;
  5) read -p "Masukkan link .gz Windows: " IMAGE ;;
  *) echo "Pilihan tidak valid." && exit 1 ;;
esac

echo "[✓] Menggunakan image: $IMAGE"
sleep 2

# === Konfirmasi user ===
echo "⚠️ PERINGATAN: Proses ini akan menghapus semua data di VPS!"
read -p "Ketik 'YES' untuk melanjutkan: " confirm
[ "$confirm" != "YES" ] && echo "Dibatalkan." && exit 1

# === Instalasi alat ===
echo "[⏳] Menginstall tools..."
apt update -y && apt install -y wget curl gunzip

# === Overwrite Disk ===
echo "[🚀] Menulis image ke /dev/vda, mohon tunggu..."
wget --no-check-certificate -O- "$IMAGE" | gunzip | dd of=/dev/vda bs=3M status=progress

echo "[✅] Berhasil overwrite image ke disk utama."

# === Shutdown ===
echo "🛑 VPS akan dimatikan dalam 10 detik, lalu kamu bisa RDP ke: $(curl -s ifconfig.me):$RDP_PORT"
sleep 10
poweroff
