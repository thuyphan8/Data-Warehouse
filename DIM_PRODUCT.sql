--CREATE TABLE DIM_PRODUCT
CREATE OR REPLACE TABLE PUBLIC.DIM_PRODUCT (
    DimProductID INT IDENTITY(1,1) CONSTRAINT PK_DimProductID PRIMARY KEY NOT NULL
    , ProductID INT NOT NULL
    , ProductTypeID INT NOT NULL
    , ProductCategoryID INT NOT NULL
    , ProductName VARCHAR(255) NOT NULL
    , ProductType VARCHAR(255) NOT NULL
    , ProductCategory VARCHAR(255) NOT NULL
    , ProductRetailPrice FLOAT NOT NULL
    , ProductWholesalePrice FLOAT NOT NULL
    , ProductCost FLOAT NOT NULL
    , ProductRetailProfit FLOAT NOT NULL
    , ProductWholesaleUnitProfit FLOAT NOT NULL
    , ProductProfitMarginUnitPercent FLOAT NOT NULL
); 
--Load unknown product
INSERT INTO PUBLIC.DIM_PRODUCT (
    DimProductID
    , ProductID
    , ProductTypeID
    , ProductCategoryID
    , ProductName
    , ProductType
    , ProductCategory 
    , ProductRetailPrice
    , ProductWholesalePrice
    , ProductCost
    , ProductRetailProfit
    , ProductWholesaleUnitProfit
    , ProductProfitMarginUnitPercent
)
VALUES (
    -1
    ,-1
    , -1
    , -1
    , 'NULL'
    , 'NULL'
    , 'NULL'
    , -1
    , -1
    , -1
    , -1
    , -1
    , -1
)
--Load product data
INSERT INTO PUBLIC.DIM_PRODUCT (
     ProductID
    , ProductTypeID
    , ProductCategoryID
    , ProductName
    , ProductType
    , ProductCategory 
    , ProductRetailPrice
    , ProductWholesalePrice
    , ProductCost
    , ProductRetailProfit
    , ProductWholesaleUnitProfit
    , ProductProfitMarginUnitPercent
)
SELECT DISTINCT
     A.ProductID
    , A.ProductTypeID 
    , C.ProductCategoryID
    , Product
    , C.ProductType
    , D.ProductCategory
    , Price 
    , WholesalePrice 
    , Cost 
    , Price - Cost
    , WholesalePrice - Cost
    , (Price - Cost)/Price * 100
FROM STAGE_PRODUCT A
LEFT JOIN STAGE_PRODUCTTYPE C
ON A.ProductTypeID = C.ProductTypeID
JOIN STAGE_PRODUCTCATEGORY D
ON C.ProductCategoryID = D.ProductCategoryID
