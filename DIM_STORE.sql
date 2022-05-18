--CREATE TABLE DIM_STORE
CREATE OR REPLACE TABLE PUBLIC.DIM_STORE (
    DimStoreID INT IDENTITY(1,1) CONSTRAINT PK_DimStoreID PRIMARY KEY NOT NULL
    , DimLocationID INTEGER CONSTRAINT FK_DimLocationIDStore FOREIGN KEY REFERENCES PUBLIC.Dim_LOCATION (DimLocationID) NOT NULL 
    , StoreID INT NOT NULL
    , StoreNumber INT NOT NULL
    , StoreManager VARCHAR(255) NOT NULL
); 
--Load unknown store
INSERT INTO PUBLIC.DIM_STORE (
    DimStoreID
    , DimLocationID
    , StoreID
    , StoreNumber
    , StoreManager
)
VALUES (
    -1
    ,-1
    , -1
    , -1
    , 'NULL'
)
--Load store data
INSERT INTO PUBLIC.DIM_STORE (
    DimLocationID
    , StoreID
    , StoreNumber
    , StoreManager
)
SELECT B.DimLocationID 
    , StoreID
    , StoreNumber
    , StoreManager
FROM STAGE_STORE A
LEFT JOIN PUBLIC.DIM_LOCATION B
ON A.PostalCode = B.PostalCode
AND A.Address = B.Address
AND A.City = B.City
AND A.STATEPROVINCE = B.State
AND A.Country = B.Country
