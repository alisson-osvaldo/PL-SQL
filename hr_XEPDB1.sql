-- Definindo Indentificadores - Váriaveis

-- Literal Númerico --
vvalor := 5000; --Recebe valor 5mil (decimal)
vvalor2 := 2638E8; --Recebe (2638 * 10) ^ 8; (literal em notação Ciêntifica)
vdouble := 2.0d; --Recebe 2.0 que é do tipo (Double)
vfloat := 2.0f; --Recebe 2.0 que é do tipo (Float)

-- Literal Boleano --
vboleano = TRUE;
vboleano = FALSE;
vboleano NULL;

-- Literal String --
vstring = 'String de caractéres';

/*
-Declare e inicialize variaveis dentro da sessão "DECLARE".
-Declarações também podem atribuir um valor inicial e atribuir a constraint "NOT NULL".
-Para atribuir novos valores a variável deve estar dentro da sessão "BEGIN";

Sintaxe para declarar váriaveis:

DECLARE
NomeIdentificador [CONSTANT] TipoDeDado     
[NOT NULL][:= | DEFAULT expressão]; --Para inicializar a variável := ou DEFAULT eo valor;  
*/



-------------------------------------------------------------------------------
--SYSDATE : função que retorna a data atual
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
BEGIN --Iniciar sessão executavel
    vMedia := (vNumero1 + vNumero2) / 2;
    DBMS_OUTPUT.PUT_LINE('Média: ' || vMedia); -- ||Concatena
END;

--Delcarando variável do tipo CHAR e VARCHAR
SET SERVEROUTPUT ON 
DECLARE
    vCaracterTamanhoFixo CHAR(4) := 'Olá';
    vTexto VARCHAR(100):= 'Seja bem vindo ao PL/SQL';
BEGIN
    DBMS_OUTPUT.PUT_LINE(vCaracterTamanhoFixo || Chr(10) || vTexto);
EXCEPTION 
    WHEN OTHERS 
    THEN
    DBMS_OUTPUT.PUT_LINE('Erro Oracle: ' || SQLCODE || SQLERRM);
END;

--Declarando variável do tipo Date
SET SERVEROUTPUT ON
DECLARE
    vData1 DATE := '16/07/22';
    vData2 DATE := '16/07/2022';
BEGIN
    DBMS_OUTPUT.PUT_LINE('vData1: ' || vData1);
    DBMS_OUTPUT.PUT_LINE('vData2: ' || vData2);   
END;

--Delcarando variáveis do tipo CONSTANTE
DECLARE 
    vConstante CONSTANT NUMBER(38,15) := 3.141592653589793;
    vCaracterFixo CONSTANT CHAR(2) := 'PR';
    vCaracterVariavel CONSTANT VARCHAR2(100) := 'Caracter variável';
BEGIN
    DBMS_OUTPUT.PUT_LINE('vConstante: ' || vConstante);
    DBMS_OUTPUT.PUT_LINE('vCaracterFixo: ' || vCaracterFixo);
    DBMS_OUTPUT.PUT_LINE('vCaracterVariavel: ' || vCaracterVariavel);
END;

-----------------------------------------------------------------------------