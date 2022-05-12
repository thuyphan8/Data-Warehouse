--CREATE TABLE DIM_RESELLER
CREATE OR REPLACE TABLE PUBLIC.DIM_RESELLER (
    DimResellerID INT IDENTITY(1,1) CONSTRAINT PK_DimResellerID PRIMARY KEY NOT NULL
    , DimLocationID INTEGER CONSTRAINT FK_DimLocationIDReseller FOREIGN KEY REFERENCES PUBLIC.Dim_LOCATION (DimLocationID) NOT NULL 
    , ResellerID VARCHAR(255) NOT NULL
    , ResellerName VARCHAR(255) NOT NULL
    , ContactName VARCHAR(255) NOT NULL
    , PhoneNumber VARCHAR(255) NOT NULL
    , Email VARCHAR(255) NOT NULL
); 
--Load unknown reseller
INSERT INTO PUBLIC.DIM_RESELLER (
    DimResellerID
    , DimLocationID
    , ResellerID
    , ResellerName
    , ContactName
    , PhoneNumber
    , Email 
)
VALUES (
    -1
    ,-1
    , 'NULL'
    , 'NULL'
    , 'NULL'
    , 'NULL'
    , 'NULL'
)
--Load reseller data
INSERT INTO PUBLIC.DIM_RESELLER (
    DimLocationID
    , ResellerID
    , ResellerName
    , ContactName
    , PhoneNumber
    , Email 
)
SELECT 
     B.DimLocationID 
    , ResellerID
    , ResellerName
    , Contact
    , PhoneNumber
    , EmailAddress
FROM STAGE_RESELLER A
LEFT JOIN PUBLIC.DIM_LOCATION B
ON A.PostalCode = B.PostalCode
AND A.Address = B.Address
AND A.City = B.City
AND A.STATEPROVINCE = B.State
AND A.Country = B.Country