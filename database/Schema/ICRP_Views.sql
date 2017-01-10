
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
				pf.Amount, i.City, i.State, i.country, fo.FundingOrgID AS FundingOrgID, fo.[Abbreviation] AS FundingOrg, 
				pt.ProjectType, ct.CancerTypeID, c.Name AS CancerType, cso.CSOCode, ext.CalendarYear
FROM Project p	WITH (NOLOCK)
	JOIN ProjectFunding pf WITH (NOLOCK) ON p.ProjectID = pf.ProjectID 
	JOIN ProjectFundingExt ext WITH (NOLOCK) ON p.ProjectID = ext.ProjectID
	JOIN ProjectFundingInvestigator fi WITH (NOLOCK) ON fi.ProjectFundingID = pf.ProjectFundingID	
	JOIN Institution i WITH (NOLOCK) ON i.InstitutionID = fi.InstitutionID	
	JOIN FundingOrg fo WITH (NOLOCK) ON fo.FundingOrgID = pf.FundingOrgID
	JOIN Project_ProjectType pt WITH (NOLOCK) ON p.ProjectID = pt.ProjectID
	JOIN ProjectCancerType ct WITH (NOLOCK) ON pf.ProjectFundingID = ct.ProjectFundingID
	JOIN CancerType c WITH (NOLOCK) ON c.CancerTypeID = ct.CancerTypeID	
	JOIN ProjectCSO cso WITH (NOLOCK) ON pf.ProjectFundingID = cso.ProjectFundingID
	

GO


/****** Object:  View [dbo].[vwProjectFundings]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists(select 1 from sys.views where name='vwProjectFundings' and type='v')
DROP VIEW [dbo].[vwProjectFundings]
GO 

CREATE VIEW [dbo].[vwProjectFundings] AS

SELECT DISTINCT p.ProjectID, p.AwardCode, pf.ProjectFundingID, pf.Title, fi.LastName  AS piLastName, fi.FirstName AS piFirstName, fi.ORC_ID AS piORCiD, i.Name AS institution, 
				pf.Amount, i.City, i.State, i.country, pf.FundingOrgID, o.name AS FundingOrg, o.abbreviation AS FundingOrgShort
				
FROM Project p	WITH (NOLOCK)
	JOIN ProjectFunding pf WITH (NOLOCK) ON p.ProjectID = pf.ProjectID 	
	JOIN ProjectFundingInvestigator fi WITH (NOLOCK) ON fi.ProjectFundingID = pf.ProjectFundingID	
	JOIN Institution i WITH (NOLOCK) ON i.InstitutionID = fi.InstitutionID	
	JOIN FundingOrg o ON pf.FundingOrgID = o.FundingOrgID 

GO