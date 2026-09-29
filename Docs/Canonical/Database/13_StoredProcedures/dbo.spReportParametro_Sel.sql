SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spReportParametro_Sel]-- 78
	@id_Report int
as
	declare @Tipo char(1)
	set @Tipo = (select tipo from report where id = @id_Report)

	IF exists(select * from report_parametro where id_report = @id_report)
		Begin
			select 
				ordem [ ], Descr [Parameter], tipo [Type], '' [Value]
			from 
				Report_parametro
			where
				id_report = @id_report
			order by
				ordem
		End
	Else If @Tipo = 'R'
		Begin
			select 1 [ ], 'Reference' [Parameter], 'S' [Type], '' [Value] 
		End
	Else If @Tipo = 'A'
		Begin
			select 1 [ ], 'A - Alert(Email)' [Parameter], 'A' [Type], '' [Value] 
		End
	Else
		Begin
			select 1 [ ], 'Group Name' [Parameter], 'spPessoaATL_Sel ''%'',''T'',''Grupo%''' [Type], '' [Value] 
			union all
			select 2 [Order], 'Start Date' [Parameter], 'D' [Type], '' [Value] 
			union all
			select 3 [Order], 'End Date' [Parameter], 'D' [Type], '' [Value] 
			union all
			select 4 [Order], 'Type' [Parameter], 'select 0 union select 1' [Type], '' [Value] 
		End



GO
