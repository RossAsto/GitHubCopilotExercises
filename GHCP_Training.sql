/**************************************************************************************************
Exercise 1: Data Definition Language - Create Tables
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

/*create a Product table with ProductID which is an identity with a seed of 1 and increment of 1 and a ProductName which can accept unicode characters up to 500 characters*/
CREATE TABLE Product
(
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(500)
);

/*create a Productv2 table with ProductIDv2 which is an identity which value starts from 1 and increments by 1 and a ProductNamev2 which can accept unicode characters up to 500 characters*/
CREATE TABLE Productv2
(
    ProductIDv2 INT IDENTITY(1,1) PRIMARY KEY,
    ProductNamev2 NVARCHAR(500)
);


/*create a Product table with ProductID which is an identity with a seed of 1 and increment of 1 and a ProductName which can accept unicode characters up to 500 characters. create a productType table which has ProductTypeID which is an identity column and a productType name which can accept up to 10 characters. ProductType table is referenced by Product table*/
CREATE TABLE ProductType
(
    ProductTypeID INT IDENTITY(1,1) PRIMARY KEY,
    ProductTypeName NVARCHAR(10)
);

CREATE TABLE Product
(
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(500),
    ProductTypeID INT FOREIGN KEY REFERENCES ProductType(ProductTypeID)
);



/*Using ProductType table as example, create a Supplier table. Both Supplier and ProductType should be referenced by Product table.*/

CREATE TABLE Supplier
(
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName NVARCHAR(500)
);

CREATE TABLE Product
(
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(500),
    ProductTypeID INT FOREIGN KEY REFERENCES ProductType(ProductTypeID),
    SupplierID INT FOREIGN KEY REFERENCES Supplier(SupplierID)
);







