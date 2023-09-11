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

IF OBJECT_ID('dbo.dimDate') IS NOT NULL
BEGIN
    DROP EXTERNAL TABLE [dbo].[dimDate];
END


CREATE EXTERNAL TABLE dbo.dimDate
WITH (
    LOCATION     = 'dimDate',
    DATA_SOURCE = [demanddlfs_demanddlacc_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT DISTINCT(CONVERT(CHAR(8), REPLACE([account_start_date], '-', ''), 112)) AS date_id,
       CONVERT(DATE, [account_start_date])                     AS date,
       YEAR([account_start_date])                              AS year,    
       MONTH([account_start_date])                             AS month,
       DAY([account_start_date])                               AS day
FROM [dbo].[staging_rider]
UNION
SELECT DISTINCT(CONVERT(CHAR(8), REPLACE([account_end_date], '-', ''), 112)) AS date_id,
       CONVERT(DATE, [account_end_date])                     AS date,
       YEAR([account_end_date])                              AS year,    
       MONTH([account_end_date])                             AS month,
       DAY([account_end_date])                               AS day
FROM [dbo].[staging_rider]
UNION
SELECT DISTINCT(CONVERT(CHAR(8), REPLACE([started_at], '-', ''), 112)) AS date_id,
       CONVERT(DATE, [started_at])                     AS date,
       YEAR([started_at])                              AS year,    
       MONTH([started_at])                             AS month,
       DAY([started_at])                               AS day
FROM [dbo].[staging_trip]
UNION
SELECT DISTINCT(CONVERT(CHAR(8), REPLACE([ended_at], '-', ''), 112)) AS date_id,
       CONVERT(DATE, [ended_at])                     AS date,
       YEAR([ended_at])                              AS year,    
       MONTH([ended_at])                             AS month,
       DAY([ended_at])                               AS day
FROM [dbo].[staging_trip]
UNION
SELECT DISTINCT(CONVERT(CHAR(8), REPLACE([date], '-', ''), 112)) AS date_id,
       CONVERT(DATE, [date])                     AS date,
       YEAR([date])                              AS year,    
       MONTH([date])                             AS month,
       DAY([date])                               AS day
FROM [dbo].[staging_payment]


;
GO