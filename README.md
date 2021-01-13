
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tjma

<!-- badges: start -->

[![R build
status](https://github.com/jjesusfilho/tjma/workflows/R-CMD-check/badge.svg)](https://github.com/jjesusfilho/tjma/actions)
<!-- badges: end -->

O Objetivo deste pacote é coletar, organizar e analisar dados do
Tribunal de Justiça do Maranhão

## Intalação

Para instalar a versão em desenvolvimente, proceda da seguinte forma no
console do R:

``` r
remotes::install_github("jjesusfilho/tjma")
```

## Utilização

Por ora, há apenas uma função para baixar a jurisprudência do TJMA. Ela
salva as tabelas em rds. Depois disso, basta ler.

``` r
library(tjma)
library(purrr)

dir.create("tjma_cjsg")

tjma_baixar_cjsg(livre = "indígena", diretorio = "tjma_cjsg")

arquivos <- list.files("tjma_cjsg", full.names = TRUE, pattern = "rds$")

cjsg <- map_dfr(arquivos, readRDS)
```
