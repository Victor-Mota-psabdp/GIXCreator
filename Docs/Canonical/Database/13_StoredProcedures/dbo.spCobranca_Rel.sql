SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[spCobranca_Rel] --'consagro%','','2013-01-01','2013-01-23'
(
	@Cliente as varchar(50),
	@Grupo as varchar(50),
	@DtInicial as datetime,
	@DtFinal as datetime
)
as


	
if @Grupo = 'AKZO-ALL'
Begin
	select distinct CLI.Apelido Cliente, CTC.Num_Proc_Hem JOB, convert(varchar(10),CTC.Num_NF_HEM) + CTC.Ref_Acesso_NF_HEM Num_NF, convert(datetime,BNF.Emissao,103) Emissao, isnull(PO.Numero_PO_Hem, PO_JOB.Numero_PO_Hem) PO,TT.Nome_tp_tx Taxa, CTC.DC_Hem DC, CTC.Vlr_Org_Hem*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_hem Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_hem,105)) Atraso from cta_cte_hou_exp_mar CTC
	left outer join caixa_hou_exp_mar CX on CTC.num_proc_hem = CX.num_proc_hem and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_hem = CX.DC_hem 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_hem = CLI.cd_pes
	left outer join PO_HEM PO with(nolock) on CTC.Num_Proc_Hem = PO.Num_Proc_Hem and ID_DC = 1
	left outer join House_exp_mar HOU with(nolock) on CTC.Num_Proc_Hem = HOU.Num_Proc_Hem
	left outer join JOB_Exp_mar JOB with(nolock) on HOU.JOB_Hem= JOB.Num_Proc_Hem
	left outer join PO_HEM PO_JOB with(nolock) on JOB.Num_Proc_Hem = PO_JOB.Num_Proc_Hem
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'EXM'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Pessoa_LLP PLLP with(nolock) on CTC.cd_cred_dev_hem =PLLP.CD_Pes
	left outer join Grupo GR with(nolock) on PLLP.cd_pes_grupo = GR.cd_pes_grupo
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_HEM = BNF.Nota_Fiscal and ctc.ref_acesso_nf_hem =  BNF.ref_acesso
	where CX.Num_proc_hem is null and left(CTC.Num_Proc_hem,5) <> 'EMJOB' and CTC.Desp_Dst_hem = 'N'  and (smart_exp = 'AKZ' or smart_imp = 'AKZ') and convert(datetime,Dt_Prev_Pgto_hem,103)  between @DtInicial and @DtFinal
	union ALL
	select distinct CLI.Apelido Cliente, CTC.Num_Proc_Hea JOB,convert(varchar(10),CTC.Num_NF_HEa) + CTC.Ref_Acesso_NF_HEa Num_NF, convert(datetime,BNF.Emissao,103) Emissao,isnull(PO.Numero_PO_Hea, PO_JOB.Numero_PO_Hea) PO,TT.Nome_tp_tx Taxa, CTC.DC_Hea DC, CTC.Vlr_Org_Hea*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_Hea Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_Hea,105))   from cta_cte_hou_exp_aer CTC
	left outer join caixa_hou_exp_aer CX on CTC.num_proc_Hea = CX.num_proc_Hea and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_Hea = CX.DC_Hea 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_Hea = CLI.cd_pes
	left outer join PO_Hea PO with(nolock) on CTC.Num_Proc_Hea = PO.Num_Proc_Hea and ID_DC = 1
	left outer join House_exp_aer HOU with(nolock) on CTC.Num_Proc_Hea = HOU.Num_Proc_Hea
	left outer join JOB_Exp_aer JOB with(nolock) on HOU.JOB_Hea= JOB.Num_Proc_Hea
	left outer join PO_Hea PO_JOB with(nolock) on JOB.Num_Proc_Hea = PO_JOB.Num_Proc_Hea
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'EXA'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Pessoa_LLP PLLP with(nolock) on CTC.cd_cred_dev_hea =PLLP.CD_Pes
	left outer join Grupo GR with(nolock) on PLLP.cd_pes_grupo = GR.cd_pes_grupo
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_HEA = BNF.Nota_Fiscal and ctc.ref_acesso_nf_hea =  BNF.ref_acesso
	where CX.Num_proc_Hea is null and left(CTC.Num_Proc_Hea,5) <> 'EAJOB' and CTC.Desp_Dst_hea = 'N' and (smart_exp = 'AKZ' or smart_imp = 'AKZ') and convert(datetime,Dt_Prev_Pgto_Hea,103)  between @DtInicial and @DtFinal

	union all

	select distinct CLI.Apelido Cliente, CTC.Num_Proc_Heo JOB,convert(varchar(10),CTC.Num_NF_HEo) + CTC.Ref_Acesso_NF_HEo Num_NF, convert(datetime,BNF.Emissao,103) Emissao,PO.Numero_PO_Heo PO,TT.Nome_tp_tx Taxa, CTC.DC_Heo DC, CTC.Vlr_Org_Heo*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_Heo Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_Heo,105))   from cta_cte_hou_exp_out CTC
	left outer join caixa_hou_exp_out CX on CTC.num_proc_Heo = CX.num_proc_Heo and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_Heo = CX.DC_Heo 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_Heo = CLI.cd_pes
	left outer join PO_Heo PO with(nolock) on CTC.Num_Proc_Heo = PO.Num_Proc_Heo and ID_DC = 1
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'OFC'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Pessoa_LLP PLLP with(nolock) on CTC.cd_cred_dev_heo =PLLP.CD_Pes
	left outer join Grupo GR with(nolock) on PLLP.cd_pes_grupo = GR.cd_pes_grupo
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_HEO = BNF.Nota_Fiscal and ctc.ref_acesso_nf_heo =  BNF.ref_acesso
	where CX.Num_proc_Heo is null and CTC.Desp_org_heo = 'N' and (smart_exp = 'AKZ' or smart_imp = 'AKZ') and convert(datetime,Dt_Prev_Pgto_Heo,103)  between @DtInicial and @DtFinal

	union all

	select distinct CLI.Apelido Cliente, CTC.Num_Proc_him JOB,convert(varchar(10),CTC.Num_NF_HiM) + CTC.Ref_Acesso_NF_HiM Num_NF,convert(datetime,BNF.Emissao,103) Emissao, isnull(PO.Numero_PO_him, PO_JOB.Numero_PO_him) PO,TT.Nome_tp_tx Taxa, CTC.DC_him DC, CTC.Vlr_Org_him*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_him Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_him,105))   from cta_cte_hou_imp_mar CTC
	left outer join caixa_hou_imp_mar CX on CTC.num_proc_him = CX.num_proc_him and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_him = CX.DC_him 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_him = CLI.cd_pes
	left outer join PO_him PO with(nolock) on CTC.Num_Proc_him = PO.Num_Proc_him and ID_DC = 1
	left outer join House_imp_mar HOU with(nolock) on CTC.Num_Proc_him = HOU.Num_Proc_him
	left outer join JOB_imp_mar JOB with(nolock) on HOU.JOB_him= JOB.Num_Proc_him
	left outer join PO_him PO_JOB with(nolock) on JOB.Num_Proc_him = PO_JOB.Num_Proc_him
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'IMM'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Pessoa_LLP PLLP with(nolock) on CTC.cd_cred_dev_him =PLLP.CD_Pes
	left outer join Grupo GR with(nolock) on PLLP.cd_pes_grupo = GR.cd_pes_grupo
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_HIM = BNF.Nota_Fiscal and ctc.ref_acesso_nf_him =  BNF.ref_acesso
	where CX.Num_proc_him is null and left(CTC.Num_Proc_him,5) <> 'IMJOB' and CTC.Desp_org_him = 'N' and (smart_exp = 'AKZ' or smart_imp = 'AKZ') and convert(datetime,Dt_Prev_Pgto_him,103)  between @DtInicial and @DtFinal

	union all

	select  distinct CLI.Apelido Cliente, CTC.Num_Proc_hia JOB,convert(varchar(10),CTC.Num_NF_Hia) + CTC.Ref_Acesso_NF_Hia Num_NF,convert(datetime,BNF.Emissao,103) Emissao, isnull(PO.Numero_PO_hia, PO_JOB.Numero_PO_hia) PO,TT.Nome_tp_tx Taxa, CTC.DC_hia DC, CTC.Vlr_Org_hia*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_hia Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_hia,105))   from cta_cte_hou_imp_aer CTC
	left outer join caixa_hou_imp_aer CX on CTC.num_proc_hia = CX.num_proc_hia and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_hia = CX.DC_hia 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_hia = CLI.cd_pes
	left outer join PO_hia PO with(nolock) on CTC.Num_Proc_hia = PO.Num_Proc_hia and ID_DC = 1
	left outer join House_imp_aer HOU with(nolock) on CTC.Num_Proc_hia = HOU.Num_Proc_hia
	left outer join JOB_imp_aer JOB with(nolock) on HOU.JOB_hia= JOB.Num_Proc_hia
	left outer join PO_hia PO_JOB with(nolock) on JOB.Num_Proc_hia = PO_JOB.Num_Proc_hia
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'IMM'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Pessoa_LLP PLLP with(nolock) on CTC.cd_cred_dev_hia =PLLP.CD_Pes
	left outer join Grupo GR with(nolock) on PLLP.cd_pes_grupo = GR.cd_pes_grupo
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_HIA = BNF.Nota_Fiscal and ctc.ref_acesso_nf_hia =  BNF.ref_acesso
	where CX.Num_proc_hia is null and left(CTC.Num_Proc_hia,5) <> 'IAJOB' and CTC.Desp_org_hia = 'N' and (smart_exp = 'AKZ' or smart_imp = 'AKZ') and convert(datetime,Dt_Prev_Pgto_hia,103)  between @DtInicial and @DtFinal

	union all

	select distinct CLI.Apelido Cliente, CTC.Num_Proc_hio JOB,convert(varchar(10),CTC.Num_NF_Hio) + CTC.Ref_Acesso_NF_Hio Num_NF,convert(datetime,BNF.Emissao,103) Emissao, PO.Numero_PO_hio PO,TT.Nome_tp_tx Taxa, CTC.DC_hio DC, CTC.Vlr_Org_hio*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_hio Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_hio,105))   from cta_cte_hou_imp_out CTC
	left outer join caixa_hou_imp_out CX on CTC.num_proc_hio = CX.num_proc_hio and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_hio = CX.DC_hio 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_hio = CLI.cd_pes
	left outer join PO_hio PO with(nolock) on CTC.Num_Proc_hio = PO.Num_Proc_hio and ID_DC = 1
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'OFC'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Pessoa_LLP PLLP with(nolock) on CTC.cd_cred_dev_hio =PLLP.CD_Pes
	left outer join Grupo GR with(nolock) on PLLP.cd_pes_grupo = GR.cd_pes_grupo
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_HIO = BNF.Nota_Fiscal and ctc.ref_acesso_nf_hio =  BNF.ref_acesso
	where CX.Num_proc_hio is null  and CTC.Desp_org_hio = 'N' and (smart_exp = 'AKZ' or smart_imp = 'AKZ') and convert(datetime,Dt_Prev_Pgto_hio,103)  between @DtInicial and @DtFinal

	union all

	select  distinct CLI.Apelido Cliente, CTC.Num_Proc_mem JOB,convert(varchar(10),CTC.Num_NF_mem) + CTC.Ref_Acesso_NF_mEM Num_NF,convert(datetime,BNF.Emissao,103) Emissao, PO.Numero_PO PO,TT.Nome_tp_tx Taxa, CTC.DC_mem DC, CTC.Vlr_Org_mem*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_mem Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_mem,105))   from cta_cte_mas_exp_mar CTC
	left outer join caixa_mas_exp_mar CX on CTC.num_proc_mem = CX.num_proc_mem and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_mem = CX.DC_mem 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_mem = CLI.cd_pes
	left outer join PO_Master PO with(nolock) on CTC.Num_Proc_MEM = PO.Num_Proc_master and ID_DC = 1
	left outer join Paridade AS PAR ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'EXM'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Pessoa_LLP PLLP with(nolock) on CTC.cd_cred_dev_mem =PLLP.CD_Pes
	left outer join Grupo GR with(nolock) on PLLP.cd_pes_grupo = GR.cd_pes_grupo
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_MEM = BNF.Nota_Fiscal and ctc.ref_acesso_nf_mem =  BNF.ref_acesso
	where CX.Num_proc_mem is null and CTC.Desp_dst_mem = 'N' and (smart_exp = 'AKZ' or smart_imp = 'AKZ') and convert(datetime,Dt_Prev_Pgto_mem,103)  between @DtInicial and @DtFinal

	union all

	select  distinct CLI.Apelido Cliente, CTC.Num_Proc_mea JOB,convert(varchar(10),CTC.Num_NF_mea) + CTC.Ref_Acesso_NF_mea Num_NF,convert(datetime,BNF.Emissao,103) Emissao, PO.Numero_PO PO,TT.Nome_tp_tx Taxa, CTC.DC_mea DC, CTC.Vlr_Org_mea*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_mea Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_mea,105))   from cta_cte_mas_exp_aer CTC
	left outer join caixa_mas_exp_aer CX on CTC.num_proc_mea = CX.num_proc_mea and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_mea = CX.DC_mea 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_mea = CLI.cd_pes
	left outer join PO_Master PO with(nolock) on CTC.Num_Proc_mea = PO.Num_Proc_master and ID_DC = 1
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'EXA'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Pessoa_LLP PLLP with(nolock) on CTC.cd_cred_dev_mea =PLLP.CD_Pes
	left outer join Grupo GR with(nolock) on PLLP.cd_pes_grupo = GR.cd_pes_grupo
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_MEA = BNF.Nota_Fiscal and ctc.ref_acesso_nf_mea =  BNF.ref_acesso
	where CX.Num_proc_mea is null and CTC.Desp_dst_mea = 'N' and (smart_exp = 'AKZ' or smart_imp = 'AKZ') and convert(datetime,Dt_Prev_Pgto_mea,103)  between @DtInicial and @DtFinal

	union all

	select  distinct CLI.Apelido Cliente, CTC.Num_Proc_mim JOB,convert(varchar(10),CtC.Num_NF_mim) + CtC.Ref_Acesso_NF_mim Num_NF,convert(datetime,BNF.Emissao,103) Emissao, PO.Numero_PO PO,TT.Nome_tp_tx Taxa, CTC.DC_mim DC, CTC.Vlr_Org_mim*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_mim Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_mim,105))   from cta_cte_mas_imp_mar CTC
	left outer join caixa_mas_imp_mar CX on CTC.num_proc_mim = CX.num_proc_mim and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_mim = CX.DC_mim 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_mim = CLI.cd_pes
	left outer join PO_Master PO with(nolock) on CTC.Num_Proc_mim = PO.Num_Proc_master and ID_DC = 1
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'IMM'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Pessoa_LLP PLLP with(nolock) on CTC.cd_cred_dev_mim =PLLP.CD_Pes
	left outer join Grupo GR with(nolock) on PLLP.cd_pes_grupo = GR.cd_pes_grupo
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_MIM = BNF.Nota_Fiscal and ctc.ref_acesso_nf_mim =  BNF.ref_acesso
	where CX.Num_proc_mim  is null and CTC.Desp_org_mim = 'N' and (smart_exp = 'AKZ' or smart_imp = 'AKZ') and convert(datetime,Dt_Prev_Pgto_mim,103)  between @DtInicial and @DtFinal

	union all

	select  distinct CLI.Apelido Cliente, CTC.Num_Proc_mia JOB,convert(varchar(10),CTC.Num_NF_mia) + CTC.Ref_Acesso_NF_mia Num_NF,convert(datetime,BNF.Emissao,103) Emissao, PO.Numero_PO PO,TT.Nome_tp_tx Taxa, CTC.DC_mia DC, CTC.Vlr_Org_mia*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_mia Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_mia,105))   from cta_cte_mas_imp_aer CTC
	left outer join caixa_mas_imp_aer CX on CTC.num_proc_mia = CX.num_proc_mia and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_mia = CX.DC_mia 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_mia = CLI.cd_pes
	left outer join PO_Master PO with(nolock) on CTC.Num_Proc_mia = PO.Num_Proc_master and ID_DC = 1
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'EXM'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Pessoa_LLP PLLP with(nolock) on CTC.cd_cred_dev_mia =PLLP.CD_Pes
	left outer join Grupo GR with(nolock) on PLLP.cd_pes_grupo = GR.cd_pes_grupo
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_MIA = BNF.Nota_Fiscal and ctc.ref_acesso_nf_mia =  BNF.ref_acesso
	where CX.Num_proc_mia is null and CTC.Desp_org_mia = 'N' and (smart_exp = 'AKZ' or smart_imp = 'AKZ') and convert(datetime,Dt_Prev_Pgto_mia,103)  between @DtInicial and @DtFinal
end

if @Grupo <> '' and @Grupo <> 'AKZO-ALL'
Begin
	select distinct CLI.Apelido Cliente, CTC.Num_Proc_Hem JOB, convert(varchar(10),CTC.Num_NF_HEM) + CTC.Ref_Acesso_NF_HEM Num_NF,convert(datetime,BNF.Emissao,103) Emissao, isnull(PO.Numero_PO_Hem, PO_JOB.Numero_PO_Hem) PO,TT.Nome_tp_tx Taxa, CTC.DC_Hem DC, CTC.Vlr_Org_Hem*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_hem Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_hem,105)) Atraso from cta_cte_hou_exp_mar CTC
	left outer join caixa_hou_exp_mar CX on CTC.num_proc_hem = CX.num_proc_hem and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_hem = CX.DC_hem 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_hem = CLI.cd_pes
	left outer join PO_HEM PO with(nolock) on CTC.Num_Proc_Hem = PO.Num_Proc_Hem and ID_DC = 1
	left outer join House_exp_mar HOU with(nolock) on CTC.Num_Proc_Hem = HOU.Num_Proc_Hem
	left outer join JOB_Exp_mar JOB with(nolock) on HOU.JOB_Hem= JOB.Num_Proc_Hem
	left outer join PO_HEM PO_JOB with(nolock) on JOB.Num_Proc_Hem = PO_JOB.Num_Proc_Hem
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'EXM'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Pessoa_LLP PLLP with(nolock) on CTC.cd_cred_dev_hem =PLLP.CD_Pes
	left outer join Grupo GR with(nolock) on PLLP.cd_pes_grupo = GR.cd_pes_grupo
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_HEM = BNF.Nota_Fiscal and ctc.ref_acesso_nf_hem =  BNF.ref_acesso
	where CX.Num_proc_hem is null and left(CTC.Num_Proc_hem,5) <> 'EMJOB' and CTC.Desp_Dst_hem = 'N'  and GR.Grupo like @grupo and convert(datetime,Dt_Prev_Pgto_hem,103)  between @DtInicial and @DtFinal

	union all

	select distinct CLI.Apelido Cliente, CTC.Num_Proc_Hea JOB,convert(varchar(10),CTC.Num_NF_HEa) + CTC.Ref_Acesso_NF_HEa Num_NF,convert(datetime,BNF.Emissao,103) Emissao, isnull(PO.Numero_PO_Hea, PO_JOB.Numero_PO_Hea) PO,TT.Nome_tp_tx Taxa, CTC.DC_Hea DC, CTC.Vlr_Org_Hea*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_Hea Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_Hea,105))   from cta_cte_hou_exp_aer CTC
	left outer join caixa_hou_exp_aer CX on CTC.num_proc_Hea = CX.num_proc_Hea and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_Hea = CX.DC_Hea 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_Hea = CLI.cd_pes
	left outer join PO_Hea PO with(nolock) on CTC.Num_Proc_Hea = PO.Num_Proc_Hea and ID_DC = 1
	left outer join House_exp_aer HOU with(nolock) on CTC.Num_Proc_Hea = HOU.Num_Proc_Hea
	left outer join JOB_Exp_aer JOB with(nolock) on HOU.JOB_Hea= JOB.Num_Proc_Hea
	left outer join PO_Hea PO_JOB with(nolock) on JOB.Num_Proc_Hea = PO_JOB.Num_Proc_Hea
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'EXA'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Pessoa_LLP PLLP with(nolock) on CTC.cd_cred_dev_hea =PLLP.CD_Pes
	left outer join Grupo GR with(nolock) on PLLP.cd_pes_grupo = GR.cd_pes_grupo
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_HEA = BNF.Nota_Fiscal and ctc.ref_acesso_nf_hea =  BNF.ref_acesso
	where CX.Num_proc_Hea is null and left(CTC.Num_Proc_Hea,5) <> 'EAJOB' and CTC.Desp_Dst_hea = 'N' and GR.Grupo like @Grupo and convert(datetime,Dt_Prev_Pgto_Hea,103)  between @DtInicial and @DtFinal

	union all

	select distinct CLI.Apelido Cliente, CTC.Num_Proc_Heo JOB,convert(varchar(10),CTC.Num_NF_HEo) + CTC.Ref_Acesso_NF_HEo Num_NF, convert(datetime,BNF.Emissao,103) Emissao,PO.Numero_PO_Heo PO,TT.Nome_tp_tx Taxa, CTC.DC_Heo DC, CTC.Vlr_Org_Heo*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_Heo Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_Heo,105))   from cta_cte_hou_exp_out CTC
	left outer join caixa_hou_exp_out CX on CTC.num_proc_Heo = CX.num_proc_Heo and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_Heo = CX.DC_Heo 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_Heo = CLI.cd_pes
	left outer join PO_Heo PO with(nolock) on CTC.Num_Proc_Heo = PO.Num_Proc_Heo and ID_DC = 1
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'OFC'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Pessoa_LLP PLLP with(nolock) on CTC.cd_cred_dev_heo =PLLP.CD_Pes
	left outer join Grupo GR with(nolock) on PLLP.cd_pes_grupo = GR.cd_pes_grupo
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_HEO = BNF.Nota_Fiscal and ctc.ref_acesso_nf_heo =  BNF.ref_acesso
	where CX.Num_proc_Heo is null and CTC.Desp_org_heo = 'N' and GR.Grupo like @Grupo and convert(datetime,Dt_Prev_Pgto_Heo,103)  between @DtInicial and @DtFinal

	union all

	select distinct CLI.Apelido Cliente, CTC.Num_Proc_him JOB,convert(varchar(10),CTC.Num_NF_HiM) + CTC.Ref_Acesso_NF_HiM Num_NF,convert(datetime,BNF.Emissao,103) Emissao, isnull(PO.Numero_PO_him, PO_JOB.Numero_PO_him) PO,TT.Nome_tp_tx Taxa, CTC.DC_him DC, CTC.Vlr_Org_him*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_him Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_him,105))   from cta_cte_hou_imp_mar CTC
	left outer join caixa_hou_imp_mar CX on CTC.num_proc_him = CX.num_proc_him and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_him = CX.DC_him 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_him = CLI.cd_pes
	left outer join PO_him PO with(nolock) on CTC.Num_Proc_him = PO.Num_Proc_him and ID_DC = 1
	left outer join House_imp_mar HOU with(nolock) on CTC.Num_Proc_him = HOU.Num_Proc_him
	left outer join JOB_imp_mar JOB with(nolock) on HOU.JOB_him= JOB.Num_Proc_him
	left outer join PO_him PO_JOB with(nolock) on JOB.Num_Proc_him = PO_JOB.Num_Proc_him
	left outer join Paridade AS PAR with(nolock)  ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'IMM'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Pessoa_LLP PLLP with(nolock) on CTC.cd_cred_dev_him =PLLP.CD_Pes
	left outer join Grupo GR with(nolock) on PLLP.cd_pes_grupo = GR.cd_pes_grupo
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_HIM = BNF.Nota_Fiscal and ctc.ref_acesso_nf_him =  BNF.ref_acesso
	where CX.Num_proc_him is null and left(CTC.Num_Proc_him,5) <> 'IMJOB' and CTC.Desp_org_him = 'N' and GR.Grupo like @Grupo and convert(datetime,Dt_Prev_Pgto_him,103)  between @DtInicial and @DtFinal

	union all

	select distinct CLI.Apelido Cliente, CTC.Num_Proc_hia JOB,convert(varchar(10),CTC.Num_NF_Hia) + CTC.Ref_Acesso_NF_Hia Num_NF,convert(datetime,BNF.Emissao,103) Emissao, isnull(PO.Numero_PO_hia, PO_JOB.Numero_PO_hia) PO,TT.Nome_tp_tx Taxa, CTC.DC_hia DC, CTC.Vlr_Org_hia*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_hia Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_hia,105))   from cta_cte_hou_imp_aer CTC
	left outer join caixa_hou_imp_aer CX on CTC.num_proc_hia = CX.num_proc_hia and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_hia = CX.DC_hia 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_hia = CLI.cd_pes
	left outer join PO_hia PO with(nolock) on CTC.Num_Proc_hia = PO.Num_Proc_hia and ID_DC = 1
	left outer join House_imp_aer HOU with(nolock) on CTC.Num_Proc_hia = HOU.Num_Proc_hia
	left outer join JOB_imp_aer JOB with(nolock) on HOU.JOB_hia= JOB.Num_Proc_hia
	left outer join PO_hia PO_JOB with(nolock) on JOB.Num_Proc_hia = PO_JOB.Num_Proc_hia
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'IMM'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Pessoa_LLP PLLP with(nolock) on CTC.cd_cred_dev_hia =PLLP.CD_Pes
	left outer join Grupo GR with(nolock) on PLLP.cd_pes_grupo = GR.cd_pes_grupo
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_HIA = BNF.Nota_Fiscal and ctc.ref_acesso_nf_hia =  BNF.ref_acesso
	where CX.Num_proc_hia is null and left(CTC.Num_Proc_hia,5) <> 'IAJOB' and CTC.Desp_org_hia = 'N' and GR.Grupo like @Grupo and convert(datetime,Dt_Prev_Pgto_hia,103)  between @DtInicial and @DtFinal

	union all

	select distinct CLI.Apelido Cliente, CTC.Num_Proc_hio JOB,convert(varchar(10),CTC.Num_NF_Hio) + CTC.Ref_Acesso_NF_Hio Num_NF,convert(datetime,BNF.Emissao,103) Emissao, PO.Numero_PO_hio PO,TT.Nome_tp_tx Taxa, CTC.DC_hio DC, CTC.Vlr_Org_hio*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_hio Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_hio,105))   from cta_cte_hou_imp_out CTC
	left outer join caixa_hou_imp_out CX on CTC.num_proc_hio = CX.num_proc_hio and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_hio = CX.DC_hio 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_hio = CLI.cd_pes
	left outer join PO_hio PO with(nolock) on CTC.Num_Proc_hio = PO.Num_Proc_hio and ID_DC = 1
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'OFC'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Pessoa_LLP PLLP with(nolock) on CTC.cd_cred_dev_hio =PLLP.CD_Pes
	left outer join Grupo GR with(nolock) on PLLP.cd_pes_grupo = GR.cd_pes_grupo
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_HIO = BNF.Nota_Fiscal and ctc.ref_acesso_nf_hio =  BNF.ref_acesso
	where CX.Num_proc_hio is null  and CTC.Desp_org_hio = 'N' and GR.Grupo like @Grupo and convert(datetime,Dt_Prev_Pgto_hio,103)  between @DtInicial and @DtFinal

	union all

	select distinct CLI.Apelido Cliente, CTC.Num_Proc_mem JOB,convert(varchar(10),CTC.Num_NF_mem) + CTC.Ref_Acesso_NF_mEM Num_NF,convert(datetime,BNF.Emissao,103) Emissao, PO.Numero_PO PO,TT.Nome_tp_tx Taxa, CTC.DC_mem DC, CTC.Vlr_Org_mem*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_mem Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_mem,105))   from cta_cte_mas_exp_mar CTC
	left outer join caixa_mas_exp_mar CX on CTC.num_proc_mem = CX.num_proc_mem and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_mem = CX.DC_mem 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_mem = CLI.cd_pes
	left outer join PO_Master PO with(nolock) on CTC.Num_Proc_MEM = PO.Num_Proc_master and ID_DC = 1
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'EXM'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Pessoa_LLP PLLP with(nolock) on CTC.cd_cred_dev_mem =PLLP.CD_Pes
	left outer join Grupo GR with(nolock) on PLLP.cd_pes_grupo = GR.cd_pes_grupo
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_MEM = BNF.Nota_Fiscal and ctc.ref_acesso_nf_mem =  BNF.ref_acesso
	where CX.Num_proc_mem is null and CTC.Desp_dst_mem = 'N' and GR.Grupo like @Grupo and convert(datetime,Dt_Prev_Pgto_mem,103)  between @DtInicial and @DtFinal

	union all

	select distinct CLI.Apelido Cliente, CTC.Num_Proc_mea JOB,convert(varchar(10),CTC.Num_NF_mea) + CTC.Ref_Acesso_NF_mea Num_NF,convert(datetime,BNF.Emissao,103) Emissao, PO.Numero_PO PO,TT.Nome_tp_tx Taxa, CTC.DC_mea DC, CTC.Vlr_Org_mea*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_mea Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_mea,105))   from cta_cte_mas_exp_aer CTC
	left outer join caixa_mas_exp_aer CX on CTC.num_proc_mea = CX.num_proc_mea and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_mea = CX.DC_mea 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_mea = CLI.cd_pes
	left outer join PO_Master PO with(nolock) on CTC.Num_Proc_mea = PO.Num_Proc_master and ID_DC = 1
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'EXA'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Pessoa_LLP PLLP with(nolock) on CTC.cd_cred_dev_mea =PLLP.CD_Pes
	left outer join Grupo GR with(nolock) on PLLP.cd_pes_grupo = GR.cd_pes_grupo
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_MEA = BNF.Nota_Fiscal and ctc.ref_acesso_nf_mea =  BNF.ref_acesso
	where CX.Num_proc_mea is null and CTC.Desp_dst_mea = 'N' and GR.Grupo like @Grupo and convert(datetime,Dt_Prev_Pgto_mea,103)  between @DtInicial and @DtFinal

	union all

	select distinct CLI.Apelido Cliente, CTC.Num_Proc_mim JOB,convert(varchar(10),CtC.Num_NF_mim) + CtC.Ref_Acesso_NF_mim Num_NF,convert(datetime,BNF.Emissao,103) Emissao, PO.Numero_PO PO,TT.Nome_tp_tx Taxa, CTC.DC_mim DC, CTC.Vlr_Org_mim*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_mim Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_mim,105))   from cta_cte_mas_imp_mar CTC
	left outer join caixa_mas_imp_mar CX on CTC.num_proc_mim = CX.num_proc_mim and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_mim = CX.DC_mim 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_mim = CLI.cd_pes
	left outer join PO_Master PO with(nolock) on CTC.Num_Proc_mim = PO.Num_Proc_master and ID_DC = 1
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'IMM'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Pessoa_LLP PLLP with(nolock) on CTC.cd_cred_dev_mim =PLLP.CD_Pes
	left outer join Grupo GR with(nolock) on PLLP.cd_pes_grupo = GR.cd_pes_grupo
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_MIM = BNF.Nota_Fiscal and ctc.ref_acesso_nf_mim =  BNF.ref_acesso
	where CX.Num_proc_mim  is null and CTC.Desp_org_mim = 'N' and GR.Grupo like @Grupo and convert(datetime,Dt_Prev_Pgto_mim,103)  between @DtInicial and @DtFinal

	union all

	select distinct CLI.Apelido Cliente, CTC.Num_Proc_mia JOB,convert(varchar(10),CTC.Num_NF_mia) + CTC.Ref_Acesso_NF_mia Num_NF,convert(datetime,BNF.Emissao,103) Emissao, PO.Numero_PO PO,TT.Nome_tp_tx Taxa, CTC.DC_mia DC, CTC.Vlr_Org_mia*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_mia Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_mia,105))   from cta_cte_mas_imp_aer CTC
	left outer join caixa_mas_imp_aer CX on CTC.num_proc_mia = CX.num_proc_mia and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_mia = CX.DC_mia 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_mia = CLI.cd_pes
	left outer join PO_Master PO with(nolock) on CTC.Num_Proc_mia = PO.Num_Proc_master and ID_DC = 1
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'EXM'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Pessoa_LLP PLLP with(nolock) on CTC.cd_cred_dev_mia =PLLP.CD_Pes
	left outer join Grupo GR with(nolock) on PLLP.cd_pes_grupo = GR.cd_pes_grupo
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_MIA = BNF.Nota_Fiscal and ctc.ref_acesso_nf_mia =  BNF.ref_acesso
	where CX.Num_proc_mia is null and CTC.Desp_org_mia = 'N' and GR.Grupo like @Grupo and convert(datetime,Dt_Prev_Pgto_mia,103)  between @DtInicial and @DtFinal
end

if @Grupo = ''
Begin
	select  distinct  CLI.Apelido Cliente, CTC.Num_Proc_Hem JOB, convert(varchar(10),CTC.Num_NF_HEM) + CTC.Ref_Acesso_NF_HEM Num_NF,convert(datetime,BNF.Emissao,103) Emissao, isnull(PO.Numero_PO_Hem, PO_JOB.Numero_PO_Hem) PO,TT.Nome_tp_tx Taxa, CTC.DC_Hem DC, CTC.Vlr_Org_Hem*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_hem Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_hem,105)) Atraso from cta_cte_hou_exp_mar CTC
	left outer join caixa_hou_exp_mar CX on CTC.num_proc_hem = CX.num_proc_hem and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_hem = CX.DC_hem 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_hem = CLI.cd_pes
	left outer join PO_HEM PO with(nolock) on CTC.Num_Proc_Hem = PO.Num_Proc_Hem and ID_DC = 1
	left outer join House_exp_mar HOU with(nolock) on CTC.Num_Proc_Hem = HOU.Num_Proc_Hem
	left outer join JOB_Exp_mar JOB with(nolock) on HOU.JOB_Hem= JOB.Num_Proc_Hem
	left outer join PO_HEM PO_JOB with(nolock) on JOB.Num_Proc_Hem = PO_JOB.Num_Proc_Hem
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'EXM'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_HEM = BNF.Nota_Fiscal and ctc.ref_acesso_nf_hem =  BNF.ref_acesso
	where CX.Num_proc_hem is null and left(CTC.Num_Proc_hem,5) <> 'EMJOB' and CTC.Desp_dst_hem = 'N' and Apelido like @Cliente and convert(datetime,Dt_Prev_Pgto_hem,103)  between @DtInicial and @DtFinal

	union all

	select  distinct CLI.Apelido Cliente, CTC.Num_Proc_Hea JOB,convert(varchar(10),CTC.Num_NF_HEa) + CTC.Ref_Acesso_NF_HEa Num_NF,convert(datetime,BNF.Emissao,103) Emissao, isnull(PO.Numero_PO_Hea, PO_JOB.Numero_PO_Hea) PO,TT.Nome_tp_tx Taxa, CTC.DC_Hea DC, CTC.Vlr_Org_Hea*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_Hea Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_Hea,105))   from cta_cte_hou_exp_aer CTC
	left outer join caixa_hou_exp_aer CX on CTC.num_proc_Hea = CX.num_proc_Hea and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_Hea = CX.DC_Hea 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_Hea = CLI.cd_pes
	left outer join PO_Hea PO with(nolock) on CTC.Num_Proc_Hea = PO.Num_Proc_Hea and ID_DC = 1
	left outer join House_exp_aer HOU with(nolock) on CTC.Num_Proc_Hea = HOU.Num_Proc_Hea
	left outer join JOB_Exp_aer JOB with(nolock) on HOU.JOB_Hea= JOB.Num_Proc_Hea
	left outer join PO_Hea PO_JOB with(nolock) on JOB.Num_Proc_Hea = PO_JOB.Num_Proc_Hea
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'EXA'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_HEA = BNF.Nota_Fiscal and ctc.ref_acesso_nf_hea =  BNF.ref_acesso
	where CX.Num_proc_Hea is null and left(CTC.Num_Proc_Hea,5) <> 'EAJOB' and CTC.Desp_dst_hea = 'N' and Apelido like @Cliente and convert(datetime,Dt_Prev_Pgto_Hea,103)  between @DtInicial and @DtFinal

	union all

	select  distinct CLI.Apelido Cliente, CTC.Num_Proc_Heo JOB,convert(varchar(10),CTC.Num_NF_HEo) + CTC.Ref_Acesso_NF_HEo Num_NF,convert(datetime,BNF.Emissao,103) Emissao, PO.Numero_PO_Heo PO,TT.Nome_tp_tx Taxa, CTC.DC_Heo DC, CTC.Vlr_Org_Heo*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_Heo Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_Heo,105))   from cta_cte_hou_exp_out CTC
	left outer join caixa_hou_exp_out CX on CTC.num_proc_Heo = CX.num_proc_Heo and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_Heo = CX.DC_Heo 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_Heo = CLI.cd_pes
	left outer join PO_Heo PO with(nolock) on CTC.Num_Proc_Heo = PO.Num_Proc_Heo and ID_DC = 1
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'OFC'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_HEO = BNF.Nota_Fiscal and ctc.ref_acesso_nf_heo =  BNF.ref_acesso
	where CX.Num_proc_Heo is null and CTC.Desp_org_heo = 'N' and Apelido like @Cliente and convert(datetime,Dt_Prev_Pgto_Heo,103)  between @DtInicial and @DtFinal

	union all

	select  distinct CLI.Apelido Cliente, CTC.Num_Proc_him JOB,convert(varchar(10),CTC.Num_NF_HiM) + CTC.Ref_Acesso_NF_HiM Num_NF,convert(datetime,BNF.Emissao,103) Emissao, isnull(PO.Numero_PO_him, PO_JOB.Numero_PO_him) PO,TT.Nome_tp_tx Taxa, CTC.DC_him DC, CTC.Vlr_Org_him*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_him Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_him,105))   from cta_cte_hou_imp_mar CTC
	left outer join caixa_hou_imp_mar CX on CTC.num_proc_him = CX.num_proc_him and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_him = CX.DC_him 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_him = CLI.cd_pes
	left outer join PO_him PO with(nolock) on CTC.Num_Proc_him = PO.Num_Proc_him and ID_DC = 1
	left outer join House_imp_mar HOU with(nolock) on CTC.Num_Proc_him = HOU.Num_Proc_him
	left outer join JOB_imp_mar JOB with(nolock) on HOU.JOB_him= JOB.Num_Proc_him
	left outer join PO_him PO_JOB with(nolock) on JOB.Num_Proc_him = PO_JOB.Num_Proc_him
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'IMM'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_HIM = BNF.Nota_Fiscal and ctc.ref_acesso_nf_him =  BNF.ref_acesso
	where CX.Num_proc_him is null and left(CTC.Num_Proc_him,5) <> 'IMJOB' and CTC.Desp_org_him = 'N' and Apelido like @Cliente and convert(datetime,Dt_Prev_Pgto_him,103)  between @DtInicial and @DtFinal

	union all

	select  distinct CLI.Apelido Cliente, CTC.Num_Proc_hia JOB,convert(varchar(10),CTC.Num_NF_Hia) + CTC.Ref_Acesso_NF_Hia Num_NF,convert(datetime,BNF.Emissao,103) Emissao, isnull(PO.Numero_PO_hia, PO_JOB.Numero_PO_hia) PO,TT.Nome_tp_tx Taxa, CTC.DC_hia DC, CTC.Vlr_Org_hia*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_hia Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_hia,105))   from cta_cte_hou_imp_aer CTC
	left outer join caixa_hou_imp_aer CX on CTC.num_proc_hia = CX.num_proc_hia and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_hia = CX.DC_hia 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_hia = CLI.cd_pes
	left outer join PO_hia PO with(nolock) on CTC.Num_Proc_hia = PO.Num_Proc_hia and ID_DC = 1
	left outer join House_imp_aer HOU with(nolock) on CTC.Num_Proc_hia = HOU.Num_Proc_hia
	left outer join JOB_imp_aer JOB with(nolock) on HOU.JOB_hia= JOB.Num_Proc_hia
	left outer join PO_hia PO_JOB with(nolock) on JOB.Num_Proc_hia = PO_JOB.Num_Proc_hia
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'IMM'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_HIA = BNF.Nota_Fiscal and ctc.ref_acesso_nf_hia =  BNF.ref_acesso
	where CX.Num_proc_hia is null and left(CTC.Num_Proc_hia,5) <> 'IAJOB' and CTC.Desp_org_hia = 'N' and Apelido like @Cliente and convert(datetime,Dt_Prev_Pgto_hia,103)  between @DtInicial and @DtFinal

	union all

	select  distinct CLI.Apelido Cliente, CTC.Num_Proc_hio JOB,convert(varchar(10),CTC.Num_NF_Hio) + CTC.Ref_Acesso_NF_Hio Num_NF,convert(datetime,BNF.Emissao,103) Emissao, PO.Numero_PO_hio PO,TT.Nome_tp_tx Taxa, CTC.DC_hio DC, CTC.Vlr_Org_hio*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_hio Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_hio,105))   from cta_cte_hou_imp_out CTC
	left outer join caixa_hou_imp_out CX on CTC.num_proc_hio = CX.num_proc_hio and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_hio = CX.DC_hio 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_hio = CLI.cd_pes
	left outer join PO_hio PO with(nolock) on CTC.Num_Proc_hio = PO.Num_Proc_hio and ID_DC = 1
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'OFC'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_HIO = BNF.Nota_Fiscal and ctc.ref_acesso_nf_hio =  BNF.ref_acesso
	where CX.Num_proc_hio is null and CTC.Desp_org_hio = 'N' and Apelido like @Cliente and convert(datetime,Dt_Prev_Pgto_hio,103)  between @DtInicial and @DtFinal

	union all

	select CLI.Apelido Cliente, CTC.Num_Proc_mem JOB,convert(varchar(10),CTC.Num_NF_mem) + CTC.Ref_Acesso_NF_mEM Num_NF,convert(datetime,BNF.Emissao,103) Emissao, PO.Numero_PO PO,TT.Nome_tp_tx Taxa, CTC.DC_mem DC, CTC.Vlr_Org_mem*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_mem Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_mem,105))   from cta_cte_mas_exp_mar CTC
	left outer join caixa_mas_exp_mar CX on CTC.num_proc_mem = CX.num_proc_mem and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_mem = CX.DC_mem 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_mem = CLI.cd_pes
	left outer join PO_Master PO with(nolock) on CTC.Num_Proc_MEM = PO.Num_Proc_master and ID_DC = 1
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'EXM'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_MEM = BNF.Nota_Fiscal and ctc.ref_acesso_nf_mem =  BNF.ref_acesso
	where CX.Num_proc_mem is null and CTC.Desp_dst_mem = 'N' and  Apelido like @Cliente and convert(datetime,Dt_Prev_Pgto_mem,103)  between @DtInicial and @DtFinal

	union all

	select  distinct CLI.Apelido Cliente, CTC.Num_Proc_mea JOB,convert(varchar(10),CTC.Num_NF_mea) + CTC.Ref_Acesso_NF_mea Num_NF,convert(datetime,BNF.Emissao,103) Emissao, PO.Numero_PO PO,TT.Nome_tp_tx Taxa, CTC.DC_mea DC, CTC.Vlr_Org_mea*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_mea Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_mea,105))   from cta_cte_mas_exp_aer CTC
	left outer join caixa_mas_exp_aer CX on CTC.num_proc_mea = CX.num_proc_mea and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_mea = CX.DC_mea 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_mea = CLI.cd_pes
	left outer join PO_Master PO with(nolock) on CTC.Num_Proc_mea = PO.Num_Proc_master and ID_DC = 1
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'EXA'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_MEA = BNF.Nota_Fiscal and ctc.ref_acesso_nf_mea =  BNF.ref_acesso
	where CX.Num_proc_mea is null and CTC.Desp_dst_mea = 'N' and  Apelido like @Cliente and convert(datetime,Dt_Prev_Pgto_mea,103)  between @DtInicial and @DtFinal

	union all

	select  distinct CLI.Apelido Cliente, CTC.Num_Proc_mim JOB,convert(varchar(10),CtC.Num_NF_mim) + CtC.Ref_Acesso_NF_mim Num_NF,convert(datetime,BNF.Emissao,103) Emissao, PO.Numero_PO PO,TT.Nome_tp_tx Taxa, CTC.DC_mim DC, CTC.Vlr_Org_mim*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_mim Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_mim,105))   from cta_cte_mas_imp_mar CTC
	left outer join caixa_mas_imp_mar CX on CTC.num_proc_mim = CX.num_proc_mim and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_mim = CX.DC_mim 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_mim = CLI.cd_pes
	left outer join PO_Master PO with(nolock) on CTC.Num_Proc_mim = PO.Num_Proc_master and ID_DC = 1
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'IMM'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_MIM = BNF.Nota_Fiscal and ctc.ref_acesso_nf_mim =  BNF.ref_acesso
	where CX.Num_proc_mim is null and CTC.Desp_org_mim = 'N' and  Apelido like @Cliente and convert(datetime,Dt_Prev_Pgto_mim,103)  between @DtInicial and @DtFinal

	union all

	select  distinct CLI.Apelido Cliente, CTC.Num_Proc_mia JOB,convert(varchar(10),CTC.Num_NF_mia) + CTC.Ref_Acesso_NF_mia Num_NF,convert(datetime,BNF.Emissao,103) Emissao, PO.Numero_PO PO,TT.Nome_tp_tx Taxa, CTC.DC_mia DC, CTC.Vlr_Org_mia*isnull(PAR.Par_Moeda,1) Valor, Dt_Prev_Pgto_mia Vencimento, convert(int,getdate() -convert(datetime,CTC.Dt_Prev_Pgto_mia,105))   from cta_cte_mas_imp_aer CTC
	left outer join caixa_mas_imp_aer CX on CTC.num_proc_mia = CX.num_proc_mia and CTC.cd_tp_tx = CX.cd_tp_tx and CTC.DC_mia = CX.DC_mia 
	join pessoa CLI with(nolock) on CTC.cd_cred_dev_mia = CLI.cd_pes
	left outer join PO_Master PO with(nolock) on CTC.Num_Proc_mia = PO.Num_Proc_master and ID_DC = 1
	left outer join Paridade AS PAR with(nolock) ON PAR.Cd_Tp_Moeda = CTC.Cd_Tp_Moeda AND convert(datetime,PAR.Dt_Par,103) = getdate() AND PAR.Cd_Tp_Par = 'EXM'
	left outer join Tipo_Taxa TT with(nolock) on CTC.Cd_tp_tx = TT.cd_tp_tx
	left outer join Base_Nota_Fiscal BNF with(nolock) on CTC.Num_NF_MIA = BNF.Nota_Fiscal and ctc.ref_acesso_nf_mia =  BNF.ref_acesso
	where CX.Num_proc_mia is null and CTC.Desp_org_mia = 'N' and  Apelido like @Cliente and convert(datetime,Dt_Prev_Pgto_mia,103)  between @DtInicial and @DtFinal
end



GO
