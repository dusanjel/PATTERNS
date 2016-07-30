CREATE PROCEDURE dbo.proveriMAC	
AS
-- Obrisi tabelu ako postoji
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'LogTabela')
    DROP TABLE [dbo].[LogTabela];

-- Kreiraj tabelu
CREATE TABLE [dbo].[LogTabela] (
[Loger] varchar(8000)
)

-- Insertuj podatke u tabelu sa navadene destinacije
DECLARE @bulk_cmd varchar(1000);
SET @bulk_cmd = 'BULK INSERT [dbo].[LogTabela]
FROM ''C:\Users\DUSAN\Desktop\MAC_LOG\dhcp_log.txt'' 
WITH (ROWTERMINATOR = '''+CHAR(10)+''')';
EXEC(@bulk_cmd);

-- Ukoliko ne postoje neregistrovane MAC adrese izbaci poruku
IF NOT EXISTS
(
-- Selektuj sve osim registrovanih MAC adresa
SELECT SUBSTRING(Loger, CHARINDEX('from ', Loger)+4, 18) AS MacAdresa FROM dbo.LogTabela
WHERE Loger LIKE '% from %'
AND Loger NOT LIKE '%00:00:00:00:00:00%' -- MAC1
AND Loger NOT LIKE '%00:00:00:00:00:00%' -- MAC2
AND Loger NOT LIKE '%00:00:00:00:00:00%' -- MAC3
AND Loger NOT LIKE '%00:00:00:00:00:00%' -- MAC4
AND Loger NOT LIKE '%00:00:00:00:00:00%' -- MAC5
AND Loger NOT LIKE '%00:00:00:00:00:00%' -- MAC6
AND Loger NOT LIKE '%00:00:00:00:00:00%' -- MAC7
AND Loger NOT LIKE '%00:00:00:00:00:00%' -- MAC8
)
BEGIN
	PRINT 'Svi korisnici su registrovani, nema neregistrovanih korisnika!'
END ELSE
BEGIN
	SELECT DISTINCT SUBSTRING(Loger, CHARINDEX('from ', Loger)+4, 18) AS MacAdresa FROM dbo.LogTabela
WHERE Loger LIKE '% from %'
AND Loger NOT LIKE '%00:00:00:00:00:00%' -- MAC1
AND Loger NOT LIKE '%00:00:00:00:00:00%' -- MAC2
AND Loger NOT LIKE '%00:00:00:00:00:00%' -- MAC3
AND Loger NOT LIKE '%00:00:00:00:00:00%' -- MAC4
AND Loger NOT LIKE '%00:00:00:00:00:00%' -- MAC5
AND Loger NOT LIKE '%00:00:00:00:00:00%' -- MAC6
AND Loger NOT LIKE '%00:00:00:00:00:00%' -- MAC7
AND Loger NOT LIKE '%00:00:00:00:00:00%' -- MAC8
END
GO
