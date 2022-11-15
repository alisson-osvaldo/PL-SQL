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












