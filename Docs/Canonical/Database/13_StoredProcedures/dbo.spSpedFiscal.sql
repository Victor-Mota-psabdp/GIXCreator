SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[spSpedFiscal] --'ROB','2010-03-01','2010-03-31'

	@Grupo			varchar(3),
	@DataInicial	datetime,
	@DataFinal		datetime

AS

BEGIN
	select 
		'EM'											Modal,
		LLP.Num_proc_lem								Process,
		dbo.fbusca_docs_po_modal(HOU.num_proc_hem,4)	N_RE,
		dbo.fbusca_docs_po_modal(HOU.num_proc_hem,12)	N_DDE,
		''												N_MEM,
		LLP.ATD_LEM										Dt_ATD,
		''												VL_DE,
		dbo.fbusca_docs_po_modal(HOU.num_proc_hem,26)	N_DSE,
		LLP.courier_number_lem							N_Courier, 
		HOU.HAWB_HEM									House,
		HOU.MAWB_HEM									Master,
		''												TP_Conhec,
		DTD.Dt_Conclusao								Dt_DDE,
		DTA.Dt_Conclusao								Dt_Averb,
		''												DT_Mem,
		DTR.Dt_conclusao								DT_RE,
		''												Cod_Moed_Exp,
		''												Vl_RE,
		Dest.pais_local									Pais_Dest,
		''												Dt_Doc,
		''												Tp_Sis,
		dbo.fbusca_docs_po_modal(HOU.num_proc_hem,10)   Num_NF,
		convert(datetime,dbo.fBusca_TipoDocCliente ('D',HOU.num_proc_hem,10)) Dt_NF
	from 
		llp_exp_mar LLP
		join house_exp_mar				HOU on HOU.Num_proc_hem = LLP.Num_proc_lem
		left join localidade			Dest on Dest.cd_local = LLP.cd_dstfinal_lem
		left join tarefas_processos		DTA on DTA.Num_proc = LLP.num_proc_lem and DTA.id_task = '15'
		left join tarefas_processos		DTD on DTD.Num_proc = LLP.num_proc_lem and DTD.id_task = '12'
		left join tarefas_processos		DTR on DTR.Num_proc = LLP.num_proc_lem and DTR.id_task = '4'
	where
		right(left(HOU.Num_proc_hem,5),3) = @Grupo and DTA.Dt_conclusao between @DataInicial and @DataFinal

UNION

	select
		'EA'											Modal,
		LLP.Num_proc_lea								Process,
		dbo.fbusca_docs_po_modal(HOU.num_proc_hea,4)	N_RE,
		dbo.fbusca_docs_po_modal(HOU.num_proc_hea,12)	N_DDE,
		''												N_MEM,
		LLP.ATD_LEA										Dt_ATD,
		''												VL_DE,
		dbo.fbusca_docs_po_modal(HOU.num_proc_hea,26)	N_DSE,
		LLP.courier_number_lea							N_Courier, 
		HOU.HAWB_HEA									House,
		HOU.MAWB_HEA									Master,
		''												TP_Conhec,
		DTD.Dt_Conclusao								Dt_DDE,
		DTA.Dt_Conclusao								Dt_Averb,
		''												DT_Mem,
		DTR.Dt_conclusao								DT_RE,
		''												Cod_Moed_Exp,
		''												Vl_RE,
		Dest.pais_local									Pais_Dest,
		''												Dt_Doc,
		''												Tp_Sis,
		dbo.fbusca_docs_po_modal(HOU.num_proc_hea,10)	Num_NF,
		CONVERT(datetime,dbo.fBusca_TipoDocCliente ('D',HOU.num_proc_hea,10)) Dt_NF
	from 
		llp_exp_aer LLP
		join house_exp_aer				HOU on HOU.Num_proc_hea = LLP.Num_proc_lea
		left join localidade			Dest on Dest.cd_local = LLP.cd_dstfinal_lea
		left join tarefas_processos		DTA on DTA.Num_proc = LLP.num_proc_lea and DTA.id_task = '15'
		left join tarefas_processos		DTD on DTD.Num_proc = LLP.num_proc_lea and DTD.id_task = '12'
		left join tarefas_processos		DTR on DTR.Num_proc = LLP.num_proc_lea and DTR.id_task = '4'
	where
		right(left(HOU.Num_proc_hea,5),3) = @Grupo and DTA.Dt_conclusao between @DataInicial and @DataFinal

UNION

	select
		'EO'											Modal,
		LLP.Num_proc_leo								Process,
		dbo.fbusca_docs_po_modal(HOU.num_proc_heo,4)	N_RE,
		dbo.fbusca_docs_po_modal(HOU.num_proc_heo,12)	N_DDE,
		''												N_MEM,
		LLP.ATD_LEO										Dt_ATD,
		''												VL_DE,
		dbo.fbusca_docs_po_modal(HOU.num_proc_heo,26)	N_DSE,
		LLP.courier_number_leo							N_Courier, 
		HOU.HAWB_HEO									House,
		HOU.MAWB_HEO									Master,
		''												TP_Conhec,
		DTD.Dt_Conclusao								Dt_DDE,
		DTA.Dt_Conclusao								Dt_Averb,
		''												DT_Mem,
		DTR.Dt_conclusao								DT_RE,
		''												Cod_Moed_Exp,
		''												Vl_RE,
		Dest.pais_local									Pais_Dest,
		''												Dt_Doc,
		''												Tp_Sis,
		dbo.fbusca_docs_po_modal(HOU.num_proc_heo,10)	Num_NF,
		convert(datetime,dbo.fBusca_TipoDocCliente ('D',HOU.num_proc_heo,10)) Dt_NF
	from
		llp_exp_out LLP
		join house_exp_out				HOU on HOU.Num_proc_heo = LLP.Num_proc_leo
		left join localidade			Dest on Dest.cd_local = LLP.cd_dstfinal_leo
		left join tarefas_processos		DTA on DTA.Num_proc = LLP.num_proc_leo and DTA.id_task = '15'
		left join tarefas_processos		DTD on DTD.Num_proc = LLP.num_proc_leo and DTD.id_task = '12'
		left join tarefas_processos		DTR on DTR.Num_proc = LLP.num_proc_leo and DTR.id_task = '4'
	where
		right(left(HOU.Num_proc_heo,5),3) = @Grupo and DTA.Dt_conclusao between @DataInicial and @DataFinal

END





GO
