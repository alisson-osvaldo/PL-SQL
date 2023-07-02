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
--Criando uma procedure para inserir na tabela SEGMERCADO
CREATE PROCEDURE incluir_segmercado
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

---





























