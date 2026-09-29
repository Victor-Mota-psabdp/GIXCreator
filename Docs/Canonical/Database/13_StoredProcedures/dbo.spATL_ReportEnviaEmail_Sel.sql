SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--select * from report_email where id_alerta = 117
--select convert(varchar(10),'2012-11-01 14:58:59.633',103)
--2012-11-01
--select convert(varchar(10),dbo.fGetDateBR(),103)
--
--update report_email
--	set obs = 'Error: Failure sending mail.',
--		ultimo_envio = 	'2012-11-01 14:58:59.633'
--where id_alerta = 39
--10/12/12  incluido os anexos pdf, Tipo e stored pra ser usada no novo c_email send
--27/06/2014 - Incluido pra enviar como xlsx

CREATE procedure [dbo].[spATL_ReportEnviaEmail_Sel]

as

	DECLARE @Dia INT, @Mes INT, @Dia_Semana INT

	SET @Dia = DAY(dbo.fGetDateBR())
	SET @Mes = MONTH(dbo.fGetDateBR())
	SET DATEFIRST 7
	SET @Dia_Semana = (Select DATEPART(dw,dbo.fGetDateBR()))

	select ultimo_envio,
		replace(E.Email,char(13),'') strDestinatario, 'Report: ' + R.Report_Name strAssunto, 
		'Report Name: ' + Report_Name + '||' +  Parametros + '||Parameters by ' + U.Nome_Usuario + '||Created automatically by ATL System' strCorpoMSG, 
--		convert(varchar,E.Id_Alerta) + '.xls' strAnexo, 
		(case when R.Tipo = 'C' then
			convert(varchar,E.Id_Alerta) + '.pdf'
		else
			convert(varchar,E.Id_Alerta) + '.xlsx' end) strAnexo, 
		U.Email strResponderPara, E.Id_Alerta, E.Id_Report, E.hr_Envio,
		R.tipo, R.stored,Parametros,Report_Name
	from 
		Report_Email E With(nolock)
		join Report  R With(nolock) on R.Id = E.Id_Report
		join Usuario U With(nolock) on U.cd_usuario = E.cd_usuario 
	where --Ultimo_Envio is null
		
		(
		(E.Tipo='D' and hr_Envio <= datename(HH,dbo.fGetDateBR()))
		or (E.Tipo='W' and substring(E.Mes_Semana,@Dia_Semana,1)=1 and hr_Envio <= datename(HH,dbo.fGetDateBR()))
		or (E.Tipo='M' and substring(E.Mes_Semana,@Mes,1)=1 and substring(E.Dia,@Dia,1)=1 and E.hr_Envio <= datename(HH,dbo.fGetDateBR()))
		)
		and (convert(varchar(10),E.Ultimo_Envio,103) <> convert(varchar(10),dbo.fGetDateBR(),103) or E.Ultimo_Envio is NULL or OBS is null or OBS <> 'Mail sent successfully!')
		and U.ck_ativo = '1' and disable = 0 and Ativo = 'S'
		and Id_Alerta not in ('155') --or R.ID = '74'
		order by E.hr_Envio, E.Id_Alerta

GO
