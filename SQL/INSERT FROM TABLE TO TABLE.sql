-- Dusan 05.06.2013. begin -------------------------------------------------------

select name + ', ' as [text()] 
from sys.columns 
where object_id = object_id('ipAdresLog') 
for xml path('')

INSERT INTO ipAdresLog (vreme, ipAdresa)
SELECT vreme, ipAdresa
FROM ipAdresLogNew

delete from ipAdresLogNew
where vreme IS NULL

drop table ipAdresLog

-- Dusan 05.06.2013. end ---------------------------------------------------------
