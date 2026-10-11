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
* **Release Publicada:** v1.2.0 com `EFI-HP-Elite-c1030-v1.2.0.zip`, `Audio-Boost-HP-Elite-c1030.zip`, `GameSir-Nova-Lite-Mac-Tool.zip` e `HeliPort.dmg`.

---

### 🔊 2. Arquitetura de Áudio & Status Atual Confirmado
* **Controlador de Som:** Intel Comet Lake PCH-LP cAVS / DSP (Sound Open Firmware - SOF, PCI `0x02c88086`). O notebook **NÃO possui codec analógico High Definition Audio (HDA) Realtek tradicional**; todo o áudio é processado digitalmente pelo DSP.
* **Driver do Kernel:** `CmlSOFAudio.kext` (v1.1.5 por DexterSLamb), ativo no OpenCore (`Kernel -> Add`).
* **Driver de Espaço do Usuário (HAL):** `CmlSOFAudioPlugin.driver` em `/Library/Audio/Plug-Ins/HAL/`.
* **Alto-falantes & Fones:** Funcionando. Na pasta `audio_boost/` do repositório, disponibilizamos o instalador `instalar_audio_boost.sh` com o multiplicador de ganho alterado para `1.0f` (volume alto nativo de 100%).
* **Microfone Interno (DMIC):** 100% Funcional (matriz DMIC de 4 canais via pipeline 3 do DSP).
* **WhatsApp Desktop & TCC:** **RESOLVIDO na v1.1.0!** A causa do bloqueio anterior era a antiga flag `amfi=0x80`. Com a migração para o `AMFIPass.kext` e o boot-arg `-amfipassbeta`, todos os pop-ups nativos de autorização de microfone e câmera funcionam perfeitamente.
* **Reprodução de Vídeos & Netflix:** **RESOLVIDO na v1.1.0!** Destravado com a remoção de `forceRenderStandby=0` e DRM Widevine no Chrome com AMFIPass, além do Apple FairPlay nativo 1080p no Safari.

---

### 🎮 3. Foco Atual: Suporte ao Controle GameSir Nova Lite com Dongle USB 2.4 GHz (xCloud)

O usuário utiliza o controle **GameSir Nova Lite** com o **Dongle USB 2.4 GHz em modo XInput (LED Verde)** para jogar no **Xbox Cloud Gaming (xCloud)** via Google Chrome com a menor latência possível:

#### 💡 Soluções Implementadas no Repositório (`tools/gamesir_nova_lite/`):

1. **Como manter o GameSir com Dongle E a Netflix funcionando ao mesmo tempo:**
   * **Cenário A (Prático e Imediato):** 
     - Se estiver usando o perfil de EFI com `amfi_get_out_of_my_way=1` (para que a bridge de XInput do dongle rode no Chrome), a Netflix toca em **1080p Full HD no Safari**!
     - *Explicação técnica:* O Safari não usa o plugin Widevine do Chrome; ele utiliza o decodificador nativo da Apple por hardware (**Apple FairPlay** acelerado pela GPU Intel UHD 630 via `unfairgva=1`). No Safari, a Netflix toca sem qualquer limitação.
   * **Cenário B (Tudo dentro do Google Chrome):**
     - Mantenha a EFI Padrão v1.1.0 (com AMFI ativo).
     - Execute o script `setup_gamesir_dongle.command` na pasta `tools/gamesir_nova_lite/`.
     - Aplique a assinatura local Ad-Hoc no binário ou aplicativo da bridge de controle:
       ```bash
       sudo xattr -cr "/caminho/do/programa_ou_daemon"
       sudo codesign --force --deep --sign - "/caminho/do/programa_ou_daemon"
       ```
     - O macOS confia na execução do programa com AMFI ativo, permitindo o controle no Chrome e a validação do Widevine da Netflix no Chrome!

2. **Ferramenta de Alternância de Perfis de EFI (`ALTERNAR_EFI.bat`):**
   - Disponível na pasta `tools/gamesir_nova_lite/` e na Área de Trabalho do Windows para alternar entre os perfis com 1 clique se o usuário estiver em dual-boot.

---

### 🛠️ 4. Ações Recomendadas para o Antigravity executar no macOS:

1. **Validar Áudio Alto Nativo:**
   * Garantir que o script `sudo ./instalar_audio_boost.sh` da pasta `audio_boost` foi executado.
2. **Auxiliar na Configuração do GameSir Nova Lite:**
   * Caso o usuário queira rodar a ponte do dongle XInput com AMFI ativo para manter o Chrome 100% validado para Netflix, executar o `setup_gamesir_dongle.command` e assinar o binário localmente via Ad-Hoc.
3. **Verificar Conexão Wi-Fi com HeliPort:**
   * Garantir que o `HeliPort.app` está em `/Applications` e adicionado aos Itens de Início em `Ajustes do Sistema -> Geral -> Itens de Início`.

---
*Fim do briefing de transição. Antigravity, o sistema está estável, rápido e com hardware calibrado na versão v1.1.0.*
