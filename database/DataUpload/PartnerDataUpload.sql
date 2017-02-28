
----------------------------
-- Load Workbook 
-----------------------------
--DROP Table UploadWorkBook 
--GO

CREATE TABLE UploadWorkBook (	
	AwardCode NVARCHAR(50),
	AwardStartDate Date,
	AwardEndDate date,
	SourceId VARCHAR(50),
	AltId VARCHAR(50),
	AwardTitle VARCHAR(1000),
	Category VARCHAR(25),
	AwardType VARCHAR(50),
	Childhood VARCHAR(5),
	BudgetStartDate date,
	BudgetEndDate date,
	CSOCodes VARCHAR(500),
	CSORel VARCHAR(500),
	SiteCodes VARCHAR(500),
	SiteRel VARCHAR(500),
	AwardFunding float,
	IsAnnualized VARCHAR(1),
	FundingMechanismCode VARCHAR(30),
	FundingMechanism VARCHAR(200),
	FundingOrgAbbr VARCHAR(50),
	FundingDiv VARCHAR(50),
	FundingDivAbbr VARCHAR(50),
	FundingContact VARCHAR(50),
	PILastName VARCHAR(50),
	PIFirstName VARCHAR(50),
	Institution VARCHAR(250),
	City VARCHAR(50),
	State VARCHAR(3),
	Country VARCHAR(3),
	PostalZipCode VARCHAR(15),
	Latitute decimal(9,6),
	Longitute decimal(9,6),
	GRID VARCHAR(50),
	TechAbstract NVARCHAR(max),
	PublicAbstract NVARCHAR(max),
	ORCID VARCHAR(25),
	OtherResearcherID INT,
	OtherResearcherIDType VARCHAR(1000)
)

GO

BULK INSERT UploadWorkBook
FROM 'C:\icrp\database\DataUpload\ICRP_DataSubmission_CA.csv'  --ICRP_DataSubmissionWorkbook_CA2.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  -- import errors row #: 609, 6909 (Total: 13591)

UPDATE UploadWorkBook SET TechAbstract = 'I propose to develop statistical methods to (1) assess the performance of diagnostic tests and prognostic scores and (2) estimate risk (cumulative incidence) functions and, from them, individualized ''what if'' probabilities of benefit if a specific medical or lifestyle intervention is selected. In aim (1) the primary focus will be on the ''c'' statistic derived from multiple logistic regression. The initial biostatistical use of c was as the area under the roc curve (auc), to measure the discriminant ability of imaging tests (interpreted on a rating scale) and laboratory tests (measured on an interval scale). However, the index is also standard output from the SAS (multiple) LOGISTIC procedure and is increasingly used to assess the ability of diagnostic and prognostic scoring systems derived from a vector of predictors. If calculated from the same data from which the model is fitted, the statistic overestimates the true performance of the system. Indeed, by construction, the c statistic calculated from PROC LOGISTIC cannot be less than the null 0.5. Several authors (from Cornfield and Lachenbruch several decades ago, to Copas, Rockette, and Pinsky recently) have studied the factors that determine the magnitude of this bias. I propose to develop a simple ''adjusted-c'' statistic, similar to the adjusted-r-squared statistic. I expect that the needed attenuation/shrinkage will be a function of the numbers of cases and non-cases, and the numbers of useful - and useless - candidate predictor variables. A secondary focus will be on simplified lower confidence bound for the true auc when - in the simple imaging or laboratory test situations - the observed auc is unity. Obuchowshi has provided limits for this situation, but unfortunately they are too distribution-specific to be of general use. My plan is to draw on the simplicity and closed-form formulae based on overlapping exponential distributions, and on the insights on the var(auc) structure in our paper in Academic Radiology in 1997. Aim (2) has two parts. The first is to develop guidelines for a novel way (developed with my colleague Miettinen) to fit smooth-in-time hazard functions to survival-type data, where the event E=1 represents an undesirable outcome. The purpose is to estimate cumulative incidence as a function of a vector of patient characteristics and lifestyle/medical management options. The approach is based on sampling the person-moments; the main unknown is the choice of the sampling approach that gives the most stable estimate of the individualized cumulative incidence. The second aim is to derive an interval estimate for the probability of benefit within a time horizon T, for an individual with a personal profile vector x, and contemplated medical/behavioral Action (A=1) or not (A=0), i.e. the difference Prob[E=1 | x, T, A=0] - Prob[E=1 | x, T,A=1]. The hope is to have the individualized interval be test-based, so that it can be calculated from the information usually contained in study reports. We focus on individualized risk differences as a response to the inordinate emphasis on the ''average'' patient and on hazard ratios rather than what matters to an individual: for individuals such as I, with profile x, what is the difference in the probability of E over a time-horizon T if I choose one action over another? As an example, consider the 2005 NEJM report on an RCT which documented the extent to which radical prostatectomy reduces the risk of death from prostate cancer: the ''average'' prostate cancer case-fatality rate within 10 years was 15% for those randomized to watchful waiting and 10% for those randomized to surgery; the hazard ratio was 0.55. The report contained no useful information for men with a patient/tumour profile (age at diagnosis, Gleason score, pre-treatment PSA level) that was more/less favourable than the ''average'' profile to which the summary results presumably apply. With methods that are aimed at individualized risk, and that do not rely on the non-smooth estimates obtained from Cox''s proportional hazards model, we plan to change the contemporary culture of statistical reporting to be more responsive to individual ''clients''.'
WHERE AltId = '10769_1'

UPDATE UploadWorkBook SET TechAbstract = 'The program of research addressing five research aims, was undertaken by a research team (organized into the Evidence Expert Panel, Best Practices Expert Panel and the main Scientific Office): Research Aims: 1. Using existing KT resources, to identify and analyze high quality systematic reviews and guidelines (e.g. Cochrane Review) in the published literature evaluating the effectiveness of interventions directed to change behaviour across stakeholder groups. A measurement tool to operationalize the degree of KT intervention effectiveness was developed. 2. Using a targeted review, to analyze selected frameworks, models and theories that may be useful in directing KT strategy, planning, and practice to improve quality in cancer control. 3. Using key informant interviews and questionnaire methodologies, to identify best Canadian KT practices in use, being tested or targeted to improve cancer control. A tool to operationalize the concept of �best practices� was developed. 4. Using consensus methodology, findings from Aims 1 to 3 will be integrated to identify gaps and priorities in the KT research field as it relates to improving cancer control. 5. The planning and implementation of a strategy to facilitate the use and application of the findings using integrated- and end-of-grant KT principles. Final Reports: 1. Knowledge Translation for Cancer Control in Canada: A Casebook. 2. Knowledge translation to improve quality of cancer control in Canada: What we know and what is next. Publication: Brouwers MC, Makarski J, Garcia K, Bouseh S, Hafid T. Improving cancer control in Canada one case at a time: the "Knowledge Translation in Cancer" casebook. Curr Oncol. 2011;18(2):76-83. PubMed PMID: 21505598; PubMed Central PMCID: PMC3070706 PDF | APPENDIX A | APPENDIX B | HTML Brouwers MC; Garcia K; Makarski J; Daraz L; of the Evidence Expert Panel and of the KT for Cancer Control in Canada Project Research Team. The landscape of knowledge translation interventions in cancer control: What do we know and where to next? A review of systematic reviews. Implementation Science 2011, 6, 130. doi:10.1186/1748-5908-6-130 PDF | HTML'
WHERE AltId = '18497_1'

/***********************************************************************************************/
-- Fix data
/***********************************************************************************************/


/*************************************************************************************************************/
-- Delete CA funding data
/*************************************************************************************************************/
--SELECT f.ProjectID, ProjectFundingID INTO #ca FROM ProjectFunding f 
--JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
--WHERE o.sponsorcode = 'CCRA'

--DELETE ProjectFundingInvestigator WHERE ProjectFundingID IN (SELECT ProjectFundingID FROM #ca)
--DELETE ProjectCancerType WHERE ProjectFundingID IN (SELECT ProjectFundingID FROM #ca)
--DELETE ProjectCSO WHERE ProjectFundingID IN (SELECT ProjectFundingID FROM #ca)

--SELECT a.ProjectAbstractID INTO #Abstract FROM ProjectAbstract a
--	JOIN ProjectFunding f ON a.ProjectAbstractID = f.ProjectAbstractID
--		WHERE f.ProjectFundingID IN (SELECT ProjectFundingID FROM #ca)

--DELETE ProjectFunding WHERE ProjectFundingID IN (SELECT ProjectFundingID FROM #ca)
--DELETE ProjectAbstract WHERE ProjectAbstractID IN (SELECT distinct ProjectAbstractID FROM #Abstract where ProjectAbstractID <> 0)
--DELETE ProjectFundingExt WHERE ProjectID IN (SELECT DISTINCT ProjectID FROM #ca)
--DELETE Project_ProjectType WHERE ProjectID IN (SELECT DISTINCT ProjectID FROM #ca)
--DELETE ProjectDocument WHERE ProjectID IN (SELECT DISTINCT ProjectID FROM #ca)
--DELETE ProjectDocument_JP WHERE ProjectID IN (SELECT DISTINCT ProjectID FROM #ca)
--DELETE Project WHERE ProjectID IN (SELECT DISTINCT ProjectID FROM #ca)


/***********************************************************************************************/
-- Validation
/***********************************************************************************************/
-- Check related project base data
drop table #awardCodes
go
drop table #parentProjects
go

SELECT Distinct AwardCode INTO #awardCodes FROM UploadWorkBook
SELECT AwardCode, Childhood, AwardStartDate, AwardEndDate INTO #parentProjects from UploadWorkBook where Category='Parent'

DECLARE @TotalAwardCodes INT
DECLARE @TotalParentProjects INT

SELECT @TotalAwardCodes = COUNT(*) FROM #awardCodes
SELECT @TotalParentProjects = COUNT(*) FROM #parentProjects


IF @TotalAwardCodes <> @TotalParentProjects
BEGIN
  PRINT 'ERROR ==> Total parent projects <> total award codes'
  SELECT 'No parent Category' AS Issue, AwardCode FROM #awardCodes WHERE AwardCode NOT IN (SELECT AwardCode FROM #parentProjects)
END

--select * from UploadWorkBook where awardcode='10238_2'

-------------------------------------------------------------------
-- Check FundingOrg
-------------------------------------------------------------------
IF EXISTS (SELECT DISTINCT FundingOrgAbbr from UploadWorkBook 
where FundingOrgAbbr NOT IN (SELECT DISTINCT Abbreviation FROM FundingOrg))
BEGIN
  PRINT 'ERROR ==> FundingOrg Not Exist --> Add FundingOrg First'
  SELECT DISTINCT 'Missing FundingOrg' AS Issue, FundingOrgAbbr from UploadWorkBook 
	WHERE FundingOrgAbbr NOT IN (SELECT DISTINCT Abbreviation FROM FundingOrg)
END

-------------------------------------------------------------------
-- Check FundingDiv
-------------------------------------------------------------------
IF EXISTS (SELECT DISTINCT FundingDivAbbr from UploadWorkBook 
	WHERE FundingDivAbbr NOT IN (SELECT DISTINCT Abbreviation FROM FundingDivision))
BEGIN
  PRINT 'ERROR ==> FundingDiv Not Exist --> Add FundingDiv First'
 SELECT DISTINCT 'Missing FundingDiv' AS Issue, FundingDivAbbr from UploadWorkBook 
	WHERE FundingDivAbbr NOT IN (SELECT DISTINCT Abbreviation FROM FundingDivision)
END

-------------------------------------------------------------------
-- Check unique Project Funding Altid 
-------------------------------------------------------------------
IF EXISTS (SELECT Altid, Count(*) AS Count FROM UploadWorkBook GROUP BY Altid HAVING COUNT(*) > 1)
BEGIN
  PRINT 'ERROR ==> Altid not unique'
 SELECT 'Duplicate Altid' AS Issue, Altid, Count(*) AS Count FROM UploadWorkBook GROUP BY Altid HAVING COUNT(*) > 1
END

-------------------------------------------------------------------
-- Check duplicate Project Funding
-------------------------------------------------------------------
IF EXISTS (select AltId, count(*) from UploadWorkBook group by AwardCode, AltId, BudgetStartDate, BudgetEndDate having count(*) >1)
BEGIN
SELECT 'Duplicate Project Funding' AS Issue, AwardCode,  AltId, BudgetStartDate, BudgetEndDate, count(*) AS Count from UploadWorkBook group by AwardCode, AltId, BudgetStartDate, BudgetEndDate having count(*) >1
END 

-- Check if AwardCodes alreadt exist in ICRP
--IF EXISTS (select * FROM UploadWorkBook WHERE AwardCode IN (SELECT AwardCode FROM Project) )
--BEGIN
--	SELECT 'AwardCode Exists' AS Issue, AwardCode from UploadWorkBook WHERE AwardCode IN (SELECT AwardCode FROM Project)
--END 


-------------------------------------------------------------------
-- Check Institutions
-------------------------------------------------------------------
drop table #missingInst
go

-- fix institution data in the UploadWorkBook
UPDATE UploadWorkBook SET City = 'Montr�al' WHERE City IN ('Montreal', 'MontrTal')
UPDATE UploadWorkBook SET City = 'Qu�bec' WHERE City IN ('Quebec', 'QuTbec')
UPDATE UploadWorkBook SET City = 'L�vis' WHERE City IN ('LTvis', 'L?vis', 'Levis')
UPDATE UploadWorkBook SET City = 'Z�rich' WHERE City IN ('Zurich')
UPDATE UploadWorkBook SET City = 'St. Louis' WHERE City IN ('Saint Louis', 'St Louis')
UPDATE UploadWorkBook SET City = 'Sault Ste. Marie' WHERE City IN ('Sault Ste Marie')
UPDATE UploadWorkBook SET City = 'St. Catharines' WHERE City IN ('St Catharines')
UPDATE UploadWorkBook SET City = 'Trois-Rivi�res' WHERE City IN ('Trois-RiviFres')

UPDATE UploadWorkBook SET Institution = '�cole de technologie sup�rieure (Universit� du Qu�bec)' WHERE Institution like '%cole de technologie supTrieure (UniversitT du QuTbec)%'
UPDATE UploadWorkBook SET Institution = '�cole polytechnique de Montr�al' WHERE Institution like '%cole polytechnique de MontrTal%'
UPDATE UploadWorkBook SET Institution = 'Centre National de la Recherche Scientifique (CNRS), l''INSERM (Institut National de la Sant� et de la Recherche M�dicale) - UNSA' WHERE Institution like '%Centre National de la Recherche Scientifique (CNRS), %'
UPDATE UploadWorkBook SET Institution = '�cole sup�rieure de physique et de chimie industrielles (ESPCI) Paris Tech' WHERE Institution like '%�cole sup?rieure de physique et de chimie industrielles (ESPCI) Paris Tech%'
UPDATE UploadWorkBook SET Institution = 'Eidgen�ssiche Technische Hochschule (ETH) Z�rich' WHERE Institution like '%Eidgen?ssiche Technische Hochschule (ETH) Z�rich%'
--UPDATE UploadWorkBook SET Institution = '' WHERE Institution like '%h%'
--UPDATE UploadWorkBook SET Institution = '' WHERE Institution like '%h%'
--UPDATE UploadWorkBook SET Institution = '' WHERE Institution like '%h%'
--UPDATE UploadWorkBook SET Institution = '' WHERE Institution like '%h%'
--UPDATE UploadWorkBook SET Institution = '' WHERE Institution like '%h%'
--UPDATE UploadWorkBook SET Institution = '' WHERE Institution like '%h%'
--UPDATE UploadWorkBook SET Institution = '' WHERE Institution like '%h%'
--UPDATE UploadWorkBook SET Institution = '' WHERE Institution like '%h%'


--select Institution, city from UploadWorkBook where Institution like '%cole de technologie supTrieure (UniversitT du QuTbec)%'
--select name, city from lu_Institution where name like '%cole polytechnique de Mont%'


SELECT u.Institution, u.CIty INTO #missingInst FROM UploadWorkBook u
LEFT JOIN Institution i ON u.Institution = i.Name AND u.City = i.City
WHERE i.InstitutionID IS NULL 

IF EXISTS (select * FROM #missingInst)
BEGIN
SELECT DISTINCT 'Institution cannot be mapped' AS Issue, w.institution AS 'workbook - Institution Name', w.city AS 'workbook - Institution city', l.Name AS 'lookup -Institution Name', l.city AS 'lookup - Institution City' 
FROM (select Institution FROM #missingInst group by Institution, city) m
LEFT JOIN Institution l ON m.Institution = l.Name
LEFT JOIN UploadWorkBook w ON m.Institution = w.institution
ORDER BY  w.institution 
END 

--select name, city from lu_Institution where name like '%Eidgen%'
--select distinct institution, city from UploadWorkBook where institution like '%Eidgen?ssiche Technische Hochschule (ETH) Z�rich%'

--Centre National de la Recherche Scientifique (CNRS), l'INSERM (Institut National de la Sant? et de la Recherche M?dicale) - UNSA
--Centre National de la Recherche Scientifique (CNRS), l'INSERM (Institut National de la Sant� et de la Recherche M�dicale) - UNSA
--Centre National de la Recherche Scientifique (CNRS), l''INSERM (Institut National de la Sant� et de la Recherche M�dicale) - UNSA


--SELECT u.Institution, u.CIty INTO #missingInst2 FROM UploadWorkBook u
--LEFT JOIN UploadInstitution i ON u.Institution = i.DedupInstitution AND u.City = i.City_Clean
--WHERE i.DedupInstitution IS NULL 

--select * FROM #missingInst2 order by Institution

/***********************************************************************************************/
-- Import Data
/***********************************************************************************************/
-----------------------------------
-- Import base Projects
-----------------------------------
INSERT INTO Project 
SELECT CASE ISNULL(Childhood, '') WHEN 'y' THEN 1 ELSE 0 END, 
		AwardCode, 1, AwardStartDate, AwardEndDate, getdate(), getdate()
FROM #parentProjects

-----------------------------------
-- Import Project Abstract
-----------------------------------
CREATE TABLE UploadAbstract (	
	ID INT NOT NULL IDENTITY(1,1),
	AwardCode NVARCHAR(50),
	Altid NVARCHAR(50),
	TechAbstract NVARCHAR (MAX) NULL,
	PublicAbstract NVARCHAR (MAX) NULL
) ON [PRIMARY]

SET IDENTITY_INSERT UploadAbstract ON;  -- SET IDENTITY_INSERT to ON. 
GO 

INSERT INTO UploadAbstract (ID) SELECT ProjectAbstractID FROM ProjectAbstract

SET IDENTITY_INSERT UploadAbstract OFF  -- SET IDENTITY_INSERT to ON. 
GO 

INSERT INTO UploadAbstract (AwardCode, Altid, TechAbstract, PublicAbstract) SELECT DISTINCT AwardCode, Altid, TechAbstract, PublicAbstract FROM UploadWorkBook 

SET IDENTITY_INSERT ProjectAbstract ON;  -- SET IDENTITY_INSERT to ON. 
GO 

INSERT INTO ProjectAbstract (ProjectAbstractID, TechAbstract, PublicAbstract) 
SELECT ID, TechAbstract, PublicAbstract FROM UploadAbstract  WHERE AwardCode IS NOT NULL

SET IDENTITY_INSERT ProjectAbstract OFF;  -- SET IDENTITY_INSERT to OFF. 
GO 
-----------------------------------
-- Import ProjectFunding
-----------------------------------
INSERT INTO ProjectFunding
SELECT u.AwardTitle, p.ProjectID, o.FundingOrgID, d.FundingDivisionID, a.ID,    --ProjectAbtractID
	u.Category, u.AltId, u.SourceId, u.FundingMechanismCode, u.FundingMechanism, u.FundingContact, 
	CASE ISNULL(u.IsAnnualized, '') WHEN 'A' THEN 1 ELSE 0 END, 
	u.AwardFunding, 
	u.BudgetStartDate, u.BudgetEndDate, getdate(), getdate()
FROM UploadWorkBook u
JOIN UploadAbstract a ON u.AwardCode = a.AwardCode AND u.AltId = a.Altid
JOIN Project p ON u.AwardCode = p.awardCode
JOIN FundingOrg o ON u.FundingOrgAbbr = o.Abbreviation
LEFT JOIN FundingDivision d ON u.FundingDivAbbr = d.Abbreviation
GO
-----------------------------------
-- Import ProjectFundingInvestigator
-----------------------------------
INSERT INTO ProjectFundingInvestigator ([ProjectFundingID], [LastName],	[FirstName],[ORC_ID],[OtherResearch_ID],[OtherResearch_Type],[IsPrivateInvestigator],[InstitutionID],[InstitutionNameSubmitted])
SELECT f.ProjectFundingID, u.PILastName, u.PIFirstName, u.ORCID, u.OtherResearcherID, u.OtherResearcherIDType, 1, ISNULL(i.InstitutionID,1), u.Institution
FROM UploadWorkBook u
JOIN ProjectFunding f ON u.AltID = f.AltAwardCode
LEFT JOIN Institution i ON u.Institution = i.Name AND u.City = i.City
GO
-----------------------------------
-- Import ProjectCancerCSO
-----------------------------------
SELECT f.projectID, f.ProjectFundingID, f.AltAwardCode, u.CSOCodes, u.CSORel, u.SiteCodes, u.SiteRel, AwardType INTO #list
FROM UploadWorkBook u
JOIN ProjectFunding f ON u.AltId = f.AltAwardCode

DECLARE @pcso TABLE
(
	Seq INT NOT NULL IDENTITY (1,1),
	ProjectFundingID INT,
	CSO VARCHAR(50)	
)

DECLARE @pcsorel TABLE
(
	Seq INT NOT NULL IDENTITY (1,1),
	ProjectFundingID INT,	
	Rel VARCHAR(50)
)

DECLARE @projectFundingID as INT
DECLARE @csoList as NVARCHAR(50)
DECLARE @csoRelList as NVARCHAR(50)
 
DECLARE @cursor as CURSOR;

SET @cursor = CURSOR FOR
SELECT ProjectFundingID, CSOCodes , CSORel FROM #list;
 
OPEN @cursor;
FETCH NEXT FROM @cursor INTO @projectFundingID, @csoList, @csoRelList;

WHILE @@FETCH_STATUS = 0
BEGIN
 INSERT INTO @pcso SELECT @projectFundingID, value FROM  dbo.ToStrTable(@csoList)
 INSERT INTO @pcsorel SELECT @projectFundingID, value FROM  dbo.ToStrTable(@csoRelList) 
 FETCH NEXT FROM @cursor INTO @projectFundingID, @csolist, @csoRelList;
END
 
CLOSE @cursor;
DEALLOCATE @cursor;

INSERT INTO ProjectCSO SELECT c.ProjectFundingID, c.CSO, r.Rel, 'S', getdate(), getdate()
FROM @pcso c 
JOIN @pcsorel r ON c.ProjectFundingID = r.ProjectFundingID AND c.Seq = r.Seq
GO

-----------------------------------
-- Import ProjectCancerType
-----------------------------------
DECLARE @psite TABLE
(
	Seq INT NOT NULL IDENTITY (1,1),
	ProjectFundingID INT,
	Code VARCHAR(50)	
)

DECLARE @psiterel TABLE
(
	Seq INT NOT NULL IDENTITY (1,1),
	ProjectFundingID INT,	
	Rel VARCHAR(50)
)

DECLARE @projectFundingID as INT
DECLARE @siteList as NVARCHAR(50)
DECLARE @siteRelList as NVARCHAR(50)
 
DECLARE @cursor as CURSOR;

SET @cursor = CURSOR FOR
SELECT ProjectFundingID, SiteCodes , SiteRel FROM #list;
 
OPEN @cursor;
FETCH NEXT FROM @cursor INTO @projectFundingID, @siteList, @siteRelList;

WHILE @@FETCH_STATUS = 0
BEGIN
 INSERT INTO @psite SELECT @projectFundingID, value FROM  dbo.ToStrTable(@siteList)
 INSERT INTO @psiterel SELECT @projectFundingID, value FROM  dbo.ToStrTable(@siteRelList) 
 FETCH NEXT FROM @cursor INTO @projectFundingID, @siteList, @siteRelList;
END
 
CLOSE @cursor;
DEALLOCATE @cursor;

INSERT INTO ProjectCancerType (ProjectFundingID, CancerTypeID, Relevance, RelSource, EnterBy)
SELECT c.ProjectFundingID, ct.CancerTypeID, r.Rel, 'S', 'S'
FROM @psite c 
JOIN CancerType ct ON c.code = ct.ICRPCode
JOIN @psiterel r ON c.ProjectFundingID = r.ProjectFundingID AND c.Seq = r.Seq
go
	
-----------------------------------
-- Import Project_ProjectTye
-----------------------------------
DECLARE @ptype TABLE
(	
	ProjectID INT,	
	ProjectType VARCHAR(15)
)

DECLARE @projectID as INT
DECLARE @typeList as NVARCHAR(50)
 
DECLARE @cursor as CURSOR;

SET @cursor = CURSOR FOR
SELECT ProjectID, AwardType FROM (SELECT DISTINCT ProjectID, AWardType FROM #list) p;
 
OPEN @cursor;
FETCH NEXT FROM @cursor INTO @projectID, @typeList;

WHILE @@FETCH_STATUS = 0
BEGIN
 INSERT INTO @ptype SELECT @projectID, value FROM  dbo.ToStrTable(@typeList) 
 FETCH NEXT FROM @cursor INTO @projectID, @typeList;
END
 
CLOSE @cursor;
DEALLOCATE @cursor;

INSERT INTO Project_ProjectType (ProjectID, ProjectType)
SELECT ProjectID,
		CASE ProjectType
		  WHEN 'C' THEN 'Clinical Trial'
		  WHEN 'R' THEN 'Research'
		  WHEN 'T' THEN 'Training'
		END
FROM @ptype	
	
-----------------------------------
-- Import ProjectFundingExt
-----------------------------------