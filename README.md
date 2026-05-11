# 🎬 CineVerse - Gestão de Personagens

![Delphi](https://img.shields.io/badge/Delphi-VCL-red?style=for-the-badge&logo=delphi)
![SQL Server](https://img.shields.io/badge/SQL_Server-FireDAC-blue?style=for-the-badge&logo=microsoft-sql-server)
![Windows](https://img.shields.io/badge/Windows-Desktop-lightgrey?style=for-the-badge&logo=windows)
![Status](https://img.shields.io/badge/Status-Conclu%C3%ADdo-success?style=for-the-badge)

## 🎯 Objetivo
Sistema desenvolvido para o Desafio de Estágio (DomTec), focado na gestão eficiente e íntegra de personagens de filmes e séries, utilizando persistência relacional e troca de dados via arquivos estruturados.

- **Desafio:** Lista de Personagens de Filmes e Séries | **Entrada:** JSON | **Saída:** JSON

## 💻 Tecnologias Utilizadas
* **Linguagem/Framework:** Delphi (VCL)
* **Banco de Dados:** Microsoft SQL Server
* **Acesso a Dados:** FireDAC
* **Manipulação de Dados:** `REST.Json` (Serialização e Desserialização)

## 🚀 Como Executar

O sistema foi projetado com foco na **Experiência do Avaliador**, possuindo uma rotina de auto-configuração (Zero Fricção).

> 📦 **AVALIAÇÃO RÁPIDA (RECOMENDADO):** Para testar o sistema sem necessidade de compilar, **[baixe a Versão Final na aba Releases aqui](https://github.com/LeoSatCode/DesafioEstagio/releases/tag/v1.0)**. O pacote já contém o executável, o arquivo de configuração pré-montado, os scripts SQL e um arquivo JSON para testes.

**Passo a Passo de Execução:**
1. Extraia a pasta baixada.
2. Abra o arquivo `Config.ini` em um bloco de notas e ajuste a chave `Server=` para o nome da instância local do seu SQL Server (ex: `localhost\SQLEXPRESS`).
3. Execute o `DesafioEstagio.exe`.
4. **Criação Automática do Banco:** Após a conexão, o sistema fará uma conexão temporária na tabela `master`, criará o banco `CineVerseDB` e executará as *migrations* (criação das tabelas) de forma 100% automática.

> **Nota para análise de código:** Caso deseje compilar manualmente, clone o repositório e rode o projeto `DesafioEstagio.dpr` no Delphi. Para avaliação manual da modelagem, o script estrutural completo está disponível na pasta `/SQL/Script_CineVerse.sql`.

## 📥 Como Importar/Exportar Dados

* **Importação (Entrada JSON):** Clique em `Importar JSON` e selecione um arquivo válido *(Você pode utilizar o arquivo `Leonardo.json` incluso no pacote de Release para um teste rápido)*. O sistema lê o arquivo, valida a presença de campos obrigatórios e insere no banco de dados.
  * *Tratamento:* Registros duplicados (mesmo personagem na mesma franquia) encontrados no JSON são identificados e ignorados, importando apenas os válidos, com relatório final na tela.

* **Exportação (Saída JSON):** Clique em `Exportar JSON`. O sistema irá gerar um arquivo `.json` válido e indentado.
  * *Comportamento:* A exportação é **fiel à tela**. Ela respeita rigorosamente qualquer filtro de pesquisa ou ordenação de colunas que o usuário tenha aplicado na Grid no momento do clique.

## ✨ Funcionalidades

* **CRUD Completo:** Criação, Leitura, Atualização e Exclusão de Personagens, Franquias e Atores.
* **Regras de Negócio Blindadas:** O sistema impede, tanto via interface quanto via banco de dados (Constraints), o cadastro de um mesmo personagem na mesma franquia.
* **Filtro Rápido Dinâmico:** Pesquisa simultânea por Nome, Franquia, Ator/Atriz, Mídia ou Descrição.
* **Ordenação Interativa:** Clique no título das colunas na listagem para alternar a ordenação (Ascendente/Descendente).
* **Campos Extensos:** Suporte completo a textos longos na descrição (VARCHAR MAX).
* **Usabilidade e Acessibilidade:** Uso de *Hotkeys* (Alt + Letra) e navegação intuitiva.

## 🧠 Decisões Técnicas Tomadas

Para atender ao "Checklist de Correção" com excelência, as seguintes decisões arquiteturais foram aplicadas:

1. **Separação de Responsabilidades (Clean Code):** A lógica de persistência e validação não fica nas telas. Foi criado o `cCharacterManager` (CRUD e regras) e o `cCharacterService` (tratamento de JSON).
2. **Migrations Nativas:** O banco se constrói sozinho (`cUpdateTableMSSQL`), evitando que o avaliador precise rodar scripts manuais para testar a aplicação.
3. **Uso de `OUTPUT INSERTED`:** Para garantir a integridade das Chaves Estrangeiras, a inserção de Franquias e Atores devolve o ID gerado na mesma transação, evitando bugs de escopo do FireDAC ao processar lotes separados.
4. **Prevenção de Memory Leaks:** Uso estrito de blocos `try..finally` na instanciação de classes e formulários.
