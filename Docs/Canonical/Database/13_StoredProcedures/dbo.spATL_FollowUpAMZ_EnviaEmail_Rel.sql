SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Processo de Exportação:
--fernandasiquieroli@amazonas.com.br
--fabricia.ianoni@bdpint.com

--Processo de Importação:
--antoniocarlos@amazonas.com.br
--fabricia.ianoni@bdpint.com

--14/7/2017 - O Antonio da Amazonas solicitou uma alteração no envio dos alertas, 
--ele pediu para retirar o e-mail dele  antoniocarlos@amazonas.com.br e 
--incluir o e-mail do Aprendiz compras@amazonas.com.br, poderia alterar?

--14/7/2017 - 17h - A Fernanda também solicitou a alteração no envio dos alertas, ela pediu para retirar o e-mail 
--dela fernandasiquieroli@amazonas.com.br e incluir o e-mail do Aprendiz menoraprendizexportacao@amazonas.com.br,
-- poderia alterar?

--11-1-2018 - 100-117618 retirado o email da fbricia e incluido da renata
CREATE procedure [dbo].[spATL_FollowUpAMZ_EnviaEmail_Rel]

as

select 
	'menoraprendizexportacao@amazonas.com.br;renata.sousa@bdpint.com'	strDestinatario,
	--Follow up Amazonas - Invoice "x" - Importador "x"
	'Follow UP Amazonas - Invoice ' 
		+ isnull([dbo].[fBusca_Docs_PO_Modal](HOU.Num_Proc,2),'') 
		+ ' - Importador ' +  EX.Nome_Raz_Soc				[strAssunto], 
	'Follow UP: ' + HOU.Num_Proc 
		+ '||Created automatically by ATL System'			strCorpoMSG, 
	HOU.Num_Proc + '.pdf'									strAnexo,
	'renata.sousa@bdpint.com'							strResponderPara,
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
	'compras@amazonas.com.br;renata.sousa@bdpint.com'	strDestinatario, 
		--Follow up Amazonas - Invoice "x" - Importador "x"
	'Follow UP Amazonas - Invoice ' 
			+ isnull([dbo].[fBusca_Docs_PO_Modal](HOU.Num_Proc,2),'') 
			+ ' - Importador ' +  EX.Nome_Raz_Soc				[strAssunto],
	'Follow UP: ' + HOU.Num_Proc 
	+ '||Created automatically by ATL System'				strCorpoMSG, 
	HOU.Num_Proc + '.pdf'									strAnexo,
	'renata.sousa@bdpint.com'							strResponderPara, 
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
	
	--and HOU.Num_Proc in
	
	--('IAAMZ201705002BR',
	--'IAAMZ201705003BR',
	--'IAAMZ201707001BR',
	--'IAATL201108056BR',
	--'IAATL201108070BR',
	--'IAATL201210037BR',
	--'IAATL201210038BR',
	--'IAATL201310004BR',
	--'IAATL201405051BR',
	--'IAATL201409071BR',
	--'IAATL201506029BR',
	--'IOAMZ201705001BR')
	
	



GO
