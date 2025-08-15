# 📊 Censo Superior – Pipeline de Dados na Nuvem

Este projeto cria um **pipeline simples na nuvem** para análise de microdados do **Censo da Educação Superior** (INEP) em conjunto com outras fontes. O objetivo é manter um fluxo reprodutível, do download dos dados brutos até a análise final, aproveitando serviços **serverless** da AWS.

---

## 🚀 Fluxo do Pipeline

<img width="626" height="321" alt="Pipeline - Censo Superior" src="https://github.com/user-attachments/assets/0937042d-618d-4481-878c-bed49365b29f" />

## 📂 Estrutura de Pastas (S3)

s3://profissaodocente-inepdata-s3/inep/

- bronze/   # dados brutos convertidos para Parquet e particionados
- silver/   # dados transformados e limpos (outputs de CTAS ou DuckDB)
- gold/     # dados prontos para análise e visualização
    
## 🛠 Tecnologias Utilizadas

- Linguagem: R
- Leitura/Escrita Parquet: arrow
- Manipulação de dados: dplyr
- Upload para AWS S3: arrow S3 

## 📋 Passos do Pipeline

1. Download dos microdados do INEP (arquivo ZIP).
2. Extração dos CSVs relevantes.
3. Conversão para Parquet com particionamento (usando arrow no R).
4. Upload dos arquivos para S3 (direto com write_dataset()).

## 📜 Licença

Este projeto está licenciado sob a MIT License.



