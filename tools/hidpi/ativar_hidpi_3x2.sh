#!/bin/bash
# ==============================================================================
# Ativador HiDPI Nativo 3:2 para HP Elite c1030 Chromebook (Hackintosh)
# Resolução Nativa: 1920 x 1280 (Painel 13.5" IPS 3:2)
# VendorID: 0x30e4 (12516) | ProductID: 0x0663 (1635)
# Baseado na estrutura do projeto xzhih/one-key-hidpi (adaptado para 3:2)
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=========================================================="
echo "  Ativador HiDPI 3:2 - HP Elite c1030 Hackintosh"
echo "=========================================================="

if [ "$(id -u)" -ne 0 ]; then
    echo "Erro: Execute este script como administrador:"
    echo "  sudo $0"
    exit 1
fi

VENDOR_HEX="30e4"
PRODUCT_HEX="663"
VENDOR_ID=12516
PRODUCT_ID=1635

OVERRIDES_DIR="/Library/Displays/Contents/Resources/Overrides"
TARGET_DIR="${OVERRIDES_DIR}/DisplayVendorID-${VENDOR_HEX}"
TARGET_FILE="${TARGET_DIR}/DisplayProductID-${PRODUCT_HEX}"

echo "-> Criando diretório de Overrides em ${TARGET_DIR}..."
mkdir -p "${TARGET_DIR}"

if [ -f "${TARGET_FILE}" ]; then
    echo "-> Fazendo backup da configuração atual..."
    cp -f "${TARGET_FILE}" "${TARGET_FILE}.bak"
fi

if [ -f "${SCRIPT_DIR}/DisplayProductID-${PRODUCT_HEX}" ]; then
    echo "-> Instalando DisplayProductID-${PRODUCT_HEX} pré-compilado..."
    cp -f "${SCRIPT_DIR}/DisplayProductID-${PRODUCT_HEX}" "${TARGET_FILE}"
else
    echo "-> Gerando tabela de resoluções HiDPI 3:2 otimizadas dinamicamente..."
    python3 - << 'EOF'
import struct, base64

modes_3x2 = [
    (1920, 1280), # 100% Nativo (Render 3840x2560 downscaled)
    (1728, 1152), # ~111%
    (1680, 1120), # ~114%
    (1600, 1067), # ~120%
    (1536, 1024), # 125% (Ponto ideal / Sweet Spot para 13.5")
    (1440, 960),  # 133%
    (1344, 896),  # 143%
    (1280, 854),  # 150%
    (1152, 768),  # 167%
    (1024, 682),  # 188%
    (960,  640),  # 200% (Retina 2x puro)
]

entries = []

# Conjunto 1: Canvas de Renderização 2x (len 9, flags 00)
for w, h in modes_3x2:
    b = struct.pack('>IIB', w*2, h*2, 0)
    entries.append(base64.b64encode(b).decode())

# Conjunto 2: Modos HiDPI declarados (len 16, flags 0000000900a00000)
for w, h in modes_3x2:
    b = struct.pack('>IIII', w*2, h*2, 9, 0x00a00000)
    entries.append(base64.b64encode(b).decode())

# Conjunto 3: Modos complementares (len 16, flags 0000000100200000)
for w, h in modes_3x2:
    b = struct.pack('>IIII', w, h, 1, 0x00200000)
    entries.append(base64.b64encode(b).decode())

# Conjunto 4: Modos 1x padrão (len 12, flags 00000001)
for w, h in modes_3x2:
    b = struct.pack('>III', w, h, 1)
    entries.append(base64.b64encode(b).decode())

plist = '''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
\t<key>DisplayProductID</key>
\t<integer>1635</integer>
\t<key>DisplayVendorID</key>
\t<integer>12516</integer>
\t<key>DisplayProductName</key>
\t<string>Color LCD</string>
\t<key>scale-resolutions</key>
\t<array>
'''

for e in entries:
    plist += f'\t\t<data>{e}</data>\n'

plist += '''\t</array>
\t<key>target-default-ppmm</key>
\t<real>10.0699301</real>
</dict>
</plist>
'''

with open('/tmp/DisplayProductID-663.generated', 'w') as f:
    f.write(plist)
EOF
    cp -f /tmp/DisplayProductID-663.generated "${TARGET_FILE}"
fi

# Copiar o ícone se existir
if [ -f "${SCRIPT_DIR}/DisplayProductID-${PRODUCT_HEX}.icns" ]; then
    echo "-> Instalando ícone do painel Retina (MacBook Pro)..."
    cp -f "${SCRIPT_DIR}/DisplayProductID-${PRODUCT_HEX}.icns" "${TARGET_DIR}/"
fi

echo "-> Configurando permissões do sistema..."
chown -R root:wheel "${TARGET_DIR}"
chmod 755 "${TARGET_DIR}"
chmod 644 "${TARGET_FILE}"
[ -f "${TARGET_DIR}/DisplayProductID-${PRODUCT_HEX}.icns" ] && chmod 644 "${TARGET_DIR}/DisplayProductID-${PRODUCT_HEX}.icns"

echo "-> Ativando DisplayResolutionEnabled no WindowServer..."
defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool YES

echo ""
echo "=========================================================="
echo "✅ HiDPI 3:2 ativado com sucesso!"
echo "   Resoluções injetadas: 1920x1280, 1600x1067, 1536x1024 (125%),"
echo "                         1440x960 (133%), 1280x854 (150%), 960x640"
echo ""
echo "⚠️  IMPORTANTE: Reinicie o seu notebook para o macOS carregar"
echo "   as novas resoluções HiDPI no menu Ajustes do Sistema ➔ Telas."
echo "=========================================================="
