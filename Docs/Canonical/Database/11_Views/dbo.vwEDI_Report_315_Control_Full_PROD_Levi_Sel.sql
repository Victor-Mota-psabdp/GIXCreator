SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwEDI_Report_315_Control_Full_PROD_Levi_Sel]  
AS  
	SELECT
		ID_IN,Customer_Name,XML_DT,BDPJOBNUMBER,EVENTCODE,EVENTDESCRIPTION,Event_Dt,UniqueKey
	FROM 
		EDI.dbo.EDI_Report_315_Control_Full_PROD A with(nolock)  
	WHERE
		 Customer_name ='LEVI'
		

GO
