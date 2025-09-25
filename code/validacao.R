#-------------------------------------------------------------------------------
#- Criação de testes para validação da base de dados padrão prata e exportação -
#-------------------------------------------------------------------------------

funcao_validacao <- function(df_prata) {
  # Criação de regras de validação
  regras <- validator(
    # Total de vagas
    sum(QT_VG_TOTAL) == 18590273, 
    # Total de matrículas
    sum(QT_MAT) == 5189391,       
    # Total de matrículas à distância em cursos de graduação no estado do Paraná
    sum(QT_MAT[SG_UF_IES=="PR" & TP_NIVEL_ACADEMICO==1]) == 1964797,
    # Total de ingressantes em cursos de graduação à distância
    sum(QT_ING[TP_DIMENSAO %in% c(2, 3, 4)]) == 3347573,
    # Total de matrículas em cursos de pedagogia
    sum(QT_MAT[NO_CINE_ROTULO=="Pedagogia" & TP_DIMENSAO %in% c(2, 3, 4)]) == 733253,
    # Total de cursos de graduação a distância
    sum(QT_CURSO) == 11297
  )
  # Análise de atendimento às regras
  resultado <- confront(dat = df_prata, x = regras)
  print(resultado)
  # Caminho para exportar a base padrão prata
  caminho_df_prata <- here("data", "prata", glue("{as.integer(format(Sys.Date(), '%Y%m%d'))}_base_final.xlsx"))
  # Exporta arquivo
  writexl::write_xlsx(df_prata, path = caminho_df_prata)
  cat("Dados exportados com sucesso!")
}

#-------------------------
#- Geração da base final - 
#-------------------------

df_final <- df_prata %>% 
  filter(TP_DIMENSAO %in% c(2, 3) & !(is.na(CO_MUNICIPIO))) %>% 
  group_by(
    SG_UF_IES, CO_MUNICIPIO_IES, NO_MUNICIPIO_IES, SG_UF, NO_UF, CO_UF, CO_MUNICIPIO, NO_MUNICIPIO
  ) %>% 
  reframe(
    QT_MAT = sum(QT_MAT, na.rm=T),
    QT_CONC_TOTAL = sum(QT_CONC_TOTAL, na.rm=T),
    QT_ING = sum(QT_ING, na.rm=T)
  ) 

writexl::write_xlsx(x=df_final, path="data/20250925_base_polos.xlsx")


