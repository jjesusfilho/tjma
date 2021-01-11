#' Baixa consulta jurisprudencial do TJMA
#'
#' @param livre palavra ou texto a ser buscado nas ementas e nos acórdãos
#' @param aspas lógico. Colocar a expressão entre aspas?
#' @param classe Código da classe processual
#' @param assunto Código do assunto
#' @param orgao_julgador Código do órgão julgador
#' @param inicio_julg  data inicial julgamento
#' @param fim_julg  Data final julgamento
#' @param inicio_pb data inicial registro/publicação
#' @param fim_pb    data final registr/publicacao
#' @param tipo "A" Para acórdãos, "D" para decisões monocráticas
#' @param n Número de páginas
#' @param diretorio Diretório onde serão armazenadas as páginas html
#' @keywords tjsp,acórdãos
#'
#' @return baixa os htmls das decisões de segunda instância
#' @export
#'
#' @examples
#' \dontrun{
#' baixar_cjsg(livre = "Lei Maria da Penha")
#' }
#'
tjma_baixar_cjsg <-
  function(
        livre = "",
           aspas = FALSE,
           classe = "",
           assunto = "",
           orgao_julgador = "",
           inicio_julg = "",
           fim_julg = "",
           inicio_pb = "",
           fim_pb = "",
           tipo = "A",
           n = NULL,
           diretorio = ".") {
    httr::set_config(httr::config(
      ssl_verifypeer = FALSE,
      accept_encoding = "latin1"
    ))

    if (aspas == TRUE) livre <- deparse(livre)


    body <-
      list(
        dados.buscaInteiroTeor = livre,
        dados.pesquisarComSinonimos = "S",
        dados.pesquisarComSinonimos = "S",
        dados.buscaEmenta = "",
        dados.nuProcOrigem = "",
        dados.nuRegistro = "",
        agenteSelectedEntitiesList = "",
        contadoragente = "0",
        contadorMaioragente = "0",
        codigoCr = "",
        codigoTr = "",
        nmAgente = "",
        juizProlatorSelectedEntitiesList = "",
        contadorjuizProlator = "0",
        contadorMaiorjuizProlator = "0",
        codigoJuizCr = "",
        codigoJuizTr = "",
        nmJuiz = "",
        classesTreeSelection.values = classe,
        classesTreeSelection.text = "",
        assuntosTreeSelection.values = assunto,
        assuntosTreeSelection.text = "",
        comarcaSelectedEntitiesList = "",
        contadorcomarca = "0",
        contadorMaiorcomarca = "0",
        cdComarca = "",
        nmComarca = "",
        secoesTreeSelection.values = orgao_julgador,
        secoesTreeSelection.text = "",
        dados.dtJulgamentoInicio = inicio_julg,
        dados.dtJulgamentoFim = fim_julg,
        dados.dtRegistroInicio = inicio_pb,
        dados.dtRegistroFim = fim_pb,
        dados.origensSelecionadas = "T",
        tipoDecisaoSelecionados = tipo,
        dados.ordenacao = "dtPublicacao"
      )

    a <-
      httr::POST(
        "https://consultasaj.tjam.jus.br/cjsg/resultadoCompleta.do",
        encode = "form",
        body = body,
        httr::accept("text/html; charset=latin1;")
      )

    if (!is.null(n)){

      paginas <- 1:n

      pb <- progress::progress_bar$new(total = n)


    } else {


      max_pag <- a %>%
        httr::content() %>%
        xml2::xml_find_all(xpath = "//*[@id='totalResultadoAba-A']|//*[@id='totalResultadoAba-D']") %>%
        xml2::xml_attrs() %>%
        .[[1]] %>%
        .[3] %>%
        as.numeric() %>%
        `/`(20) %>%
        ceiling()



      paginas <- 1:max_pag


      pb <- progress::progress_bar$new(total = max_pag)

    }

    if (tipo == "A") {


      purrr::map(paginas, purrr::possibly(~{

        pb$tick()

        Sys.sleep(1)
       s<- httr::GET(
          paste0(
            "https://consultasaj.tjam.jus.br/cjsg/trocaDePagina.do?tipoDeDecisao=A&pagina=",.x,"&conversationId="
          ),
          httr::set_cookies(unlist(a$cookies)),
          httr::accept("text/html; charset=latin1;"),
          httr::write_disk(paste0(diretorio, "/pagina_", .x, ".html"),
                           overwrite = TRUE
          )
        )
      }, NULL))
    } else {
      purrr::map(paginas, purrr::possibly(~ {

        pb$tick()

        Sys.sleep(1)

        httr::GET(
          paste0(
            "https://consultasaj.tjam.jus.br/cjsg/trocaDePagina.do?tipoDeDecisao=D&pagina=",.x,"&conversationId="
          ),
          httr::set_cookies(unlist(a$cookies)),
          httr::write_disk(paste0(diretorio, "/pagina_", .x, ".html"),
                           overwrite = TRUE
          )
        )
        # httr::write_disk(paste0(diretorio, "/pagina_", .x,".html"), overwrite = TRUE)
      }, NULL))
    }
  }