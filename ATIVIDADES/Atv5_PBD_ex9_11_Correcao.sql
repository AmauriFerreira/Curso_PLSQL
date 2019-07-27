/*******************************
Atividade 5 
********************************/
/** 
9 – Construa um log de auditoria para reajuste de salário dos funcionários utilizando gatilho composto. 
Suponha que o salário é reajustado por um determinado índice para cada região de vendas – ou seja,
nem sempre uma região terá reajuste junto com as outras. 
Registre o nome do funcionário, o nome da região e o salário anterior e o reajustado (novo) , 
além de outros dados relevantes para o controle.  */
/**************************************************************************************
Trigger composta para auditar mudanças no salario dos funcionários
**************************************************************************************/
-- Tabela de auditoria para o reajuste de salario
DROP TABLE salario_log CASCADE CONSTRAINTS ;
CREATE TABLE salario_log
( log_id INTEGER,
funcionario INTEGER,
usuario VARCHAR2(32) ,
salario_antes NUMBER(10,2),
salario_depois NUMBER(10,2) ,
regiao VARCHAR2(50),
dt_reajuste TIMESTAMP ) ;
-- sequência para o log id
DROP SEQUENCE salario_log_seq ;
CREATE SEQUENCE salario_log_seq ;
-- gatilho composto para registrar o log de reajuste de preço
CREATE OR REPLACE TRIGGER compound_salario_reajuste
FOR UPDATE OF salario ON funcionario
COMPOUND TRIGGER
-- linha que foi alterada 
linhaalterada ROWID ;
-- declarar uma struct ( register) 
   TYPE salario_registro IS RECORD
   ( log_id              salario_log.log_id%TYPE,
     funcionario     salario_log.funcionario%TYPE,
     usuario            salario_log.usuario%TYPE ,
     salario_antes   salario_log.salario_antes%TYPE,
     salario_depois salario_log.salario_depois%TYPE ,
     regiao             salario_log.regiao%TYPE,
     dt_reajuste      salario_log.dt_reajuste%TYPE ) ;
-- tipo coleção ( table) de record
  TYPE salario_lista IS TABLE OF salario_registro ;
--  variável global que vai armazenar o log temporariamente
salario_updates salario_lista := salario_lista() ;
AFTER EACH ROW IS
-- declaração de variáveis locais que vão auxiliar na população da tabela de records
p NUMBER;
usuario_id VARCHAR2(32) ;
nomeregiao VARCHAR2(50) ;
BEGIN
linhaalterada := :NEW.rowid ;
SELECT user INTO usuario_id FROM dual ; -- usuário da sessão corrente
SELECT get_regiao ( linhaalterada) INTO nomeregiao FROM dual ;  -- retorna o nome da região para a linha que foi atualizada
-- estende o registro e atribui valor dinâmico para o índice k
salario_updates.EXTEND;
p := salario_updates.LAST ;
salario_updates(p).log_id             := salario_log_seq.nextval ;
salario_updates(p).funcionario     := :OLD.reg_func ;
salario_updates(p).usuario            := usuario_id ;
salario_updates(p).salario_antes   := :OLD.salario ;
salario_updates(p).salario_depois := :NEW.salario ;
salario_updates(p).regiao             := nomeregiao ;
salario_updates(p).dt_reajuste      := current_timestamp ;
END AFTER EACH ROW ;

AFTER STATEMENT IS
BEGIN
   FORALL i IN salario_updates.FIRST..salario_updates.LAST
      INSERT INTO salario_log VALUES
       ( salario_updates(i).log_id ,
         salario_updates(i).funcionario,
         salario_updates(i).usuario,
         salario_updates(i).salario_antes ,
         salario_updates(i).salario_depois,
         salario_updates(i).regiao,
         salario_updates(i).dt_reajuste ) ;
END AFTER STATEMENT ;
END ;

CREATE OR REPLACE FUNCTION get_regiao ( vlinha IN VARCHAR2)
RETURN VARCHAR2
IS vregiao regiao.nome_regiao%TYPE ;
PRAGMA AUTONOMOUS_TRANSACTION ;
BEGIN
       SELECT r.nome_regiao INTO vregiao
       FROM regiao r JOIN funcionario f ON ( f.cod_regiao = r.cod_regiao)
      WHERE f.rowid = vlinha ;
RETURN vregiao ;
END ;

-- testando
SELECT * FROM salario_log ;
SELECT reg_func, salario FROM funcionario ;
ALTER TRIGGER validasalario_cargo DISABLE ;
UPDATE funcionario SET salario = salario * 1.01 ;

/* 10 – Refaça a questão 4 da avaliação P1, agora construindo uma função
que retorna um cursor para os dados de venda do produto (somente o miolo do relatório) . 
Posteriormente crie o bloco anônimo que exibe esses dados. */
CREATE OR REPLACE FUNCTION venda_produto_funcao (vprod IN produto.nome_prod%TYPE,
vini IN pedido.dt_hora_ped%TYPE, vfim IN pedido.dt_hora_ped%TYPE)
RETURN SYS_REFCURSOR 
IS vendasprod SYS_REFCURSOR ;
vbusca produto.nome_prod%TYPE := '%'||UPPER(vprod)||'%' ;
vsetem SMALLINT := 0 ;
BEGIN
SELECT COUNT(*) INTO vsetem
FROM produto pr
WHERE UPPER ( pr.nome_prod) LIKE vbusca ;
IF vsetem = 1 THEN
OPEN vendasprod FOR 
       SELECT p.num_ped As Pedido, c.nome_fantasia AS Cliente,  p.dt_hora_ped As Dtpedido,
        i.qtde_pedida AS Qtde, i.preco_item as Preco, i.descto_itens_pedido AS Descto, 
       (i.qtde_pedida*i.preco_item*(100 - i.descto_itens_pedido)/100) AS Totitem
        FROM pedido p JOIN cliente c ON ( p.cod_cli = c.cod_cli)
        JOIN itens_pedido i ON ( i.num_ped = p.num_ped)
        JOIN produto pr ON ( pr.cod_prod = i.cod_prod) 
        WHERE UPPER(pr.nome_prod) LIKE vbusca
        AND p.dt_hora_ped BETWEEN vini AND vfim ;
ELSIF vsetem <> 1 THEN 
  RAISE_APPLICATION_ERROR ( -20033, 'Produto não localizado !!!') ;
END IF ;
RETURN vendasprod ;
END ;

-- estrutura auxiliar para o cursor FETCH
CREATE TABLE vendas_produto_aux
( pedido INTEGER, cliente VARCHAR2(50), data_ped TIMESTAMP,
qtde INTEGER, precoitem NUMBER(10,2), desconto NUMBER(5,2),
totalitem NUMBER(10,2)  ) ;
-- executando a função e exibindo os dados em um bloco anônimo
DECLARE
listagem SYS_REFCURSOR ;
linha vendas_produto_aux%ROWTYPE ;
BEGIN
listagem := venda_produto_funcao ( 'bola nba', current_date - 100, current_date ) ;
LOOP
FETCH listagem INTO linha ;
EXIT WHEN listagem%NOTFOUND ;
       DBMS_OUTPUT.PUT_LINE ( TO_CHAR(linha.pedido)||'-'||TO_CHAR(linha.cliente)||'-'||
                                                TO_CHAR(linha.data_ped, 'DD/MON/YY')||'-'|| TO_CHAR(linha.qtde)
                                                ||'-'||TO_CHAR(linha.precoitem, '999D99')  ||'-'||TO_CHAR(linha.desconto)
                                                ||'-'||TO_CHAR(linha.totalitem, '999D99') ) ;
END LOOP;
CLOSE listagem ;
END ;

/* 11 – Refaça o exercício 10 acima agora retornando uma tabela tipada. */
DROP TYPE vendas_produto_tab FORCE ;
CREATE OR REPLACE TYPE vendas_produto_tab AS OBJECT 
( pedido INTEGER, cliente VARCHAR2(50), data_ped TIMESTAMP,
qtde INTEGER, precoitem NUMBER(10,2), desconto NUMBER(5,2),
totalitem NUMBER(10,2) ) ;

-- tabela para dados pedido
DROP TYPE table_vendas_produto FORCE ;
CREATE OR REPLACE TYPE table_vendas_produto AS TABLE OF vendas_produto_tab ;
--  função que retorna as vendas de um produto usando tabela tipada como saída
CREATE OR REPLACE FUNCTION venda_produto_tabtipada 
( vprod IN produto.nome_prod%TYPE,
vini IN pedido.dt_hora_ped%TYPE, vfim IN pedido.dt_hora_ped%TYPE )
RETURN table_vendas_produto
IS info_vdaprod  table_vendas_produto := table_vendas_produto() ;
vbusca produto.nome_prod%TYPE := '%'||UPPER(vprod)||'%' ;
vsetem SMALLINT := 0 ;
CURSOR vendasproduto IS 
   SELECT p.num_ped As Pedido, c.nome_fantasia AS Cliente,  p.dt_hora_ped As Dtpedido,
        i.qtde_pedida AS Qtde, i.preco_item as Preco, i.descto_itens_pedido AS Descto, 
       (i.qtde_pedida*i.preco_item*(100 - i.descto_itens_pedido)/100) AS Totitem
        FROM pedido p JOIN cliente c ON ( p.cod_cli = c.cod_cli)
        JOIN itens_pedido i ON ( i.num_ped = p.num_ped)
        JOIN produto pr ON ( pr.cod_prod = i.cod_prod) 
        WHERE UPPER(pr.nome_prod) LIKE vbusca
        AND p.dt_hora_ped BETWEEN vini AND vfim ;
BEGIN
-- vendo se o produto existe
SELECT COUNT(*) INTO vsetem
FROM produto pr
WHERE UPPER ( pr.nome_prod) LIKE vbusca ;
IF vsetem = 1 THEN
    FOR m IN vendasproduto LOOP
        info_vdaprod.EXTEND ;
        info_vdaprod ( info_vdaprod.COUNT) := ( vendas_produto_tab ( m.Pedido, m.Cliente, m.Dtpedido, m.Qtde, m.Preco, m.Descto, m.Totitem));
    END LOOP ;
END IF ;
RETURN info_vdaprod ;
END ;
-- executando
SELECT venda_produto_tabtipada ( 'bola nba', current_date - 200, current_date ) FROM dual ;

SELECT vp.* FROM TABLE 
( SELECT venda_produto_tabtipada ( 'bola nba', current_date - 200, current_date )
FROM dual) vp  ;
