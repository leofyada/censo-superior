#---------------------------------------------
#- TRANSFORMAÇÃO DOS DADOS UTILIZANDO DUCKDB -
#---------------------------------------------

# Cria uma conexão que representa o banco de dados
con <- dbConnect(duckdb::duckdb(), dbdir = ":memory:")
# Instala extensão para conexão com S3
dbExecute(con, "INSTALL httpfs; LOAD httpfs;