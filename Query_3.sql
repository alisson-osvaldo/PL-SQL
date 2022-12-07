--Gerenciando Depend�ncias de Objetos
/*
 -Sempre que um objeto do BD for alterado os objetos dependentes diretamente dele seram invalidados
  "Status Invalid" quando um programa fazer uma chamada a uma fun��o ou Procedure invalid o Oracle altom�ticamente 
  tentar� recompilar o objeto.
  
-Dependencia dir�ta: Um procedimento ou fun��o depende diretamente de um objeto se ele referencia um objeto intermediario 
 que referencia outros objetos, causando uma cadeia de dependencias em rela��o ao objeto.
 
 -Dependencia Local: � uma depend�ncia entre objetos que est�o no mesmo BD.
 
  -Depend�ncia Remota: � quando um objeto referencia outro objeto em que est� em outro BD atrav�z de um Database Link.
  
*/


-- Consultando Dependencias Diretas dos objetos do seu schema utilizando a visão USER_DEPENDENCIES 
DESC user_dependencies

--Aqui vamos consultar todod que tem dependencias diretas com a tabela EMPLOYEES do tipo TABLE:
SELECT *
FROM   user_dependencies
WHERE  referenced_name = 'EMPLOYEES' AND
       referenced_type = 'TABLE';
       
--Lendo toda a Hierarquia de refer�ncias(vai mostrar o mesmo que a pesquisa a cima pq n�o temos d�pend~encias indiretas):
SELECT      *
FROM        user_dependencies
START WITH  referenced_name = 'EMPLOYEES' AND
            referenced_type = 'TABLE'
CONNECT BY PRIOR  name = referenced_name AND
                  type = referenced_type;
                        

-- Conecte-se como SYS (para fazer essa consulta DBA precisa te dar esses previl�gios)
DESC DBA_DEPENDENCIES

SELECT      *
FROM        dba_dependencies
START WITH  referenced_owner = 'HR' AND
            referenced_name = 'EMPLOYEES' AND
            referenced_type = 'TABLE'
CONNECT BY PRIOR  owner = referenced_owner AND
                  name =  referenced_name   AND
                  type =  referenced_type;
                  
-- Consultando objetos Inv�lidos do schema do seu usu�rio 
DESC USER_OBJECTS

SELECT object_name, object_type, last_ddl_time, timestamp, status
FROM   user_objects
WHERE  status = 'INVALID';

---------------------------------------------------------------------------------------------------------------------------
--- DEPTREE e IDEPTREE ---
/*
- Outra forma de consultar dependencias diretas e indiretas de um objeto � utilizando DEPTREE e IDEPTREE.
- Crie as vis�es DEPTREE e IDEPTREE executando o script "utldtree.sql" fornecido pelo BD Oracle
vo�e pode encontrar o script no diret�rio: ORACLE_HOME/rdbms/admin
-Execute o script conectado com o usu�rio owner do objeto para o qual voc� deseja analisar as depend�ncias.
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

-- Utilizando as Vis�es DEPTREE

DESC deptree

SELECT   *
FROM     deptree
ORDER by seq#


-- Utilizando as Vis�es IDEPTREE

desc ideptree

SELECT *
FROM ideptree;
---------------------------------------------------------------------------------------------------------------------------
--- Debuger PROCEDURES e FUNCTIONS ---
-- Requisitos necess�rios para executar o PL/SqL Debuger
/*
- Efetuar o grant dos privil�gios DEBUG CONNECT SESSION e DEBUG ANY PROCEDURE para o usu�rio.
- O usu�rio deve ser owner ou possuir privil�gio de EXECUTE da procedure ou function q que deseja debugar.
- A PROCEDURE ou FUNCTION de ser compliada para debug (Compiled for Degug).
*/

-- Tente debugar novamente, ocorrerá o seguinte erro
/*
Conectando ao banco de dados hr_XEPDB1.
Executando PL/SQL: CALL DBMS_DEBUG_JDWP.CONNECT_TCP( '127.0.0.1', '52100' )
ORA-24247: acesso à rede negado pela ACL (access control list)
ORA-06512: em "SYS.DBMS_DEBUG_JDWP", line 68
ORA-06512: em line 1
Processo encerrado.
Desconectando do banco de dados hr_XEPDB1.
*/
    
-- Conectado como SYS
grant DEBUG CONNECT SESSION, DEBUG ANY PROCEDURE to hr;

/*
 Para n�o ocorrer esse ERRO:
 - ORA-24247: acesso à rede negado pela ACL (access control list)
 Executar como usuario Sys: 
 */
BEGIN
 DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE
 (
 host => '127.0.0.1',    --Meu ip:10.0.0.241                                          <- Ip da m�quina, nosso caso localhost 
 lower_port => null,
 upper_port => null,
 ace => xs$ace_type(privilege_list => xs$name_list('jdwp'),
 principal_name => 'hr',                                          --<- aqui vai o nome do usu�rio Oracle em q est� executando 
 principal_type => xs_acl.ptype_db)
 );
END;

-- Debugar
-- Vai na function -> bot�o direito -> editar -> engrenagem -> Compilar para depura��o
-- Em seguida clica no bot�o de debug.

---------------------------------------------------------------------------------------------------------------------------

-- Packages

/*
Componentes de uma package:
- Vari�vel
- Constante
- Cursor
- Exce��es
- Procedures
- Fun��es

* Componentes Publicas de uma Package:
- Componentes (ou constru��es) publicos de uma package s�o aqueles qdue podem ser referenciados por externamente a package.
- Devem ser dedclarados no Package Specification e definidos no Package Body.

* Componentes Privados de uma Package:
- Componentes privados de uma package s�o aqueles que podem ser referenciados somente por componentes da pr�pria package.
- Devem ser declarados e definidos no Package Body.
*/


--Criando o package specification
/*
    CREATE [OR REPLACE] PACKAGE nome_package IS|AS
        -- Declara��o de vari�veis p�blicas
        -- Declara��o de constantes p�blicas
        -- Declara��o de cursores p�blicas
        -- Declara��o de exce��es p�blicas
        -- Declara��o de procedures p�blicas
        -- Declara��o de fun��es p�blicas
    END [nome_package];
*/

--Vari�vel Global
/*
 - Quando vc declara uma vari�vel no package specification, vc est� declarando uma vari�vel global.
 - Uma vari�vel global tera valor durante toda a sess�o do Oracle, a sess�o come�a quando se conecta no BD Oracle e 
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




