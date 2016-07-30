--The syntax for creating a VIEW in SQL is:

-- Dusan 26.06.2013. begin -------------------------------------------------------

CREATE VIEW view_name AS
  SELECT columns
  FROM table
  WHERE predicates;

-- Dusan 26.06.2013. end ---------------------------------------------------------


CREATE VIEW sup_orders AS
  SELECT suppliers.supplier_id, orders.quantity, orders.price
  FROM suppliers, orders
  WHERE suppliers.supplier_id = orders.supplier_id
  and suppliers.supplier_name = 'IBM';

--This SQL View (Create statement) would create a virtual table based on the result set of the select statement. You can now query the view as follows:

SELECT *
FROM sup_orders;
Updating an SQL VIEW

--You can modify the definition of a VIEW in SQL without dropping it by using the following syntax:

CREATE OR REPLACE VIEW view_name AS
  SELECT columns
  FROM table
  WHERE predicates;
SQL View Modify - Example

CREATE or REPLACE VIEW sup_orders AS
  SELECT suppliers.supplier_id, orders.quantity, orders.price
  FROM suppliers, orders
  WHERE suppliers.supplier_id = orders.supplier_id
  and suppliers.supplier_name = 'Microsoft';

--This SQL View (Create/Replace statement) would update the definition of the SQL View without dropping it. If the SQL View did not yet exist, the SQL View would merely be created for the first time.

--Dropping an SQL VIEW

--The syntax for dropping a VIEW in SQL is:

DROP VIEW view_name;

--SQL View Drop - Example

DROP VIEW sup_orders;