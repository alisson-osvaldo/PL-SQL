
-- ROWNUM 
/*
Retorna uma determinada quantidade de linhas em uma consulta.
Exemplo:
	select * from employeers where id = 1 and ROWNUM = 1;  - Retornara apenas uma linha.
	select * from employeers where id = 1 and ROWNUM < 10; - Retornara 9 linhas.
*/