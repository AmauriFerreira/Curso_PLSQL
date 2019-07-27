-- Programação BD Vendas Produtos Esportivos
-- Versao para Oracle 11g
/*
cliente ( cod_cli(PK), limite_credito, endereco_cli, fone_cli, situacao_cli, tipo_cli, cod_regiao(fk))
cliente_pf (cod_cli_pf(PK)(FK), nome_fantasia, cpf_cli, sexo_cli, profissao_cli)
cliente_pj (cod_cli_pj(PK)(FK), razao_social_cli, cnpj_cli, ramo_atividade_cli)
produto ( cod_prod(PK), nome_prod, descr_prod, categ_esporte, preco_venda, preco_custo, peso, marca, tamanho)
funcionario ( reg_func(PK), nome_func, end_func, depto, sexo_func, dt_admissao, cargo, cod_regiao(fk))
regiao (cod_regiao(PK), nome_regiao)
deposito ( cod_depo(PK), nome_depo, end_depo, cidade_depo, pais_depo, cod_regiao(fk))
pedido ( num_ped(PK), dt_hora_ped, tp_atendimento, vl_total_ped, vl_descto, vl_frete,
 end_entrega, forma_pgto, cod_cli(fk), reg_func_vendedor(fk))
itens_pedido (num_ped(FK)(PK), cod_prod(fk)(PK), qtde_item, descto_item)
armazenamento ( cod_depo(FK)(PK), cod_prod(FK)(PK), qtde_estoque, end_estoque)*/


/* parametros de configuracao da sessao */
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY HH24:MI:SS';
ALTER SESSION SET NLS_LANGUAGE = PORTUGUESE;
SELECT SESSIONTIMEZONE, CURRENT_TIMESTAMP FROM DUAL;

--Aula FATEC 21/fev/2019 -Validar a inserção de um produto como item desde que a quantidade pedida 
--seja menor ou igual à quantidade em estoque para o depósito que atende à região do cliente, ou seja, 
--não será possível cadastrar um item no pedido se não houver quantidade suficiente no estoque.
CREATE OR REPLACE TRIGGER valida_estoque
BEFORE INSERT OR UPDATE ON itens_pedido
FOR EACH ROW
DECLARE
vdepocli deposito.cod_depo%TYPE ;
vqtde_estoque armazenamento.qtde_estoque%TYPE ;
BEGIN
-- buscando o deposito do cliente que fez o pedido
SELECT d.cod_depo INTO vdepocli
FROM deposito d, regiao r, cliente c, pedido p
WHERE d.cod_regiao = r.cod_regiao
AND r.cod_regiao = c.cod_regiao
AND c.pais_cli = d.pais_depo
AND p.cod_cli = c.cod_cli
AND p.num_ped = :NEW.num_ped ;
-- buscando a qtde de estoque para o produto armazenado no deposito acima
SELECT a.qtde_estoque INTO vqtde_estoque
FROM armazenamento a
WHERE a.cod_depo = vdepocli
AND a.cod_prod = :NEW.cod_prod ;
-- validar se a qtde é suficiente
IF vqtde_estoque < :NEW.qtde_pedida THEN
RAISE_APPLICATION_ERROR ( -20003, 
'Qtde insuficiente para o item. Faltam '||
TO_CHAR (:NEW.qtde_pedida - vqtde_estoque)|| ' unidades');
END IF ;
END ;

SELECT cod_cli FROM pedido WHERE num_ped = 1900 ;
SELECT cod_regiao, pais_cli FROM cliente WHERE cod_cli = 200 ;
SELECT cod_depo FROM deposito WHERE cod_regiao = 2 AND pais_depo = 'BRA' ; -- 201
SELECT * FROM itens_pedido WHERE num_ped = 1900 ; -- 5005 tem 4 pedido
SELECT qtde_estoque FROM armazenamento WHERE cod_depo = 101 AND cod_prod = 5002 ;

SELECT * FROM armazenamento WHERE cod_depo = 101 ;
SELECT cod_regiao FROM deposito WHERE cod_depo = 101 ;
SELECT cod_cli FROM cliente WHERE cod_regiao = 1 ;
SELECT num_ped from pedido WHERE cod_cli = 203 ;
SELECT * FROM itens_pedido WHERE num_ped = 1901 ;
SELECT * FROM pedido WHERE num_ped = 1901 ;
SELECT cod_regiao 

UPDATE itens_pedido SET qtde_pedida = 181 WHERE num_ped = 1910 
AND cod_prod = 5002 ;
SELECT * FROM itens_pedido WHERE num_ped = 1910 AND cod_prod = 5002 ;

SELECT qtde_estoque 
cod_regiao = 5 ;
SELECT cod_regiao, pais_cli FROM cliente WHERE cod_cli = 201 ;
SELECT * from deposito where cod_regiao = 5 ;

SELECT * FROM armazenamento WHERE cod_prod = 5002 ;
SELECT cod_regiao FROM deposito WHERE cod_depo IN ( 101, 105 ) ;
SELECT cod_cli FROM cliente WHERE cod_regiao = 6 ;
SELECT * FROM pedido WHERE cod_cli = 210 ;
SELECT * FROM itens_pedido WHERE num_ped = 1910 ;

SELECT * FROM pedido where cod_cli = 210 ; 1910
SELECT * FROM cliente WHERE cod_regiao = 6 ; 207 ou 210
SELECT * FROM itens_pedido WHERE num_ped = 1910 ;
SELECT * FROM deposito ; dep=105 , r=6 , pais = ALE
SELECT * FROM armazenamento where cod_depo = 105 ; prod = 5002 tem 150

update itens_pedido set qtde_pedida = 151 where cod_prod = 5002 AND num_ped = 1910 ;

/****************************************************************************************************************
Gatilho para atualizar o valor do pedido conforme inserção ou alteração no item do pedido - FATEC 21/fev/2019 -- OK
***************************************************************************************************************/
ALTER TABLE itens_pedido ADD situacao_item CHAR(15) 
CHECK ( situacao_item IN ( 'SEPARACAO', 'ENTREGUE', 'CANCELADO', 'DESPACHADO')) ;

UPDATE itens_pedido SET situacao_item = 'SEPARACAO' ;
ALTER TRIGGER valida_estoque ENABLE ;

CREATE OR REPLACE TRIGGER atualiza_pedido
AFTER INSERT OR UPDATE ON itens_pedido
FOR EACH ROW
DECLARE
vtotalped_antes pedido.vl_total_ped%TYPE ;
vtotalped_depois pedido.vl_total_ped%TYPE ;
vpreco_prod produto.preco_venda%TYPE ;
vpedido pedido.num_ped%TYPE ;
BEGIN
-- busca o preço do produto que está sendo manipulado
SELECT pr.preco_venda INTO vpreco_prod
FROM produto pr
WHERE pr.cod_prod = :NEW.cod_prod ;
-- no caso de insercao somar o valor do item
IF INSERTING THEN
   SELECT p.vl_total_ped INTO vtotalped_antes
   FROM pedido p
   WHERE p.num_ped = :NEW.num_ped ;
   vpedido := :NEW.num_ped ;
   vtotalped_depois := vtotalped_antes +
 :NEW.qtde_pedida * vpreco_prod * ( 100 - :NEW.descto_itens_pedido)/100;
ELSIF UPDATING AND :OLD.situacao_item = 'SEPARACAO' THEN
   SELECT p.vl_total_ped INTO vtotalped_antes
   FROM pedido p
   WHERE p.num_ped = :OLD.num_ped ;
   vpedido := :OLD.num_ped ;
   -- cancelamento - estornar o valor do item
   IF :NEW.situacao_item = 'CANCELADO' AND 
      :NEW.situacao_item <> :OLD.situacao_item THEN
	vtotalped_depois := vtotalped_antes - :OLD.qtde_pedida*vpreco_prod*( 100 - :OLD.descto_itens_pedido)/ 100 ;
   END IF ;
   -- mudando a qtde, mas desconto igual
   IF :NEW.qtde_pedida <> :OLD.qtde_pedida AND :NEW.descto_itens_pedido = :OLD.descto_itens_pedido THEN
    vtotalped_depois := vtotalped_antes + (:NEW.qtde_pedida - :OLD.qtde_pedida)*vpreco_prod*
	( 100 - :OLD.descto_itens_pedido)/100 ;
   END IF ;
   -- mesma qtde, mudando desconto
   IF :NEW.qtde_pedida = :OLD.qtde_pedida AND :NEW.descto_itens_pedido <> :OLD.descto_itens_pedido THEN
    vtotalped_depois := vtotalped_antes + :OLD.qtde_pedida*vpreco_prod*
	 (:OLD.descto_itens_pedido-:NEW.descto_itens_pedido)/100 ;
   END IF ;
   -- muda qtde e desconto - valor antes + diferença novo valor total item e valor total item antes
   IF :NEW.qtde_pedida <> :OLD.qtde_pedida AND :NEW.descto_itens_pedido <> :OLD.descto_itens_pedido THEN
    vtotalped_depois := vtotalped_antes + 	:NEW.qtde_pedida*vpreco_prod* ( 100 -:NEW.descto_itens_pedido)/100 -
    	:OLD.qtde_pedida*vpreco_prod* ( 100 -:OLD.descto_itens_pedido)/100; 
   END IF ;
END IF ;
-- atualiza o valor na tabela pedido
IF vtotalped_antes <> vtotalped_depois THEN
UPDATE pedido p SET p.vl_total_ped = vtotalped_depois
WHERE p.num_ped = vpedido ;
END IF ;
END ;

ALTER TRIGGER valida_estoque DISABLE ;

SELECT * FROM pedido WHERE num_ped = 1905 ;
SELECT * FROM itens_pedido WHERE num_ped = 1905 ; 
SELECT * FROM produto WHERE cod_prod = 5003 ;
UPDATE produto SET preco_venda = 100 WHERE cod_prod = 5003 ;  -- mudando preço para 100
UPDATE ITENS_pedido SET DESCTO_ITENS_PEDIDO = 10 WHERE num_ped = 1905 ; -- todos itens com 10%
-- recalculando o valor total dos pedidos
UPDATE pedido ped
SET ped.vl_total_ped =
(SELECT sum(i.qtde_pedida*p.preco_venda*(100-i.descto_itens_pedido)/100) 
FROM itens_pedido i, produto p
WHERE ped.num_ped = i.num_ped
AND i.cod_prod = p.cod_prod );

-- Testes 
  
-- Pedido 1905 -> $ 12024 -- todos itens com 10% desconto e item 5003 $100
-- mudando a qtde -- aumentei 10, era 30 foi pra 40
UPDATE itens_pedido SET QTDE_PEDIDA = 40 WHERE COD_PROD = 5003 AND NUM_PED = 1905 ; -- 12924
-- 10x(100-10)/100 = 900 a mais // bateu
-- voltando -- colocando 30 de novo
UPDATE itens_pedido SET QTDE_PEDIDA = 30 WHERE COD_PROD = 5003 AND NUM_PED = 1905 ; -- 12024 // bateu
-- mudando desconto -- mais 10% -- preço passou a 80, diminui 10 reais por unidade x 30 unidades diminui 300 
UPDATE itens_pedido SET DESCTO_ITENS_PEDIDO = 20 WHERE COD_PROD = 5003 AND NUM_PED = 1905 ; --11724//bateu
-- voltando
UPDATE itens_pedido SET DESCTO_ITENS_PEDIDO = 10 WHERE COD_PROD = 5003 AND NUM_PED = 1905 ; --12024//bateu
-- mudando os dois, unidade custa 100, aumentou 10 unidades pedidas então 
-- $100 x 40 - $90x30 = 1300 a mais 
UPDATE itens_pedido SET QTDE_PEDIDA = 40, DESCTO_ITENS_PEDIDO = 0
WHERE COD_PROD = 5003 AND NUM_PED = 1905 ; -- 13324 // bateu
-- voltando
UPDATE itens_pedido SET QTDE_PEDIDA = 30, DESCTO_ITENS_PEDIDO = 10
WHERE COD_PROD = 5003 AND NUM_PED = 1905 ; -- 12024 //bateu
-- mudando os dois, unidade custa 80 agora , diminui 10 unidades então 
-- $90x30 - $80x20 = 2700 - 1600 -> diminui 1100 
UPDATE itens_pedido SET QTDE_PEDIDA = 20, DESCTO_ITENS_PEDIDO = 20
WHERE COD_PROD = 5003 AND NUM_PED = 1905 ; -- 10924 = 12024 - 1100 //bateu

