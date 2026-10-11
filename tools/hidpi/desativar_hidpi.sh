#!/bin/bash
# ==============================================================================
# Desativador HiDPI para HP Elite c1030 Chromebook (Hackintosh)
# ==============================================================================

set -e

echo "=========================================================="
echo "  Desativador HiDPI - Restaurar Configurações Originais"
echo "=========================================================="

if [ "$(id -u)" -ne 0 ]; then
    echo "Erro: Execute este script como administrador:"
    echo "  sudo $0"
    exit 1
fi

OVERRIDES_DIR="/Library/Displays/Contents/Resources/Overrides"
VENDOR_DIR="${OVERRIDES_DIR}/DisplayVendorID-30e4"

if [ -d "${VENDOR_DIR}" ]; then
    echo "-> Removendo configurações personalizadas do monitor..."
    rm -rf "${VENDOR_DIR}"
fi

echo "=========================================================="
echo "✅ HiDPI desativado. Configuração original da Apple restaurada!"
echo "   Reinicie o notebook para concluir."
echo "=========================================================="
