--Script that you can use to find out the Users and their AD Groups in SSMS

--Finding out members of Active Directory Group that is already in SQL Server
master.dbo.xp_logininfo 'ADSERVER\DBAGROUP', 'members' 

--Finding out Active directory group that below user belong to?
Exec master.dbo.xp_logininfo 'ADSERVER\DBAGROUP', 'members' 
