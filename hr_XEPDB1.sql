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


------------------------------------------------------------------------------------------------------------------------------------
-- Declarando Vari�veis utilizando os principais Tipos de Dados

--Delcarando vari�vel do tipo CHAR e VARCHAR
SET SERVEROUTPUT ON --abilitando o buffer de saida da packge out put
DECLARE
    vCaracterTamanhoFixo CHAR(4) := 'Ol�';
    vTexto VARCHAR2(100):= 'Seja bem vindo ao PL/SQL';
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
    vPI CONSTANT NUMBER(38,15) := 3.141592653589793;
    vCaracterFixo CONSTANT CHAR(2) := 'PR';
    vCaracterVariavel CONSTANT VARCHAR2(100) := 'Caracter vari�vel';
BEGIN
    DBMS_OUTPUT.PUT_LINE('vPI: ' || vPI);
    DBMS_OUTPUT.PUT_LINE('vCaracterFixo: ' || vCaracterFixo);
    DBMS_OUTPUT.PUT_LINE('vCaracterVariavel: ' || vCaracterVariavel);
END;

--Declarando v�riavel do tipo LONG e LONG RAW
DECLARE
    vTexto LONG := 'CAR'; --Inicializa com uma String
    vVar LONG RAW := HEXTORAW('43'||'41'||'52'); --LONG RAW: para dados bin�rios, HEXTORAW: fun��o que converte exadecimal para bin�rio.
BEGIN                                            --43: 'C', 41:'A', 52:'R'. vVar := 'CAR';
    DBMS_OUTPUT.PUT_LINE('vTexto: ' || vTexto);
    DBMS_OUTPUT.PUT_LINE('vVar: ' || vVAr);
END;

--Declarando vari�vel do tipo ROWID
/*
-� o endere�o l�gico de uma linha de uma tabela.
-� um String de 18 Caract�res.
*/
DECLARE
vRowid ROWID;

--Declarando vari�vel do tipo: 
--DATE
DECLARE
    vData1 DATE := SYSDATE;
    vData2 DATE := 17/08/22;
    
--TIMESTAMP: com 9 digitos de segundos
DECLARE
    vData1 TIMESTAMP := SYSTIMESTAMP;
    vData2 TIMESTAMP(3) := SYSTIMESTAMP;
BEGIN
    DBMS_OUTPUT.PUT_LINE('vData1: ' || vData1);
    DBMS_OUTPUT.PUT_LINE('vData2: ' || vData2);
END;

--TIMESTAMP WITH TIME ZONE: com 9 digitos de segundos e UTC da regi�o configurada para o banco de dados ex: Brasil/Paran�.
DECLARE
    vData1 TIMESTAMP(2) WITH TIME ZONE := SYSTIMESTAMP;
BEGIN
    DBMS_OUTPUT.PUT_LINE('vData1: ' || vData1);
END;

--TIMESTAMP WITH TIME ZONE: vai mostrar a UTC Data de onde est� o BD
    vData1 TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
    vData2 TIMESTAMP WITH LOCAL TIME ZONE := SYSTIMESTAMP;

--NVARCHAR e VARCHAR2
/*
Ambos suporta qualquer linguagem Universal.
VARCHAR2: pode ser UTF8 gasta 3 bits para cada caracter ou DEFAULT que � AL16UTF16 gasta 2 bits para cada car�cter.
*/

--BINARY_INTEGER
/*
-Apenas valores inteiros sem decimais.
-Mais eficiente doque NUMBER pois consome menos espa�o em mem�ria.
*/
DECLARE
    vValor1 BINARY_INTEGER := 10;
    vValor2 BINARY_INTEGER := 2155254;
BEGIN 
    DBMS_OUTPUT.PUT_LINE('vValor1: ' || vValor1 || Chr(10) || 'vValor2: ' || vValor2);
END;

--BINARY_FLOAT
--Precis�o simple(32bits) semehante ao NUMBER.
vVar1 BINARY_FLOAT := 14;

--BINARY_DOUBLE
--Precis�o dupla(64bits) representa uma faixa de n�meros muito maior.
vVar1 BINARY_DOUBLE := 54;

--%TYPE 
/*Declarando vari�vel por refer�ncia, utilizando coluna de uma tabela.*/
DECLARE
    vVar1 employees.FIRST_NAME%TYPE;


--Exemplo de todas as declara��es
SET SERVEROUTPUT ON
DECLARE
  vNumero              NUMBER(11,2) := 1200.50;
  vCaracterTamFixo     CHAR(100) := 'Texto de Tamanho Fixo de at� 32767 bytes';
  vCaracterTamVariavel VARCHAR2(100) := 'Texto Tamanho vari�vel de at� 32767 bytes';
  vBooleano            BOOLEAN := TRUE;
  vData                DATE := sysdate;
  vLong                LONG := 'Texto Tamanho vari�vel de at� 32760 bytes';
  vRowid               ROWID;
  vTimestamp           TIMESTAMP := systimestamp;
  vTimestamptz         TIMESTAMP WITH TIME ZONE := systimestamp;
  vCaracterTamFixoUniversal     NCHAR(100) := 'Texto de Tamanho Fixo Universal de at� 32767 bytes';
  vCaracterTamVariavelUniversal NVARCHAR2(100) := 'Texto Tamanho vari�vel Universal de at� 32767 bytes';
  vNumeroInteiro       BINARY_INTEGER := 1200;
  vNumeroFloat         BINARY_FLOAT := 15000000;
  vNumeroDouble        BINARY_DOUBLE := 15000000;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Numero = ' ||   vNumero);
  DBMS_OUTPUT.PUT_LINE('String Caracteres Tam Fixo = ' || vCaracterTamFixo );
  DBMS_OUTPUT.PUT_LINE('String Caracteres Tam Vari�vel = ' || vCaracterTamVariavel );
  IF  vBooleano = TRUE
  THEN 
    DBMS_OUTPUT.PUT_LINE('Booleano = ' || 'TRUE');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Booleano = ' || 'FALSE OR NULL');
  END IF;
  DBMS_OUTPUT.PUT_LINE('Data = ' || vData);
  DBMS_OUTPUT.PUT_LINE('Long = ' || vLong );
  SELECT rowid
  INTO   vRowid
  FROM   employees
  WHERE  first_name = 'Steven' AND last_name = 'King';
  DBMS_OUTPUT.PUT_LINE('Rowid = ' || vRowid );
  DBMS_OUTPUT.PUT_LINE('Timestamp = ' || vTimestamp);
  DBMS_OUTPUT.PUT_LINE('Timestamp with time zone= ' || vTimestamptz);
  DBMS_OUTPUT.PUT_LINE('String Caracteres Tam Fixo = ' || vCaracterTamFixoUniversal );
  DBMS_OUTPUT.PUT_LINE('String Caracteres Tam Vari�vel = ' || vCaracterTamVariavelUniversal );
  DBMS_OUTPUT.PUT_LINE('Numero Inteiro = ' || vNumeroInteiro);
  DBMS_OUTPUT.PUT_LINE('Numero Float = ' || vNumeroFloat);
  DBMS_OUTPUT.PUT_LINE('Numero Double = ' || vNumeroDouble);
END;

--V�ri�vel BIND
/*
-S�o declaradas esternamentes ao bloco PL/SQL, n�o s�o declaradas na ses�o DECLARE.
-Utilizadas para passar valores em tempo de execu��o, para um ou mais blocos PL/SQL.
*/
SET SERVEROUTPUT ON
    VARIABLE gMedia NUMBER
DECLARE
    vNumero1 NUMBER(11,2) := 2000;
    vNumero2 NUMBER(11,2) := 5000;
BEGIN
    :gMedia := (vNumero1 + vNumero2) / 2;
    DBMS_OUTPUT.PUT_LINE('M�dia: ' || TO_CHAR(:gMedia));
EXCEPTION
    WHEN OTHERS
    THEN
    DBMS_OUTPUT.PUT_LINE('ERRO Oralcle: ' || SQLCODE || SQLERRM);
END;

--(Fun��es)------------------------------------------------------------------------------------------------------------------------------
/*
Fun��es e express�es que n�o podemos utilizar no PL/SQl apenas em SQL:
- DECODE
- Fun��es de grupo: AVG,SUM, MIN, MAX, COUNT, STDDEV e VARIANCE.
*/

--SYSDATE : fun��o que retorna a data atual
SELECT sysdate
FROM dual;

SELECT TO_CHAR(sysdate, 'DD,MM,YYYY') FROM dual;

--DESC fun��o que mostra a estrutura da tabela.
DESC employees

------------------------------------------------------------------------------------------------------------------------------------
-- Escopo de Identificadores e Blocos Aninhados

SET SERVEROUTPUT ON
<<BLOCO1>>
DECLARE
  vbloco1 VARCHAR2(20) := 'Bloco 1';
BEGIN
  DBMS_OUTPUT.PUT_LINE('Referenciando vari�vel do Bloco 1: ' || bloco1.vbloco1);
  -- Se voce referencia vbloco2 aqui ocorrer� Erro
  <<BLOCO2>>
  DECLARE
    vbloco2 VARCHAR2(20) := 'Bloco 2';
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Referenciando vari�vel do Bloco 1: ' || bloco1.vbloco1);
    DBMS_OUTPUT.PUT_LINE('Referenciando vari�vel do Bloco 2: ' || bloco2.vbloco2);
  END;
  DBMS_OUTPUT.PUT_LINE('Referenciando vari�vel do Bloco 1: ' || bloco1.vbloco1);
  -- Se voce referencia vbloco2 aqui ocorrer� Erro
END;

------------------------------------------------------------------------------------------------------------------------------------
-- Comandos SQL no PL/SQL
/*
    SELECT:
    - Deve retornar apenas uma linha.
    - Caso retorne mais de um gera exce��o TOO_MANY_ROWS.
    - Caso n�o retorne nenhuma linha gera exece��o NO_DATA_FOUND.
    - Voc� deve garantir que o comando SELECT retorne somente uma linha.
*/
--Pegando nome, sobreno e sal�rio do funcionario cujo employee_id = 121.
SET SERVEROUTPUT ON
DECLARE
    vFirst_name   employees.first_name%type;
    vLast_name    employees.last_name%type;
    vSalary       employees.salary%type;
    vEmployee_id  employees.employee_id%type := 121;
BEGIN
    SELECT first_name, last_name, salary
    INTO  vFirst_name, vLast_name, vSalary
    FROM employees
    WHERE employee_id = vEmployee_id;
    DBMS_OUTPUT.PUT_LINE('vEmployee_id: ' || vEmployee_id);
    DBMS_OUTPUT.PUT_LINE('vFirst_name: ' || vFirst_name);
    DBMS_OUTPUT.PUT_LINE('vLast_name: ' || vLast_name);
    DBMS_OUTPUT.PUT_LINE('vSalary: ' || vSalary);
END;

--Pegando a m�dia e somat�rio de todos os salarios cujo o cargo � igual a 'IT_PROG'.
SET SERVEROUTPUT ON
DECLARE 
    vJob_id     employees.job_id%type := 'IT_PROG';
    vAvg_salary employees.salary%type;
    vSum_salary employees.salary%type;
BEGIN
    SELECT ROUND(AVG(salary),2), ROUND(SUM(salary),2)
    INTO vAvg_salary, vSum_salary
    FROM employees
    WHERE job_id = vJob_id;
    DBMS_OUTPUT.PUT_LINE('Cargo: ' || vJob_id);
    DBMS_OUTPUT.PUT_LINE('M�dia de Sal�rios: ' || vAvg_salary);
    DBMS_OUTPUT.PUT_LINE('Somat�ria de Sal�rios: ' || vSum_salary);
END;


--Utilizando comando INSERT no PL/SQL
SET SERVEROUTPUT ON
DECLARE
    vFast_name employees.first_name%type;
    vLast_name employees.last_name%type;
    vSalary    employees.salary%type;
BEGIN
    INSERT INTO employees
        (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
    VALUES
        (employees_seq.nextval, 'Kobe', 'Bryant', 'KBRYANT', '515.123.45568', SYSDATE,'IT_PROG', 15000, 0.4, 103, 60);
    COMMIT;
END;

--Utilizando UPDATE no PL/SQL
SET SERVEROUTPUT ON
DECLARE
    vEmployee_id employees.employee_id%type := 150;
    vPercentual  NUMBER(3) := 10;
BEGIN
    UPDATE employees
    SET    salary = salary * (1 + vPercentual / 100)
    WHERE  employee_id = vEmployee_id;
    COMMIT;
END;

SELECT * FROM employees WHERE employee_id = 150;

--Utilizando DELETE no PL/SQL
SET SERVEROUTPUT ON
DECLARE
    vEmployee_id employees.employee_id%type := 207;
BEGIN
    DELETE FROM employees
    WHERE employee_id = vEmployee_id;
    COMMIT;
END;
    
SELECT * FROM employees WHERE employee_id = 207;    


-- Transa��es de Banco de Dados
/*
Consisten em :
- Um conjunto de comandos DML
- Um comando DLL
- Um comando DCL

Uma Transa��o inicia em um dos seguintes eventos:
- Voc� se conecta e um comando SQL DML � excutado.
- Ap�s um comando COMMIT, um comando SQL DML � executado.
- Ap�s um comando ROLLBACK, um comando SQL DML � executado.

Uma Transa��o termina em um dos seguintes eventos:
- Um comando COMMIT.
- Um comando ROLLBACK.
- Um comando DDL ou DCL, (executa um commit autom�tico).
- O usu�rio encerra a sess�o (desconecta), no SLQ Developer, SQL*Plus e etc...
- Crash do sistema (Sistema operacional, rede, banco de dados, etc...).

COMMIT encerra a transa��o corrente tornando todas as mudan�as pendentes permanentes.
Unica forma de voltar � fazendo Backoup do BD ou recurso de FlashBack.

ROLLBACK encerra a transa��o corrente, desfazendo todas as mudan�as(INSERT, UPDATE, DELETE, etc...).

SAVEPOINT � uma marca um ponto de controle na sua transa��o.
Sintaxe: SAVEPOINT nomesavepoint;

ROLLBACK TO SAVEPOINT nomesavepoint, descarta todas as mudan�as realizadas apartir do SAVEPOINT.
(n�o � muito recomendado)
*/
SAVEPOINT UPDATEOK; -- O ROLLBACK vai contar apartir daqui
    UPDATE employees
    SET    salary = 5000
    WHERE  job_id = 'IT_PROG';

ROLLBACK TO UPDATEOK; -- Esse cara vai dedscartar tudo o que foi feito apartir do SAVEPOINT


--- tributos do CURSOR SQL ---
/*
- SQL%ROWCOUNT  N�mero de linhas afetados pelo cursor, ou seja pelo ultimo comando SQL.
- SQL%FOUND     Retorna true se o cursor afetou uma ou mais linhas.
- SQL%NOTFOUND  Retorna true se o cursor n�o afetou nenhuma linha
- SQL%ISOPEN    Retorna false, porque o Oracle controla o cursor implicito autom�ticamente, fechando o cursor.
*/


---------------------------------------------------------------------------------------------------------------------------
--- Atributos de Controle ---

--Utilizando par�nteses para alterar a sobrepor a regra de proced�ncia
/*
- Tudo que estiver entre parenteses ser� resolvido primeiro.
- Se voc� aninhar par�nteses eles ser�o resolvidos de dentro para fora.
*/

--ex:
SET SERVEROUTPUT ON
DECLARE
    vNota1 NUMBER(11,2) := 7.0;
    vNota2 NUMBER(11,2) := 6.0;
    vNota3 NUMBER(11,2) := 9.0;
    vNota4 NUMBER(11,2) := 6.0;
    vMedia NUMBER(11,2);
BEGIN
    vMedia := (vNota1 + vNota2 + vNota3 + vNota4) / 4;
    DBMS_OUTPUT.PUT_LINE('M�dia: ' || vMedia);
END;


--- Utilizando comando IF (aninhado)---
SET SERVEROUTPUT ON 
    ACCEPT pDepartment_id PROMP 'Digite o id do departamento: ' --ACCEPT vai definir uma v�riavel, PROMPT vai ixibir a frase e esperar voc� digitar.
DECLARE
    vPercentual     NUMBER(3);
    vDepartment_id employees.employee_id%type := &pDepartment_id; --Utilizar & para referenciar a veriavel pDepartment_id.
BEGIN
    IF vDepartment_id = 80
    THEN 
        vPercentual := 10; --Sales
    ELSE
        IF vDepartment_id = 20
        THEN
            vPercentual := 15; --Marketing
        ELSE
            IF vDepartment_id = 60
            THEN
                vPercentual := 20; --IT
            ELSE
                vPercentual := 5;
            END IF;
        END IF;
    END IF;
    DBMS_OUTPUT.PUT_LINE('vDepartment_id: ' || vDepartment_id);
    DBMS_OUTPUT.PUT_LINE('vPercentual : ' || vPercentual);
    
    UPDATE employees
    SET    salary = salary * (1 + vPercentual / 100)
    WHERE  department_id = vDepartment_id;   
    COMMIT;
    
END;

-- Comando IF com ELSIF
SET SERVEROUTPUT ON
    ACCEPT pDepartment_id PROMP 'Digite o id do departamento: '
DECLARE
    vDepartment_id employees.employee_id%type := &pDepartment_id;
    vPercentual NUMBER(3);
BEGIN
    IF vDepartment_id = 80
    THEN
        vPercentual := 10; --Sales
    ELSIF vDepartment_id = 20
    THEN
        vPercentual := 15; --Marketing
    ELSIF vDepartment_id = 60
    THEN
        vPercentual := 20; --TI
    ELSE
        vPercentual := 5;
    END if;
    
    DBMS_OUTPUT.PUT_LINE('Id do Departamento: ' || vDepartment_id);   
    DBMS_OUTPUT.PUT_LINE('percentual: ' || vPercentual );  

    UPDATE employees 
    SET    salary = salary * (1 + vPercentual / 100)
    WHERE department_id =  vDepartment_id;
    --COMMIT;
END;


--- Utilizando o comando CASE ---
--Modelo 1
SET SERVEROUTPUT ON
    ACCEPT pDepartment_id PROMPT 'Digite o id do departemento:'
DECLARE
    vPercentual NUMBER(3);
    vDepartment_id employees.employee_id%type := &pDepartment_id;
BEGIN
    CASE
    WHEN vDepartment_id = 80
    THEN
        vPercentual := 10; --Sales
    WHEN vDepartment_id = 20
    THEN
        vPercentual := 15; --Marketing
    WHEN vDepartment_id = 60
    THEN 
        vPercentual := 20;
    ELSE
        vPercentual := 5;
    END CASE;
    
    DBMS_OUTPUT.PUT_LINE('Id do departamento: ' || vDepartment_id);
    DBMS_OUTPUT.PUT_LINE('Percentual: ' || vPercentual);
    
    UPDATE employees
    SET salary = salary * (1 + vPercentual / 100)
    WHERE department_id = &PDepartment_id;
    --COMMIT;
END;   

--Modelo 2
SET SERVEROUTPUT ON
    ACCEPT pDepartment_id PROMPT 'Digite o id do departamento:'
DECLARE
    vPercentual    NUMBER(3);
    vDepartment_id employees.employee_id%type := &pDepartment_id;
BEGIN
    CASE vDepartment_id
    WHEN 80
    THEN 
        vPercentual := 10; --Sales
    WHEN 20
    THEN
        vPercentual := 15; --Marketing
    WHEN 60
    THEN 
        vPercentual := 20; --IT
    ELSE 
        vPercentual := 5;
    END CASE;
    
    DBMS_OUTPUT.PUT_LINE('Id do departamento: ' || vDepartment_id);
    DBMS_OUTPUT.PUT_LINE('Percentual: ' || vPercentual);
    
    UPDATE employees
    SET    salary = salary * (1 + vPercentual / 100)
    WHERE  department_id = &pDepartment_id;
    --COMMIT;
END;


--- Utilizando LOOP B�sico ---
SET SERVEROUTPUT ON
    ACCEPT pLimite PROMPT 'Digite o valor do limite: '
DECLARE
    vNumero NUMBER(38) := 1;
    vLimite NUMBER(38) := &pLimite;
BEGIN
    --Imprimindo n�meros de 1 at� o Limite
    LOOP 
        DBMS_OUTPUT.PUT_LINE('N�mero: ' || TO_CHAR(vNumero));
        EXIT WHEN vNumero = vLimite;
        vNumero := vNumero + 1;
    END LOOP;
END;





