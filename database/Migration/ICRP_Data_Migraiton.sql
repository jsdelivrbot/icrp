-----------------------------
-- Country
-----------------------------
INSERT INTO Country
(Abbreviation, Name)
SELECT ABBREVIATION, name
FROM icrp.dbo.COUNTRY

-----------------------------
-- State
-----------------------------
INSERT INTO State
(Abbreviation, Name, Country)
SELECT ABBREVIATION, name, COUNTRY
FROM icrp.dbo.State

-----------------------------
-- ProjectGroup
-----------------------------
--INSERT INTO ProjectGroup ([Group]) VALUES ('Childhood')
--INSERT INTO ProjectGroup ([Group]) VALUES ('Adolescents')
--INSERT INTO ProjectGroup ([Group]) VALUES ('Adult')


-----------------------------
-- ProjectType
-----------------------------
INSERT INTO ProjectType
(ProjectType)
SELECT Type
FROM icrp.dbo.PROJECTTYPE

-----------------------------
-- CSOCategory
-----------------------------
INSERT INTO CSOCategory
(Name, Code)
SELECT DISTINCT category, categoryCode from icrp.dbo.CSO order by categoryCode

-----------------------------
-- CSO
-----------------------------
INSERT INTO CSO
(Code, Name, ShortName, CategoryName, WeightName,SortOrder)
SELECT DISTINCT code, name, ShortName, Category, WEIGHTNAME, SortOrder from icrp.dbo.CSO order by code

-----------------------------
-- CancerType
-----------------------------
INSERT INTO CancerType
(Name, ICRPCode, SiteURL, IsCommon, IsArchived, SortOrder)
SELECT DISTINCT name, mappedID, 
	CASE URL WHEN '' THEN NULL ELSE URL END AS SiteURL,
	ISCOMMON, ISARCHIVED, SORTORDER from icrp.dbo.SITE order by mappedid

-----------------------------
-- PrjectAbstract
-----------------------------
SET IDENTITY_INSERT ProjectAbstract ON;  -- SET IDENTITY_INSERT to ON. 
GO  

INSERT INTO ProjectAbstract
(ProjectAbstractID, TechAbstract, PublicAbstract, CreatedDate, UpdatedDate)
SELECT DISTINCT ID, techAbstract, publicAbstract, dateadded, lastrevised
	from icrp.dbo.Abstract order by id

SET IDENTITY_INSERT ProjectAbstract OFF;   -- SET IDENTITY_INSERT to OFF. 
GO  

-----------------------------
-- Currency - De-dup...
-----------------------------
INSERT INTO Currency
(Code, Description, SortOrder)
SELECT Currency, min(CURRENCYDESC), min(sortorder) as sortorder
	from icrp.dbo.CURRENCIES group by CURRENCY order by sortorder

-----------------------------
-- CurrencyRate
-----------------------------
INSERT INTO CurrencyRate
(YearOld, FromCurrency, FromCurrencyRate, ToCurrency, ToCurrencyRate, year)
SELECT year_old, FromCurrency, FromCurrencyRate, ToCurrency, ToCurrencyRate, year
	from icrp.dbo.CURRENCYRATE order by year

	
-----------------------------
-- Institution
-----------------------------
INSERT INTO Institution
(Name, City, State, Country)
SELECT DISTINCT institution, ISNULL(city, ''), ISNULL(state,''), ISNULL(country, '')
FROM icrp.dbo.Project
WHERE ISNULL(institution,'') <> ''
ORDER BY institution

--delete FROM Institution
--DBCC CHECKIDENT ('[Institution]', RESEED, 0)



-----------------------------------------
-- Partners
-----------------------------------------
INSERT INTO Partner 
SELECT NULL,[NMPARTNER],[TXTPARTNER],ISNULL(s.code, ''), s.email, p.[COUNTRY],	p.[WEBSITE], p.[LOGO],p.[DISPLAYID],
p.[displayURL],p.[MAPCOORDS], '', NULL, getdate(), getdate()
FROM icrp.dbo.tblPARTNERS p
LEFT JOIN icrp.dbo.sponsor s ON p.NMPARTNER = s.NAME

UPDATE Partner SET SponsorCode = 'INCa', EMail='recherche@institutcancer.fr' WHERE name = 'French National Cancer Institute'
UPDATE Partner SET SponsorCode = 'KWF', EMail='poz@kwfkankerbestrijding.nl' WHERE name = 'Dutch Cancer Society'
UPDATE Partner SET SponsorCode = 'CDMRP', EMail='cdmrp.pa@det.amedd.army.mil' WHERE name = 'Congressionally Directed Medical Research Programs'
UPDATE Partner SET SponsorCode = 'AVONFDN', EMail='info@avonfoundation.org' WHERE name = 'AVON Foundation'
UPDATE Partner SET SponsorCode = 'NCC', EMail=NULL WHERE name = 'National Cancer Center'

UPDATE Partner SET JoinedDate = o.JOINDATE
FROM Partner p
left join (SELECT SponsorCode, min(JOINDATE) AS JOINDATE FROM icrp.dbo.tblORG group by SponsorCode) o ON p.SponsorCode = o.SPONSORCODE

-----------------------------
-- FundingOrg
-----------------------------
SET IDENTITY_INSERT FundingOrg ON;  -- SET IDENTITY_INSERT to ON. 
GO 

INSERT INTO FundingOrg
(FundingOrgID, PartnerID, Name, [Abbreviation], [Country], [CURRENCY], [SponsorCode], [MemberType],[MemberStatus],[ISANNUALIZED],
LastImportDate, CreatedDate, UpdatedDate)
SELECT ID, 1, NAME, [ABBREVIATION],
	CASE [COUNTRY] WHEN 'UK' THEN 'GB' ELSE country END AS Country, 
	[CURRENCY], [SponsorCode], '', NULL, [ISANNUALIZED],[LASTDATAIMPORT], [DATEADDED], [LASTREVISED]
FROM icrp.dbo.fundingorg

SET IDENTITY_INSERT FundingOrg OFF;  -- SET IDENTITY_INSERT to ON. 
GO 


UPDATE FundingOrg SET PartnerID = p.PartnerID
FROM  FundingOrg f
LEFT JOIN Partner p ON f.SponsorCode = p.SponsorCode

UPDATE FundingOrg SET MemberType = CASE ISNULL(p.Name, '') WHEN '' THEN 'Associate' ELSE 'Partner' END, MemberStatus='Current'
FROM  FundingOrg f
LEFT JOIN Partner p ON f.Name = p.Name


UPDATE FundingOrg SET IsDSASigned = o.DSASIGNED
FROM FundingOrg f
LEFT JOIN icrp.dbo.tblORG o ON f.Name = o.Name

--select * from  FundingOrg where IsDSASigned is null (Check later)

-----------------------------
-- FundingDivision
-----------------------------
INSERT INTO FundingDivision
(FundingOrgID, Name, [Abbreviation], CreatedDate, UpdatedDate)
SELECT FundingOrgID, NAME, [ABBREVIATION], [DATEADDED], [LASTREVISED]
FROM icrp.dbo.fundingdivision

----------------------------------------------------------------------------------
-- Only migrate the active projects 
----------------------------------------------------------------------------------
DECLARE @sortedProjects TABLE (
	[SortedProjectID] [int] IDENTITY(1,1) NOT NULL,
	[OldProjectID] [int] NOT NULL,
	[AwardCode] nvarchar(1000) NOT NULL
)

INSERT INTO @sortedProjects SELECT ID, COde FROM icrp.dbo.project ORDER BY code, DateStart, BUDGETSTARTDATE, ImportYear, ID

SELECT DISTINCT s.SortedProjectID, p.* INTO #activeProjects
FROM icrp.dbo.project p
JOIN @sortedProjects s ON p.id = s.OldProjectID
JOIN icrp.dbo.TestProjectActive a ON p.ID = a.projectID
ORDER BY s.SortedProjectID

----------------------------------------------------------------------------------
-- Fix NIH AwardCode First by strippong out leading and training characters
----------------------------------------------------------------------------------
/* Fix the NIH AwardCode */
UPDATE #activeProjects SET Code =
(case 	
	when INTERNALCODE like '%sub%' THEN left(internalcode, 8)
	when substring(internalcode, 13,1) = '-' THEN substring(internalcode, 5,8)
	when substring(internalcode, 9,1) = '-' THEN left(internalcode, 8)
	ELSE  internalcode 
END) 
FROM #activeProjects a
JOIN icrp.dbo.FundingOrg f ON a.FUNDINGORGID = f.ID
WHERE f.SponsorCode = 'NIH'

/* Not fixed NIH code */
--select * from #activeProjects a
--JOIN FundingOrg f ON a.FUNDINGORGID = f.ID
--where f.SponsorCode='nih' and  len(code) <> 8

-----------------------------
-- [Migration_Project]
-----------------------------
CREATE TABLE [dbo].[Migration_Project] (
	[ProjectID] [int] IDENTITY(1,1) NOT NULL,
	[OldProjectID] [int] NOT NULL,
	[AwardCode] nvarchar(1000) NOT NULL
)

-- Use AwardCode to group project (pull the oldest ProjectID - originally imported)
INSERT INTO [Migration_Project] ([OldProjectID], [AwardCode])		
	SELECT a.ID, bp.Code FROM (SELECT code, MIN(SortedProjectID) AS SortedProjectID FROM #activeProjects GROUP BY code) bp
	JOIN #activeProjects a ON bp.SortedProjectID = a.SortedProjectID	

-----------------------------
-- Project
-----------------------------
SET IDENTITY_INSERT Project ON;  -- SET IDENTITY_INSERT to ON. 
GO 

INSERT INTO Project  
(ProjectID, [AwardCode], [IsFunded],[ProjectStartDate],[ProjectEndDate],[CreatedDate],[UpdatedDate])
SELECT bp.ProjectID, p.code, p.[IsFunded], p.[DateStart], p.[DateEnd], p.[DATEADDED], p.[LASTREVISED]
FROM #activeProjects p
	JOIN Migration_Project bp ON p.id = bp.OldProjectID		
ORDER BY bp.ProjectID

SET IDENTITY_INSERT Project OFF;  -- SET IDENTITY_INSERT to ON. 
GO 

--delete from Project
--DBCC CHECKIDENT ('[Project]', RESEED, 0)

--------------------------------------------------------------------------------------------
-- ProjectDocument  - TBD: change to save the most recent project content/abstract?
--------------------------------------------------------------------------------------------
INSERT INTO ProjectDocument
(ProjectID, [Content])
SELECT m.[ProjectID], s.[Text]
FROM icrp.dbo.search s
	JOIN Migration_Project m ON s.ProjectID = m.OldProjectID

--------------------------------------------------------------------------------------------
-- ProjectDocument_JP  - TBD: change to save the most recent project content/abstract?
--------------------------------------------------------------------------------------------
INSERT INTO ProjectDocument_JP
(ProjectID, [Content])
SELECT m.[ProjectID], s.[Text]
FROM icrp.dbo.search_JP s
	JOIN Migration_Project m ON s.ProjectID = m.OldProjectID

-----------------------------
-- Project_ProjectType
-----------------------------
INSERT INTO Project_ProjectType
(ProjectID, ProjectType)
select np.projectid, projecttype 
FROM [Migration_Project] bp
	join #activeProjects p on bp.OldProjectID = p.id
	join project np ON np.ProjectID = bp.ProjectID

	--delete from Project_ProjectType

-----------------------------
-- [Migration_ProjectFunding]
-----------------------------
CREATE TABLE [dbo].[Migration_ProjectFunding](
	[ProjectFundingID] [int] IDENTITY(1,1) NOT NULL,
	[NewProjectID] [int] NOT NULL,
	[OldProjectID] [int] NOT NULL,
	[AbstractID] [int] NOT NULL,
	[Title] varchar(1000) NULL, 
	[Institution] varchar(250) NULL, 
	[city] varchar(250) NULL, 
	[state] varchar(250) NULL, 
	[country] varchar(250) NULL, 
	[piLastName] varchar(250) NULL,
	[piFirstName] varchar(250) NULL,
	[piORC_ID] varchar(250) NULL,
	[FundingOrgID] [int] NOT NULL,
	[FundingDivisionID] [int] NULL,
	[AwardCode] [varchar](500) NOT NULL,
	[AltAwardCode] [varchar](500) NOT NULL,
	[Source_ID] [varchar](50) NULL,
	[MechanismCode] [varchar](30) NULL,
	[MechanismTitle] [varchar](200) NULL,
	[Amount] [float] NULL,
	[IsAnnualized] [bit] NOT NULL,
	[BudgetStartDate] [date] NULL,
	[BudgetEndDate] [date] NULL,	
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL
)
GO


INSERT INTO [Migration_ProjectFunding] 
	([NewProjectID], [OldProjectID], [AbstractID], [Title],[Institution], [city], [state], [country], [piLastName], [piFirstName], [piORC_ID], [FundingOrgID], [FundingDivisionID], [AwardCode], [AltAwardCode],
	 [Source_ID], [MechanismCode], [MechanismTitle], [Amount], [IsAnnualized], [BudgetStartDate],	[BudgetEndDate], [CreatedDate],[UpdatedDate])
SELECT mp.ProjectID, op.ID, op.abstractID, op.title, op.institution, op.city, op.state, op.country, op.piLastName, op.piFirstName,  op.piORCiD,op.FUNDINGORGID, op.FUNDINGDIVISIONID, 
		op.code, op.altid, op.SOURCE_ID, m.SPONSORCODE,  m.TITLE, pf.AMOUNT, 
		CASE WHEN [Amount] = [AnnualizedAmount] THEN 1 ELSE 0 END AS [IsAnnualized],
		op.BUDGETSTARTDATE, op.budgetenddate, op.[DATEADDED], op.[LASTREVISED]
FROM #activeProjects op   -- active projects from old icrp database
	 LEFT JOIN icrp.dbo.ProjectFunding pf ON op.ID = pf.ProjectID
	 LEFT JOIN icrp.dbo.Mechanism m ON m.ID = op.MechanismID
	 LEFT JOIN Migration_Project mp ON mp.AwardCode = op.code	 	 
ORDER BY mp.ProjectID, op.sortedProjectID
 
-----------------------------
-- ProjectFunding
-----------------------------
SET IDENTITY_INSERT ProjectFunding ON;  -- SET IDENTITY_INSERT to ON. 
GO 

INSERT INTO ProjectFunding 
([ProjectFundingID], [ProjectAbstractID], [Title],[ProjectID], [FundingOrgID], [FundingDivisionID], [AltAwardCode],	[Source_ID], [MechanismCode],[MechanismTitle],[Amount], [IsAnnualized], [BudgetStartDate],	[BudgetEndDate], [CreatedDate],[UpdatedDate])
SELECT [ProjectFundingID],[AbstractID], [Title], [NewProjectID], [FundingOrgID], [FundingDivisionID], [ALtAwardCode], [Source_ID],[MechanismCode], [MechanismTitle],[Amount], [IsAnnualized], [BudgetStartDate],	[BudgetEndDate], [CreatedDate],[UpdatedDate]
FROM [Migration_ProjectFunding]

SET IDENTITY_INSERT ProjectFunding OFF;  -- SET IDENTITY_INSERT to ON. 
GO 

--delete from ProjectFunding
--DBCC CHECKIDENT ('[ProjectFunding]', RESEED, 0)
--select * from ProjectFunding  --200805

	 
-----------------------------
-- ProjectCSO
-----------------------------
INSERT INTO ProjectCSO
(ProjectFundingID, [CSOCode],[Relevance],[RelSource],[CreatedDate],[UpdatedDate])
SELECT mf.[ProjectFundingID], c.Code, pc.[RELEVANCE], pc.[RELSOURCE], pc.[DATEADDED], pc.[LASTREVISED]
FROM icrp.dbo.projectCSO pc
	JOIN [Migration_ProjectFunding] mf ON pc.PROJECTID = mf.OldProjectID	
	JOIN icrp.dbo.CSO c ON pc.CSOID = c.id  -- 187005	

--delete from ProjectCSO
--DBCC CHECKIDENT ('[ProjectCSO]', RESEED, 0)
	

-----------------------------
-- ProjectCancerType
-----------------------------
INSERT INTO ProjectCancerType
(ProjectFundingID, CancerTypeID, Relevance, RelSource, EnterBy)
SELECT mf.[ProjectFundingID], c.CancerTypeID, ps.RELEVANCE, ps.RELSOURCE, ps.ENTEREDBY 
FROM icrp.dbo.PROJECTSITE ps	
	JOIN [Migration_ProjectFunding] mf ON ps.PROJECTID = mf.OldProjectID	
	JOIN icrp.dbo.SITE s ON ps.SITEID = s.ID
	JOIN CancerType c ON s.Name = c.NAME

-----------------------------
-- ProjectFundingExt
-----------------------------
INSERT INTO ProjectFundingExt
([ProjectID], [AncestorProjectID], [CalendarYear], [CalendarAmount])
SELECT p.[ProjectID], a.[ProjectIDANCESTOR], a.[YEAR], a.[CALENDARAMOUNT_V2]
FROM icrp.dbo.[TestProjectActive] a
JOIN Migration_Project p ON a.PROJECTID = p.OldProjectID

--delete from ProjectFundingExt
--DBCC CHECKIDENT ('[ProjectFundingExt]', RESEED, 0)
--select * from ProjectFundingExt  --200805

-----------------------------------------
-- ProjectFunding_Investigator (check investigator)
-----------------------------------------
INSERT INTO ProjectFundingInvestigator 
([ProjectFundingID], [LastName], [FirstName], [ORC_ID], [InstitutionID], IsPrivateInvestigator)
SELECT distinct f.ProjectFundingID, ISNULL(f.piLastName, ''), f.piFirstName, f.piORC_ID, inst.InstitutionID, 1 AS IsPrivateInvestigator
FROM [Migration_ProjectFunding] f
	 LEFT JOIN Institution inst ON inst.name = f.Institution AND 
									(ISNULL(f.city, '') = ISNULL(inst.city, '')) AND 
									(ISNULL(f.state, '') = ISNULL(inst.state, '')) AND
									(ISNULL(f.country, '') = ISNULL(inst.country, ''))	  --200774	
WHERE inst.InstitutionID IS NOT NULL



-----------------------------------------
-- LibraryFolder
-----------------------------------------
SET IDENTITY_INSERT LibraryFolder ON;  -- SET IDENTITY_INSERT to ON. 
GO  

INSERT INTO LibraryFolder ([LibraryFolderID],[Name],[ParentFolderID],[IsPublic],[ArchivedDate],[CreatedDate],[UpdatedDate])
SELECT FID, [FOLDERNAME],[PARENTFOLDERID],0, 
CASE isArchived WHEN 1 THEN  getdate() ELSE NULL END AS [ArchivedDate], 
getdate(),getdate()
FROM icrp.dbo.tblFILEFOLDERS

SET IDENTITY_INSERT FundingOrg OFF;  -- SET IDENTITY_INSERT to ON. 
GO  
-----------------------------------------
-- Library
-----------------------------------------
INSERT INTO Library 
SELECT [FID],[FILENAME],'', [FILETITLE],[DESCRIPTION], 0, [DATEARCHIVED],getdate(), getdate()
FROM icrp.dbo.tblLIBRARY

----------------------------
-- CancerType Description
-----------------------------
CREATE TABLE #CancerType (		
	[ICRPCode] VARCHAR(10),	
	[ICD10CodeInfo] NVARCHAR(250),
	[Description] VARCHAR(1000)
)
GO

BULK INSERT #CancerType
FROM 'C:\icrp\database\Migration\CancerType.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO

UPDATE CancerType Set [Description] = t.[Description], [ICD10CodeInfo]=t.[ICD10CodeInfo]
FROM CancerType c
JOIN #CancerType t ON c.ICRPCode = CAST(t.[ICRPCode] AS INT)


----------------------------
-- Institution
-----------------------------
--CREATE TABLE Institution_Temp (	
--	[Name] VARCHAR(1000),
--	[City_ICRP] VARCHAR(1000),
--	[City_ICRP_Correciton] VARCHAR(1000),
--	[State_ICRP] VARCHAR(1000),
--	[State_ICRP_Correction] VARCHAR(1000),
--	[Country_ICRP] VARCHAR(1000),
--	[Country_ICRP_Correction] VARCHAR(1000),
--	[DeDup_Institution] VARCHAR(1000),
--	[Grid_Name] VARCHAR(1000),
--	[Grid_City] VARCHAR(1000),
--	[Grid_Country] VARCHAR(1000),
--	[ISO_Country] VARCHAR(1000),
--	[Grid_ID] VARCHAR(1000),
--	[Grid_Lat] VARCHAR(1000),
--	[Grid_Lng] VARCHAR(1000)
--)
--GO

--BULK INSERT Institution_Temp
--FROM 'C:\Developments\icrp\database\Migration\Institution.csv'
--WITH
--(
--	FIRSTROW = 2,
--	FIELDTERMINATOR = ',',
--	ROWTERMINATOR = '\n'
--)
--GO


-----------------------------
-- Country Income Band
-- High income - H
-- Low income  - L
-- Lower middle income - ML
-- Upper middle income - MU
--    42 COUNTRIES HAVE NO INCOME BAND
-----------------------------
CREATE TABLE #CountryCodeMapping (	
	Two VARCHAR(2),
	Three VARCHAR(3)
)
GO

BULK INSERT #CountryCodeMapping
FROM 'C:\icrp\database\Migration\CountryCodeMapping.csv'
WITH
(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
)
GO

CREATE TABLE #IncomeBand(	
	CountryCode VARCHAR(10),
	IncomeGroup VARCHAR(50)
)
GO

BULK INSERT #IncomeBand
FROM 'C:\icrp\database\Migration\IncomeBand.csv'
WITH
(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
)
GO

Update Country Set IncomeBand =
	CASE i.IncomeGroup
		 WHEN 'High income' THEN 'H'
		 WHEN 'Low income' THEN 'L'
		 WHEN 'Lower middle income' THEN 'ML'
		 WHEN 'Upper middle income' THEN 'MU'
		 ELSE NULL END 
FROM Country c
JOIN #CountryCodeMapping m ON c.Abbreviation = m.two
JOIN #IncomeBand i ON m.three = i.CountryCode

