# ITHelp - Helpdesk de TI

O projeto ITHelp visa auxiliar profissionais e usuários da infraestrutura de TI de uma organização. Dada a complexidade de manejar chamados, manter o inventário atualizado e lidar com as demandas de tarefas do dia-a-dia do profissional de infraestrutura, o ITHelp é uma plataforma que centraliza e organiza as atividades mais essenciais a esses profissionais.

Você pode encontrar nossa especificação [aqui](https://docs.google.com/document/d/1qIkzOHty6jXXsaRLysMd40sjNIDHf-m0h9GrSPG1m9o/edit?usp=sharing)

## Implementação Funcional (Haskell)

Utilizamos do Cabal para construir nosso projeto utilizando Haskell. O Cabal já vem por padrão se você tem o [GHCup](https://www.haskell.org/ghcup/) instalado na sua máquina.

### Dependências
- PostgreSQL (versão 13 ou superior)
    - Para funcionar corretamente, tenha certeza que você tem uma tabela de dados "postgres" existente. 
    - Deve estar rodando no localhost na porta 5432 (padrão)
    - Deve possuir um usuário "postgres" que a senha é "123456"
        - Você pode alterar no código-fonte para definir o usuário e a senha do banco de dados no arquivo `LocalDB/ConnectionDB.hs`

### Como executar
1. Build do projeto com Cabal
    ```sh
    cabal build
    ```
2. Executando o projeto com Cabal
    ```sh
    cabal run
    ```