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

# Ajuste de 1 regional para 2 municípios
dt_regionais <- dt_regionais %>% 
  filter(!(municipio %in% c("Olinda e Paulista", "Moreno e São Lourenço da Mata"))) 

regional_dupla <- tibble(
  UF=c("PE", "PE", "PE", "PE"),
  regional=c("METROPOLITANA NORTE", "METROPOLITANA NORTE", "METROPOLITANA SUL", "METROPOLITANA SUL"),
  municipio=c("Olinda", "Paulista", "Moreno", "São Lourenço da Mata")
) 

dt_regionais <- rbind(dt_regionais, regional_dupla)
  

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
      municipio=="GUARIBAS DO PIAUI" & UF=="PI" ~ "Guaribas",
      municipio=="venha ver" & UF=="RN" ~ "Venha-Ver",
      municipio=="Várze Alegre" & UF=="CE" ~ "Várzea Alegre",
      municipio=="TANQUES DO PIAUI" & UF=="PI" ~ "Tanque do Piauí",
      municipio=="TAMBORIL" & UF=="PI" ~ "Tamboril do Piauí",
      municipio=="tabuleiro grande" & UF=="RN" ~ "Taboleiro Grande",
      municipio=="SÍTIO D ABADIA" & UF=="GO" ~ "Sítio d'Abadia",
      municipio=="senador georgino" & UF=="RN" ~ "Senador Georgino Avelino",
      municipio=="são mateus" & UF=="MA" ~ "São Mateus do Maranhão",
      municipio=="são luiz gonzaga do maranhao" & UF=="MA" ~ "São Luís Gonzaga do Maranhão",
      municipio=="SAO LUIS" & UF=="PI" ~ "São Luís do Piauí",
      municipio=="são jose de campestre" & UF=="RN" ~ "São José do Campestre",
      municipio=="SAO JOAO VARJOTA" & UF=="PI" ~ "São João da Varjota",
      municipio=="SÃO JOÃO D ALIANÇA" & UF=="GO" ~ "São João d'Aliança",
      municipio=="SAO F. DE ASSIS DO PIAUI" & UF=="PI" ~ "São Francisco de Assis do Piauí",
      municipio=="são domingos" & UF=="MA" ~ "São Domingos do Maranhão",
      municipio=="São Braz" & UF=="AL" ~ "São Brás",
      municipio=="santo amaro" & UF=="MA" ~ "Santo Amaro do Maranhão",
      municipio=="SANTA TERESINHA" & UF=="BA" ~ "Santa Terezinha",
      municipio=="santa filomena" & UF=="MA" ~ "Santa Filomena do Maranhão",
      municipio=="santa Bárbara" & UF=="PA" ~ "Santa Bárbara do Pará",
      municipio=="Rui Palmeira" & UF=="AL" ~ "Senador Rui Palmeira",
      municipio=="são Geraldo do araguaia e" & UF=="PA" ~ "São Geraldo do Araguaia",
      municipio=="RIBEIRA" & UF=="PI" ~ "Ribeira do Piauí",
      municipio=="presidente medice" & UF=="MA" ~ "Presidente Médici",
      municipio=="PORTO ALEGRE" & UF=="PI" ~ "Porto Alegre do Piauí",
      municipio=="Porto de Pedra" & UF=="AL" ~ "Porto de Pedras",
      municipio=="pindare" & UF=="MA" ~ "Pindaré-Mirim",
      municipio=="Pau-d'Arco" & UF=="TO" ~ "Pau D'Arco",
      municipio=="Olho D`Água Grande" & UF=="AL" ~ "Olho d'Água Grande",
      municipio=="PAU D'ARCO" & UF=="PI" ~ "Pau D'Arco do Piauí",
      municipio=="Olho D`Água do Casado" & UF=="AL" ~ "Olho d'Água do Casado",
      municipio=="olho dagua dos borges" & UF=="RN" ~ "Olho d'Água do Borges",
      municipio=="OLHO DAGUA" & UF=="PI" ~ "Olho d'Água do Piauí",
      municipio=="N.S.DE NAZARE" & UF=="PI" ~ "Nossa Senhora de Nazaré",
      municipio=="NOVO SANTO ANTONIO DO PIAUI" & UF=="PI" ~ "Novo Santo Antônio",
      municipio=="Nova Estrela" & UF=="RO" ~ "Rolim de Moura",
      municipio=="MORRO DO CHAPEU" & UF=="PI" ~ "Morro do Chapéu do Piauí",
      municipio=="MORRO CABECA DO TEMPO" & UF=="PI" ~ "Morro Cabeça no Tempo",
      municipio=="MADEIROS" & UF=="PI" ~ "Madeiro",
      municipio=="luiz gomes" & UF=="RN" ~ "Luís Gomes",
      municipio=="llhota" & UF=="SC" ~ "Ilhota",
      municipio=="lajes pintada" & UF=="RN" ~ "Lajes Pintadas",
      municipio=="LAGOINHA" & UF=="PI" ~ "Lagoinha do Piauí",
      municipio=="LAGOA DO SAO FRANCISCO" & UF=="PI" ~ "Lagoa de São Francisco",
      municipio=="LAGOA DO BARRO" & UF=="PI" ~ "Lagoa do Barro do Piauí",
      municipio=="JUREMA DO PIAUI" & UF=="PI" ~ "Jurema",
      municipio=="JUAZEIRO" & UF=="PI" ~ "Juazeiro do Piauí",
      municipio=="ITAPORANGA D AJUDA" & UF=="SE" ~ "Itaporanga d'Ajuda",
      municipio=="Itamaracá" & UF=="PE" ~ "Ilha de Itamaracá",
      municipio=="Herval d Oeste" & UF=="SC" ~ "Herval d'Oeste",
      municipio=="MASSAPE" & UF=="PI" ~ "Massapê do Piauí",
      municipio=="lagoa de pedra" & UF=="RN" ~ "Lagoa de Pedras",
      municipio=="rui barbosa" & UF=="RN" ~ "Ruy Barbosa",
      municipio=="Massagueira" & UF=="AL" ~ "Marechal Deodoro",
      
      
      municipio=="arez" & UF=="RN" ~ "Arês",
      municipio=="Vitor Meirelles" & UF=="SC" ~ "Vitor Meireles",
      (regional=="PORTO VELHO" | regional=="EXTREMA") & UF=="RO" ~ "Porto Velho",
      regional=="BURITIS" & UF=="RO" ~ "Buritis",
      regional=="CACOAL" & UF=="RO" ~ "Cacoal",
      
      
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

# Remoção de arquivos
rm(dt_regionais, dt_ibge, dt_ibge_filtrada, dt_ibge_filtrada_padronizada, dt_regionais_padronizada)
# Limpeza do ambiente
gc()

# Exportação de dados de regionais
writexl::write_xlsx(x=dt_regionais_padronizada_limpa %>% select(co_municipio, no_municipio, municipio, regional, UF) %>% arrange(co_municipio), path=here("data", "prata", "regionais.xlsx"))
writexl::write_xlsx(x=dt_regionais_nidentificado, path=here("data", "prata", "regionais_nidentificada.xlsx"))


