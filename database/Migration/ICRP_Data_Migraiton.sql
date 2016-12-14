Use ICRP_Data
GO

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
(Abbreviation, Name)
SELECT ABBREVIATION, name
FROM icrp.dbo.State

-----------------------------
-- ProjectGroup
-----------------------------
INSERT INTO ProjectGroup ([Group]) VALUES ('Childhood')
INSERT INTO ProjectGroup ([Group]) VALUES ('Adolescents')
INSERT INTO ProjectGroup ([Group]) VALUES ('Adult')

-----------------------------
-- InstitutionType
-----------------------------
INSERT INTO InstitutionType ([Type]) VALUES ('Academic')
INSERT INTO InstitutionType ([Type]) VALUES ('Government')
INSERT INTO InstitutionType ([Type]) VALUES ('Non-Profit')
INSERT INTO InstitutionType ([Type]) VALUES ('Industry')

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
(Name, Mapped_ID, SiteURL, IsCommon, IsArchived, SortOrder)
SELECT DISTINCT name, mappedID, 
	CASE URL WHEN '' THEN NULL ELSE URL END AS SiteURL,
	ISCOMMON, ISARCHIVED, SORTORDER from icrp.dbo.SITE order by mappedid

-----------------------------
-- PrjectAbstract
-----------------------------
SET IDENTITY_INSERT ProjectAbstract ON;  -- SET IDENTITY_INSERT to ON. 
GO  

INSERT INTO ProjectAbstract
(ProjectAbstractID,TechTitle, TechAbstract, PublicTitle, PublicAbstract, CreatedDate, UpdatedDate)
SELECT DISTINCT ID, TechTitle, techAbstract, publicTitle, publicAbstract, dateadded, lastrevised
	from icrp.dbo.Abstract order by id

SET IDENTITY_INSERT ProjectAbstract OFF;   -- SET IDENTITY_INSERT to OFF. 
GO  

-----------------------------
-- Sponsor
-----------------------------
INSERT INTO Sponsor
(Code, Name, Country, Email, DisplayAltID, AltIDName, CreatedDate, UpdatedDate)
SELECT CODE, Name, country, email, displayAltID, AltIDName, ISNULL(dateadded, getdate()), ISNULL(lastrevised, dateadded)
	from icrp.dbo.Sponsor order by code

	-----------------------------
-- FundingMechanism
-----------------------------
SET IDENTITY_INSERT FundingMechanism ON;  -- SET IDENTITY_INSERT to ON. 
GO  

INSERT INTO FundingMechanism
(FundingMechanismID, Title, DisplayName, SponsorCode, SponsorMechanism, SortOrder, CreatedDate, UpdatedDate)
SELECT ID, title, displayname, sponsorCODE, SPONSORMECHANISM, SORTORDER, ISNULL(dateadded, getdate()), ISNULL(lastrevised, dateadded)
	from icrp.dbo.MECHANISM order by id

SET IDENTITY_INSERT FundingMechanism OFF;  -- SET IDENTITY_INSERT to ON. 
GO  

-----------------------------
-- Currency - Dedup...
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
-----------------------------
-- FundingOrg
-----------------------------
SET IDENTITY_INSERT FundingOrg ON;  -- SET IDENTITY_INSERT to ON. 
GO  

INSERT INTO FundingOrg
(FundingOrgID, Name, [Abbreviation], [Country], [CURRENCY], [SponsorCode], [SortOrder],[ISANNUALIZED],[IsUseLatestFundingAmount],[LastImportDate], CreatedDate, UpdatedDate)
SELECT ID, NAME, [ABBREVIATION], 
	CASE [COUNTRY] WHEN 'UK' THEN 'GB' ELSE country END AS Country, 
	[CURRENCY], [SponsorCode], [SortOrder],[ISANNUALIZED],[USELATESTFUNDINGAMOUNTS],[LASTDATAIMPORT], [DATEADDED], [LASTREVISED]
FROM icrp.dbo.fundingorg

SET IDENTITY_INSERT FundingOrg OFF;  -- SET IDENTITY_INSERT to ON. 
GO  


-----------------------------
-- FundingDivision
-----------------------------
INSERT INTO FundingDivision
(FundingOrgID, Name, [Abbreviation], CreatedDate, UpdatedDate)
SELECT FundingOrgID, NAME, [ABBREVIATION], [DATEADDED], [LASTREVISED]
FROM icrp.dbo.fundingdivision


-----------------------------
-- [Migration_Project]
-----------------------------
CREATE TABLE [dbo].[Migration_Project] (
	[ProjectID] [int] IDENTITY(1,1) NOT NULL,
	[OldProjectID] [int] NOT NULL,
	[AwardCode] nvarchar(1000) NOT NULL
)


-- Use AwardCode to group project
INSERT INTO [Migration_Project] ([OldProjectID], [AwardCode])
SELECT min(id) as OldProjectID, code AS AwardCode
FROM icrp.dbo.project group by code  
ORDER BY OldProjectID  -- total: 122336


-----------------------------------------
-- ProjectDocument
-----------------------------------------
SET IDENTITY_INSERT ProjectDocument ON;  -- SET IDENTITY_INSERT to ON. 
GO

INSERT INTO ProjectDocument
(ProjectDocumentID, [Content])
SELECT m.[ProjectID], s.[Text]
FROM icrp.dbo.search s
	JOIN Migration_Project m ON s.ProjectID = m.OldProjectID

SET IDENTITY_INSERT ProjectDocument OFF;  -- SET IDENTITY_INSERT to ON. 
GO

-----------------------------
-- Project
-----------------------------
SET IDENTITY_INSERT Project ON;  -- SET IDENTITY_INSERT to ON. 
GO 

INSERT INTO Project  
(ProjectID, [ProjectGroupID], [ProjectDocumentID], [Title], [AwardCode],[ProjectAbstractID],[FundingMechanismID],[IsFunded],[ProjectStartDate],[ProjectEndDate],[CreatedDate],[UpdatedDate])
SELECT bp.ProjectID, NULL, d.[ProjectDocumentID], p.[Title], p.code, p.abstractId, p.MECHANISMID, p.[IsFunded], p.[DateStart], p.[DateEnd], p.[DATEADDED], p.[LASTREVISED]
FROM icrp.dbo.project p
	JOIN Migration_Project bp ON p.id = bp.OldProjectID
	LEFT JOIN ProjectDocument d ON bp.ProjectID = d.ProjectDocumentID
ORDER BY bp.ProjectID

SET IDENTITY_INSERT Project OFF;  -- SET IDENTITY_INSERT to ON. 
GO 

--delete from Project
--DBCC CHECKIDENT ('[Project]', RESEED, 0)
-----------------------------
-- ProjectCSO
-----------------------------
INSERT INTO ProjectCSO
(ProjectID, [CSOCode],[Relvance],[RelSource],[CreatedDate],[UpdatedDate])
SELECT p.ProjectID, c.Code, pc.[RELEVANCE], pc.[RELSOURCE], pc.[DATEADDED], pc.[LASTREVISED]
FROM icrp.dbo.projectCSO pc
	JOIN [Migration_Project] bp ON pc.PROJECTID = bp.OldProjectID	
	JOIN Project p ON p.ProjectID = bp.ProjectID
	JOIN icrp.dbo.CSO c ON pc.CSOID = c.id  -- 187005

--delete from ProjectCSO
--DBCC CHECKIDENT ('[ProjectCSO]', RESEED, 0)
	

-----------------------------
-- ProjectCancerType
-----------------------------
INSERT INTO ProjectCancerType
(ProjectID, CancerTypeID, Relvance, RelSource, EnterBy)
SELECT bp.ProjectID, c.CancerTypeID, ps.RELEVANCE, ps.RELSOURCE, ps.ENTEREDBY 
FROM icrp.dbo.PROJECTSITE ps
	JOIN icrp.dbo.SITE s ON ps.SITEID = s.ID
	JOIN Migration_Project bp ON bp.OldProjectID = ps.PROJECTID	
	JOIN CancerType c ON s.Name = c.NAME

-----------------------------
-- Project_ProjectType
-----------------------------
INSERT INTO Project_ProjectType
(ProjectID, ProjectType)
select np.projectid, projecttype 
FROM [Migration_Project] bp
	join icrp.dbo.project p on bp.OldProjectID = p.id
	join project np ON np.ProjectID = bp.ProjectID

	--delete from Project_ProjectType

-----------------------------
-- [Migration_ProjectFunding]
-----------------------------

CREATE TABLE [dbo].[Migration_ProjectFunding](
	[ProjectFundingID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectID] [int] NOT NULL,
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
	[Amount] [float] NOT NULL,
	[AnnualizedAmount] [float] NULL,
	[LifetimeAmount] [float] NULL,
	[BudgetStartDate] [date] NULL,
	[BudgetEndDate] [date] NULL,	
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL
)
GO

INSERT INTO [Migration_ProjectFunding] 
	([ProjectID], [Institution], [city], [state], [country], [piLastName], [piFirstName], [piORC_ID], [FundingOrgID], [FundingDivisionID], [AwardCode], [AltAwardCode],
	 [Source_ID], [Amount], [AnnualizedAmount], [LifetimeAmount], [BudgetStartDate],	[BudgetEndDate], [CreatedDate],[UpdatedDate])
SELECT np.ProjectID, op.institution, op.city, op.state, op.country, op.piLastName, op.piFirstName,  op.piORCiD,op.FUNDINGORGID, op.FUNDINGDIVISIONID, op.code, op.altid, op.SOURCE_ID, 
		pf.AMOUNT, pf.ANNUALIZEDAMOUNT, pf.LIFETIMEAMOUNT, op.BUDGETSTARTDATE, op.budgetenddate, pf.[DATEADDED], pf.[LASTREVISED]
FROM icrp.dbo.projectfunding pf
	 LEFT JOIN icrp.dbo.project op ON op.id = pf.projectid
	 JOIN Project np ON np.AwardCode = op.code  -- 200805
	 
-----------------------------
-- ProjectFunding
-----------------------------
SET IDENTITY_INSERT ProjectFunding ON;  -- SET IDENTITY_INSERT to ON. 
GO 

INSERT INTO ProjectFunding 
([ProjectFundingID], [ProjectID], [FundingOrgID], [FundingDivisionID], [AltAwardCode],	[Source_ID], [Amount], [AnnualizedAmount], [LifetimeAmount], [BudgetStartDate],	[BudgetEndDate], [CreatedDate],[UpdatedDate])
SELECT [ProjectFundingID], [ProjectID], [FundingOrgID], [FundingDivisionID], [ALtAwardCode],	[Source_ID], [Amount], [AnnualizedAmount], [LifetimeAmount], [BudgetStartDate],	[BudgetEndDate], [CreatedDate],[UpdatedDate]
FROM [Migration_ProjectFunding]

SET IDENTITY_INSERT ProjectFunding OFF;  -- SET IDENTITY_INSERT to ON. 
GO 

--delete from ProjectFunding
--DBCC CHECKIDENT ('[ProjectFunding]', RESEED, 0)
--select * from ProjectFunding  --200805

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


