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


IF OBJECT_ID('dbo.dimRider') IS NOT NULL
BEGIN
    DROP EXTERNAL TABLE [dbo].[dimRider];
END


CREATE EXTERNAL TABLE dbo.dimRider
WITH (
    LOCATION     = 'dimRider',
    DATA_SOURCE = [demanddlfs_demanddlacc_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT [rider_id],
       DATEDIFF(year, birthday, account_start_date) AS rider_age_account_start,
       member
FROM [dbo].[staging_rider]
;
GO