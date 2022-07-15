--SYSDATE : fun��o que retorna a data atual
SELECT sysdate
FROM dual;

-- Bloco anonimo --------------------------------------------------------------

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

