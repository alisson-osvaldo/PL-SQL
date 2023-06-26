--Gerenciando Dependências de Objetos
/*
 -Sempre que um objeto do BD for alterado os objetos dependentes diretamente dele seram invalidados
  "Status Invalid" quando um programa fazer uma chamada a uma função ou Procedure invalid o Oracle altomáticamente 
  tentará recompilar o objeto.
  
-Dependencia diréta: Um procedimento ou função depende diretamente de um objeto se ele referencia um objeto intermediario 
 que referencia outros objetos, causando uma cadeia de dependencias em relação ao objeto.
 
 -Dependencia Local: É uma dependência entre objetos que estão no mesmo BD.
 
  -Dependência Remota: É quando um objeto referencia outro objeto em que está em outro BD atravéz de um Database Link.
  
*/


-- Consultando Dependencias Diretas dos objetos do seu schema utilizando a visÃ£o USER_DEPENDENCIES 
DESC user_dependencies

--Aqui vamos consultar todod que tem dependencias diretas com a tabela EMPLOYEES do tipo TABLE:
SELECT *
FROM   user_dependencies
WHERE  referenced_name = 'EMPLOYEES' AND
       referenced_type = 'TABLE';
       
--Lendo toda a Hierarquia de referências(vai mostrar o mesmo que a pesquisa a cima pq não temos d´pend~encias indiretas):
SELECT      *
FROM        user_dependencies
START WITH  referenced_name = 'EMPLOYEES' AND
            referenced_type = 'TABLE'
CONNECT BY PRIOR  name = referenced_name AND
                  type = referenced_type;
                        

-- Conecte-se como SYS (para fazer essa consulta DBA precisa te dar esses previlágios)
DESC DBA_DEPENDENCIES

SELECT      *
FROM        dba_dependencies
START WITH  referenced_owner = 'HR' AND
            referenced_name = 'EMPLOYEES' AND
            referenced_type = 'TABLE'
CONNECT BY PRIOR  owner = referenced_owner AND
                  name =  referenced_name   AND
                  type =  referenced_type;
                  
-- Consultando objetos Inválidos do schema do seu usuário 
DESC USER_OBJECTS

SELECT object_name, object_type, last_ddl_time, timestamp, status
FROM   user_objects
WHERE  status = 'INVALID';

---------------------------------------------------------------------------------------------------------------------------
--- DEPTREE e IDEPTREE ---
/*
- Outra forma de consultar dependencias diretas e indiretas de um objeto é utilizando DEPTREE e IDEPTREE.
- Crie as visões DEPTREE e IDEPTREE executando o script "utldtree.sql" fornecido pelo BD Oracle
voçe pode encontrar o script no diretório: ORACLE_HOME/rdbms/admin
-Execute o script conectado com o usuário owner do objeto para o qual você deseja analisar as dependências.
*/

-- Executando a procedure DEPTREE
-- Exec DEPTREE_FILL('tipo_de_objeto', 'owner', 'nome_objeto')


-- Consultando o resuktado da analise DEPTREE ou IDEPTREE:
/*
SELECT * FROM deptree ORDER BY seq#;
SELECT * FROM idepTREE
*/

--Executando script UTLDTREE: basta dar f9:
@C:\OracleDatabase21cXE\dbhomeXE\rdbms\admin\utldtree.sql

-- Executando a procedure DEPTREE_FILL
exec DEPTREE_FILL('TABLE','HR','EMPLOYEES')

-- Utilizando as Visões DEPTREE

DESC deptree

SELECT   *
FROM     deptree
ORDER by seq#


-- Utilizando as Visões IDEPTREE

desc ideptree

SELECT *
FROM ideptree;
---------------------------------------------------------------------------------------------------------------------------
--- Debuger PROCEDURES e FUNCTIONS ---
-- Requisitos necessários para executar o PL/SqL Debuger
/*
- Efetuar o grant dos privilégios DEBUG CONNECT SESSION e DEBUG ANY PROCEDURE para o usuário.
- O usuário deve ser owner ou possuir privilégio de EXECUTE da procedure ou function q que deseja debugar.
- A PROCEDURE ou FUNCTION de ser compliada para debug (Compiled for Degug).
*/

-- Tente debugar novamente, ocorrerÃ¡ o seguinte erro
/*
Conectando ao banco de dados hr_XEPDB1.
Executando PL/SQL: CALL DBMS_DEBUG_JDWP.CONNECT_TCP( '127.0.0.1', '52100' )
ORA-24247: acesso Ã  rede negado pela ACL (access control list)
ORA-06512: em "SYS.DBMS_DEBUG_JDWP", line 68
ORA-06512: em line 1
Processo encerrado.
Desconectando do banco de dados hr_XEPDB1.
*/
    
-- Conectado como SYS
grant DEBUG CONNECT SESSION, DEBUG ANY PROCEDURE to hr;

/*
 Para não ocorrer esse ERRO:
 - ORA-24247: acesso Ã  rede negado pela ACL (access control list)
 Executar como usuario Sys: 
 */
BEGIN
 DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE
 (
 host => '127.0.0.1',    --Meu ip:10.0.0.241                                          <- Ip da máquina, nosso caso localhost 
 lower_port => null,
 upper_port => null,
 ace => xs$ace_type(privilege_list => xs$name_list('jdwp'),
 principal_name => 'hr',                                          --<- aqui vai o nome do usuário Oracle em q está executando 
 principal_type => xs_acl.ptype_db)
 );
END;

-- Debugar
-- Vai na function -> botão direito -> editar -> engrenagem -> Compilar para depuração
-- Em seguida clica no botão de debug.

---------------------------------------------------------------------------------------------------------------------------

-- Packages

/*
Componentes de uma package:
- Variável
- Constante
- Cursor
- Exceções
- Procedures
- Funções

* Componentes Publicas de uma Package:
- Componentes (ou construções) publicos de uma package são aqueles qdue podem ser referenciados por externamente a package.
- Devem ser dedclarados no Package Specification e definidos no Package Body.

* Componentes Privados de uma Package:
- Componentes privados de uma package são aqueles que podem ser referenciados somente por componentes da própria package.
- Devem ser declarados e definidos no Package Body.
*/


--Criando o package specification
/*
    CREATE [OR REPLACE] PACKAGE nome_package IS|AS
        -- Declaração de variáveis públicas
        -- Declaração de constantes públicas
        -- Declaração de cursores públicas
        -- Declaração de exceções públicas
        -- Declaração de procedures públicas
        -- Declaração de funções públicas
    END [nome_package];
*/

--Variável Global
/*
 - Quando vc declara uma variável no package specification, vc está declarando uma variável global.
 - Uma variável global tera valor durante toda a sessão do Oracle, a sessão começa quando se conecta no BD Oracle e 
   encerra quando se desconecta.
*/

-- Criando o Package Specification 
create or replace PACKAGE PCK_EMPREGADOS
IS

	gMinSalary     employees.salary%TYPE;
    
    --Incluindo procedure insere_empregado
	PROCEDURE PRC_INSERE_EMPREGADO
	(pfirst_name    IN VARCHAR2,
	plast_name     IN VARCHAR2,
	pemail         IN VARCHAR2,
	pphone_number  IN VARCHAR2,
	phire_date     IN DATE DEFAULT SYSDATE,
	pjob_id        IN VARCHAR2,
	pSALARY        IN NUMBER,
	pCOMMICION_PCT IN NUMBER,
	pMANAGER_ID    IN NUMBER,
	pDEPARTMENT_ID IN NUMBER);
    
    --Incluindo procedure aumenta_salario_empregado
	PROCEDURE PRC_AUMENTA_SALARIO_EMPREGADO
	(pemployee_id   IN NUMBER,
	ppercentual    IN NUMBER);

    --Incluindo function consulta salario empregado
	FUNCTION FNC_CONSULTA_SALARIO_EMPREGADO
	(pemployee_id   IN NUMBER)
	RETURN NUMBER;

END PCK_EMPREGADOS;




-- Criando o package Body
/*
-Para criar o package body vc precisa ter compilado o package specification OK.
- ultilizar o mesmo nome do package specification.
*/

/*
CREATE [OR REPLACE] PACKAGE BODY nome_package
IS | AS 
    -- declaração de variáveis (sera privada)
    -- declaração de constantes(sera privada)
    -- declaração de cursores  (sera privada)
    -- declaração de exceções  (sera privada)
    -- declaração de procedures(sera privada)
    -- declaração de funções   (sera privada)
    -- corpo de procedures  (colocar o corpo de todas as procedures, tanto das publicas como das privadas)    
    -- corpo de funções (colocar o corpo de todas as funções, tanto das publicas como das privadas)
END[nome_package];
    
*/

-- Criando o Package Body
create or replace PACKAGE BODY PCK_EMPREGADOS
IS
	PROCEDURE PRC_INSERE_EMPREGADO
	  (pfirst_name    IN VARCHAR2,
	   plast_name     IN VARCHAR2,
	   pemail         IN VARCHAR2,
	   pphone_number  IN VARCHAR2,
	   phire_date     IN DATE DEFAULT SYSDATE,
	   pjob_id        IN VARCHAR2,
	   pSALARY        IN NUMBER,
	   pCOMMICION_PCT IN NUMBER,
	   pMANAGER_ID    IN NUMBER,
	   pDEPARTMENT_ID IN NUMBER)
	IS 
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
		employees_seq.nextval,
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

	PROCEDURE PRC_AUMENTA_SALARIO_EMPREGADO
	  (pemployee_id   IN NUMBER,
	   ppercentual    IN NUMBER)
	IS
	  -- Nenhuma vÃ¡riÃ¡vel declarada
	BEGIN
	  UPDATE employees 
	  SET salary = salary * (1 + ppercentual / 100)
	  WHERE employee_id = pemployee_id;

	EXCEPTION
	  WHEN OTHERS 
	  THEN
		 RAISE_APPLICATION_ERROR(-20001, 'Erro Oracle: ' || SQLCODE || ' - ' || SQLERRM);
	END;

	FUNCTION FNC_CONSULTA_SALARIO_EMPREGADO
	  (pemployee_id   IN NUMBER)
	   RETURN NUMBER
	IS 
	  vsalary  employees.salary%TYPE;
	BEGIN
	  SELECT salary
	  INTO   vsalary
	  FROM   employees
	  WHERE employee_id = pemployee_id;
	  RETURN (vsalary);
	EXCEPTION
	  WHEN NO_DATA_FOUND THEN 
		  RAISE_APPLICATION_ERROR(-20001, 'Empregado inexistente');
	  WHEN OTHERS THEN
		 RAISE_APPLICATION_ERROR(-20002, 'Erro Oracle ' || SQLCODE || SQLERRM);
	END;

END PCK_EMPREGADOS;



--Referenciando componentes de uma package
/*
 -Referencie um componente de uma package a partir de um componente da própria package ou
  construções externas a ela.
 - Somente os componentes (construções) públicos de uma package podem ser referenciados
 por construções externas a package.
 
 Sintaxe:
    nome_package.nome_componente
*/

-- Referenciando Componentes de uma Package 

BEGIN
  PCK_EMPREGADOS.PRC_INSERE_EMPREGADO('Bob', 'Dylan','BDYLAN','515.258.4861',SYSDATE,'IT_PROG',20000,NULL,103,60);
  COMMIT;
END;

BEGIN
  PCK_EMPREGADOS.PRC_INSERE_EMPREGADO('John', 'Lenon','JLENON','515.244.4861',SYSDATE,'IT_PROG',15000,NULL,103,60);
  COMMIT;
END;



---Procedimento de uma unica execução na Sessão
/*
 - Defina um bloco (procedimento) para ser executado uma única vez na sessão, somente na primeira vez que um componente
   da package for referênciado na sessão do banco de dados.
 - Este procedimento pode ser utilizado para inicialização a niível de sessão.
*/



---------------------------------------------------------------------------------------------------------------------------







































