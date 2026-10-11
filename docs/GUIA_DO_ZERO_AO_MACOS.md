# 🧭 Guia Definitivo: Do ChromeOS ao macOS no HP Elite c1030 (Passo a Passo do Zero)

Este guia foi elaborado para qualquer pessoa que acabou de comprar ou adquirir um **HP Elite c1030 Chromebook (x360 13c / Jinlon)** e deseja transformar esse hardware incrível em uma máquina funcional com **macOS (Hackintosh)**, além de permitir dual-boot limpo com **Windows 11** e **Linux**.

---

## ⚠️ AVISO LEGAL E ISENÇÃO TOTAL DE RESPONSABILIDADE

> [!CAUTION]
> **LEIA COM ATENÇÃO ANTES DE QUALQUER PROCEDIMENTO:**
> 
> * **NÃO ME RESPONSABILIZO POR QUAISQUER DANOS, PERDA DE DADOS, BRICK DO DISPOSITIVO OU PROBLEMAS DE QUALQUER NATUREZA EM SEU COMPUTADOR!**
> * As informações a seguir **NÃO são recomendações de fábrica**, mas sim instruções técnicas, tutoriais e relatos práticos da experiência bem-sucedida que desenvolvemos neste projeto.
> * Você é o único e total responsável por seguir estas instruções por sua **própria conta e risco**.
> * Modificar a BIOS de um Chromebook e instalar sistemas operacionais não homologados requer atenção mecânica e lógica. Tenha certeza de que tem backups de quaisquer dados importantes antes de iniciar.

---

## 🤖 Dica Crucial sobre o uso de Inteligência Artificial (Antigravity)

Neste projeto, utilizamos a ferramenta de assistência de código e terminal **Antigravity** para automatizar diagnósticos, montar partições ocultas e calibrar arquivos de sistema. Se você decidir usar IA para manipular sua partição EFI e instalar o sistema:

1. **A escolha de usar IA para modificar arquivos de inicialização e partições é totalmente sua.** Lembre-se de que a IA executa comandos no seu sistema; você deve sempre acompanhar o que está sendo executado.
2. **Execute o Antigravity como Administrador no Windows:** Para que a IA consiga acessar o disco físico, executar o `diskpart` ou montar partições protegidas (`mountvol Y: /S`), o executável do Antigravity **deve ser iniciado com "Executar como Administrador"**. Instrua a IA logo na primeira mensagem avisando: *"Estou executando você com privilégios de Administrador, pode executar comandos de montagem de partição e cópia de arquivos diretamente."*
3. **Qual modelo de IA utilizar:**
   * **Recomendado:** Utilizamos os modelos **Gemini Flash mais recentes (3.5, depois 3.7 e atualmente 3.8) configurados no modo "High"**. O modelo Flash High é rápido, direto, entende os limites de hardware e lida com scripts de terminal sem alucinar.
   * **Não recomendado:** **NÃO usei o modelo Pro em nenhuma alteração e NÃO o recomendo para essa finalidade.** O modelo Pro tende a sugerir refatorações complexas e pesadas que fogem do escopo cirúrgico necessário para o OpenCore.

---

## 📚 Índice do Roteiro

1. [Etapa 1: Desbloqueando o Chromebook e Gravando a BIOS UEFI (Coreboot)](#-etapa-1-desbloqueando-o-chromebook-e-gravando-a-bios-uefi-coreboot)
2. [Etapa 2: A Estratégia do Windows Light (Tiny11) como Base](#-etapa-2-a-estratégia-do-windows-light-tiny11-como-base)
3. [Etapa 3: O que é o OpenCore e Como Funciona a Partição EFI?](#-etapa-3-o-que-é-o-opencore-e-como-funciona-a-partição-efi)
4. [Etapa 4: Configurando a EFI no SSD pelo Windows](#-etapa-4-configurando-a-efi-no-ssd-pelo-windows)
5. [Etapa 5: Criando o Pendrive de Instalação e Instalando o macOS](#-etapa-5-criando-o-pendrive-de-instalação-e-instalando-o-macos)
6. [Etapa 6: Pós-Instalação Obrigatória no macOS](#-etapa-6-pós-instalação-obrigatória-no-macos)

---

## 🛠️ Etapa 1: Desbloqueando o Chromebook e Gravando a BIOS UEFI (Coreboot)

De fábrica, os Chromebooks não possuem uma BIOS tradicional (PC UEFI). Eles rodam o firmware Depthcharge da Google, que só permite carregar o ChromeOS. Para rodar Windows, Linux ou macOS, precisamos substituir o firmware pelo **Coreboot Full ROM UEFI**.

* 🔗 **Tutorial e Script Oficial:** [MrChromebox.tech Firmware Utility Script](https://mrchromebox.tech/#fwscript)

### 1.1. Ativar o Modo Desenvolvedor (Developer Mode)
1. Com o notebook desligado, segure as teclas **`Esc` + `Refresh (F3)`** e pressione o botão **`Power`**.
2. A tela exibirá a mensagem de recuperação (*Recovery Mode*).
3. Pressione **`Ctrl + D`** no teclado.
4. Pressione **`Enter`** para confirmar a exclusão dos dados e a ativação do modo desenvolvedor. O Chromebook reiniciará e formatará o armazenamento interno (leva cerca de 2 a 5 minutos).
5. Ao ligar na tela de aviso *"OS verification is OFF"*, pressione **`Ctrl + D`** para entrar no ChromeOS.

### 1.2. Desativar a Proteção de Gravação de Hardware (Hardware Write Protect)
O chip de segurança **Titan C (CR50)** da placa-mãe impede a regravação da memória flash da BIOS. Para desativar a proteção de hardware no HP Elite c1030 (placa Jinlon):
1. Desligue o Chromebook.
2. Retire os parafusos da tampa inferior (Torx T5 / Phillips) e abra a carcaça traseira com uma espátula plástica.
3. **Desconecte o cabo da bateria da placa-mãe.**
4. Conecte o carregador USB-C original na tomada. *(Quando a bateria está fisicamente desconectada, o chip CR50 entra em modo de manutenção e desativa a proteção de gravação de hardware).*
5. Ligue o Chromebook pelo botão de ligar.

### 1.3. Executar o Script do MrChromebox
1. No ChromeOS, conecte-se ao Wi-Fi (pode entrar como Convidado / Guest).
2. Pressione **`Ctrl + Alt + F2`** (ou `Ctrl + Alt + Seta para frente`) para abrir o terminal preto (VT-2).
3. Faça login digitando o usuário: `chronos` (geralmente não pede senha).
4. Execute o comando oficial do MrChromebox:
   ```bash
   cd; curl -LO mrchromebox.tech/firmware-util.sh && sudo bash firmware-util.sh
   ```
5. O menu do utilitário será exibido no terminal.
6. Escolha a opção **`2) Install/Update UEFI (Full ROM) Firmware`**.
7. O script perguntará se você deseja fazer backup da ROM original do ChromeOS. **Conecte um pendrive FAT32 e confirme o backup (SIM)** para garantir que você possa reverter o notebook para ChromeOS de fábrica no futuro, se desejar.
8. Aguarde o download e a gravação da nova BIOS Coreboot (não desligue o aparelho enquanto grava).
9. Ao concluir, desligue o notebook, **reconecte a bateria na placa-mãe**, parafuse a tampa inferior e pronto!

> [!NOTE]
> Ao ligar o notebook agora, aparecerá o logo de inicialização do **MrChromebox (coelho)** com uma BIOS UEFI 100% moderna e compatível com pendrives de instalação de qualquer sistema!

---

## 🪟 Etapa 2: A Estratégia do Windows Light (Tiny11) como Base

Você pode instalar o macOS diretamente, mas a **estratégia que nós adotamos e recomendamos na prática** é instalar primeiro um Windows leve no notebook:

### Por que instalar um Windows leve primeiro?
* **Facilidade de Manutenção:** No Windows, você pode usar ferramentas gráficas como *Minitool Partition Wizard*, *Diskpart*, *Explorer++* e gerenciar o particionamento do SSD sem estresse.
* **Uso da IA Antigravity:** Permite que você abra o Antigravity com privilégios de Administrador no Windows para montar a partição EFI oculta (`Y:\EFI`), copiar arquivos da nossa Release v1.1.0 e conferir tudo antes de reiniciar.
* **Dual-Boot Permanente:** Você fica com um notebook híbrido, podendo alternar entre macOS e Windows sempre que precisar de algum aplicativo ou jogo específico.

### O que usamos: Tiny11
* Utilizamos a ISO do **Tiny11** (uma versão enxuta do Windows 11 sem bloatwares da Microsoft, consumindo menos de 2 GB de RAM e apenas 15 GB de espaço em disco).
* Crie o pendrive do Tiny11 usando ferramentas padrão como o [Rufus](https://rufus.ie/).

### Particionamento Sugerido no SSD (Western Digital SN520 128 GB):
1. **Partição 1 (EFI):** Formato **FAT32**, tamanho de **1 GB** (onde o OpenCore e o bootloader do Windows residem juntos).
2. **Partição 2 (Windows):** Formato **NTFS**, tamanho de **~50 GB**.
3. **Partição 3 (Espaço para o macOS):** Deixe cerca de **~65 GB a 70 GB** como "Espaço não alocado" (ou formate como ExFAT temporariamente; depois o instalador da Apple converterá em APFS).

---

## ⚙️ Etapa 3: O que é o OpenCore e Como Funciona a Partição EFI?

Muitos iniciantes se perguntam: *"O que é esse tal de OpenCore e onde ele fica?"*

* **O que é o OpenCore:** Ele é o **bootloader** (carregador de inicialização). A Apple projeta o macOS para rodar apenas na placa-mãe de computadores Mac originais. O OpenCore atua como um tradutor inteligente entre o hardware do seu Chromebook (Intel Comet Lake, Coreboot) e o sistema operacional da Apple.
* **Onde ele fica:** Ele reside dentro da pasta oculta **`EFI`** do seu disco.
* **Estrutura de pastas da EFI:**
  ```text
  EFI/
  ├── BOOT/
  │   └── BOOTX64.EFI        <- Ponto de entrada padrão da BIOS UEFI
  ├── OC/
  │   ├── OpenCore.efi       <- O cérebro do bootloader
  │   ├── config.plist       <- Arquivo mestre que comanda todos os ajustes
  │   ├── ACPI/              <- Arquivos SSDT que mapeiam teclas, trackpad e bateria
  │   ├── Kexts/             <- Drivers de hardware (áudio, rede, gráficos)
  │   └── Drivers/           <- Drivers UEFI de inicialização
  └── Microsoft/             <- Bootloader nativo do Windows 11 (para dual-boot)
  ```
* **Como funciona o boot:**
  Ao ligar o notebook, a BIOS Coreboot carrega o OpenCore. O OpenCore exibe uma tela bonita onde você escolhe entre **macOS** ou **Windows**. 
  * Se você escolhe **Windows**, ele passa o controle direto para o Windows, sem modificar nada.
  * Se você escolhe **macOS**, ele injeta os drivers da Intel UHD 630, o controle de áudio, o trackpad e sobe o sistema da Apple perfeitamente!

---

## 💻 Etapa 4: Configurando a EFI no SSD pelo Windows

Com o Windows instalado, configurar a EFI com o nosso pacote pronto leva menos de 2 minutos:

1. Baixe o arquivo **`EFI-HP-Elite-c1030-v1.1.0.zip`** na página de **[Releases deste Repositório](https://github.com/nepotira/HP-Elite-c1030-Hackintosh/releases/latest)**.
2. Extraia o arquivo `.zip` na sua Área de Trabalho.
3. Abra o **Prompt de Comando (CMD) ou PowerShell como Administrador** e monte a partição EFI oculta na letra `Y:`:
   ```cmd
   mountvol Y: /S
   ```
4. Copie as pastas **`BOOT`** e **`OC`** extraídas para dentro da pasta `Y:\EFI\`.
5. *(Opcional)* Se você estiver usando o **Antigravity como Administrador**, basta pedir para a IA: *"Monte minha partição EFI na letra Y: e copie a pasta EFI da release para lá"*. A IA fará a cópia e validará a ausência de caracteres invisíveis (BOM).

---

## 🍎 Etapa 5: Criando o Pendrive de Instalação e Instalando o macOS

### 5.1. Criar o Pendrive de Instalação do macOS
1. Você precisará de um pendrive de no mínimo 16 GB.
2. Baixe a imagem de instalação oficial do macOS (recomendamos **macOS 14 Sonoma**, **macOS 15 Sequoia** ou **macOS 26 Tahoe**).
3. Grave a imagem no pendrive usando o [balenaEtcher](https://etcher.balena.io/) ou criando via terminal se tiver acesso a outro Mac.
4. Monte a partição EFI do pendrive e copie a mesma pasta **`EFI`** deste repositório para ela.

### 5.2. A Instalação no Chromebook
1. Conecte o pendrive no HP Elite c1030.
2. Ligue o notebook e pressione **`F10`** (ou `Esc`) na tela do coelho do Coreboot para abrir o menu de boot.
3. Selecione o seu pendrive USB.
4. O menu do OpenCore aparecerá. Escolha **"Install macOS"**.
5. Quando o instalador carregar, abra o **Utilitário de Disco (Disk Utility)**.
6. Clique em *Visualizar -> Mostrar Todos os Dispositivos*.
7. Localize o espaço que você reservou no SSD interno e clique em **Apagar (Erase)**:
   * **Nome:** `Macintosh HD` (ou o nome que preferir).
   * **Formato:** `APFS`.
   * **Esquema:** `Mapa de Partição GUID`.
8. Feche o Utilitário de Disco e clique em **Instalar macOS**.
9. Selecione o disco recém-formatado e inicie a instalação.
10. O notebook reiniciará cerca de 3 a 4 vezes durante o processo. **Em todas as reinicializações, deixe ele entrar no OpenCore e selecione a opção "macOS Installer" (ou o nome do seu disco)** até a tela de boas-vindas do macOS aparecer.

---

## 🚀 Etapa 6: Pós-Instalação Obrigatória no macOS

Parabéns! Você chegou à área de trabalho do macOS no seu Chromebook. Para deixar a máquina 100% pronta para o uso diário:

1. **Volume Alto Nativo no Áudio (100% de Ganho):**
   * Baixe ou abra a pasta `audio_boost` deste repositório.
   * Abra o Terminal e rode:
     ```bash
     cd audio_boost
     sudo ./instalar_audio_boost.sh
     ```
   * O som do notebook ficará imediatamente encorpado e 4x mais alto!

2. **Ativar o Wi-Fi com o HeliPort:**
   * Instale o aplicativo **[HeliPort.dmg](https://github.com/OpenIntelWireless/HeliPort/releases)**.
   * Arraste para a pasta Aplicativos e abra. O ícone do Wi-Fi aparecerá ao lado do relógio. Conecte na sua rede e adicione o HeliPort em `Ajustes do Sistema -> Geral -> Itens de Início`.

3. **Dicas para quem vem do Windows:**
   * Instale o **LinearMouse** para ajustar a direção e aceleração do ponteiro.
   * Consulte o nosso **[Guia de Dicas de Migração do Windows](DICAS_MIGRACAO_WINDOWS.md)** para ter Snap de janelas e atalhos idênticos aos do PC.

Pronto! Agora você tem uma máquina premium x360 conversível rodando macOS liso, com som potente, tela incrível 3:2 e bateria de longa duração!
