--- PL/SQL ---

-- INSERT em uma tabela
DECLARE
    v_ID NUMBER(5) := 1;
    v_DESCRICAO VARCHAR2(100) := 'Varejo';
BEGIN
    INSERT INTO segmercado (ID, DESCRICAO) VALUES (v_ID, v_DESCRICAO);
    COMMIT;
END;

/* Exerc�cio:

 -COD: 41232
 -DESCRICAO: Sabor de Ver�o - Laranja - 1 Litro
 -CATEGORIA: Sucos de Frutas
Fa�a um programa em PL/SQL que inicialize 3 vari�veis que recebam os valores acima 
e os incluam na tabela PRODUTO_EXERCICIO. N�o esque�a de executar o comando.
*/
DECLARE
    v_COD VARCHAR(5) := 41233;
    v_CATEGORIA VARCHAR2(100) := 'Salada de Frutas'; 
    v_DESCRICAO VARCHAR2(100) := 'Sabor de Ver�o - Laranja - 1 Litro';
BEGIN
    INSERT INTO produto_exercicio (cod, descricao, categoria) VALUES (v_COD, v_CATEGORIA, v_DESCRICAO);
    COMMIT;
END;

select * from produto_exercicio;

--- Fun��es ----------------------------------------------------------------------------

/*
EXERC�CIO

O usu�rio usa sempre o h�fen (-) para separar o nome do produto, o sabor e a embalagem. Note um exemplo abaixo:

DECLARE
   v_COD produto_exercicio.cod%type := '32223';
   v_DESCRICAO produto_exercicio.descricao%type := 'Sabor de Ver�o - Uva - 1 Litro';
   v_CATEGORIA produto_exercicio.categoria%type := 'Sucos de Frutas';
BEGIN
   INSERT INTO PRODUTO_EXERCICIO (COD, DESCRICAO, CATEGORIA) VALUES (v_COD, v_DESCRICAO, v_CATEGORIA);
   COMMIT;
END;

DESCRICAO: Sabor de Ver�o - Uva - 1 Litro
Mas queremos que o produto seja salvo com o s�mbolo "maior que" (>) no lugar do h�fen.

Para isso, modifique o script PL/SQL abaixo para que, caso o usu�rio inclua o h�fen como separador dos nomes e classifica��es do produto,
ele seja substitu�do pelo "maior que" (>):

*/

DECLARE
   v_COD produto_exercicio.cod%type := '32224';
   v_DESCRICAO produto_exercicio.descricao%type := 'Sabor de Ver�o - Uva - 1 Litro';
   v_CATEGORIA produto_exercicio.categoria%type := 'Sucos de Frutas';
BEGIN
   INSERT INTO PRODUTO_EXERCICIO (COD, DESCRICAO, CATEGORIA) VALUES (v_COD, REPLACE(v_DESCRICAO, ' - ', ' > '), v_CATEGORIA);
   COMMIT;
END;

select * from PRODUTO_EXERCICIO;


--- V�rios comandos em bloco ---------------------------------------------------------------

DECLARE 
    v_ID segmercado.ID%type := 3;
    v_DESCRICAO segmercado.descricao%type := 'Atacadista';
BEGIN
    UPDATE segmercado SET descricao = UPPER(v_DESCRICAO) WHERE ID = v_ID;
    
    v_ID := 1;
    v_DESCRICAO := 'Varejista';
    UPDATE segmercado SET DESCRICAO = UPPER(v_DESCRICAO) WHERE ID = v_ID;
   
    v_ID := 2;
    v_DESCRICAO := 'Industrial';
    UPDATE segmercado SET DESCRICAO = UPPER(v_DESCRICAO) WHERE ID = v_ID;

    COMMIT;
END;
    
select * from segmercado;


--- PROCEDURE -----------------------------------------------------------------------------
-- Criando uma procedure para inserir na tabela SEGMERCADO
-- Obs. CREATE OR REPLACE = caso a procedure j� exista s� ir� alterar e n�o vai criar outra.

CREATE OR REPLACE PROCEDURE incluir_segmercado
(p_ID IN NUMBER, p_DESCRICAO IN VARCHAR2)
IS
BEGIN
    INSERT INTO SEGMERCADO (ID, DESCRICAO) VALUES (p_ID, UPPER(p_DESCRICAO));
    COMMIT;
END;

--Executando a procedure
EXECUTE incluir_segmercado(4, 'Farmaceuticos');

--Executando apenas pelo nome, obs. tem que utilizar begin
BEGIN
    incluir_segmercado(5, 'Teste');
END;


-- EXCLUIR PROCEDURE
DROP PROCEDURE incluir_segmercado2;


-- Retornando o descritor do segmento de mercado
SET SERVEROUTPUT ON;
DECLARE
    v_ID SEGMERCADO.ID%type := 3;
    v_DESCRICAO SEGMERCADO.DESCRICAO%type;
BEGIN
    SELECT DESCRICAO INTO v_DESCRICAO FROM SEGMERCADO WHERE ID = v_ID;
    dbms_output.put_line(v_DESCRICAO);
END;


-- Incluir cliente na tabela de clientes
CREATE OR REPLACE PROCEDURE incluir_cliente
(
p_ID CLIENTE.ID%type,
p_RAZAO CLIENTE.RAZAO_SOCIAL%type,
p_CNPJ CLIENTE.CNPJ%type,
p_SEGMERCADO CLIENTE.SEGMERCADO_ID%type,
p_FATURAMENTO CLIENTE.FATURAMENTO_PREVISTO%type,
p_CATEGORIA CLIENTE.CATEGORIA%type
)
IS
BEGIN
    INSERT INTO CLIENTE
    VALUES
    (p_ID, p_RAZAO, p_CNPJ, p_SEGMERCADO, SYSDATE, p_FATURAMENTO, p_CATEGORIA);
    COMMIT;
END;

--Chamando a procedure incluir_cliente:
EXECUTE incluir_cliente (1, 'SUPERMERCADOS CAMPEAO', '1234567890', 1, 90000, 'MEDIO GRANDE');

select * from cliente;



-- Obter Categoria
SET SERVEROUTPUT ON
DECLARE
    v_FATURAMENTO CLIENTE.FATURAMENTO_PREVISTO%type := 65000;
    v_CATEGORIA CLIENTE.CATEGORIA%type;
BEGIN
    IF v_FATURAMENTO <= 10000 THEN
        v_CATEGORIA := 'PEQUENO';
    ELSIF v_FATURAMENTO <= 50000 THEN
        v_CATEGORIA := 'M�DIO';
    ELSIF v_FATURAMENTO <= 100000 THEN
        v_CATEGORIA := 'M�DIO GRANDE';
    ELSE
        v_CATEGORIA := 'GRANDE';
    END IF;
    dbms_output.put_line('A Categoria � ' || v_CATEGORIA);
END;












--- FUN��O ----------------------------------------------------------------------------
-- Criando uma fun��o:
CREATE OR REPLACE FUNCTION obter_descricao_segmercado
(p_ID IN SEGMERCADO.ID%type)
RETURN SEGMERCADO.DESCRICAO%type
IS
    v_DESCRICAO SEGMERCADO.DESCRICAO%type;
BEGIN
    SELECT DESCRICAO INTO v_DESCRICAO FROM SEGMERCADO WHERE ID = p_ID;
    RETURN v_DESCRICAO;
END;

--Executando a fun��o:
SELECT ID, obter_descricao_segmercado(ID), DESCRICAO, LOWER(DESCRICAO) FROM SEGMERCADO WHERE ID = 1;
SELECT ID, obter_descricao_segmercado(ID), DESCRICAO, LOWER(DESCRICAO) FROM SEGMERCADO;
select obter_descricao_segmercado(2) from dual;

--Executando fora de um comando PLSQL
VARIABLE g_DESCRICAO VARCHAR2(100);
EXECUTE :g_DESCRICAO:=obter_descricao_segmercado(3);
PRINT g_DESCRICAO;

--Executando dentro do PLSQL
SET SERVEROUTPUT ON;
DECLARE
    v_DESCRICAO SEGMERCADO.DESCRICAO%type;
    v_ID SEGMERCADO.ID%type := 1;
BEGIN
    v_DESCRICAO := obter_descricao_segmercado(v_ID);
    dbms_output.put_line('A descri��o do segmento de mercado � ' || v_DESCRICAO);
END;


-- Criando Fun��o para verificar qual a categoria do cliente:
CREATE OR REPLACE FUNCTION categoria_cliente
(p_FATURAMENTO IN CLIENTE.FATURAMENTO_PREVISTO%type) 
RETURN CLIENTE.CATEGORIA%type
IS
    v_CATEGORIA CLIENTE.CATEGORIA%type;
BEGIN
    IF p_FATURAMENTO <= 10000 THEN
        v_CATEGORIA := 'PEQUENO';
    ELSIF p_FATURAMENTO <= 50000 THEN
        v_CATEGORIA := 'M�DIO';
    ELSIF p_FATURAMENTO <= 100000 THEN
        v_CATEGORIA := 'M�DIO GRANDE';
    ELSE
        v_CATEGORIA := 'GRANDE';
    END IF;
    RETURN v_CATEGORIA;
END;


-- Criando procedure para incluir cliente:
CREATE OR REPLACE PROCEDURE incluir_cliente
(
p_ID CLIENTE.ID%type,
p_RAZAO CLIENTE.RAZAO_SOCIAL%type,
p_CNPJ CLIENTE.CNPJ%type,
p_SEGMERCADO CLIENTE.SEGMERCADO_ID%type,
p_FATURAMENTO CLIENTE.FATURAMENTO_PREVISTO%type
)
IS
    v_CATEGORIA CLIENTE.CATEGORIA%type;
BEGIN

    v_CATEGORIA := categoria_cliente(p_FATURAMENTO);

    INSERT INTO CLIENTE
    VALUES
    (p_ID, p_RAZAO, p_CNPJ, p_SEGMERCADO, SYSDATE, p_FATURAMENTO, v_CATEGORIA);
    COMMIT;
END;


--Executando a procedure incluir_cliente:
EXECUTE incluir_cliente(3, 'SUPERMERCADO CARIOCA', '2222222222', 1, 30000);
select * from cliente;












