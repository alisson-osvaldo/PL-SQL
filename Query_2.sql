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

--Comandos:
ALTER PROCEDURE PRC_CONSULTA_EMPREGADO COMPILE; --utilizado quando vc acha que seu código está ok, e quer recomplilar.

DROP PROCEDURE PRC_CONSULTA_EMPREGADO; --Deletar Procedure (pós deletar já era, só fazendo backup do BD)


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



-- Utilizando Parametros tipo IN --------------------------------------------------------------
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



-- Utilizando Parametros tipo OUT ----------------------------------------------------------
CREATE OR REPLACE PROCEDURE PRC_CONSULTA_EMPREGADO
    (pemployee_id   IN  NUMBER,
     pfirst_name     OUT VARCHAR2,
     plast_name      OUT VARCHAR2,
     pemail         OUT VARCHAR2,
     pphone_number   OUT VARCHAR2,
     phire_date      OUT DATE,
     pjob_Id        OUT VARCHAR2,
     psalary        OUT NUMBER,
     pCommission_Pct OUT NUMBER,
     pManager_Id     OUT NUMBER,
     pDepartment_Id  OUT NUMBER)
IS
    --Nenhuma váriavel de clarada
BEGIN 
    SELECT
        first_name,
        last_name,
        email,
        phone_number,
        hire_date,
        job_id,
        salary,
        commission_pct,
        manager_id,
        department_id
    INTO
        pfirst_name,
        plast_name,
        pemail,
        pphone_number,
        phire_date,
        pjob_id,
        psalary,
        pcommission_pct,
        pmanager_id,
        pdepartment_id

    FROM employees
    WHERE employee_id = pemployee_id;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APpLICATION_ERROR(-20001, 'Empregado NÃ£o existe: ' || pemployee_id);
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Erro Oracle ' || SQLCODE || SQLERRM);
END;

-- Executando procedure parametro Tipo OUT
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE 
    employees_record employees%ROWTYPE;
BEGIN   
    PRC_CONSULTA_EMPREGADO(100, employees_record.first_name, employees_record.last_name, employees_record.email,
        employees_record.phone_number, employees_record.hire_date, employees_record.job_id, employees_record.salary,
        employees_record.commission_pct, employees_record.manager_id, employees_record.department_id);
        DBMS_OUTPUT.PUT_LINE(employees_record.first_name || ' ' || 
                         employees_record.last_name || ' - ' ||
                         employees_record.department_id || ' - ' ||
                         employees_record.job_id || ' - ' ||
                         employees_record.phone_number || ' - ' ||
                         LTRIM(TO_CHAR(employees_record.salary, 'L99G999G999D99')));
END;
    
-- Utilizando Parametros tipo OUT com opção NOCOPY
CREATE OR REPLACE PROCEDURE PRC_CONSULTA_EMPREGADO
  (pemployee_id   IN NUMBER,
   pfirst_name    OUT NOCOPY VARCHAR2, --OUT NOCOPY em vez de copíar ele vai fazer referência  
   plast_name     OUT NOCOPY VARCHAR2,
   pemail         OUT NOCOPY VARCHAR2,
   pphone_number  OUT NOCOPY VARCHAR2,
   phire_date     OUT NOCOPY DATE,
   pjob_id        OUT NOCOPY VARCHAR2,
   pSALARY        OUT NOCOPY NUMBER,
   pCOMMISSION_PCT OUT NOCOPY NUMBER,
   pMANAGER_ID    OUT NOCOPY NUMBER,
   pDEPARTMENT_ID OUT NOCOPY NUMBER)
IS 
BEGIN
  SELECT
    first_name,
    last_name,
    email,
    phone_number,
    hire_date,
    job_id,
    salary,
    commission_pct,
    manager_id,
    department_id
  INTO 
    pfirst_name,
    plast_name,
    pemail,
    pphone_number,
    phire_date,
    pjob_id,
    psalary,
    pcommission_pct,
    pmanager_id,
    pdepartment_id
  FROM employees
  WHERE employee_id = pemployee_id;
  
EXCEPTION
  WHEN NO_DATA_FOUND THEN
     RAISE_APPLICATION_ERROR(-20001, 'Empregado NÃ£o existe: ' || pemployee_id);
  WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20002, 'Erro Oracle ' || SQLCODE || SQLERRM);
END;

-- Executando procedure parametro Tipo OUT
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
    employees_record    employees%ROWTYPE;
BEGIN
  PRC_CONSULTA_EMPREGADO(100, employees_record.first_name, employees_record.last_name, employees_record.email,
    employees_record.phone_number, employees_record.hire_date, employees_record.job_id, employees_record.salary, 
    employees_record.commission_pct, employees_record.manager_id, employees_record.department_id);
    DBMS_OUTPUT.PUT_LINE(employees_record.first_name || ' ' || 
                         employees_record.last_name || ' - ' ||
                         employees_record.department_id || ' - ' ||
                         employees_record.job_id || ' - ' ||
                         employees_record.phone_number || ' - ' ||
                         LTRIM(TO_CHAR(employees_record.salary, 'L99G999G999D99')));
END;


-- Método Nomeado
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
    VEMPLOYEE_ID    NUMBER := 100;
    VFIRST_NAME     VARCHAR2(200);
    VLAST_NAME      VARCHAR2(200);
    VEMAIL          VARCHAR2(200);
    VPHONE_NUMBER   VARCHAR2(200);
    VHIRE_DATE      DATE;
    VJOB_ID         VARCHAR2(200);
    VSALARY         NUMBER;
    VCOMMISSION_PCT NUMBER;
    VMANAGER_ID     NUMBER;
    VDEPARTMENT_ID  NUMBER;
BEGIN
    PRC_CONSULTA_EMPREGADO(
        PEMPLOYEE_ID     => VEMPLOYEE_ID,  --PEMPLOYEE_ID   parâmetro OUT que vai receber o valor de   VEMPLOYEE_ID
        PFIRST_NAME      => VFIRST_NAME,
        PLAST_NAME       => VLAST_NAME,
        PEMAIL           => VEMAIL,
        PPHONE_NUMBER    => VPHONE_NUMBER,
        PHIRE_DATE       => VHIRE_DATE,
        PJOB_ID          => VJOB_ID,
        PSALARY          => VSALARY,
        PCOMMISSION_PCT  => VCOMMISSION_PCT,
        PMANAGER_ID      => VMANAGER_ID,
        PDEPARTMENT_ID   => VDEPARTMENT_ID
    );
    DBMS_OUTPUT.PUT_LINE('PFIRST_NAME     = ' || VFIRST_NAME);
    DBMS_OUTPUT.PUT_LINE('PLAST_NAME      = ' || VLAST_NAME);
    DBMS_OUTPUT.PUT_LINE('PEMAIL          = ' || VEMAIL);
    DBMS_OUTPUT.PUT_LINE('PPHONE_NUMBER   = ' || VPHONE_NUMBER);
    DBMS_OUTPUT.PUT_LINE('PHIRE_DATE      = ' || VHIRE_DATE);
    DBMS_OUTPUT.PUT_LINE('PJOB_ID         = ' || VJOB_ID);
    DBMS_OUTPUT.PUT_LINE('PSALARY         = ' || VSALARY);
    DBMS_OUTPUT.PUT_LINE('PCOMMISSION_PCT = ' || VCOMMISSION_PCT);
    DBMS_OUTPUT.PUT_LINE('PMANAGER_ID     = ' || VMANAGER_ID);
    DBMS_OUTPUT.PUT_LINE('PDEPARTMENT_ID  = ' || VDEPARTMENT_ID);
END;



--------------------------------------------------------------------------------------------------------------
--CRIANDO FUNÇÕES DE BANCO DE DADOS

/*
- Um função é uma sub-rotina que sempre retorna um valor.
- Utilize uma FUNÇÂO ao invez de um PROCEDURE quando a rotina retorna obrigatóriamente um valor.
- Se a rotina retornar nenhum ou mais de um valor, considere o uso de uma PROCEDURE. 
*/

CREATE OR REPLACE FUNCTION  FNC_CONSULTA_SALARIO_EMPREGADO(pemployee_id IN NUMBER)
    RETURN NUMBER
IS 
    vSalary employees.salary%TYPE;
BEGIN
    SELECT salary
    INTO   vSalary
    FROM   employees
    WHERE  employee_id = pemployee_id;
    RETURN (vSalary);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Empregado inexistente');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-2002, 'ERRO Oracle ' || SQLCODE || ' - ' || SQLERRM);
END;

--Executando a Função pelo bloco PL/SQL
SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT pEmployee_id PROMPT 'Digite o Id do empregado: '
DECLARE
    vEmployee_id    employees.employee_id%TYPE := &pEmployee_id;
    vSalary         employees.salary%TYPE;
BEGIN
    vSalary := FNC_CONSULTA_SALARIO_EMPREGADO(VEmployee_id);
    DBMS_OUTPUT.PUT_LINE('Salario: ' || vSalary);
END;



/*
    Regras para o uso de funções em comandos SQL
    * As funções devem ser armazenadas no servidor de Banco De Dados.
    * A função deve ser do tipo SINGLE-ROW.
    * No corpo da função, não devem ter comandos DML.
    * A função deve ter apenas parâmetros do tipo IN.
    * Tipo PL/SQL, tais como BOOLEAN, RECORD, ou TABLE (array associative), não são aceitos como o tipo de retorno da função.
    * No corpo da função, não são permitidas chamadas sub-rotinas que desobedeçam quaisquer restrições anteriores. 
*/

-- Utilizando Funçôes em comandos SQL
CREATE OR REPLACE FUNCTION FNC_CONSULTA_TITULO_CARGO_EMPREGADO(pJob_id  IN jobs.job_title%TYPE)
    RETURN VARCHAR2
IS
    vJob_title  jobs.job_title%Type;
BEGIN
    SELECT  job_title
    INTO    vJob_title
    FROM    jobs
    WHERE   job_id = pJob_id;
    RETURN  (vJob_title);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'job inexistente');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Erro Oracle' || SQLCODE || ' - ' || SQLERRM);
END;

-- Exemplo Utilizando Funções em comandos SQL (mais correto aqui seria utilizar um join, aqui apenas para exemplo)
SELECT employee_id, first_name, last_name, job_id, FNC_CONSULTA_TITULO_CARGO_EMPREGADO(job_id) "JOB TITLE"
FROM employees;

--Mesma consulta mas para penas uma consulta
SELECT FNC_CONSULTA_TITULO_CARGO_EMPREGADO('IT_PROG')
FROM   dual; --dual tabela que retorna penas uma linhas.

-- Mesma consulta mas para apenas empregado job_id 130
SELECT FNC_CONSULTA_SALARIO_EMPREGADO(130)
FROM   dual;

--Comando para Recompilar função 
ALTER FUNCTION FNC_CONSULTA_TITULO_CARGO_EMPREGADO COMPILE;

--Comando para Remover uma função do BD (Removeu já erá, apenas backup para restaurar)
DROP FUNCTION FNC_CONSULTA_TITULO_CARGO_EMPREGADO;


----------------------------------------------------------------------------------------------------------------------------------
-- Gerenciando PROCEDURES e FUNCTIONS

--Consultando Objetos tipo PROCEDURE e FUNCTION do seu usuário - prática

DESC USER_OBJECTS --informações dos objetos do usuário em que está conectado ex: user hr

-- Consulta todas as PROCEDURES e FUNÇÔES
SELECT object_name, object_type, last_ddl_time, timestamp, status
FROM   user_objects
WHERE  object_type IN ('PROCEDURE', 'FUNCTION');

-- Consulta todos os Objetos até mesmo os que o Oracle criou (objetos q seu usuário tem privilégio)
SELECT object_name, object_type, last_ddl_time, timestamp, status
FROM   all_objects
WHERE  object_type IN ('PROCEDURE', 'FUNCTION');

-- Consultando objetos Inválidos do schema do seu usuário 
SELECT object_name, object_type, last_ddl_time, timestamp, status
FROM   user_objects
WHERE  status = 'INVALID';

-- Consultando o Código Fonte de Procedures e Fuções do seu usuário
DESC user_source --Se eu quero consultar o código fonte de um objeto uso a visão user_source

--Consultando Código Fonte da PROCEDURE
SELECT line, text
FROM   user_source
WHERE  name = 'PRC_INSERE_EMPREGADO' AND
       type = 'PROCEDURE'

ORDER BY line;

--Consultando Código Fonte da FUNCTION
SELECT line, text
FROM   user_source
WHERE  name = 'FNC_CONSULTA_SALARIO_EMPREGADO' AND
       type = 'FUNCTION'
ORDER BY line;

-- Consultando a lista de parâmetros de Procedures e Funções 
DESC PRC_INSERE_EMPREGADO

DESC FNC_CONSULTA_SALARIO_EMPREGADO

-- Consultando Erros de Compilação
/*
- SHOW ERRORS PROCEDURE nome_procedure
- SHOW ERRORS FUNTION   nome_function
- SHOW ERRORS PACKAGE   nome_package

* USER_ERRORS tem os erros do objetos do esquema do usuário em que está conectado.
* ALL_ERRORS  tem os erros do objetos do esquema do usuário em que está conectado e em que ele tem privilégio.
* DBA_ERRORS  tem os erros de todo o banco de dados, más pode ser acessado apenas pelo DBA.
*/

-- Forçando um erro de compilação
CREATE OR REPLACE FUNCTION FNC_CONSULTA_SALARIO_EMPREGADO
  (pemployee_id   IN NUMBER)
   RETURN NUMBER
IS 
  vsalary  employees.salary%TYPE;
BEGIN
  SELECT salary
  INTO   vsalary
  FROM   employees
  WHERE employee_id = pemployee_id --Sem o ; aqui
  RETURN (vsalary);
EXCEPTION
  WHEN NO_DATA_FOUND THEN 
      RAISE_APPLICATION_ERROR(-20001, 'Empregado inexistente');
  WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20002, 'Erro Oracle ' || SQLCODE || SQLERRM);
END;

-- Consultando Erros de Compilação - Comando SHOW ERRORS
SHOW ERRORS FUNCTION  FNC_CONSULTA_SALARIO_EMPREGADO
SHOW ERRORS PROCEDURE FNC_CONSULTA_SALARIO_EMPREGADO

-- Consultando Erros de Compilação - Visão USER_ERRORS
DESC user_errors

COLUMN position FORMAT a4 --Formatando a coluna
COLUMN text FORMAT a60    --Formatando a coluna
SELECT line||'/'||position position, text
FROM   user_errors
WHERE  name = 'FNC_CONSULTA_SALARIO_EMPREGADO'
ORDER BY line;

--Consultando ERRO de compilação com o comando SHOW_ERRORS (só vai precisar se estiver compilando pelo SQL PLUS)
SHOW ERRORS PROCEDURE FNC_CONSULTA_SALARIO_EMPREGADO;

