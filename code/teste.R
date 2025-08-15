#------------------------------------------------------------------
#- CRIAÇÃO DE TESTES PARA VALIDAÇÃO DA BASE DE DADOS PADRÃO PRATA -
#------------------------------------------------------------------

# Criação de regras de validação
regras <- validator(
  # Total de vagas
  sum(QT_VG_TOTAL) == 19181871, 
  # Total de matrículas
  sum(QT_MAT) == 4913281,       
  # Total de matrículas à distância em cursos de graduação no estado do Paraná
  sum(QT_MAT[SG_UF_IES=="PR" & TP_NIVEL_ACADEMICO==1 & TP_DIMENSAO == 2]) == 1773058,
  # Total de ingressantes em cursos de graduação à distância
  sum(QT_ING[TP_DIMENSAO %in% c(2, 3, 4)]) == 3314402,
  # Total de matrículas em cursos de pedagogia
  sum(subset(df_prata, NO_CINE_ROTULO=="Pedagogia" & TP_DIMENSAO %in% c(2, 3, 4))$QT_MAT),
  # Total de cursos de graduação a distância
  sum(QT_CURSO) == 10554
)

# Análise de atendimento às regras
resultado <- confront(dat = df_prata, x = regras)
resultado

#--------------
#- EXPORTAÇÃO -
#--------------

# Caminho para exportar a base padrão prata
caminho_df_prata <- here("data", "prata", glue("{as.integer(format(Sys.Date(), '%Y%m%d'))}_base_final.xlsx"))
# Exporta arquivo
writexl::write_xlsx(df_prata, path = caminho_df_prata)


