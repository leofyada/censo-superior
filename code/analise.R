#------------------------
#- Importação dos dados - 
#------------------------

# Importação das funções
source("code/config.R")

# Importação dos dados do IBGE e de regionais (PD)
dt_regionais <- data.table::fread("/Users/leonardoyada/OneDrive/Pé-de-Meia Licenciatura - PD/regionais_municipios.csv")
# Importação da base de dados do IBGE
dt_ibge <- readxl::read_xls("/Users/leonardoyada/OneDrive/DTB_2024/RELATORIO_DTB_BRASIL_2024_MUNICIPIOS.xls", skip = 5)
# Exclusão da última coluna (sem dados)
dt_ibge_filtrada <- dt_ibge %>% 
  select(UF, Nome_UF, `Código Município Completo`, Nome_Município) %>% 
  rename(
    "co_uf" = "UF",
    "no_uf" = "Nome_UF",
    "co_municipio" = "Código Município Completo",
    "no_municipio" = "Nome_Município"
  )

#-----------------------------------------
#- Padronização dos nomes dos municípios - 
#-----------------------------------------

# Ajuste de municípios
dt_regionais <- dt_regionais %>% 
  mutate(
    municipio = case_when(
      municipio=="ALAGOINHAS" & UF=="PI" ~ "Alagoinha do Piauí", 
      municipio=="Aparecida do Tabuado" & UF=="MS" ~ "Aparecida do Taboado", 
      municipio=="Armação de Búzios" & UF=="RJ" ~ "Armação dos Búzios",
      municipio=="assu" & UF=="RN" ~ "Açu",
      municipio=="avelino" & UF=="RN" ~ "Pedro Avelino",
      municipio=="BARÃO DE MONTE ALTO" & UF=="MG" ~ "Barão do Monte Alto",
      municipio=="BARRA DALCANTARA" & UF=="PI" ~ "Barra D'Alcântara",
      municipio=="BETANIA" & UF=="PI" ~ "Betânia do Piauí",
      municipio=="BOA HORA-PI" & UF=="PI" ~ "Boa Hora",
      municipio=="boa saude" & UF=="RN" ~ "Januário Cicco",
      municipio=="BOQUEIRAO" & UF=="PI" ~ "Boqueirão do Piauí",
      municipio=="BREJO" & UF=="PI" ~ "Brejo do Piauí",
      municipio=="caicara do rio dos ventos" & UF=="RN" ~ "Caiçara do Rio do Vento",
      municipio=="CAJAZEIRAS" & UF=="PI" ~ "Cajazeiras do Piauí",
      municipio=="CAPITAL GERVASIO OLIVEIRA" & UF=="PI" ~ "Capitão Gervásio Oliveira",
      municipio=="CARAUBAS" & UF=="PI" ~ "Caraúbas do Piauí",
      municipio=="CAXINGOS" & UF=="PI" ~ "Caxingó",
      municipio=="ceara mirim" & UF=="RN" ~ "Ceará-Mirim",
      municipio=="Colônia de Leopoldina" & UF=="AL" ~ "Colônia Leopoldina",
      municipio=="conceicao do lago acu" & UF=="MA" ~ "Conceição do Lago-Açu",
      municipio=="Couto de Magalhães" & UF=="TO" ~ "Couto Magalhães",
      municipio=="CURRAL NOVO" & UF=="PI" ~ "Curral Novo do Piauí",
      municipio=="CURRALINHO" & UF=="PI" ~ "Curralinhos",
      municipio=="Major Izidoro" & UF=="AL" ~ "Major Isidoro",
      municipio=="DIAS D AVILA" & UF=="BA" ~ "Dias d'Ávila",
      municipio=="EMBU GUACU" & UF=="SP" ~ "Embu-Guaçu",
      municipio=="FARTUNA DO PIAUI" & UF=="PI" ~ "Fartura do Piauí",
      municipio=="felipe de guerra" & UF=="RN" ~ "Felipe Guerra",
      municipio=="fernando pedrosa" & UF=="RN" ~ "Fernando Pedroza",
      municipio=="GERMINIANO" & UF=="PI" ~ "Geminiano",
      municipio=="governador luis rocha" & UF=="MA" ~ "Governador Luiz Rocha",
      municipio=="governador ribamar fiquene" & UF=="MA" ~ "Ribamar Fiquene",
      municipio=="GUARANI D OESTE" & UF=="SP" ~ "Guarani d'Oeste",
      municipio=="ILHA GRANDE DO PIAUI" & UF=="PI" ~ "Ilha Grande",
      municipio=="ipixuna" & UF=="PA" ~ "Ipixuna do Pará",
      municipio=="VILA NOVA" & UF=="PI" ~ "Vila Nova do Piauí",
      municipio=="veracruz" & UF=="RN" ~ "Vera Cruz",
      municipio=="JATOBA" & UF=="PI" ~ "Jatobá do Piauí",
      municipio=="são vicente de ferrer" & UF=="MA" ~ "São Vicente Ferrer",
      municipio=="itapecuru-mirim" & UF=="MA" ~ "Itapecuru Mirim",
      municipio=="lageado novo" & UF=="MA" ~ "Lajeado Novo",
      municipio=="olho dagua das cunhas" & UF=="MA" ~ "Olho d'Água das Cunhãs",
      municipio=="ipanguassu" & UF=="RN" ~ "Ipanguaçu",
      municipio=="peri-mirim" & UF=="MA" ~ "Peri Mirim",
      

      
      .default = municipio
    )
  )

# Utilização do pacote enderecobr para padronizar os municípios das regionais
dt_regionais_padronizada <- dt_regionais %>% 
  mutate(
    municipio_s_ponto = gsub("\\.", "", municipio),
    estado_padronizado = padronizar_estados(UF),
    municipio_padronizado = padronizar_municipios(municipio_s_ponto)
  )

# Utilização do pacote enderecobr para padronizar os municípios do IBGE
dt_ibge_filtrada_padronizada <- dt_ibge_filtrada %>% 
  mutate(
    estado_padronizado = padronizar_estados(no_uf),
    municipio_padronizado = padronizar_municipios(no_municipio)
  )

# Merge de tabelas
dt_regionais_padronizada_limpa <- merge(x=dt_regionais_padronizada, y=dt_ibge_filtrada_padronizada, by=c("municipio_padronizado", "estado_padronizado"))
dt_regionais_padronizada_limpa <- dt_regionais_padronizada_limpa %>% select(UF, regional, municipio, co_municipio, no_municipio)
dt_regionais_padronizada <- merge(x=dt_regionais_padronizada, y=dt_ibge_filtrada_padronizada, by=c("municipio_padronizado", "estado_padronizado"), all.x=T)

# Municípios não encontrados na base de dados do IBGE
dt_regionais_nidentificado <- dt_regionais_padronizada %>% filter(is.na(no_municipio)) %>% select(UF, regional, municipio)
nrow(dt_regionais_nidentificado)
View(dt_regionais_nidentificado)

# Remoção de arquivos
rm(dt_regionais, dt_ibge, dt_ibge_filtrada, dt_ibge_filtrada_padronizada, dt_regionais_padronizada, dt_regionais_nidentificado)
# Limpeza do ambiente
gc()





