--- Cursor ---
/*
Tipos de Cursor:
 - Implicito: São declarados altomáticamente para todos os comandos DML e para 
   comando SELECT que retorna somente uma linha.
 - Explicito: Podem retornar mais de uma linha, pode ser declarado e manipulado pelo programador.
*/

/*
 Método           Tipo            Tipos de Collections
 %ISOPEN          Boolean         Retorna TRUE se o cursor estiver aberto.
 %NOTFOUND        Boolean         Retorna TRUE se o ultimo FETCH não retornou uma linha.
 %FOUND           Boolean         Retorna TRUE se o ultimo FETCH retornou uma linha.
 %ROWCOUNT        Number          Retorna o número de linhas recuperadas por FETCH até o momento.
*/

-- Controlando um Cursor Explicito com LOOP Básico.
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
  FROM    employees; -- Declaração do Cursor
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
    FOR employees_record IN employees_cursor --Declarndo variável employees_record com a mesma estrutura do employees_cursor
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
    

--Cursor FOR LOOP com parâmetros
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


-- Cursor ExplÃ­cito com SELECT FOR UPDATE
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
--- Tratamento de Exceção ---
--Meu código de erro vai de -20001 até -20999;
 
--Excecções prédefinidas ORACLE
/*
Nome da exceção         Erro Oracle       Descrição
COLLECTION_IS_NULL      ORA-06531         Tentativa de aplicar métodos que não o EXISTS para uma Collection não inicializada.
CURSOR_ALREADY_OPEN     ORA-06511         Tentativa de abrir um cursor que já está aberto.
DUP_VAL_ON_INDEX        ORA-00001         Tentativa de inserir um valor duplicado em um indice único.
INVALID_CURSOR          ORA-01001         Ocorreu uma operação ilegal em um cursor.
INVALID_NUMBER          ORA-01722         Falha na conversão de uma string caractere para númerica.
LOGIN_DENIED            ORA-01017         Conexão ao ORACLE com um nome de usuário/senha inválida.
NO_DATA_FOUND           ORA-01403         SELECT do tipo single-row não retornou nem uma linha.
NOT_LOGGED_ON           ORA-01012         Programa PL/SQL executou uma chamada ao BD sem estar conectado ao ORACLE.
TIMEOUT_ON_RESOURCE     ORA-00051         Ocorreu um time-out enquanto o ORACLE estava aguardando por um recurso.
TOO_MANY_ROWS           ORA-01422         SELECT do tipo single-row retornou mais que uma linha.
VALUE_ERROR             ORA-06502         Ocorreu um erro de aritmética, converão ou truncamento.
ZERO_DIVIDE             ORA-01476         Tentativa de divisão por zero.
*/

--Tratamento de exceção pré definida ORACLE
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
     RAISE_APPLICATION_ERROR(-20001, 'Empregado nÃ£o encontrado, id = ' || 
     TO_CHAR(vEmployee_id)); --Meu código de erro -20001 até 20999;
  WHEN OTHERS 
  THEN
     RAISE_APPLICATION_ERROR(-20002, 'Erro Oracle - ' || SQLCODE || SQLERRM);

END;


-- Exceções Definidas pelo Desenvolvedor 
SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT pEmployee_id PROMPT 'Digite o id do empregado: '
DECLARE
    vFirst_name     employees.first_name%Type;
    vLast_name      employees.last_name%Type;
    vJob_id         employees.job_id%Type;
    vEmployee_id    employees.employee_id%Type := &pEmployee_id; 
    ePresident      EXCEPTION;
BEGIN
    SELECT  first_name, last_name, job_id
    INTO    vFirst_name, vLast_name, vJob_id
    FROM    employees
    WHERE   employee_id = vEmployee_id;

    IF vJob_id = 'AD_PRES'
    THEN
        RAISE ePresident; 
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND
    THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Empregado não encontrado id = ' || TO_CHAR(vEmployee_id));
    WHEN ePresident
    THEN
        UPDATE  employees
        SET     salary = salary * 1.5
        WHERE   employee_id = vEmployee_id;
    WHEN OTHERS
    THEN
        RAISE_APPLICATION_ERROR( -20002, 'Erro Oracle ' || SQLCODE || SQLERRM);
END;
        

-- PRAGMA EXCEPTION INIT
SET SERVEROUTPUT ON
DECLARE
   vemployee_id    employees.employee_id%TYPE := 300;
   vfirst_name     employees.first_name%TYPE := 'Robert';
   vlast_name      employees.last_name%TYPE := 'Ford';
   vjob_id         employees.job_id%TYPE := 'XX_YYYY';
   vphone_number   employees.phone_number%TYPE := '650.511.9844';
   vemail          employees.email%TYPE := 'RFORD';
   efk_inexistente EXCEPTION;
   PRAGMA EXCEPTION_INIT(efk_inexistente, -2291);

BEGIN
   INSERT INTO employees (employee_id, first_name, last_name, phone_number, email, hire_date,job_id)
   VALUES (vemployee_id, vfirst_name, vlast_name, vphone_number, vemail, sysdate, vjob_id);
EXCEPTION
   WHEN  efk_inexistente 
   THEN
         RAISE_APPLICATION_ERROR(-20003, 'Job inexistente!');
   WHEN OTHERS 
   THEN
         RAISE_APPLICATION_ERROR(-20002, 'Erro Oracle ' || SQLCODE || SQLERRM);
END;
-- Forçar o Erro para descobrir o código de Erro a ser tratado
   INSERT INTO employees (employee_id, first_name, last_name, phone_number, email, hire_date, job_id)
   VALUES (employees_seq.nextval, 'Joseph', 'Smith', '3333333', 'JSMITH', sysdate, 'ZZZZ_XX');


------------------------------------------------------------------------------------------------------------------------------------
--- PROCEDURE ---

-- Criando uma Procedure de Banco de Dados
CREATE OR REPLACE PROCEDURE PRC_INSERE_EMPREGADO
  (pfirst_name    IN VARCHAR2,
   plast_name     IN VARCHAR2,
   pemail         IN VARCHAR2,
   pphone_number  IN VARCHAR2,
   phire_date     IN DATE DEFAULT SYSDATE, --Se não passar um valor para ele, irá receber a data atual.
   pjob_id        IN VARCHAR2,
   pSALARY        IN NUMBER,
   pCOMMICION_PCT IN NUMBER,
   pMANAGER_ID    IN NUMBER,
   pDEPARTMENT_ID IN NUMBER)
IS 
  -- Nenhuma variável declarada
BEGIN
  INSERT INTO employees (
    employee_id,
    first_name,
    last_name,
    email,
    phone_number,
    hire_date,
    job_id,
    salary,
    commission_pct,
    manager_id,
    department_id )
  VALUES (
    employees_seq.nextval, --adicionar altomático o próximo id
    pfirst_name,
    plast_name,
    pemail,
    pphone_number,
    phire_date,
    pjob_id,
    psalary,
    pcommicion_pct,
    pmanager_id,
    pdepartment_id );
EXCEPTION
  WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20001, 'Erro Oracle ' || SQLCODE || SQLERRM);
END;

-- Executando a Procedure pelo Bloco PL/SQL
BEGIN
  PRC_INSERE_EMPREGADO('David', 'Bowie','DBOWIE','515.127.4861',SYSDATE,'IT_PROG',15000,NULL,103,60);
  COMMIT;
END;

-- Consultando o empregado inserido
SELECT *
FROM   employees
WHERE  first_name = 'David' AND
       last_name = 'Bowie';

-- Executando a Procedure com o comando EXECUTE do SQL*PLUS
EXEC PRC_INSERE_EMPREGADO('Greg', 'Lake','GLAKE','515.127.4961',SYSDATE,'IT_PROG',15000,NULL,103,60)
COMMIT;

-- Consultando o empregado inserido
SELECT *
FROM   employees
WHERE  first_name = 'Greg' AND
       last_name = 'Lake';



-- Utilizando Parametros tipo IN
CREATE OR REPLACE PROCEDURE PRC_AUMENTA_SALARIO_EMPREGADO 
    (
        pemployee_id IN NUMBER,
        ppercentual  IN NUMBER
    )
IS
    --Nenhuma variável declarada
BEGIN
    UPDATE employees
    SET    salary = salary * (1 + ppercentual / 100)
    WHERE  employee_id = pemployee_id;
    
EXCEPTION
    WHEN OTHERS
    THEN
        RAISE_APPLICATION_ERROR(-20001, 'Erro Oracle: ' || SQLCODE || ' - ' || SQLERRM);
    END;
    
--Executando a Procedure pelo Bloco PL/SQL
BEGIN 
    PRC_AUMENTA_SALARIO_EMPREGADO(109,10);
    COMMIT;
END;





















