-- Definindo Indentificadores - V�riaveis

-- Literal N�merico --
vvalor := 5000; --Recebe valor 5mil (decimal)
vvalor2 := 2638E8; --Recebe (2638 * 10) ^ 8; (literal em nota��o Ci�ntifica)
vdouble := 2.0d; --Recebe 2.0 que � do tipo (Double)
vfloat := 2.0f; --Recebe 2.0 que � do tipo (Float)

-- Literal Boleano --
vboleano = TRUE;
vboleano = FALSE;
vboleano NULL;

-- Literal String --
vstring = 'String de caract�res';

/*
-Declare e inicialize variaveis dentro da sess�o "DECLARE".
-Declara��es tamb�m podem atribuir um valor inicial e atribuir a constraint "NOT NULL".
-Para atribuir novos valores a vari�vel deve estar dentro da sess�o "BEGIN";

Sintaxe para declarar v�riaveis:

DECLARE
NomeIdentificador [CONSTANT] TipoDeDado     
[NOT NULL][:= | DEFAULT express�o]; --Para inicializar a vari�vel := ou DEFAULT eo valor;  
*/



-------------------------------------------------------------------------------
--SYSDATE : fun��o que retorna a data atual
SELECT sysdate
FROM dual;

SELECT TO_CHAR(sysdate, 'DD,MM,YYYY') FROM dual;

------------------------------------------------------------------------------
--Bloco anonimo

SET SERVEROUTPUT ON --abilitando o buffer de saida da packge out put
DECLARE
    vNumero1 NUMBER(11,2) := 500;
    vNumero2 NUMBER(11,2) := 400;
    vMedia Number(11,2);
BEGIN --Iniciar sess�o executavel
    vMedia := (vNumero1 + vNumero2) / 2;
    DBMS_OUTPUT.PUT_LINE('M�dia: ' || vMedia); -- ||Concatena
END;

--Delcarando vari�vel do tipo CHAR e VARCHAR
SET SERVEROUTPUT ON 
DECLARE
    vCaracterTamanhoFixo CHAR(4) := 'Ol�';
    vTexto VARCHAR(100):= 'Seja bem vindo ao PL/SQL';
BEGIN
    DBMS_OUTPUT.PUT_LINE(vCaracterTamanhoFixo || Chr(10) || vTexto);
EXCEPTION 
    WHEN OTHERS 
    THEN
    DBMS_OUTPUT.PUT_LINE('Erro Oracle: ' || SQLCODE || SQLERRM);
END;

--Declarando vari�vel do tipo Date
SET SERVEROUTPUT ON
DECLARE
    vData1 DATE := '16/07/22';
    vData2 DATE := '16/07/2022';
BEGIN
    DBMS_OUTPUT.PUT_LINE('vData1: ' || vData1);
    DBMS_OUTPUT.PUT_LINE('vData2: ' || vData2);   
END;

--Delcarando vari�veis do tipo CONSTANTE
DECLARE 
    vConstante CONSTANT NUMBER(38,15) := 3.141592653589793;
    vCaracterFixo CONSTANT CHAR(2) := 'PR';
    vCaracterVariavel CONSTANT VARCHAR2(100) := 'Caracter vari�vel';
BEGIN
    DBMS_OUTPUT.PUT_LINE('vConstante: ' || vConstante);
    DBMS_OUTPUT.PUT_LINE('vCaracterFixo: ' || vCaracterFixo);
    DBMS_OUTPUT.PUT_LINE('vCaracterVariavel: ' || vCaracterVariavel);
END;

-----------------------------------------------------------------------------