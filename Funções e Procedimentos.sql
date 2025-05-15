/*Procedimento que recebe uma nota alfanumérica e retorna todos os alunos com essa nota além de outras colunas como a pontuação numérica*/
CREATE PROCEDURE student_grade_points
    @grade_input VARCHAR(2)
AS
BEGIN
    SELECT
        s.name AS Nome,
        s.dept_name AS Departamento_Estudante,
        c.title AS Título_Curso,
        c.dept_name AS Departamento_Curso,
        t.semester AS Semestre,
        t.year AS ano,
        t.grade AS Pontuação_Alfanumérica,
        CASE
            WHEN t.grade = 'A+' THEN 4.0
            WHEN t.grade = 'A'  THEN 3.7
            WHEN t.grade = 'A-' THEN 3.4
            WHEN t.grade = 'B+' THEN 3.1
            WHEN t.grade = 'B'  THEN 2.7
            WHEN t.grade = 'B-' THEN 2.3
            WHEN t.grade = 'C+' THEN 2.0
            WHEN t.grade = 'C'  THEN 1.7
            WHEN t.grade = 'C-' THEN 1.3
            WHEN t.grade = 'D'  THEN 1.0
            WHEN t.grade = 'F'  THEN 0.0
            ELSE NULL
        END AS Pontuação_Numérica
    FROM 
        student s
    JOIN 
        takes t ON s.ID = t.ID
    JOIN 
        course c ON t.course_id = c.course_id
    WHERE 
        t.grade = @grade_input
END

EXEC student_grade_points 'B+';

/*Função que retorna uma tabela com as aulas ministradas por um instrutos e mais detalhes*/
CREATE FUNCTION dbo.return_instructor_location (
    @instructor_name VARCHAR(100)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        i.name AS Nome_Instrutor,
        c.title AS Curso_Ministrado,
        s.semester AS Semestre,
        s.year AS Ano,
        s.building AS Predio,
        s.room_number AS Sala
    FROM instructor i
    JOIN teaches t ON i.ID = t.ID
    JOIN section s ON t.course_id = s.course_id 
                  AND t.sec_id = s.sec_id 
                  AND t.semester = s.semester 
                  AND t.year = s.year
    JOIN course c ON s.course_id = c.course_id
    WHERE i.name = @instructor_name
);

SELECT * FROM dbo.return_instructor_location('Gustafsson');
