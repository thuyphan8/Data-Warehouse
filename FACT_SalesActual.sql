--CREATE TABLE FACT_SalesActual
CREATE OR REPLACE TABLE PUBLIC.FACT_SALESACTUAL (
    DimProductID INTEGER CONSTRAINT FK_DimProductIDProduct FOREIGN KEY REFERENCES PUBLIC.Dim_PRODUCT (DimProductID) NOT NULL 
    , DimStoreID INTEGER CONSTRAINT FK_DimStoreIDStore FOREIGN KEY REFERENCES PUBLIC.Dim_Store (DimStoreID) NOT NULL 
    , DimResellerID INTEGER CONSTRAINT FK_DimResellerIDReseller FOREIGN KEY REFERENCES PUBLIC.Dim_Reseller (DimResellerID) NOT NULL 
    , DimCustomerID INTEGER CONSTRAINT FK_DimCustomerIDCustomer FOREIGN KEY REFERENCES PUBLIC.Dim_Customer (DimCustomerID) NOT NULL 
    , DimChannelID INTEGER CONSTRAINT FK_DimChannelIDChannel FOREIGN KEY REFERENCES PUBLIC.Dim_Channel (DimChannelID) NOT NULL 
    , DimSaleDateID number(9) CONSTRAINT FK_DimSaleDateIDDate FOREIGN KEY REFERENCES PUBLIC.Dim_Date (DATE_PKEY) NOT NULL
    , DimLocationID INTEGER CONSTRAINT FK_DimLocationIDLocation FOREIGN KEY REFERENCES PUBLIC.Dim_LOCATION (DimLocationID) NOT NULL 
    , SalesHeaderID INT NOT NULL
    , SalesDetailID INT NOT NULL
    , SaleAmount FLOAT NOT NULL
    , SaleQuantity INT NOT NULL
    , SaleUnitPrice FLOAT NOT NULL
    , SaleExtendedCost FLOAT NOT NULL
    , SaleTotalProfit FLOAT NOT NULL
); 
--Load unknown SaleActual
INSERT INTO PUBLIC.FACT_SALESACTUAL (
    DimProductID
    , DimStoreID
    , DimResellerID
    , DimCustomerID
    , DimChannelID
    , DimSaleDateID
    , DimLocationID 
    , SalesHeaderID
    , SalesDetailID
    , SaleAmount
    , SaleQuantity
    , SaleUnitPrice
    , SaleExtendedCost
    , SaleTotalProfit
)
VALUES (
    -1
    ,-1
    , -1
    , -1
    , -1
    , -1
    , -1
    , -1
    , -1
    , -1
    , -1
    , -1
    , -1
    , -1
)
--Load SaleActual data
INSERT INTO PUBLIC.FACT_SALESACTUAL (
    DimProductID
    , DimStoreID
    , DimResellerID
    , DimCustomerID
    , DimChannelID
    , DimSaleDateID
    , DimLocationID 
    , SalesHeaderID
    , SalesDetailID
    , SaleAmount
    , SaleQuantity
    , SaleUnitPrice
    , SaleExtendedCost
    , SaleTotalProfit
)
SELECT 
     COALESCE(C.DimProductID, -1)
    , COALESCE(D.DimStoreID, -1)
    , COALESCE(E.DimResellerID, -1)
    , COALESCE(F.DimCustomerID, -1)
    , COALESCE(G.DimChannelID, -1)
    , COALESCE(H.DATE_PKEY, -1)
    , COALESCE(J.DIMLOCATIONID, -1)
    , COALESCE(A.SALESHEADERID, -1)
    , COALESCE(B.SALESDETAILID, -1)
    , B.SALESAMOUNT
    , B.SALESQUANTITY
    , CASE WHEN cast(B.SALESAMOUNT /  B.SALESQUANTITY as varchar) =  cast(C.ProductRetailPrice as varchar) THEN C.ProductRetailPrice 
           WHEN cast(B.SALESAMOUNT /  B.SALESQUANTITY as varchar) =  cast(C.ProductWholesalePrice as varchar) THEN C.ProductWholesalePrice end
    , B.SALESQUANTITY * C.ProductCost
    , B.SALESAMOUNT - (B.SALESQUANTITY * C.ProductCost)
FROM STAGE_SalesHeaderNew A
JOIN STAGE_SalesDetail B ON A.SALESHEADERID = B.SALESHEADERID
LEFT JOIN PUBLIC.DIM_PRODUCT C ON B.PRODUCTID = C.PRODUCTID
LEFT JOIN PUBLIC.DIM_STORE D ON A.STOREID = D.STOREID
LEFT JOIN PUBLIC.DIM_RESELLER E ON A.RESELLERID = E.RESELLERID
LEFT JOIN PUBLIC.DIM_CUSTOMER F ON A.CUSTOMERID = F.CUSTOMERID
LEFT JOIN PUBLIC.DIM_CHANNEL G ON A.CHANNELID = G.CHANNELID
LEFT JOIN PUBLIC.DIM_DATE H ON TO_DATE(A.DATE, 'mm/dd/yy') = H.DATE
LEFT JOIN PUBLIC.DIM_LOCATION J ON cast(D.STOREID as varchar) = J.SOURCELOCATIONID
        OR E.RESELLERID = J.SOURCELOCATIONID
        OR F.CUSTOMERID = J.SOURCELOCATIONID
