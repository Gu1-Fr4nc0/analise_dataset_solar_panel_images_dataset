# ================================
# ANÁLISE EXPLORATÓRIA DE IMAGENS
# Projeto: Solar Panel Defect Detection
# Linguagem: R (com magick + imager)
# Autor: Guilherme Pança Franco
# ================================

library(magrittr)
library(imager)
library(ggplot2)
library(tidyverse)
library(magick)

# ---- DEFINA O CAMINHO DO SEU DATASET ----
dataset_path <- "archive/Faulty_solar_panel"  # <- altere aqui

# ---- 1. LISTAR CATEGORIAS E CONTAR NÚMERO DE IMAGENS POR CATEGORIA ----
categorias <- list.dirs(dataset_path, recursive = FALSE)
nomes_categorias <- basename(categorias)

qtd_imgs <- sapply(categorias, function(path) {
  length(list.files(path, pattern = "\\.(jpg|png|jpeg)$"))
})

df_categorias <- data.frame(Categoria = nomes_categorias, Quantidade = qtd_imgs)

# Visualizar contagem
print(df_categorias)

# Gráfico de barras
ggplot(df_categorias, aes(x = Categoria, y = Quantidade, fill = Categoria)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Quantidade de Imagens por Categoria", y = "Nº de Imagens", x = "Categoria")

# ---- 2. VERIFICAR DIMENSÕES DAS IMAGENS POR CATEGORIA ----
get_image_dimensions <- function(img_path) {
  img <- image_read(img_path)
  info <- image_info(img)
  return(c(width = info$width, height = info$height))
}

df_dim <- lapply(categorias, function(path) {
  arquivos <- list.files(path, pattern = "\\.(jpg|png|jpeg)$", full.names = TRUE)
  if (length(arquivos) > 0) {
    img_dim <- get_image_dimensions(arquivos[1])
    data.frame(Categoria = basename(path), Largura = img_dim["width"], Altura = img_dim["height"])
  }
}) %>% bind_rows()

print(df_dim)

# ---- 3. HISTOGRAMAS RGB USANDO IMAGER ----
gerar_histograma_rgb <- function(img_path, categoria) {
  imagem <- load.image(img_path)
  
  # Separar canais R, G, B
  canais <- imsplit(imagem, "c")
  nomes_canais <- c("R", "G", "B")
  dados <- data.frame()
  
  for (i in 1:3) {
    canal_dados <- as.vector(canais[[i]])
    df_canal <- data.frame(
      Intensidade = canal_dados,
      Canal = nomes_canais[i],
      Categoria = categoria
    )
    dados <- rbind(dados, df_canal)
  }
  
  return(dados)
}

# Gerar dados de histograma para uma imagem de cada categoria
dados_histogramas <- do.call(rbind, lapply(categorias, function(cat_path) {
  arquivos <- list.files(cat_path, pattern = "\\.(jpg|jpeg|png)$", full.names = TRUE)
  if (length(arquivos) > 0) {
    gerar_histograma_rgb(arquivos[1], basename(cat_path))
  } else {
    NULL
  }
}))

# Plotar histogramas
ggplot(dados_histogramas, aes(x = Intensidade, fill = Canal)) +
  geom_histogram(bins = 30, alpha = 0.6, position = "identity") +
  facet_wrap(~ Categoria, scales = "free_y") +
  scale_fill_manual(values = c("R" = "red", "G" = "green", "B" = "blue")) +
  theme_minimal() +
  labs(title = "Histogramas RGB por Categoria", x = "Intensidade (0-1)", y = "Frequência")

# ---- 4. VERIFICAR IMAGENS CORROMPIDAS ----
verificar_imagens <- function(path) {
  arquivos <- list.files(path, pattern = "\\.(jpg|png|jpeg)$", full.names = TRUE)
  problemas <- c()
  for (img_path in arquivos) {
    tryCatch({
      image_info(image_read(img_path))
    }, error = function(e) {
      problemas <<- c(problemas, img_path)
    })
  }
  return(problemas)
}

problemas_total <- lapply(categorias, verificar_imagens)
names(problemas_total) <- nomes_categorias
print(problemas_total)

# ---- 5. CÁLCULO DE BRILHO E CONTRASTE ----
get_brilho_contraste <- function(img_path) {
  img <- image_read(img_path)
  img_gray <- image_convert(img, colorspace = "gray")
  pixels <- as.numeric(image_data(img_gray)[1,,])
  
  brilho_medio <- mean(pixels)
  contraste <- sd(pixels)
  
  return(c(brilho = brilho_medio, contraste = contraste))
}

df_brilho_contraste <- lapply(categorias, function(path) {
  arquivos <- list.files(path, pattern = "\\.(jpg|png|jpeg)$", full.names = TRUE)
  if (length(arquivos) > 0) {
    val <- get_brilho_contraste(arquivos[1])
    data.frame(Categoria = basename(path), Brilho = val[1], Contraste = val[2])
  }
}) %>% bind_rows()

print(df_brilho_contraste)

# ---- 6. PROPORÇÃO DE PIXELS ESCUROS ----
calc_proporcao_escura <- function(img_path, limiar = 50) {
  img <- image_read(img_path)
  gray <- image_convert(img, colorspace = "gray")
  pixel_matrix <- as.integer(image_data(gray)[1,,])
  total <- length(pixel_matrix)
  escuros <- sum(pixel_matrix < limiar)
  return(escuros / total)
}

df_escura <- lapply(categorias, function(path) {
  arquivos <- list.files(path, pattern = "\\.(jpg|png|jpeg)$", full.names = TRUE)
  if (length(arquivos) > 0) {
    prop <- calc_proporcao_escura(arquivos[1])
    data.frame(Categoria = basename(path), ProporcaoEscura = prop)
  }
}) %>% bind_rows()

print(df_escura)

# ---- 7. MÉDIA DOS CANAIS RGB ----
get_rgb_medio <- function(img_path) {
  img <- image_read(img_path)
  arr <- image_data(img)
  r <- mean(as.integer(arr[1,,]))
  g <- mean(as.integer(arr[2,,]))
  b <- mean(as.integer(arr[3,,]))
  return(c(R = r, G = g, B = b))
}

df_cores <- lapply(categorias, function(path) {
  arquivos <- list.files(path, pattern = "\\.(jpg|png|jpeg)$", full.names = TRUE)
  if (length(arquivos) > 0) {
    medias <- get_rgb_medio(arquivos[1])
    data.frame(Categoria = basename(path), R = medias[1], G = medias[2], B = medias[3])
  }
}) %>% bind_rows()

print(df_cores)