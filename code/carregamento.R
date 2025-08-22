#--------------------------------------------
#- Carregamento dos dados para um bucket S3 - 
#--------------------------------------------

# Função que carrega os dados para o bucket S3
funcao_carregamento <- function() {
  tryCatch({
    # Importa os microdados de cursos e ies
    caminho_micro_cur <- here("data", "bronze", "unzip", "microdados_censo_da_educacao_superior_2023", "dados", "MICRODADOS_CADASTRO_CURSOS_2023.CSV")
    caminho_micro_ies <- here("data", "bronze", "unzip", "microdados_censo_da_educacao_superior_2023", "dados", "MICRODADOS_ED_SUP_IES_2023.CSV")
    micro_cur <- data.table::fread(input = caminho_micro_cur, encoding="Latin-1")
    cat("Microdados de cursos lido com sucesso!\n")
    micro_ies <- data.table::fread(input = caminho_micro_ies, encoding="Latin-1")
    cat("Microdados de IES lido com sucesso!\n")
    # Verifica existência do bucket
    bucket_exists(bucket = "profissaodocente-inepdata-s3", region = "us-east-1")
    cat("Bucket existe!\n")
    # Converte para parquet e carrega para S3
    arrow::write_dataset(dataset = micro_cur, path = "s3://profissaodocente-inepdata-s3/inep/bronze/microsuperior2023_cur", format = "parquet", partitioning = c("TP_MODALIDADE_ENSINO"))
    arrow::write_dataset(dataset = micro_ies, path = "s3://profissaodocente-inepdata-s3/inep/bronze/microsuperior2023_ies", format = "parquet")
    cat("Dados carregados para S3 com sucesso!\n")
    # Exclui pasta zip 
    file.remove(here("data", "bronze", "censosuperior_23.zip"))
    # Exclui arquivos da pasta local
    unlink(here("data", "bronze", "unzip"), recursive = TRUE)
  }, error = function(e) {
    # Erro
    cat("Ocorreu o seguinte erro:", conditionMessage(e), "\n")
  }, warning = function(w) {
    # Aviso
    cat("Um aviso apareceu:", conditionMessage(w), "\n")
  })
}




