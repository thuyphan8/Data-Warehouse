--Create table DIM_LOCATION
CREATE OR REPLACE TABLE PUBLIC.DIM_LOCATION (
    DimLocationID INT IDENTITY(1,1) CONSTRAINT PK_DimLocationID PRIMARY KEY NOT NULL
    , SourceLocationID VARCHAR(255) NOT NULL
    , PostalCode VARCHAR(255) NOT NULL
    , Address VARCHAR(255) NOT NULL
    , City VARCHAR(255) NOT NULL
    , State VARCHAR(255) NOT NULL
    , Region VARCHAR(255) NOT NULL
    , Country VARCHAR(255) NOT NULL
);
--Load unknown location
INSERT INTO PUBLIC.DIM_LOCATION (
    DimLocationID
    , SourceLocationID
    , PostalCode
    , Address
    , City
    , State
    , Region
    , Country
)
VALUES (
    -1
    , 'NULL'
    , 'NULL'
    , 'NULL'
    , 'NULL'
    , 'NULL'
    , 'NULL'
    , 'NULL'
)
--Load location
INSERT INTO PUBLIC.DIM_LOCATION (
    SourceLocationID
    , PostalCode
    , Address
    , City
    , State
    , Region
    , Country
)
SELECT cast(StoreID as varchar) as SourceLocationID
    , PostalCode
    , Address
    , City
    , STATEPROVINCE 
    , CASE WHEN STATEPROVINCE IN ('Iowa', 'Illinois', 'Indiana', 'Kansas', 'Michigan', 
    'Minnesota', 'Missouri', 'North Dakota', 'Nebraska', 'Ohio', 'South Dakota', 'Wisconsin')
    THEN 'Midwest'
    WHEN STATEPROVINCE IN ('Connecticut', 'Massachusetts', 'Maine', 'New Hampshire', 
    'New Jersey', 'New York', 'Pennsylvania', 'Rhode Island', 'Vermont')
    THEN 'Northeast'
    WHEN STATEPROVINCE IN ('Alabama', 'Arkansas', 'District of Columbia', 'Delaware', 
    'Florida', 'Georgia', 'Kentucky', 'Louisiana', 'Maryland', 'Mississippi', 'North Carolina', 
    'Oklahoma', 'South Carolina', 'Tennessee', 'Texas', 'Virginia', 'West Virginia')
    THEN 'South'
    WHEN STATEPROVINCE IN ('Alaska', 'Arizona', 'California', 'Colorado', 'Hawaii', 'Idaho', 
    'Montana', 'New Mexico', 'Nevada', 'Oregon', 'Utah', 'Washington', 'Wyoming')
    THEN 'West' end as REGION
    , Country
from PUBLIC.STAGE_STORE
UNION ALL
SELECT ResellerID as SourceLocationID
    , PostalCode
    , Address
    , City
    , STATEPROVINCE 
    , CASE WHEN STATEPROVINCE IN ('Iowa', 'Illinois', 'Indiana', 'Kansas', 'Michigan', 
    'Minnesota', 'Missouri', 'North Dakota', 'Nebraska', 'Ohio', 'South Dakota', 'Wisconsin')
    THEN 'Midwest'
    WHEN STATEPROVINCE IN ('Connecticut', 'Massachusetts', 'Maine', 'New Hampshire', 
    'New Jersey', 'New York', 'Pennsylvania', 'Rhode Island', 'Vermont')
    THEN 'Northeast'
    WHEN STATEPROVINCE IN ('Alabama', 'Arkansas', 'District of Columbia', 'Delaware', 
    'Florida', 'Georgia', 'Kentucky', 'Louisiana', 'Maryland', 'Mississippi', 'North Carolina', 
    'Oklahoma', 'South Carolina', 'Tennessee', 'Texas', 'Virginia', 'West Virginia')
    THEN 'South'
    WHEN STATEPROVINCE IN ('Alaska', 'Arizona', 'California', 'Colorado', 'Hawaii', 'Idaho', 
    'Montana', 'New Mexico', 'Nevada', 'Oregon', 'Utah', 'Washington', 'Wyoming')
    THEN 'West' end as REGION
    , Country
from PUBLIC.STAGE_RESELLER
UNION ALL
SELECT CustomerID as SourceLocationID
    , PostalCode
    , Address
    , City
    , STATEPROVINCE 
    , CASE WHEN STATEPROVINCE IN ('Iowa', 'Illinois', 'Indiana', 'Kansas', 'Michigan', 
    'Minnesota', 'Missouri', 'North Dakota', 'Nebraska', 'Ohio', 'South Dakota', 'Wisconsin')
    THEN 'Midwest'
    WHEN STATEPROVINCE IN ('Connecticut', 'Massachusetts', 'Maine', 'New Hampshire', 
    'New Jersey', 'New York', 'Pennsylvania', 'Rhode Island', 'Vermont')
    THEN 'Northeast'
    WHEN STATEPROVINCE IN ('Alabama', 'Arkansas', 'District of Columbia', 'Delaware', 
    'Florida', 'Georgia', 'Kentucky', 'Louisiana', 'Maryland', 'Mississippi', 'North Carolina', 
    'Oklahoma', 'South Carolina', 'Tennessee', 'Texas', 'Virginia', 'West Virginia')
    THEN 'South'
    WHEN STATEPROVINCE IN ('Alaska', 'Arizona', 'California', 'Colorado', 'Hawaii', 'Idaho', 
    'Montana', 'New Mexico', 'Nevada', 'Oregon', 'Utah', 'Washington', 'Wyoming')
    THEN 'West' end as REGION
    , Country
from PUBLIC.STAGE_CUSTOMER

