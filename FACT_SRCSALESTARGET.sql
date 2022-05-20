--CREATE TABLE FACT_SRCSALESTARGET
CREATE OR REPLACE TABLE PUBLIC.FACT_SRCSALESTARGET (
    DimStoreID INTEGER CONSTRAINT FK_DimStoreIDStore FOREIGN KEY REFERENCES PUBLIC.Dim_Store (DimStoreID) NOT NULL 
    , DimResellerID INTEGER CONSTRAINT FK_DimResellerIDReseller FOREIGN KEY REFERENCES PUBLIC.Dim_Reseller (DimResellerID) NOT NULL 
    , DimChannelID INTEGER CONSTRAINT FK_DimChannelIDChannel FOREIGN KEY REFERENCES PUBLIC.Dim_Channel (DimChannelID) NOT NULL 
    , DimTargetDateID number(9) CONSTRAINT FK_DimTargetDateIDDDate FOREIGN KEY REFERENCES PUBLIC.Dim_Date (DATE_PKEY) NOT NULL
    , SaleTargetAmount FLOAT NOT NULL
); 
--Load unknown SRCSALESTARGET
INSERT INTO PUBLIC.FACT_SRCSALESTARGET (
    DimStoreID
    , DimResellerID
    , DimChannelID
    , DimTargetDateID
    , SaleTargetAmount
)
VALUES (
    -1
    ,-1
    , -1
    , -1
    , -1
)
--Load SRCSALESTARGET data
INSERT INTO PUBLIC.FACT_SRCSALESTARGET (
    DimStoreID
    , DimResellerID
    , DimChannelID
    , DimTargetDateID
    , SaleTargetAmount
)
SELECT COALESCE(B.DimStoreID, -1)
    , COALESCE(C.DimResellerID, -1)
    , D.DimChannelID
    , E.DATE_PKEY
    , A.TARGETSALESAMOUNT
     
FROM 
(SELECT YEAR, CASE WHEN CHANNELNAME = 'Online' THEN 'On-line' ELSE CHANNELNAME END AS CHANNELNAME,
CASE WHEN TARGETNAME = 'Store Number 5' THEN '5' 
    WHEN TARGETNAME = 'Store Number 8' THEN '8' 
    WHEN TARGETNAME = 'Store Number 10' THEN '10' 
    WHEN TARGETNAME = 'Store Number 21' THEN '21'
    WHEN TARGETNAME = 'Store Number 34' THEN '34' 
    WHEN TARGETNAME = 'Store Number 39' THEN '39' ELSE TARGETNAME END AS TARGETNAME,
TARGETSALESAMOUNT FROM STAGE_TARGETDATACHANNELRESELLERSTORE) A
LEFT JOIN PUBLIC.DIM_STORE B ON A.TARGETNAME = CAST(B.STOREID AS VARCHAR)
LEFT JOIN PUBLIC.DIM_RESELLER C ON A.TARGETNAME = C.RESELLERNAME
LEFT JOIN PUBLIC.DIM_CHANNEL D ON A.CHANNELNAME = D.CHANNELNAME
LEFT JOIN PUBLIC.DIM_DATE E ON A.YEAR = CAST(E.YEAR AS VARCHAR)


