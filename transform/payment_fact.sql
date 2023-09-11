IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat')
    CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat]
    WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
           FORMAT_OPTIONS (
             FIELD_TERMINATOR = ',',
             USE_TYPE_DEFAULT = FALSE
            ))
GO


IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'demanddlfs_demanddlacc_dfs_core_windows_net')
    CREATE EXTERNAL DATA SOURCE [demanddlfs_demanddlacc_dfs_core_windows_net]
    WITH (
        LOCATION = 'abfss://demanddlfs@demanddlacc.dfs.core.windows.net'
    )
GO


IF OBJECT_ID('dbo.payment_fact') IS NOT NULL
BEGIN
    DROP EXTERNAL TABLE [dbo].[payment_fact];
END


CREATE EXTERNAL TABLE dbo.payment_fact
WITH (
    LOCATION     = 'payment_fact',
    DATA_SOURCE = [demanddlfs_demanddlacc_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT [payment_id],
       [amount],
       CONVERT(CHAR(8), REPLACE([date], '-', ''), 112) AS date_id,
       [rider_id],
       [end_station_id] AS station_id
FROM [dbo].[staging_payment]
JOIN [dbo].[staging_trip] AS t
ON rider_id= t.rider_id


;
GO