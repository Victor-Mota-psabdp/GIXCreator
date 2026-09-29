SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_ReportEnviaEmailWeekly_Sel]

as

	DECLARE @Dia INT, @Mes INT, @Dia_Semana INT

	SET @Dia = DAY(GETDATE())
	SET @Mes = MONTH(GETDATE())
	SET DATEFIRST 7
	SET @Dia_Semana = (Select DATEPART(dw,getdate()))

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
		Report_Email E
		join Report R on R.Id = E.Id_Report
		join Usuario U on U.cd_usuario = E.cd_usuario 
	where 
		(
		(E.Tipo='D' and hr_Envio <= datename(HH,getdate()))
		or (E.Tipo='W' and substring(E.Mes_Semana,@Dia_Semana,1)=1 and hr_Envio <= datename(HH,getdate()))
		or (E.Tipo='M' and substring(E.Mes_Semana,@Mes,1)=1 and substring(E.Dia,@Dia,1)=1 and E.hr_Envio <= datename(HH,getdate()))
		)
		and (convert(varchar(10),E.Ultimo_Envio,103) <> convert(varchar(10),getdate(),103) or E.Ultimo_Envio is NULL or OBS is null or OBS <> 'Mail sent successfully!')
		and U.ck_ativo = '1' and disable = 0 and Ativo = 'S'
		and Id_Alerta ='155'	
		
		--select * from Report_Email --set Ultimo_Envio = NULL, Obs = NULL
		--where Id_Alerta = '155'
		
		--2016-08-11 08:45:30.110	Mail sent successfully!

--	DECLARE @Dia INT, @Mes INT, @Dia_Semana INT

--	SET @Dia = DAY(GETDATE())
--	SET @Mes = MONTH(GETDATE())
--	SET DATEFIRST 7
--	SET @Dia_Semana = (Select DATEPART(dw,getdate()))

--	select ultimo_envio,
--		'carlos.eduardo@bdpint.com' strDestinatario, 
--		'Report: ' + R.Report_Name strAssunto, 
--		'Report Name: ' + Report_Name + '||' +  Parametros + '||Parameters by ' + U.Nome_Usuario + '||Created automatically by ATL System' strCorpoMSG, 
----		convert(varchar,E.Id_Alerta) + '.xls' strAnexo, 
--		(case when R.Tipo = 'C' then
--			convert(varchar,E.Id_Alerta) + '.pdf'
--		else
--			convert(varchar,E.Id_Alerta) + '.xlsx' end) strAnexo, 
--		'carlos.eduardo@bdpint.com' strResponderPara, E.Id_Alerta, E.Id_Report, E.hr_Envio,
--		R.tipo, R.stored,Parametros,Report_Name
--	from 
--		Report_Email E
--		join Report R on R.Id = E.Id_Report
--		join Usuario U on U.cd_usuario = E.cd_usuario 
--	where
--		ID_Alerta in (14)
--/*(
--		(E.Tipo='D' and hr_Envio <= datename(HH,getdate()))
--		or (E.Tipo='W' and substring(E.Mes_Semana,@Dia_Semana,1)=1 and hr_Envio <= datename(HH,getdate()))
--		or (E.Tipo='M' and substring(E.Mes_Semana,@Mes,1)=1 and substring(E.Dia,@Dia,1)=1 and E.hr_Envio <= datename(HH,getdate()))
--		)
--		and (convert(varchar(10),E.Ultimo_Envio,103) <> convert(varchar(10),getdate(),103) or E.Ultimo_Envio is NULL or OBS is null or OBS <> 'Mail sent successfully!')
--		and U.ck_ativo = '1' and disable = 0
		
--*/
GO
