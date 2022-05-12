--CREATE TABLE DIM_CHANNEL
CREATE OR REPLACE TABLE PUBLIC.DIM_CHANNEL (
    DimChannelID INT IDENTITY(1,1) CONSTRAINT PK_DimChannelID PRIMARY KEY NOT NULL
    , ChannelID INT NOT NULL
    , ChannelCategoryID INT NOT NULL
    , ChannelName VARCHAR(255) NOT NULL
    , ChannelCategory VARCHAR(255) NOT NULL
);
--Load unknown channel
INSERT INTO PUBLIC.DIM_CHANNEL (
    DimChannelID
    , ChannelID
    , ChannelCategoryID
    , ChannelName
    , ChannelCategory
)
VALUES (
    -1
    ,-1
    , -1
    , 'NULL'
    , 'NULL'
)
--Load channel data
INSERT INTO PUBLIC.DIM_CHANNEL (
    ChannelID
    , ChannelCategoryID
    , ChannelName
    , ChannelCategory
)
SELECT 
    ChannelID
    , A.ChannelCategoryID
    , Channel
    , B.ChannelCategory
FROM STAGE_CHANNEL A
LEFT JOIN STAGE_CHANNELCATEGORY B
ON A.ChannelCategoryID = B.ChannelCategoryID
