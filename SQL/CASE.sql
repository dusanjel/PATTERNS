select COLUMN1 +
(
CASE
  WHEN COLUMN1 = 1 THEN
    COLUMN1 + 100
  ELSE
    COLUMN1 + 200
END
)
FROM TABLE1