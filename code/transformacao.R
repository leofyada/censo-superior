#---------------------------------------------
#- Transformação dos dados utilizando duckDB -
#---------------------------------------------

funcao_transformacao <- function() {
  tryCatch({
    # Cria uma conexão que representa o banco de dados
    con <- dbConnect(duckdb::duckdb(), dbdir = ":memory:")
    # Instala extensão para conexão com S3
    dbExecute(con, "INSTALL httpfs; LOAD httpfs;")
    # Cria arquivo padrão prata
    df_prata <- dbGetQuery(
      con,
      "
        WITH tab_cursos AS (
          SELECT 
            CO_IES, 
            NO_CURSO, 
            CO_CURSO, 
            CO_CINE_AREA_GERAL, 
            NO_CINE_AREA_GERAL,
            CO_CINE_ROTULO,
            NO_CINE_ROTULO,
            CO_CINE_AREA_ESPECIFICA,
            NO_CINE_AREA_ESPECIFICA,
            CO_CINE_AREA_DETALHADA,
            NO_CINE_AREA_DETALHADA,
            TP_GRAU_ACADEMICO,
            TP_NIVEL_ACADEMICO,
            TP_DIMENSAO,
            SUM(QT_VG_TOTAL) AS 'QT_VG_TOTAL', 
            SUM(QT_CONC) AS 'QT_CONC_TOTAL',
            SUM(QT_MAT) AS 'QT_MAT',
            SUM(QT_ING) AS 'QT_ING',
            SUM(QT_CURSO) AS 'QT_CURSO'
          FROM read_parquet('s3://profissaodocente-inepdata-s3/inep/bronze/microsuperior2023_cur/TP_MODALIDADE_ENSINO=2/part-0.parquet')
          GROUP BY 
            CO_IES, 
            NO_CURSO, 
            CO_CURSO, 
            CO_CINE_AREA_GERAL, 
            NO_CINE_AREA_GERAL, 
            CO_CINE_ROTULO,
            NO_CINE_ROTULO,
            CO_CINE_AREA_ESPECIFICA,
            NO_CINE_AREA_ESPECIFICA,
            CO_CINE_AREA_DETALHADA,
            NO_CINE_AREA_DETALHADA,
            TP_GRAU_ACADEMICO, 
            TP_NIVEL_ACADEMICO, 
            TP_DIMENSAO
        ), 
        tab_ies AS (
          SELECT 
            CO_UF_IES,
            SG_UF_IES,
            CO_MUNICIPIO_IES,
            NO_MUNICIPIO_IES,
            CO_IES,
            NO_IES,
            SG_IES
          FROM read_parquet('s3://profissaodocente-inepdata-s3/inep/bronze/microsuperior2023_ies/part-0.parquet')
        )
        SELECT 
          CO_UF_IES,
          SG_UF_IES,
          CO_MUNICIPIO_IES,
          NO_MUNICIPIO_IES,
          tab_ies.CO_IES,
          NO_IES,
          SG_IES,
          NO_CURSO, 
          CO_CURSO, 
          CO_CINE_AREA_GERAL, 
          NO_CINE_AREA_GERAL, 
          CO_CINE_ROTULO,
          NO_CINE_ROTULO,
          CO_CINE_AREA_ESPECIFICA,
          NO_CINE_AREA_ESPECIFICA,
          CO_CINE_AREA_DETALHADA,
          NO_CINE_AREA_DETALHADA,
          TP_GRAU_ACADEMICO,
          TP_NIVEL_ACADEMICO,
          TP_DIMENSAO, 
          QT_VG_TOTAL, 
          QT_CONC_TOTAL,
          QT_MAT,
          QT_ING, 
          QT_CURSO
        FROM tab_cursos
        INNER JOIN tab_ies ON tab_ies.CO_IES = tab_cursos.CO_IES;
      "
    )
    return(df_prata)
    cat("Dados transformados com sucesso!\n")
  }, error = function(e) {
    # Erro
    cat("Ocorrou o seguinte erro:", conditionMessage(e), "\n")
  }, warning = function(w) {
    # Aviso
    cat("Um aviso apareceu:", conditionMessage(w), "\n")
  })
}


