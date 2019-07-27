/***************************
Aula 7 - 02/maio
***************************/

/******************************************************
Trigger composta para auditar mudanças no preço do produto
******************************************************/
-- Tabela de auditoria para o preço
DROP TABLE produto_log CASCADE CONSTRAINTS ;
CREATE TABLE produto_log
( log_id INTEGER,
produto INTEGER,
usuario VARCHAR2(32) ,
dt_criação TIMESTAMP,
preco_antes NUMBER(10,2),
preco_depois NUMBER(10,2) ,
dt_reajuste TIMESTAMP ) ;
-- sequência para o log id
DROP SEQUENCE produto_log_seq ;
CREATE SEQUENCE produto_log_seq ;
-- gatilho composto para registrar o log de reajuste de preço
CREATE OR REPLACE TRIGGER compound_preco_atualizacao
FOR UPDATE OF preco_venda ON produto
COMPOUND TRIGGER
-- declarar uma struct ( register) 
   TYPE produto_registro IS RECORD
   ( log_id produto_log.log_id%TYPE,
     produto produto_log.produto%TYPE,
     usuario produto_log.usuario%TYPE ,
     dt_criação produto_log.dt_criação%TYPE ,
     preco_antes produto_log.preco_antes%TYPE,
     preco_depois produto_log.preco_depois%TYPE ,
     dt_reajuste produto_log.dt_reajuste%TYPE ) ;
-- tipo coleção ( table) de record
  TYPE produto_lista IS TABLE OF produto_registro ;
--  variável global que vai armazenar o log temporariamente
produto_updates produto_lista := produto_lista() ;

BEFORE EACH ROW IS
-- declaração de variáveis locais que vão auxiliar na população da tabela de records
k NUMBER;
usuario_id VARCHAR2(32) ;
BEGIN
SELECT user INTO usuario_id FROM dual ; -- usuário da sessão corrente
-- estende o registro e atribui valor dinâmico para o índice k
produto_updates.EXTEND;
k := produto_updates.LAST ;
produto_updates(k).log_id := produto_log_seq.nextval ;
produto_updates(k).produto := :OLD.cod_prod ;
produto_updates(k).usuario := usuario_id ;
produto_updates(k).dt_criação := current_timestamp ;
produto_updates(k).preco_antes := :OLD.preco_venda ;
produto_updates(k).preco_depois := :NEW.preco_venda ;
produto_updates(k).dt_reajuste := current_timestamp ;
END BEFORE EACH ROW ;

AFTER STATEMENT IS
BEGIN
   FORALL i IN produto_updates.FIRST..produto_updates.LAST
      INSERT INTO produto_log VALUES
       ( produto_updates(i).log_id ,
         produto_updates(i).produto,
         produto_updates(i).usuario,
         produto_updates(i).dt_criação ,
         produto_updates(i).preco_antes ,
         produto_updates(i).preco_depois,
         produto_updates(i).dt_reajuste ) ;
END AFTER STATEMENT ;
END ;

DESC produto_log ;
SELECT * FROM produto_log ;


-- Atualizando o preço
-- volta pra a linha 1084

-- Query produto_log table.
SELECT * FROM produto_log;
SELECT user FROM dual ;

-- Função retornando um cursor
-- trazer os pedidos de um cliente num intervalo de tempo
CREATE OR REPLACE FUNCTION qtde_pedidos_cursor 
( vcli IN cliente.nome_fantasia%TYPE,
  vini IN pedido.dt_hora_ped%TYPE , vfim IN pedido.dt_hora_ped%TYPE )
RETURN SYS_REFCURSOR
IS retorna_ped SYS_REFCURSOR ;
vbusca cliente.nome_fantasia%TYPE := '%'||UPPER(vcli)||'%' ;
vsetem SMALLINT := 0 ;
BEGIN
-- vendo se o cliente existe
SELECT COUNT(*) INTO vsetem FROM cliente
WHERE UPPER(nome_fantasia) LIKE vbusca ;
IF vsetem = 1 THEN -- achou exatamente quem queria
    OPEN retorna_ped FOR -- pedidos do cliente num determinado período
             SELECT p.num_ped, p.dt_hora_ped, p.vl_total_ped, fpg.descr_forma_pgto
             FROM cliente c JOIN pedido p ON ( p.cod_cli = c.cod_cli)
                     JOIN forma_pgto fpg ON (fpg.cod_forma = p.forma_pgto)
             WHERE p.dt_hora_ped BETWEEN vini AND vfim
             AND UPPER(nome_fantasia) LIKE vbusca ;
ELSE
     RAISE_APPLICATION_ERROR ( -20099, 'Algo deu errado !!!') ;
END IF ; 
RETURN retorna_ped ;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR ( -20099, 'Algo deu errado !!!') ;
END ;

-- estrutura auxiliar para o cursor FETCH
CREATE TABLE auxiliar ( pedido INTEGER, data_ped TIMESTAMP,
                                       total NUMBER(10,2) , forma_pgto VARCHAR2(30) ) ;
-- executando a função e exibindo os dados em um bloco anônimo
DECLARE
listagem SYS_REFCURSOR ;
linha auxiliar%ROWTYPE ;
BEGIN
listagem := qtde_pedidos_cursor ( 'hamses', current_date - 100, current_date ) ;
LOOP
FETCH listagem INTO linha ;
EXIT WHEN listagem%NOTFOUND ;
       DBMS_OUTPUT.PUT_LINE ( TO_CHAR(linha.pedido)||'-'||
                                                TO_CHAR(linha.data_ped, 'DD/MON/YY') ) ;
END LOOP;
CLOSE listagem ;
END ;

-- usando tabela tipada
DROP TYPE dados_pedido FORCE ;
CREATE OR REPLACE TYPE dados_pedido AS OBJECT 
( pedido INTEGER, 
data_ped TIMESTAMP,
total NUMBER(10,2) ,
forma_pgto VARCHAR2(30) ) ;
-- tabela para dados pedido
DROP TYPE tab_dados_pedido FORCE ;
CREATE OR REPLACE TYPE tab_dados_pedido AS TABLE OF dados_pedido ;
-- função que retorna os pedidos de um cliente usando tabela tipada como saída
CREATE OR REPLACE FUNCTION qtde_pedidos_table 
( vcli IN cliente.nome_fantasia%TYPE,
  vini IN pedido.dt_hora_ped%TYPE , vfim IN pedido.dt_hora_ped%TYPE )
RETURN tab_dados_pedido
IS info_pedidos tab_dados_pedido := tab_dados_pedido() ;
vbusca cliente.nome_fantasia%TYPE := '%'||UPPER(vcli)||'%' ;
vsetem SMALLINT := 0 ;
CURSOR pedidos IS 
             SELECT p.num_ped AS pedido, p.dt_hora_ped AS dtped,
             p.vl_total_ped AS total, fpg.descr_forma_pgto AS fpgto
             FROM cliente c JOIN pedido p ON ( p.cod_cli = c.cod_cli)
                     JOIN forma_pgto fpg ON (fpg.cod_forma = p.forma_pgto)
             WHERE p.dt_hora_ped BETWEEN vini AND vfim
             AND UPPER(nome_fantasia) LIKE vbusca ; 
BEGIN
-- vendo se o cliente existe
SELECT COUNT(*) INTO vsetem FROM cliente
WHERE UPPER(nome_fantasia) LIKE vbusca ;
IF vsetem = 1 THEN
    DBMS_OUTPUT.PUT_LINE ( 'Estamos bem até aqui !!!') ;
    FOR w IN pedidos LOOP
  info_pedidos.EXTEND ;
  info_pedidos ( info_pedidos.COUNT) := ( dados_pedido ( w.pedido, w.dtped, w.total,w.fpgto));
    END LOOP ;
END IF ;
RETURN info_pedidos ;
END ;
-- executando
SELECT qtde_pedidos_table ( 'hamses', current_date - 200, current_date ) FROM dual ;

SELECT xuxu.* FROM TABLE 
( SELECT qtde_pedidos_table ( 'hamses', current_date - 200, current_date )
FROM dual) xuxu  ;