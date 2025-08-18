#-----------------------------------------------------------------
#- Extração da pasta ZIP com dados do Censo da Educação Superior - 
#-----------------------------------------------------------------

# Função que realiza o download dos dados do Censo e extrai os dados do ZIP
funcao_extracao <- function(caminho_censosuperior) {
  # Definição do destino da pasta 
  destino_censosuperior <- here("data", "bronze", "censosuperior_23.zip")
  # Download e unzip dos dados
  tryCatch({
    # Download dos dados
    download.file(url = caminho_censosuperior, destfile = destino_censosuperior, mode = "wb")
    cat("Download realizado com sucesso!\n")
    # Caminho para os arquivos
    destino_unzip_censosuperior <- here("data", "bronze", "unzip")
    # Unzip 
    archive::archive_extract(archive = destino_censosuperior, dir = destino_unzip_censosuperior)
    cat("Extração dos dados realizada com sucesso!\n")
  }, error = function(e) {
    # Erro
    cat("Ocorrou o seguinte erro:", conditionMessage(e), "\n")
  }, warning = function(w) {
    # Aviso
    cat("Um aviso apareceu:", conditionMessage(w), "\n")
  })
}



