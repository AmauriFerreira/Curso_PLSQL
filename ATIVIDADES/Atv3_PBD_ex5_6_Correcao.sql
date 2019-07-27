/* Aktv 3 - 5-  Elabore uma função que retorne a quantidade e a soma do valor total dos pedidos feitos por um cliente 
passando como parâmetro o nome ou parte do nome, em um intervalo de tempo.  */
CREATE OR REPLACE TYPE resultado_cli AS VARRAY(5) OF NUMBER ;
CREATE OR REPLACE FUNCTION qtde_pedidos ( vcli IN cliente.nome_fantasia%TYPE ,
vini IN pedido.dt_hora_ped%TYPE, vfim IN pedido.dt_hora_ped%TYPE)
RETURN resultado_cli
IS vqtde resultado_cli := resultado_cli() ;
vargumento cliente.nome_fantasia%TYPE := '%'||UPPER(vcli)||'%' ;
vsetem SMALLINT := 0 ;
BEGIN
vqtde.EXTEND(2) ;
SELECT COUNT(*) INTO vsetem FROM cliente
WHERE upper(nome_fantasia) LIKE vargumento ;
IF vsetem = 1 THEN
SELECT COUNT(*), SUM(p.vl_total_ped)  INTO vqtde(1), vqtde(2) 
FROM pedido p, cliente c
WHERE p.cod_cli = c.cod_cli
AND upper(nome_fantasia) LIKE vargumento
AND p.dt_hora_ped BETWEEN vini AND vfim ;
ELSIF vsetem > 1 THEN
RAISE_APPLICATION_ERROR ( -20011, 'Existe mais de um cliente com este nome. Seja mais específico!');
END IF ;
RETURN vqtde ;
 EXCEPTION
WHEN NO_DATA_FOUND THEN
RAISE_APPLICATION_ERROR ( -20029, 'Cliente não encontrado'); 
END ;

SELECT qtde_pedidos('gun', current_date - 1000, current_date) FROM DUAL;

SELECT * FROM cliente ;

--Aktv 3 - 6 - Elabore uma função que retorne o valor total vendido, calculado em reais,
--para um determinado Gerente de uma equipe de vendas em um período de tempo,
--tendo como parâmetros de entrada o código do gerente e as datas de início e término do período, ou seja, 
--quanto foi vendido pelos vendedores que são gerenciados por este gerente. 
--Considere que na tabela de cargo existe o cargo “Gerente Vendas”. Faça as validações necessárias.

ALTER TRIGGER valida_admissao DISABLE ;
SELECT * FROM cargo ; -- gerente vendas = 9 
SELECT * FROM funcionario WHERE REG_FUNC_GERENTE = 9 ;
UPDATE funcionario SET cod_cargo = 9 WHERE cod_cargo = 10 ;

SELECT f.*
FROM funcionario f, cargo c
WHERE f.cod_cargo = c.cod_cargo
AND UPPER( c.nome_cargo) LIKE '%GERENTE DE VENDAS%' ;

-- função
CREATE OR REPLACE FUNCTION total_gerente_vendas ( vgerente IN funcionario.reg_func%TYPE, 
vini IN pedido.dt_hora_ped%TYPE, vfim IN pedido.dt_hora_ped%TYPE)
RETURN NUMBER IS
vtotal pedido.vl_total_ped%TYPE  := 0 ;
vsegerente cargo.nome_cargo%TYPE ;
BEGIN
SELECT c.nome_cargo INTO vsegerente
FROM funcionario f, cargo c
WHERE f.cod_cargo = c.cod_cargo
AND f.reg_func = vgerente ;

IF UPPER (vsegerente) NOT LIKE '%GERENTE DE VENDAS%'  THEN
       RAISE_APPLICATION_ERROR ( -20001, ' Funcionario não é gerente de Vendas !!' );
ELSE
       SELECT SUM(p.vl_total_ped) INTO vtotal
       FROM pedido p, funcionario f
       WHERE p.reg_func_vendedor = f.reg_func
       AND f.reg_func_gerente = vgerente
       AND p.dt_hora_ped BETWEEN vini AND vfim ;
END IF;
RETURN vtotal ;
END ;

-- testando
SELECT total_gerente_vendas (2, current_timestamp - 500, current_timestamp) FROM dual ;
