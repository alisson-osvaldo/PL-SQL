--- PL/SQL ---

-- INSERT em uma tabela
DECLARE
    v_ID NUMBER(5) := 1;
    v_DESCRICAO VARCHAR2(100) := 'Varejo';
BEGIN
    INSERT INTO segmercado (ID, DESCRICAO) VALUES (v_ID, v_DESCRICAO);
    COMMIT;
END;

/* Exercício:

 -COD: 41232
 -DESCRICAO: Sabor de Verão - Laranja - 1 Litro
 -CATEGORIA: Sucos de Frutas
Faça um programa em PL/SQL que inicialize 3 variáveis que recebam os valores acima 
e os incluam na tabela PRODUTO_EXERCICIO. Não esqueça de executar o comando.
*/
DECLARE
    v_COD VARCHAR(5) := 41233;
    v_CATEGORIA VARCHAR2(100) := 'Salada de Frutas'; 
    v_DESCRICAO VARCHAR2(100) := 'Sabor de Verão - Laranja - 1 Litro';
BEGIN
    INSERT INTO produto_exercicio (cod, descricao, categoria) VALUES (v_COD, v_CATEGORIA, v_DESCRICAO);
    COMMIT;
END;

select * from produto_exercicio;

--- Funções ----------------------------------------------------------------------------

/*
EXERCÍCIO

O usuário usa sempre o hífen (-) para separar o nome do produto, o sabor e a embalagem. Note um exemplo abaixo:

DECLARE
   v_COD produto_exercicio.cod%type := '32223';
   v_DESCRICAO produto_exercicio.descricao%type := 'Sabor de Verão - Uva - 1 Litro';
   v_CATEGORIA produto_exercicio.categoria%type := 'Sucos de Frutas';
BEGIN
   INSERT INTO PRODUTO_EXERCICIO (COD, DESCRICAO, CATEGORIA) VALUES (v_COD, v_DESCRICAO, v_CATEGORIA);
   COMMIT;
END;

DESCRICAO: Sabor de Verão - Uva - 1 Litro
Mas queremos que o produto seja salvo com o símbolo "maior que" (>) no lugar do hífen.

Para isso, modifique o script PL/SQL abaixo para que, caso o usuário inclua o hífen como separador dos nomes e classificações do produto,
ele seja substituído pelo "maior que" (>):

*/

DECLARE
   v_COD produto_exercicio.cod%type := '32224';
   v_DESCRICAO produto_exercicio.descricao%type := 'Sabor de Verão - Uva - 1 Litro';
   v_CATEGORIA produto_exercicio.categoria%type := 'Sucos de Frutas';
BEGIN
   INSERT INTO PRODUTO_EXERCICIO (COD, DESCRICAO, CATEGORIA) VALUES (v_COD, REPLACE(v_DESCRICAO, ' - ', ' > '), v_CATEGORIA);
   COMMIT;
END;

select * from PRODUTO_EXERCICIO;

