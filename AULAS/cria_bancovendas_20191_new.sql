-- Criacao e populacao de tabelas BD Vendas Produtos Esportivos
-- Versao para Oracle 10g
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

-- Sequencias
DROP SEQUENCE pedido_cod;
CREATE SEQUENCE pedido_cod MINVALUE 1 MAXVALUE 9999999 INCREMENT BY 1 START WITH 1900 ;

DROP SEQUENCE produto_cod;
CREATE SEQUENCE produto_cod MINVALUE 1 MAXVALUE 9999999 INCREMENT BY 1 START WITH 5000 ;

-- Tabela regiao
DROP TABLE regiao CASCADE CONSTRAINTS;
CREATE TABLE regiao
(cod_regiao NUMBER(2),
 nome_regiao VARCHAR2(50)
 CONSTRAINT reg_nome_nn NOT NULL,
 CONSTRAINT reg_cod_pk PRIMARY KEY (cod_regiao),
 CONSTRAINT reg_nome_uk UNIQUE (nome_regiao));

INSERT INTO regiao VALUES (1, 'America do Norte');
INSERT INTO regiao VALUES (2, 'America do Sul');
INSERT INTO regiao VALUES (3, 'America Central');
INSERT INTO regiao VALUES (4, 'Africa');
INSERT INTO regiao VALUES (5, 'Asia');
INSERT INTO regiao VALUES (6, 'Europa');

--Tabela CLIENTE
DROP TABLE cliente CASCADE CONSTRAINTS;
CREATE TABLE cliente
(cod_cli INTEGER,
 limite_credito NUMBER(12,2),
 endereco_cli VARCHAR2(400),
 fone_cli CHAR(15),
 situacao_cli CHAR(20),
 tipo_cli CHAR(20),
 cod_regiao NUMBER(2) REFERENCES regiao,
 CONSTRAINT cliente_cod_pk PRIMARY KEY (cod_cli));

ALTER TABLE cliente
 ADD CONSTRAINT chk_tp_cli CHECK ( tipo_cli IN ('PF', 'PJ'));

--Tabela CLIENTE FISICA
DROP TABLE cliente_pf CASCADE CONSTRAINTS;
CREATE TABLE cliente_pf
(cod_cli_pf INTEGER REFERENCES cliente ON DELETE CASCADE,
nome_fantasia VARCHAR2(50) CONSTRAINT cliente_nome_nn NOT NULL,
cpf_cli CHAR(11) not null UNIQUE,
sexo_cli CHAR(1) not null CHECK (sexo_cli IN ('M', 'F')),
profissao_cli CHAR(15),
CONSTRAINT cli_pf_pk PRIMARY KEY (cod_cli_pf));

--Tabela CLIENTE JURIDICA
DROP TABLE cliente_pj CASCADE CONSTRAINTS;
CREATE TABLE cliente_pj
(cod_cli_pj INTEGER REFERENCES cliente ON DELETE CASCADE,
razao_social_cli VARCHAR2(50) CONSTRAINT cliente_rzsoc_nn NOT NULL,
cnpj_cli CHAR(14) not null UNIQUE,
ramo_atividade_cli CHAR(15),
CONSTRAINT cli_pj_pk PRIMARY KEY (cod_cli_pj));

--Tabela func
--funcionario ( reg_func(PK), nome_func, end_func, depto, sexo_func, dt_admissao, cargo, cod_regiao(fk))

DROP TABLE funcionario CASCADE CONSTRAINTS;
CREATE TABLE funcionario
(reg_func NUMBER(7),
 nome_func VARCHAR2(25) CONSTRAINT func_nome_nn NOT NULL,
 end_func VARCHAR2(80) NOT NULL,
 sexo_func CHAR(1) CHECK ( sexo_func IN ('M', 'F')),
 dt_admissao DATE,
 cargo CHAR(20) NOT NULL,
 depto CHAR(20) NOT NULL,
 cod_regiao INTEGER NOT NULL REFERENCES regiao,
 CONSTRAINT func_pk PRIMARY KEY (reg_func));
 
-- Tabela deposito
--deposito ( cod_depo(PK), nome_depo, end_depo, cidade_depo, pais_depo, cod_regiao(fk), reg_func_gerente(FK))
DROP TABLE deposito CASCADE CONSTRAINTS;
CREATE TABLE deposito
(cod_depo NUMBER(3) CONSTRAINT deposito_cod_pk PRIMARY KEY ,
 nome_depo VARCHAR2(30) NOT NULL,
 end_depo VARCHAR2(100),
 cidade_depo VARCHAR2(30),
 pais_depo CHAR(20),
 cod_regiao INTEGER NOT NULL REFERENCES regiao,
 reg_func_gerente_deposito NUMBER(7) REFERENCES funcionario);
 
-- Tabela PRODUTO
--produto ( cod_prod(PK), nome_prod, descr_prod, categ_esporte, preco_venda, preco_custo, peso, marca)
DROP TABLE produto CASCADE CONSTRAINTS;
CREATE TABLE produto
(cod_prod NUMBER(7) CONSTRAINT prod_cod_pk PRIMARY KEY,
 nome_prod VARCHAR2(50) CONSTRAINT prod_nome_nn NOT NULL,
 descr_prod VARCHAR2(255),
 categ_esporte CHAR(20),
 preco_venda NUMBER(11, 2),
 preco_custo NUMBER(11, 2),
 peso NUMBER(5,2),
 marca CHAR(15) NOT NULL,
 CONSTRAINT prod_nome_uq UNIQUE (nome_prod));
 
 ALTER TABLE produto ADD tamanho CHAR(3) ;
 
-- Tabela PEDIDO
/* pedido ( num_ped(PK), dt_hora_ped, tp_atendimento, vl_vl_total_ped, vl_descto, vl_frete,
 end_entrega, forma_pgto, cod_cli(fk), reg_func_vendedor(fk)) */
DROP TABLE pedido CASCADE CONSTRAINTS;
CREATE TABLE pedido
(num_ped INTEGER CONSTRAINT ped_cod_pk PRIMARY KEY,
 dt_hora_ped TIMESTAMP NOT NULL,
 tp_atendimento CHAR(10),
 vl_total_ped NUMBER(11, 2),
 vl_descto_ped NUMBER(11, 2),
 vl_frete_ped NUMBER(11, 2),
 end_entrega VARCHAR2(80),
 forma_pgto CHAR(20),
 cod_cli INTEGER NOT NULL REFERENCES cliente,
 reg_func_vendedor NUMBER(7) REFERENCES funcionario);

--Tabela ARMAZENAMENTO
--armazenamento ( cod_depo(FK)(PK), cod_prod(FK)(PK), qtde_estoque, end_estoque)
DROP TABLE armazenamento CASCADE CONSTRAINTS;
CREATE TABLE armazenamento
(cod_depo NUMBER(3) NOT NULL REFERENCES deposito ON DELETE CASCADE,
 cod_prod NUMBER(7) NOT NULL REFERENCES produto ON DELETE CASCADE,
 qtde_estoque NUMBER(5),
 end_estoque VARCHAR2(25),
CONSTRAINT armazenamento_pk PRIMARY KEY (cod_depo, cod_prod));

-- Tabela itens_pedido DE PEDIDO
--itens_pedido (num_ped(FK)(PK), cod_prod(fk)(PK), qtde_item, descto_item)
DROP TABLE item_pedido CASCADE CONSTRAINTS;
DROP TABLE itens_pedido CASCADE CONSTRAINTS;
CREATE TABLE itens_pedido
(num_ped INTEGER REFERENCES pedido (num_ped) ON DELETE CASCADE,
 cod_prod NUMBER(7) REFERENCES produto (cod_prod) ON DELETE CASCADE,
 qtde_itens_pedido NUMBER(3),
 descto_itens_pedido NUMBER(5,2) ,
 CONSTRAINT itemped_pk PRIMARY KEY (num_ped, cod_prod));

-- Tabela Pais
DROP TABLE pais CASCADE CONSTRAINTS ;
CREATE TABLE pais
( sigla_pais CHAR(3) PRIMARY KEY,
nome_pais VARCHAR2(50) NOT NULL) ;

INSERT INTO pais VALUES ( 'BRA' , 'Brasil') ;
INSERT INTO pais VALUES ( 'EUA' , 'Estados Unidos da America') ;
INSERT INTO pais VALUES ( 'JAP' , 'Japao') ;
INSERT INTO pais VALUES ( 'ALE' , 'Alemanha') ;
INSERT INTO pais VALUES ( 'GBR' , 'Gra-Bretanha') ;
INSERT INTO pais VALUES ( 'IND' , 'India') ;
INSERT INTO pais VALUES ( 'CHI' , 'China') ;
INSERT INTO pais VALUES ( 'FRA' , 'Franca') ;
INSERT INTO pais VALUES ( 'ESP' , 'Espanha') ;

INSERT INTO pais VALUES ( 'ARG' , 'Argentina') ;
INSERT INTO pais VALUES ( 'URU' , 'Uruguai') ;
INSERT INTO pais VALUES ( 'POR' , 'Portugal') ;
INSERT INTO pais VALUES ( 'ITA' , 'Italia') ;
INSERT INTO pais VALUES ( 'COR' , 'Coreia do Sul') ;
INSERT INTO pais VALUES ( 'CAN' , 'Canada') ;


-- Tabela Marca
DROP TABLE marca cascade constraints;
CREATE TABLE marca
( sigla_marca CHAR(3) NOT NULL constraint fabr_sigla_pk PRIMARY KEY,
nome_marca VARCHAR2(30) NOT NULL,
pais_marca CHAR(3) NOT NULL REFERENCES pais (sigla_pais) ) ; 

INSERT INTO marca VALUES ('NIK' , 'NIKE' , 'EUA') ;
INSERT INTO marca VALUES ('MZN' , 'MIZUNO' , 'JAP') ;
INSERT INTO marca VALUES ('ADI' , 'ADIDAS' , 'ALE') ;
INSERT INTO marca VALUES ('RBK' , 'REBOOK' , 'EUA') ;
INSERT INTO marca VALUES ('PUM' , 'PUMA' , 'ALE') ;
INSERT INTO marca VALUES ('TIM' , 'TIMBERLAND' , 'EUA') ;
INSERT INTO marca VALUES ('WLS' , 'WILSON' , 'EUA') ;
INSERT INTO marca VALUES ('UMB' , 'UMBRO' , 'GBR') ;
INSERT INTO marca VALUES ('ASI' , 'ASICS' , 'JAP') ;
INSERT INTO marca VALUES ('PEN' , 'PENALTY' , 'BRA') ;
INSERT INTO marca VALUES ('UAR' , 'UNDER ARMOUR' , 'EUA') ;
INSERT INTO marca VALUES ('LOT' , 'LOTO' , 'ITA') ;

ALTER TABLE produto MODIFY marca CHAR(3) REFERENCES marca ( sigla_marca) ;

-- Tabela categoria esportiva
DROP TABLE categ_esporte cascade constraints;
CREATE TABLE categ_esporte
( categ_esporte CHAR(4) NOT NULL constraint mod_tp_pk PRIMARY KEY,
nome_esporte VARCHAR2(30) NOT NULL ) ; 

INSERT INTO categ_esporte VALUES ('FUTB' , 'Futebol de campo') ;
INSERT INTO categ_esporte VALUES ('BASQ' , 'Basquetebol') ;
INSERT INTO categ_esporte VALUES ('VOLQ' , 'Voleibol de quadra') ;
INSERT INTO categ_esporte VALUES ('CORR' , 'Corrida e Caminhada') ;
INSERT INTO categ_esporte VALUES ('TENQ' , 'Tenis de quadra') ;
INSERT INTO categ_esporte VALUES ('MARC' , 'Artes Marciais') ;
INSERT INTO categ_esporte VALUES ('CASU' , 'Casual') ;
INSERT INTO categ_esporte VALUES ('SKAT' , 'Skate') ;

ALTER TABLE produto MODIFY categ_esporte CHAR(4) REFERENCES categ_esporte ( categ_esporte) ;
ALTER TABLE produto MODIFY categ_esporte NOT NULL ;

-- Tabela CARGO
DROP TABLE cargo CASCADE CONSTRAINTS;
CREATE TABLE cargo
( cod_cargo NUMBER(2) CONSTRAINT cargo_cargo_pk PRIMARY KEY,
nome_cargo VARCHAR2(25));

INSERT INTO cargo VALUES (01,'Presidente');
INSERT INTO cargo VALUES (02, 'Vendedor');
INSERT INTO cargo VALUES (03, 'Operador de Estoque');
INSERT INTO cargo VALUES (04, 'VP, Administracao');
INSERT INTO cargo VALUES (05, 'VP, Financeiro');
INSERT INTO cargo VALUES (06, 'Auxiliar Administrativo');
INSERT INTO cargo VALUES (07, 'Atendente');
INSERT INTO cargo VALUES (08, 'Gerente de Deposito');
INSERT INTO cargo VALUES (09, 'Gerente de Vendas');
INSERT INTO cargo VALUES (10, 'Gerente Financeiro');
INSERT INTO cargo VALUES (11, 'Gerente Tecnologia');
INSERT INTO cargo VALUES (12, 'Analista Suporte');
INSERT INTO cargo VALUES (13, 'Desenvolvedor');

descr funcionario ;
ALTER TABLE funcionario MODIFY cargo NUMBER(2) REFERENCES cargo ;
ALTER TABLE funcionario RENAME COLUMN cargo TO cod_cargo ;

-- Tabela DEPTO
DROP TABLE depto CASCADE CONSTRAINTS;
CREATE TABLE depto
(cod_depto NUMBER(7),
 nome_depto VARCHAR2(30) CONSTRAINT depto_nome_nn NOT NULL,
 cod_regiao NUMBER(2) REFERENCES regiao (cod_regiao),
 CONSTRAINT depto_cod_pk PRIMARY KEY (cod_depto));
 
 SELECT * FROM regiao ;

INSERT INTO depto VALUES (10, 'Financeiro', 1);
INSERT INTO depto VALUES (11, 'Financeiro', 2);
INSERT INTO depto VALUES (12, 'Financeiro', 3);
INSERT INTO depto VALUES (13, 'Financeiro', 4);
INSERT INTO depto VALUES (14, 'Financeiro', 5);
INSERT INTO depto VALUES (31, 'Vendas', 1);
INSERT INTO depto VALUES (32, 'Vendas', 2);
INSERT INTO depto VALUES (33, 'Vendas', 3);
INSERT INTO depto VALUES (34, 'Vendas', 4);
INSERT INTO depto VALUES (35, 'Vendas', 5);
INSERT INTO depto VALUES (36, 'Vendas', 6);
INSERT INTO depto VALUES (41, 'Estoque', 1);
INSERT INTO depto VALUES (42, 'Estoque', 2);
INSERT INTO depto VALUES (43, 'Estoque', 3);
INSERT INTO depto VALUES (44, 'Estoque', 4);
INSERT INTO depto VALUES (45, 'Estoque', 5);
INSERT INTO depto VALUES (50, 'Administracao', 1);
INSERT INTO depto VALUES (51, 'Administracao', 2);
INSERT INTO depto VALUES (22, 'Tecnologia da Informacao', 1);
INSERT INTO depto VALUES (23, 'Tecnologia da Informacao', 2);

descr funcionario;
ALTER TABLE funcionario MODIFY depto NUMBER(7) REFERENCES depto;
ALTER TABLE funcionario RENAME COLUMN depto TO cod_depto;

-- Tabela Forma de pagamento
DROP TABLE forma_pgto CASCADE CONSTRAINTS;
CREATE TABLE forma_pgto
( cod_forma CHAR(6) PRIMARY KEY,
descr_forma_pgto VARCHAR2(30)) ;

INSERT INTO forma_pgto VALUES ( 'DIN', 'Dinheiro') ;
INSERT INTO forma_pgto VALUES ( 'CTCRED', 'Cartao de Credito') ;
INSERT INTO forma_pgto VALUES ( 'TICKET', 'Vale refeicao') ;
INSERT INTO forma_pgto VALUES ( 'DEBITO', 'Debito em conta') ;

ALTER TABLE pedido MODIFY forma_pgto CHAR(6) REFERENCES forma_pgto ;
ALTER TABLE pedido MODIFY forma_pgto NOT NULL ;

-- Adicionando auto-relacionamento a funcionario
ALTER TABLE funcionario
 ADD reg_func_gerente NUMBER(7) REFERENCES funcionario (reg_func) ;

-- relacionando deposito com o pais
descr deposito;
ALTER TABLE deposito MODIFY pais_depo CHAR(3) REFERENCES pais ;

--a) Inclua uma nova coluna em Pedido com a Situação;
ALTER TABLE pedido ADD situacao_ped CHAR(15) CHECK
( situacao_ped IN ('APROVADO', 'REJEITADO', 'EM SEPARACAO', 'DESPACHADO', 'ENTREGUE', 'CANCELADO'));

--b)Inclua uma nova coluna em Cliente e em Funcionário com o País e relacione com a tabela correspondente;
ALTER TABLE cliente ADD pais_cli CHAR(3) REFERENCES pais ;
ALTER TABLE funcionario ADD pais_func CHAR(3) REFERENCES pais ;

/*c) Crie as seguintes constraints de verificação : 
	Situação em Cliente : Ativo, Inativo, Suspenso */
ALTER TABLE cliente ADD CHECK ( situacao_cli IN ('ATIVO', 'INATIVO', 'SUSPENSO')); 

--Preço de venda maior ou igual a preço de custo
ALTER TABLE produto ADD CHECK ( preco_venda >= preco_custo) ;

--Valores e quantidades nunca com valor negativo
ALTER TABLE produto ADD CHECK ( preco_venda >= 0) ;
ALTER TABLE produto ADD CHECK ( preco_custo >= 0) ;
ALTER TABLE pedido ADD CHECK ( vl_total_ped >= 0) ;
ALTER TABLE pedido ADD CHECK ( vl_descto_ped >= 0) ;
ALTER TABLE pedido ADD CHECK ( vl_frete_ped >= 0) ;
ALTER TABLE itens_pedido ADD CHECK ( qtde_itens_pedido > 0) ;
	
--c) Renomeie alguma coluna;
ALTER TABLE itens_pedido RENAME COLUMN qtde_itens_pedido to qtde_pedida ;

--d) Altere o tipo de dados de alguma coluna CHAR para VARCHAR;
ALTER TABLE cliente_pf MODIFY profissao_cli VARCHAR2(20) ;

--e) Coloque valores default para todas as colunas que indiquem Valor e para a data e hora do pedido.
ALTER TABLE pedido MODIFY vl_descto_ped DEFAULT 0.0 ;

/**********************************************************
populacao das tabelas
***********************************************************/
-- cliente
descr cliente ;
INSERT INTO cliente VALUES ( 200, 1000, '72 Via Bahia', '123456', 'ATIVO', 'PF', 2, 'BRA');
INSERT INTO cliente VALUES ( 201, 2000, '6741 Takashi Blvd.', '81-20101','ATIVO','PJ', 5, 'JAP');
INSERT INTO cliente VALUES ( 202, 5000, '11368 Chanakya', '91-10351', 'ATIVO','PJ', 5, 'IND');
INSERT INTO cliente VALUES ( 203, 2500, '281 King Street', '1-206-104-0103', 'ATIVO','PJ', 1,'EUA');
INSERT INTO cliente VALUES ( 204, 3000, '15 Henessey Road', '852-3692888','ATIVO','PJ', 5,'CHI' );
INSERT INTO cliente VALUES ( 205, 4000, '172 Rue de Rivoli', '33-2257201', 'ATIVO','PJ', 6,'FRA');
INSERT INTO cliente VALUES ( 206, 1800, '6 Saint Antoine', '234-6036201', 'ATIVO','PJ', 6,'FRA');
INSERT INTO cliente VALUES ( 207, 3800, '435 Gruenestrasse', '49-527454','ATIVO','PJ', 6,'ALE');
INSERT INTO cliente VALUES ( 208, 6000, '792 Playa Del Mar','809-352689', 'ATIVO','PJ', 6,'ESP');
INSERT INTO cliente VALUES ( 209, 3000, '3 Via Saguaro', '52-404562', 'ATIVO','PF', 6,'ESP');
INSERT INTO cliente VALUES ( 210, 3500, '7 Modrany', '42-111292','ATIVO','PF', 6,'ALE' );
INSERT INTO cliente VALUES ( 211, 5500, '2130 Granville', '52-1876292','ATIVO','PJ', 1,'CAN' );
INSERT INTO cliente VALUES ( 212, 4200, 'Via Rosso 677', '72-2311292','ATIVO','PF', 6,'ITA' );
INSERT INTO cliente VALUES ( 213, 3200, 'Libertad 400', '97-311543','ATIVO','PF', 2,'ARG' );
INSERT INTO cliente VALUES ( 214, 2100, 'Maldonado 120', '96-352943','ATIVO','PJ', 2,'URU' );

SELECT * FROM cliente ;
descr cliente_pf ;
descr cliente_pj ;

INSERT INTO cliente_pf VALUES ( 200, 'Joao Avila', 033123, 'M', 'Arquiteto');
INSERT INTO cliente_pf VALUES ( 209, 'Katrina Shultz', 173623, 'F', 'Medica');
INSERT INTO cliente_pf VALUES ( 210, 'Gunter Schwintz', 826363, 'M', 'Professor');
INSERT INTO cliente_pf VALUES ( 212, 'Luigi Forlani', 876521, 'M', 'Maestro');
INSERT INTO cliente_pf VALUES ( 213, 'Sabrina Lescano', 562378, 'F', 'Designer');

INSERT INTO cliente_pj VALUES ( 201, 'Hamses Distribuidora SC', 7654321, 'Distribuidora') ;
INSERT INTO cliente_pj VALUES ( 202, 'Ementhal Comercio Ltda', 9876321, 'Comercio') ;
INSERT INTO cliente_pj VALUES ( 203, 'Picture Bow', 9865411, 'Comercio') ;
INSERT INTO cliente_pj VALUES ( 204, 'Saturn Sports INC', 73634646, 'Comercio') ;
INSERT INTO cliente_pj VALUES ( 205, 'Ping Tong Sam', 35352656, 'Comercio') ;
INSERT INTO cliente_pj VALUES ( 206, 'Pasadena Esportes', 73657126, 'Comercio') ;
INSERT INTO cliente_pj VALUES ( 207, 'Weltashung Sportif', 187908098, 'Comercio') ;
INSERT INTO cliente_pj VALUES ( 208, 'Random Realey Company', 76325943, 'Comercio') ;
INSERT INTO cliente_pj VALUES ( 211, 'London Drugs', 16721563, 'Comercio') ;
INSERT INTO cliente_pj VALUES ( 214, 'Empanadas con Vino', 90312876, 'Distribuidora') ;

alter table cliente add nome_fantasia varchar2(30) ;

UPDATE cliente c
SET c.nome_fantasia = ( SELECT SUBSTR(nome_fantasia, 1, INSTR(nome_fantasia,' ')- 1) FROM cliente_pf
WHERE cod_cli_pf = c.cod_cli )
WHERE c.tipo_cli = 'PF' ;

UPDATE cliente c
SET c.nome_fantasia = ( SELECT SUBSTR(razao_social_cli, 1, INSTR(razao_social_cli,' ')- 1) FROM cliente_pj
WHERE cod_cli_pj = c.cod_cli )
WHERE c.tipo_cli = 'PJ' ;

SELECT * FROM cliente ;
SELECT * FROM cliente_pj ;
SELECT * FROM cliente_pf ;


alter table funcionario add salario number(10,2) ;

INSERT INTO funcionario VALUES ( 1, 'Alessandra Mariano', 'Rua A,10', 'F', '03-03-2000', 11,12, 3, null, 'BRA', 2100);
INSERT INTO funcionario VALUES ( 2, 'James Smith', 'Rua B,20', 'M', '08-03-2000', 10, 12, 3, null, 'EUA', 6000);
INSERT INTO funcionario VALUES ( 3, 'Kraus Schumann', 'Rua C,100','M', '17-06-2000', 10, 36, 6, 2, 'ALE',4200 );
INSERT INTO funcionario VALUES ( 4, 'Kurota Issa', 'Rua D,23', 'F','07-04-2000', 2, 35, 5 , null, 'JAP',6450);
INSERT INTO funcionario VALUES ( 5, 'Cristina Moreira', 'Rua Abc,34', 'F','04-03-2000', 3, 35, 5, 4, 'BRA', 4000);
INSERT INTO funcionario VALUES ( 6, 'Jose Silva', 'Av. Sete, 10', 'M','18-01-2001', 12, 41,3, NULL, 'BRA', 3200);
INSERT INTO funcionario VALUES ( 7, 'Roberta Pereira', 'Largo batata, 200', 'F','14-05-2000', 12, 33, 3, 1, 'EUA', 5300); 
INSERT INTO funcionario VALUES ( 8, 'Alex Alves', 'Rua Dabliu, 10','M','07-04-2000', 2, 12, 1, 3, 'BRA', 2900);
INSERT INTO funcionario VALUES ( 9, 'Isabela Matos', 'Rua Ipsilone, 20', 'F','09-02-2001',2, 42, 6,4, 'EUA', 3200); 
INSERT INTO funcionario VALUES (10, 'Matheus De Matos','Av. Beira-Mar, 300', 'M','27-02-2001', 2, 51,5,2, 'ESP',4000);
INSERT INTO funcionario VALUES (11, 'Wilson Borga', 'Travessa Circular', 'M','14-05-2000', 2, 33, 3,3,'BRA', 3150);

INSERT INTO funcionario VALUES (12, 'Marco Rodrigues', 'Rua Beta, 20', 'M', '18-01-2000', 8, 43, 1, 1, 'URU', 3400);
INSERT INTO funcionario VALUES (13, 'Javier Hernandez', 'Calle Sur, 20','M', '18-02-2000', 3, 51, 3, 3, 'ARG', 4210); 
INSERT INTO funcionario VALUES (14, 'Chang Shung Dao', 'Dai Kai, 300', 'F', '22-01-2001', 10, 12, 2, 2, 'CHI', 3980);
INSERT INTO funcionario VALUES (15, 'Simon Holowitz', '19th Street','M', '09-10-2001',3, 14, 6, 6, 'GBR', 5460);

INSERT INTO funcionario VALUES (16, 'Penelope Xavier', 'Calle Paraguay, 20', 'F', '12-11-2003', 8, 43, 1, 1, 'URU', 2400);
INSERT INTO funcionario VALUES (17, 'Esmeralda Soriano', 'Calle Peru, 40','F', '18-12-2006', 3, 51, 3, 3, 'ARG', 4710); 
INSERT INTO funcionario VALUES (18, 'Ari Gato Sam', 'Yakisoba, 300', 'M', '21-01-2011', 10, 12, 2, 2, 'CHI', 1980);
INSERT INTO funcionario VALUES (19, 'Hannah Arendt', '22th South Avenue','F', '19-11-2011',3, 14, 6, 6, 'CAN', 4460);

descr deposito;
INSERT INTO deposito VALUES ( 101, 'Warehouse Bull', '283 King Street', 'Seattle', 'EUA', 1, 1);
INSERT INTO deposito VALUES ( 105, 'Deutsch Store','Friederisch Strasse', 'Berlim','ALE',6, 3);
INSERT INTO deposito VALUES ( 201, 'Santao','68 Via Anchieta', 'Sao Paulo', 'BRA', 2, 7);
INSERT INTO deposito VALUES ( 301, 'NorthWare', '6921 King Way', 'Nova Iorque', 'EUA', 1, 8);
INSERT INTO deposito VALUES ( 401, 'Daiso Han', '86 Chu Street', 'Tokio', 'JAP', 5, 9);
INSERT INTO deposito VALUES ( 302, 'RailStore', '234 Richards', 'Vancouver', 'CAN', 1, 8);
INSERT INTO deposito VALUES ( 402, 'Daiwu Son', 'Heyjunka 200', 'Seul', 'COR', 5, 9);
SELECT * FROM funcionario ;
SELECT * FROM cargo ;

SELECT * FROM marca ;
SELECT * FROM categ_esporte ;

/*********** Produto ***********/
SELECT * FROM produto ;
INSERT INTO produto VALUES ( produto_cod.nextval, 'Chuteira Total 90', 'Chuteira Total 90 Shoot TF', 'FUTB', 169, 132, 290,'NIK', null);
INSERT INTO produto VALUES ( produto_cod.nextval, 'Chuteira Absolado TRX', 'Chuteira Absolado TRX FG', 'FUTB',279,210,321, 'ADI', null );
INSERT INTO produto VALUES ( produto_cod.nextval, 'Agasalho Total 90', 'Agasalho Total 90', 'FUTB',199,121,420, 'NIK', null);
INSERT INTO produto VALUES ( produto_cod.nextval, 'Bola Copa do Mundo', 'Bola Futebol Copa do Mundo Oficial 2006', 'FUTB',56.25,32,390, 'ADI', null );
INSERT INTO produto VALUES ( produto_cod.nextval, 'Camisa Real Madrid', 'Camisa Oficial Real Madrid I Ronaldinho', 'FUTB',99.95,62, 190,'ADI', null );
INSERT INTO produto VALUES ( produto_cod.nextval, 'Meia Drift 3/4', 'Meia Esportiva', 'CORR', 22.95,16, 160, 'NIK', null);

INSERT INTO produto VALUES (produto_cod.nextval, 'T-Shirt Run Power', 'Camiseta Dry Fit', 'CORR', 69, 51, 145,'MZN','M');
INSERT INTO produto VALUES ( produto_cod.nextval, 'Calcao Dighton', 'Calcao Running Dighton','CORR', 38, 27, 100, 'MZN','P');
INSERT INTO produto VALUES ( produto_cod.nextval, 'Tenis Stratus 2.1','Tenis Corrida Stratus 2.1', 'CORR', 293,242, 258, 'ASI','42');
INSERT INTO produto VALUES ( produto_cod.nextval, 'Tenis Actual', 'Tenis Actual Alto Impacto', 'CORR', 399, 320, 278,'RBK',null );
INSERT INTO produto VALUES ( produto_cod.nextval, 'Tenis Advantage Court III', 'Tenis Advantage Court III', 'CASU', 98, 70, 241, 'WLS', '40');
INSERT INTO produto VALUES ( produto_cod.nextval, 'Tenis Slim Racer Woman', 'Tenis Corrida Feminino Slim Racer', 'CORR', 199, 165, 189, 'RBK', '37' );

INSERT INTO produto VALUES (produto_cod.nextval , 'Caneleira F50 Replique 2008', 'Caneleira Futebol F50 Replique 2008','FUTB', 49, 37, 120, 'ADI','U' );
INSERT INTO produto VALUES (produto_cod.nextval, 'Luvas F50 Training', 'Luvas Adidas F50 Training', 'FUTB', 69, 52.78, 85, 'ADI', 'U' );
INSERT INTO produto VALUES (produto_cod.nextval, 'Tenis Asics Gel Kambarra III', 'Tenis Corrida Gel Kambarra III Masculino',  'CORR', 199,143, 210, 'ASI',41);
INSERT INTO produto VALUES (produto_cod.nextval, 'Tenis Asics Gel Maverick 2', 'Tenis Corrida Gel Maverick 2',  'CORR', 159,129.90, 206, 'ASI','42');
INSERT INTO produto VALUES (produto_cod.nextval, 'Tenis Puma Elevation II', 'Tenis Puma Elevation II Feminino',  'CASU', 129, 98.75, 230, 'PUM', '42');
INSERT INTO produto VALUES (produto_cod.nextval , 'Blusao Adidas F50 Formotion', 'Blusao Adidas F50 Formotion', 'FUTB', 199, 159.90, 320, 'ADI', 'XG');
INSERT INTO produto VALUES (produto_cod.nextval, 'Tenis Puma Alacron II','Tenis Puma Alacron II' ,  'CASU', 165, 128.55, 210, 'PUM', '43');
INSERT INTO produto VALUES (produto_cod.nextval , 'Tenis Aventura RG Hike', 'Tenis Aventura RG Hike', 'CORR', 269, 201.55, 240,  'TIM', '42');
INSERT INTO produto VALUES (produto_cod.nextval , 'Tenis Aventura Gorge C2', 'Tenis Aventura Gorge C2',  'CORR', 229, 175.24, 198,  'TIM', '41');
INSERT INTO produto VALUES (produto_cod.nextval, 'Bola Varsity', 'Bola Varsity', 'BASQ', 22, 15.75, 265, 'WLS', 'u');

INSERT INTO produto VALUES (produto_cod.nextval , 'Camiseta U40', 'Camiseta U40', 'SKAT', 75, 62.30, 320, 'LOT', 'G');
INSERT INTO produto VALUES (produto_cod.nextval, 'Bermuda Corrida','Bermuda Corrida DriFit' ,  'CORR', 105, 90.55, 210, 'UAR', 'M');
INSERT INTO produto VALUES (produto_cod.nextval , 'Camiseta Regata NBA', 'Camiseta Regata NBA', 'BASQ', 169, 101.35, 240,  'NIK', 'G');
INSERT INTO produto VALUES (produto_cod.nextval , 'Truck 5pol', 'Truck 5 polegadas LongBoard',  'SKAT', 129, 85.24, 198,  'ADI', 'u');
INSERT INTO produto VALUES (produto_cod.nextval, 'Bola NBA', 'Bola NBA', 'BASQ', 72,  65.75, 265, 'NIK', 'u');

SELECT * FROM produto ;


descr armazenamento ;
INSERT INTO armazenamento VALUES ( 101, 5001, 650, 'A0123');
INSERT INTO armazenamento VALUES ( 101, 5002, 150, 'B0123');
INSERT INTO armazenamento VALUES ( 101, 5003, 650, 'C0123');
INSERT INTO armazenamento VALUES ( 101, 5004, 650, 'D0123');
INSERT INTO armazenamento VALUES ( 101, 5005, 610, 'E0123');
INSERT INTO armazenamento VALUES ( 101, 5006, 650, 'F0123');
INSERT INTO armazenamento VALUES ( 101, 5007, 250, 'G0123');
INSERT INTO armazenamento VALUES ( 101, 5008, 650, 'H0123');
INSERT INTO armazenamento VALUES ( 101, 5009, 650, 'I0123');
INSERT INTO armazenamento VALUES ( 101, 5010, 650, 'J0123');

INSERT INTO armazenamento VALUES ( 101, 5015, 50, 'J0123');
INSERT INTO armazenamento VALUES ( 101, 5016, 50, 'W0113');
INSERT INTO armazenamento VALUES ( 101, 5017, 50, 'U0123');
INSERT INTO armazenamento VALUES ( 101, 5018, 150, 'A0143');

INSERT INTO armazenamento VALUES ( 105, 5001, 650, 'A0123');
INSERT INTO armazenamento VALUES ( 105, 5002, 150, 'B0123');
INSERT INTO armazenamento VALUES ( 105, 5003, 650, 'C0123');
INSERT INTO armazenamento VALUES ( 105, 5004, 650, 'D0123');
INSERT INTO armazenamento VALUES ( 105, 5005, 610, 'E0123');
INSERT INTO armazenamento VALUES ( 105, 5006, 650, 'F0123');
INSERT INTO armazenamento VALUES ( 105, 5007, 250, 'G0123');
INSERT INTO armazenamento VALUES ( 105, 5008, 650, 'H0123');
INSERT INTO armazenamento VALUES ( 105, 5009, 650, 'I0123');
INSERT INTO armazenamento VALUES ( 105, 5010, 650, 'J0123');
INSERT INTO armazenamento VALUES ( 105, 5011, 650, 'K0123');

INSERT INTO armazenamento VALUES ( 105, 5017, 50, 'G0223');
INSERT INTO armazenamento VALUES ( 105, 5018, 50, 'H0323');
INSERT INTO armazenamento VALUES ( 105, 5019, 50, 'I0423');
INSERT INTO armazenamento VALUES ( 105, 5020, 50, 'J0323');
INSERT INTO armazenamento VALUES ( 105, 5021, 50, 'K0223');

SELECT * FROM armazenamento ;

INSERT INTO pedido VALUES ( pedido_cod.nextval, current_timestamp - 130,'FONE' , 200, 0, 5, 'O MESMO', 'CTCRED', 200, 8,'EM SEPARACAO');
INSERT INTO pedido VALUES ( pedido_cod.nextval, current_timestamp - 100,'FONE' , 200, 0, 5, 'O MESMO', 'CTCRED', 211, 4,'EM SEPARACAO');
INSERT INTO pedido VALUES ( pedido_cod.nextval, current_timestamp - 90,'FONE' , 300, 0, 5, 'O MESMO', 'CTCRED', 201, 8,'EM SEPARACAO');
INSERT INTO pedido VALUES ( pedido_cod.nextval, current_timestamp - 80,'FONE' , 400, 0, 5, 'O MESMO', 'DEBITO', 202, 10,'EM SEPARACAO');
INSERT INTO pedido VALUES ( pedido_cod.nextval, current_timestamp - 70,'FONE' , 210, 0, 5, 'O MESMO', 'CTCRED', 203, 8,'EM SEPARACAO');
INSERT INTO pedido VALUES ( pedido_cod.nextval, current_timestamp - 60,'FONE' , 600, 0, 5, 'O MESMO', 'CTCRED', 204, 4,'EM SEPARACAO');
INSERT INTO pedido VALUES ( pedido_cod.nextval, current_timestamp - 55,'FONE' , 280, 0, 5, 'O MESMO', 'DEBITO', 214, 11,'EM SEPARACAO');
INSERT INTO pedido VALUES ( pedido_cod.nextval, current_timestamp - 50,'FONE' , 280, 0, 5, 'O MESMO', 'CTCRED', 208, 8,'EM SEPARACAO');
INSERT INTO pedido VALUES ( pedido_cod.nextval, current_timestamp - 40,'FONE' , 1200, 0, 5, 'O MESMO', 'DEBITO', 201, 11,'EM SEPARACAO');
INSERT INTO pedido VALUES ( pedido_cod.nextval, current_timestamp - 30,'FONE' , 230, 0, 5, 'O MESMO', 'CTCRED', 203, 8,'EM SEPARACAO');
INSERT INTO pedido VALUES ( pedido_cod.nextval, current_timestamp - 20,'FONE' , 2200, 0, 5, 'O MESMO', 'CTCRED', 204,11,'EM SEPARACAO');
INSERT INTO pedido VALUES ( pedido_cod.nextval, current_timestamp - 10,'FONE' , 4200, 0, 5, 'O MESMO', 'CTCRED', 209, 8,'EM SEPARACAO');
INSERT INTO pedido VALUES ( pedido_cod.nextval, current_timestamp - 1,'FONE' , 208, 0, 5, 'O MESMO', 'CTCRED', 210, 9,'EM SEPARACAO');
INSERT INTO pedido VALUES ( pedido_cod.nextval, current_timestamp ,'FONE' , 208, 0, 5, 'O MESMO', 'DIN', 202, 9,'EM SEPARACAO');
INSERT INTO pedido VALUES ( pedido_cod.nextval, current_timestamp ,'FONE' , 208, 0, 5, 'O MESMO', 'DIN', 205, 9,'EM SEPARACAO');

SELECT * FROM pedido ;
SELECT * FROM itens_pedido ;

INSERT INTO itens_pedido VALUES ( 1900,5001,1 , 5);
INSERT INTO itens_pedido VALUES ( 1900, 5002, 2, 15);
INSERT INTO itens_pedido VALUES ( 1900, 5003,3 , 7 );
INSERT INTO itens_pedido VALUES ( 1900, 5004,4 , 5);
INSERT INTO itens_pedido VALUES ( 1900, 5005,4 , 10);
INSERT INTO itens_pedido VALUES ( 1900, 5006,3, 15);
INSERT INTO itens_pedido VALUES ( 1900, 5007,2 , 5);
INSERT INTO itens_pedido VALUES ( 1901, 5001,1 , 3);
INSERT INTO itens_pedido VALUES ( 1901, 5002, 1, 5);
INSERT INTO itens_pedido VALUES ( 1901, 5003,8 , 5);
INSERT INTO itens_pedido VALUES ( 1901, 5004,4 , 5);
INSERT INTO itens_pedido VALUES ( 1901, 5005,2 , 5);
INSERT INTO itens_pedido VALUES ( 1901, 5006,3 , 35);
INSERT INTO itens_pedido VALUES ( 1901, 5007,6, 30);
INSERT INTO itens_pedido VALUES ( 1902, 5001,9 , 5);
INSERT INTO itens_pedido VALUES ( 1902, 5002,11 ,5);
INSERT INTO itens_pedido VALUES ( 1903, 5001,1 , 15);
INSERT INTO itens_pedido VALUES ( 1903, 5002,3, 11);
INSERT INTO itens_pedido VALUES ( 1904, 5001,7, 6);
INSERT INTO itens_pedido VALUES ( 1904, 5002,9 , 30);
INSERT INTO itens_pedido VALUES ( 1904, 5003,15 , 12);
INSERT INTO itens_pedido VALUES ( 1904, 5004,20 , 19);
INSERT INTO itens_pedido VALUES ( 1905, 5001,30, 16);
INSERT INTO itens_pedido VALUES ( 1905, 5003,30 , 22);
INSERT INTO itens_pedido VALUES ( 1905, 5002, 10, 12);
INSERT INTO itens_pedido VALUES ( 1906, 5001,15 , 16);
INSERT INTO itens_pedido VALUES ( 1906, 5002,24 , 15);
INSERT INTO itens_pedido VALUES ( 1906, 5003,12 , 18);
INSERT INTO itens_pedido VALUES ( 1906, 5004,6 , 27);
INSERT INTO itens_pedido VALUES ( 1906, 5006,6, 5);
INSERT INTO itens_pedido VALUES ( 1906, 5005, 3, 12);
INSERT INTO itens_pedido VALUES ( 1907, 5010, 2, 5);
INSERT INTO itens_pedido VALUES ( 1907, 5002, 1, 11);
INSERT INTO itens_pedido VALUES ( 1907, 5003, 16, 5);
INSERT INTO itens_pedido VALUES ( 1907, 5004, 9, 5);
INSERT INTO itens_pedido VALUES ( 1907, 5005, 8, 0);
INSERT INTO itens_pedido VALUES ( 1908, 5001, 9, 0);
INSERT INTO itens_pedido VALUES ( 1908, 5006, 35, 50);
INSERT INTO itens_pedido VALUES ( 1908, 5007, 5, 0);
INSERT INTO itens_pedido VALUES ( 1908, 5005, 10, 0);
INSERT INTO itens_pedido VALUES ( 1908, 5002, 8, 0);
INSERT INTO itens_pedido VALUES ( 1908, 5004, 7, 0);
INSERT INTO itens_pedido VALUES ( 1908, 5003, 9,10);
INSERT INTO itens_pedido VALUES ( 1909, 5011, 5, 20);
INSERT INTO itens_pedido VALUES ( 1909, 5005, 5,30);
INSERT INTO itens_pedido VALUES ( 1909, 5007, 5, 10);
INSERT INTO itens_pedido VALUES ( 1909, 5006, 4, 0);
INSERT INTO itens_pedido VALUES ( 1909, 5004, 12, 30);
INSERT INTO itens_pedido VALUES ( 1909, 5002, 5, 20);
INSERT INTO itens_pedido VALUES ( 1909, 5003, 5, 15);
INSERT INTO itens_pedido VALUES ( 1910, 5011, 9, 10);
INSERT INTO itens_pedido VALUES ( 1910, 5002, 1, 0);

INSERT INTO itens_pedido VALUES ( 1911, 5021, 5, 20);
INSERT INTO itens_pedido VALUES ( 1911, 5015, 5,30);
INSERT INTO itens_pedido VALUES ( 1911, 5017, 5, 10);
INSERT INTO itens_pedido VALUES ( 1911, 5016, 4, 0);
INSERT INTO itens_pedido VALUES ( 1911, 5014, 12, 30);
INSERT INTO itens_pedido VALUES ( 1911, 5012, 5, 20);
INSERT INTO itens_pedido VALUES ( 1912, 5013, 5, 15);
INSERT INTO itens_pedido VALUES ( 1912, 5021, 9, 10);
INSERT INTO itens_pedido VALUES ( 1912, 5019, 1, 0);

INSERT INTO itens_pedido VALUES ( 1913,5026,1 , 5);
INSERT INTO itens_pedido VALUES ( 1913, 5022, 2, 15);
INSERT INTO itens_pedido VALUES ( 1913, 5003,3 , 7 );
INSERT INTO itens_pedido VALUES ( 1913, 5024,4 , 5);
INSERT INTO itens_pedido VALUES ( 1913, 5005,4 , 10);
INSERT INTO itens_pedido VALUES ( 1913, 5006,3, 15);
INSERT INTO itens_pedido VALUES ( 1913, 5017,2 , 5);
INSERT INTO itens_pedido VALUES ( 1914, 5026,1 , 3);
INSERT INTO itens_pedido VALUES ( 1914, 5002, 1, 5);
INSERT INTO itens_pedido VALUES ( 1914, 5013,8 , 5);
INSERT INTO itens_pedido VALUES ( 1914, 5024,4 , 5);
INSERT INTO itens_pedido VALUES ( 1914, 5005,2 , 5);
INSERT INTO itens_pedido VALUES ( 1914, 5016,3 , 35);
INSERT INTO itens_pedido VALUES ( 1914, 5007,6, 30);

SELECT * FROM itens_pedido ;

ALTER TABLE itens_pedido ADD ( preco_item NUMBER(10,2), total_item NUMBER(10,2) ) ;
UPDATE itens_pedido i SET i.preco_item = ( SELECT p.preco_venda*0.995 FROM produto p
WHERE p.cod_prod = i.cod_prod ) ;

-- atualizando o total dos pedidos
UPDATE pedido ped
set ped.vl_total_ped =
(SELECT sum(i.qtde_pedida*i.preco_item*(100-i.descto_itens_pedido)/100) 
FROM itens_pedido i, produto p
WHERE ped.num_ped = i.num_ped
AND i.cod_prod = p.cod_prod );

commit ;
SELECT count(*) FROM itens_pedido ;
SELECT count(*) FROM regiao ;
SELECT count(*) FROM produto ;
SELECT count(*) FROM cliente ;
SELECT count(*) FROM pedido ;
SELECT count(*) FROM armazenamento ;
SELECT count(*) FROM funcionario ;
SELECT count(*) FROM depto ;
SELECT count(*) FROM cargo ;


select cod_cli_pf as Cod, nome_fantasia AS NOME from cliente_pf
union
select cod_cli_pj as Cod, razao_social_cli AS Nome from cliente_pj ;

-- alteracao na estrutura de itens pedido
ALTER TABLE itens_pedido ADD situacao_item CHAR(15) 
CHECK ( situacao_item IN ( 'SEPARACAO', 'ENTREGUE', 'CANCELADO', 'DESPACHADO')) ;
UPDATE itens_pedido SET situacao_item = 'SEPARACAO' ;