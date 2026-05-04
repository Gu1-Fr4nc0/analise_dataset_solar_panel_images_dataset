# Análise Exploratória: Solar Panel Image Dataset

Este projeto realiza uma Análise Exploratória de Dados (EDA) em um dataset de imagens de painéis solares para identificar padrões em diferentes categorias de falhas e estados de conservação.

## 📌 Objetivo
Utilizar a linguagem R para extrair estatísticas de cor, brilho e distribuição das imagens, preparando o terreno para futuros modelos de classificação (como Redes Neurais ou Perceptrons).

## 📊 Resultados da Análise

### 1. Distribuição do Dataset
O dataset é composto por 6 categorias. A análise abaixo mostra a quantidade de amostras por classe, revelando o equilíbrio (ou desequilíbrio) dos dados.

![Distribuição por Categoria](Distribuicao%20por%20Categoria.webp)

### 2. Análise de Cores (Canais RGB)
Foram gerados histogramas para entender como a intensidade luminosa se comporta em cada falha. Por exemplo, a categoria **Snow-Covered** apresenta picos de alta intensidade em todos os canais devido ao branco da neve.

![Histogramas RGB](Histogramas%20RGB%20por%20Categoria.webp)

## 🛠️ Tecnologias Utilizadas
* **Linguagem:** R
* **Bibliotecas:** * `tidyverse` (Manipulação de dados e gráficos)
    * `magick` & `imager` (Processamento de imagem)
    * `ggplot2` (Visualização de dados)

## 📂 Como executar
1. Clone o repositório:
   ```bash
   git clone [https://github.com/SeuUsuario/analise_dataset_solar_panel.git](https://github.com/SeuUsuario/analise_dataset_solar_panel.git)
