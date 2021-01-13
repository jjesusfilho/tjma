#' Baixar jurisprudência do TJMA
#'
#' @param chave Campo busca livre. Se não informado, irá buscar
#'     palavra "tribunal"
#' @param data_inicio Data inicial da publicação no formato dd/mm/aaaa
#' @param data_fim Data final da publicação no formato dd/mm/aaaa
#' @param sistema ThemisSG ou PGE2G
#' @param relator Nome do relator
#' @param revisor Nome do revisor
#' @param camara Câmara
#' @param tipo_pesquisa 1 para ementa, 2 para advogado,
#'     3 para número do acórdão, 4 para número do processo
#' @param diretorio Diretório onde armazenar os dados
#'
#' @return As tabelas são convertidas em rds e salvas no
#'     diretório informado
#' @export
#'
tjma_baixar_cjsg <- function(
  chave = "",
  data_inicio = "",
  data_fim = "",
  sistema = "0",
  relator = "0",
  revisor = "0",
  camara = "0",
  tipo_pesquisa = "1",
  diretorio = "."){

  if (chave == ""){

    chave <-  "tribunal"

  }

  if (data_inicio != ""){

    data_inicio <- lubridate::dmy(data_inicio)

    data_fim <- lubridate::dmy(data_fim)

    check_todas_datas <- "1"

  } else {

    check_todas_datas <- "0"

  }

  url <- "https://apijuris.tjma.jus.br/v1/sg/jurisprudencias/processos?sistema=0&relator=0&revisor=0&camara=0&tipoPesquisa=1&chave&condicao=3&dtaInicio=&dtaFim=&checkTodasDatas=0&inicioPagina=1&fimPagina=20"

  parseada <- httr::parse_url(url)


  lista <- FALSE

  inicio_pagina <-1
  fim_pagina <- 20


  repeat {

    query <-
      list(
        sistema = sistema,
        relator = relator,
        revisor = revisor,
        camara = camara,
        tipoPesquisa = tipo_pesquisa,
        chave = chave,
        condicao = "3",
        dtaInicio = data_inicio,
        dtaFim = data_fim,
        checkTodasDatas = check_todas_datas,
        inicioPagina = inicio_pagina,
        fimPagina = fim_pagina
      )


    parseada$query <- query

    url2 <- httr::build_url(parseada)

    d <- jsonlite::fromJSON(url2)

    lista <- rlang::is_empty(d$response)

    if (lista == TRUE){
      break
    }

    arquivo <- file.path(diretorio, paste0("cjsg_",inicio_pagina,"_",fim_pagina,".rds"))

    saveRDS(d$response[[1]],arquivo)

    #df <- dplyr::bind_rows(d$response[[1]])

    inicio_pagina <- inicio_pagina + 20

    fim_pagina <- fim_pagina + 20

  }
}
