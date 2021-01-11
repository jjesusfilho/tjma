
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

Por ora, há apenas duas funções para baixar a jurisprudência do TJMA e
lê-las, respectivamente.

``` r
library(tjma)
dir.create("tjma_cjsg")
tjma_baixar_cjsg(livre = "indígena", diretorio = "tjma_cjsg")
cjsg <- tjma_ler_cjsg(diretorio = "tjma_cjsg")
```
