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
| **Tela** | 13.5" IPS 1920 × 1280 (proporção 3:2) |
| **Rede Sem Fio** | Intel Wi-Fi 6 AX201 + Bluetooth 5.2 |
| **Portas** | 2× USB Type-C (USB 3.2 Gen 1, DisplayPort 1.2 Alt Mode, Power Delivery) + 1× USB-A |
| **Firmware** | Coreboot / MrChromebox Full ROM UEFI |

---

## 🚀 Status dos Recursos

| Recurso | Status | Observações |
| :--- | :---: | :--- |
| **Aceleração Gráfica Metal 3** | ✅ Funcionando | Intel UHD 630 com aceleração completa, transparências e animações fluidas |
| **Monitor Externo USB-C (DisplayPort)** | ✅ Funcionando | Corrigido com `igfxagdc=0` e `disable-agdc` (sem congelamentos) |
| **Gerenciamento de Energia da CPU** | ✅ Funcionando | `CPUFriend` tunado com EPP `0x40` para resposta instantânea de clock |
| **Trackpad Multitoque** | ✅ Funcionando | Gestos nativos do macOS via `VoodooI2C` + `VoodooI2CELAN` (I2C0) |
| **Áudio (Alto-falantes & Fones)** | ✅ Funcionando | Driver SOF (`CmlSOFAudio`). Volume alto nativo via pasta `audio_boost/` |
| **Microfone Interno** | 🟡 Em testes / Parcial | Reconhecido como DMIC no CmlSOFAudio HAL, porém com sensibilidade baixa |
| **Wi-Fi** | ✅ Funcionando | Gerenciado com estabilidade via `itlwm.kext` + app **HeliPort** |
| **Bluetooth** | ✅ Funcionando | `IntelBluetoothFirmware` + `BlueToolFixup` |
| **Teclado & Atalhos (Brilho/Volume)** | ✅ Funcionando | Teclas de função e multimídia mapeadas via `SSDT-ChromebookKeys` |
| **Iluminação do Teclado (Backlight)** | ❌ Não funcional | Controlado pelo Chrome EC via PWM proprietário; em testes pela comunidade |
| **Touchscreen** | ❌ Desativado por Segurança | Bloqueado propositalmente (`SSDT-NoTouch`) para evitar crash/congelamento no I2C |
| **Indicador de Bateria & Status EC** | ✅ Funcionando | Integrado com `CrosEC.kext` + `SMCBatteryManager` |
| **SSD NVMe (Western Digital)** | ✅ Funcionando | `NVMeFix.kext` ativo para estabilidade térmica e de energia |
| **Sleep / Wake** | ✅ Funcionando | Suspensão e despertar funcionando perfeitamente |

---

## 📶 Como Usar o Wi-Fi com o HeliPort

Como a placa de rede sem fio é uma **Intel Wi-Fi 6 AX201**, a Apple não possui drivers nativos para ela nas versões modernas do macOS. O driver open-source **itlwm** gerencia o hardware da Intel emulando uma interface de alta velocidade, e o aplicativo **HeliPort** fornece o menu visual idêntico ao Wi-Fi nativo da Apple.

### Passo a Passo:
1. Baixe a versão mais recente do aplicativo [HeliPort](https://github.com/OpenIntelWireless/HeliPort/releases).
2. Abra o arquivo `.dmg` e arraste o **HeliPort.app** para a sua pasta **Aplicativos** (`/Applications`).
3. Abra o HeliPort. O ícone de Wi-Fi aparecerá na sua **barra de menus superior** (ao lado do relógio).
4. Clique no ícone do HeliPort, selecione sua rede Wi-Fi e digite a senha.
5. Marque a opção para **lembrar a rede** (Auto-Join) para que ele conecte automaticamente ao iniciar.
6. **Para iniciar sempre com o macOS:**
   * Vá em `Ajustes do Sistema -> Geral -> Itens de Início`.
   * Na seção *"Abrir no Início de Sessão"*, clique no `+` e adicione o **HeliPort.app**.

---

## 🔊 Áudio com Volume Alto Nativo (`audio_boost`)

O driver `CmlSOFAudio` padrão limita o ganho de software a 25% para evitar distorções no amplificador. Se você acha o som do notebook baixo, incluímos uma versão calibrada para **100% de ganho nativo (4x mais alto)** sem necessidade de instalar aplicativos de terceiros da App Store.

Para ativar o volume amplificado no macOS:
1. Abra a pasta `audio_boost` deste repositório no seu Mac.
2. Abra o Terminal e execute:
   ```bash
   cd audio_boost
   sudo ./instalar_audio_boost.sh
   ```
3. O script substituirá o plugin HAL em `/Library/Audio/Plug-Ins/HAL/` e reiniciará o serviço de áudio. Pronto!

---

## 🪟 Dicas para quem vem do Windows (Produtividade & Atalhos)

Preparamos um guia completo dedicado a quem está migrando do Windows para o macOS no Chromebook, ensinando como configurar o **LinearMouse** para iniciar junto com o sistema, como ter o **gerenciamento de janelas com divisão de tela (Snap)**, o **Alt+Tab idêntico ao Windows** e as diferenças de atalhos (`Cmd` vs `Ctrl`):

👉 **[Acesse o Guia de Sobrevivência do Windows no macOS](docs/DICAS_MIGRACAO_WINDOWS.md)**

---

## 🛠️ Correções e Otimizações Críticas Aplicadas

### 1. Correção do Monitor Externo USB-C (DisplayPort Alt Mode)
* **O Problema:** Conectar uma tela externa via USB-C espelhava o vídeo por poucos segundos e congelava o sistema por completo.
* **A Solução:** Adicionados `igfxagdc=0` aos `boot-args` e `disable-agdc = 01000000` em `DeviceProperties`. A memória do framebuffer (`fbmem`) foi calibrada em 9 MB e o `framebuffer-cursormem` inflado foi removido, permitindo que as duas telas operem simultaneamente sem estourar o limite de memória DVMT da BIOS.

### 2. Desempenho e Fluidez de Animações (EPP 0x40)
* No `CPUFriendDataProvider.kext`, o parâmetro **EPP (Energy Performance Preference)** foi configurado para **`0x40`** em todos os vetores de frequência. A CPU sobe o clock instantaneamente no início de animações (efeito Gênio, Mission Control e redimensionamento), eliminando engasgos visuais.

---

## ⚡ Por que o sistema pode parecer meio travado no início, mas fica ultra-fluido com o tempo?

### 🗣️ Falando a real (A explicação prática / tática):
Se você acabou de instalar o macOS ou acabou de reiniciar o notebook e notar que, nos primeiros minutos, algumas animações dão uma leve engasgada ou parecem meio travadas, **não se preocupe e não mexa em nada! Isso é 100% normal e esperado.**

Pode parecer que o sistema está pesado logo no começo, mas **garantimos que ele funcionará muito bem e cada vez melhor com o tempo de uso**. Conforme você vai usando o notebook, abrindo os aplicativos, navegando e usando as janelas, o macOS vai "aquecendo os motores" e guardando tudo na memória rápida. Em pouco tempo, você vai notar que as animações ficam completamente lisas, soltas e o sistema simplesmente voa!

### 🔬 Para quem quer saber os detalhes (A explicação técnica):
Existem 5 razões reais de engenharia pelas quais o macOS ganha tanta fluidez com o uso contínuo:

1. **Compilação e Cache de Shaders Metal (JIT da GPU):** A placa de vídeo integrada (Intel UHD 630) compila os efeitos visuais, desfoques (*blur*, transparências e janelas) via Metal sob demanda (*Just-In-Time*). Na primeira vez que um efeito aparece na tela, a GPU gasta alguns milissegundos compilando as instruções; logo em seguida, o macOS armazena esse código já compilado em cache rápido no disco (`/var/db/Metal/`). Nas vezes seguintes, a GPU simplesmente lê o cache pronto da memória sem gastar processamento, tornando tudo 100% fluido.
2. **Serviços Pesados de Indexação Inicial:** Logo após a inicialização, o indexador do **Spotlight (`mds`, `mdworker_shared`)** e rotinas de telemetria do sistema varrem os arquivos para criar o catálogo de buscas rápidas. Essa varredura inicial consome ciclos da CPU e do SSD nos primeiros minutos. Assim que a indexação termina, esses serviços silenciam e a CPU fica 100% livre para a interface.
3. **Gerenciamento de Memória Dinâmico (Mach VM):** O macOS tem uma política de gerenciamento de memória em que a RAM livre é considerada "desperdiçada". Com os **16 GB LPDDR4** do HP Elite c1030, tudo o que você abre fica pré-carregado em cache quente na memória (*warm cache*). Alternar entre janelas e apps passa a ser instantâneo.
4. **Pré-aquecimento do WindowServer e buffers do CoreAnimation:** As texturas e matrizes de desenho da interface gráfica já ficam alocadas diretamente no framebuffer de vídeo.
5. **Ajuste de Clock da CPU com EPP `0x40`:** Como calibramos o `CPUFriend` para EPP `0x40`, o processador Intel Core i7-10610U sobe o clock instantaneamente na menor demanda gráfica. Quando essa resposta imediata de clock se junta aos shaders e apps já em cache na memória, a máquina entrega o ápice de desempenho.

### 3. Trava de Segurança do Touchscreen (Evita Kernel Panics)
* O Chromebook possui uma tela sensível ao toque que causa congelamento de interrupção I2C no driver `VoodooI2CHID` ao ser tocada.
* **A Solução:** 
  1. Patch ACPI de 14 bytes renomeando o método `_STA` do touchscreen para `XSTA`.
  2. Patch ACPI renomeando o `_CID` `PNP0C50` para `XNP0C50`.
  3. `SSDT-NoTouch.aml` forçando `_STA = 0` no macOS. A tela de toque fica desativada no macOS com total segurança, mantendo o trackpad 100% funcional.

---

## 📖 Como Usar a EFI

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

### 🛠️ Pós-Instalação Obrigatória (Primeiros Passos no macOS)

Assim que o macOS inicializar pela primeira vez usando a EFI, execute estas duas etapas essenciais:

1. **Ativar o Áudio com Volume Alto Nativo (100% de ganho):**
   O OpenCore carrega a kext no kernel, mas o subsistema Sound Open Firmware (SOF) do Chromebook precisa do plugin HAL dentro do macOS. Abra o Terminal e rode:
   ```bash
   cd audio_boost
   sudo ./instalar_audio_boost.sh
   ```
   Isso ativa o som com volume alto e nítido instantaneamente, sem precisar de apps de terceiros.

2. **Conectar ao Wi-Fi com o HeliPort:**
   Baixe o aplicativo oficial [HeliPort](https://github.com/OpenIntelWireless/HeliPort/releases), arraste para sua pasta **Aplicativos** (`/Applications`), abra-o e conecte na sua rede pelo ícone na barra superior. Lembre-se de adicioná-lo em `Ajustes do Sistema -> Geral -> Itens de Início` para conectar automaticamente ao ligar.

3. **Produtividade & Atalhos (Para quem vem do Windows):**
   Instale o **LinearMouse**, o **Rectangle** (snap de janelas) e o **AltTab** seguindo o nosso **[Guia de Dicas do Windows no macOS](docs/DICAS_MIGRACAO_WINDOWS.md)**.

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
* [DexterSLamb](https://github.com/DexterSLamb/CmlSOFAudio) pelo driver `CmlSOFAudio` para Comet Lake SOF.
* [VoodooI2C Team](https://github.com/VoodooI2C/VoodooI2C) pelo suporte ao trackpad I2C.
* [OpenIntelWireless](https://github.com/OpenIntelWireless) pelos drivers `itlwm` e `IntelBluetoothFirmware`.
