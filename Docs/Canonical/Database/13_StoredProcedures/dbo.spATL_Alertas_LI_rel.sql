SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--estava puxando o 9 - customer PO, alterei pro 1 - PO
--12/3/13 a marcia solicitou que seja enviado o customer PO
--select * from dbo.Alerta_Email_Historico where id_alerta_email =71

CREATE Procedure [dbo].[spATL_Alertas_LI_rel]
	
as

select distinct
	TF.num_proc							[JOB],
	isnull(PHIM.Nome_raz_soc,isnull(PHIA.Nome_raz_soc,PHIO.Nome_raz_soc)) [Consignee],
	isnull(POM.Numero_PO_HIM,isnull(POA.Numero_PO_HIA,POO.Numero_PO_HIO)) [Num_PO],
--	LI.num_li							[Numero da LI],
	[dbo].[fBusca_Num_LI](TF.num_proc)	[LI],
	convert(varchar,LI.dt_solicitacao,103)[Dt_Emissao],
	convert(varchar,LI.dt_vencimento,103)[Dt_vencimento],
	convert(varchar,TF.dt_conclusao,103)[Dt_deferimento],
	AE.Destinatarios					[Emails],
	AE.id								[ID],
	'marcias@bdp.com.br'				[ResponderPara],
	'Deferimento de LI'					[Assunto],
	'Deferimento de LI'					[Descricao],
	'Envio de E-mail'					[Tipo_Ocorrencia]	
from Tarefas_Processos TF With(nolock)
	Join solicitacao_li				LI With(nolock) on TF.num_proc=LI.num_proc and LI.ID_status = 5
	Left Join PO_HIM				POM	With(nolock) on POM.num_proc_him=TF.num_proc and POM.id_dc=9
	Left Join PO_HIA				POA	With(nolock) on POA.num_proc_hia=TF.num_proc and POA.id_dc=9
	Left Join PO_HIO				POO	With(nolock) on POO.num_proc_hio=TF.num_proc and POO.id_dc=9
	left join House_imp_mar			HIM With(nolock) on HIM.num_proc_him=TF.num_proc
	left join pessoa				PHIM With(nolock) on HIM.cd_consig_him=PHIM.cd_pes
	left join House_imp_aer			HIA With(nolock) on HIA.num_proc_hia=TF.num_proc
	left join pessoa				PHIA With(nolock) on HIA.cd_consig_hia=PHIM.cd_pes
	left join House_imp_out			HIO With(nolock) on HIO.num_proc_hio=TF.num_proc
	left join pessoa				PHIO With(nolock) on HIO.cd_consig_hio=PHIM.cd_pes
	Left Join Hist_Geral_Sistema	HSD With(nolock) on HSGPRocesso=LI.num_proc and cd_tp_ocor=79
	--left join msdb.dbo.Alerta_Email	AE	with(nolock) on AE.id=71
	left join Alerta_Email	AE	with(nolock) on AE.id=71
where 
	substring(TF.num_proc,3,3) in ('STB','CSR','ROB') and
	TF.dt_conclusao > getdate()-2 and
	TF.Id_task=20 and
	HSD.cd_tp_ocor is null




GO
