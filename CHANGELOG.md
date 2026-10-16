# Changelog

Todas as alterações notáveis deste projeto são documentadas aqui.
Formato: [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/) · Versionamento: [SemVer 2.0.0](https://semver.org/lang/pt-BR/) · Regras: [`docs/REGRAS_DE_VERSIONAMENTO.md`](docs/REGRAS_DE_VERSIONAMENTO.md).
Contexto narrativo (por que cada coisa foi feita): [`docs/HISTORICO_DO_PROJETO.md`](docs/HISTORICO_DO_PROJETO.md).

> **Convenção de status:** um erro só é **Resolvido** quando o dono confirmou no hardware. Antes disso é **Aberto**, **Em investigação**, **Mitigado** ou **Limitação de hardware**. Hipóteses são rotuladas como tal.

---

## [v1.3.4] - 2026-10-16

### Alterado (somente documentação — a EFI é idêntica à v1.3.3)
- Auditoria completa da documentação: datas e conteúdos incorretos deste changelog corrigidos; hardware errado do README corrigido (i7-10610U, não i5); status de `ERR-VID-01` e `ERR-AUD-01` corrigidos de "Resolvido" para **Aberto** (a v1.3.2 não resolveu e foi revertida).
- Causa de `ERR-PWR-01` reclassificada como **hipótese**: a v1.0.0 (desempenho "impecável") já usava `forceRenderStandby=0`; o suspeito principal passa a ser `igfxrpsc=1`.

### Adicionado
- [`docs/HISTORICO_DO_PROJETO.md`](docs/HISTORICO_DO_PROJETO.md): cronologia completa do primeiro prompt até hoje (incl. tentativas que falharam e lições).
- [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md): sintoma → causa → solução, problemas abertos, coleta de diagnóstico, lista de `boot-args` (usar / não usar).
- [`docs/BRIEFING_ANTIGRAVITY_MACOS.md`](docs/BRIEFING_ANTIGRAVITY_MACOS.md) **reescrito** com o estado real e as regras do dono.
- [`AGENTS.md`](AGENTS.md) na raiz para orientar agentes de IA.
- Release **v1.3.4** publicada no GitHub com os arquivos anexados (o README da v1.3.3 apontava para uma release que não existia).

---

## [v1.3.3] - 2026-10-14

### Revertido
- **`ERR-PWR-01` (desempenho horrível após a v1.3.2):** `boot-args` restaurados **exatamente** ao estado da v1.3.1 — removidos `forceRenderStandby=0` e `igfxrpsc=1`, restaurado `unfairgva=1` — em `EFI/OC/config.plist` e na EFI viva (`Y:\EFI\OC\config.plist`).
  - **Status:** Mitigado por reversão. **Causa individual não isolada** (🔶 suspeito principal: `igfxrpsc=1`, ou interação com o HiDPI).

---

## [v1.3.2] - 2026-10-14 — ⚠️ tentativa fracassada (revertida na v1.3.3)

### Alterado
- `boot-args`: adicionados `forceRenderStandby=0` e `igfxrpsc=1`; removido `unfairgva=1`. Objetivo: corrigir `ERR-VID-01` e `ERR-AUD-01`.
- **Resultado:** o dono relatou desempenho "horrível". **Não** corrigiu vídeo nem áudio (não houve confirmação). Revertido na v1.3.3. **Não reaplicar.**

### Adicionado
- [`docs/REGRAS_DE_VERSIONAMENTO.md`](docs/REGRAS_DE_VERSIONAMENTO.md) (SemVer, Conventional Commits, rastreamento de erros).
- Este `CHANGELOG.md`.
- [`tools/audio/otimizar_audio.sh`](tools/audio/otimizar_audio.sh): reinicia o `coreaudiod` e limpa preferências de áudio. **Efeito sobre o "repicado" não foi validado.** Não altera ganho/volume.

---

## [v1.3.1] - 2026-10-13

### Corrigido / Alterado
- **`ERR-DISP-01`** (monitor USB-C): removidos `igfxonln=1`, `igfxagdc=0` e `disable-agdc` (commit `389782c`) para devolver o controle nativo do DisplayPort ao macOS. Tentativa `fbmem 48MB` + `cursormem` + `-igfxtypec` (`c499f6e`) foi **revertida** (`6626975`).
- Documentação: status do monitor externo passou a **Em testes / instável**, com diagnóstico técnico (porta esquerda com mau contato físico; porta direita estável mas ainda congela no macOS).

---

## [v1.3.0] - 2026-10-11

### Adicionado
- **Escala HiDPI 3:2** em [`tools/hidpi/`](tools/hidpi/): `ativar_hidpi_3x2.sh`, `desativar_hidpi.sh` e *DisplayOverride* (`VendorID 0x30e4`, `ProductID 0x0663`); modo recomendado 1536×1024 (HiDPI) na tela 1920×1280.
- 🔶 Suspeita de efeitos colaterais (flicker/ghosting, vídeo/áudio instáveis) — ver `docs/TROUBLESHOOTING.md#problemas-abertos`.

---

## [v1.2.2] - 2026-10-11

### Corrigido
- **`ERR-KBD-01`** (luz do teclado): a documentação afirmava, **incorretamente**, 6 níveis de brilho por atalhos (F8/F9, Alt+F6/F7). O backlight é controlado só pelo ChromeOS EC e **não funciona no macOS**. Status: **Limitação de hardware**.

---

## [v1.2.1] - 2026-10-11

### Adicionado
- `PollAppleHotKeys=true` no OpenCore + documentação: no menu, selecionar macOS e apertar **`Ctrl + Enter`** grava o macOS como boot padrão (`ERR-BOOT-01`).

---

## [v1.2.0] - 2026-10-11

### Adicionado
- Pacote do controle **GameSir Nova Lite com dongle 2.4 GHz** (XInput) em [`tools/gamesir_nova_lite/`](tools/gamesir_nova_lite/): ponte, `setup_gamesir_dongle.command` (assinatura ad-hoc), `ALTERNAR_EFI.bat` e perfis de EFI.

---

## [v1.1.2] - 2026-10-11

### Alterado
- Release com o pacote GameSir e tabela de downloads atualizada (`e3bb07e`).

---

## [v1.1.1] - 2026-10-11

### Adicionado
- [`docs/GUIA_DO_ZERO_AO_MACOS.md`](docs/GUIA_DO_ZERO_AO_MACOS.md) (Coreboot → Tiny11 → OpenCore → macOS).
- [`docs/DICAS_MIGRACAO_WINDOWS.md`](docs/DICAS_MIGRACAO_WINDOWS.md).

---

## [v1.1.0] - 2026-10-10

### Corrigido
- Permissões de **microfone/câmera (TCC)** e **Widevine**: `amfi=0x80` substituído por **`AMFIPass.kext` + `-amfipassbeta`**.

### Alterado
- `boot-args`: removido `forceRenderStandby=0`; adicionados `debug=0x100` e `unfairgva=1`.
- Licença **MIT**.
- ❌ Experimento `igfxfw=2` (GuC) **descartado**: trava o boot a ~40% (Coreboot sem canal Intel MEI). Ficou apenas na branch `teste-correcoes`.

---

## [v1.0.0] - 2026-10-04

### Adicionado
- Primeira EFI funcional do macOS **Tahoe** no HP Elite c1030 (base: starsnwind + Bantryred + DexterSLamb), com: aceleração gráfica UHD 630, `CPUFriend` com **EPP `0x40`**, trackpad I2C, teclas do Chromebook, Wi-Fi (`itlwm` + HeliPort), áudio SOF (`CmlSOFAudio`), `SSDT-NoTouch` + `-vi2c-force-polling` (touchscreen desligado de propósito), `NVMeFix`, e pacote `audio_boost` (ganho 25% → 100%).
- Documentação inicial, mapeamento de teclas e créditos. *(A tag aponta para `eb1a0a9`, um commit depois do inicial `83d35eb`.)*

---

## Notas sobre tags e releases legadas

- **`v1.1.3` (tag e release):** criada antes da regra SemVer; aponta para `d70ca8c`, o **mesmo commit** da `v1.3.0`. Seus arquivos (EFI inclusive) correspondem ao estado da v1.3.0, **anterior** à v1.3.1. Mantida só para não quebrar links antigos — prefira a release mais recente.
- **`v1.2.0` (`dfda498`)** é cronologicamente anterior ao commit da `v1.1.2` (`e3bb07e`); o número não acompanha a ordem do histórico. Mantido para não reescrever tags públicas.
- Releases com arquivos anexados: v1.0.0, v1.1.0, v1.1.2, v1.1.3 e **v1.3.4**. As demais tags (v1.1.1, v1.2.x, v1.3.0–v1.3.3) existem como marcos no Git, sem arquivos.

---

## Tabela Geral de Rastreamento de Erros

| ID | Subsistema | Sintoma | Causa (✅ confirmada / 🔶 hipótese) | Status | Origem | Correção |
| :--- | :--- | :--- | :--- | :---: | :---: | :---: |
| `ERR-VID-01` | Vídeo | Vídeos param do nada ou não iniciam | 🔶 HiDPI sobrecarregando a iGPU; 🔶 transições de energia da iGPU; 🔶 relógio do vídeo acoplado ao do CoreAudio | **Aberto** | `v1.1.0` (re-observado em out/2026) | — (tentativa v1.3.2 falhou) |
| `ERR-AUD-01` | Áudio | Som picotando/"repicado" | 🔶 Underrun no anel DMA de 16384 frames do `CmlSOFAudioPlugin` (DPIB alcança SPIB); gatilho não provado | **Aberto** | out/2026 | — |
| `ERR-PWR-01` | Desempenho | Lentidão forte após a v1.3.2 | 🔶 `igfxrpsc=1` (principal) e/ou `forceRenderStandby=0` combinados | **Mitigado por reversão** | `v1.3.2` | `v1.3.3` |
| `ERR-DISP-01` | Display | Monitor USB-C congela o macOS | 🔶 EC do Chromebook comuta DP Alt-Mode/PD sem driver Type-C no macOS; ✅ funciona no Windows; ✅ porta esquerda com mau contato físico | **Em testes / instável** | `v1.0.0` | parcial (`v1.3.1`) |
| `ERR-DISP-02` | Display | Flicker, ghosting e travamentos após ativar HiDPI/"Retina" | 🔶 Buffer HiDPI 3072×2048 / programa de terceiros | **Em investigação** | `v1.3.0` | — |
| `ERR-KBD-01` | Teclado | Luz de fundo não funciona | ✅ Controlada só pelo ChromeOS EC; sem driver no macOS | **Limitação de hardware** | `v1.0.0` | doc. corrigida `v1.2.2` |
| `ERR-TCH-01` | Touchscreen | Tocar na tela causa kernel panic | ✅ Interrupt storm GPIO no `VoodooI2CHID` (Coreboot) | **Contornado** (desligado) | `v1.0.0` | `-vi2c-force-polling` + `SSDT-NoTouch` |
| `ERR-SEC-01` | Permissões | WhatsApp/Steam sem pop-up de microfone; Netflix no Chrome falhando | ✅ `amfi=0x80` quebra TCC | **Resolvido** | `v1.0.0` | `v1.1.0` (`AMFIPass`) |
| `ERR-BOOT-01` | Boot | Menu escolhia Windows sozinho | ✅ Nenhum padrão gravado | **Resolvido** | `v1.0.0` | `v1.2.1` (`Ctrl+Enter`) |
| `ERR-BOOT-02` | Boot | Trava a ~40% da barra com `igfxfw=2` | ✅ Coreboot sem canal Intel MEI para o GuC | **Resolvido** (flag proibida) | branch `teste-correcoes` | `v1.1.0` |
