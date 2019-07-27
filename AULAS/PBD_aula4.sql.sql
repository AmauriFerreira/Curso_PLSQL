Aula 4 FATEC - 07/03/2019

CREATE OR REPLACE FUNCTION comissao_vendedor (vvendor IN pedido.reg_func_vendedor%TYPE, vini IN pedido.dt_hora_ped%TYPE,
vfim IN pedido.dt_hora_ped%TYPE, vcomissao IN 	NUMBER)
RETURN NUMBER IS
vtotal_comissao pedido.vl_total_ped%TYPE;
vcargo cargo.nome_cargo%TYPE;
BEGIN
----VALIDANDO A FAIXA DE VALORES DO PERCENTUAL DE COMISSAO------

IF vcomissao IS NULL OR vcomissao NOT BETWEEN 0 TO 100 THEN
RAISE_APPLICATION_ERROR(-20100,'percentual da comissão é obrigatorio e deve estar  entre 0 e 1001');
END IF;

---VALIDANDO AS DATAS---
IF vfim <vini OR vfim IS NULL OR vini IS NULL THEN 
RAISE_APPLICATION_ERROR(-20104,'Dats são obrigatórias e data finalç deve ser maior que a inicial!');
END IF;

----VALIDANDO SE O FUNCIONÁRIO É VENDEDOR MESMO---
SELECT UPPER (c.nome-cargo)INTO vcargo
FROM cargo c JOIN funcionario f 
ON (c.cod_cargo = f.cod_cargo)
WHERE f.reg_func = vvendor;
IF vcargo NOT LIKE 'VENDE%' THEN 
RAISE_APPLICATION_ERROR(-20101,' Funcionário'||TO_CHAR(vvendor)||'é'||vcargo);
END IF;

END;
----CÁLCULO DA COMISSAO---

SELECT SUM (p.vl_total_ped*vcomissao)/100 INTO vtotal_comissao
FROM pedido p
WHERE p.reg_func_vendedor=vvendor
AND p.dt_hora_ped BETWEEN vini AND vfim;
RETURN vtotal_comissao

EXCEPTION
WHEN NO_DATA_FOUD THEN 
RAISE_APPLICATION_ERROR (-20102,'Dados não encontrados !');
END;

---TESTANDO---

SELECT comissao_vendedor (8, current_date, current_date -1 ,0) FROM dual;
SELECT reg_func_vendedor FROM pedido;

/*ELABORA UMA FUNÇÃO QUE RETORNE O VALOR TOTAL VENDIDO, CALCULE EM REAIS,PARA UM DETERMINADO PRODUTO EM UM 
PERIODO DE TEMPIO, E A QUANTIDADE DE ITENS VENIDOS,TENDO COMO PARÂMETROS DE ENTRADA O CÓDIGO DO PRODUTO E 
AS DATAS DE INICIO E TERMINO DO PERIODOD,OU SEJA, QUANDO O PRODUTO VENDEU CONSIDERANDO TODOS OS PEDIDOS 
EM QUE APARECE NAQUELE PERIODO*/

CREATE OR REPLACE TYPE resultados IS VARRAY (5) OF NUMBER;
CREATE 







