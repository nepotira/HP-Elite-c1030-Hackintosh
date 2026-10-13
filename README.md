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

## 🧭 Acabou de Comprar o HP Elite c1030? (Do Zero ao macOS)

Se você acabou de comprar o Chromebook e ele ainda está com o ChromeOS de fábrica, preparamos um **guia completo do zero**, passo a passo, ensinando como desbloquear a placa com o Coreboot UEFI, a estratégia de instalar o Windows leve (Tiny11) primeiro como base, como configurar o OpenCore e como instalar o macOS:

👉 **[Acesse o Tutorial Completo: Do ChromeOS ao macOS Passo a Passo](docs/GUIA_DO_ZERO_AO_MACOS.md)**

> [!WARNING]
> **AVISO IMPORTANTE:** O guia inclui os links dos tutoriais oficiais do [MrChromebox.tech](https://mrchromebox.tech/), instruções de segurança de hardware, e dicas sobre como utilizar Inteligência Artificial (Antigravity como Administrador com modelos Gemini Flash no modo High) para ajudar no processo por sua conta e risco. NÃO nos responsabilizamos por quaisquer danos ao seu hardware!

---

## 🚀 Status dos Recursos

| Recurso | Status | Observações |
| :--- | :---: | :--- |
| **Aceleração Gráfica Metal 3** | ✅ Funcionando | Intel UHD 630 com aceleração completa, transparências e animações fluidas |
| **Monitor Externo USB-C (DisplayPort)** | ⚠️ Em Testes (Instável) | Funciona no Windows, mas no macOS o hotplug de cabos diretos USB-C para USB-C pode congelar o sistema; em investigação ativa |
| **Gerenciamento de Energia da CPU** | ✅ Funcionando | `CPUFriend` tunado com EPP `0x40` para resposta instantânea de clock |
| **Trackpad Multitoque** | ✅ Funcionando | Gestos nativos do macOS via `VoodooI2C` + `VoodooI2CELAN` (I2C0) |
| **Áudio (Alto-falantes & Fones)** | ✅ Funcionando | Driver SOF (`CmlSOFAudio`). Volume alto nativo via pacote `audio_boost` |
| **Microfone Interno** | ✅ Funcionando | Matriz DMIC interna gravando com clareza nos Ajustes e no Gravador de Voz |
| **Wi-Fi** | ✅ Funcionando | Gerenciado com estabilidade via `itlwm.kext` + app **HeliPort** |
| **Bluetooth** | ✅ Funcionando | `IntelBluetoothFirmware` + `BlueToolFixup` |
| **Teclado & Teclas de Atalho** | ✅ Funcionando | Brilho, volume, multimídia e atalhos mapeados via `SSDT-ChromebookKeys` |
| **Iluminação do Teclado (Backlight)** | ❌ Não funcional | Controle gerenciado pelo ChromeOS EC que não possui driver compatível no macOS |
| **Serviços de Localização** | 🟡 Parcial (IP) | itlwm opera via emulação de rede; localização precisa por Wi-Fi BSSID não disponível |
| **Touchscreen** | ❌ Desativado por Segurança | Bloqueado propositalmente (`SSDT-NoTouch`) para evitar crash/congelamento no I2C |
| **Indicador de Bateria & Status EC** | ✅ Funcionando | Integrado com `CrosEC.kext` + `SMCBatteryManager` |
| **SSD NVMe (Western Digital)** | ✅ Funcionando | `NVMeFix.kext` ativo para estabilidade térmica e de energia |
| **Reprodução de Vídeos (YouTube/Navegadores)** | ✅ Funcionando | Decodificação por hardware fluida (corrigido com remoção de `forceRenderStandby=0`) |
| **Streaming com DRM (Netflix/Prime Video)** | ✅ Funcionando | FairPlay nativo 1080p no Safari e Widevine no Chrome (com `-amfipassbeta`) |
| **Permissões do Sistema (TCC / WhatsApp)** | ✅ Funcionando | Pop-ups nativos de microfone/câmera liberados via `AMFIPass.kext` |
| **Controles de Jogo (GameSir Nova Lite)** | ✅ Funcionando | Suporte completo via Dongle USB 2.4 GHz (XInput) com utilitários dedicados e Bluetooth nativo |
| **Escala da Tela HiDPI (Retina 3:2)** | ✅ Funcionando | Resoluções HiDPI 3:2 (125% / 1536×1024, 1600×1067) com nitidez cristalina via pacote `tools/hidpi` |
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

### 1. Monitor Externo USB-C (DisplayPort Alt Mode) — [STATUS: EM TESTES / INSTÁVEL]
* **Situação Atual:** No Windows, o sinal de vídeo externo via USB-C (DisplayPort Alt Mode) funciona perfeitamente (testado com monitor portátil Full HD `RTK1920` na porta direita), comprovando que o conector físico, a GPU e o monitor são plenamente funcionais. No macOS, no entanto, a conexão via cabo direto **USB-C para USB-C** ainda está em fase de testes e apresenta **congelamento completo do sistema (*hard freeze*)** no momento em que o cabo é conectado com o sistema ligado (*hotplug*).
* **Diagnóstico Técnico:**
  1. Conexões diretas **USB-C para USB-C** transmitem simultaneamente sinal de vídeo (DisplayPort Alt Mode), dados e alta potência de recarga (**USB Power Delivery**). No HP Elite c1030 (hardware Chromebook *Jinlon*), o chaveamento dessas linhas é controlado pelo chip **ChromeOS EC (Embedded Controller)**, que não possui um driver de comutação Type-C equivalente no macOS, o que pode causar conflito elétrico ou tempestades de interrupção ACPI.
  2. Ajustes anteriores de Hackintosh desktop como `disable-agdc` ou `igfxonln=1` causavam conflitos no handshake de link training do DisplayPort.
  3. A porta USB-C da esquerda apresentou vulnerabilidade a mau contato físico no conector em alguns testes, enquanto a porta da direita opera estável no Windows.
* **Recomendações no Momento:**
  * Para uso de monitor externo no macOS, recomenda-se provisoriamente o uso de **adaptadores dedicados Type-C para HDMI ou Type-C para DisplayPort** (que isolam a transmissão exclusivamente para vídeo, sem injeção simultânea de Power Delivery).
  * O recurso segue em investigação ativa para refinamento dos buffers de vídeo e ACPI.

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

### 4. Correções de Vídeo por Hardware, Permissões TCC e DRM (v1.1.0)
* **Destravamento de Vídeos (YouTube/Navegadores):** A remoção do argumento `forceRenderStandby=0` permitiu que a Intel UHD 630 alterne seus estados de energia RC6 durante a reprodução de mídia, eliminando o congelamento silencioso do serviço `VTDecoderXPCService`.
* **Permissões do Sistema (WhatsApp/Microfone/Câmera):** A remoção da antiga marreta `amfi=0x80` e a transição para o **`AMFIPass.kext`** com o argumento **`-amfipassbeta`** restaurou os pop-ups nativos de autorização do macOS, permitindo que o WhatsApp acesse o microfone normalmente.
* **Aceleração DRM (Netflix/Prime Video):** Com o AMFI mantido de forma compatível via `AMFIPass`, a biblioteca Widevine do Google Chrome (`libwidevinecdm.dylib`) carrega com validação íntegra, permitindo a reprodução de streamings protegidos por direitos autorais. No Safari, o streaming roda via **Apple FairPlay nativo por hardware**.
* **Por que NÃO usar o Intel GuC Firmware (`igfxfw=2`):** O firmware Coreboot / MrChromebox não implementa os canais de autenticação proprietários da Intel MEI (*Management Engine*). Tentar forçar o carregamento do GuC via `igfxfw=2` faz o driver `AppleIntelKBLGraphics` entrar em loop de espera infinito (*hardware timeout*), travando o boot na barra da maçã.

### 5. 🎮 Controles de Jogo no macOS (GameSir Nova Lite com Dongle 2.4 GHz & xCloud)
O **GameSir Nova Lite** é o controle ideal para o HP Elite c1030, oferecendo conexão sem fio tanto pelo **Dongle USB 2.4 GHz de baixa latência** quanto por **Bluetooth**.

#### ⚡ Usando o Dongle USB 2.4 GHz (Modo XInput - LED Verde) no xCloud / Google Chrome:
Para quem joga no **Xbox Cloud Gaming (xCloud)** e busca a menor latência possível sem depender de Bluetooth:
1. **O Cenário:** O dongle do GameSir opera em modo XInput padrão de fábrica (`Home + X`, LED verde). Navegadores baseados em Chromium no macOS necessitam de uma ponte/driver para mapear dispositivos XInput via USB.
2. **Como ter GameSir com Dongle E Netflix funcionando ao mesmo tempo:**
   * **Cenário A (Prático e Imediato):** Com o perfil de bypass da EFI (`amfi_get_out_of_my_way=1`), você joga no **Google Chrome com o Dongle USB 2.4 GHz** com resposta imediata. Para assistir à **Netflix**, basta abrir o **Safari**! O Safari não depende do módulo Widevine do Chrome; ele utiliza o decodificador nativo da Apple por hardware (**Apple FairPlay** acelerado pela Intel UHD 630 com `unfairgva=1`), reproduzindo em **1080p Full HD** sem nenhum conflito!
   * **Cenário B (Tudo no Google Chrome com Assinatura Ad-Hoc):** Se você prefere assistir à Netflix dentro do Chrome, mantenha a EFI Padrão v1.1.2 e utilize o utilitário **`setup_gamesir_dongle.command`** da pasta `tools/gamesir_nova_lite/`. O script assina a ponte de controle localmente (`codesign --force --deep --sign -`), fazendo o macOS confiar no programa com o AMFI ativo!
   * **Cenário C (Alternador de Perfis de EFI no Windows):** Incluímos o script **`ALTERNAR_EFI.bat`** para quem usa dual-boot com Windows poder alternar entre o perfil Padrão e o perfil XInput com apenas 1 clique.
3. 👉 **[Acesse o Pacote de Ferramentas e Instruções do GameSir](tools/gamesir_nova_lite/README.md)** na pasta `tools/gamesir_nova_lite/`.

#### 📱 Modo Bluetooth Nativo (Alternativa sem Dongle):
* Ligue o controle em modo Nintendo Switch (`Home + B` ou `Home + Y`) ou Xbox Wireless Controller e emparelhe via Bluetooth. O macOS reconhece pelo framework Apple Game Controller (`GCController`) nativamente.

### 6. 🖥️ Escala HiDPI Nativa para a Tela 3:2 (1920×1280 IPS 13.5")
A tela do HP Elite c1030 é um painel IPS de 13.5 polegadas com resolução nativa de **1920 × 1280 (proporção 3:2)**.
Por padrão, o macOS só exibe os botões de escala (como nos MacBooks Retina de fábrica) para monitores oficiais da Apple ou painéis 4K/5K. Em telas de terceiros de densidade padrão, o macOS esconde o seletor de escala, deixando tudo pequeno em 100% ou completamente borrado se você escolher uma resolução mais baixa comum.

Com o utilitário customizado na pasta **`tools/hidpi`**:
* **Resoluções HiDPI 3:2 Reais:** Injetamos um arquivo DisplayOverride sob medida (`VendorID 0x30e4`, `ProductID 0x0663`) com modos matematicamente perfeitos na proporção 3:2.
* **Escala de 125% Retina (1536 × 1024):** O sistema renderiza a interface internamente em **3072 × 2048** com vetores ultra nítidos e faz o downsampling para os 1920×1280 físicos da tela. Os elementos ficam no tamanho perfeito para os olhos (idêntico aos 125% do Windows), com **100% da nitidez de um MacBook Retina original**.
* **Sem perda de resolução:** O sinal da GPU continua em 1920×1280 a 60Hz cravados para o monitor físico.
* 👉 **[Acesse o Pacote de Ferramentas e Instruções de HiDPI](tools/hidpi/README.md)** na pasta `tools/hidpi/`.

---

## 📖 Como Usar a EFI

### Opção 1: Baixar a Release Pronta (Recomendado)
1. Vá na aba **[Releases](https://github.com/nepotira/HP-Elite-c1030-Hackintosh/releases/latest)** e baixe o arquivo **`EFI-HP-Elite-c1030-v1.1.3.zip`**.
2. Extraia o arquivo zip.
3. Copie a pasta `EFI` para a partição EFI (FAT32) do seu SSD ou pendrive bootável.

### Opção 2: Clonar o Repositório via Git
```bash
git clone https://github.com/nepotira/HP-Elite-c1030-Hackintosh.git
```
Copie a pasta `EFI` do repositório para a partição EFI (FAT32).

---

### 🛠️ Pós-Instalação Obrigatória (Primeiros Passos no macOS)

Assim que o macOS inicializar pela primeira vez usando a EFI, execute estas etapas essenciais:

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

4. **Definir o macOS como Inicialização Padrão no Boot:**
   Na tela do OpenCore, selecione o **macOS** (com a setinha para a direita), segure a tecla **`Ctrl`** e aperte **`Enter`**. O OpenCore grava a preferência na NVRAM, fazendo o computador acordar sempre no macOS por padrão.

5. **Ativar a Escala HiDPI Nativa da Tela 3:2 (125% Retina sem Borrão):**
   Para deixar textos, janelas e ícones no tamanho ideal sem perder um único pingo de nitidez:
   ```bash
   cd tools/hidpi
   sudo ./ativar_hidpi_3x2.sh
   ```
   Reinicie o notebook. Nos *Ajustes do Sistema -> Telas* (ou no BetterDisplay), selecione o modo **1536 × 1024 (HiDPI)**!


## ⌨️ Mapeamento de Teclas do Chromebook

Como o layout de teclado físico do Chromebook HP Elite c1030 difere do teclado padrão da Apple, aplicamos o mapeamento inteligente via **`SSDT-ChromebookKeys.aml`**:

### Linha Superior de Funções (Top Row):
* **F1:** Voltar no histórico do navegador / sistema
* **F2:** Avançar no histórico do navegador
* **F3:** Recarregar página atual (Refresh)
* **F4:** Alternar modo Tela Cheia (Fullscreen)
* **F5:** Visão Geral / Mission Control
* **F6:** Diminuir Brilho da Tela
* **F7:** Aumentar Brilho da Tela
* **F8:** Mudo
* **F9:** Diminuir Volume
* **F10:** Aumentar Volume

### 🔄 Inversão Command / Option:
* O patch ACPI já define `Swap command and option = y` para que a tecla física ao lado da barra de espaço atue como **Command (`⌘`)**, mantendo a ergonomia natural do macOS para atalhos (`Cmd+C`, `Cmd+V`, etc.).

> [!NOTE]
> **Sobre a Iluminação do Teclado (Backlight):** Embora o hardware do teclado do HP Elite c1030 tenha LEDs de iluminação, o controle de intensidade é gerenciado exclusivamente pelo firmware do chip **ChromeOS EC (Embedded Controller)** via barramento proprietário. Como não existe um driver de teclado ChromeOS EC para macOS, os LEDs não acendem e não há ajuste de brilho do teclado no macOS.

---

## 📦 Arquivos para Download (Release v1.1.3 Oficial)

Todos os arquivos necessários para rodar o macOS com 100% dos recursos configurados estão disponíveis diretamente na página de **[Releases](https://github.com/nepotira/HP-Elite-c1030-Hackintosh/releases/tag/v1.1.3)**:

| Arquivo | Tamanho | Descrição | Download Direto |
| :--- | :---: | :--- | :---: |
| **`EFI-HP-Elite-c1030-v1.1.3.zip`** | 68.9 MB | Pasta EFI completa (`BOOT` + `OC`) pronta para copiar na partição EFI | [Baixar EFI](https://github.com/nepotira/HP-Elite-c1030-Hackintosh/releases/download/v1.1.3/EFI-HP-Elite-c1030-v1.1.3.zip) |
| **`HiDPI-3x2-HP-Elite-c1030.zip`** | 269 KB | Pacote de injeção de resoluções HiDPI (Retina) sob medida para a tela 3:2 (125%, 1536×1024) | [Baixar Pacote HiDPI 3:2](https://github.com/nepotira/HP-Elite-c1030-Hackintosh/releases/download/v1.1.3/HiDPI-3x2-HP-Elite-c1030.zip) |
| **`Audio-Boost-HP-Elite-c1030.zip`** | 13.9 KB | Instalador do driver de áudio HAL com 100% de volume alto nativo | [Baixar Audio Boost](https://github.com/nepotira/HP-Elite-c1030-Hackintosh/releases/download/v1.1.3/Audio-Boost-HP-Elite-c1030.zip) |
| **`GameSir-Nova-Lite-Mac-Tool.zip`** | 28.7 KB | Utilitários, scripts de assinatura Ad-Hoc e alternador de perfil EFI para Dongle USB 2.4 GHz | [Baixar Ferramentas GameSir](https://github.com/nepotira/HP-Elite-c1030-Hackintosh/releases/download/v1.1.3/GameSir-Nova-Lite-Mac-Tool.zip) |
| **`HeliPort.dmg`** | 8.2 MB | Aplicativo oficial para gerenciamento e conexão do Wi-Fi Intel | [Baixar HeliPort](https://github.com/nepotira/HP-Elite-c1030-Hackintosh/releases/download/v1.1.3/HeliPort.dmg) |


---

## ⚠️ Gerando seus próprios números de série (SMBIOS)

Por motivos de segurança e para o correto funcionamento dos serviços da Apple (iMessage, FaceTime, iCloud), gere seu próprio número de série antes de logar na sua conta Apple:
1. Baixe o [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS).
2. Escolha o modelo **MacBookPro16,2**.
3. Substitua `MLB`, `SystemSerialNumber` e `SystemUUID` na seção `PlatformInfo -> Generic` do seu `config.plist`.

---

## 📜 Licença, Isenção de Responsabilidade e Linhagem (Fork)

Este projeto é distribuído sob a **[Licença MIT](LICENSE)**.

### 📌 Origem e Linhagem do Projeto (Fork / Derivação):
* **Repositório Base:** Este projeto é uma evolução direta do repositório pioneiro **[starsnwind/HP-Elite-C1030---x360-13c-Chromebook-Hackintosh](https://github.com/starsnwind/HP-Elite-C1030---x360-13c-Chromebook-Hackintosh)**.
* **Base do Update macOS Tahoe:** A atualização inicial da EFI para suportar o macOS 26 Tahoe e o uso do driver `CmlSOFAudio` foram disponibilizadas publicamente pelo colaborador **Bantryred** através do Google Drive na [Issue #7 do repositório original](https://github.com/starsnwind/HP-Elite-C1030---x360-13c-Chromebook-Hackintosh/issues/7).
* **Desenvolvimento e Refinamentos (nepotira):**
  - Engenharia reversa e criação do ganho nativo de volume 100% no HAL (`audio_boost`).
  - Calibração de desempenho agressivo via `CPUFriend` (EPP `0x40`).
  - Otimização do framebuffer de vídeo da Intel UHD 630 e correção de congelamento nas portas USB-C com monitores externos.
  - Correção de decodificação de vídeo (remoção do deadlock de `forceRenderStandby`).
  - Remoção do bloqueio de AMFI para restauração das permissões de microfone/câmera e DRM Widevine.
  - Engenharia e injeção do pacote de resoluções HiDPI nativas 3:2 para o painel IPS 13.5" (1920×1280), adaptando a estrutura do projeto open-source `xzhih/one-key-hidpi` para o formato 3:2 e macOS 26 Tahoe / Sequoia.
  - Criação da documentação completa, scripts automatizados e guias de migração.

### ⚖️ Disclaimer Legal:
macOS, OS X, Apple, MacBook Pro e suas respectivas marcas são propriedades exclusivas da Apple Inc. Este projeto não possui vínculos comerciais, patrocínio ou endosso da Apple Inc. O conteúdo é estritamente educacional, experimental e voltado para computação pessoal. Os componentes de terceiros (OpenCore, kexts) mantêm seus direitos e licenças originais sob custódia de seus respectivos mantenedores.

---

## 🤝 Créditos e Agradecimentos Especiais

Este projeto é fruto da pesquisa e cooperação ativa da comunidade Hackintosh e ChromeOS. Agradecimentos especiais a:

* **[starsnwind](https://github.com/starsnwind/HP-Elite-C1030---x360-13c-Chromebook-Hackintosh):** Autor do repositório base original para o HP Elite c1030 (Jinlon), pioneiro na criação dos SSDTs de teclado, trackpad e estrutura de ACPI.
* **Bantryred:** O grande amigo e colaborador que na Issue #7 do repositório do starsnwind descobriu o caminho para rodar o macOS Tahoe, compartilhou sua pasta EFI pelo Google Drive e encontrou o driver `CmlSOFAudio` para toda a comunidade!
* **[DexterSLamb](https://github.com/DexterSLamb/CmlSOFAudio):** Pelo desenvolvimento revolucionário do driver `CmlSOFAudio` (Sound Open Firmware) para o chipset Comet Lake cAVS no HP c1030.
* **[xzhih (one-key-hidpi)](https://github.com/xzhih/one-key-hidpi):** Pelo projeto pioneiro e utilitário open-source `one-key-hidpi` (Licença MIT), cuja metodologia de injeção de Display Overrides serviu como base para a criação da nossa solução customizada e adaptada para painéis 3:2 (1920×1280).
* **[JeoJay127](https://github.com/JeoJay127/OCLP-X):** Pelo projeto e patches do OCLP-X.
* **[OpenIntelWireless](https://github.com/OpenIntelWireless):** Pelos drivers `itlwm`, `IntelBluetoothFirmware` e o aplicativo `HeliPort`.
* **[LinearMouse Team](https://github.com/linearmouse/linearmouse):** Pelo utilitário open-source essencial para mouse no macOS.
* **[Acidanthera](https://github.com/acidanthera):** Pelo OpenCore Bootloader, Lilu, WhateverGreen, VirtualSMC, VoodooInput e AppleALC.
* **[MrChromebox](https://mrchromebox.tech/):** Pelo firmware UEFI Coreboot Full ROM que torna a instalação de sistemas operacionais padrão possível nos Chromebooks.
* **[VoodooI2C Team](https://github.com/VoodooI2C/VoodooI2C):** Pelo suporte aos gestos do trackpad multitoque.
* **[CoolStar](https://coolstar.org/):** Pelos trabalhos fundamentais de drivers para Chromebooks.

