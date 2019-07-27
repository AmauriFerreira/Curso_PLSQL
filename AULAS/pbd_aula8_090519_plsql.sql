/*************************************
Aula 8 -9/maio SQL Dinâmico 
**********************************/
/* Ao contrário de instruções SQL estáticas, que são codificados no programa, 
instruções SQL dinâmicas podem ser criadas em tempo de execução e
colocadas em uma variável de host da cadeia de caracteres. 
Eles são então enviados para o DBMS para processamento. 
Como o DBMS deve gerar um plano de acesso em tempo de execução para instruções SQL dinâmicas, 
o SQL dinâmico é geralmente mais lento do que o SQL estático. */
    
/* Bind Variables
O processo de associar valores de variáveis PL/SQL em consultas SQL, 
especificadas no corpo de funções ou procedures escritas nesta linguagem, é conhecido como binding (“ligação”). 
Para observar a aplicação deste conceito na prática, considere a procedure Deleta_produto, especificada abaixo. 
Esta procedure recebe como entrada um código de produto, em seu corpo, 
contém três comandos SQL DELETE responsáveis por excluir todos os registros do produto especificado
em três diferentes tabelas. Nesta procedure, a variável vprod atua como uma bind variable, 
pois ela foi utilizada como condição da cláusula WHERE em três instruções SQL. */

-- procedure para excluir um determinado produto do banco
CREATE OR REPLACE PROCEDURE deleta_produto ( vcod IN produto.cod_prod%TYPE)
IS
BEGIN
DELETE FROM itens_pedido WHERE cod_prod = vcod ;
DELETE FROM armazenamento WHERE cod_prod = vcod ;
DELETE FROM produto WHERE cod_prod = vcod ;
END ;
SELECT * FROM produto WHERE cod_prod =  5010 ;
-- sumindo com o 5010
BEGIN
deleta_produto ( 5010 ) ;
END ;

-- deletar todos os dados de uma tabela
CREATE OR REPLACE PROCEDURE drakaris_tabela ( vtabela IN VARCHAR2)
IS
BEGIN
     DELETE FROM vtabela ;
END ;

-- passando variáveis que são objetos do BD para executar no comando
-- EXECUTE IMMEDIATE
-- bloco anônimo para criar uma tabela e popular
DROP TABLE testedin CASCADE CONSTRAINTS ;
DECLARE
vSQLDin VARCHAR2(4000) ; -- string que vai montar o comando SQL
vCod NUMBER(2) := 88 ;
vNome CHAR ( 15) := 'Teste PL/SQL' ;
BEGIN
-- passo1 cria uma tabela para receber os dados
EXECUTE IMMEDIATE 'CREATE TABLE testedin ( cod NUMBER(2), nome CHAR(15))' ;
-- passo 2 monta a string para o insert
vSQLdin := 'INSERT INTO testedin VALUES ( :1, :2)' ;
EXECUTE IMMEDIATE vSQLdin USING vCod, vNome ;
END ;
SELECT * FROM testedin ;

-- função parametrizada para consulta na tabela produto
-- retorna só uma linha 
CREATE OR REPLACE FUNCTION f_consulta_produto ( vcolunamostra IN VARCHAR2,
vcolunafiltro IN VARCHAR2 , vvalor IN INTEGER )
RETURN VARCHAR2
IS
auxiliar VARCHAR2(50) ;
vSQLdin VARCHAR2(255) := 'SELECT '||vcolunamostra||' FROM produto
WHERE '||vcolunafiltro||' = :1 ' ;
BEGIN
-- mostrando a cara do select
DBMS_OUTPUT.PUT_LINE ( vSQLdin) ;
-- executando o select
EXECUTE IMMEDIATE vSQLdin INTO auxiliar USING vvalor ;
RETURN auxiliar ;
END ;
-- rodando
SELECT f_consulta_produto ( 'categ_esporte', 'cod_prod', 5001) FROM dual ;

-- consulta parametrizada retornando mais de uma linha - cursor
-- retornando as 100 primeiras linhas
CREATE OR REPLACE PROCEDURE lista_dinamica ( vtab IN VARCHAR2, 
vcoluna IN VARCHAR2) 
IS 
TYPE vteste IS REF CURSOR ;
vCursorteste vteste ;
vSQLdin VARCHAR2(255) ;
vaux VARCHAR2(4000) ;
BEGIN
-- montando o select que vai retornar mais de uma linha
vSQLdin := 'SELECT '||vcoluna||' FROM '||vtab||' WHERE ROWNUM <= 10' ;
-- abrindo o cursor dinâmico e exibindo os dados
  OPEN vCursorteste FOR vSQLdin;
     LOOP
     FETCH vCursorteste INTO vaux ;
     EXIT WHEN vCursorteste%NOTFOUND ;
          DBMS_OUTPUT.PUT_LINE ( TRIM ( vaux) ) ;
     END LOOP ;
   CLOSE vCursorteste ;
END ;
-- rodando
BEGIN
lista_dinamica ( 'funcionario', 'dt_admissao' ) ;
END ;

-- passando valor como filtro
CREATE OR REPLACE PROCEDURE lista_dinamica_valor ( vtab IN VARCHAR2, 
vcoluna IN VARCHAR2, vvalor IN INTEGER) 
IS 
TYPE vteste IS REF CURSOR ;
vCursorteste vteste ;
vSQLdin VARCHAR2(255) ;
vaux VARCHAR2(4000) ;
BEGIN
-- montando o select que vai retornar mais de uma linha
vSQLdin := 'SELECT '||vcoluna||' FROM '||vtab||' WHERE '||vcoluna||' >= '||vvalor  ;
DBMS_OUTPUT.PUT_LINE ( vSQLdin) ;
-- abrindo o cursor dinâmico e exibindo os dados
  OPEN vCursorteste FOR vSQLdin;
     LOOP
     FETCH vCursorteste INTO vaux ;
     EXIT WHEN vCursorteste%NOTFOUND ;
          DBMS_OUTPUT.PUT_LINE ( TRIM ( vaux) ) ;
     END LOOP ;
   CLOSE vCursorteste ;
END ;
-- rodando
BEGIN
lista_dinamica_valor ( 'funcionario', 'reg_func', 3)  ;
END ;
