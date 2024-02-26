/**************************************************************************************************
Exercise 1: Data Definition – Create Tables 

1. Create tables
2. Create tables with foreign key constraints
**************************************************************************************************/

/*create a Product table*/
CREATE TABLE Product
(
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    ProductPrice DECIMAL(10,2)
);

/*create a Product table with ProductID and ProductName*/
CREATE TABLE Product
(
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50)
);

/*create a Product table with ProductID which is an identity with a seed of 1 and increment of 1 and a ProductName which can accept unicode characters up to 500 characters. Price can is a decimal and can accept up to 2 decimal points*/
CREATE TABLE Product
(
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(500),
    ProductPrice DECIMAL(10,2)
);

/*create a Productv2 table with ProductIDv2 which is an identity which value starts from 1 and increments by 1 and a ProductNamev2 which can accept unicode characters up to 500 characters. Price can is a decimal and can accept up to 2 decimal points*/
CREATE TABLE Productv2
(
    ProductIDv2 INT IDENTITY(1,1) PRIMARY KEY,
    ProductNamev2 NVARCHAR(500),
    ProductPricev2 DECIMAL(10,2)
);


/*Create a ProductType table which has ProductTypeID which is an identity column and a productType name which can accept up to 10 characters.
Create a Product table with ProductID which is an identity with a seed of 1 and increment of 1, a ProductName which can accept unicode characters up to 500 characters and ProductPrice which is a decimal and can accept up to 2 decimal points
ProductType table is referenced by Product table */

CREATE TABLE ProductType
(
    ProductTypeID INT IDENTITY(1,1) PRIMARY KEY,
    ProductTypeName NVARCHAR(10)
);

CREATE TABLE Product
(
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(500),
    ProductPrice DECIMAL(10,2),
    ProductTypeID INT FOREIGN KEY REFERENCES ProductType(ProductTypeID)
);


/*Create a Supplier table. It should have the same schema as the ProductType table. Modify Product table to reference Supplier table.*/
CREATE TABLE Supplier
(
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName NVARCHAR(10)
);

ALTER TABLE Product
ADD SupplierID INT FOREIGN KEY REFERENCES Supplier(SupplierID);


/**************************************************************************************************
Exercise 2: Generate data

1. Generate insert statements
**************************************************************************************************/

/*Insert data into ProductType table*/
INSERT INTO ProductType(ProductTypeName)
VALUES('Type1'),('Type2'),('Type3'),('Type4'),('Type5');

/*Insert data into Supplier table*/
INSERT INTO Supplier(SupplierName)
VALUES('Supplier1'),('Supplier2'),('Supplier3'),('Supplier4'),('Supplier5');

/*Insert data into Product table*/
INSERT INTO Product(ProductName, ProductPrice, ProductTypeID, SupplierID)
VALUES('Product1', 100, 1, 1),
('Product2', 200, 2, 2),
('Product3', 300, 3, 3),
('Product4', 400, 4, 4),
('Product5', 500, 5, 5);




/**************************************************************************************************
Exercise 3: Querying Data

1. Select statements (with data filters, aggregation)
2. Join statements
3. Subqueries
**************************************************************************************************/

-- Select statements

/*select all columns from a Product table*/
SELECT * FROM Product;

/*return ProductName from product where ProductTypeId is 1*/
SELECT ProductName FROM Product WHERE ProductTypeID = 1;

/*Return all products ordered by price from highest to lowest*/
SELECT * FROM Product ORDER BY ProductPrice DESC;

/*Return the count of products for each ProductTypeID*/
SELECT ProductTypeID, COUNT(*) FROM Product GROUP BY ProductTypeID;

/*Return SUM of all product prices for all products*/
SELECT SUM(ProductPrice) FROM Product;


-- Join Statements

/*Join product and ProductType on productTypeID and return all Products with a productType*/
SELECT p.ProductName, pt.ProductTypeName FROM Product p
JOIN ProductType pt ON p.ProductTypeID = pt.ProductTypeID;

/*Inner join between Product and Product Type*/
SELECT p.ProductName, pt.ProductTypeName FROM Product p
JOIN ProductType pt ON p.ProductTypeID = pt.ProductTypeID;


/*Join product and ProductType on productTypeID and return all Products with no productType*/
SELECT p.ProductName, pt.ProductTypeName FROM Product p
LEFT JOIN ProductType pt ON p.ProductTypeID = pt.ProductTypeID
WHERE pt.ProductTypeName IS NULL;

/*Right join between Product and Product Type. Return all columns from Product and productTYpe*/
SELECT p.*, pt.* FROM Product p
RIGHT JOIN ProductType pt ON p.ProductTypeID = pt.ProductTypeID;


-- Subqueries
/*select data from ProductType where ProductTypeID in Products table*/
SELECT * FROM ProductType WHERE ProductTypeID IN (SELECT ProductTypeID FROM Product);

/*select data from ProductType where ProductTypeID not in Products table*/
SELECT * FROM ProductType WHERE ProductTypeID NOT IN (SELECT ProductTypeID FROM Product);


/**************************************************************************************************
Exercise 4: Stored Procedures
1. Create stored procedures
2. Execute stored procedures
3. Implement error handling
4. Implement transactions
**************************************************************************************************/

/*Create stored procedure that will insert data into ProductType table and return the ProductTypeId*/
CREATE PROCEDURE InsertProductType
@ProductTypeName NVARCHAR(10)
AS
BEGIN
    INSERT INTO ProductType(ProductTypeName)
    VALUES(@ProductTypeName)
END;

/*Generate a sample execution of the InsertProductType stored procedure*/
EXEC InsertProductType 'Type6';

/*Alter InsertProductType stored procedure to implement error handling.*/
ALTER PROCEDURE InsertProductType
@ProductTypeName NVARCHAR(10)
AS
BEGIN
    BEGIN TRY
        INSERT INTO ProductType(ProductTypeName)
        VALUES(@ProductTypeName)
    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS ErrorMessage
    END CATCH
END;

/*Create a stored procedure that will insert data into ProductType, Supplier and Product table and return the ProductTypeId. Implement transactions.*/
CREATE PROCEDURE InsertProduct
@ProductName NVARCHAR(500),
@ProductPrice DECIMAL(10,2),
@ProductTypeName NVARCHAR(10),
@SupplierName NVARCHAR(10)
AS

BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        DECLARE @ProductTypeID INT
        INSERT INTO ProductType(ProductTypeName)
        VALUES(@ProductTypeName)
        SET @ProductTypeID = SCOPE_IDENTITY()

        DECLARE @SupplierID INT
        INSERT INTO Supplier(SupplierName)
        VALUES(@SupplierName)
        SET @SupplierID = SCOPE_IDENTITY()

        INSERT INTO Product(ProductName, ProductPrice, ProductTypeID, SupplierID)
        VALUES(@ProductName, @ProductPrice, @ProductTypeID, @SupplierID)

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        SELECT ERROR_MESSAGE() AS ErrorMessage
    END CATCH
END;

/*Generate a sample execution of the InsertProduct stored procedure*/
EXEC InsertProduct 'Product6', 600, 'Type6', 'Supplier6';



/**************************************************************************************************
Exercise 5: Functions
1. Create different types of functions
**************************************************************************************************/

/*Create a scalar function that will return the sum of the prices of 2 products in product table. Generate a sample call to the function.*/

CREATE FUNCTION GetProductPriceSum
(
    @ProductID1 INT,
    @ProductID2 INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @ProductPrice1 DECIMAL(10,2)
    DECLARE @ProductPrice2 DECIMAL(10,2)

    SELECT @ProductPrice1 = ProductPrice FROM Product WHERE ProductID = @ProductID1
    SELECT @ProductPrice2 = ProductPrice FROM Product WHERE ProductID = @ProductID2

    RETURN @ProductPrice1 + @ProductPrice2
END;    

SELECT dbo.GetProductPriceSum(1,2);

/*Create a table valued function that will return all products with a product type. Generate a sample call to the function.*/
CREATE FUNCTION GetProductsByProductType
(
    @ProductTypeID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT * FROM Product WHERE ProductTypeID = @ProductTypeID
);

SELECT * FROM dbo.GetProductsByProductType(1);

/**************************************************************************************************
Exercise 6: Triggers
1. Create different types of triggers
**************************************************************************************************/

/*Create a ProductLog table using the schema of an audit table. Create a trigger that will insert a record into a log table when a new product is inserted into Product table.*/
CREATE TABLE ProductLog
(
    ProductID INT,
    ProductName NVARCHAR(500),
    ProductPrice DECIMAL(10,2),
    ProductTypeID INT,
    SupplierID INT,
    LogDate DATETIME
);

CREATE TRIGGER InsertProductLog
ON Product
AFTER INSERT
AS
BEGIN
    INSERT INTO ProductLog(ProductID, ProductName, ProductPrice, ProductTypeID, SupplierID, LogDate)
    SELECT ProductID, ProductName, ProductPrice, ProductTypeID, SupplierID, GETDATE() FROM INSERTED
END;

/*Generate a sample insert into Product table to test the trigger*/
INSERT INTO Product(ProductName, ProductPrice, ProductTypeID, SupplierID)
VALUES('Product6', 600, 6, 6);

SELECT * FROM ProductLog;


/*Create a trigger on Product table that will update the ProductName to append the updated ProductTypeId when the ProductTypeId is updated*/
CREATE TRIGGER UpdateProductName
ON Product
AFTER UPDATE
AS
BEGIN
    UPDATE p
    SET p.ProductName = p.ProductName + CAST(i.ProductTypeID AS NVARCHAR(10))
    FROM Product p
    JOIN INSERTED i ON p.ProductID = i.ProductID
END;

/*Generate a sample update to Product table to test the trigger*/
UPDATE Product
SET ProductTypeID = 2
WHERE ProductID = 1;

SELECT * FROM Product;




/**************************************************************************************************
Exercise 7: CTE
**************************************************************************************************/


/*Create an Employee table with ManagerID as a foreign key to EmployeeID.*/

CREATE TABLE Employee
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName NVARCHAR(50),
    ManagerID INT FOREIGN KEY REFERENCES Employee(EmployeeID)
);

/*Insert data into Employee table*/
INSERT INTO Employee(EmployeeID, EmployeeName, ManagerID)
VALUES(1, 'Employee1', 2),
(2, 'Employee2', 3),
(3, 'Employee3', NULL),
(4, 'Employee4', 3),
(5, 'Employee5', 2),
(6, 'Employee6', 1),
(7, 'Employee6', NULL);


/*Create a CTE that will return all employees and their managers*/
WITH EmployeeCTE AS
(
    SELECT EmployeeID, EmployeeName, ManagerID
    FROM Employee
    WHERE ManagerID IS NULL
    UNION ALL
    SELECT e.EmployeeID, e.EmployeeName, e.ManagerID
    FROM Employee e
    JOIN EmployeeCTE ecte ON e.ManagerID = ecte.EmployeeID
)
SELECT * FROM EmployeeCTE;


/**************************************************************************************************
Exercise 8: Data Normalization and Denormalization
**************************************************************************************************/
/*Create a denormalized table that will store the Students and their Courses.*/
CREATE TABLE StudentCourse
(
    StudentID INT,
    StudentName NVARCHAR(50),
    CourseID INT,
    CourseName NVARCHAR(50)
);

-- after normalization

CREATE TABLE Student
(
    StudentID INT PRIMARY KEY,
    StudentName NVARCHAR(50)
);

CREATE TABLE Course
(
    CourseID INT PRIMARY KEY,
    CourseName NVARCHAR(50)
);

CREATE TABLE StudentCourse
(
    StudentID INT,
    CourseID INT,
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

/**************************************************************************************************
Exercise 9: Optimizing SQL queries
**************************************************************************************************/


/*Select from Product*/
SELECT p.ProductID, p.ProductName, p.ProductTypeID
FROM Product p
WHERE p.ProductName = 'YourProductName'

-- after optimization
SELECT p.ProductID, p.ProductName, p.ProductTypeID
FROM Product p
-- Add any necessary conditions or filters here


/*Join product and ProductType tables and return all products with a product type using a temporary table*/
SELECT p.ProductName, pt.ProductTypeName
INTO #TempProduct
FROM Product p
JOIN ProductType pt ON p.ProductTypeID = pt.ProductTypeID
WHERE p.ProductName = 'YourProductName' -- Add any necessary conditions or filters here

SELECT * FROM #TempProduct

-- after optimization
SELECT p.ProductName, pt.ProductTypeName
FROM Product p
JOIN ProductType pt ON p.ProductTypeID = pt.ProductTypeID
WHERE p.ProductName = 'YourProductName' -- Add any necessary conditions or filters here


/*Create an index on Product table to optimize querying data from Product table by Price and Name*/
CREATE INDEX IX_Product_ProductName_ProductPrice
ON Product(ProductName, ProductPrice);






