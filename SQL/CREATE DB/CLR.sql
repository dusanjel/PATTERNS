USE JAT
GO

CREATE ASSEMBLY Valuta
FROM
'C:\Users\Dusan\Desktop\SQL Script FON\StruktuiraniTipFile\CLRValuta\CLRValuta\bin\Debug\CLRValuta.dll'
GO

CREATE TYPE dbo.Valuta
EXTERNAL NAME Valuta.Valuta
GO

DECLARE @i [Valuta]
SET @i = [Valuta]::[KreirajValutu]('$', 0.53)
PRINT CONVERT([varchar], @i)

/* Iskoristi instanciranu mutator metodu da promenis simbol: */
DECLARE @i [Valuta]
SET @i = [Valuta]::[KreirajValutu]('$', 0.53)
SET @i.IzmeniSimbol('£')
PRINT CONVERT([varchar], @i)

/* Vrati znak valute*/
DECLARE @i [Valuta]
SET @i = [Valuta]::[KreirajValutu]('$', 0.53)
PRINT @i.Simbol
