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


SET SERVEROUTPUT ON 
DECLARE
    vTexto VARCHAR(100):= 'Seja bem vindo ao PL/SQL';
BEGIN
    DBMS_OUTPUT.PUT_LINE(vTexto);
EXCEPTION 
    WHEN OTHERS 
    THEN
    DBMS_OUTPUT.PUT_LINE('Erro Oracle: ' || SQLCODE || SQLERRM);
END;

----------------------------------------------------------------------------