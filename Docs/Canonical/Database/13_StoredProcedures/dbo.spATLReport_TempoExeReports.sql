SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATLReport_TempoExeReports]  
@DtInicial datetime = null  
--@DtFinal datetime    
AS  



if @DtInicial is null  
	set @DtInicial = dbo.fGetDateBR()

	select   
	id_report,   
	Id_Alerta			as id_agendamento,  
	report_name,  
	Email,  
	parametros,  
	hr_envio,  
	(select isnull(max(re2.ultimo_envio),CAST(@DtInicial AS DATE)) 
	from report_email re2  (nolock)
	where re2.ultimo_envio < re.ultimo_envio  
	and ultimo_envio >= CAST(@DtInicial AS DATE)
	) AS ini_geracao_report,   

	Convert(Char(8),
		(select isnull(max(re2.ultimo_envio),CAST(@DtInicial AS DATE))  
from report_email re2  (nolock)
where re2.ultimo_envio < re.ultimo_envio  
and ultimo_envio >= CAST(@DtInicial AS DATE)),114) AS hr_ini_geracao_report,   

ultimo_envio as ultimo_envio,   

Convert(Char(8),ultimo_envio,114) as hr_ultimo_envio, 

datediff ( minute,   
      
(select isnull(max(re2.ultimo_envio),CAST(@DtInicial AS DATE))  
from report_email re2  (nolock)
where re2.ultimo_envio < re.ultimo_envio  
and ultimo_envio >= CAST(@DtInicial AS DATE))  
  
,  ultimo_envio ) as tempo_processamento_minutos  
,obs  
--into aux_ale  
from report_email re   (nolock)
inner join report  
on id_report = id  
where disable = 0   
and ultimo_envio >= cAST(CAST(@DtInicial AS DATE) AS DATETIME)  
order by ultimo_envio asc   
  
  
GO
