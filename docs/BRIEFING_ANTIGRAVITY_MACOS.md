# 📋 BRIEFING DE TRANSIÇÃO E CONTINUIDADE PARA O ANTIGRAVITY (NO macOS)

> **Instrução para o usuário:** Copie todo o conteúdo abaixo e cole diretamente na primeira mensagem para o Antigravity quando você abrir o aplicativo dentro do macOS.

---

### 💻 1. Perfil do Hardware & Ambiente
* **Notebook:** HP Elite c1030 Chromebook (x360 13c, placa-mãe *Jinlon*)
* **Processador:** Intel Core i7-10610U (Comet Lake-U, 4 Cores / 8 Threads @ 1.80 GHz até 4.90 GHz)
* **Gráficos Integrados:** Intel UHD Graphics 630 (Device ID `0x9B41`, spoof `0x3EA5`, framebuffer calibrado em 9 MB `fbmem`, sem estouro de DVMT)
* **Memória RAM:** 16 GB LPDDR4 2667 MHz (Dual-Channel)
* **SSD:** Western Digital PC SN520 128 GB NVMe
* **Firmware:** Coreboot / MrChromebox Full ROM UEFI
* **Sistema Operacional:** macOS 15 / 26 (Tahoe / Sonoma)
* **Repositório Oficial do Projeto no GitHub:** [https://github.com/nepotira/HP-Elite-c1030-Hackintosh](https://github.com/nepotira/HP-Elite-c1030-Hackintosh)
* **Release Publicada:** v1.0.0 com `EFI-HP-Elite-c1030-v1.0.0.zip`, `Audio-Boost-HP-Elite-c1030.zip` e `HeliPort.dmg`.

---

### 🔊 2. Arquitetura de Áudio & Status Atual Confirmado
* **Controlador de Som:** Intel Comet Lake PCH-LP cAVS / DSP (Sound Open Firmware - SOF, PCI `0x02c88086`). O notebook **NÃO possui codec analógico High Definition Audio (HDA) Realtek tradicional**; todo o áudio é processado digitalmente pelo DSP.
* **Driver do Kernel:** `CmlSOFAudio.kext` (v1.1.5 por DexterSLamb), ativo no OpenCore (`Kernel -> Add`).
* **Driver de Espaço do Usuário (HAL):** `CmlSOFAudioPlugin.driver` em `/Library/Audio/Plug-Ins/HAL/`.
* **Alto-falantes & Fones:** Funcionando. Na pasta `audio_boost/` do repositório, corrigimos o binário do plugin HAL alterando o multiplicador de ganho de `0.25f` para `1.0f` (volume alto nativo de 100%).
* **Microfone Interno (DMIC):**
  * Hardware: Matriz DMIC de 4 canais conectada via PDM ao pipeline 3 do DSP.
  * **STATUS CONFIRMADO PELO USUÁRIO:** O microfone **ESTÁ FUNCIONANDO PERFEITAMENTE**! Foi testado com sucesso nos *Ajustes do Sistema -> Som -> Entrada* (com as barras de nível mexendo) e gravando áudio cristalino no aplicativo nativo **Gravador de Voz da Apple (Voice Memos)**.

---

### 🚨 3. O Problema Específico a Resolver Agora no macOS
O hardware do microfone está 100% funcional no sistema, mas **aplicativos de terceiros (especialmente o WhatsApp Desktop) não conseguem gravar áudio e NÃO aparecem na lista de permissão de microfone em *Ajustes do Sistema -> Privacidade e Segurança -> Microfone***:
1. Ao clicar no ícone de microfone dentro de uma conversa do WhatsApp Desktop para mandar mensagem de voz, o aplicativo não grava nada e **não dispara o pop-up nativo da Apple pedindo autorização**.
2. Foi executado o comando `tccutil reset Microphone` pelo Terminal, o que resetou com sucesso o banco de dados do TCC (a Steam que estava na lista sumiu, como esperado), mas o WhatsApp ainda assim não pediu permissão nem entrou na lista.
3. Além disso, os **Serviços de Localização (CoreLocation)** só funcionam por aproximação de IP, pois o driver Wi-Fi Intel `itlwm` emula uma conexão cabeada Ethernet e o daemon `locationd` da Apple não recebe escaneamento de BSSIDs Wi-Fi nativo.

---

### 🛠️ 4. Diagnósticos e Tarefas Prioritárias para o Antigravity executar no macOS:

#### Tarefa A: Diagnosticar o WhatsApp e o TCC (Microphone Permission)
1. **Identificar a versão exata do WhatsApp instalada:**
   * Verificar se é a versão da Mac App Store (Catalyst, Bundle ID `net.whatsapp.WhatsApp`) ou a versão Web/Electron baixada do site (`desktop.WhatsApp` ou `WhatsApp.app`).
   * Comando no Terminal:
     ```bash
     osascript -e 'id of app "WhatsApp"'
     ```
2. **Checar as configurações internas de entrada de áudio do WhatsApp:**
   * Abrir o WhatsApp -> Configurações (Settings) -> Áudio / Chamadas -> Dispositivo de Entrada de Áudio.
   * Verificar se o dispositivo selecionado é o "Microfone Interno" ou se está nulo/padrão incorreto.
3. **Forçar o handshake de permissão via Chamada de Voz:**
   * Testar iniciar uma **chamada de voz (ligação)** no WhatsApp para forçar o motor WebRTC do app a requisitar a API de hardware do macOS.
4. **Verificar logs do sistema ao tentar gravar:**
   * No Terminal do macOS:
     ```bash
     log stream --predicate 'process == "WhatsApp" or subsystem contains "tcc" or subsystem contains "audio"' --info
     ```
   * Clicar no microfone do WhatsApp e analisar exatamente qual erro ou exceção o WhatsApp ou o TCC disparam.
5. **Injeção ou liberação no banco de dados TCC (se necessário):**
   * Verificar o estado no banco de dados local do usuário em `~/Library/Application Support/com.apple.TCC/TCC.db`.
   * Testar abrir o WhatsApp direto pelo binário no Terminal:
     ```bash
     open /Applications/WhatsApp.app/Contents/MacOS/WhatsApp
     ```

#### Tarefa B: Garantir a Instalação do Áudio Alto Nativo (`audio_boost`)
Se ainda não foi executado no macOS, rodar o instalador da pasta `audio_boost`:
```bash
cd ~/Desktop/HP-Elite-c1030-Hackintosh/audio_boost
sudo ./instalar_audio_boost.sh
```

#### Tarefa C: Testar Atalhos do Teclado e Iluminação
* Testar os atalhos de iluminação do teclado identificados no repositório starsnwind: `F8 / F9` ou `Alt(Cmd) + F6 / F7` (desativando ajuste automático em Ajustes -> Teclado).

---
*Fim do briefing de transição. Antigravity, assuma o controle direto no terminal e ambiente do macOS para debugar e resolver o WhatsApp e o TCC.*
