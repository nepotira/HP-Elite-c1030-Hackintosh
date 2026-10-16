# Troubleshooting — Sintoma → Causa → Solução

> Tudo aqui foi **observado neste notebook** (HP Elite c1030 / Jinlon). Cada item informa o nível de certeza: ✅ confirmado, 🔶 hipótese, ❌ não funciona / limitação.
> Regra de ouro antes de qualquer correção: **faça backup da pasta `EFI`**, altere **uma coisa por vez**, e se não funcionar **reverta**. Registre no [`CHANGELOG.md`](../CHANGELOG.md).

## Índice
1. [Recuperação de emergência (macOS não inicia)](#recuperação-de-emergência)
2. [Instalação e disco](#instalação-e-disco)
3. [Boot](#boot)
4. [Hardware: o que funciona e o que não funciona](#hardware)
5. [Problemas abertos (vídeo, áudio, monitor externo)](#problemas-abertos)
6. [Coleta de diagnóstico antes de mexer](#coleta-de-diagnóstico-antes-de-mexer)
7. [Flags de boot-args: o que cada uma faz neste notebook](#boot-args)

---

## Recuperação de emergência

| Situação | O que fazer |
| :--- | :--- |
| Mudei o `config.plist` e o macOS não sobe | Volte ao Windows (boot manual pela BIOS: *Boot Options → boot por arquivo*) e restaure a EFI anterior (`Y:\EFI`, ou use um ZIP de release). Para isso monte a partição EFI: `mountvol Y: /S` num PowerShell **como administrador** |
| O SSD "sumiu" da BIOS depois de um crash | Desligue, segure **Refresh + Power** (corte de energia do PCIe pelo EC) e ligue. Se repetir, desative `NVMeFix.kext` 🔶 |
| Tela do OpenCore não aparece | Limpe a NVRAM (opção *Reset NVRAM* no menu) e, se preciso, entre pela BIOS no arquivo `EFI/BOOT/BOOTx64.efi` |
| `OCS: ... plist` ao iniciar o OpenCore | O `config.plist` foi salvo com **BOM UTF-8**. Salve como **UTF-8 sem BOM** ✅ |
| Boot trava na barra da maçã (~40%) | Provável `igfxfw=2` ou remoção do AMFI sem `AMFIPass` ✅ — ver [boot-args](#boot-args) |

> **Sobre a pasta `Y:\EFI`:** a letra `Y:` é a partição EFI **montada no Windows do dono**; em outros PCs será outra. Sempre **confirme qual EFI está na partição antes de afirmar qualquer coisa**.

---

## Instalação e disco

### Não consigo encolher a partição do Windows para abrir espaço para o macOS ✅
1. **Espaço mínimo:** o instalador do macOS recusa menos de **40 GB**. Reserve 60 GB+ se puder.
2. *Paragon Partition Manager Community* pode falhar com `Authorization is denied` (erro de licença `0x82000002`) — não é problema do disco.
3. O Windows só encolhe até onde há arquivos imóveis; `pagefile.sys`, `hiberfil.sys` e pontos de restauração costumam travar. Desative temporariamente a hibernação (`powercfg /h off`), o arquivo de paginação e o Restauração do Sistema, reinicie, e tente de novo.
4. Libere espaço antes: `C:\Windows\WinSxS` (via *Limpeza de Disco → Limpar arquivos do sistema* / `DISM /Online /Cleanup-Image /StartComponentCleanup`), caches em `AppData\Local`, versões antigas do Edge, instaladores em *Downloads*.
5. Solução mais confiável: **GParted Live** (pendrive) para reduzir a partição NTFS. Resultado: espaço **não alocado** (sem formatar).

### O instalador do macOS "congela" ou reinicia em ~20% ✅
- Provavelmente é a **transição para a segunda etapa**: a primeira etapa termina (nos logs: `Operation success - OSISensureAPFSPrebootOperation`) e o computador reinicia. Volte ao menu do OpenCore e escolha **`macOS Installer`** (não o Recovery).
- Se não aparecer, a EFI precisa do driver **`apfs.efi`** (extraído do próprio macOS) e de `GlobalConnect=true`.
- O Recovery do macOS é **online**: precisa de internet mesmo para reinstalar. Use Wi-Fi configurado no `itlwm.kext` (chave `WiFiConfig` do `Info.plist`) ou ancoragem USB (iPhone/Android).
- Use `caffeinate` no Terminal para não suspender, mas **minimize** a janela do Terminal em vez de fechá-la (fechar mata o `caffeinate`).

### Kernel panic ao desligar a partir do Recovery
Ocorria com a EFI inicial; desapareceu depois dos ajustes descritos em [`HISTORICO_DO_PROJETO.md`](HISTORICO_DO_PROJETO.md) (Fase 1).

---

## Boot

### Quero que o macOS seja o padrão no menu do OpenCore ✅
No menu: selecione **macOS** → segure **`Ctrl`** → aperte **`Enter`**. Requer `PollAppleHotKeys=true` (já ligado desde a v1.2.1). Se resetar a NVRAM, repita.

### Vou usar o dongle do controle GameSir e a Netflix no Chrome ✅
Veja [`tools/gamesir_nova_lite/README.md`](../tools/gamesir_nova_lite/README.md): Cenário A (AMFI desligado + Netflix no **Safari**), B (assinatura ad-hoc) ou C (alternador `ALTERNAR_EFI.bat`). O modo XInput é `Home + X` (LED verde); `Home + A` **não** funciona.

---

## Hardware

| Recurso | Estado | Observação |
| :--- | :---: | :--- |
| Aceleração gráfica (Metal), Wi-Fi (itlwm+HeliPort), Bluetooth, trackpad, teclado (SSDT-ChromebookKeys), bateria (CrosEC), NVMe, sleep/wake | ✅ | Funcionam |
| Áudio (alto-falantes/fones) e microfone | ✅ | `CmlSOFAudio.kext` **+** `CmlSOFAudioPlugin.driver` (as duas partes são necessárias). Volume alto: `audio_boost/` |
| Escala HiDPI 1536×1024 | ✅ (🔶 suspeita de efeitos colaterais) | `tools/hidpi/` — ver [problemas abertos](#problemas-abertos) |
| Touchscreen | ❌ desligado de propósito | Tocar na tela gera tempestade de interrupções → kernel panic. `SSDT-NoTouch.aml` + `-vi2c-force-polling` |
| Luz do teclado (backlight) | ❌ | Controlada só pelo ChromeOS EC; não há driver no macOS. **Não existem atalhos F8/F9/Alt+F6/F7 para isso** (afirmação antiga era falsa) |
| Localização precisa | 🟡 | Só por IP; o `itlwm` não expõe BSSIDs |
| Monitor externo USB-C | 🟡 instável | ver abaixo |

### WhatsApp/Steam não aparecem na lista de microfone (TCC) ✅
Era o `amfi=0x80`. Use **`AMFIPass.kext` + `-amfipassbeta`** (já na EFI). Se o app ainda não aparecer, abra-o e tente gravar um áudio para o macOS exibir o pop-up; só então use `tccutil reset Microphone` (atenção: o reset **apaga** permissões de todos os apps).

### Wi-Fi não conecta no Tahoe ✅
Use `itlwm.kext` + **HeliPort** (em `/Applications` e em *Itens de Início*) e os kexts legados do OCLP-X (`IOSkywalkFamily`, `IO80211FamilyLegacy`) com o `OpenCore-Patcher.pkg`. Para a primeira conexão, ancoragem USB.

### Áudio reconhecido mas mudo ✅
Falta o `CmlSOFAudio.kext` no `config.plist` (o plugin HAL sozinho "fala no vácuo").

---

## Problemas abertos

> Estes são os itens **não resolvidos**. Qualquer IA/pessoa que continuar o projeto deve começar por aqui.

### P1 — Vídeos param ou não iniciam (YouTube, players) 🔶 em investigação (`ERR-VID-01`)
- **Sintoma:** reprodução congela do nada ou nem inicia, em qualquer navegador/player.
- **O que já foi tentado:**
  - v1.1.0: remover `forceRenderStandby=0` e adicionar `unfairgva=1` → relatado como melhora na época; depois voltou a falhar.
  - v1.3.2: `forceRenderStandby=0 igfxrpsc=1` e remover `unfairgva=1` → ❌ **desempenho horrível**, revertido (v1.3.3).
- **Hipóteses (nenhuma comprovada):** (a) HiDPI 3072×2048 sobrecarregando a UHD 630; (b) transições de energia da iGPU (RC6) durante decodificação; (c) acoplamento relógio do vídeo ↔ relógio do CoreAudio (se o áudio engasga, o vídeo trava junto).
- **Próximo passo mais barato:** desligar o HiDPI (`sudo tools/hidpi/desativar_hidpi.sh`) e reiniciar.

### P2 — Áudio picotando / "repicado" 🔶 em investigação (`ERR-AUD-01`)
- **Sintoma:** estalos/repetição rápida do som, às vezes junto com travamento de vídeo.
- **Restrição do dono:** **não resolver baixando o volume** — encontrar a causa.
- **Análise do código** (`CmlSOFAudioPlugin.c`, DexterSLamb): o áudio vai para um anel de **16384 frames** (≈341 ms a 48 kHz); o ponteiro de leitura do DMA (DPIB) persegue o de escrita (SPIB). Se a thread do `coreaudiod` atrasa, o DPIB alcança o SPIB e o hardware **relê o mesmo bloco** — som "metralhadora". *(Mecanismo plausível; o gatilho real — GPU, CPU, taxa de amostragem — ainda não foi provado.)*
- **Mitigações seguras a testar** (nenhuma altera ganho/volume): fixar a saída em **48 000 Hz** no *Audio MIDI Setup*; rodar `sudo tools/audio/otimizar_audio.sh` (reinicia `coreaudiod` e limpa preferências de áudio — **efeito não validado**); testar com HiDPI desligado.

### P3 — Monitor USB-C → USB-C congela o macOS 🟡 (`ERR-DISP-01`)
- **Sintoma:** espelha por segundos e congela; com cabo conectado, o boot trava na metade da barra.
- **Fatos ✅:** funciona no Windows; **porta esquerda tem mau contato físico**; a porta **direita** é estável e ainda assim congela no macOS.
- **Já tentado:** remover `igfxonln=1`, `igfxagdc=0`, `disable-agdc` (mantido); `fbmem 48MB`+`cursormem`+`-igfxtypec` (❌ revertido).
- **Hipótese 🔶:** o EC do Chromebook comuta DP Alt-Mode/Power Delivery e não há driver Type-C equivalente no macOS.
- **Alternativa:** adaptador dedicado USB-C→HDMI/DisplayPort (não testado).

### P4 — Após instalar o "programa de tela Retina", flicker e janelas "salpicadas" 🔶
Relatado pelo dono após ativar HiDPI/Retina: ghosting de janelas minimizadas, elementos cortados, travamentos. Reverter com `tools/hidpi/desativar_hidpi.sh`. **Se esta for a causa de P1/P2, os três se resolvem juntos.**

---

## Coleta de diagnóstico antes de mexer

No macOS (Terminal), **antes** de alterar qualquer flag, salve o estado:

```bash
# Versão e boot-args realmente em uso
sw_vers; nvram boot-args; sysctl machdep.cpu.brand_string

# Escala/resolução atual
system_profiler SPDisplaysDataType | grep -E "Resolution|UI Looks|Framebuffer"

# Áudio: erros do coreaudiod nos últimos 10 min
log show --last 10m --predicate 'process == "coreaudiod"' --info | tail -n 80

# Vídeo: decodificador de hardware nos últimos 10 min
log show --last 10m --predicate 'process == "VTDecoderXPCService" OR process == "coremediad"' | tail -n 80

# Energia/GPU (precisa de sudo; Ctrl+C para parar)
sudo powermetrics --samplers cpu_power,gpu_power -i 2000 -n 5

# Kernel panics anteriores
ls -lt /Library/Logs/DiagnosticReports | head
```

No Windows, o log do OpenCore é gravado na partição EFI (`Misc → Debug → Target`), útil para boots que travam sem tela.

---

## boot-args

Estado **atual** (v1.3.4, igual ao da v1.3.1/v1.3.3):

```text
-lilubetaall -igfxnotelemetryload -igfxblr -igfxblt -igfxmlr -igfxmpc -igfxhdmidivs revpatch=sbvmm -amfipassbeta -vi2c-force-polling keepsyms=1 debug=0x100 unfairgva=1
```

| Flag | Para que serve aqui | Observação |
| :--- | :--- | :--- |
| `-lilubetaall` | Lilu/plugins em macOS não oficial (Tahoe) | necessário |
| `-igfxnotelemetryload`, `-igfxblr`, `-igfxblt`, `-igfxmlr`, `-igfxmpc`, `-igfxhdmidivs` | Ajustes do WhateverGreen para a iGPU / brilho / HDMI | herdados do repositório base |
| `revpatch=sbvmm` | RestrictEvents: habilita atualizações / esconde VMM | |
| `-amfipassbeta` | Habilita `AMFIPass.kext` (TCC e Widevine funcionam sem `amfi=0x80`) | ✅ essencial |
| `-vi2c-force-polling` | `VoodooI2C` em polling → evita *interrupt storm* da tela de toque | ✅ essencial |
| `keepsyms=1`, `debug=0x100` | Símbolos em panics / não reiniciar automático | diagnóstico |
| `unfairgva=1` | Desvio de DRM/decodificação pensado para dGPU AMD | 🔶 efeito nesta máquina incerto |

**Flags que NÃO usar neste notebook:**

| Flag | Por quê |
| :--- | :--- |
| `igfxfw=2` | ❌ Trava o boot (~40% da barra): o Coreboot não fornece o canal Intel MEI para o GuC |
| `amfi=0x80` | ❌ Quebra TCC (microfone/câmera) — usar `-amfipassbeta` |
| `igfxrpsc=1` (+ `forceRenderStandby=0`) | ❌ Na v1.3.2 o conjunto causou "desempenho horrível" (causa individual não isolada; `igfxrpsc=1` é o suspeito principal) |
| `igfxonln=1`, `igfxagdc=0`, `disable-agdc` | ❌ Removidos na v1.3.1: pioravam o hotplug de monitor |
