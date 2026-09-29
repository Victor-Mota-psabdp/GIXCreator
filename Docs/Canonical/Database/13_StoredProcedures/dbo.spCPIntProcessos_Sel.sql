SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spCPIntProcessos_Sel
	as

/*
08-12-2010 - Stored responsavel por buscar os processos pendentes de geração de Taxa
Anderson Oliveira
*/
select 
	Num_Proc_LIM Num_Proc,PP.Cd_Pes,PP.Cd_Pes_Grupo,Cd_Org_Him CD_Org,
	Cd_Dst_Him CD_DST,ATD_LIM Data 
from 
	llp_imp_mar LLP
	Join House_imp_mar Hou on hou.num_proc_him=num_proc_lim
	Join Pessoa_LLP PP on PP.cd_pes=cd_consig_him
	Left Join Hist_Geral HSG on HSG.hsgprocesso=num_proC_lim and cd_tp_ocor=98
where 
	atd_lim >= getdate()-30 and hsgprocesso is null

GO
