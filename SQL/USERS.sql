SELECT @@SPID AS 'ID', SYSTEM_USER AS 'Login Name', USER AS 'User Name'

USE master;
GO
EXEC sp_who;
GO