--SYSDATE : função que retorna a data atual
SELECT sysdate
FROM dual;

SET SERVEROUTPUT ON --abilitando o buffer de saida da packge out put
DECLARE
    vNumero1 NUMBER(11,2) := 500;
    vNumero2 NUMBER(11,2) := 400;
    vMedia Number(11,2);
BEGIN --Iniciar sessão executavel
    vMedia := (vNumero1 + vNumero2) / 2;
    DBMS_OUTPUT.PUT_LINE('Média: ' || vMedia); -- ||Concatena
END;