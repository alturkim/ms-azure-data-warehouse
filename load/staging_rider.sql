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


CREATE EXTERNAL TABLE dbo.staging_rider (
    [rider_id] bigint,
    [first] nvarchar(4000),
    [last] nvarchar(4000),
    [address] nvarchar(4000),
    [birthday] varchar(50),
    [account_start_date] varchar(50),
    [account_end_date] varchar(50),
    [member] bit
    )
    WITH (
    LOCATION = 'publicrider.csv',
    DATA_SOURCE = [demanddlfs_demanddlacc_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
    )
GO

