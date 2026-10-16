# Histórico Completo do Projeto (do primeiro prompt até hoje)

> **Para quem é este documento:** (1) qualquer pessoa que queira entender *como* este Hackintosh foi construído e *por que* cada decisão foi tomada; (2) qualquer IA que precise continuar o trabalho de onde parou.
> Complementos: [`CHANGELOG.md`](../CHANGELOG.md) (o que mudou em cada versão), [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md) (sintoma → causa → solução), [`BRIEFING_ANTIGRAVITY_MACOS.md`](BRIEFING_ANTIGRAVITY_MACOS.md) (estado atual e regras de trabalho), [`REGRAS_DE_VERSIONAMENTO.md`](REGRAS_DE_VERSIONAMENTO.md).

> [!IMPORTANT]
> **Honestidade sobre o nível de certeza.** Este histórico separa o que foi **confirmado em teste real pelo dono do notebook** (✅) do que é **hipótese ainda não comprovada** (🔶) e do que **foi tentado e falhou** (❌). Datas seguem o `git log` (fuso -03:00). Fases anteriores a 04/10/2026 não têm commits, pois o repositório só foi criado ao final da Fase 2.

---

## Resumo em 30 segundos

| Item | Valor |
| :--- | :--- |
| Máquina | HP Elite c1030 Chromebook (x360 13c, placa *Jinlon*), i7-10610U, Intel UHD 630, 16 GB, SSD WD SN520 128 GB, firmware Coreboot (MrChromebox) |
| Objetivo | macOS (Tahoe) em dual-boot com Windows via OpenCore, com o máximo de hardware funcionando |
| Resultado | macOS Tahoe **instalado e utilizável** ✅ — Wi-Fi, Bluetooth, áudio, microfone, trackpad, sleep, HiDPI funcionam. Pendências abertas: vídeo/áudio instáveis às vezes, monitor USB-C externo trava o macOS, touchscreen desligado de propósito, luz do teclado impossível |
| Versão atual | **v1.3.4** (EFI idêntica à v1.3.3, que é a v1.3.1 com `boot-args` restaurados) |
| Base de código | Fork evoluído de [starsnwind](https://github.com/starsnwind/HP-Elite-C1030---x360-13c-Chromebook-Hackintosh); EFI Tahoe de **Bantryred** (Issue #7); áudio [DexterSLamb/CmlSOFAudio](https://github.com/DexterSLamb/CmlSOFAudio); Wi-Fi legado via [OCLP-X](https://github.com/JeoJay127/OCLP-X) |

---

## Fase 1 — Preparar o disco e instalar o macOS (setembro/2026, sem commits)

**Ponto de partida:** o dono forneceu os repositórios acima e a pasta `CmlSOFAudio-v1.1.5`, e pediu ajuda para instalar o macOS Tahoe com acesso de administrador no Windows.

1. **Espaço no SSD.** O dono pediu ~35 GB para o macOS; o instalador exigiu **mínimo de 40 GB** ✅ (lição: reserve ≥ 40 GB, ideal 60+).
2. **Encolher a partição do Windows deu trabalho:**
   - ❌ *Paragon Partition Manager (Community)* não aplicou a operação — o log (`hdm17.log`) mostrou `Authorization is denied` (erro de licenciamento `0x82000002`).
   - ❌ O *Gerenciamento de Disco* do Windows também não encolhia — o desfragmentador acusou `pagefile.sys` como último arquivo imóvel.
   - ✅ Solução: limpar espaço do Windows (backups do WinSxS, caches de `AppData`, versões antigas do Edge, instaladores esquecidos) e usar o **GParted (live)** para reduzir a partição e criar o espaço não alocado. Detalhes práticos em [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md).
3. **Instalador "congelando" e kernel panic ao desligar do Recovery.** Diagnóstico aplicado na EFI do SSD:
   - Os logs do instalador (`osinstallersetupd`) mostraram que a **primeira etapa terminou com sucesso** (`Operation success - OSISensureAPFSPrebootOperation`); o "travamento" era na verdade o ponto em que o instalador precisa **reiniciar para a segunda etapa**, que aparece no OpenCore como *macOS Installer*. Foi preciso **extrair o `apfs.efi`** do próprio sistema e habilitar `GlobalConnect` para o OpenCore enxergar o volume APFS/Preboot recém-criado.
   - O instalador pedia internet mesmo em "reinstalação": o **Recovery do macOS é online**. Solução: injetar as credenciais do Wi-Fi no `Info.plist` do `itlwm.kext` (chave `WiFiConfig`) **na EFI local do dono** — essas credenciais **nunca foram nem devem ser commitadas**.
   - O comando `caffeinate` (para evitar suspensão durante o download) morre se a janela do Terminal for **fechada**; a solução é **minimizar** (botão amarelo) ou usar o atalho, não fechar.
4. 🎉 **O Tahoe iniciou.** Imediatamente a pasta do Bantryred (OC completo) foi usada como base, **sem alterações**, só para validar. O desempenho ficou "muito melhor que antes, parecia nativo".

## Fase 2 — Estabilizar o sistema recém-instalado

Problemas encontrados logo após o primeiro boot completo, **todos resolvidos** ✅:

| Sintoma | Causa | Solução aplicada |
| :--- | :--- | :--- |
| Tocar na tela derruba o macOS (kernel panic) | Touchscreen **Goodix `GDIX0000`** no barramento I2C: o Coreboot não roteia as interrupções GPIO como uma BIOS comum → *interrupt storm* no `VoodooI2CHID` | Boot-arg **`-vi2c-force-polling`** + **`SSDT-NoTouch.aml`** (desliga a tela de toque no macOS com patch ACPI `_STA→XSTA`). **O touchscreen fica desativado de propósito** |
| Após um crash, o SSD "sumiu" da BIOS (só voltou com *Refresh + Power*) | 🔶 Suspeita: interação do `NVMeFix.kext` com o controlador do **WD SN520** durante o crash. O *Refresh+Power* faz o EC cortar a energia do PCIe | Durante a depuração o `NVMeFix` ficou desligado; **na EFI atual ele está ligado (`ON`)** sem recorrência relatada. Se o SSD sumir de novo, desligue o `NVMeFix` primeiro |
| Wi-Fi inexistente após instalar | A Intel AX201 não tem driver Apple | `itlwm.kext` (+ app **HeliPort**) e, para o macOS Tahoe, os kexts legados do **OCLP-X** (`IOSkywalkFamily`, `IO80211FamilyLegacy`) — o dono rodou o `OpenCore-Patcher.pkg` e o Wi-Fi funcionou ✅. Para a 1ª conexão usou-se **ancoragem USB (tethering)** |
| Áudio "reconhecido mas mudo" | O driver SOF tem **duas partes**: o plugin HAL (`CmlSOFAudioPlugin.driver`, instalado por script) **e** o kext de kernel `CmlSOFAudio.kext` (que precisa estar ativo no `config.plist`). O kext tinha ficado de fora para isolar o Wi-Fi | Ativar `CmlSOFAudio.kext` no OpenCore ✅ |
| Animações com leve engasgo | CPU demorava a subir o clock | `CPUFriend` + `CPUFriendDataProvider` com **EPP `0x40`** em todos os vetores ✅ ("efeito Gênio" liso, sem desativar transparência) |

**Regra de ouro criada nesta fase:** o dono **não aceita** "desligar efeitos visuais" (transparência/desfoque) para ganhar desempenho.

## Fase 3 — Primeiro repositório e primeira release (04/10/2026)

- O dono pediu *backup + repositório*. Foram criados o ZIP `EFI_HP_Elite_c1030_PERFEITA_FINAL.zip`, o repositório `nepotira/HP-Elite-c1030-Hackintosh` e a release **v1.0.0** (`83d35eb` → tag em `eb1a0a9`).
- Tabela de status (o que funciona / testando / não funciona), README com créditos a **starsnwind, Bantryred e DexterSLamb**.
- **Microfone:** inicialmente "não funcionava em lugar nenhum"; depois confirmado ✅ funcionando nos Ajustes e no Gravador de Voz (matriz DMIC de 4 canais via DSP SOF).
- **Áudio baixo sem apps de terceiros:** lendo o código-fonte do driver encontrou-se `gain = volume * 0.25f` (saída travada em 25%). Gerou-se o plugin modificado em [`audio_boost/`](../audio_boost/) com ganho `1.0f` ✅. *(Restrição do dono: **nunca** resolver áudio problemático diminuindo o volume geral.)*
- Explicação "tática e técnica" de por que o sistema parece travado no início e fica fluido com o tempo (cache de shaders Metal, Spotlight, etc.) — pedida pelo dono para quem não entende.

## Fase 4 — Permissões (TCC), DRM e a saga do AMFI (09–10/10/2026)

**Problemas relatados:** WhatsApp não aparecia na lista de microfone; localização falhando; Netflix funcionou uma vez e parou; vídeos travando.

- **Causa do TCC quebrado:** o boot-arg **`amfi=0x80`** desliga o AMFI e, com isso, os pop-ups de permissão (TCC) deixam de funcionar ✅.
- **Solução (v1.1.0, `9431571`):** trocar `amfi=0x80` por **`AMFIPass.kext` + `-amfipassbeta`** ✅ → pop-ups voltam, Widevine do Chrome valida, FairPlay no Safari.
- ❌ **Tentativa que falhou (branch `teste-correcoes`):** o outro Antigravity (rodando dentro do macOS) sugeriu `igfxfw=2` (carregar firmware GuC) e remover `amfi=0x80` de uma vez. Resultado: o boot **morria a ~40% da barra da maçã**. Isolando: remover o AMFI sem o `AMFIPass` quebrava os kexts de rede legados; já o **`igfxfw=2` trava** porque o Coreboot não fornece o canal Intel MEI exigido pelo GuC. **Nunca use `igfxfw=2` neste notebook.**
- A pasta "de desempenho" (branch `desempenho`, base da v1.0.0) foi preservada como ponto de retorno seguro. O dono corrigiu um erro de confusão entre as duas EFIs — **sempre confira qual EFI está na partição `Y:` antes de afirmar algo**.
- Cuidado com **BOM UTF-8** no `config.plist`: causa erro `OCS` no OpenCore (commit `4d9301b`). Sempre salvar **UTF-8 sem BOM**.

## Fase 5 — Controle GameSir Nova Lite com dongle (10/10/2026)

- O dono usa o **GameSir Nova Lite com dongle USB 2.4 GHz (XInput)** no **xCloud pelo Chrome**. O outro Antigravity criou uma "gambiarra" (ponte XInput) que exigiu `amfi_get_out_of_my_way=1`, o que quebra o Widevine (Netflix no Chrome).
- Solução documentada em [`tools/gamesir_nova_lite/`](../tools/gamesir_nova_lite/): **Cenário A** (EFI com AMFI desligado para jogar + **Netflix no Safari**, que usa FairPlay nativo), **Cenário B** (AMFI ligado + assinatura *ad-hoc* local da ponte com `codesign --force --deep --sign -`), **Cenário C** (`ALTERNAR_EFI.bat` para trocar de perfil no Windows com 1 clique).
- O dono corrigiu: o atalho **`Home + A` não conecta o dongle em DInput** (o modo correto é XInput, `Home + X`, LED verde).

## Fase 6 — Guia do zero, versionamento e releases (10–11/10/2026)

- Criado [`GUIA_DO_ZERO_AO_MACOS.md`](GUIA_DO_ZERO_AO_MACOS.md) (Coreboot/MrChromebox → Tiny11 → OpenCore → macOS), com aviso legal e dicas de uso de IA — **o dono não se responsabiliza por danos; o texto é instrução, não recomendação**.
- **Erros de versionamento reclamados pelo dono (e corrigidos):** README falando "v1.0.0", release sem upload, "1.1.0" repetida, "1.2.0 chutado". Lição: **consultar [`REGRAS_DE_VERSIONAMENTO.md`](REGRAS_DE_VERSIONAMENTO.md) antes de qualquer commit/tag** e **verificar na API do GitHub se a release realmente tem os arquivos**.
- ⚠️ Anomalia histórica registrada: a tag **`v1.1.3`** (e a release de mesmo nome) aponta para o commit `d70ca8c`, o **mesmo** da tag `v1.3.0` — foi criada antes da regra SemVer. Ver [CHANGELOG](../CHANGELOG.md#notas-sobre-tags-e-releases-legadas).

## Fase 7 — Boot padrão no macOS (11/10/2026)

- Pedido: ao ligar, o menu Windows/macOS escolhia Windows sozinho; o dono queria macOS por padrão.
- Houve uma tentativa excessiva da IA (mexeu em muita coisa desnecessária) — o dono mandou **desfazer tudo e não refazer o que não foi pedido** ✅ (regra permanente).
- **Solução final ✅ (v1.2.1):** `PollAppleHotKeys=true` + no menu do OpenCore selecionar **macOS**, segurar **`Ctrl`** e apertar **`Enter`** (grava o padrão na NVRAM). Se a NVRAM for resetada, repetir.

## Fase 8 — Escala HiDPI (11/10/2026)

- Pedido: ter a escala 100%/110%/125% (como Retina) na tela 1920×1280 (3:2) sem perder nitidez. O macOS esconde esse seletor em telas de terceiros.
- **Solução (v1.3.0, tag `d70ca8c`)**: `tools/hidpi/` com *DisplayOverride* sob medida (`VendorID 0x30e4`, `ProductID 0x0663`), baseado no `xzhih/one-key-hidpi`, modo recomendado **1536×1024 HiDPI** ✅ (o sistema renderiza em 3072×2048 e reduz para os 1920×1280).
- 🔶 **Efeito colateral suspeito (NÃO resolvido):** depois de um programa de HiDPI/"tela Retina" ter sido instalado, o dono relatou **flicker, "salpicado/ghosting" de janelas, elementos cortados e depois travamentos**. A partir daí surgiram também **vídeos que param/não iniciam** e **áudio picotando**. A hipótese de que o HiDPI (buffer 3072×2048 numa UHD 630) esteja sobrecarregando a GPU **nunca foi testada isoladamente** — ver "Próximos passos".

## Fase 9 — Luz do teclado (11/10/2026)

- O README dizia que a luz do teclado ajustava em 6 níveis por atalhos (**F8/F9, Alt+F6/F7**). **Isso era falso** ❌ e foi corrigido (v1.2.2): o backlight é controlado só pelo **ChromeOS EC** (barramento proprietário); não existe driver no macOS. Status correto: **não funcional / limitação de hardware**.

## Fase 10 — Monitor USB-C externo (11–13/10/2026)

- **Sintoma ✅ reproduzido:** macOS mostra a imagem espelhada por alguns segundos e **congela**; no boot com o cabo conectado, a barra da maçã trava ~metade. **No Windows funciona** (monitor portátil Full HD `RTK1920`).
- **Porta esquerda** tem **mau contato físico** (liga/desliga sozinha até no Windows) — descartada para testes; a **direita é estável** e mesmo assim congela no macOS.
- Tentativas: remover `igfxonln=1`, `igfxagdc=0` e `disable-agdc` (`389782c`, mantido); `fbmem 48MB`+`cursormem`+`-igfxtypec` (`c499f6e`) ❌ **revertido** (`6626975`).
- Status: **em testes / instável**. Hipótese: o EC do Chromebook comuta DP Alt-Mode/PD e não há driver Type-C equivalente no macOS. Alternativa prática: adaptador **USB-C→HDMI/DP** dedicado (não testado pelo dono).

## Fase 11 — Versionamento formal e a tentativa que falhou (14/10/2026)

- O dono exigiu um **manual de versionamento** e retag correto → criados `REGRAS_DE_VERSIONAMENTO.md`, `CHANGELOG.md` e tags `v1.0.0 … v1.3.2` (**v1.3.2 = `fb11f94`**).
- ❌ **v1.3.2 falhou:** ao tentar corrigir "vídeo não roda" e "áudio picotando", mudou-se o `boot-args` para `forceRenderStandby=0 igfxrpsc=1` e removeu-se `unfairgva=1`. O dono reportou **"desempenho ficou horrível"**.
- ✅ **v1.3.3 (`27db775`)**: `boot-args` revertidos **exatamente** ao estado da v1.3.1.
- 🔶 **Correção de análise (importante):** na época atribuiu-se a lentidão a *throttling de TDP* causado por `forceRenderStandby=0`. Isso é **improvável**: a v1.0.0 — que o dono descreveu como "impecável" — **já usava `forceRenderStandby=0`**. O suspeito mais provável da piora é **`igfxrpsc=1`** (ou a combinação com o HiDPI). **A causa real não foi comprovada.**

## Fase 12 — Auditoria de documentação (16/10/2026, v1.3.4)

Esta versão **não altera a EFI**. Corrigiu documentação (datas erradas no changelog, hardware errado no README, afirmações "resolvido" que não eram verdade), criou este histórico, o troubleshooting, o briefing para IAs, o `AGENTS.md` e publicou a release com os arquivos que o README já prometia.

---

## Próximos passos recomendados (em ordem de custo/benefício)

1. **Teste isolado do HiDPI** 🔶: rodar `sudo tools/hidpi/desativar_hidpi.sh`, reiniciar, usar 1920×1280 nativo (ou resolução menor) por um dia. Se vídeo e áudio normalizarem, o culpado é o HiDPI (e a v1.3.3 já está correta). **Esta é a hipótese mais barata e ainda não testada.**
2. Se persistir: **medir antes de mudar** — ver [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md#coleta-de-diagnóstico-antes-de-mexer) (logs `coreaudiod`, `VTDecoderXPCService`, `pmset`, `powermetrics`).
3. Testar **uma flag por vez** (nunca várias), com backup da EFI e *reset de NVRAM* entre testes, registrando cada resultado no `CHANGELOG.md`.
4. Monitor USB-C: testar um adaptador USB-C→HDMI antes de investir em mais patches.
5. (Opcional, upstream) abrir issue no repositório do DexterSLamb sobre *underruns* de áudio do `CmlSOFAudioPlugin` (anel de 16384 frames; o ponteiro DPIB alcança o SPIB quando a thread do `coreaudiod` atrasa).
