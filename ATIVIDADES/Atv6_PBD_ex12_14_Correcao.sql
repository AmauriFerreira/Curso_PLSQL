/*******************************
Atividade 6 
********************************/

/ * 12 – Crie uma nova tabela para Tamanho usando SQL Dinâmica e 
popule os dados com os valores distintos a partir da tabela de origem PRODUTO. 
Tudo em uma única procedure, função ou bloco anônimo. 
Posteriormente resolva com SQL estático o relacionamento entre as duas tabelas. */

SELECT DISTINCT TRIM(UPPER(TO_CHAR(NVL(tamanho,'TAM')))) FROM produto ;

DESC produto ;
DROP SEQUENCE tam_seq ;
CREATE SEQUENCE tam_seq ;
SELECT tam_seq.nextval FROM dual ;

DROP TABLE tamanho CASCADE CONSTRAINTS ;
CREATE TABLE tamanho ( cod_tam SMALLINT PRIMARY KEY, tamanho VARCHAR2(30)) ;

CREATE OR REPLACE PROCEDURE gera_tamanho 
IS
TYPE vtamanho IS REF CURSOR ;
vCursortam vtamanho ;
vdinSelect VARCHAR2(4000) ; -- dml para trazer os tamanhos
--ddl para criar a tabela nova tamanho
vdinCreate VARCHAR2(4000) := 'CREATE TABLE tamanho ( cod_tam CHAR(3) PRIMARY KEY, tamanho VARCHAR2(30) )' ; 
vdinInsert VARCHAR2(4000) ;
vtam CHAR(3);
vseq INTEGER ;
BEGIN
vdinSelect := 'SELECT DISTINCT TRIM ( UPPER (TO_CHAR (tamanho) ) ) FROM produto' ;
-- cria a tabela tamanho
--EXECUTE IMMEDIATE vdinCreate ;  -- problemas de privilegio
-- monta o cursor com os tamanhos
  OPEN vCursortam FOR vdinSelect ;
     LOOP
     FETCH vCursortam INTO vtam ;
     EXIT WHEN vCursortam%NOTFOUND ;
        -- gera o codigo do tamanho baseado na sequência
            IF vtam IS NULL THEN vtam := 'TAM' ; END IF ;
            SELECT tam_seq.nextval INTO vseq FROM dual ;
		-- monta a string para o insert
		    vdinInsert := 'INSERT INTO tamanho VALUES ( :1, :2)' ;
            EXECUTE IMMEDIATE vdinInsert USING vseq, vtam ;
     END LOOP ;
   CLOSE vCursortam ;
END ;

-- executando
BEGIN 
gera_tamanho;
END;

SELECT  * FROM tamanho;

/****** adicionando a FK em produto   */
ALTER TABLE produto ADD cod_tamanho SMALLINT ;
-- atualizando
UPDATE produto p
SET p.cod_tamanho = (SELECT t.cod_tam FROM tamanho t WHERE  TRIM(UPPER(p.tamanho)) = TRIM(UPPER(t.tamanho))) ;
-- arrumando os nulos
UPDATE produto p
SET p.cod_tamanho = ( SELECT t.cod_tam FROM tamanho t WHERE t.tamanho = 'TAM' )
WHERE p.tamanho IS NULL ;
-- transformando em FK
ALTER TABLE produto ADD FOREIGN KEY ( cod_tamanho) REFERENCES tamanho ( cod_tam) ;
ALTER TABLE produto MODIFY cod_tamanho NOT NULL ;

SELECT cod_tamanho FROM produto ;


/* 13- Elabore um controle que permita consultar um produto por um dos
seguintes parâmetros de busca : nome, descrição, categoria esportiva ou marca. 
Cada um dos parâmetros deve ser buscado por parte do texto na tabela correspondente
(não pelo código da categoria ou marca). 
Retorne o nome e o preço de venda do produto consultado.*/

DESC marca ;
DESC categ_esporte ;
DESC produto ;
 
CREATE OR REPLACE PROCEDURE consulta_produto_p (vcolBusca IN VARCHAR2, vvalor IN VARCHAR2)
IS
TYPE vprod IS REF CURSOR;
vCursorprod vprod ;
vdinBusca    VARCHAR2(4000) ;
vBuscavalor VARCHAR2(100)     := '%'||TRIM ( UPPER ( vvalor ) ) ||'%' ;
vBusca         VARCHAR2(32)      := TRIM ( UPPER(vcolBusca) ) ;
vaux1 VARCHAR2(100) ;
vaux2 VARCHAR2(100) ;
BEGIN
-- verificando qual a coluna de busca que vai retornar mais de uma linha
DBMS_OUTPUT.PUT_LINE ( vBuscavalor) ;
IF vBusca = 'MARCA' THEN
    vdinBusca := 'SELECT p.nome_prod, TO_CHAR(p.preco_venda) FROM produto p, marca m
                          WHERE p.marca = m.sigla_marca
                          AND UPPER(m.nome_marca) = :1' ;
   DBMS_OUTPUT.PUT_LINE(vdinBusca);
ELSIF vBusca = 'CATEG_ESPORTE' THEN
    vdinBusca := 'SELECT p.nome_prod, TO_CHAR(p.preco_venda) FROM produto p, categ_esporte ctg
                        WHERE ctg.categ_esporte = p.categ_esporte
                        AND UPPER(ctg.nome_esporte ) = :1' ;
   DBMS_OUTPUT.PUT_LINE(vdinBusca);
ELSIF vBusca IN ('NOME_PROD', 'DESCR_PROD') THEN
    vdinBusca := 'SELECT p.nome_prod, p.preco_venda FROM produto p 
                          WHERE p.'||vBusca||' =  :1 '  ;
   DBMS_OUTPUT.PUT_LINE(vdinBusca);
ELSE
    RAISE_APPLICATION_ERROR ( -20333, ' Coluna não existente !!!') ; 
END IF ;
--abrindo o cursor dinâmico - FETCH
OPEN vCursorprod FOR vdinBusca USING vvalor;
    LOOP
    FETCH vCursorprod INTO vaux1, vaux2 ;
    EXIT WHEN vCursorprod%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(RPAD(TRIM(vaux1), 40, ' ')||'-'||vaux2);
    END LOOP;
  CLOSE vCursorprod ; 
END;

--rodando
BEGIN
consulta_produto_p ('categ_esporte', 'CASUAL' );
--consulta_produto_p ('marca', 'NIKE' );
--consulta_produto_p ('nome_prod', 'Bola NBA' );
END;

SELECT * FROM categ_esporte ;
 
 
/* 14 – Elabore um controle usando SQL Dinâmica para gerar um extrato 
com os dados dos clientes que compraram um determinado produto num intervalo de tempo. 
O produto pode ser parte do nome e exiba no máximo 3 colunas dos clientes
especificando como parâmetros quais são. */

CREATE OR REPLACE PROCEDURE cliente_compra_produto 
( vprod IN VARCHAR2, vini IN pedido.dt_hora_ped%TYPE, vfim IN pedido.dt_hora_ped%TYPE, 
  vcoluna1 IN VARCHAR2, vcoluna2 IN VARCHAR2, vcoluna3 IN VARCHAR2 ) 
IS 
TYPE vcliprod IS REF CURSOR ;
vCursor_cliprod vcliprod ;
vdinSelect VARCHAR2(4000) ;
vaux1 VARCHAR2(4000) ;
vaux2 VARCHAR2(4000) ;
vaux3 VARCHAR2(4000) ;
BEGIN
-- montando o select que vai retornar mais de uma linha
vdinSelect := 'SELECT c.'||vcoluna1||', c.'||vcoluna2||', c.'||vcoluna3||' 
                      FROM itens_pedido i, pedido p, cliente c, produto pr
                      WHERE pr.nome_prod = :1
                      AND i.cod_prod = pr.cod_prod
                      AND i.num_ped = p.num_ped
                      AND p.cod_cli = c.cod_cli 
                      AND p.dt_hora_ped BETWEEN :2 AND :3' ;
DBMS_OUTPUT.PUT_LINE ( vdinSelect) ;
DBMS_OUTPUT.PUT_LINE (vcoluna1||'-'||vcoluna2||'-'||vcoluna3) ;
DBMS_OUTPUT.PUT_LINE ( RPAD('-', 50, '-') ) ;
-- abrindo o cursor e exibindo os dados
  OPEN vCursor_cliprod FOR vdinSelect USING vprod, vini, vfim ; 
     LOOP
     FETCH vCursor_cliprod INTO vaux1,vaux2,vaux3 ;
     EXIT WHEN vCursor_cliprod%NOTFOUND ;
          DBMS_OUTPUT.PUT_LINE ( TRIM ( vaux1)||'-'||TRIM ( vaux2)||'-'||TRIM ( vaux3) ) ;

     END LOOP ;
   CLOSE vCursor_cliprod ;
END ;

BEGIN
cliente_compra_produto ( 'Bola NBA', current_date - 100, current_date , 'nome_fantasia', 'endereco_cli', 'tipo_cli')  ;
END ;
