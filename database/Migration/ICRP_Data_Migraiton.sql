-----------------------------
-- Country
-----------------------------
PRINT 'Migrate [Country]'

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
-- ProjectType
-----------------------------
INSERT INTO ProjectType
(ProjectType)
SELECT Type
FROM icrp.dbo.PROJECTTYPE

-----------------------------
-- CSOCategory
-----------------------------
PRINT 'Migrate [CSOCategory]'

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
(Name, ICRPCode, IsCommon, IsArchived, SortOrder)
SELECT DISTINCT name, mappedID, ISCOMMON, ISARCHIVED, SORTORDER 
FROM icrp.dbo.SITE 
ORDER BY mappedid

-----------------------------
-- PrjectAbstract  -- TO DO (Only migrate active projects)
-----------------------------
PRINT 'Migrate [ProjectAbstract]'

SET IDENTITY_INSERT ProjectAbstract ON;  -- SET IDENTITY_INSERT to ON. 
GO  

INSERT INTO ProjectAbstract
(ProjectAbstractID, TechAbstract, PublicAbstract, CreatedDate, UpdatedDate)
SELECT DISTINCT a.ID, a.techAbstract, a.publicAbstract, a.dateadded, a.lastrevised
FROM icrp.dbo.Abstract a
	JOIN icrp.dbo.PROJECT p ON p.abstractId = a.ID
	JOIN icrp.dbo.TESTPROJECTACTIVE t ON t.PROJECTID = p.ID
ORDER BY id


update ProjectAbstract set TechAbstract = 'No abstract available for this Project funding.' where ProjectAbstractID =0

SET IDENTITY_INSERT ProjectAbstract OFF;   -- SET IDENTITY_INSERT to OFF. 
GO  

-----------------------------
-- Currency - De-dup...
-----------------------------
PRINT 'Migrate [Currency]'

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
-- Create Institution Lookup - load from excel
-----------------------------
--drop table [UploadInstitution]
--go
--delete InstitutionMapping
--go
--DBCC CHECKIDENT ('[InstitutionMapping]', RESEED, 0)
--go
--delete [Institution]
--go
--DBCC CHECKIDENT ('[Institution]', RESEED, 0)
--go

PRINT 'Create Institution Lookup'

CREATE TABLE [dbo].[UploadInstitution](
DataIssue_ICRP [varchar](250) NOT NULL,
institution_ICRP	[varchar](250) NOT NULL,
city_ICRP	[varchar](250) NOT NULL,
city_ICRP_corrected	[varchar](250) NOT NULL,
state_ICRP	[varchar](250) NOT NULL,
state_ICRP_corrected	[varchar](250) NOT NULL,
country_ICRP	[varchar](250) NOT NULL,
country_ICRP_corrected	[varchar](250) NOT NULL,
ICRP_CURRENT_Combination_Inst_City	[varchar](250) NOT NULL,
MATCHGRID [varchar](250) NOT NULL,
MATCHGRIDNote	[varchar](1000) NOT NULL,
IsNOTEMultiHost [varchar](250) NOT NULL,
DedupInstitution	[varchar](250) NOT NULL,
[Check] [varchar](50) NOT NULL,
City_Clean	[varchar](250) NOT NULL,
State_Clean	[varchar](250) NULL,
Name_GRID	[varchar](250) NOT NULL,
City_GRID	[varchar](250) NOT NULL,
Country_GRID	[varchar](250) NOT NULL,
Country_ICRP_ISO	[varchar](250) NOT NULL,
ID_GRID	[varchar](250) NOT NULL,
Lat_GRID	[decimal](9,6) NULL,
Lng_GRID [decimal](9,6) NULL,
)

GO


BULK INSERT [UploadInstitution]
FROM 'C:\icrp\database\Migration\ICRPInstitutions.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO 

--select * from [UploadInstitution] where institution_ICRP like 'CEA-DSV-I2BM - %'

 --select distinct city_clean from [UploadInstitution] where city_clean like 'Mont%'
 --select distinct city_clean from [UploadInstitution] where city_clean like 'Que%'

UPDATE UploadInstitution SET City_ICRP = '' WHERE City_ICRP = 'NULL'
UPDATE UploadInstitution SET City_Clean = NULL WHERE City_Clean = 'NULL'
UPDATE UploadInstitution SET State_Clean = NULL WHERE State_Clean = 'NULL'
UPDATE UploadInstitution SET Country_ICRP_ISO = NULL WHERE Country_ICRP_ISO = 'NULL'
UPDATE UploadInstitution SET ID_GRID = NULL WHERE ID_GRID = 'NULL'

--select * from [UploadInstitution] where institution_icrp like 'Institut du Cancer de MontrTal (ICM)%'
--select distinct City_Clean from [UploadInstitution] order by city_clean

UPDATE UploadInstitution SET institution_ICRP = DedupInstitution WHERE ISNULL(institution_ICRP, '') = ''
UPDATE UploadInstitution SET DedupInstitution = institution_ICRP WHERE ISNULL(DedupInstitution, '') = ''
UPDATE UploadInstitution SET City_Clean = city_ICRP WHERE ISNULL(City_Clean, '') = ''
UPDATE UploadInstitution SET City_Clean = 'Montr�al' WHERE City_Clean IN ('Montr?al', 'Montreal', 'MontrTal')
UPDATE UploadInstitution SET City_Clean = 'Qu�bec' WHERE City_Clean IN ('Qu?bec', 'Qu??bec', 'Quebec')
UPDATE UploadInstitution SET City_Clean = 'L�vis' WHERE City_Clean IN ('LTvis', 'L?vis', 'Levis')
UPDATE UploadInstitution SET City_Clean = 'Z�rich' WHERE City_Clean IN ('Zurich')
UPDATE UploadInstitution SET City_Clean = 'St. Louis' WHERE City_Clean IN ('Saint Louis', 'St Louis')
UPDATE UploadInstitution SET City_Clean = 'Sault Ste. Marie' WHERE City_Clean IN ('Sault Ste Marie')
UPDATE UploadInstitution SET City_Clean = 'St. Catharines' WHERE City_Clean IN ('St Catharines')
UPDATE UploadInstitution SET City_Clean = 'Trois-Rivi�res' WHERE City_Clean IN ('Trois-RiviFres')
UPDATE UploadInstitution SET STATE_Clean = s.abbreviation FROM UploadInstitution u JOIN state s ON s.name = u.State_Clean
UPDATE UploadInstitution SET STATE_Clean = NULL where State_Clean IN ('Hamburg', 'Pirkanmaa')

INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT DISTINCT institution_ICRP, City_ICRP, DedupInstitution, City_Clean  FROM UploadInstitution  -- 7123

-- Manually inserted not-mapped institutions 
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'Ente ospedaliero ""Ospedali Galliera""', 'Genova', 'Ente Ospedaliero Ospedali Galliera', 'Genoa'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'HUMANITAS, INC.', '', 'Humanitas (United States)', 'Silver Spring'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'IFO - Italian National Cancer Institute ""Regina Elena""', 'Rome', 'IFO- Italian National Cancer Institute Regina Elina', 'Rome'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'Inserm U1086 ""Cancers & Preventions"" - CHU de Caen', 'Caen', 'Centre Hospitalier Universitaire de Caen', 'Caen'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'Institut Gustave Roussy-IGR - UPRES EA 3535 ""Pharmacologie et Nouveaux Traitements du Cancer', 'Villejuif', 'Institut Gustave Roussy', 'Villejuif'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'MASSACHUSETTS UNIV MED CTR', '', 'Massachusetts Institute of Technology', 'Cambridge'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'New York University, School of Medicine', 'New York', 'New York University', 'New York'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'Rutgers, The State University of New Jersey', 'New Brunswick', 'Rutgers University', 'New Brunswick'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'SOCIAL AND SCIENTIFIC SYSTEMS, INC.', 'Paris', 'Social and Scientific Systems (United States)', 'Paris'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'UMR7587 (CNRS) - Langevin ""Ondes et Images""', 'Paris', 'Institut Langevin', 'Paris'

-- Insert a placeholder for missing institution 
INSERT INTO [Institution] ([Name], [City])
SELECT 'Missing', 'Missing'

INSERT INTO [Institution] ([Name],[City],[State],[Country],[Longitude],[Latitude],[GRID])
SELECT DISTINCT MAX(DedupInstitution), City_Clean, MAX(State_Clean), MAX(Country_ICRP_ISO), MAX(Lng_GRID), MAX(Lat_GRID), MAX(ID_GRID)
FROM [UploadInstitution] GROUP BY DedupInstitution, City_Clean -- 3944


IF EXISTS (select name, city, count(*)  from [Institution] group by name, city having count(*) > 1)
BEGIN
	SELECT 'Duplicate Institutions', [Name], [City], count(*)  from [Institution] group by [Name], [City] having count(*) > 1
END

--DBCC CHECKIDENT ('[Institution]', RESEED, 0)

-----------------------------------------
-- [PartnerApplication]
-----------------------------------------

PRINT 'Migrate [PartnerApplication]'

INSERT INTO [PartnerApplication]
SELECT '',
[ORGNAME],[ORGADD1],[ORGADD2],[ORGCITY],[ORGSTATE],[ORGCOUNTRY],[ORGZIP],
[EDPCNAME],[EDPCPOSITION],[EDPCPHONE],[EDPCEMAIL],[MISSIONDESC],[PROFILEDESC],
[INIYEAR],[CRESEARCHBUDGET],[REPORTPERIOD],[COPERATINGBUDGET],[NUMPROJECTS],
[TIER],[PAYMENTDT],[CONTACTNAME],[CONTACTPOSITION],[CONTACTPHONE],[CONTACTEMAIL],
[CONTACTADD1],[CONTACTADD2],[CONTACTCITY],[CONTACTSTATE],[CONTACTCOUNTRY],
[CONTACTZIP],[TERM1],[TERM2],[TERM3],[TERM4],[TERM5],[TERM6],[TERM7],[TERM8],[TERM9],
[SUPPLELETTER],[SUPPLEDOC],[ISCOMPLETED],[SUBMITDT],[SUBMITDT]
FROM icrp.dbo.tblMEMBERSHIPFORM

-----------------------------------------
-- Partners
-----------------------------------------
PRINT 'Migrate [Partner]'

INSERT INTO Partner 
SELECT [NMPARTNER],[TXTPARTNER],
	CASE ISNULL(s.code, '') WHEN '' THEN 'N/A - '+ LEFT([NMPARTNER], 10) ELSE s.code END,
	s.email, NULL, p.[COUNTRY], p.[WEBSITE], p.[LOGO],p.[MAPCOORDS], '', NULL, getdate(), getdate()
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

UPDATE Partner SET IsDSASigned = o.DSASIGNED
FROM Partner p
LEFT JOIN icrp.dbo.tblORG o ON p.Name = o.Name

-----------------------------
-- FundingOrg
-----------------------------
PRINT 'Migrate [FundingOrg]'

SET IDENTITY_INSERT FundingOrg ON;  -- SET IDENTITY_INSERT to ON. 
GO 

INSERT INTO FundingOrg
(FundingOrgID, Name, [Abbreviation], [Country], [CURRENCY], [SponsorCode], [MemberType],[MemberStatus],[ISANNUALIZED],
LastImportDate, CreatedDate, UpdatedDate)
SELECT ID, NAME, [ABBREVIATION],
	CASE [COUNTRY] WHEN 'UK' THEN 'GB' ELSE country END AS Country, 
	[CURRENCY], [SponsorCode], '', NULL, [ISANNUALIZED],[LASTDATAIMPORT], [DATEADDED], [LASTREVISED]
FROM icrp.dbo.fundingorg

SET IDENTITY_INSERT FundingOrg OFF;  -- SET IDENTITY_INSERT to ON. 
GO 

UPDATE FundingOrg SET MemberType = CASE ISNULL(p.Name, '') WHEN '' THEN 'Associate' ELSE 'Partner' END, MemberStatus='Current'
FROM  FundingOrg f
LEFT JOIN Partner p ON f.Name = p.Name

--select * from  FundingOrg where IsDSASigned is null (Check later)

-----------------------------
-- FundingDivision
-----------------------------
PRINT 'Migrate [FundingDivision]'

INSERT INTO FundingDivision
(FundingOrgID, Name, [Abbreviation], CreatedDate, UpdatedDate)
SELECT FundingOrgID, NAME, [ABBREVIATION], [DATEADDED], [LASTREVISED]
FROM icrp.dbo.fundingdivision

----------------------------------------------------------------------------------
-- Only migrate the active projects 
--  Exclude CA funding (CCRA) -- 29,748
--  Exclude UK funding
----------------------------------------------------------------------------------
DECLARE @sortedProjects TABLE (
	[SortedProjectID] [int] IDENTITY(1,1) NOT NULL,
	[OldProjectID] [int] NOT NULL,
	[AwardCode] nvarchar(1000) NOT NULL
)

INSERT INTO @sortedProjects SELECT ID, COde FROM icrp.dbo.project ORDER BY code, DateStart, BUDGETSTARTDATE, ImportYear, ID

SELECT DISTINCT s.SortedProjectID, p.* INTO #activeProjects
FROM icrp.dbo.project p
join icrp.dbo.fundingorg f on p.FUNDINGORGID = f.ID
JOIN @sortedProjects s ON p.id = s.OldProjectID
JOIN icrp.dbo.TestProjectActive a ON p.ID = a.projectID
WHERE f.SPONSORCODE <> 'CCRA'
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
PRINT 'Create [Migration_Project]'

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
PRINT 'Migrate [Project]'

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
PRINT 'Migrate [ProjectDocument]'

INSERT INTO ProjectDocument
(ProjectID, [Content])
SELECT m.[ProjectID], s.[Text]
FROM icrp.dbo.search s
	JOIN Migration_Project m ON s.ProjectID = m.OldProjectID

--------------------------------------------------------------------------------------------
-- ProjectDocument_JP  - TBD: change to save the most recent project content/abstract?
--------------------------------------------------------------------------------------------
PRINT 'Migrate [ProjectDocument_JP]'

INSERT INTO ProjectDocument_JP
(ProjectID, [Content])
SELECT m.[ProjectID], s.[Text]
FROM icrp.dbo.search_JP s
	JOIN Migration_Project m ON s.ProjectID = m.OldProjectID

-----------------------------
-- Project_ProjectType
-----------------------------
PRINT 'Migrate [Project_ProjectType]'

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
PRINT 'Create [Migration_ProjectFunding]'

CREATE TABLE [dbo].[Migration_ProjectFunding](
	[ProjectFundingID] [int] IDENTITY(1,1) NOT NULL,
	[NewProjectID] [int] NOT NULL,
	[OldProjectID] [int] NOT NULL,
	[AbstractID] [int] NOT NULL,
	[Title] varchar(1000) NULL, 
	[Institution] varchar(250) NULL, 
	[city] varchar(250) NULL, 
	[NewInstitution] varchar(250) NULL, 
	[NewCity] varchar(250) NULL, 
	[state] varchar(250) NULL, 
	[country] varchar(250) NULL, 
	[piLastName] varchar(250) NULL,
	[piFirstName] varchar(250) NULL,
	[piORC_ID] varchar(250) NULL,
	[OtherResearch_ID] int NULL,
	[OtherResearch_Type] varchar(50) NULL,
	[FundingOrgID] [int] NOT NULL,
	[FundingDivisionID] [int] NULL,
	[AwardCode] [varchar](500) NOT NULL,
	[AltAwardCode] [varchar](500) NOT NULL,
	[Source_ID] [varchar](50) NULL,
	[MechanismCode] [varchar](30) NULL,
	[MechanismTitle] [varchar](200) NULL,
	[FundingContact] [varchar](200) NULL,	
	[Amount] [float] NULL,
	[IsAnnualized] [bit] NOT NULL,
	[BudgetStartDate] [date] NULL,
	[BudgetEndDate] [date] NULL,	
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL
)
GO


INSERT INTO [Migration_ProjectFunding] 
	([NewProjectID], [OldProjectID], [AbstractID], [Title],[Institution], [city], [newInstitution], [newcity], [state], [country], [piLastName], [piFirstName], [piORC_ID], 
	 [OtherResearch_ID], [OtherResearch_Type], [FundingOrgID], [FundingDivisionID], [AwardCode], [AltAwardCode], [Source_ID], [MechanismCode], 
	 [MechanismTitle], [FundingContact], [Amount], [IsAnnualized], [BudgetStartDate],	[BudgetEndDate], [CreatedDate],[UpdatedDate])
SELECT mp.ProjectID, op.ID, op.abstractID, op.title, op.institution, op.city,  op.institution, op.city, op.state, op.country, op.piLastName, op.piFirstName,  op.piORCiD,
	   op.OtherResearcherId, OtherResearcherIdType, op.FUNDINGORGID, op.FUNDINGDIVISIONID, op.code, op.altid, op.SOURCE_ID, m.SPONSORMECHANISM,  
	   m.TITLE, op.fundingOfficer, pf.AMOUNT, 
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
PRINT 'Migrate [ProjectFunding]'

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
PRINT 'Migrate [ProjectFundingExt]'

INSERT INTO ProjectFundingExt
([ProjectFundingID], [AncestorProjectID], [CalendarYear], [CalendarAmount])
SELECT m.[ProjectFundingID], a.[ProjectIDANCESTOR], a.[YEAR], a.[CALENDARAMOUNT_V2]
FROM icrp.dbo.[TestProjectActive] a
JOIN [Migration_ProjectFunding] m ON a.PROJECTID = m.OldProjectID

--delete from ProjectFundingExt
--DBCC CHECKIDENT ('[ProjectFundingExt]', RESEED, 0)
--select * from ProjectFundingExt  --200805

-----------------------------------------
-- ProjectFunding_Investigator (check investigator)
-----------------------------------------
PRINT 'Migrate [ProjectFunding_Investigator]'

UPDATE [Migration_ProjectFunding] SET newInstitution = m.newName, [newCity] = m.newCity 
--SELECT f.institution, f.City, f.newinstitution, f.newcity,m.*
FROM [Migration_ProjectFunding] f
JOIN InstitutionMapping m ON f.institution = m.oldName AND ISNULL(f.city, '') = ISNULL(m.oldCity,'')
WHERE m.newName <> m.oldName OR m.oldCity <> m.newCity

UPDATE [Migration_ProjectFunding] SET newInstitution = 'Fox Chase Cancer Center', [newCity] = 'Philadelphia'
FROM [Migration_ProjectFunding] 
WHERE Institution = 'Institute for Cancer Research, Fox Chase Cancer Center'


UPDATE [Migration_ProjectFunding] SET NewCity = '' where city = 'NULL'

INSERT INTO ProjectFundingInvestigator 
([ProjectFundingID], [LastName], [FirstName], [ORC_ID], [OtherResearch_ID], [OtherResearch_Type], [IsPrivateInvestigator], InstitutionID)
SELECT distinct m.ProjectFundingID, ISNULL(m.piLastName, '') AS LastName, m.piFirstName, m.piORC_ID, m.[OtherResearch_ID], m.OtherResearch_Type, 1 AS IsPrivateInvestigator, ISNULL(i.InstitutionID, 1) AS InstitutionID --into #tmp
FROM [Migration_ProjectFunding] m
	 LEFT JOIN Institution i ON (i.name = m.newInstitution AND i.city = m.[newcity]) 
   
 -- test
SELECT distinct m.institution,  m.city
FROM [Migration_ProjectFunding] m	
	LEFT JOIN Institution i ON (i.name = m.newInstitution AND i.city = m.[newcity])  
	  where i.InstitutionID is null	  

--delete ProjectFundingInvestigator

-----------------------------------------
-- LibraryFolder
-----------------------------------------
SET IDENTITY_INSERT LibraryFolder ON;  -- SET IDENTITY_INSERT to ON. 
GO  

INSERT INTO LibraryFolder ([LibraryFolderID],[Name],[ParentFolderID],[IsPublic],[CreatedDate],[UpdatedDate])
SELECT FID, [FOLDERNAME],[PARENTFOLDERID],0, getdate(),getdate()
FROM icrp.dbo.tblFILEFOLDERS

SET IDENTITY_INSERT LibraryFolder OFF;  -- SET IDENTITY_INSERT to ON. 

INSERT INTO LibraryFolder ([Name],[ParentFolderID],[IsPublic],[CreatedDate],[UpdatedDate])
VALUES ( 'Publications', 1, 1, getdate(),getdate())

INSERT INTO LibraryFolder ([Name],[ParentFolderID],[IsPublic],[CreatedDate],[UpdatedDate])
VALUES ( 'Newsletters', 1, 1, getdate(),getdate())

INSERT INTO LibraryFolder ([Name],[ParentFolderID],[IsPublic],[CreatedDate],[UpdatedDate])
VALUES ( 'Meeting Reports', 1, 1, getdate(),getdate())

go

-----------------------------------------
-- Library
-----------------------------------------
INSERT INTO Library 
SELECT [FID],[FILENAME],'', [FILETITLE],[DESCRIPTION], 0, [DATEARCHIVED],getdate(), getdate()
FROM icrp.dbo.tblLIBRARY

--select * from Library where ispublic=1

-- public publications
DECLARE @PublicationsFolderID INT
DECLARE @NewsLettersFolderID INT
DECLARE @MeetingReportsFolderID INT

SELECT @PublicationsFolderID=LibraryFolderID FROM LibraryFolder WHERE Name='Publications'
SELECT @NewsLettersFolderID=LibraryFolderID FROM LibraryFolder WHERE Name='Newsletters'
SELECT @MeetingReportsFolderID=LibraryFolderID FROM LibraryFolder WHERE Name='Meeting Reports'

INSERT INTO Library VALUES(@PublicationsFolderID,'ICRP_EnvInfBreastCancer_ShortReport_2014.pdf','ICRP_EnvInfluences_BreastCancer_2014_cover.png', 'Metastatic Breast Cancer Alliance Report 2014','An analysis of MBC clinical trials and grant funding from the ICRP and related databases from 2000 through 2013', 1, NULL,getdate(), getdate())
INSERT INTO Library VALUES(@PublicationsFolderID, '2014_NCRI_Childrens_Cancer_Research_Analysis.pdf','2014_NCRI_Childrens_Cancer_Research_Analysis_Cover.png', 'Children''s Cancer Research','A report on international research investment in childhood cancer in 2008, by the UK National Cancer Research Institute and members of the International Cancer Research Partnership', 1, NULL, DATEADD(second,1, getdate()), getdate())
INSERT INTO Library VALUES(@PublicationsFolderID,'ICRP_GYN_analysis.pdf','GYN_cover.png', 'Gynecologic Cancers Portfolio Analysis','Summary of the burden of gynecologic cancers in the United States and investments in research by the National Cancer Institute and members of the International Cancer Research Partnership', 1, NULL,DATEADD(second,2, getdate()), getdate())
INSERT INTO Library VALUES(@PublicationsFolderID,'ICRP_Report_2005-08.pdf','ICRP_Data_Report_Cover.png', 'ICRP Data Report 2005-2008','This is the first, co-operative international analysis of the cancer research landscape, based on data from over 50 current member organizations about their individual projects and programs, each classified by type of cancer and type of research', 1, NULL,DATEADD(second,3, getdate()), getdate())
INSERT INTO Library VALUES(@PublicationsFolderID,'ICRP_EnvInfluences_BreastCancer_2014.pdf','ICRP_EnvInfluences_BreastCancer_2014_cover.png', 'ICRP report on environmental influences in breast cancer (2014)','An analysis of the research landscape in this area, examining trends in investment, research activity and gaps across a range of environmental carcinogens and lifestyle factors', 1, NULL,DATEADD(second,4, getdate()), getdate())
INSERT INTO Library VALUES(@PublicationsFolderID,'ICRP_Obesity_Cancer_Report_2014.pdf','ICRP_Obesity_Cancer_Report_2014_cover.png', 'ICRP report into obesity and cancer research (2014)','This report examines trends in investment and publication outputs for research on the role of obesity in cancer', 1, NULL,DATEADD(second,5, getdate()), getdate())
INSERT INTO Library VALUES(@PublicationsFolderID,'ICRP_Translational_Methodology_2015.pdf','ICRP_Translational_Methodology_2015.png', 'ICRP Translational Research Methodology (2015)','This report details a robust and easy way to identify translational research awards and monitor trends in this area, using the ICRP�s Common Scientific Outline (CSO)', 1, NULL,DATEADD(second,6, getdate()), getdate())
INSERT INTO Library VALUES(@PublicationsFolderID,'ICRP_ChildhoodCancer_2016.pdf','ICRP_ChildhoodCancer_2016.png', 'ICRP Childhood Cancer Analysis 2016','An overview of research investment in cancers affecting children, adolescents and young adults in the ICRP portfolio', 1, NULL,DATEADD(second,7, getdate()), getdate())
INSERT INTO Library VALUES(@PublicationsFolderID,'ICRP_Disparities_ShortReport_2016.pdf','ICRP_Disparities_ShortReport_2016.png', 'ICRP Health Disparities Report 2016','An overview of research investment in health disparities and inequities in the ICRP portfolio', 1, NULL,DATEADD(second,8, getdate()), getdate())
INSERT INTO Library VALUES(@PublicationsFolderID,'ICRP_LungCancer_2016.pdf','ICRP_LungCancer_2016.png', 'ICRP Lung Cancer Overview 2016','An overview of research investment in lung cancer in the ICRP portfolio', 1, NULL, DATEADD(second,9, getdate()), getdate())

--INSERT INTO Library VALUES(@PublicationsFolderID,'MBCAlliance-Chapter-2.pdf','MBCAlliance-Chapter-2.png', '','', 1, NULL,getdate(), getdate())

-- public newsletters
INSERT INTO Library VALUES(@NewsLettersFolderID,'ICRP_Newsletter_Feb2015.pdf','newsletter_2015_02.png', 'ICRP Newsletter, February 2015','Includes evaluation highlights presented at the San Antonio Breast Cancer Symposium, news about ICRP landscape reports and information about the ICRP annual meeting', 1, NULL,getdate(), getdate())
INSERT INTO Library VALUES(@NewsLettersFolderID,'ICRP_Newsletter_November_2015.pdf','newsletter_2015_11.png', 'ICRP Newsletter, November 2015','Includes details on the launch of a new, more user-friendly version (V2) of the cancer classification system or Common Scientific Outline (CSO)', 1, NULL,DATEADD(minute,1, getdate()), getdate())
INSERT INTO Library VALUES(@NewsLettersFolderID,'ICRP_Newsletter_Summer_2015.pdf','.png', 'ICRP Newsletter, Summary 2015','ICRP Newsletter, Summary 2015', 1, getdate(),getdate(), getdate())

-- public Meeting Reports
INSERT INTO Library VALUES(@MeetingReportsFolderID,'ICRP_2016_Annual meeting_BriefSummary.pdf','report_2016_08.png', 'ICRP 2016 Annual Meeting Report','This report summarizes the ICRP''s 2016 annual meeting on Health Disparities, hosted by the American Cancer Society', 1, NULL,getdate(), getdate())

-----------------------------
-- DataUploadStatus
-----------------------------
INSERT INTO DataUploadStatus
SELECT PARTNER,	[FUNDINGYEAR], [STATUS],[RECEIVEDDATE],	[PREIMPORTDATE],
	[UPLOADDEVDBDATE],[COPYSTAGEDBDATE], [COPYPROCDBDATE],[NOTE], [submitdt]
FROM icrp.dbo.tblDATAUPLOADPROCESSINFO
	
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



-----------------------------
-- Migrate users to drupal
-- -1: registering
-- 0: Archived
-- 1: partner
-- 2: Manager
-- 3: Admin
-----------------------------
--SELECT l.FNAME AS FirstName, l.LNAME AS LastName, l.EMAIL, o.NAME AS Organization, 
--		CASE l.ACCESSLEVEL
--		  WHEN 1 THEN 'Partner'
--		  WHEN 2 THEN 'Manager'		  
--		  ELSE NULL END AS Role, 
--		  CASE l.ACCESSLEVEL
--		  WHEN -1 THEN 'Registering'
--		  WHEN 0 THEN 'Block'		  
--		  ELSE 'Approved' END AS Access		  
--    INTO #users
--	FROM icrp.dbo.tblLogin l
--    	JOIN tblORG o ON o.ID = l.ORGID
--	WHERE l.ACCESSLEVEL <> 3  -- do not migrate admin accounts

--	AND o.name <> 'IMSWeb'UPDATE #org SET Organization = 'Avon Foundation for Women' WHERE Organization = 'Avon Foundation'
--	UPDATE #org SET Organization = 'Canadian Breast Cancer Research Alliance' WHERE Organization = 'Canadian Cancer Research Alliance'
--	UPDATE #org SET Organization = 'Canadian Cancer Society' WHERE Organization = 'Canadian Cancer Society Research Institute'
--	UPDATE #org SET Organization = 'Cancer Australia' WHERE Organization = 'Cancer Institute New South Wales'
--	UPDATE #org SET Organization = 'KWF Kankerbestrijding / Dutch Cancer Society' WHERE Organization = 'Dutch Cancer Society'
--	UPDATE #org SET Organization = 'National Cancer Center, Japan' WHERE Organization = 'National Cancer Center (Japan)'
--	UPDATE #org SET Organization = 'Cancer Research UK' WHERE Organization = 'National Cancer Research Institute'
--	UPDATE #org SET Organization = 'Northern Ireland Health & Social Care - R & D Office' WHERE Organization = 'Northern Ireland R & D Office'
--	UPDATE #org SET Organization = 'Welsh Assembly Government - Office of R & D' WHERE Organization = 'Welsh Assembly Government'

--	SELECT * FROM #users

	--select distinct Organization FROM #org o
	--LEFT JOIN FUNDINGORG f ON o.Organization = f.name
	--WHERE f.name is null

	
	