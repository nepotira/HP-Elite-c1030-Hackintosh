# Changelog

Todas as alterações notáveis neste projeto serão documentadas neste arquivo.

O formato baseia-se em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/) e este projeto adere ao [Semantic Versioning (SemVer 2.0.0)](https://semver.org/lang/pt-BR/).  
Consulte [`docs/REGRAS_DE_VERSIONAMENTO.md`](docs/REGRAS_DE_VERSIONAMENTO.md) para as regras de governança e fluxo de commits.

---

## [v1.3.3] - 2026-10-14

### Revertido / Corrigido
- **`ERR-PWR-01` (Queda severa de desempenho e lentidão geral no macOS):**
  - **Sintoma Relatado:** Desempenho geral do sistema ficou severamente comprometido, lento e engasgado após o boot da `v1.3.2`.
  - **Causa Raiz Técnica:** A ativação de `forceRenderStandby=0` impediu a GPU integrada Intel UHD 630 de entrar no modo de baixo consumo RC6 (Render Standby). No processador Intel Comet Lake móvel (TDP nominal de 15W compartilhado entre CPU e GPU), manter a GPU constantemente energizada esgotou o orçamento térmico do pacote (*package power limit*), provocando estrangulamento (*throttling*) severo de clock da CPU. Além disso, o patch `igfxrpsc=1` travou o escalonamento dinâmico de estados de performance.
  - **Correção:** Reversão imediata dos parâmetros de CPU/GPU nos `boot-args`, removendo `forceRenderStandby=0` e `igfxrpsc=1` e restaurando a configuração estável de desempenho nativo em `EFI/OC/config.plist` e na partição ativa `Y:\EFI\OC\config.plist`.

---

## [v1.3.2] - 2026-10-14

### Corrigido
- **`ERR-VID-01` (Vídeos travando/não iniciando nos navegadores e reprodutores):**
  - **Causa Raiz:** O argumento `forceRenderStandby=0` havia sido removido anteriormente, fazendo com que a Intel UHD 630 entrasse em suspensão profunda RC6 durante a troca de quadros do decodificador de hardware (`VTDecoderXPCService`), ocasionando *ring timeout* do motor de vídeo. Além disso, o argumento `unfairgva=1` (projetado exclusivamente para GPUs dedicadas AMD) causava falha de inicialização no pipeline de DRM/mídia em laptops somente com iGPU Intel.
  - **Correção:** Restauração de `forceRenderStandby=0`, adição de `igfxrpsc=1` (patch de controle de estado de performance da GPU no WhateverGreen) e remoção do `unfairgva=1` em `EFI/OC/config.plist` e na partição ativa `Y:\EFI\OC\config.plist`.
- **`ERR-AUD-01` (Áudio picotando/repicado em loop contínuo):**
  - **Causa Raiz:** No driver HAL `CmlSOFAudioPlugin`, o ponteiro de leitura do DMA de hardware (DPIB) persegue o ponteiro de escrita de software (SPIB) em um ring buffer de 16.384 quadros (~341ms). Quando a GPU entrava em estados RC6 de alta latência, a thread de tempo real do `coreaudiod` perdia seu prazo de agendamento (*scheduling deadline*), fazendo com que o ponteiro de hardware ultrapassasse o de escrita e reproduzisse repetidamente o mesmo bloco anterior de amostras (loop tipo "metralhadora/repicado").
  - **Correção (Sem diminuir volume total):** A eliminação das pausas de RC6 da iGPU garantiu a pontualidade do agendamento do CoreAudio. Foi criado o utilitário de otimização `tools/audio/otimizar_audio.sh` para limpar caches de calibração corrompidos do daemon de áudio (`/Library/Preferences/Audio/`), forçar o alinhamento da taxa de amostragem em 48.000 Hz nativos do DSP Intel Comet Lake e reiniciar o `coreaudiod` sem perda de ganho sonoro.

### Adicionado
- **Manual de Governança SemVer:** Criação de [`docs/REGRAS_DE_VERSIONAMENTO.md`](docs/REGRAS_DE_VERSIONAMENTO.md) estabelecendo critérios obrigatórios de versionamento SemVer 2.0.0, Conventional Commits e protocolo de Error Tracking para agentes de IA e mantenedores.
- **Utilitário de Recuperação de Áudio:** Adicionado script [`tools/audio/otimizar_audio.sh`](tools/audio/otimizar_audio.sh) para flush de buffers e alinhamento de clock do CoreAudio.

---

## [v1.3.1] - 2026-10-14

### Corrigido
- **`ERR-DISP-01` (Congelamento do sistema no hotplug de monitor USB-C DisplayPort):**
  - Remoção de flags conflitantes de inicialização (`igfxonln=1`, `igfxagdc=0` e `disable-agdc`) que forçavam todos os conectores online simultaneamente e desativavam o controlador de portas da Apple, resultando em corrida de buffers no conector Tipo-C e travamento do macOS.

### Alterado
- **Status do Monitor Externo:** Atualizado o status na documentação para *Em Testes / Instável*, com detalhamento técnico das diferenças de estabilidade entre as portas USB-C esquerda e direita do chassi Jinlon.

---

## [v1.3.0] - 2026-10-13

### Adicionado
- **Escala Nativa HiDPI 3:2:** Criação da pasta [`tools/hidpi/`](tools/hidpi/) com perfis de resolução customizados para a proporção 3:2 (1920×1280), permitindo escala Retina nítida a 125% (1536×1024) sem distorção geométrica.
- Script automatizado de instalação do override de display em `/Library/Displays/Contents/Resources/Overrides/`.

---

## [v1.2.2] - 2026-10-13

### Corrigido
- **`ERR-KBD-01` (Iluminação do teclado / Backlight):**
  - Esclarecido na documentação que o controle de iluminação do teclado no HP Elite c1030 é gerenciado exclusivamente pelo Embedded Controller (EC) do firmware ChromeOS (Google Jinlon), não expondo interface ACPI padrão controlável pelo macOS. O status foi devidamente registrado como limitação de hardware.

---

## [v1.2.1] - 2026-10-13

### Adicionado
- Ativação do parâmetro `PollAppleHotKeys=true` no OpenCore para permitir a seleção de disco de inicialização padrão pelo atalho `Ctrl + Enter` no menu de boot.

---

## [v1.2.0] - 2026-10-12

### Adicionado
- **Pacote GameSir Nova Lite Dongle 2.4 GHz:** Inclusão de driver XInput modificado, script de assinatura ad-hoc local (`setup_gamesir_dongle.command`) e alternador de perfil de EFI para dual-boot Windows/macOS (`ALTERNAR_EFI.bat`).
- Documentação completa de uso de controles sem fio no Chrome e Safari.

---

## [v1.1.2] - 2026-10-11

### Alterado
- Ajuste de versionamento e sincronização da tabela de downloads e releases.

---

## [v1.1.1] - 2026-10-11

### Adicionado
- Guia estruturado passo a passo do zero ao macOS: [`docs/GUIA_DO_ZERO_AO_MACOS.md`](docs/GUIA_DO_ZERO_AO_MACOS.md), cobrindo desbloqueio Coreboot, particionamento Tiny11 e OpenCore.
- Manual de dicas de migração e produtividade: [`docs/DICAS_MIGRACAO_WINDOWS.md`](docs/DICAS_MIGRACAO_WINDOWS.md).

---

## [v1.1.0] - 2026-10-10

### Adicionado
- Licença oficial MIT ao repositório.
- Integração do `AMFIPass.kext` com boot-arg `-amfipassbeta` para restaurar o subsistema de permissões TCC (câmera, microfone e gravação de tela) mantendo o AMFI habilitado.

### Alterado
- Remoção do argumento de desenvolvimento `amfi=0x80`.

---

## [v1.0.0] - 2026-09-15

### Adicionado
- **Lançamento Inicial da EFI Oficial do HP Elite c1030 Chromebook (Jinlon):**
  - OpenCore 1.0.1 configurado com SMBIOS `MacBookPro16,2` / `MacBookPro16,4`.
  - Aceleração gráfica completa para Intel UHD Graphics 630 (Comet Lake 10th Gen).
  - Gerenciamento nativo de energia da CPU com CPUFriend e perfil EPP 0x40.
  - Áudio integrado via kext experimental `CmlSOFAudio` e driver HAL.
  - Suporte completo a Touchpad I2C com gestos multitoque e caneta ativa (USI Stylus).
  - Wi-Fi Intel AX201 via `itlwm` e gerenciador `HeliPort`.
  - Suporte a suspensão nativa (Sleep/Wake).

---

## Tabela Geral de Rastreamento de Erros (Error Tracking)

| ID do Erro | Subsistema | Sintoma Relatado | Causa Raiz Técnica | Status | Versão Origem | Versão Correção |
| :--- | :---: | :--- | :--- | :---: | :---: | :---: |
| **`ERR-PWR-01`** | Desempenho / Energia | Queda severa de desempenho e lentidão geral no sistema. | `forceRenderStandby=0` saturava o TDP de 15W do pacote da CPU e `igfxrpsc=1` causava throttling severo de clock. | **Resolvido via Reversão** | `v1.3.2` | `v1.3.3` |
| **`ERR-VID-01`** | Vídeo / Mídia | Vídeos em navegadores e players congelam no início ou param do nada. | Suspensão RC6 da iGPU em `VTDecoderXPCService` devido à ausência de `forceRenderStandby=0`, somada a flag DRM incompatível `unfairgva=1`. | **Resolvido** | `v1.1.0` | `v1.3.2` |
| **`ERR-AUD-01`** | Áudio | Som picotando/flickando como repicado contínuo sem parar. | Stalls de agendamento na thread do `coreaudiod` causados pela latência de RC6 da iGPU, gerando *buffer underrun* e looping de leitura DMA no ring buffer de 16384 frames. | **Resolvido** | `v1.1.0` | `v1.3.2` |
| **`ERR-DISP-01`** | Display / Hotplug | Kernel panic ou congelamento de tela ao plugar monitor USB-C. | Conflito de framebuffer com `igfxonln=1` e supressão de controle nativo do Apple Graphics Device Control (`igfxagdc=0`). | **Mitigado / Em Testes** | `v1.0.0` | `v1.3.1` |
| **`ERR-KBD-01`** | Teclado | Luz de fundo do teclado (backlight) não acende nem altera via atalhos no macOS. | Hardware do ChromeOS Jinlon gerencia os LEDs do teclado diretamente pelo chip EC privado, sem tabela ACPI compatível com macOS. | **Limitação de Hardware** | `v1.0.0` | `v1.2.2` |
| **`ERR-BOOT-01`** | Bootloader | Disco padrão de inicialização não memorizava sem atalhos nativos. | `PollAppleHotKeys` estava desativado no `config.plist`. | **Resolvido** | `v1.0.0` | `v1.2.1` |
