# Briefing para Continuidade por Qualquer IA / Mantenedor

> **Leia isto primeiro.** Este arquivo substitui o briefing antigo (que estava defasado na v1.1.2 e marcava como "resolvido" problemas que continuam abertos). Ele resume o **estado real** do projeto na **v1.3.4** e as **regras de trabalho** que o dono impôs ao longo do desenvolvimento.
> Leitura recomendada, nesta ordem: este briefing → [`REGRAS_DE_VERSIONAMENTO.md`](REGRAS_DE_VERSIONAMENTO.md) → [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md) → [`HISTORICO_DO_PROJETO.md`](HISTORICO_DO_PROJETO.md) → [`../CHANGELOG.md`](../CHANGELOG.md).

---

## 1. Hardware e ambiente

| Item | Detalhe |
| :--- | :--- |
| Notebook | HP Elite c1030 Chromebook (x360 13c), placa **Jinlon** |
| CPU / GPU | Intel Core **i7-10610U** (Comet Lake-U) / Intel **UHD 630** (`0x9B41`, spoof `0x3EA5`) |
| RAM / SSD | 16 GB LPDDR4 / WD PC **SN520** 128 GB NVMe |
| Tela | 13.5" IPS **1920×1280 (3:2)** — `VendorID 0x30e4`, `ProductID 0x0663` |
| Firmware | **Coreboot / MrChromebox Full ROM** (UEFI) |
| SO | macOS **Tahoe (26)** via **OpenCore**, dual-boot com Windows (Tiny11) |
| Áudio | DSP Intel cAVS **SOF** (`CmlSOFAudio.kext` + `CmlSOFAudioPlugin.driver`); **não** há codec HDA tradicional |
| Wi-Fi/BT | Intel AX201 → `itlwm.kext` + HeliPort; `IntelBluetoothFirmware` + `BlueToolFixup` |
| SMBIOS | `MacBookPro16,2` (cada usuário deve gerar o seu — nunca publique seu serial) |
| Repositório | https://github.com/nepotira/HP-Elite-c1030-Hackintosh |
| Branches | `main` (atual), `desempenho` (base da v1.0.0, ponto de retorno seguro), `teste-correcoes` (experimentos antigos — contém o `igfxfw=2` que **trava**) |

No Windows do dono, a partição EFI é montada como **`Y:`** (`mountvol Y: /S` como administrador). O arquivo vivo é `Y:\EFI\OC\config.plist`; o do repositório é `EFI/OC/config.plist`. **Os dois devem permanecer idênticos**, salvos em **UTF-8 sem BOM**.

---

## 2. Estado atual (v1.3.4)

### Funcionando ✅
Metal/aceleração gráfica, trackpad (VoodooI2C), teclado + teclas do Chromebook, Wi-Fi, Bluetooth, áudio (alto-falantes/fones, com `audio_boost`), microfone, bateria/EC, NVMe, sleep/wake, TCC/permissões (AMFIPass), DRM (FairPlay no Safari, Widevine no Chrome), HiDPI 1536×1024, boot padrão macOS (`Ctrl+Enter`), pacote GameSir Nova Lite.

### Desligado de propósito / impossível ❌
- **Touchscreen:** desativado (`SSDT-NoTouch.aml` + `-vi2c-force-polling`) — tocar derruba o macOS.
- **Luz do teclado:** impossível (só o ChromeOS EC controla). **Não existe atalho** que ajuste isso.

### Abertos 🔶 (comece por aqui)
| ID | Problema | Estado |
| :--- | :--- | :--- |
| `ERR-VID-01` | Vídeos param/não iniciam | Aberto. v1.3.2 tentou e falhou (revertido) |
| `ERR-AUD-01` | Áudio picotando ("repicado") | Aberto. **Não resolver baixando o volume** |
| `ERR-PWR-01` | Desempenho horrível após v1.3.2 | Mitigado por reversão (v1.3.3); causa individual não isolada |
| `ERR-DISP-01` | Monitor USB-C congela o macOS | Em testes / instável (porta esquerda com mau contato físico) |

**Hipótese principal ainda NÃO testada:** o HiDPI (3072×2048 numa UHD 630) + o "programa Retina" causam flicker/ghosting e podem estar por trás de vídeo/áudio instáveis. **Teste primeiro:** `sudo tools/hidpi/desativar_hidpi.sh` + reiniciar.

**boot-args atuais:** `-lilubetaall -igfxnotelemetryload -igfxblr -igfxblt -igfxmlr -igfxmpc -igfxhdmidivs revpatch=sbvmm -amfipassbeta -vi2c-force-polling keepsyms=1 debug=0x100 unfairgva=1`

---

## 3. Mapa do repositório

| Caminho | Conteúdo |
| :--- | :--- |
| `EFI/BOOT`, `EFI/OC` | EFI pronta (OpenCore, kexts, SSDTs, `config.plist`) |
| `audio_boost/` | Plugin HAL com ganho `1.0f` + `instalar_audio_boost.sh` |
| `tools/audio/otimizar_audio.sh` | Reinicia `coreaudiod` e limpa preferências de áudio (**efeito não validado**; não mexe em ganho) |
| `tools/hidpi/` | Ativar/desativar HiDPI 3:2 |
| `tools/gamesir_nova_lite/` | Ponte XInput, assinatura ad-hoc, `ALTERNAR_EFI.bat`, configs |
| `docs/` | Guia do zero, migração Windows, regras, histórico, troubleshooting, este briefing |
| `CHANGELOG.md` | Histórico por versão + tabela de rastreamento de erros |

---

## 4. Regras de trabalho impostas pelo dono (obrigatórias)

1. **Versionamento:** ler [`REGRAS_DE_VERSIONAMENTO.md`](REGRAS_DE_VERSIONAMENTO.md) **antes** de qualquer alteração; SemVer 2.0.0; Conventional Commits; atualizar `CHANGELOG.md`; criar tag; **publicar a release com os arquivos e conferir pela API** (`https://api.github.com/repos/nepotira/HP-Elite-c1030-Hackintosh/releases`). Nunca "chutar" número de versão.
2. **Relate erros** como `ERR-XXX-NN` (sintoma, causa, status, versão). **Rotule hipóteses como hipóteses.** Não escreva "Resolvido" sem o dono confirmar no hardware.
3. **Não baixe o volume** para esconder defeito de áudio. **Não desative transparência/desfoque/animações** para ganhar desempenho.
4. **Não faça mais do que foi pedido.** Quando o dono pede uma coisa, não refaça/"melhore" outras. Se exagerou, desfaça tudo e peça desculpa — já aconteceu.
5. **Backup antes de mexer** na EFI/`config.plist`; **uma mudança por vez**; reversão imediata se piorar. Sempre dizer qual EFI está em uso (`Y:` vs repositório vs backups).
6. **Antes de mandar o dono fazer algo**, pesquise e valide se aquilo funciona (ele relatou perder tempo com instruções erradas, p.ex. botões inexistentes).
7. **Leia o histórico** antes de perguntar o que ele já informou.
8. **Nunca publique credenciais**: senhas de Wi-Fi (injetadas só na EFI local, no `itlwm.kext`), seriais SMBIOS reais, tokens. O `Info.plist` do `itlwm` no repositório contém apenas um exemplo.
9. **`config.plist` em UTF-8 sem BOM** (BOM gera erro `OCS`).
10. **Texto do repositório em português do Brasil**, claro para leigos (o dono quer que "qualquer pessoa que não sabe nada" consiga usar) e tecnicamente preciso. Incluir sempre o aviso: *instruções, não recomendações; sem responsabilidade por danos*.

---

## 5. Comandos úteis

```powershell
# Windows (PowerShell como administrador): montar a EFI
mountvol Y: /S

# Comparar EFI viva x repositório
fc.exe /b Y:\EFI\OC\config.plist .\EFI\OC\config.plist

# Conferir releases publicadas
Invoke-RestMethod https://api.github.com/repos/nepotira/HP-Elite-c1030-Hackintosh/releases -Headers @{'User-Agent'='x'} | % { $_.tag_name; $_.assets.name }
```

```bash
# macOS: diagnóstico rápido (detalhes em docs/TROUBLESHOOTING.md)
nvram boot-args
log show --last 10m --predicate 'process == "coreaudiod"' --info | tail -n 80
sudo tools/hidpi/desativar_hidpi.sh   # teste da hipótese principal
```

---

## 6. Fluxo recomendado para a próxima sessão

1. Confirmar com o dono a versão da EFI em uso (`nvram boot-args`).
2. Rodar o **teste do HiDPI desligado** (item 2 acima) e registrar o resultado.
3. Se vídeo/áudio continuarem ruins, coletar diagnóstico (`TROUBLESHOOTING.md`) **antes** de propor flags.
4. Propor **uma** mudança, aplicar com backup, pedir teste, registrar no `CHANGELOG.md` (resolvido **só** com confirmação do dono), versionar e publicar.
