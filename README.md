# 📊 Censo Superior – Pipeline de Dados na Nuvem

Este projeto cria um **pipeline simples na nuvem** para análise de microdados do **Censo da Educação Superior** (INEP). O objetivo é manter um fluxo reprodutível, do download dos dados brutos até a análise final, aproveitando serviços **serverless** da AWS.

---

## 🚀 Fluxo do Pipeline

![Pipeline - Censo Superior drawio](https://github.com/user-attachments/assets/db9d1e7c-6fdc-4496-a518-f358389f8b6d)
    
## 🛠 Tecnologias Utilizadas

- Linguagem: R
- Leitura/Escrita Parquet: arrow
- Manipulação de dados: dplyr, duckdb
- Upload para AWS S3: arrow S3 

## 📋 Passos do Pipeline

1. Download dos microdados do INEP (arquivo ZIP).
2. Extração dos CSVs relevantes.
3. Conversão para Parquet com particionamento (usando arrow no R).
4. Upload dos arquivos para S3 (direto com write_dataset()).
5. Transformação utilizando duckDB.
6. Testes com o pacote "validate".
7. Exportação para arquivo Excel.

## 📜 Licença

Este projeto está licenciado sob a MIT License.



