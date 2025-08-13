#--------------------------------------------
#- Carregamento dos dados para um bucket S3 - 
#--------------------------------------------

# Importa os microdados de cursos e ies
caminho_micro_cur <- here("data", "unzip", "microdados_censo_da_educacao_superior_2023", "dados", "MICRODADOS_CADASTRO_CURSOS_2023.CSV")
caminho_micro_ies <- here("data", "unzip", "microdados_censo_da_educacao_superior_2023", "dados", "MICRODADOS_ED_SUP_IES_2023.CSV")
micro_cur <- data.table::fread(input = caminho_micro_cur, encoding="Latin-1")
micro_ies <- data.table::fread(input = caminho_micro_ies, encoding="Latin-1")

# Análise para particionamento da tabela de cursos
micro_cur %>% 
  group_by(TP_MODALIDADE_ENSINO) %>% 
  tally()

# 1 - 35.739
# 2 - 635.871

# Pariticionar a tabela por modalidade de ensino, já que o foco da 
# análise são os cursos à distância

# Verifica existência do bucket
bucket_exists(bucket = "profissaodocente-inepdata-s3", region = "us-east-1")
# Converte para parquet e carrega para S3
arrow::write_dataset(dataset = micro_cur, path = "s3://profissaodocente-inepdata-s3/inep/bronze/microsuperior2023_cur", format = "parquet", partitioning = c("TP_MODALIDADE_ENSINO"))
arrow::write_dataset(dataset = micro_ies, path = "s3://profissaodocente-inepdata-s3/inep/bronze/microsuperior2023_ies", format = "parquet")


