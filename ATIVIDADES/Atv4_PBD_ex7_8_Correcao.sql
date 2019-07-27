/******************************
Aula 6 - 18/abril/19
*******************************/
/***** Atividade 4 
7 -  Alterar a tabela Itens de Pedido incluindo uma nova coluna preco_item. 
Atualize o valor dessa coluna para que os itens tenham preço 0,5% menor que o valor original do produto 
( está na tabela produto).
Após essas alterações elabore um controle para evitar que o preço do item de um produto -
ao ser inserido ou atualizado- seja maior que o preço original do produto. */
ALTER TABLE itens_pedido DROP COLUMN num_item ;

SELECT * FROM itens_pedido ;
-- alterando a tabela itens pedido para construir a procedure abaixo
ALTER TABLE itens_pedido ADD preco_item NUMBER(10,2) ;
ALTER TRIGGER valida_estoque DISABLE ;
UPDATE itens_pedido i SET i.preco_item = ( SELECT p.preco_venda*0.995 FROM produto p
WHERE p.cod_prod = i.cod_prod ) ;

-- gatilho para validar o preço do item
CREATE or replace trigger valida_preco_item
BEFORE insert or update on itens_pedido
for each row
DECLARE
vpreco produto.preco_venda%TYPE ;
PRAGMA AUTONOMOUS_TRANSACTION ;
BEGIN
select preco_venda into vpreco
from produto
where cod_prod = :NEW.cod_prod ;
IF :NEW.preco_item > vpreco  OR :NEW.preco_item = 0 THEN
   raise_application_error ( -20032, 'Preco do item não pode ser maior que o sugerido para o produto nem ser de graça!!');
END IF ;
END;

-- teste
SELECT get_preco( 5010) FROM dual ;
INSERT INTO itens_pedido VALUES ( 1905 , 5010, 1, 0, 'SEPARACAO', 108, null );


/****
8 - Elaborar um extrato do pedido no seguinte formato (faça de duas maneiras : com cursor FETCH e cursor FOR):
Pedido : 1906   Data : 01/MAR/2019 Cliente : José Arimatéia   Forma Pagamento : Cartao Credito
----------------------------------------------------------------------------------------------------------------------------
Item	Produto		Preço Item	Qtde Pedida Valor Item	Valor Pedido		
1	Bola Futebol 		  30,00		    3	         90,00		     90,00
2	Meia Futebol		  19,00		    1	         19,00		    109,00
3	Camisa Seleção	 150,00	    2	        300,00	    	    409,00
----------------------------------------------------------------------------------------------------------------------------
Total Pedido : 409,00		Vendedor : Lúcia Castro   ***/


-- usando cursor fetch -- funcionou 10/abril
CREATE OR REPLACE PROCEDURE cupompedido (vped IN INTEGER)
IS
   CURSOR cupom IS
   SELECT i.*, pr.nome_prod
    FROM itens_pedido i, produto pr
    where i.cod_prod = pr.cod_prod
          and i.num_ped = vped
          ORDER BY pr.nome_prod ;
          
pedidolinha cupom%ROWTYPE ;
vdata pedido.dt_hora_ped%TYPE ;
vcliente cliente.nome_fantasia%TYPE ;
vpgto forma_pgto.descr_forma_pgto%TYPE ;
vvendor funcionario.nome_func%TYPE ;
vtotallinha pedido.vl_total_ped%TYPE ;
separador VARCHAR2(100) := RPAD('-',99,'-');
cabecalho VARCHAR2(100) ;
vindice SMALLINT := 1 ;
   BEGIN
   select c.nome_fantasia, p.dt_hora_ped, fp.descr_forma_pgto, f.nome_func
          INTO vcliente, vdata, vpgto, vvendor
          from cliente c, pedido p, funcionario f, forma_pgto fp
          where c.cod_cli = p.cod_cli
          and p.reg_func_vendedor = f.reg_func
          and p.forma_pgto = fp.cod_forma
          and p.num_ped = vped ;
         
cabecalho := 'Pedido : '|| TO_CHAR (vped)||' Data : ' ||
TO_CHAR(vdata,'DD-MON-YYYY')
||' Cliente : '||vcliente||' Forma Pagto: '||vpgto;
DBMS_OUTPUT.put_line ( cabecalho) ;
DBMS_OUTPUT.put_line ( separador ) ;
DBMS_OUTPUT.put_line ( '  Item  |           Produto            | 
Preço Item  |  Qtde Pedida   | Valor Item  | Valor Pedido') ;
vtotallinha := 0 ;
   OPEN cupom ;
   LOOP
   FETCH cupom INTO pedidolinha ;
     EXIT WHEN cupom%NOTFOUND ;
   
   vtotallinha := vtotallinha + pedidolinha.qtde_pedida*pedidolinha.preco_item;
    
  DBMS_OUTPUT.put_line ( 
 TO_CHAR (vindice, '009999')||
 ' | '||RPAD(pedidolinha.nome_prod,29,' ')||'|'||
 TO_CHAR(pedidolinha.preco_item,'$999999D99')||'    |    '||
 TO_CHAR(pedidolinha.qtde_pedida,'9999')||'       |  '||
 TO_CHAR(pedidolinha.preco_item*pedidolinha.qtde_pedida, '$9999999D99')||'| '||
 TO_CHAR(vtotallinha,'$9999999D99')) ;
  vindice := vindice + 1 ;
END LOOP ;
CLOSE cupom ;
DBMS_OUTPUT.put_line ( separador ) ;
DBMS_OUTPUT.put_line ( 'Total Pedido : '||
                        TO_CHAR (vtotallinha, '$99999999D999')||
                          '  Vendedor : ' || vvendor );
END ;
-- executando
BEGIN
cupompedido (1906) ;
END ;

select * from itens_pedido;

-- usando cursor FOR -- funcionou 10/abril
CREATE OR REPLACE PROCEDURE cupompedido_for (vped IN INTEGER)
IS
   CURSOR cupomfor IS
   SELECT i.*, pr.nome_prod
    FROM itens_pedido i, produto pr
    where i.cod_prod = pr.cod_prod
          and i.num_ped = vped ;

--pedidolinha cupom%ROWTYPE ;
vdata pedido.dt_hora_ped%TYPE ;
vcliente cliente.nome_fantasia%TYPE ;
vpgto forma_pgto.descr_forma_pgto%TYPE ;
vvendor funcionario.nome_func%TYPE ;
vtotallinha pedido.vl_total_ped%TYPE ;
cabecalho VARCHAR2(100) ;
vindice SMALLINT := 1 ;
   BEGIN
   select c.nome_fantasia, p.dt_hora_ped, fp.descr_forma_pgto, f.nome_func
          INTO vcliente, vdata, vpgto, vvendor
          from cliente c, pedido p, funcionario f, forma_pgto fp
          where c.cod_cli = p.cod_cli
          and p.reg_func_vendedor = f.reg_func
          and p.forma_pgto = fp.cod_forma
          and p.num_ped = vped ;
         
cabecalho := 'Pedido : '|| TO_CHAR (vped)||'Data : ' ||TO_CHAR(vdata,'DD-MON-YYYY')||' Cliente : '||vcliente||' Forma Pagto: '||vpgto;
DBMS_OUTPUT.put_line ( cabecalho) ;
DBMS_OUTPUT.put_line ( '  Item  |           Produto           |  Preço Item  |  Qtde Pedida   | Valor Item  | Valor Pedido') ;
vtotallinha := 0 ;
FOR j IN cupomfor LOOP

   vtotallinha := vtotallinha + j.qtde_pedida*j.preco_item;
    
    DBMS_OUTPUT.put_line ( TO_CHAR (vindice, '009999')|| '  '||RPAD(j.nome_prod,30,' ')||
    TO_CHAR(j.preco_item,'999999D99')||'         '||TO_CHAR(j.qtde_pedida,'9999')||'         '||
    TO_CHAR(j.preco_item*j.qtde_pedida, '9999999D99')||
    TO_CHAR(vtotallinha,'9999999D99')) ;
    vindice := vindice + 1 ;
END LOOP ;
--CLOSE cupom ;
DBMS_OUTPUT.put_line ( 'Total Pedido : '||
                        TO_CHAR (vtotallinha, '99999999D99')||
                          '  Vendedor : ' || vvendor );
END ;

BEGIN
cupompedido_for (1906) ;
END ;