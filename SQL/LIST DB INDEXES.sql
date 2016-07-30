SELECT IndexName = i.Name,
       SchemaName = schema_name(schema_id),
       TableName = object_name(o.object_id)
FROM   sys.indexes i
       JOIN sys.objects o
         ON i.object_id = o.object_id
WHERE  is_primary_key = 0
       AND is_unique = 1
       AND i.Name = 'INDEX_NAME' --Obrisati ukoliko treba lista svih sa baze
       AND o.object_id IN (SELECT object_id
                           FROM   sys.objects
                           WHERE  TYPE = 'U')
ORDER  BY SchemaName,
          TableName,
          IndexName; 