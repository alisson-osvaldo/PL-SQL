--- Cursor ---
/*
Tipos de Cursor:
 - Implicito: S?o declarados altom?ticamente para todos os comandos DML e para 
   comando SELECT que retorna somente uma linha.
 - Explicito: Podem retornar mais de uma linha, pode ser declarado e manipulado pelo programador.
*/

/*
 M?todo           Tipo            Tipos de Collections
 %ISOPEN          Boolean         Retorna TRUE se o cursor estiver aberto.
 %NOTFOUND        Boolean         Retorna TRUE se o ultimo FETCH n?o retornou uma linha.
 %FOUND           Boolean         Retorna TRUE se o ultimo FETCH retornou uma linha.
 %ROWCOUNT        Number          Retorna o n?mero de linhas recuperadas por FETCH at? o momento.
*/

-- Controlando um Cursor Explicito com LOOP B?sico.
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
    CURSOR employees_cursor IS
    SELECT * 
    FROM   employees; --Declarando cursor
    
    employees_record    employees_cursor%rowtype; --employees_record vai ter toda a estrutura da tabela employees.
BEGIN
    OPEN employees_cursor;  -- Abrindo o Cursor
    
    LOOP
        FETCH employees_cursor
        INTO  employees_record;  -- Fetch do Cursor, vai colocar aqui toda a estrutura da tabela employees.
    
        EXIT WHEN employees_cursor%notfound; --Se meu cursor estiver vazio, saia do LOOP.
        
        DBMS_OUTPUT.PUT_LINE(employees_record.employee_id || ' - ' ||
                     employees_record.first_name || ' ' || 
                     employees_record.last_name || ' - ' ||
                     employees_record.department_id || ' - ' ||
                     employees_record.job_id || ' - ' ||
                     employees_record.phone_number || ' - ' ||
                     LTRIM(TO_CHAR(employees_record.salary, 'L99G999G999D99')));
    END LOOP;
    CLOSE employees_cursor; -- Close do Cursor
END;
    
     
-- Controlando um Cursor Explicito com WHILE LOOP
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
  CURSOR  employees_cursor  IS
  SELECT *
  FROM    employees; -- Declara??o do Cursor
  employees_record  employees_cursor%rowtype; 
BEGIN
  OPEN  employees_cursor; -- Abrindo o Cursor
  
  FETCH  employees_cursor  
    INTO  employees_record; -- Fetch do Cursor
	
  WHILE  employees_cursor%found  LOOP --Enquanto a ultima linha for TRUE 
     DBMS_OUTPUT.PUT_LINE(employees_record.employee_id || ' - ' ||
                         employees_record.first_name || ' ' || 
                         employees_record.last_name || ' - ' ||
                         employees_record.department_id || ' - ' ||
                         employees_record.job_id || ' - ' ||
                         employees_record.phone_number || ' - ' ||
                         LTRIM(TO_CHAR(employees_record.salary, 'L99G999G999D99')));
    FETCH  employees_cursor  
      INTO  employees_record;
  END LOOP;
  
  CLOSE employees_cursor; -- Close do Cursor
END;
    
  
--Controlando um cursor explicito utilizando CURSOR FOR LOOP
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
    CURSOR employees_cursor IS 
    SELECT *
    FROM   employees;
BEGIN
    FOR employees_record IN employees_cursor --Declarndo vari?vel employees_record com a mesma estrutura do employees_cursor
    LOOP
        DBMS_OUTPUT.PUT_LINE(employees_record.employee_id || ' - ' ||
                         employees_record.first_name || ' ' || 
                         employees_record.last_name || ' - ' ||
                         employees_record.department_id || ' - ' ||
                         employees_record.job_id || ' - ' ||
                         employees_record.phone_number || ' - ' ||
                         LTRIM(TO_CHAR(employees_record.salary, 'L99G999G999D99')));
    END LOOP;
END;


-- CURSOR FOR LOOP utilizando Sub-consulta
SET SERVEROUTPUT ON
SET VERIFY OFF
BEGIN
    FOR employees_record IN ( SELECT * FROM employees)
    LOOP
        DBMS_OUTPUT.PUT_LINE(employees_record.employee_id || ' - ' ||
                         employees_record.first_name || ' ' || 
                         employees_record.last_name || ' - ' ||
                         employees_record.department_id || ' - ' ||
                         employees_record.job_id || ' - ' ||
                         employees_record.phone_number || ' - ' ||
                         LTRIM(TO_CHAR(employees_record.salary, 'L99G999G999D99')));
    END LOOP;
END;
    

--Cursor FOR LOOP com par?metros
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
    CURSOR employees_cursor(pdepartment_id NUMBER, pjob_id VARCHAR2)
    IS
    SELECT *
    FROM   employees
    WHERE  department_id = pdepartment_id AND job_id = pjob_id;
BEGIN
    FOR employees_record IN employees_cursor(60, 'IT_PROG') 
    LOOP
        DBMS_OUTPUT.PUT_LINE(employees_record.employee_id || ' - ' ||
                         employees_record.first_name || ' ' || 
                         employees_record.last_name || ' - ' ||
                         employees_record.department_id || ' - ' ||
                         employees_record.job_id || ' - ' ||
                         employees_record.phone_number || ' - ' ||
                         LTRIM(TO_CHAR(employees_record.salary, 'L99G999G999D99')));
    END LOOP;
END;


-- Cursor Explícito com SELECT FOR UPDATE
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
    CURSOR  employees_cursor(pjob_id VARCHAR2)
    IS
    SELECT *
    FROM   employees
    WHERE  job_id = pjob_id
    FOR UPDATE;
BEGIN
    FOR employees_record IN employees_cursor('AD_VP')
    LOOP
        UPDATE employees
        SET    salary = salary * (1 + 10 / 100)
        WHERE CURRENT OF employees_cursor;
    END LOOP;
    COMMIT;
END;


------------------------------------------------------------------------------------------------------------------------------------
--- Tratamento de Exce??o ---
--Meu c?digo de erro vai de -20001 at? -20999;
 
--Excec??es pr?definidas ORACLE
/*
Nome da exce??o         Erro Oracle       Descri??o
COLLECTION_IS_NULL      ORA-06531         Tentativa de aplicar m?todos que n?o o EXISTS para uma Collection n?o inicializada.
CURSOR_ALREADY_OPEN     ORA-06511         Tentativa de abrir um cursor que j? est? aberto.
DUP_VAL_ON_INDEX        ORA-00001         Tentativa de inserir um valor duplicado em um indice ?nico.
INVALID_CURSOR          ORA-01001         Ocorreu uma opera??o ilegal em um cursor.
INVALID_NUMBER          ORA-01722         Falha na convers?o de uma string caractere para n?merica.
LOGIN_DENIED            ORA-01017         Conex?o ao ORACLE com um nome de usu?rio/senha inv?lida.
NO_DATA_FOUND           ORA-01403         SELECT do tipo single-row n?o retornou nem uma linha.
NOT_LOGGED_ON           ORA-01012         Programa PL/SQL executou uma chamada ao BD sem estar conectado ao ORACLE.
TIMEOUT_ON_RESOURCE     ORA-00051         Ocorreu um time-out enquanto o ORACLE estava aguardando por um recurso.
TOO_MANY_ROWS           ORA-01422         SELECT do tipo single-row retornou mais que uma linha.
VALUE_ERROR             ORA-06502         Ocorreu um erro de aritm?tica, conver?o ou truncamento.
ZERO_DIVIDE             ORA-01476         Tentativa de divis?o por zero.
*/

--Tratamento de exce??o pr? definida ORACLE
SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT  pEmployee_id PROMPT 'Digite o Id do Empregado: '
DECLARE
  vFirst_name   employees.first_name%TYPE;
  vLast_name    employees.last_name%TYPE;
  vEmployee_id  employees.employee_id%TYPE := &pEmployee_id;
BEGIN
  SELECT first_name, last_name
  INTO   vfirst_name, vlast_name
  FROM   employees
  WHERE  employee_id = vEmployee_id;

  DBMS_OUTPUT.PUT_LINE('Empregado: ' || vfirst_name || ' ' || vlast_name);
 
EXCEPTION
  WHEN NO_DATA_FOUND 
  THEN
     RAISE_APPLICATION_ERROR(-20001, 'Empregado não encontrado, id = ' || 
     TO_CHAR(vEmployee_id)); --Meu c?digo de erro -20001 at? 20999;
  WHEN OTHERS 
  THEN
     RAISE_APPLICATION_ERROR(-20002, 'Erro Oracle - ' || SQLCODE || SQLERRM);

END;

