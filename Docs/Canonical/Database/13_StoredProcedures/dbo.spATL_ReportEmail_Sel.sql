SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--spATL_ReportEmail_Sel 8,'admin'

CREATE procedure [dbo].[spATL_ReportEmail_Sel]

	@ID_Report int,
	@cd_usuario varchar(50)

AS

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
