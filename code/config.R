#------------------------
#- Importar bibliotecas - 
#------------------------

# Função para importar pacotes
importar_pacotes <- function(pacotes) {
  for (pacote in pacotes) {
    if (!require(pacote, character.only = TRUE)) {
      message(paste("Pacote", pacote, "não encontrado. Instalando..."))
    } else {
      message(paste("Pacote", pacote, "carregado com sucesso."))
    }
  }
}
# Pacotes utilizados
pacotes <- c(
  "here", "arrow", "dplyr", "archive", "aws.s3", "data.table", "aws.signature", "duckdb", "DBI", "validate", "writexl", "glue", "readxl", "enderecobr"
 )
# Importa pacotes selecionados
importar_pacotes(pacotes)
