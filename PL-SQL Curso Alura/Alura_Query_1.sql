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

--- PERCENT TYPE ----------------------------------------------------------------------------


