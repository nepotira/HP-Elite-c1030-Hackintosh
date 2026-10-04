# 🪟 Guia de Sobrevivência e Dicas para quem vem do Windows no macOS

Se você está acostumado com o fluxo de trabalho do Windows e acabou de entrar no mundo do macOS (especialmente neste Hackintosh no **HP Elite c1030 Chromebook**), este guia reúne os principais utilitários, atalhos e configurações essenciais para deixar o sistema tão produtivo e intuitivo quanto o Windows, eliminando choques culturais.

---

## 🖱️ 1. O Mouse e o Trackpad: LinearMouse (Indispensável)

No macOS nativo, o sistema possui duas particularidades que incomodam quem usa mouse tradicional:
1. **Rolagem Acoplada:** Se você define que o trackpad use "Rolagem Natural", o scroll da rodinha do mouse também é invertido.
2. **Aceleração Agressiva da Apple:** O cursor de mouses USB/Bluetooth comuns parece "pesado" ou impreciso por conta da curva de aceleração da Apple.

### A Solução: **LinearMouse**
O [LinearMouse](https://linearmouse.app/) (aplicativo gratuito e de código aberto) resolve tudo isso perfeitamente:
* Desacopla o mouse do trackpad (deixa o scroll do mouse tradicional e o do trackpad com gestos naturais).
* Desativa a aceleração artificial do ponteiro (resposta 1:1 exata como no Windows).
* Ajusta a velocidade e a suavidade da rodinha de rolagem.

> **💡 Como iniciar automaticamente junto com o sistema:**  
> 1. No próprio LinearMouse: clique no ícone na barra de menus superior -> `Settings` (Configurações) -> aba `General` -> marque **"Start at login"**.  
> 2. No macOS: abra `Ajustes do Sistema -> Geral -> Itens de Início` e adicione o **LinearMouse.app** na lista de "Abrir no Início de Sessão".

---

## 🪟 2. Gerenciamento de Janelas (Snap estilo Windows): Rectangle

No Windows, arrastar uma janela para as bordas divide a tela em metades ou quartos, e `Win + Setas` organiza seu espaço de trabalho instantaneamente. No macOS puro, o gerenciamento de janelas padrão é bastante limitado.

### A Solução: **Rectangle**
Baixe o [Rectangle](https://rectangleapp.com/) (gratuito e open-source). Ele replica com perfeição a experiência do Windows:
* **Snap por Arrastar:** Arraste a janela até a borda esquerda/direita para dividir em 50%; arraste para o topo para maximizar; arraste para os cantos para dividir em 4 telas.
* **Atalhos de Teclado:**
  * `Ctrl + Option + Seta Esquerda` -> Janela na metade esquerda
  * `Ctrl + Option + Seta Direita` -> Janela na metade direita
  * `Ctrl + Option + Enter` -> Maximizar janela
  * `Ctrl + Option + C` -> Centralizar janela

---

## 🔄 3. Alternador de Janelas com Miniaturas: AltTab

No macOS padrão, o atalho `Cmd + Tab` alterna apenas entre os **ícones dos programas abertos**, e não entre as janelas individuais com miniaturas visuais.

### A Solução: **AltTab for macOS**
O [AltTab](https://alt-tab-macos.netlify.app/) (gratuito e open-source) traz exatamente o visual e o comportamento do Alt+Tab do Windows:
* Exibe miniaturas em tempo real de cada janela aberta.
* Permite fechar janelas diretamente pelo menu com `X` ou tecla `W`.
* Permite minimizar janelas ou puxar janelas de outros monitores.

---

## ⌨️ 4. Atalhos e Diferenças Críticas no Teclado

### A Regra de Ouro: Command (`Cmd`) substitui o Control (`Ctrl`)
A maioria dos atalhos clássicos do Windows utiliza a tecla **Command** (`⌘`) no macOS:

| Ação no Windows | Atalho no Windows | Atalho Equivalente no macOS |
| :--- | :--- | :--- |
| **Copiar** | `Ctrl + C` | `Cmd + C` |
| **Colar** | `Ctrl + V` | `Cmd + V` |
| **Recortar** | `Ctrl + X` | `Cmd + X` |
| **Desfazer** | `Ctrl + Z` | `Cmd + Z` |
| **Salvar** | `Ctrl + S` | `Cmd + S` |
| **Selecionar Tudo** | `Ctrl + A` | `Cmd + A` |
| **Nova Aba** | `Ctrl + T` | `Cmd + T` |
| **Fechar Aba** | `Ctrl + W` | `Cmd + W` |
| **Pesquisar** | `Ctrl + F` | `Cmd + F` |
| **Busca Global (Spotlight)** | Tecla Windows | `Cmd + Espaço` |

### A Diferença do `Enter` e do `Delete` no Finder (Arquivos):
* **Tecla `Enter`:** No Windows, abre o arquivo selecionado. **No macOS, a tecla Enter serve para renomear o arquivo!**  
  👉 Para abrir um arquivo no Finder pelo teclado: use **`Cmd + O`** ou **`Cmd + Seta para Baixo`** (ou dê duplo clique).
* **Tecla `Delete`:** No Finder, pressionar Delete sozinho não move para a lixeira.  
  👉 Para apagar um arquivo: use **`Cmd + Delete`**. Para esvaziar a Lixeira: **`Cmd + Shift + Delete`**.

### ⚠️ Fechar Janela (`X` Vermelho) vs Encerrar Aplicativo:
* No Windows, clicar no `X` fecha o programa e o remove da memória.
* No macOS, clicar na bolinha vermelha apenas fecha a **janela visual**; o programa continua rodando em segundo plano (você verá uma bolinha luminosa abaixo do ícone dele no Dock).
* **Para fechar o programa de verdade:** use o atalho **`Cmd + Q`** (Quit) ou clique com o botão direito no ícone do aplicativo no Dock e selecione **Encerrar**.

---

## ⚙️ 5. Configurações do Sistema Recomendadas

1. **Toque Leve no Trackpad (Sem afundar o botão):**
   * Vá em `Ajustes do Sistema -> Trackpad`.
   * Ative a opção **"Tocar para clicar"** (*Tap to click*). Você poderá clicar apenas encostando levemente o dedo na superfície.
2. **Ocultar o Dock Automaticamente (Mais espaço na tela 3:2):**
   * Vá em `Ajustes do Sistema -> Mesa e Dock`.
   * Ative **"Ocultar e exibir o Dock automaticamente"** (Atalho rápido: `Option + Cmd + D`).
   * Isso aproveita 100% da resolução vertical (1280px) do HP Elite c1030 para suas janelas e produtividade.
3. **Remapeamento de Teclas Modificadoras (Opcional):**
   * Se sua memória muscular estiver muito acostumada a apertar a tecla da ponta esquerda para copiar/colar:
   * Vá em `Ajustes do Sistema -> Teclado -> Atalhos de Teclado -> Teclas Modificadoras`.
   * Selecione seu teclado e você pode trocar a função da tecla `Control` para se comportar como `Command`.
