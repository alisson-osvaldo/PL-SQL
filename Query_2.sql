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
  SELECT  *
  FROM    employees; -- DeclaraÃ§Ã£o do Cursor
  employees_record  employees_cursor%rowtype; 
BEGIN
  /* Inicializa */
  
  OPEN  employees_cursor; -- Abrindo o Cursor
  
  FETCH  employees_cursor  
    INTO  employees_record; -- Fetch do Cursor
	
  /* Loop */
  
  WHILE  employees_cursor%found  LOOP
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
