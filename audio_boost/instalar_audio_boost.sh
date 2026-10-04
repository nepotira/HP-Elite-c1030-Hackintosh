#!/bin/bash
# Instalador do Driver de Áudio com Volume Alto (100% de Ganho Nativo) para HP Elite c1030
set -e

echo "=== Instalador do Driver de Áudio com Volume Alto (HP Elite c1030) ==="

if [ "$(id -u)" -ne 0 ]; then
    echo "Erro: Execute este script como administrador: sudo ./instalar_audio_boost.sh"
    exit 1
fi

HERE="$(cd "$(dirname "$0")" && pwd)"
SOURCE="$HERE/CmlSOFAudioPlugin_Boosted.driver"
DEST="/Library/Audio/Plug-Ins/HAL/CmlSOFAudioPlugin.driver"

if [ ! -d "$SOURCE" ]; then
    echo "Erro: CmlSOFAudioPlugin_Boosted.driver não encontrado em $HERE"
    exit 1
fi

mkdir -p /Library/Audio/Plug-Ins/HAL
echo "-> Substituindo o plugin HAL antigo pela versão com ganho total..."
rm -rf "$DEST"
cp -R "$SOURCE" "$DEST"
chown -R root:wheel "$DEST"
chmod -R 755 "$DEST"

echo "-> Reiniciando o daemon de áudio do macOS (coreaudiod)..."
launchctl kickstart -kp system/com.apple.audio.coreaudiod 2>/dev/null || killall coreaudiod 2>/dev/null || true

echo "=== Sucesso! O som do seu Mac agora opera com volume alto e nítido sem apps extras! ==="
