USE [DOMY]
SET NOCOUNT ON

BEGIN
DECLARE 
@domy_min AS int,
@domy_max AS int,
@dom_id AS int,
@licznik AS int,
@obserwacja_id AS bigint;

SET @licznik = 1;
SET @domy_min = (SELECT MIN(id) FROM dom);
SET @domy_max = (SELECT MAX(id) FROM dom);

WHILE @licznik <= 100
	BEGIN
		SET @dom_id = (SELECT TOP 1 id
						 FROM dbo.dom
						WHERE id >= (SELECT ROUND((@domy_max - @domy_min)*RAND(),0) + @domy_min)
					   ORDER BY id ASC);

		INSERT INTO dbo.obserwacje(id,data,IP,dom_id)
		SELECT NEXT VALUE FOR dbo.seq_obserwacje_id,
		       GETDATE() - RAND()*365 AS DATA,
			   CAST(CAST(ROUND(256*RAND(),0) AS NVARCHAR(3)) + '.' +
					CAST(ROUND(256*RAND(),0) AS NVARCHAR(3)) + '.' +
					CAST(ROUND(256*RAND(),0) AS NVARCHAR(3)) + '.' +
					CAST(ROUND(256*RAND(),0) AS NVARCHAR(3)) AS nvarchar(15)),
			   @dom_id	          
		;
		
		SET @licznik = @licznik + 1
	END;
END