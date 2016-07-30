CREATE PROCEDURE dbo.PretraziTekst
    @VrednostPretrage nvarchar(500) 
AS 

SELECT DISTINCT
    s.name+'.'+o.name AS Object_Name,o.type_desc
    FROM sys.sql_modules        m
        INNER JOIN sys.objects  o ON m.object_id=o.object_id
        INNER JOIN sys.schemas  s ON o.schema_id=s.schema_id
    WHERE m.definition Like '%'+@VrednostPretrage+'%'
        --AND o.Type='P'  --<uncomment if you only want to search procedures
    ORDER BY 1
GO