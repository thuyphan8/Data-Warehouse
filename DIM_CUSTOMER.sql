--CREATE TABLE DIM_CUSTOMER
CREATE OR REPLACE TABLE PUBLIC.DIM_CUSTOMER (
    DimCustomerID INT IDENTITY(1,1) CONSTRAINT PK_DimCustomerID PRIMARY KEY NOT NULL
    , DimLocationID INTEGER CONSTRAINT FK_DimLocationIDCustomer FOREIGN KEY REFERENCES PUBLIC.Dim_LOCATION (DimLocationID) NOT NULL 
    , CustomerID VARCHAR(255) NOT NULL
    , FullName VARCHAR(255) NOT NULL
    , FirstName VARCHAR(255) NOT NULL
    , LastName VARCHAR(255) NOT NULL
    , Gender VARCHAR(255) NOT NULL
    , EmailAddress VARCHAR(255) NOT NULL
    , PhoneNumber VARCHAR(255) NOT NULL
); 
--Load unknown customer
INSERT INTO PUBLIC.DIM_CUSTOMER (
    DimCustomerID
    , DimLocationID
    , CustomerID
    , FullName
    , FirstName
    , LastName
    , Gender 
    , EmailAddress
    , PhoneNumber
)
VALUES (
    -1
    ,-1
    , 'NULL'
    , 'NULL'
    , 'NULL'
    , 'NULL'
    , 'NULL'
    , 'NULL'
    , 'NULL'
)
--Load customer data
INSERT INTO PUBLIC.DIM_CUSTOMER (
    DimLocationID
    , CustomerID
    , FullName
    , FirstName
    , LastName
    , Gender 
    , EmailAddress
    , PhoneNumber
)
SELECT 
     B.DimLocationID as DimLocationID
    , CustomerID
    , CONCAT(FirstName,' ', LastName) 
    , FirstName
    , LastName
    , Gender
    , EmailAddress
    , PhoneNumber
FROM STAGE_CUSTOMER A
LEFT JOIN PUBLIC.DIM_LOCATION B
ON A.PostalCode = B.PostalCode
AND A.Address = B.Address
AND A.City = B.City
AND A.STATEPROVINCE = B.State
AND A.Country = B.Country