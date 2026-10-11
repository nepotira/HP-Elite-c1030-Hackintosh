# 🖥️ Escala HiDPI Nativa 3:2 (Modo Retina) para HP Elite c1030

Utilitário de injeção de resoluções **HiDPI (Retina)** sob medida para a tela **IPS 13.5" na proporção 3:2 (1920 × 1280)** do Chromebook HP Elite c1030 executando macOS Tahoe / Sequoia / Sonoma.

---

## 🧐 O que é e por que isso é necessário?

O HP Elite c1030 possui uma tela incrível de alta resolução (**1920 × 1280** em formato **3:2**). No entanto, em 13.5 polegadas, usar 1920×1280 em escala 100% (1x) deixa as fontes, botões e janelas um pouco pequenos para a leitura diária.

* **No Windows:** Você simplesmente arrasta o slider para **125%**, e o Windows amplia os elementos mantendo a tela nítida.
* **No macOS:** A Apple lida com escala através do motor **HiDPI (Retina)**. Por padrão, o macOS só libera os botões de escala se a tela for reconhecida como um monitor oficial da Apple ou 4K/5K. Monitores de terceiros em 1080p/1280p ficam restritos apenas ao modo bruto 1x. Se você tenta escolher uma resolução menor comum (ex: 1280×853), a tela fica **completamente borrada**.

### 🔍 Por que o script `one-key-hidpi` genérico não funcionava antes?
O script clássico `one-key-hidpi` da comunidade foi desenvolvido pensando em notebooks com proporção padrão **16:9** (1920×1080) ou Surface Book 3K (3000×2000):
1. Ao selecionar a opção 1080p, ele injetava resoluções 16:9 (`1680x945`, `1440x810`, `1280x720`).
2. O macOS detectava a disparidade entre a tela física interna (**3:2**) e as resoluções HiDPI (**16:9**) e descartava todas elas para evitar distorção ou faixas pretas.
3. Este módulo corrige isso **100%**: geramos e injetamos uma tabela de **44 modos exclusivos na proporção nativa 3:2**.

---

## 🚀 Como funciona o HiDPI nos bastidores?

> [!NOTE]
> **Ele diminui a resolução da tela? NÃO!**  
> A placa de vídeo (Intel UHD 630) continua enviando **1920 × 1280 a 60Hz cravados** para o painel físico. Nenhum pixel é perdido.

Quando você seleciona a escala recomendada de **125% (que o macOS chama de "1536 × 1024")**:
1. O macOS renderiza a interface internamente no **dobro da resolução (3072 × 2048)** com gráficos vetoriais cristalinos.
2. A placa gráfica faz uma super-amostragem (*downsampling*) para os **1920 × 1280** físicos da tela em tempo real.
3. O resultado é exatamente a mesma ergonomia dos **125% do Windows**, mas com a **nitidez perfeita de uma tela Retina da Apple**.

---

## 📊 Tabela de Escalas 3:2 Disponíveis

| Escala Equivalente | Resolução Lógica (UI) | Buffer de Renderização (2x) | Experiência Visual |
| :---: | :---: | :---: | :--- |
| **100%** | **1920 × 1280** | 3840 × 2560 | Espaço máximo / Elementos compactos |
| **~111%** | **1728 × 1152** | 3456 × 2304 | Leve ampliação |
| **~114%** | **1680 × 1120** | 3360 × 2240 | Equilíbrio entre espaço e conforto |
| **~120%** | **1600 × 1067** | 3200 × 2134 | Texto bastante confortável |
| **125% 🌟** | **1536 × 1024** | **3072 × 2048** | **Ponto ideal (Sweet Spot)!** Idêntico aos 125% do Windows |
| **133%** | **1440 × 960** | 2880 × 1920 | Ícones e textos grandes |
| **143%** | **1344 × 896** | 2688 × 1792 | Alta legibilidade |
| **150%** | **1280 × 854** | 2560 × 1708 | Elementos bem grandes |
| **200%** | **960 × 640** | 1920 × 1280 | Modo Retina 2x integer |

---

## ⚡ Como Ativar

Abra o Terminal na pasta onde estão os scripts e execute:

```bash
sudo ./ativar_hidpi_3x2.sh
```

O script irá:
1. Criar a pasta de substituição do monitor em `/Library/Displays/Contents/Resources/Overrides/DisplayVendorID-30e4/`.
2. Injetar o arquivo `DisplayProductID-663` com a tabela 3:2 completa.
3. Instalar o ícone oficial de MacBook Pro para o monitor interno.
4. Habilitar a chave `DisplayResolutionEnabled = 1` no WindowServer do macOS.

👉 **Após executar, reinicie o notebook (Menu Apple  ➔ Reiniciar).**

Ao religar:
* Vá em **Ajustes do Sistema ➔ Telas**: os botões de escala estarão disponíveis nativamente.
* Ou abra o **BetterDisplay**: as resoluções 3:2 HiDPI aparecerão diretamente no menu de contexto com 1 clique.

---

## 🔄 Como Desativar (Restaurar Padrão de Fábrica)

Se por qualquer motivo desejar remover o override e voltar ao padrão original do macOS:

```bash
sudo ./desativar_hidpi.sh
```

Depois reinicie o computador.

---

## 🤝 Créditos e Licença

* **Projeto Base / Conceito:** [xzhih/one-key-hidpi](https://github.com/xzhih/one-key-hidpi) (Licença MIT).
* **Adaptação & Engenharia 3:2:** [nepotira](https://github.com/nepotira) — Criação da matriz matemática para painel IPS 13.5" (1920×1280) e compatibilidade com macOS 26 Tahoe / Sequoia no HP Elite c1030.
