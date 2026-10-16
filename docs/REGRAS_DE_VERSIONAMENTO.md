# Regras de Versionamento Semântico e Rastreamento de Erros

> **OBRIGATÓRIO PARA AGENTES DE IA E DESENVOLVEDORES:**  
> Antes de realizar qualquer commit, tag, alteração na EFI, script ou documentação deste repositório, você **DEVE** ler e seguir rigorosamente as diretrizes deste documento. Toda alteração precisa ser versionada, documentada e rastreada segundo as regras abaixo.

---

## 1. Princípios do Versionamento Semântico (SemVer 2.0.0)

O projeto adota formalmente o padrão [SemVer 2.0.0](https://semver.org/lang/pt-BR/). O formato de numeração de versão é:

$$\text{v}\mathbf{MAJOR}.\mathbf{MINOR}.\mathbf{PATCH}$$

Exemplo: `v1.3.2`

### 1.1 Critérios de Incremento de Versão

| Segmento | Quando Incrementar | Exemplos no Projeto |
| :--- | :--- | :--- |
| **MAJOR** (`X.0.0`) | **Mudanças Incompatíveis (Breaking Changes)**<br>• Atualização de versão maior do macOS (ex: Sonoma 14 $\to$ Sequoia 15) que exija reconfiguração estrutural.<br>• Troca ou reestruturação completa do OpenCore.<br>• Mudanças de particionamento, tabela ACPI incompatível ou quebra de retrocompatibilidade de drivers essenciais. | `v2.0.0` |
| **MINOR** (`1.Y.0`) | **Novas Funcionalidades Retrocompatíveis**<br>• Adição de suporte a novo subsistema de hardware (ex: Wi-Fi, Bluetooth, Touchscreen, Áudio).<br>• Inclusão de novas ferramentas ou pacotes funcionais (ex: ferramentas HiDPI 3:2, utilitários GameSir XInput).<br>• Novos fluxos e roteiros estruturados de instalação. | `v1.2.0`, `v1.3.0` |
| **PATCH** (`1.3.Z`) | **Correções de Bugs e Ajustes de Estabilidade**<br>• Correções de `boot-args` (ex: `forceRenderStandby=0`, `igfxrpsc=1`).<br>• Correções de bugs de áudio, vídeo, rede ou energia.<br>• Atualizações de versão de kexts existentes sem quebra.<br>• Correções e ajustes em documentação e scripts de automação. | `v1.3.1`, `v1.3.2` |

---

## 2. Padrão de Commits (Conventional Commits)

Todas as mensagens de commit devem seguir o padrão Conventional Commits:

```text
<tipo>(<escopo opcional>): <descrição sucinta em português ou inglês>

[corpo opcional detalhando a motivação e causa técnica]

[rodapé opcional com referências a IDs de erro, ex: Fixes ERR-VID-01]
```

### 2.1 Tipos Permitidos
- `feat`: Nova funcionalidade, ferramenta ou suporte a componente de hardware.
- `fix`: Correção de bug em código, EFI, kext, ACPI ou script.
- `docs`: Alterações exclusivas em arquivos de documentação Markdown.
- `refactor`: Refatoração de arquivos sem alterar comportamento funcional (ex: limpeza de ACPI, organização de pastas).
- `chore`: Tarefas de manutenção, automações de build, scripts de push ou rotinas de repositório.
- `revert`: Reversão de commits anteriores.

### 2.2 Escopos Recomendados
- `(video)`: Decodificação de hardware, iGPU UHD 630, WhateverGreen, conectores de display.
- `(audio)`: Driver HAL CmlSOF, kext CmlSOFAudio, CoreAudio, sample rate, buffers.
- `(display)`: Painel interno 3:2, HiDPI, brilho, monitores externos DisplayPort/Type-C.
- `(input)`: Teclado, Touchpad I2C, Touchscreen, atalhos de hardware.
- `(efi)`: `config.plist`, drivers UEFI, OpenCore core.
- `(release)`: Ajustes de versão e preparação de tags.

---

## 3. Protocolo de Rastreamento e Documentação de Erros (Error Tracking)

Sempre que o usuário ou testador relatar um defeito, travamento, comportamento anômalo ou regressão, o agente **NÃO DEVE** aplicar soluções paliativas superficiais (como reduzir volume para mascarar estouro de buffer). Deve-se aplicar o seguinte protocolo:

### 3.1 Identificador de Erro (Error ID)
Cada erro recebe um identificador único no padrão:

$$\mathbf{ERR}\text{-}\mathbf{[SUBSISTEMA]}\text{-}\mathbf{[NÚMERO]}$$

Subsistemas padronizados:
- `ERR-VID`: Vídeo, decodificação por hardware, iGPU, aceleração gráfica.
- `ERR-AUD`: Áudio, driver HAL, CoreAudio, microfone, taxa de amostragem.
- `ERR-DISP`: Telas, HiDPI, monitores externos, hotplug Type-C.
- `ERR-BOOT`: Inicialização, OpenCore, NVRAM, tempos de boot.
- `ERR-KBD`: Teclado, iluminação backlight, mapeamento de teclas.
- `ERR-PWR`: Gerenciamento de energia, suspensão (sleep/wake), bateria.

### 3.2 Ficha Cadastral do Erro
No `CHANGELOG.md` e nos commits relacionados, registre:
1. **ID do Erro**: Ex: `ERR-VID-01`
2. **Sintoma Relatado**: O comportamento observado pelo usuário.
3. **Causa Raiz Técnica**: A explicação exata em nível de sistema/driver (ex: estouro de buffer DMA, suspensão de RC6, flag indevida de DRM).
4. **Status**: `Aberto`, `Em Investigação`, `Resolvido`, `Mitigado` ou `Limitação de Hardware`.
5. **Versão Introduzida / Observada**: Ex: `v1.1.0`.
6. **Versão da Correção**: Ex: `v1.3.2`.
7. **Ação Realizada**: Arquivos e valores alterados para solucionar a causa raiz.

---

## 4. Manutenção Obrigatória do `CHANGELOG.md`

O repositório mantém um arquivo `CHANGELOG.md` no padrão [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/).  
A cada nova versão:
1. Crie uma seção com `## [vX.Y.Z] - AAAA-MM-DD`.
2. Categorize as mudanças em:
   - `### Adicionado` (Added)
   - `### Corrigido` (Fixed) — contendo a referência explícita aos IDs de Erro resolvidos.
   - `### Alterado` (Changed)
   - `### Erros Conhecidos e Limitações` (Known Issues)
3. Mantenha no rodapé do `CHANGELOG.md` a **Tabela Geral de Rastreamento de Erros**.

---

## 5. Checklist Obrigatório para Agentes de IA

Antes de declarar uma tarefa concluída:
- [ ] Consultei este arquivo (`docs/REGRAS_DE_VERSIONAMENTO.md`)?
- [ ] Se o usuário relatou um bug, foi criado/atualizado o respectivo ID no formato `ERR-XXX-NN`?
- [ ] A causa raiz real foi investigada e solucionada sem uso de gambiarras paliativas?
- [ ] A numeração da nova versão segue estritamente SemVer 2.0.0?
- [ ] Se houve alteração de EFI (`config.plist`), o arquivo foi espelhado com perfeição tanto no repositório local quanto na partição EFI ativa montada (ex: `Y:\EFI\OC\config.plist`), sem introduzir BOM (UTF-8 puro)?
- [ ] O arquivo `CHANGELOG.md` foi atualizado com a nova versão e o fechamento do erro?
- [ ] O `README.md` teve suas referências de versão e links de download atualizados?
- [ ] O commit foi criado com mensagem padronizada (Conventional Commits)?
- [ ] A tag Git (`vX.Y.Z`) foi gerada e enviada ao repositório remoto?

---

## 6. Regras Adicionais (aprendidas em out/2026)

1. **Hipótese não é causa raiz.** No `CHANGELOG.md` e nos commits, rotule como 🔶 *hipótese* tudo o que não foi comprovado. Só marque **Resolvido** quando o **dono confirmar no hardware**. (A v1.3.2 foi publicada como "resolvida" sem confirmação e precisou ser revertida na v1.3.3.)
2. **Uma mudança de comportamento por versão.** Nunca combine várias flags de GPU/CPU no mesmo teste; assim a reversão e o diagnóstico são possíveis.
3. **Reversão é uma versão.** Reverter uma tentativa fracassada gera um novo PATCH (ex.: v1.3.3 reverte a v1.3.2); **não** reescreva nem apague tags públicas.
4. **Release só existe se tiver arquivos.** Antes de linkar downloads no `README.md`, publique a release e confira pela API: `https://api.github.com/repos/nepotira/HP-Elite-c1030-Hackintosh/releases` (nome do arquivo, tamanho > 0).
5. **Segredos nunca entram no Git:** senhas de Wi-Fi, seriais/MLB/ROM reais, tokens. Credenciais de Wi-Fi do `itlwm.kext` ficam apenas na EFI local.
6. **Mudança só de documentação = PATCH** (ex.: v1.3.4). Informe no changelog que a EFI não mudou.
7. **Ao concluir, atualize o histórico:** novos fatos relevantes vão para `docs/HISTORICO_DO_PROJETO.md` e, se forem problemas, para `docs/TROUBLESHOOTING.md`.