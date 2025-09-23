#------------------------
#- Importar bibliotecas - 
#------------------------

# Função para importar pacotes
importar_pacotes <- function(pacotes) {
  for (pacote in pacotes) {
    if (!require(pacote, character.only = TRUE)) {
      message(paste("Pacote", pacote, "não encontrado. Instalando..."))
      install.packages(pacote, dependencies = TRUE)
      if (require(pacote, character.only = TRUE)) {
        message(paste("Pacote", pacote, "instalado e carregado com sucesso."))
      } else {
        warning(paste("Falha ao instalar o pacote:", pacote))
      }
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


