/*****************************
F U N Ç Õ E S  - Aula 28/fev/2019
*****************************/
--Elaborar uma função que retorne o preço do produto passando seu código como parâmetro ;
CREATE OR REPLACE FUNCTION get_preco ( vprod IN produto.cod_prod%TYPE ) 
RETURN NUMBER IS
vpreco produto.preco_venda%TYPE ;
BEGIN
SELECT preco_venda INTO vpreco
FROM produto
WHERE cod_prod = vprod ;
RETURN vpreco ;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RAISE_APPLICATION_ERROR ( -20999, 'Produto '||TO_CHAR(vprod)||' não localizado!!!');
END ;
-- testando
SELECT get_preco( 5050) FROM dual ;

/* Aula FATEC 28/fev/2019 Elabore uma função que retorne o preço sugerido de um produto passando como parâmetro o nome ou parte do nome.
Suponha que o nome do produto é único, não se repete.  */
CREATE OR REPLACE FUNCTION get_preco_nome ( vprod IN produto.nome_Prod%TYPE)
RETURN NUMBER IS
vpreco produto.preco_venda%TYPE ;
vbusca produto.nome_prod%TYPE := '%'||UPPER(vprod)||'%' ;
vqtos_tem SMALLINT := 0 ;
BEGIN
SELECT COUNT(*) INTO vqtos_tem
FROM produto
WHERE UPPER(nome_prod) LIKE vbusca ;
IF vqtos_tem = 0 THEN
    RAISE_APPLICATION_ERROR ( -20100, 'Produto não localizado !!!') ;
ELSIF vqtos_tem > 1 THEN
   RAISE_APPLICATION_ERROR ( -20101, 'Mais de um produto com este nome! Refine sua busca!') ;
ELSIF vqtos_tem = 1 THEN
      SELECT preco_venda INTO vpreco
      FROM produto
      WHERE UPPER(nome_prod) LIKE vbusca ;
END IF;
RETURN vpreco ;
END ;
-- testando
SELECT get_preco_nome ( 'blablabla') FROM dual ;
SELECT get_preco_nome ( 'tenis') FROM dual ;
SELECT get_preco_nome ( 'tenis slim') FROM dual ;


/**********************************************************************************************
Atividades 3 e 4 - Fatec Correção 07/mar/2019
**********************************************************************************************/
--3-Validar o vendedor que atende o pedido garantindo que o cargo deste funcionário corresponde ao de um Vendedor;
CREATE OR REPLACE TRIGGER validavendedor 
BEFORE INSERT OR UPDATE ON pedido
FOR EACH ROW
DECLARE
vcargo cargo.nome_cargo%TYPE ;
BEGIN
select nome_cargo into vcargo
from funcionario f, cargo c
where f.cod_cargo = c.cod_cargo
and f.reg_func = :NEW.reg_func_vendedor ;
IF upper(vcargo) NOT LIKE '%VENDEDOR%' THEN
  RAISE_APPLICATION_ERROR ( -20003, 'Vendedor não confere com o cargo!!. Ele é '||vcargo);
END IF ;
END ;

select * from funcionario ;
select * from cargo ;
SELECT * from pedido ;

INSERT INTO pedido VALUES ( pedido_cod.nextval, current_timestamp - 100, 'FONE' , 1000, 15, 12, 'o mesmo', 
 'CTCRED' , 200, 15 , 'APROVADO'); -- ok deu erro
 
 UPDATE pedido SET reg_func_vendedor = 1 WHERE num_ped = 1920 ;

--4-Validar a região do vendedor que atende o pedido para a mesma região do cliente, ou seja, 
--não permitir que um vendedor de outra região atenda o cliente;
descr pedido ;
descr funcionario ;
desc cliente ;
descr regiao;
SELECT * FROM cargo ;

CREATE OR REPLACE trigger valida_vendedor_regiao
BEFORE INSERT OR UPDATE ON pedido
FOR EACH ROW
DECLARE
rvendor regiao.cod_regiao%TYPE ;  -- captura a regiao do vendedor
rcliente regiao.cod_regiao%TYPE ; -- captura a regiao do cliente
BEGIN
SELECT c.cod_regiao INTO rcliente 
from cliente c
where c.cod_cli =:NEW.cod_cli ;

SELECT f.cod_regiao INTO rvendor
from  funcionario f
where f.reg_func = :NEW.reg_func_vendedor ;

IF rcliente <> rvendor THEN
  RAISE_APPLICATION_ERROR ( -20004 , 'Vendedor nao pertence à mesma regiao do cliente !!'
  ||'Vendedor : '||TO_CHAR(rvendor)|| ' x  Cliente :'||TO_CHAR(rcliente));
END IF ;
END ;

descr pedido ;
INSERT INTO pedido VALUES ( pedido_cod.nextval, current_timestamp - 100, 'FONE' , 1000, 15, 12, 'o mesmo', 
 'CTCRED' , 200, 4 , 'APROVADO'); -- ok erro