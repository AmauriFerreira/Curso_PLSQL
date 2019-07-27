-- Sript Criacao Controle Internacao - 2019 - Fatec Ipiranga

/* parametros de configuracao da sessao */
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY HH24:MI:SS';
ALTER SESSION SET NLS_LANGUAGE = PORTUGUESE;
SELECT SESSIONTIMEZONE, CURRENT_TIMESTAMP FROM DUAL;

/* TABELA PACIENTE*/
DROP TABLE paciente CASCADE CONSTRAINTS;
CREATE TABLE paciente(
cod_paciente INTEGER PRIMARY KEY,
nome_pac VARCHAR2(40) NOT NULL,
end_pac VARCHAR2(40) NOT NULL,
dt_nascto_pac DATE NOT NULL,
fone_pac VARCHAR2(10),
sexo_pac CHAR(1) NOT NULL,
tipo_sangue_pac CHAR(3) NOT NULL);

-- alterando a estrutura
ALTER TABLE paciente ADD cpf_responsavel NUMBER(11) NOT NULL ;
ALTER TABLE paciente ADD CHECK ( sexo_pac in ('M', 'F')) ;
--2a
DROP SEQUENCE pac_seq ;
CREATE SEQUENCE pac_seq start with 5000 ;

/*POPULANDO PACIENTE*/
INSERT INTO paciente VALUES(pac_seq.nextval,'VALTER GARCIA','AV. AMALIA FRANCO 100','20/02/1949','1151524630','M','AB',12358411878);
INSERT INTO paciente VALUES(pac_seq.nextval,'MARIA LUCIEIDE','AV SARAH VELOSO 645','15/10/1975','1145652311','F','O+',2117958498);
INSERT INTO paciente VALUES(pac_seq.nextval,'ADRIANO ROMAGNOLO','AV C. COSTA 445','25/12/1972','1137895278','M','B',3865118776);
INSERT INTO paciente VALUES(pac_seq.nextval,'WAGNER DINIZ','PRAÇA IDALINO ANDREOLO 98','30/07/1985','1136985266','M','AB-',52255444119);
INSERT INTO paciente VALUES(pac_seq.nextval,'CAIO CESAR','AV C. COSTA 445','02/05/2004','1137895278','M','A',8564458558);
INSERT INTO paciente VALUES(pac_seq.nextval,'RITA CAMACHO','RUA COSTA LARGA, 447','02/05/1984','1137855278','F','A',8553355448);
INSERT INTO paciente VALUES(pac_seq.nextval,'ANA MARIA CARVALHO','AV. FRANCO DA ROCHA 100','21/03/1939','1151524630','F','AB',12333584878);
INSERT INTO paciente VALUES(pac_seq.nextval,'GORETE CAMPOS','AV SALIM FARAH MALUF 638','18/11/1955','1145652311','F','O+',8795843398);
INSERT INTO paciente VALUES(pac_seq.nextval,'ALVARO PEREIRA CRUZ','AV DO CONTORNO 415','21/10/1962','1137895278','M','AB',3844658776);
INSERT INTO paciente VALUES(pac_seq.nextval,'ROBERTO CARLOS SANTOS','PRAÇA SANTOS DUMONT 98','31/08/1995','1136985266','M','AB+',88555444119);
INSERT INTO paciente VALUES(pac_seq.nextval,'TRISTAO ATAIDE FREITAS','AV NAZARE 111','12/01/2014','1137895278','M','A+',8565228558);
INSERT INTO paciente VALUES(pac_seq.nextval,'PRISCILA FURLAN','RUA COSTA AGUIAR, 1247','22/06/1974','1137855278','F','A-',8225533558);
INSERT INTO paciente VALUES(pac_seq.nextval,'FERNANDO GOMES PRADO','AV. PIRITUBA 100','10/02/1969','1151774630','M','AB',33358411878);
INSERT INTO paciente VALUES(pac_seq.nextval,'MARIA APARECIDA CAMARGO','AV CARLOS GOMES 645','11/10/1965','1177652311','F','O+',2113358498);
INSERT INTO paciente VALUES(pac_seq.nextval,'JOAO JESUS DE PAULA','AV INTERLAGOS 445','15/12/1962','1137775278','M','B',3865338776);
INSERT INTO paciente VALUES(pac_seq.nextval,'WALTER CAMPINA','PRAÇA TAUBATE 98','31/07/1995','1136987766','M','AB-',53355444119);
INSERT INTO paciente VALUES(pac_seq.nextval,'CATULO REZENDE','AV PERNAMBUCO 445','12/05/2014','1137775278','M','A',8533458558);
INSERT INTO paciente VALUES(pac_seq.nextval,'CIBELE CRISTINA SILVA','RUA FRANCISCO GOMES, 447','12/05/1994','1137775278','F','A',3353355448);
INSERT INTO paciente VALUES(pac_seq.nextval,'PAULA TEODORO MAIOR','AV. TIQUATIRA 100','11/03/1979','1151577630','F','AB',12333774878);
INSERT INTO paciente VALUES(pac_seq.nextval,'GILDA CAMPOS MACHADO','AV SALIM FARAH MALUF 988','28/11/1975','1145772311','F','O+',8777843398);
INSERT INTO paciente VALUES(pac_seq.nextval,'JONNY CRUZ DE SOUZA','AV DO CURSINO 415','21/11/1972','1137895778','M','AB',3844998776);
INSERT INTO paciente VALUES(pac_seq.nextval,'ROBERTO ANDRE KUBLOVSKY','PRAÇA APECATU 98','01/08/1985','11344985266','M','AB+',89955444119);
INSERT INTO paciente VALUES(pac_seq.nextval,'ADRAIN MORENBACH','AV NAZARE 455','22/01/2014','1137894478','M','A+',8565998558);
INSERT INTO paciente VALUES(pac_seq.nextval,'GIOVANNA CASTIGLIONE','RUA FREI JOAO, 17','27/06/1944','1134455278','F','A-',8225993558);
SELECT * FROM paciente ;

/* TABELA QUARTO*/

DROP TABLE  quarto CASCADE constraints;
CREATE TABLE quarto(
num_qto INTEGER PRIMARY KEY,
local_qto VARCHAR2(20) NOT NULL,
capacidade_leitos INTEGER NOT NULL,
tipo_qto VARCHAR2(12) NOT NULL);

--2D
ALTER TABLE quarto ADD CHECK ( tipo_qto IN ('ENFERMARIA', 'UTI', 'CTI',  'PADRAO'));

/*POPULANDO QUARTO*/
INSERT INTO quarto VALUES(101,'1 ANDAR',2,'ENFERMARIA');
INSERT INTO quarto VALUES(102,'1 ANDAR',3,'ENFERMARIA');
INSERT INTO quarto VALUES(103,'1 ANDAR',3,'ENFERMARIA');
INSERT INTO quarto VALUES(201,'2 ANDAR',4,'UTI');
INSERT INTO quarto VALUES(301,'3 ANDAR',4,'CTI');
INSERT INTO quarto VALUES(401,'4 ANDAR',1,'PADRAO');
INSERT INTO quarto VALUES(402,'4 ANDAR',2,'PADRAO');
INSERT INTO quarto VALUES(411,'4 ANDAR',2,'PADRAO');
INSERT INTO quarto VALUES(412,'4 ANDAR',2,'PADRAO');
INSERT INTO quarto VALUES(104,'1 ANDAR',2,'ENFERMARIA');
INSERT INTO quarto VALUES(105,'1 ANDAR',3,'ENFERMARIA');
INSERT INTO quarto VALUES(106,'1 ANDAR',3,'ENFERMARIA');
INSERT INTO quarto VALUES(202,'2 ANDAR',6,'UTI');
INSERT INTO quarto VALUES(302,'3 ANDAR',6,'CTI');
INSERT INTO quarto VALUES(404,'4 ANDAR',3,'PADRAO');
INSERT INTO quarto VALUES(405,'4 ANDAR',3,'PADRAO');
INSERT INTO quarto VALUES(413,'4 ANDAR',3,'PADRAO');
INSERT INTO quarto VALUES(414,'4 ANDAR',3,'PADRAO');

SELECT * FROM quarto ;

/* TABELA LEITO*/
DROP TABLE  leito CASCADE constraints;
CREATE TABLE leito(
num_leito INTEGER ,
num_qto INTEGER NOT NULL,
tipo_leito VARCHAR2(10) NOT NULL,
PRIMARY KEY ( num_leito, num_qto),
FOREIGN KEY (num_qto) REFERENCES quarto(num_qto) ON DELETE CASCADE);

--2D
ALTER TABLE leito ADD CHECK ( tipo_leito IN ('SIMPLES', 'MECANICO', 'ELETRONICO'));

/* INSERINDO DADOS NA TABELA LEITO*/
INSERT INTO leito VALUES(1,101,'SIMPLES');
INSERT INTO leito VALUES(2,101,'MECANICO');
INSERT INTO leito VALUES(1,102,'SIMPLES');
INSERT INTO leito VALUES(2,102,'MECANICO');
INSERT INTO leito VALUES(3,102,'MECANICO');
INSERT INTO leito VALUES(1,201, 'ELETRONICO');
INSERT INTO leito VALUES(2,201, 'MECANICO');
INSERT INTO leito VALUES(3,101,'ELETRONICO');
INSERT INTO leito VALUES(1, 301, 'MECANICO');
INSERT INTO leito VALUES(1, 401, 'ELETRONICO');
INSERT INTO leito VALUES(2, 401, 'ELETRONICO');
INSERT INTO leito VALUES(2, 402, 'SIMPLES');
INSERT INTO leito VALUES(1, 412, 'SIMPLES');
INSERT INTO leito VALUES(1, 411, 'SIMPLES');
INSERT INTO leito VALUES(2, 411, 'SIMPLES');
INSERT INTO leito VALUES(2, 412, 'SIMPLES');
INSERT INTO leito VALUES(1,103,'SIMPLES');
INSERT INTO leito VALUES(2,103,'MECANICO');
INSERT INTO leito VALUES(1,104,'SIMPLES');
INSERT INTO leito VALUES(2,104,'MECANICO');
INSERT INTO leito VALUES(3,104,'MECANICO');
INSERT INTO leito VALUES(1,202, 'ELETRONICO');
INSERT INTO leito VALUES(2,202, 'MECANICO');
INSERT INTO leito VALUES(3,105,'ELETRONICO');
INSERT INTO leito VALUES(1, 404, 'ELETRONICO');
INSERT INTO leito VALUES(2, 405, 'SIMPLES');
INSERT INTO leito VALUES(1, 413, 'SIMPLES');
INSERT INTO leito VALUES(1, 414, 'SIMPLES');
INSERT INTO leito VALUES(2, 413, 'SIMPLES');
INSERT INTO leito VALUES(2, 414, 'SIMPLES');

SELECT * FROM leito ;

/* TABELA MEDICO*/
DROP TABLE  medico CASCADE CONSTRAINTS ;
CREATE TABLE medico(
crm INTEGER PRIMARY KEY,
nome_med VARCHAR2(30) NOT NULL,
sexo_med CHAR(1) NOT NULL check ( sexo_med in ('M', 'F')),
fone_med VARCHAR2(10) NOT NULL,
end_med VARCHAR2(30) NOT NULL,
celular_med VARCHAR2(10),
tipo_contrato CHAR(11) NOT NULL) ;

ALTER TABLE medico add check (tipo_contrato in ('EFETIVO', 'RESIDENTE')) ;
ALTER TABLE medico modify celular_med not null ;

/*INSERINDO DADOS NA TABELA MEDICO*/

INSERT INTO medico VALUES(1234,'ANTONIO SOUZA','M','1132259952','RUA DOS MILAGRES 100','1199115555','EFETIVO');
INSERT INTO medico VALUES(2235,'JOAO PERES','M','1133345999','RUA DOS INICIANTES 200','1188885455','RESIDENTE');
INSERT INTO medico VALUES(3236,'JOSE TEIXEIRA','M','1147859952','AV INTERLAGOS 1000','1188886666','EFETIVO');
INSERT INTO medico VALUES(4237,'ANA CASTRO','F','1147859952','RUA ANTONIO AGU','1177788555','RESIDENTE');
INSERT INTO medico VALUES(5238,'TADASHI KOBAIASH','M','1155556666','RUA VOLUNTARIOS DA PATRIA,500','1199785566','EFETIVO');
INSERT INTO medico VALUES(6239,'JOANA SANTOS','F','1166859952','RUA TURIASSU , 156','1177885566','RESIDENTE');
INSERT INTO medico VALUES(7240,'FERNANDA DE ABREU','F','1149859967','RUA DOS PINHEIROS,700','1185486666','EFETIVO');
INSERT INTO medico VALUES(8241,'FUAD TUFIK','M','1136859767','RUA RUBI,100','1166486666','EFETIVO');
INSERT INTO medico VALUES(9242,'IRENE GARCIA','M','1155859752','AV AMALIA FRANCO , 600','1179885526','RESIDENTE');
INSERT INTO medico VALUES(7243,'SUELLEN RAMOS','F','1136909759','RUA VALMIR ALENCAR, 965','1174515526','RESIDENTE');
INSERT INTO medico VALUES(1243,'TANCREDO RAMOS','M','1136859759','RUA PEACABA, 325','1174521526','EFETIVO');
INSERT INTO medico VALUES(9756,'FERNANDA HIROSHI','F','1132159759','AV CURUMIM, 165','1174591627','RESIDENTE');
INSERT INTO medico VALUES(4275,'CLOVIS REBELO JUNIOR','M','1136339759','RUA FOLR DO LIRIO, 967','1198755526','EFETIVO');

SELECT * FROM medico ;

/* tabela Especialidade */
DROP TABLE especialidade CASCADE CONSTRAINTS ;
CREATE TABLE especialidade
( cod_esp INTEGER PRIMARY KEY,
descr_esp VARCHAR2(50) NOT NULL) ;

INSERT INTO especialidade VALUES ( 1, 'Clinico Geral') ;
INSERT INTO especialidade VALUES ( 2, 'Ortopedia') ;
INSERT INTO especialidade VALUES ( 3, 'Cardiologia') ;
INSERT INTO especialidade VALUES ( 4, 'Urologia') ;
INSERT INTO especialidade VALUES ( 5, 'Pediatria') ;
INSERT INTO especialidade VALUES ( 6, 'Geriatria') ;
INSERT INTO especialidade VALUES ( 7, 'Oftalmologia') ;
INSERT INTO especialidade VALUES ( 8, 'Otorrinolaringologia') ;
INSERT INTO especialidade VALUES ( 9, 'Nefrologia') ;

/* medico efetivo */
DROP TABLE medico_efetivo CASCADE CONSTRAINTS ;
CREATE TABLE medico_efetivo
( crm_efetivo INTEGER NOT NULL REFERENCES MEDICO ,
cod_espec INTEGER NOT NULL REFERENCES especialidade );

INSERT INTO medico_efetivo VALUES ( 1234, 1) ;
INSERT INTO medico_efetivo VALUES ( 3236, 2) ;
INSERT INTO medico_efetivo VALUES ( 5238, 3) ;
INSERT INTO medico_efetivo VALUES ( 7240, 4) ;
INSERT INTO medico_efetivo VALUES ( 1243, 1) ;
INSERT INTO medico_efetivo VALUES ( 4275, 9) ;

ALTER TABLE medico_efetivo add primary key (crm_efetivo);

/* medico residente */
DROP TABLE medico_residente CASCADE CONSTRAINTS ;
CREATE TABLE medico_residente
( crm_residente INTEGER NOT NULL REFERENCES MEDICO ,
crm_efetivo INTEGER NOT NULL  REFERENCES medico_efetivo ,
dt_ini_orientacao DATE,
dt_term_orientacao DATE ,
prazo_residencia DATE,
formacao_academica VARCHAR2(50),
PRIMARY KEY ( crm_residente)) ;

INSERT INTO medico_residente  VALUES (2235, 1234, SYSDATE - 200, null, SYSDATE + 100, 'UNIFESP' );
INSERT INTO medico_residente  VALUES (4237, 3236, SYSDATE - 200, null, SYSDATE +100,'FMUSP');
INSERT INTO medico_residente  VALUES (9756, 4275, SYSDATE - 200, null, SYSDATE +100,'SANTA CASA');

/*  TABELA INTERNACAO*/
DROP TABLE  internacao CASCADE CONSTRAINTS ;
CREATE TABLE internacao(
num_internacao integer PRIMARY KEY,
motivo VARCHAR2(40) NOT NULL,
dt_hora_entrada TIMESTAMP NOT NULL,
dt_hora_alta TIMESTAMP,
dt_hora_saida TIMESTAMP,
diagnostico_inicial VARCHAR2(50),
tratamento_inicial VARCHAR2(150),
num_leito INTEGER NOT NULL,
num_qto INTEGER NOT NULL,
cod_paciente INTEGER NOT NULL,
crm_responsavel INTEGER NOT NULL,
FOREIGN KEY (num_leito , num_qto) REFERENCES leito ON DELETE CASCADE ,
FOREIGN KEY (cod_paciente) REFERENCES paciente(cod_paciente) ON DELETE CASCADE,
FOREIGN KEY (crm_responsavel) REFERENCES medico_efetivo ON DELETE CASCADE);

-- sequencia internacao
DROP SEQUENCE internacao_seq ;
CREATE SEQUENCE internacao_seq START WITH 3000 ;

DELETE FROM internacao ;

/* POPULANDO INTERNACAO */
INSERT INTO internacao VALUES
(internacao_seq.nextval,'DORES FORTES NO PEITO', current_timestamp - 155, current_timestamp - 147 , current_timestamp - 147 + INTERVAL '31' MINUTE, 
null, null, 1,101,5003,1234);
INSERT INTO internacao VALUES
(internacao_seq.nextval,'PARTO EM ANDAMENTO',current_timestamp - 147,current_timestamp - 143, current_timestamp - 143 + INTERVAL '38' MINUTE, 
null, null,1,401,5015,5238);
INSERT INTO internacao VALUES
(internacao_seq.nextval,'FRATURA EXPOSTA',current_timestamp - 138, current_timestamp - 120, current_timestamp - 120 + INTERVAL '4' MINUTE,
null, null, 2,101, 5011,7240);
INSERT INTO internacao VALUES
(internacao_seq.nextval,'MANCHAS VERMELHAS NA PELE',current_timestamp - 140,current_timestamp - 119 ,current_timestamp - 119,
null, null, 2,201,5004,3236);
INSERT INTO internacao VALUES
(internacao_seq.nextval,'PARADA CARDIACA',current_timestamp - 120,current_timestamp - 105 ,current_timestamp - 105 + INTERVAL '14' MINUTE,
null, null,2,101, 5006,1234);
INSERT INTO internacao VALUES
(internacao_seq.nextval,'PRE NATAL',current_timestamp - 95,current_timestamp - 94,current_timestamp - 94 + INTERVAL '61' MINUTE, 
null, null,1,411,5009,3236);
INSERT INTO internacao VALUES
(internacao_seq.nextval,'CONGESTAO NASAL',current_timestamp - 88,current_timestamp - 84,current_timestamp - 84+ INTERVAL '54' MINUTE, 
null, null,2,412,5013,5238);
INSERT INTO internacao VALUES
(internacao_seq.nextval,'CONVULSAO',current_timestamp - 79,current_timestamp - 74,current_timestamp - 74 + INTERVAL '39' MINUTE, 
null, null,1,412,5002,1243);
INSERT INTO internacao VALUES
(internacao_seq.nextval,'DIARREIA',current_timestamp - 62,current_timestamp - 54,current_timestamp - 54 + INTERVAL '34' MINUTE, 
null, null,1,411,5001,5238);
INSERT INTO internacao VALUES
(internacao_seq.nextval,'DOR FORTE COLUNA',current_timestamp - 35,current_timestamp - 34,current_timestamp - 34 + INTERVAL '31' MINUTE, 
null, null,2,402,5016,3236);
INSERT INTO internacao VALUES
(internacao_seq.nextval,'VOMITO',current_timestamp - 15,current_timestamp - 4,current_timestamp - 4 + INTERVAL '44' MINUTE, 
null, null,1,301,5007,1243);
INSERT INTO internacao VALUES
(internacao_seq.nextval,'BOLHAS NA MAO',current_timestamp - 14,current_timestamp - 13,current_timestamp -13 + INTERVAL '44' MINUTE, 
null, null,1,202,5007,1243);
INSERT INTO internacao VALUES
(internacao_seq.nextval,'FALTA DE AR',current_timestamp - 14,current_timestamp - 12,current_timestamp -12 + INTERVAL '44' MINUTE, 
null, null,1,401,5017,3236);
INSERT INTO internacao VALUES
(internacao_seq.nextval,'DIARREIA E VOMITO',current_timestamp - 12,current_timestamp - 11,current_timestamp - 11 + INTERVAL '44' MINUTE, 
null, null,1,413,5007,1234);
INSERT INTO internacao VALUES
(internacao_seq.nextval,'DOR DE CABECA DIARREIA E VOMITO',current_timestamp - 11,current_timestamp - 10,current_timestamp - 10 + INTERVAL '44' MINUTE, 
null, null,1,411,5010,1243);
INSERT INTO internacao VALUES
(internacao_seq.nextval, 'SUOR EXCESSIVO' , current_timestamp - 3, NULL, NULL, NULL, NULL, 2, 401, 5014, 1243);
INSERT INTO internacao VALUES
(internacao_seq.nextval, 'CONVULSAO', current_timestamp -2 , NULL, NULL, NULL, NULL, 1, 414, 5009, 1234);
INSERT INTO internacao VALUES
(internacao_seq.nextval,'FRATURA PERNA ESQUERDA',current_timestamp -1 , NULL,NULL,NULL, NULL,1,103,5011,3236);
INSERT INTO internacao VALUES
(internacao_seq.nextval, 'ARRITMIA CARDIACA',current_timestamp , NULL, NULL, NULL, NULL, 3, 101, 5009, 4275);


SELECT * FROM internacao ;

/* tabela tipo de exame */
DROP TABLE tipo_exame CASCADE constraints;
CREATE TABLE tipo_exame
( cod_tipo_exame INTEGER PRIMARY KEY,
tipo_exame VARCHAR2(50) NOT NULL,
instrucoes_preparo VARCHAR2(200) ,
prazo_resultado SMALLINT);

INSERT INTO tipo_exame VALUES ( 1 , 'SANGUE', null, null) ;
INSERT INTO tipo_exame VALUES ( 2 , 'GLICEMIA TOTAL', 'JEJUM 8 HORAS', 24) ;
INSERT INTO tipo_exame VALUES ( 3 , 'RAIO X TORAX', null, null) ;
INSERT INTO tipo_exame VALUES ( 4 , 'URINA', 'INGESTA DE 2L LIQUIDO', 36) ;
INSERT INTO tipo_exame VALUES ( 5 , 'PSA COMPLETO E FRACOES', null, null) ;
INSERT INTO tipo_exame VALUES ( 6 , 'TOMOGRAFIA COMPUTADORIZADA', null, 1) ;
INSERT INTO tipo_exame VALUES ( 7 , 'ULTRASSOM RINS', null, null) ;
INSERT INTO tipo_exame VALUES ( 8 , 'CREATININA', null, null) ;

DROP TABLE exame_med CASCADE CONSTRAINTS ;
CREATE TABLE exame_med
( num_exame INTEGER PRIMARY KEY, 
cod_tipo_exame INTEGER NOT NULL REFERENCES tipo_exame,
num_internacao INTEGER NOT NULL ,
dt_hora_exame TIMESTAMP,
resultado_exame VARCHAR2(100) ,
laudo_exame VARCHAR2(100) ,
responsavel_laudo VARCHAR2(30) ,
executor_exame VARCHAR2(50),
obs_exame VARCHAR2(100));
-- relacionando com internação
ALTER TABLE exame_med ADD FOREIGN KEY (num_internacao) REFERENCES internacao ON DELETE CASCADE ;

-- sequência de auto-numeração para os exames começando com 50 ;
DROP SEQUENCE exame_seq ;
CREATE SEQUENCE exame_seq START WITH 20 ;

-- população exame
INSERT INTO exame_med VALUES( exame_seq.nextval, 1, 3000, current_timestamp - 10, 'Normal', 'Normal', 'Dra. Beatriz',
'Ze Chico', null); 
INSERT INTO exame_med VALUES( exame_seq.nextval, 2, 3003, current_timestamp - 9, 'Normal', 'Normal', 'Dra. Fatima',
'Ana Cintra', null); 
INSERT INTO exame_med VALUES( exame_seq.nextval, 6, 3006, current_timestamp - 10, 'Normal', 'Normal', 'Dr. Barreto',
'Joao Carlos', null); 
INSERT INTO exame_med VALUES( exame_seq.nextval, 8, 3008, current_timestamp - 9, 'Normal', 'Normal', 'Dra. Celia',
'Ana Serra', null); 

SELECT * FROM exame_med ;

/* DOENCAS PRE-EXISTENTES */
DROP TABLE  doencas_pre_existentes CASCADE CONSTRAINTS;
CREATE TABLE doencas_pre_existentes(
cod_doenca CHAR(5) PRIMARY KEY,
nome_doenca VARCHAR(30) NOT NULL,
descricao_doenca VARCHAR(100) NOT NULL);

/*POPULANDO DOENCAS PRE EXISTENTE*/
INSERT INTO doencas_pre_existentes VALUES('DIAB1','DIABETES TIPO 1','DEFICIENCIA NA PRODUCAO DE INSULINA');
INSERT INTO doencas_pre_existentes VALUES('DIAB2','DIABETES TIPO 2','DOENCA QUE AFETA O PANCREAS ACARRETANDO NA DIMINUICAO DA INSULINA');
INSERT INTO doencas_pre_existentes VALUES('RNT','RINITE ALERGICA','ALERGIA PROVOCADA POR ACAROS, POEIRA, PRODUTOS QUIMICOS');
INSERT INTO doencas_pre_existentes VALUES('HIPT','HIPERTENSAO', 'PRESSAO ALTA' );
INSERT INTO doencas_pre_existentes VALUES('GLAUC','GLAUCOMA','DEGENERACAO DA VISAO');
INSERT INTO doencas_pre_existentes VALUES('ASMA','ASMA', 'INFLAMACAO CRONICA DAS VIAS AEREAS' );
INSERT INTO doencas_pre_existentes VALUES('BRQT','BRONQUITE','INFLAMACAO DOS BRONQUIOS');
INSERT INTO doencas_pre_existentes VALUES('ANEM','ANEMIA','DEFICIENCIA NA CONCENTRACAO DA HEMOGLOBINA');
SELECT * FROM doencas_pre_existentes ;

/*TABELA DE RELACIONAMENTO DOENCAS PRE EXISTENTES COM PACIENTE*/
DROP TABLE  doencas_paciente CASCADE CONSTRAINTS;
CREATE TABLE doencas_paciente(
cod_doenca CHAR(5) NOT NULL,
cod_paciente_paciente INTEGER NOT NULL,
dt_inicio DATE,
FOREIGN KEY (cod_doenca) REFERENCES doencas_pre_existentes(cod_doenca) ON DELETE CASCADE,
FOREIGN KEY (cod_paciente_paciente) REFERENCES paciente(cod_paciente) ON DELETE CASCADE);

/*POPULANDO doencas_paciente*/
INSERT INTO doencas_paciente VALUES('DIAB1',5003,'01/02/1987');
INSERT INTO doencas_paciente VALUES('RNT',5003,'08/10/1990');
INSERT INTO doencas_paciente VALUES('HIPT',5004,'15/05/2000');
INSERT INTO doencas_paciente VALUES('GLAUC',5004,'02/03/1991');
INSERT INTO doencas_paciente VALUES('BRQT',5004,'28/07/2005');
INSERT INTO doencas_paciente VALUES('HIPT',5001,'07/03/2007');
INSERT INTO doencas_paciente VALUES('RNT',5002,'10/04/1989');
INSERT INTO doencas_paciente VALUES('DIAB2',5013,'01/02/1997');
INSERT INTO doencas_paciente VALUES('RNT',5013,'08/10/1980');
INSERT INTO doencas_paciente VALUES('HIPT',5013,'15/05/2010');
INSERT INTO doencas_paciente VALUES('ANEM',5023,'10/04/1999');
INSERT INTO doencas_paciente VALUES('ASMA',5023,'01/02/1999');
INSERT INTO doencas_paciente VALUES('DIAB2',5023,'08/10/1980');
INSERT INTO doencas_paciente VALUES('HIPT',5006,'11/05/2000');
INSERT INTO doencas_paciente VALUES('ANEM',5006,'12/10/1959');
INSERT INTO doencas_paciente VALUES('BRQT',5006,'21/12/1969');
INSERT INTO doencas_paciente VALUES('DIAB2',5006,'28/10/1970');
INSERT INTO doencas_paciente VALUES('BRQT',5004,'28/07/2005');
INSERT INTO doencas_paciente VALUES('HIPT',5011,'07/03/2017');
INSERT INTO doencas_paciente VALUES('RNT',5012,'10/04/1969');
INSERT INTO doencas_paciente VALUES('DIAB1',5010,'01/03/2015');

SELECT * FROM doencas_paciente ;

/* TABELA MEDICAMENTO */
DROP TABLE  medicamento CASCADE constraints;
CREATE TABLE medicamento(
cod_medicamento integer PRIMARY KEY,
nome_medicamento VARCHAR2(30) NOT NULL,
nome_popular VARCHAR2(30) NOT NULL,
dosagem NUMERIC(5,2) NOT NULL,
tipo VARCHAR2(30) NOT NULL,
estoque INTEGER NOT NULL,
principio_ativo VARCHAR2(30) NOT NULL,
tarja VARCHAR2(20) NOT NULL);

DROP SEQUENCE medicamento_seq ;
create SEQUENCE medicamento_seq START WITH 1;

INSERT INTO medicamento VALUES(medicamento_seq.nextval,'CAPOBAL','CAPOBAL',12.5,'CARDIACO',5,'CAPTOPRIL','VERMELHA');
INSERT INTO medicamento VALUES(medicamento_seq.nextval,'BALUROL','BALUROL',400,'ANTI-INFECCIOSO URINARIO',20,'ACIDO PIPEMIDICO','S/TARJA');
INSERT INTO medicamento VALUES(medicamento_seq.nextval,'NIMESUBAL','NIMESUBAL',100,'ANTI-INFLAMATORIO',20,'NIMESULIDA','S/TARJA');
INSERT INTO medicamento VALUES(medicamento_seq.nextval,'NOVALGINA','NOVALGINA',85,'ANALGESICO',30,'DIPIRONA SODICA','VERMELHA');
INSERT INTO medicamento VALUES(medicamento_seq.nextval,'RIVOTRIL','RIVOTRIL',2.5,'CALMANTE ANTI-EPILETICO',20,'CLONAZEPAM','PRETA');
INSERT INTO medicamento VALUES(medicamento_seq.nextval,'DICLOFENACO RESINATO','CATAFLAM',100,'ANTI-INFLAMATORIO',10,'DICLOFENACO RESINATO','S/TARJA');
INSERT INTO medicamento VALUES(medicamento_seq.nextval,'ASPIRINA', 'ASPIRINA',500,'ANALGESICO',14,'ACIDO ACETILSALICILICO','S/TARJA');
SELECT * FROM medicamento ;

ALTER TABLE medicamento rename column tipo TO tipo_medcto ;

/*CRIANDO A TABELA PRESCRICAO*/
DROP TABLE  prescricao CASCADE constraints;
CREATE TABLE prescricao(
num_prescricao integer primary key,
dt_hora_prescricao timestamp not null,
cod_medicamento INTEGER NOT NULL,
num_internacao INTEGER NOT NULL,
intervalo VARCHAR2(10),
dose_prescrita VARCHAR2(10),
dt_ini_aplicacao Timestamp,
dt_termino_aplicacao timestamp,
FOREIGN KEY (cod_medicamento) REFERENCES medicamento(cod_medicamento) ON DELETE CASCADE,
FOREIGN KEY (num_internacao) REFERENCES internacao(num_internacao) ON DELETE CASCADE ,
unique ( dt_hora_prescricao, cod_medicamento, num_internacao));

DROP SEQUENCE prescricao_seq; 
CREATE SEQUENCE prescricao_seq start with 200 ;

/*INSERINDO DADOS NA TABELA PRESCRICAO*/
INSERT INTO prescricao VALUES(prescricao_seq.nextval, current_timestamp -20, 1,3000,'Cada 2hs','12mg',current_timestamp-20, current_timestamp-17);
INSERT INTO prescricao VALUES(prescricao_seq.nextval, current_timestamp -19,1,3001,'Cada 4hs','20mg', current_timestamp-19, current_timestamp-14);
INSERT INTO prescricao VALUES(prescricao_seq.nextval, current_timestamp -17,2,3002,'cada 6hs','10mg',current_timestamp-17, current_timestamp-10);
INSERT INTO prescricao VALUES(prescricao_seq.nextval, current_timestamp -12,4,3003,'Cada 2hs','15mg',current_timestamp-10, current_timestamp-7);
INSERT INTO prescricao VALUES(prescricao_seq.nextval, current_timestamp -10,5,3003,'Cada 6hs','50mg',current_timestamp-10, current_timestamp-7);
INSERT INTO prescricao VALUES(prescricao_seq.nextval, current_timestamp -2,3,3005,'Cada 12hs','25mg',current_timestamp-1, current_timestamp+3);
INSERT INTO prescricao VALUES(prescricao_seq.nextval, current_timestamp ,4,3005,'Cada 8hs','5mg',current_timestamp, current_timestamp+5);
INSERT INTO prescricao VALUES(prescricao_seq.nextval, current_timestamp ,4,3007,'Cada 8hs','5mg',current_timestamp, current_timestamp+5);

SELECT * FROM prescricao ;

/*CRIANDO A TABELA APLICACAO*/
DROP TABLE  aplicacao CASCADE constraints;
CREATE TABLE aplicacao (
num_aplicacao INTEGER PRIMARY KEY,
num_prescricao integer not null references prescricao ON delete cascade ,
dt_hora_aplicacao timestamp NOT NULL,
aplicado_por CHAR(15),
dose_aplicada INTEGER);

DROP SEQUENCE aplicacao_seq ;
CREATE SEQUENCE aplicacao_seq START WITH 400 ;

/*INSERINDO DADOS NA TABELA APLICACAO*/

INSERT INTO aplicacao VALUES(aplicacao_seq.nextval,200,current_timestamp - 19,'Zefa', 10);
INSERT INTO aplicacao VALUES(aplicacao_seq.nextval,200,current_timestamp - 50, 'Tiao',10);
INSERT INTO aplicacao VALUES(aplicacao_seq.nextval,201,current_timestamp - 49, 'Tiao', 10);
INSERT INTO aplicacao VALUES(aplicacao_seq.nextval,201,current_timestamp - 48, 'Tiao',10 );
INSERT INTO aplicacao VALUES(aplicacao_seq.nextval,201,current_timestamp - 45, 'Tiao',10 );
INSERT INTO aplicacao VALUES(aplicacao_seq.nextval,202,current_timestamp - 44, 'Tiao', 10);
INSERT INTO aplicacao VALUES(aplicacao_seq.nextval,202,current_timestamp - 40, 'Tiao',10 );
INSERT INTO aplicacao VALUES(aplicacao_seq.nextval,202,current_timestamp - 38, 'Tiao', 10);
INSERT INTO aplicacao VALUES(aplicacao_seq.nextval,203,current_timestamp - 37, 'Tiao',10 );
INSERT INTO aplicacao VALUES(aplicacao_seq.nextval,203,current_timestamp - 10, 'Tiao',10 );
INSERT INTO aplicacao VALUES(aplicacao_seq.nextval,204,current_timestamp - 10, 'Tiao',10 );
INSERT INTO aplicacao VALUES(aplicacao_seq.nextval,205,current_timestamp - 9, 'Tiao',10 );
INSERT INTO aplicacao VALUES(aplicacao_seq.nextval,205,current_timestamp - 9, 'Tiao',10 );
INSERT INTO aplicacao VALUES(aplicacao_seq.nextval,206,current_timestamp - 8, 'Tiao', 10);
INSERT INTO aplicacao VALUES(aplicacao_seq.nextval,206,current_timestamp - 8, 'Tiao',10 );
INSERT INTO aplicacao VALUES(aplicacao_seq.nextval,201,current_timestamp - 47, 'Tiao', 10);


-- Constraint de unicidade em Internação para cod_paciente + dt_hora_Entrada
ALTER TABLE internacao ADD UNIQUE( cod_paciente, dt_hora_entrada) ;

DROP TABLE cirurgia CASCADE CONSTRAINTS ;
CREATE TABLE cirurgia
( num_cirurgia INTEGER PRIMARY KEY,
dt_hora_agendada TIMESTAMP,
tipo_cirurgia CHAR(20),
proced_cirurgia VARCHAR2(100),
obs_cirurgia VARCHAR2(100));

-- relacionando com internação
ALTER TABLE cirurgia ADD num_internacao INTEGER NOT NULL REFERENCES internacao ON DELETE CASCADE ;

-- Sequência de auto-numeração para as intervenções cirúrgicas começando com 9000 ;
DROP SEQUENCE cirurgia_seq;
CREATE SEQUENCE cirurgia_seq START WITH 9000 ;

-- população cirurgia
INSERT INTO cirurgia VALUES( cirurgia_seq.nextval, current_date - 10, 'Laparoscopia', 'Normal', null, 3004); 
INSERT INTO cirurgia VALUES( cirurgia_seq.nextval, current_date - 1, 'Plastica', 'Normal', null, 3005); 

ALTER TABLE internacao modify dt_hora_entrada DEFAULT current_timestamp ;


UPDATE internacao set dt_hora_saida = dt_hora_entrada + interval '23' HOUR ;

ALTER TABLE medicamento ADD custo_dose NUMBER(12,2) ;
UPDATE medicamento set custo_dose = 1.37 ;
UPDATE medicamento set custo_dose = 1.15* custo_dose ;
INSERT INTO medicamento VALUES(medicamento_seq.nextval,'DICLOFENACO SODICO', 'VOLTAREN',500,'ANALGESICO',14,'DICLOFENACO SODICO','S/TARJA',12);

ALTER TABLE internacao ADD ( custo_internacao NUMBER(10,2), situacao_internacao CHAR(15) ) ;
ALTER TABLE internacao ADD CONSTRAINT chk_situ_inter CHECK ( situacao_internacao IN ( 'ATIVA', 'ALTA', 'SAIDA', 'OBITO')) ;

UPDATE internacao SET situacao_internacao = 'SAIDA' WHERE dt_hora_saida IS NOT NULL ;
UPDATE internacao SET situacao_internacao = 'ATIVA' WHERE dt_hora_alta IS NULL ;

-- alteracoes em medicamento
UPDATE MEDICAMENTO SET custo_dose = 10.00 ;
UPDATE MEDICAMENTO SET custo_dose = 20.00 WHERE tarja = 'PRETA';
SELECT * FROM medicamento ;
-- alteracoes em leito e internacao
ALTER TABLE leito ADD custo_diaria NUMBER(10,2) ;
UPDATE LEITO SET custo_diaria = 150  WHERE tipo_leito = 'ELETRONICO' ;
UPDATE LEITO SET custo_diaria = 100  WHERE tipo_leito = 'SIMPLES' ;
UPDATE LEITO SET custo_diaria = 75  WHERE tipo_leito = 'MECANICO' ;
SELECT * FROM LEITO ;
-- alterações em tipo_exame
ALTER TABLE tipo_exame ADD custo_exame NUMBER(10,2) ;
UPDATE tipo_exame SET custo_exame = 55.00 ;

SELECT * FROM exame_med ;
INSERT INTO exame_med VALUES( exame_seq.nextval, 7, 3003, current_timestamp - 10, 'Normal', 'Normal', 'Dra. Giulia Nunes',
'Helga Hell', null); 
INSERT INTO exame_med VALUES( exame_seq.nextval, 4, 3006, current_timestamp - 9, 'Normal', 'Normal', 'Dr. Ricardo',
'Akira Kumari', null); 

-- alteracaoes em especialidade
ALTER TABLE especialidade ADD custo_servico NUMBER (10,2) ;
UPDATE ESPECIALIDADE SET custo_servico = 75 + 10*cod_esp ;

SELECT table_name FROM user_tables ; 


SELECT COUNT (*) AS quarto FROM QUARTO;
SELECT COUNT (*) AS LEITO FROM LEITO;
SELECT COUNT (*) as medico FROM MEDICO;
SELECT COUNT (*) AS ESPECIALIDADE FROM ESPECIALIDADE;
SELECT COUNT (*) AS MEDICOEFETIVO FROM MEDICO_EFETIVO;
SELECT COUNT (*) AS MEDICORESIDENTE  FROM MEDICO_RESIDENTE;
SELECT COUNT (*) AS TIPOEXAME FROM TIPO_EXAME;
SELECT COUNT (*) AS EXAME FROM EXAME_MED;
SELECT COUNT (*) AS DOENCASPRE FROM DOENCAS_PRE_EXISTENTES;
SELECT COUNT (*) AS DOENCAS FROM DOENCAS_PACIENTE;
SELECT COUNT (*) AS MEDICAMENTO FROM MEDICAMENTO;
SELECT COUNT (*) AS PRESCRICAO FROM PRESCRICAO;
SELECT COUNT (*) AS APLICACAO FROM APLICACAO;
SELECT COUNT (*) AS CIRURGIA FROM CIRURGIA;
SELECT COUNT (*) as paciente FROM PACIENTE;
SELECT COUNT (*) as internacao FROM INTERNACAO;