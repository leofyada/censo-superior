#------------------------------------------------------------------
#- CRIAÇÃO DE TESTES PARA VALIDAÇÃO DA BASE DE DADOS PADRÃO PRATA -
#------------------------------------------------------------------

# Criação de regras de validação
regras <- validator(
  # Total de vagas
  sum(QT_VG_TOTAL) == 19181871, 
  # Total de matrículas
  sum(QT_MAT) == 4913281,       
  # Total de matrículas à distância em cursos de graduação no estado d