/*DROP TABLE CurrentInventory
DROP TABLE NewInventory*/

/**************************************************************************************************
Exercise 1: Exercise: Create the following SQL objects. This will set up the data for the exercises. 
**************************************************************************************************/


/*Create 3 tables.

Current Inventory which has the following columns:
ProductID (int) 
Quantity (int)
Discontinued (bit)

ProductID is the primary key for this table.

NewInventory which has the following columns:
ProductID (int)
Quantity (int) 

ProductID is the primary key for this table.

Products which has the following columns:
ProductID (int)
ProductName (varchar(50))

ProductID is the primary key for this table.

Generate a script that will insert the following data into the Current Inventory table:
ProductID	Quantity	Discontinued
1	100	0
2	200	0
3	300	1

Generate a script that will insert the following data into the New Inventory table:
ProductID	Quantity
1	100
2	250
4	400 

Generate a script that will insert the following data into the Products table:
ProductID	ProductName
1	1abc2dsds 
2	dfg2dsf 
3	P2osf5 
4	Psdsd5dd
5	dff1 
6	11ddd 
*/


/*Create CurrentInventory table*/
CREATE TABLE CurrentInventory
(
    ProductID INT PRIMARY KEY,
    Quantity INT,
    Discontinued BIT
)

/*Create NewInventory table*/
CREATE TABLE NewInventory
(
    ProductID INT PRIMARY KEY,
    Quantity INT
)

/*Create Products table*/
CREATE TABLE Products
(
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50)
)

/*Insert data into CurrentInventory table*/
INSERT INTO CurrentInventory
VALUES (1, 100, 0),
       (2, 200, 0),
       (3, 300, 1)


/*Insert data into NewInventory table*/
INSERT INTO NewInventory
VALUES (1, 100),
       (2, 250),
       (4, 400)

/*Insert data into Products table*/
INSERT INTO Products
VALUES (1, '1abc2dsds'),
       (2, 'dfg2dsf'),
       (3, 'P2osf5'),
       (4, 'Psdsd5dd'),
       (5, 'dff1'),
       (6, '11ddd')


/*select data from CurrentInventory table*/
SELECT * FROM CurrentInventory
/*select data from NewInventory table*/
SELECT * FROM NewInventory
/*select data from Products table*/
SELECT * FROM Products

/*Select data from CurrentInventory table where Discontinued is 1*/
SELECT * FROM CurrentInventory WHERE Discontinued = 1

/*Select total quantity of CurrentInventory table where Discontinued is 0*/
SELECT SUM(Quantity) FROM CurrentInventory WHERE Discontinued = 0

/*select statement that will return product name which starts with number followed by 3 letters then a single digit and then may be followed by any number of characters*/ 
SELECT * FROM Products WHERE ProductName LIKE '[0-9][a-z][a-z][a-z][0-9]%'

/*select statement that will return product name  from Product table based off the pattern of the product name.  

The following names will be returned: 
1abc2dsds 
2osf5 
3sdsd5dd 

The following names will not be returned: 

dff1 
dfg2dsf 
11ddd */
SELECT * FROM Products WHERE ProductName LIKE '[0-9][a-z][a-z][a-z][0-9]%' AND ProductName NOT LIKE '%[a-z][a-z][0-9]%'



/*Select data from CurrentInventory table which has a corresponding record in NewInventory table*/
SELECT * FROM CurrentInventory WHERE ProductID IN (SELECT ProductID FROM NewInventory)


/*Select data from both CurrentInventory table and NewInventory table. Only return data where CurrentInventory has a ProductID which has a corresponding record in NewInventory table.*/
SELECT * FROM CurrentInventory CI
JOIN NewInventory NI
ON CI.ProductID = NI.ProductID


/*Join CurrentInvntory and NewInventory table on ProductID and select data*/
SELECT * FROM CurrentInventory CI
JOIN NewInventory NI
ON CI.ProductID = NI.ProductID


/*Do a left join between CurrentInventory and NewInventory table on ProductID and select data*/
SELECT * FROM CurrentInventory CI
LEFT JOIN NewInventory NI
ON CI.ProductID = NI.ProductID

/*Do a right join between CurrentInventory and NewInventory table on ProductID and select data*/
SELECT * FROM CurrentInventory CI
RIGHT JOIN NewInventory NI
ON CI.ProductID = NI.ProductID

/*Do a full join between CurrentInventory and NewInventory table on ProductID and select data*/
SELECT * FROM CurrentInventory CI
FULL JOIN NewInventory NI
ON CI.ProductID = NI.ProductID

/*Do a cross join between CurrentInventory and NewInventory table and select data*/
SELECT * FROM CurrentInventory CI
CROSS JOIN NewInventory NI


/**************************************************************************************************************************
Exercise 2: Write a SQL query that would use the data in the NewInventory table to modify the data in CurrentInventory table. 
After the query is ran, select the contents of CurrentInventory table to produce the expected output. 
***************************************************************************************************************************/


/*create an insert query to insert data from NewInventory table to CurrentInventory table if data does not exist in the CurrentInventory table*/
INSERT INTO CurrentInventory
SELECT * FROM NewInventory
WHERE ProductID NOT IN (SELECT ProductID FROM CurrentInventory)

/*create an insert query to insert data from NewInventory table to CurrentInventory table if data does not exist in the CurrentInventory table. Make the insert columns explicit.*/
INSERT INTO CurrentInventory (ProductID, Quantity, Discontinued)
SELECT NI.ProductID, NI.Quantity, 0
FROM NewInventory NI
LEFT JOIN CurrentInventory CI
ON NI.ProductID = CI.ProductID
WHERE CI.ProductID IS NULL

/*create an update query to update Quantity in CurrentInventory table from NewInventory table where ProductID is same*/
UPDATE CI
SET CI.Quantity = NI.Quantity
FROM CurrentInventory CI
JOIN NewInventory NI
ON CI.ProductID = NI.ProductID

/*create an update query to update Discontinued to 1 in CurrentInventory table where ProductID does not exist in NewInventory table*/
UPDATE CI
SET CI.Discontinued = 1
FROM CurrentInventory CI
LEFT JOIN NewInventory NI
ON CI.ProductID = NI.ProductID
WHERE NI.ProductID IS NULL


/*based on the Insert and 2 Update statements above, create an optimized query */
MERGE INTO CurrentInventory CI
USING NewInventory NI
ON CI.ProductID = NI.ProductID
WHEN MATCHED THEN
    UPDATE SET CI.Quantity = NI.Quantity
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, Quantity, Discontinued)
    VALUES (NI.ProductID, NI.Quantity, 0)
WHEN NOT MATCHED BY SOURCE THEN
    UPDATE SET CI.Discontinued = 1;


/*Merge the 2 tables. The merge should update existing records, insert new records and flag records that are in CurrentInventory but not in NewInventory as discontinued.*/
MERGE INTO CurrentInventory CI
USING NewInventory NI
ON CI.ProductID = NI.ProductID
WHEN MATCHED THEN
    UPDATE SET CI.Quantity = NI.Quantity
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, Quantity, Discontinued)
    VALUES (NI.ProductID, NI.Quantity, 0)
WHEN NOT MATCHED BY SOURCE THEN
    UPDATE SET CI.Discontinued = 1;

/*select data from CurrentInventory table*/
SELECT * FROM CurrentInventory

/*************************************************************************************
Exercise 3: Write a stored procedure that will process data in the NewInventoryTable. 
*************************************************************************************/

/*Create a stored procedure that will insert data into NewInventory table and return the contents. Make the insert columns explicit.*/

CREATE PROCEDURE InsertNewInventory
    @ProductID INT,
    @Quantity INT
AS
BEGIN
    INSERT INTO NewInventory (ProductID, Quantity)
    VALUES (@ProductID, @Quantity)

    SELECT * FROM NewInventory
END

/*Generate an execution script for the stored procedure*/
EXEC InsertNewInventory 5, 100
EXEC InsertNewInventory 6, 200

/*Alter the InsertNewInventory and add error handling. Print the error message */
ALTER PROCEDURE InsertNewInventory
    @ProductID INT,
    @Quantity INT
AS
BEGIN
    BEGIN TRY
        INSERT INTO NewInventory (ProductID, Quantity)
        VALUES (@ProductID, @Quantity)

        SELECT * FROM NewInventory
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE()
    END CATCH
END

/*Retest the stored procedure with an invalid input*/
EXEC InsertNewInventory 5, 100

/*************************************************************************************
Exercise 4: Write a SQL query that would insert data into a SQL table from a CSV file. 
*************************************************************************************/

/*Insert a CSV file called CurrentInventory.csv in C:\myDocs\Avanade\GHCP-Playground  into CurrentInventory table. 
The delimiter for the CSV file is a pipe.
It has column headers.*/
BULK INSERT CurrentInventory
FROM 'C:\myDocs\Avanade\GHCP-Playground\CurrentInventory.csv'
WITH
(
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
)

/*select data from CurrentInventory table*/
select * from CurrentInventory


/*Insert a CSV file called CurrentInventory2.csv in C:\myDocs\Avanade\GHCP-Playground  into CurrentInventory table. */
BULK INSERT CurrentInventory
FROM 'C:\myDocs\Avanade\GHCP-Playground\CurrentInventoryv2.csv'
WITH
(
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
)

/*Insert a CSV file called CurrentInventory2.csv in C:\myDocs\Avanade\GHCP-Playground  into CurrentInventory table.
Pass the arguments to the BULK INSERT command using a format file.
Also the CSV file is pipe-delimited and has column headers.*/
BULK INSERT CurrentInventory
FROM 'C:\myDocs\Avanade\GHCP-Playground\CurrentInventoryv2.csv'
WITH
(
    FORMATFILE = 'C:\myDocs\Avanade\GHCP-Playground\CurrentInventoryFormatFile.xml',
    FIRSTROW = 2
)


/*Generate CurrentInventoryFormatFile.xml from CurrentInventory table*/
bcp SampleDB.dbo.CurrentInventory format nul -c -x -f C:\myDocs\Avanade\GHCP-Playground\CurrentInventoryFormatFile.xml -t "|" -T

