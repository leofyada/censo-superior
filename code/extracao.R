#-----------------------------------------------------------------
#- Extração da pasta ZIP com dados do Censo da Educação Superior - 
#-----------------------------------------------------------------

# Caminho para a pasta ZIP
caminho_censosuperior <- "https://download.inep.gov.br/microdados/microdados_censo_da_educacao_superior_2023.zip"
# Caminho de destino da pasta baixada
destino_censosuperior <- here("data", "censosuperior_23.zip")
# Download
download.file(url = caminho_censosuperior, destfile = destino_censosuperior, mode = "wb") 
# Caminho para os arquivos
destino_unzip_censosuperior <- here("data", "unzip")
# Unzip 
archive::archive_extract(archive = destino_censosuperior, dir = destino_unzip_censosuperior)

