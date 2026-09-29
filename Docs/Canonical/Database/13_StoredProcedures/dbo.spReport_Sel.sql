SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spReport_Sel]
(
	@Report_Name varchar(100) 
)
AS
	select *, 
		(case 
			when tipo = 'E' then 'E - Excel' 
			when tipo = 'H' then 'H - Excel Details' 
			when tipo = 'C' then 'C - Crystal' 
			when tipo = 'T' then 'T - Text(TXT)' 
			when tipo = 'A' then 'A - Alert(Email)'
		else '' end) [Type] 
	from 
		report R
		left join report_detalhe D on D.id_report = R.id
	where 
		report_name = @Report_Name 



GO
