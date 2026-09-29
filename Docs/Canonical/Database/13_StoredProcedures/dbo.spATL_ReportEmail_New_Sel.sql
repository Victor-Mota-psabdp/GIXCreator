SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from usuario where cd_area = 'TII'and ck_ativo  =1


--spATL_ReportEmail_New_Sel 81,'ce','TII'

CREATE procedure [dbo].[spATL_ReportEmail_New_Sel]

	@ID_Report int,
	@cd_usuario varchar(50),
	@cd_area varchar(3)

AS

	if @cd_area = 'TII'
		begin
			set @cd_usuario = 'ADMIN'
		End

	select 
		id_alerta [ID],
		(case
			when Tipo='D' then 'Daily'
			when Tipo='W' then 'Weekly'
			when Tipo='M' then 'Monthly'
		end) [Type],
		dbo.Bit_to_String(Tipo,Mes_Semana) [In],
		dbo.Bit_to_String('DM',Dia) [Day(s)],
		right('0' + cast(hr_Envio as varchar(2)),2) + ':00' [Time],
		Parametros [Parameters],
		Email,
		disable [Disable]
	from 
		Report_Email E
	where 
		ID_Report = @ID_Report and (cd_usuario = @cd_usuario OR @cd_usuario = 'ADMIN')
	order by
		1




GO
