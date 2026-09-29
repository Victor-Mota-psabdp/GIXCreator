SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Log_FollowUp_Envio
CREATE procedure [dbo].[spATL_FollowUpAMZ_EnviaEmail_Teste_Rel]

as

select 
	'carlos.eduardo@bdpint.com'	strDestinatario,
	--Follow up Amazonas - Invoice "x" - Importador "x"
	'Follow UP Amazonas - Invoice ' 
		+ isnull([dbo].[fBusca_Docs_PO_Modal](HOU.Num_Proc,2),'') 
		+ ' - Importador ' +  EX.Nome_Raz_Soc				[strAssunto], 
	'Follow UP: ' + HOU.Num_Proc 
		+ '||Created automatically by ATL System'			strCorpoMSG, 
	HOU.Num_Proc + '.pdf'									strAnexo,
	'carlos.eduardo@bdpint.com'							strResponderPara,
	'AMZ_FollowUp.rpt'										Report_Name,
	HOU.Num_Proc											Num_Proc	
from 
	vwHouse_EXP HOU with(nolock)
	left join Tarefas_Processos TP40 with(nolock) on HOU.Num_Proc = TP40.Num_Proc and TP40.ID_Task = 40
	join Pessoa EX with(nolock) on HOU.Cd_Export = Ex.Cd_Pes
	join Pessoa_LLP PL with(nolock) on EX.Cd_Pes = PL.Cd_Pes
	join Grupo GP with(nolock) on PL.Cd_Pes_Grupo = GP.Cd_Pes_Grupo
where 
	GP.Grupo = 'AMZ' 
	and TP40.Dt_Conclusao is null
	and isnull(HOU.ID_Status,0) < 9
	
UNION ALL

select
	'carlos.eduardo@bdpint.com'	strDestinatario, 
		--Follow up Amazonas - Invoice "x" - Importador "x"
	'Follow UP Amazonas - Invoice ' 
			+ isnull([dbo].[fBusca_Docs_PO_Modal](HOU.Num_Proc,2),'') 
			+ ' - Importador ' +  EX.Nome_Raz_Soc				[strAssunto],
	'Follow UP: ' + HOU.Num_Proc 
	+ '||Created automatically by ATL System'				strCorpoMSG, 
	HOU.Num_Proc + '.pdf'									strAnexo,
	'carlos.eduardo@bdpint.com'							strResponderPara, 
	'AMZ_FollowUp.rpt'										Report_Name,
	HOU.Num_Proc											Num_Proc	
from 
	vwHouse_IMP HOU with(nolock)
	left join Tarefas_Processos TP40 with(nolock) on HOU.Num_Proc = TP40.Num_Proc and TP40.ID_Task = 40
	join Pessoa EX with(nolock) on HOU.Cd_Consig = Ex.Cd_Pes
	join Pessoa_LLP PL with(nolock) on EX.Cd_Pes = PL.Cd_Pes
	join Grupo GP with(nolock) on PL.Cd_Pes_Grupo = GP.Cd_Pes_Grupo	
where 
	GP.Grupo = 'AMZ' 
	and TP40.Dt_Conclusao is null
	and isnull(HOU.ID_Status,0) < 9
	
	
GO
