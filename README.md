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
        - Você pode alterar no código-fonte para definir o usuário e a senha do banco de dados no arquivo `Funcional/LocalDB/ConnectionDB.hs`
    - Dica: consulte o ChatGPT com a seguinte pergunta: "Como instalar e configurar o PostgreSQL no `WINDOWS/MAC_OS/DISTRO_LINUX` na versão 13 ou superior que rode na porta padrão (5432), possua um usuário "postgres" com a senha "123456", e uma tabela chamada postgres?". Pode ser extremamente útil para que você configure seu ambiente corretamente.

### Como executar
1. Abra o projeto clonado do Github e navegue até a pasta `Funcional`
    ```sh
    cd Funcional/
    ```
2. Build do projeto com Cabal
    ```sh
    cabal build
    ```
3. Executando o projeto com Cabal
    ```sh
    cabal run
    ```

## Implementanção Lógica (Prolog)

Utilizamos somente o SWI-Prolog para construir o nosso projeto em Prolog. 

### Dependências
- SWI-Prolog
    - Para conseguir rodar o projeto você deve ter o SWI-Prolog instalado na sua máquina. Acesse o [site oficial](https://www.swi-prolog.org/Download.html) para saber como.

### Como executar
1. Abra o projeto clonado do Github e navegue até a pasta `Logico`
    ```sh
    cd Logico/
    ```
2. Execute o projeto utilizando o SWI-Prolog:
    ```sh
    swipl -o -f main.pl
    ```