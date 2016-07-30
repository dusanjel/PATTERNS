select name + ', ' as [text()] 
from sys.columns 
where object_id = object_id('log') 
for xml path('')