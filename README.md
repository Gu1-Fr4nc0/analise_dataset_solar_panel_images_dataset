# Análise Exploratória e Extração de Características: Solar Panel Images

Este projeto realiza uma análise profunda e extração de características (feature extraction) de um dataset de imagens de painéis solares. O objetivo é identificar padrões visuais que distinguem diferentes tipos de danos e estados de conservação, servindo como base para modelos de classificação automática.

## 🚀 Metodologia

O fluxo de trabalho utiliza processamento digital de imagens em linguagem **R** para quantificar informações que olhos humanos percebem apenas qualitativamente.

A análise foca em três pilares principais:
* **Distribuição Espectral:** Análise de histogramas RGB para identificar assinaturas de cor (ex: o azul dominante em painéis limpos vs. o branco saturado em painéis cobertos por neve).
* **Métricas de Luminância:** Cálculo de brilho médio e contraste para diferenciar poeira (*dust*) de danos físicos.
* **Proporção de Pixels Escuros:** Utilizada para identificar sombreamentos ou falhas elétricas específicas.

## 📊 Estatísticas do Dataset

Atualmente, o projeto analisa 6 categorias de imagens. A distribuição amostral é fundamental para entender o viés do modelo:

| Categoria | Estado | Observação Principal |
| :--- | :---: | :--- |
| **Clean** | Saudável | Alta concentração no canal Azul (B) |
| **Dusty** | Sujo | Redução de contraste e brilho médio |
| **Bird-drop** | Obstruído | Pontos focais de alta variação local |
| **Electrical-damage** | Falha | Padrões de cores anômalos |
| **Physical-Damage** | Falha | Mudança na textura superficial |
| **Snow-Covered** | Obstruído | Saturação total dos canais RGB |

### Extração de Características (Features)
As principais métricas extraídas via script para cada imagem incluem:
1. **Brilho Médio:** $\mu = \frac{1}{N} \sum_{i=1}^{N} P_i$
2. **Contraste (Desvio Padrão):** $\sigma = \sqrt{\frac{1}{N} \sum_{i=1}^{N} (P_i - \mu)^2}$
3. **Médias RGB:** Intensidade média por canal cromático.

## 📈 Visualizações

<p align="center">
  <img src="Distribuicao por Categoria.webp" width="45%" alt="Distribuição por Categoria" />
  <img src="Histogramas RGB por Categoria.webp" width="45%" alt="Histogramas RGB" />
</p>

## 📂 Estrutura do Repositório

* `Iniciacao Cientifica.R`: Script principal contendo a esteira de processamento e geração de gráficos.
* `Iniciacao Cientifica.Rproj`: Arquivo de projeto do RStudio.
* `*.webp`: Gráficos exportados da análise exploratória.
* `.gitignore`: Configuração para evitar o upload de arquivos temporários (`.RData`, `.Rhistory`).

## 🛠️ Como Reproduzir

1. **Clone o repositório:**
   ```bash
   git clone [https://github.com/SeuUsuario/analise_dataset_solar_panel.git](https://github.com/SeuUsuario/analise_dataset_solar_panel.git)
2.Dependências:** No R, instale os pacotes necessários:
   ```bash
   install.packages(c("tidyverse", "magick", "imager", "ggplot2"))
   ```
3. **Dataset:** Obtenha o dataset de painéis solares e coloque-o na pasta archive/Faulty_solar_panel.

4. **Execução:** Abra o arquivo .Rproj e execute o script Iniciacao Cientifica.R.
