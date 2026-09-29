SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[spATL_TesteReportXLS_Rel]--'C' --spATL_NetRevenue_Sel '','01-01-2013','03-31-2013'
	(
	@Tipo			Varchar(1)
	)
AS	
	select 
		*
	 from 
		report 
	 where 
		tipo = @tipo


GO
