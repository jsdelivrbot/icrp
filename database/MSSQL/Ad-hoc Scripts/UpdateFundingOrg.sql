--drop table #FundingOrg
--go
-----------------------------------------
-- Update FundingOrg
----------------------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #FundingOrg (	
	[Sponsor] [varchar](100) NOT NULL,	
	[Abbreviation] [varchar](100) NOT NULL,
	[Coordinates] [varchar](200) NULL	
)

GO

BULK INSERT #FundingOrg
FROM 'C:\icrp\database\DataImport\CurrentRelease\FundingOrgUpdates.csv'  
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

Select * from #FundingOrg

update #FundingOrg SET Coordinates = REPLACE(Coordinates, '"', '')

begin transaction

UPDATE FundingOrg SET 
	Latitude = CAST(LEFT(u.[Coordinates], CHARINDEX(',', u.[Coordinates])-1) AS DECIMAL(9,6)),
	Longitude = CAST(RIGHT(u.[Coordinates], len(u.[Coordinates]) - CHARINDEX(',', u.[Coordinates])) AS DECIMAL(9,6))	
FROM FundingOrg f
JOIN #FundingOrg u ON f.SponsorCode = u.Sponsor AND f.Abbreviation = u.Abbreviation
WHERE u.Coordinates <> '#N/A'

--commit
rollback

--select * from FundingOrg where latitude is not null
--select * from FundingOrg where latitude is null

--select * from #FundingOrg u
--JOIN FundingOrg f ON f.SponsorCode = u.Sponsor AND f.Abbreviation = u.Abbreviation
--where f.latitude is null 
