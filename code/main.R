#-------------------------------------------
#- Função de execução do pipeline de dados - 
#-------------------------------------------

# Importação das funções
source("code/config.R")
source(here("code", "extracao.R"))
source(here("code", "carregamento.R"))
source(here("code", "transformacao.R"))
source(here("code", "validacao.R"))

# Caminho dos dados do Censo da Educação Superior
caminho_censosuperior <- "https://download.inep.gov.br/microdados/microdados_censo_da_educacao_superior_2024.zip"

# Criação de função do pipeline de dados
funcao_pipeline <- function(caminho_censosuperior) {
  # Extração dos dados do Censo da Educação Superior
  funcao_extracao(caminho_censosuperior)
  # Carregamento para o bucket S3
  funcao_carregamento()
  # Modelagem de dados
  df_prata <- funcao_transformacao()
  # Validação e exportação
  funcao_validacao(df_prata)
}

# Execução de pipeline de dados
funcao_pipeline(caminho_censosuperior)


