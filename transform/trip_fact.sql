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


IF OBJECT_ID('dbo.trip_fact') IS NOT NULL
BEGIN
    DROP EXTERNAL TABLE [dbo].[trip_fact];
END


CREATE EXTERNAL TABLE dbo.trip_fact
WITH (
    LOCATION     = 'trip_fact',
    DATA_SOURCE = [demanddlfs_demanddlacc_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT [trip_id],
       DATEDIFF(MINUTE, started_at, ended_at) AS duration_min,
       DATEDIFF(year, r.birthday, started_at) AS rider_age,
       start_station_id,
       end_station_id,
       rider_id,
       CONVERT(CHAR(8), started_at, 112) AS date_id
FROM [dbo].[staging_trip]
JOIN [dbo].[staging_rider] AS r
ON rider_id=r.rider_id
;
GO
