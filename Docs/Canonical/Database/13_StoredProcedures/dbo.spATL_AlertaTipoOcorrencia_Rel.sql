SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[spATL_AlertaTipoOcorrencia_Rel]

AS
	select 
		HSGProcesso JOB, ResponderPara, Assunto, Emails, HG.cd_tp_ocor, HG.HSDDescricao Mensagem, --dbo.fBusca_Docs_PO_Modal(HG.HSGProcesso,'1') PO,
		isnull(PEA.Numero_PO_HEA,isnull(PEM.Numero_PO_HEM,isnull(PEO.Numero_PO_HEO,isnull(PIA.Numero_PO_HIA,isnull(PIM.Numero_PO_HIM,isnull(PIO.Numero_PO_HIO,'')))))) PO,
		(Select nome_tp_ocor from tipo_ocorrencia with(nolock) where cd_tp_ocor = HG.cd_tp_ocor) Ocorrencia
	from
		alerta_ocorrencia AO with(nolock)
		Join Grupo GRP with(nolock) on GRP.cd_pes_grupo=AO.cd_pes_Grupo
		Join Hist_GEral HG with(nolock) on substring(hsgprocesso,3,3)=grupo and ao.cd_tp_ocor=hg.cd_tp_ocor
		left join PO_HEA PEA with(nolock) on PEA.num_proc_hea = HG.HSGProcesso and PEA.ID_DC='1'
		left join PO_HEM PEM with(nolock) on PEM.num_proc_hem = HG.HSGProcesso and PEM.ID_DC='1'
		left join PO_HEO PEO with(nolock) on PEO.num_proc_heo = HG.HSGProcesso and PEO.ID_DC='1'
		left join PO_HIA PIA with(nolock) on PIA.num_proc_hia = HG.HSGProcesso and PIA.ID_DC='1'
		left join PO_HIM PIM with(nolock) on PIM.num_proc_him = HG.HSGProcesso and PIM.ID_DC='1'
		left join PO_HIO PIO with(nolock) on PIO.num_proc_hio = HG.HSGProcesso and PIO.ID_DC='1'
	where
		HSGdata > getdate()-1 and HG.Disp_Cliente = 'S' and HSGDataConf is null




GO
