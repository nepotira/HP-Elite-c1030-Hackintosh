# 🍎 HP Elite c1030 Chromebook (Jinlon) - macOS Hackintosh EFI

[![OpenCore](https://img.shields.io/badge/OpenCore-1.0.x-blue.svg)](https://github.com/acidanthera/OpenCorePkg)
[![macOS](https://img.shields.io/badge/macOS-Sonoma%20%7C%20Sequoia%20%7C%20Tahoe-green.svg)](https://www.apple.com/macos/)
[![Release](https://img.shields.io/github/v/release/nepotira/HP-Elite-c1030-Hackintosh?color=brightgreen)](https://github.com/nepotira/HP-Elite-c1030-Hackintosh/releases/latest)
[![Hardware](https://img.shields.io/badge/Board-Jinlon%20(Comet%20Lake)-orange.svg)](https://support.hp.com)

Esta é a pasta **EFI definitiva, testada e 100% otimizada** para rodar o macOS com aceleração gráfica completa, estabilidade total e alto desempenho no **HP Elite c1030 Chromebook** (placa-mãe *Jinlon*), com firmware UEFI **Coreboot (MrChromebox Full ROM)**.

---

## 💻 Especificações do Hardware

| Componente | Detalhe |
| :--- | :--- |
| **Modelo** | HP Elite c1030 Chromebook (x360 13c) |
| **Placa-mãe / Codinome** | Jinlon (Google ChromeOS platform) |
| **Processador** | Intel Core i7-10610U @ 1.80 GHz (Turbo até 4.90 GHz) - 4 Cores / 8 Threads |
| **Gráficos Integrados** | Intel UHD Graphics 630 (Comet Lake GT2, Device ID `0x9B41` / Spoof `0x3EA5`) |
| **Memória RAM** | 16 GB LPDDR4 2667 MHz (Dual-Channel) |
| **Armazenamento** | Western Digital PC SN520 128 GB NVMe SSD |
| **Tela** | 13.5" IPS 1920 × 1280 (proporção 3:2), Touchscreen |
| **Rede Sem Fio** | Intel Wi-Fi 6 AX201 + Bluetooth 5.2 |
| **Portas** | 2× USB Type-C (USB 3.2 Gen 1, DisplayPort 1.2 Alt Mode, Power Delivery) + 1× USB-A |
| **Firmware** | Coreboot / MrChromebox Full ROM UEFI |

---

## 🚀 Status dos Recursos

| Recurso | Status | Observações |
| :--- | :---: | :--- |
| **Aceleração Gráfica Metal 3** | ✅ Funcionando | Intel UHD 630 com aceleração completa e animações fluidas |
| **Monitor Externo USB-C (DisplayPort)** | ✅ Funcionando | Corrigido com `igfxagdc=0` e `disable-agdc` (sem congelamento/freeze) |
| **Gerenciamento de Energia da CPU** | ✅ Funcionando | `CPUFriend` tunado com EPP `0x40` para resposta instantânea de clock |
| **Proteção contra crash no Touchscreen** | ✅ Funcionando | Patch ACPI duplo de 14 bytes + `SSDT-NoTouch` bloqueando travamento |
| **Trackpad Multitoque** | ✅ Funcionando | Gestos nativos do macOS via `VoodooI2C` + `VoodooI2CELAN` (I2C0) |
| **Áudio (Falantes, Fone, Microfone)** | ✅ Funcionando | Implementado via driver Sound Open Firmware (`CmlSOFAudio.kext`) |
| **Wi-Fi** | ✅ Funcionando | Gerenciado via `itlwm.kext` + aplicativo **HeliPort** |
| **Bluetooth** | ✅ Funcionando | `IntelBluetoothFirmware` + `BlueToolFixup` |
| **Teclado & Teclas Especiais** | ✅ Funcionando | Brilho da tela, volume e layout mapeados via `SSDT-ChromebookKeys` |
| **Indicador de Bateria & Status EC** | ✅ Funcionando | Integrado com `CrosEC.kext` + `SMCBatteryManager` |
| **SSD NVMe (Western Digital)** | ✅ Funcionando | `NVMeFix.kext` ativo para evitar gargalos e timeouts de energia |
| **Sleep / Wake** | ✅ Funcionando | Suspensão e despertar estáveis |

---

## 🛠️ Correções e Otimizações Críticas Aplicadas

### 1. Correção do Monitor Externo USB-C (DisplayPort Alt Mode)
* **O Problema:** Conectar uma tela externa via USB-C espelhava o vídeo por poucos segundos e congelava o sistema por completo.
* **A Solução:** Adicionados `igfxagdc=0` aos `boot-args` e `disable-agdc = 01000000` em `DeviceProperties`. A memória do framebuffer (`fbmem`) foi calibrada em 9 MB e o `framebuffer-cursormem` inflado foi removido, permitindo que as duas telas operem simultaneamente sem estourar o limite de memória DVMT da BIOS.

### 2. Desempenho e Fluidez de Animações (EPP 0x40)
* No `CPUFriendDataProvider.kext`, o parâmetro **EPP (Energy Performance Preference)** foi configurado para **`0x40`** em todos os vetores de frequência. A CPU sobe o clock instantaneamente no início de animações (efeito Gênio, Mission Control e redimensionamento), eliminando engasgos visuais.

### 3. Trava de Segurança do Touchscreen (Evita Kernel Panics)
* O Chromebook possui uma tela sensível ao toque que causa congelamento de interrupção I2C no driver `VoodooI2CHID` ao ser tocada.
* **A Solução:** 
  1. Patch ACPI de 14 bytes renomeando o método `_STA` do touchscreen para `XSTA`.
  2. Patch ACPI renomeando o `_CID` `PNP0C50` para `XNP0C50`.
  3. `SSDT-NoTouch.aml` forçando `_STA = 0` no macOS. A tela de toque fica desativada no macOS com total segurança, mantendo o trackpad 100% funcional.

---

## 📖 Como Usar

### Opção 1: Baixar a Release Pronta (Recomendado)
1. Vá na aba **[Releases](https://github.com/nepotira/HP-Elite-c1030-Hackintosh/releases/latest)** e baixe o arquivo **`EFI-HP-Elite-c1030-v1.0.0.zip`**.
2. Extraia o arquivo zip.
3. Copie a pasta `EFI` para a partição EFI (FAT32) do seu SSD ou pendrive bootável.

### Opção 2: Clonar o Repositório via Git
```bash
git clone https://github.com/nepotira/HP-Elite-c1030-Hackintosh.git
```
Copie a pasta `EFI` do repositório para a partição EFI (FAT32).

---

### Inicialização e Pós-Instalação:
1. No menu inicial do OpenCore, pressione a barra de espaço e selecione `Reset NVRAM` para limpar caches residuais.
2. Inicie o instalador ou o macOS!

---

## ⚠️ Gerando seus próprios números de série (SMBIOS)

Por motivos de segurança e para o correto funcionamento dos serviços da Apple (iMessage, FaceTime, iCloud), gere seu próprio número de série antes de logar na sua conta Apple:
1. Baixe o [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS).
2. Escolha o modelo **MacBookPro16,2**.
3. Substitua `MLB`, `SystemSerialNumber` e `SystemUUID` na seção `PlatformInfo -> Generic` do seu `config.plist`.

---

## 🤝 Créditos
* [Acidanthera](https://github.com/acidanthera) pelo OpenCore, Lilu, WhateverGreen, VirtualSMC, VoodooInput e AppleALC.
* [MrChromebox](https://mrchromebox.tech/) pelo firmware UEFI Coreboot para Chromebooks.
* [VoodooI2C Team](https://github.com/VoodooI2C/VoodooI2C) pelo suporte ao trackpad I2C.
* [OpenIntelWireless](https://github.com/OpenIntelWireless) pelos drivers `itlwm` e `IntelBluetoothFirmware`.
* Comunidade Hackintosh pelo suporte ao SOF Audio no Comet Lake.
