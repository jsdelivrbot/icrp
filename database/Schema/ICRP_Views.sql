
/****** Object:  View [dbo].[vwProjects]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists(select 1 from sys.views where name='vwProjects' and type='v')
DROP VIEW [dbo].[vwProjects]
GO 


CREATE VIEW [dbo].[vwProjects] AS

SELECT DISTINCT p.ProjectID, p.AwardCode, pf.ProjectFundingID, pf.Title, fi.LastName  AS piLastName, fi.FirstName AS piFirstName, fi.ORC_ID AS piORCiD, i.Name AS institution, 
				pf.Amount, i.City, i.State, i.country, fo.FundingOrgID AS FundingOrgID, fo.Name AS FundingOrg, 
				pt.ProjectType, ct.CancerTypeID, c.Name AS CancerType, cso.CSOCode, ext.CalendarYear
FROM Project p	
	JOIN ProjectFunding pf ON p.ProjectID = pf.ProjectID 
	JOIN ProjectFundingExt ext ON p.ProjectID = ext.ProjectID
	JOIN ProjectFundingInvestigator fi ON fi.ProjectFundingID = pf.ProjectFundingID	
	JOIN Institution i ON i.InstitutionID = fi.InstitutionID	
	JOIN FundingOrg fo ON fo.FundingOrgID = pf.FundingOrgID
	JOIN Project_ProjectType pt ON p.ProjectID = pt.ProjectID
	JOIN ProjectCancerType ct ON p.ProjectID = ct.ProjectID
	JOIN CancerType c ON c.CancerTypeID = ct.CancerTypeID	
	JOIN ProjectCSO cso ON p.ProjectID = cso.ProjectID
	

GO
