/*************************************************/
/******	NEW TABLE            				******/
/*************************************************/ 
IF object_id('[DataUploadCompleteness]') is null  
BEGIN
	
	CREATE TABLE [dbo].[DataUploadCompleteness](
		[DataUploadCompletenessID] [int] IDENTITY(1,1) NOT NULL,
		[FundingOrgID] [int] NOT NULL,
		[FundingOrgAbbrev] [varchar](15) NOT NULL,
		[Year] [int] NOT NULL,
		[Status] [int] NULL,
		[CreatedDate] [datetime] NOT NULL,
		[UpdatedDate] [datetime] NOT NULL,
	 CONSTRAINT [PK_DataUploadCompleteness] PRIMARY KEY CLUSTERED 
	(
		[DataUploadCompletenessID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
	) ON [PRIMARY]

END
GO

/*************************************************/
/******		UPDATE TABLE        			******/
/*************************************************/


/*************************************************/
/******					Data				******/
/*************************************************/
truncate table [DataUploadCompleteness]
GO
	
INSERT INTO [DataUploadCompleteness] ([FundingOrgID]
    ,[FundingOrgAbbrev]  
	,[Year]          
    ,[CreatedDate]
    ,[UpdatedDate])
SELECT f.FundingOrgID, f.FundingOrgAbbrev, y.Year, getdate(), getdate()
	FROM (SELECT DISTINCT FundingOrgID, Abbreviation AS FundingOrgAbbrev FROM FundingOrg) f
	FULL OUTER JOIN (SELECT DISTINCT  CalendarYear AS Year FROM ProjectFundingExt) y ON 1=1
ORDER BY f.FundingOrgAbbrev, y.Year

/*************************************************/
/******					Keys				******/
/*************************************************/


/*************************************************/
/******	 Obsolete SPs						******/
/*************************************************/

