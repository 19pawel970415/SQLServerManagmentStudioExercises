--2
MERGE Territories AS T
USING EmployeeTerritories AS S
ON T.TerritoryID = S.TerritoryID
WHEN NOT MATCHED BY SOURCE
THEN DELETE;

--3
MERGE Categories AS T
USING (Values ('Dummy')) AS S (Nazwa)
ON CategoryName = S.Nazwa
WHEN MATCHED THEN
UPDATE SET T.[Description] = 'New dummy description'
WHEN NOT MATCHED THEN
INSERT (CategoryName, [Description], Picture) VALUES ('Dummy', 'Dummy description', 'Picture');

--4
MERGE Categories AS T
USING Products AS S
ON T.CategoryID = S.CategoryID
WHEN NOT MATCHED BY SOURCE
THEN DELETE;

--5
MERGE [Order Details] AS T
USING Orders AS S
ON T.OrderID = S.OrderID
WHEN MATCHED AND S.ShipCountry = 'USA' THEN
UPDATE SET T.Discount = 0.3;

--6
MERGE Products AS T
USING Suppliers AS S
ON T.SupplierID = S.SupplierID
WHEN MATCHED AND S.CompanyName = 'Exotic Liquids' THEN
UPDATE SET T.Discontinued = 1;

--7
-- na 5 na kolosie
MERGE Products AS T
USING (Values ('Finlandia')) AS S (ProductName)
ON T.ProductName = S.ProductName
WHEN MATCHED THEN
UPDATE SET UnitsInStock += 10
WHEN NOT MATCHED THEN
INSERT (ProductName, SupplierId, CategoryID) VALUES ('Finlandia', (Select SupplierID FROM Suppliers WHERE CompanyName = 'Exotic Liquids'),
(Select CategoryID FROM Categories WHERE CategoryName = 'Bevereges'));



