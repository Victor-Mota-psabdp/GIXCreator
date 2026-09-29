SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE              Procedure [dbo].[spFechDetalhe] -- '%','08-01-2009','08-31-2009'
		@Vendedor varchar(20),
		@DataInicial varchar(10),
		@Datafinal varchar(10)

as

select 
	'H' Tipo,nome_usuario,dt_fech,apelido,hou.num_proc_hea,org.nome_local Origem,dst.nome_local Destino,cta.cd_tp_moeda, CTA.DC_HEA DC, vlr_org_hea, IsNull(isnull(Par.Par_moeda, OFC.par_moeda),1) Paridade,isnull(cxa.num_lcto,'NAO') Caixa_Sit, isnull(vlr_pgto_rcto_hea, 0) PG
from 
	vendas_fechamento VF
	Left Join relacao RL on vf.cd_pes=cd_pes_a and Cd_Tp_Rel='GPO'
	Join house_exp_aer hou on hou.cd_org_hea=cd_org and hou.cd_dst_hea=cd_dst and cd_export_hea=isnull(cd_pes_b,vf.cd_pes)
	Join pessoa pp on pp.cd_pes=vf.cd_pes
	Join Localidade org on org.cd_local=cd_org
	Join Localidade dst on dst.cd_local=cd_dst
	Join usuario US on US.cd_usuario=cd_vendedor
	Left Join CtA_ctE_hou_exp_aer Cta on CTA.num_proc_hea=HOU.num_proC_hea 
	Left Join Paridade PAR on PAR.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='EXA' and convert(datetime,par.dt_par,105)=convert(datetime,dt_ins_hea,105)
	Left Join Paridade OFC on OFC.cd_tp_moeda=cta.cd_tp_moeda and OFC.cd_tp_par='OFC' and convert(datetime,OFC.dt_par,105)=convert(datetime,dt_ins_hea,105)
	Left Join Caixa_hou_exp_Aer CXA on CTa.num_proc_hea=CXA.num_proc_hea and cta.cd_tp_Tx=cxa.cd_Tp_Tx and cta.dc_hea=cxa.dc_hea and num_lcto <> 'PROVISÓRIO' and convert(Datetime,dt_pgto_Rcto_hea,105)<=@DataFinal
Where
	--convert(datetime,dt_saida_mea,105) between @DataInicial and @DataFinal 
	nome_usuario like @Vendedor and cd_vendedor <> 'COM' and 
	convert(datetime,dt_fech,105)<=@DataFinal and (dt_perd is null or dt_perd between @dataInicial and @dataFinal)
	and convert(Datetime,dt_ins_hea,105) between @DataInicial and @DataFinal
	and desp_dst_hea='N'
	and cta.cd_tp_Tx not in (select * from param_aekcontabil_taxas_exc)
	and left(cta.num_proc_hea,5) <> 'EAJOB'
	and left(cta.cd_tP_Tx,1) <> 'X'

UNION ALL


select 
	'M' Tipo,nome_usuario,dt_fech,apelido,hou.num_proc_hea,org.nome_local Origem,dst.nome_local Destino,'REL', 'M' ,0 Valor, 0 Paridade,'NAO' Caixa_Sit, dbo.SPresultado_masdt(hou.num_proc_hea,@dataInicial) PG
from 
	vendas_fechamento VF
	Left Join relacao RL on vf.cd_pes=cd_pes_a and Cd_Tp_Rel='GPO'
	Join house_exp_aer hou on hou.cd_org_hea=cd_org and hou.cd_dst_hea=cd_dst and cd_export_hea=isnull(cd_pes_b,vf.cd_pes)
	Join pessoa pp on pp.cd_pes=vf.cd_pes
	Join Localidade org on org.cd_local=cd_org
	Join Localidade dst on dst.cd_local=cd_dst
	Join usuario US on US.cd_usuario=cd_vendedor
	Left Join CtA_ctE_MAS_exp_aer Cta on CTA.num_proc_Mea=HOU.num_proC_Mea 
Where
	--convert(datetime,dt_saida_mea,105) between @DataInicial and @DataFinal 
	nome_usuario like @Vendedor and cd_vendedor <> 'COM' and 
	convert(datetime,dt_fech,105)<=@DataFinal and (dt_perd is null or dt_perd between @dataInicial and @dataFinal)
	and convert(Datetime,dt_ins_Mea,105) between @DataInicial and @DataFinal
	and desp_dst_Mea='N'
	and cta.cd_tp_Tx not in (select * from param_aekcontabil_taxas_exc)
and left(cta.cd_tP_Tx,1) <> 'X'
GROUP BY
	nome_usuario,dt_fech,apelido,hou.num_proc_hea,org.nome_local,dst.nome_local, dbo.SPresultado_masdt(hou.num_proc_hea,@dataInicial) 


UNION all


select 
	'H' Tipo,nome_usuario,dt_fech,apelido,hou.num_proc_hia,org.nome_local Origem,dst.nome_local Destino,cta.cd_tp_moeda, CTA.DC_hia DC, vlr_org_hia, IsNull(isnull(Par.Par_moeda, OFC.par_moeda),1) Paridade,isnull(cxa.num_lcto,'NAO') Caixa_Sit, isnull(vlr_pgto_rcto_hia, 0) PG
from 
	vendas_fechamento VF
	Left Join relacao RL on vf.cd_pes=cd_pes_a and Cd_Tp_Rel='GPO'
	Join house_imp_aer hou on hou.cd_org_hia=cd_org and hou.cd_dst_hia=cd_dst and cd_import_hia=isnull(cd_pes_b,vf.cd_pes)
	Join pessoa pp on pp.cd_pes=vf.cd_pes
	Join Localidade org on org.cd_local=cd_org
	Join Localidade dst on dst.cd_local=cd_dst
	Join usuario US on US.cd_usuario=cd_vendedor
	Left Join CtA_ctE_hou_imp_aer Cta on CTA.num_proc_hia=HOU.num_proC_hia 
	Left Join Paridade PAR on PAR.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='EXA' and convert(datetime,par.dt_par,105)=convert(datetime,dt_ins_hia,105)
	Left Join Paridade OFC on OFC.cd_tp_moeda=cta.cd_tp_moeda and OFC.cd_tp_par='OFC' and convert(datetime,OFC.dt_par,105)=convert(datetime,dt_ins_hia,105)
	Left Join Caixa_hou_imp_Aer CXA on CTa.num_proc_hia=CXA.num_proc_hia and cta.cd_tp_Tx=cxa.cd_Tp_Tx and cta.dc_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO' and convert(Datetime,dt_pgto_Rcto_hia,105)<=@DataFinal
Where
	--convert(datetime,dt_saida_mea,105) between @DataInicial and @DataFinal 
	nome_usuario like @Vendedor and cd_vendedor <> 'COM' and 
	convert(datetime,dt_fech,105)<=@DataFinal and (dt_perd is null or dt_perd between @dataInicial and @dataFinal)
	and convert(Datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
	and desp_org_hia='N'
	and cta.cd_tp_Tx not in (select * from param_aekcontabil_taxas_exc)
	and left(hou.num_proc_hia,5) <> 'IAJOB'
and left(cta.cd_tP_Tx,1) <> 'X'
UNION all

select 
	'M' Tipo,nome_usuario,dt_fech,apelido,hou.num_proc_HIA,org.nome_local Origem,dst.nome_local Destino,'REL', 'M' ,0 Valor, 0 Paridade,'NAO' Caixa_Sit, dbo.SPresultado_masdt(hou.num_proc_HIA,@dataInicial) PG
from 
	vendas_fechamento VF
	Left Join relacao RL on vf.cd_pes=cd_pes_a and Cd_Tp_Rel='GPO'
	Join house_IMP_aer hou on hou.cd_org_HIA=cd_org and hou.cd_dst_HIA=cd_dst and cd_IMPort_HIA=isnull(cd_pes_b,vf.cd_pes)
	Join pessoa pp on pp.cd_pes=vf.cd_pes
	Join Localidade org on org.cd_local=cd_org
	Join Localidade dst on dst.cd_local=cd_dst
	Join usuario US on US.cd_usuario=cd_vendedor
	Left Join CtA_ctE_MAS_IMP_aer Cta on CTA.num_proc_MIA=HOU.num_proC_MIA 
Where
	--convert(datetime,dt_saida_MIA,105) between @DataInicial and @DataFinal 
	nome_usuario like @Vendedor and cd_vendedor <> 'COM' and 
	convert(datetime,dt_fech,105)<=@DataFinal and (dt_perd is null or dt_perd between @dataInicial and @dataFinal)
	and convert(Datetime,dt_ins_MIA,105) between @DataInicial and @DataFinal
	and desp_ORG_MIA='N'
	and cta.cd_tp_Tx not in (select * from param_aekcontabil_taxas_exc)
and left(cta.cd_tP_Tx,1) <> 'X'
GROUP BY
	nome_usuario,dt_fech,apelido,hou.num_proc_HIA,org.nome_local,dst.nome_local, dbo.SPresultado_masdt(hou.num_proc_HIA,@dataInicial) 


UNION all


select 
	'H' Tipo,nome_usuario,dt_fech,apelido,hou.num_proc_HEM,org.nome_local Origem,dst.nome_local Destino,cta.cd_tp_moeda, CTA.DC_HEM DC, vlr_org_HEM, IsNull(isnull(Par.Par_moeda, OFC.par_moeda),1) Paridade,isnull(cxa.num_lcto,'NAO') Caixa_Sit, isnull(vlr_pgto_rcto_HEM, 0) PG
from 
	vendas_fechamento VF
	Left Join relacao RL on vf.cd_pes=cd_pes_a and Cd_Tp_Rel='GPO'
	Join house_exp_MAR hou on hou.cd_org_HEM=cd_org and hou.cd_dst_HEM=cd_dst and cd_export_HEM=isnull(cd_pes_b,vf.cd_pes)
	Join pessoa pp on pp.cd_pes=vf.cd_pes
	Join Localidade org on org.cd_local=cd_org
	Join Localidade dst on dst.cd_local=cd_dst
	Join usuario US on US.cd_usuario=cd_vendedor
	Left Join CtA_ctE_hou_exp_MAR Cta on CTA.num_proc_HEM=HOU.num_proC_HEM 
	Left Join Paridade PAR on PAR.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='EXA' and convert(datetime,par.dt_par,105)=convert(datetime,dt_ins_HEM,105)
	Left Join Paridade OFC on OFC.cd_tp_moeda=cta.cd_tp_moeda and OFC.cd_tp_par='OFC' and convert(datetime,OFC.dt_par,105)=convert(datetime,dt_ins_HEM,105)
	Left Join Caixa_hou_exp_MAR CXA on CTa.num_proc_HEM=CXA.num_proc_HEM and cta.cd_tp_Tx=cxa.cd_Tp_Tx and cta.dc_HEM=cxa.dc_HEM and num_lcto <> 'PROVISÓRIO' and convert(Datetime,dt_pgto_Rcto_HEM,105)<=@DataFinal
Where
	--convert(datetime,dt_saida_MEM,105) between @DataInicial and @DataFinal 
	nome_usuario like @Vendedor and cd_vendedor <> 'COM' and 
	convert(datetime,dt_fech,105)<=@DataFinal and (dt_perd is null or dt_perd between @dataInicial and @dataFinal)
	and convert(Datetime,dt_ins_HEM,105) between @DataInicial and @DataFinal
	and desp_dst_HEM='N'
	and cta.cd_tp_Tx not in (select * from param_aekcontabil_taxas_exc)
	and left(hou.num_proc_hem,5) <> 'EMJOB'
and left(cta.cd_tP_Tx,1) <> 'X'


UNION ALL


select 
	'M' Tipo,nome_usuario,dt_fech,apelido,hou.num_proc_HEM,org.nome_local Origem,dst.nome_local Destino,'REL', 'M' ,0 Valor, 0 Paridade,'NAO' Caixa_Sit, dbo.SPresultado_masdt(hou.num_proc_HEM,@dataInicial) PG
from 
	vendas_fechamento VF
	Left Join relacao RL on vf.cd_pes=cd_pes_a and Cd_Tp_Rel='GPO'
	Join house_exp_MAR hou on hou.cd_org_HEM=cd_org and hou.cd_dst_HEM=cd_dst and cd_export_HEM=isnull(cd_pes_b,vf.cd_pes)
	Join pessoa pp on pp.cd_pes=vf.cd_pes
	Join Localidade org on org.cd_local=cd_org
	Join Localidade dst on dst.cd_local=cd_dst
	Join usuario US on US.cd_usuario=cd_vendedor
	Left Join CtA_ctE_MAS_exp_MAR Cta on CTA.num_proc_MEM=HOU.num_proC_MEM 
Where
	--convert(datetime,dt_saida_MEM,105) between @DataInicial and @DataFinal 
	nome_usuario like @Vendedor and cd_vendedor <> 'COM' and 
	convert(datetime,dt_fech,105)<=@DataFinal and (dt_perd is null or dt_perd between @dataInicial and @dataFinal)
	and convert(Datetime,dt_ins_MEM,105) between @DataInicial and @DataFinal
	and desp_dst_MEM='N'
	and cta.cd_tp_Tx not in (select * from param_aekcontabil_taxas_exc)
	and left(cta.cd_tP_Tx,1) <> 'X'
	
GROUP BY
	nome_usuario,dt_fech,apelido,hou.num_proc_HEM,org.nome_local,dst.nome_local, dbo.SPresultado_masdt(hou.num_proc_HEM,@dataInicial) 


UNION all

select 
	'H' Tipo,nome_usuario,dt_fech,apelido,hou.num_proc_HIM,org.nome_local Origem,dst.nome_local Destino,cta.cd_tp_moeda, CTA.DC_HIM DC, vlr_org_HIM, IsNull(isnull(Par.Par_moeda, OFC.par_moeda),1) Paridade,isnull(cxa.num_lcto,'NAO') Caixa_Sit, isnull(vlr_pgto_rcto_HIM, 0) PG
from 
	vendas_fechamento VF
	Left Join relacao RL on vf.cd_pes=cd_pes_a and Cd_Tp_Rel='GPO'
	Join house_imp_MAR hou on hou.cd_org_HIM=cd_org and hou.cd_dst_HIM=cd_dst and cd_import_HIM=isnull(cd_pes_b,vf.cd_pes)
	Join pessoa pp on pp.cd_pes=vf.cd_pes
	Join Localidade org on org.cd_local=cd_org
	Join Localidade dst on dst.cd_local=cd_dst
	Join usuario US on US.cd_usuario=cd_vendedor
	Left Join CtA_ctE_hou_imp_MAR Cta on CTA.num_proc_HIM=HOU.num_proC_HIM 
	Left Join Paridade PAR on PAR.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='IMM' and convert(datetime,par.dt_par,105)=convert(datetime,dt_ins_HIM,105)
	Left Join Paridade OFC on OFC.cd_tp_moeda=cta.cd_tp_moeda and OFC.cd_tp_par='OFC' and convert(datetime,OFC.dt_par,105)=convert(datetime,dt_ins_HIM,105)
	Left Join Caixa_hou_imp_MAR CXA on CTa.num_proc_HIM=CXA.num_proc_HIM and cta.cd_tp_Tx=cxa.cd_Tp_Tx and cta.dc_HIM=cxa.dc_HIM and num_lcto <> 'PROVISÓRIO' and convert(Datetime,dt_pgto_Rcto_HIM,105)<=@DataFinal
Where
	--convert(datetime,dt_saida_mea,105) between @DataInicial and @DataFinal 
	nome_usuario like @Vendedor and cd_vendedor <> 'COM' and 
	convert(datetime,dt_fech,105)<=@DataFinal and (dt_perd is null or dt_perd between @dataInicial and @dataFinal)	and convert(Datetime,dt_ins_HIM,105) between @DataInicial and @DataFinal
	and desp_org_HIM='N'
	and cta.cd_tp_Tx not in (select * from param_aekcontabil_taxas_exc)
	and left(hou.num_proc_him,5) <> 'IMJOB'
	and left(cta.cd_tP_Tx,1) <> 'X'
GROUP BY
	nome_usuario,dt_fech,apelido,hou.num_proc_HIM,org.nome_local ,dst.nome_local ,cta.cd_tp_moeda, CTA.DC_HIM , vlr_org_HIM, IsNull(isnull(Par.Par_moeda, OFC.par_moeda),1) ,isnull(cxa.num_lcto,'NAO') , isnull(vlr_pgto_rcto_HIM, 0) 

UNION all

select 
	'M' Tipo,nome_usuario,dt_fech,apelido,hou.num_proc_HIM,org.nome_local Origem,dst.nome_local Destino,'REL', 'M' ,0 Valor, 0 Paridade,'NAO' Caixa_Sit, dbo.SPresultado_masdt(hou.num_proc_HIM,@dataInicial) PG
from 
	vendas_fechamento VF
	Left Join relacao RL on vf.cd_pes=cd_pes_a and Cd_Tp_Rel='GPO'
	Join house_IMP_MAR hou on hou.cd_org_HIM=cd_org and hou.cd_dst_HIM=cd_dst and cd_IMPort_HIM=isnull(cd_pes_b,vf.cd_pes)
	Join pessoa pp on pp.cd_pes=vf.cd_pes
	Join Localidade org on org.cd_local=cd_org
	Join Localidade dst on dst.cd_local=cd_dst
	Join usuario US on US.cd_usuario=cd_vendedor
	Left Join CtA_ctE_MAS_IMP_MAR Cta on CTA.num_proc_MIM=HOU.num_proC_MIM 
Where
	--convert(datetime,dt_saida_MIM,105) between @DataInicial and @DataFinal 
	nome_usuario like @Vendedor and cd_vendedor <> 'COM' and 
	convert(datetime,dt_fech,105)<=@DataFinal and (dt_perd is null or dt_perd between @dataInicial and @dataFinal)
	and convert(Datetime,dt_ins_MIM,105) between @DataInicial and @DataFinal
	and desp_ORG_MIM='N'
	and cta.cd_tp_Tx not in (select * from param_aekcontabil_taxas_exc)
	and left(cta.cd_tP_Tx,1) <> 'X'
	and left(hou.num_proc_mim,5) <>'IMCLI'
GROUP BY
	nome_usuario,dt_fech,apelido,hou.num_proc_HIM,org.nome_local,dst.nome_local, dbo.SPresultado_masdt(hou.num_proc_HIM,@dataInicial)


union all


select 
	'H' Tipo,nome_usuario,dt_fech,apelido,hou.num_proc_Mea,org.nome_local Origem,dst.nome_local Destino,cta.cd_tp_moeda, CTA.DC_MEA DC, cta.vlr_org_Mea, 1 Paridade,isnull(cxa.num_lcto,'NAO') Caixa_Sit, isnull(vlr_pgto_rcto_Mea, 0) PG
from 
	vendas_fechamento VF
	Join Cta_cte_MAs_exp_Aer HOU on HOU.cd_cred_dev_mea=VF.cd_pes and hou.cd_tp_tx='BRO' and hou.dc_mea='C'
	join pessoa pp on pp.cd_pes=vf.cd_pes
	Join Localidade org on org.cd_local=cd_org
	Join Localidade dst on dst.cd_local=cd_dst
	Join usuario US on US.cd_usuario=cd_vendedor
	Left Join CtA_ctE_MAS_exp_aer Cta on CTA.num_proc_Mea=HOU.num_proC_Mea 
	Left Join Caixa_MAS_exp_Aer CXA on CTa.num_proc_Mea=CXA.num_proc_Mea and cta.cd_tp_Tx=cxa.cd_Tp_Tx and cta.dc_Mea=cxa.dc_Mea and num_lcto <> 'PROVISÓRIO' and convert(Datetime,dt_pgto_Rcto_Mea,105)<=@DataFinal
Where
	--convert(datetime,dt_saida_mea,105) between @DataInicial and @DataFinal 
	nome_usuario like @Vendedor and cd_vendedor <> 'COM' and 
	convert(datetime,dt_fech,105)<=@DataFinal and (dt_perd is null or dt_perd between @dataInicial and @dataFinal)
	and convert(Datetime,cta.dt_ins_Mea,105) between @DataInicial and @DataFinal
	and cta.desp_dst_Mea='N'
	and cta.cd_tp_Tx not in (select * from param_aekcontabil_taxas_exc)
	and left(cta.num_proc_mea,5) <> 'EAJOB' AND LEFT(HOU.NUM_PROC_MEA,5) = 'EASSZ' AND CTA.CD_TP_TX NOT IN ('DS1','DS2','DS3','DS4') AND LEFT(CTA.CD_TP_TX,1)<>'£'
	AND VF.CD_ORG='DES' AND VF.CD_DST='DES'
and left(cta.cd_tP_Tx,1) <> 'X'

UNION ALL

select 
	'H' Tipo,nome_usuario,dt_fech,apelido,hou.num_proc_HIA,org.nome_local Origem,dst.nome_local Destino,cta.cd_tp_moeda, CTA.DC_HIA DC, cta.vlr_pgto_nf_hia, 1 Paridade,isnull(cxa.num_lcto,'NAO') Caixa_Sit, isnull(vlr_pgto_rcto_HIA, 0) PG
from 
	vendas_fechamento VF
	Join Cta_cte_HOU_IMP_Aer HOU on HOU.cd_cred_dev_HIA=VF.cd_pes AND LEFT(HOU.NUM_PROC_HIA,5)='IAREM'
	join pessoa pp on pp.cd_pes=vf.cd_pes
	Join Localidade org on org.cd_local=cd_org
	Join Localidade dst on dst.cd_local=cd_dst
	Join usuario US on US.cd_usuario=cd_vendedor
	Left Join CtA_ctE_HOU_IMP_aer Cta on CTA.num_proc_HIA=HOU.num_proC_HIA 
	Left Join Caixa_HOU_IMP_Aer CXA on CTa.num_proc_HIA=CXA.num_proc_HIA and cta.cd_tp_Tx=cxa.cd_Tp_Tx and cta.dc_HIA=cxa.dc_HIA and num_lcto <> 'PROVISÓRIO' and convert(Datetime,dt_pgto_Rcto_HIA,105)<=@DataFinal
Where
	--convert(datetime,dt_saida_mea,105) between @DataInicial and @DataFinal 
	nome_usuario like @Vendedor and cd_vendedor <> 'COM' and 
	convert(datetime,dt_fech,105)<=@DataFinal and (dt_perd is null or dt_perd between @dataInicial and @dataFinal)
	and convert(Datetime,cta.dt_ins_HIA,105) between @DataInicial and @DataFinal
	and cta.desp_ORG_HIA='N'
	and cta.cd_tp_Tx not in (select * from param_aekcontabil_taxas_exc)
	and left(cta.num_proc_HIA,5) <> 'IAJOB' AND LEFT(HOU.NUM_PROC_HIA,5) = 'IAREM' AND CTA.CD_TP_TX NOT IN ('DS1','DS2','DS3','DS4') AND LEFT(CTA.CD_TP_TX,1)<>'£'
	AND VF.CD_ORG='DES' AND VF.CD_DST='DES'
	and left(cta.cd_tP_Tx,1) <> 'X'
UNION ALL

select 
	'H' Tipo,nome_usuario,dt_fech,apelido,hou.num_proc_HIM,org.nome_local Origem,dst.nome_local Destino,cta.cd_tp_moeda, CTA.DC_HIM DC, cta.vlr_pgto_nf_hiM, 1 Paridade,isnull(cxa.num_lcto,'NAO') Caixa_Sit, isnull(vlr_pgto_rcto_HIM, 0) PG
from 
	vendas_fechamento VF
	Join Cta_cte_HOU_IMP_MAR HOU on HOU.cd_cred_dev_HIM=VF.cd_pes AND LEFT(HOU.NUM_PROC_HIM,5)='IMREM'
	join pessoa pp on pp.cd_pes=vf.cd_pes
	Join Localidade org on org.cd_local=cd_org
	Join Localidade dst on dst.cd_local=cd_dst
	Join usuario US on US.cd_usuario=cd_vendedor
	Left Join CtA_ctE_HOU_IMP_MAR Cta on CTA.num_proc_HIM=HOU.num_proC_HIM 
	Left Join Caixa_HOU_IMP_MAR CXA on CTa.num_proc_HIM=CXA.num_proc_HIM and cta.cd_tp_Tx=cxa.cd_Tp_Tx and cta.dc_HIM=cxa.dc_HIM and num_lcto <> 'PROVISÓRIO' and convert(Datetime,dt_pgto_Rcto_HIM,105)<=@DataFinal
Where
	--convert(datetime,dt_saida_mea,105) between @DataInicial and @DataFinal 
	nome_usuario like @Vendedor and cd_vendedor <> 'COM' and 
	convert(datetime,dt_fech,105)<=@DataFinal and (dt_perd is null or dt_perd between @dataInicial and @dataFinal)
	and convert(Datetime,cta.dt_ins_HIM,105) between @DataInicial and @DataFinal
	and cta.desp_ORG_HIM='N'
	and cta.cd_tp_Tx not in (select * from param_aekcontabil_taxas_exc)
	and left(cta.num_proc_HIM,5) <> 'IMJOB' AND LEFT(HOU.NUM_PROC_HIM,5) = 'IMREM' AND CTA.CD_TP_TX NOT IN ('DS1','DS2','DS3','DS4') AND LEFT(CTA.CD_TP_TX,1)<>'£'
	AND VF.CD_ORG='DES' AND VF.CD_DST='DES'

	and left(cta.cd_tP_Tx,1) <> 'X'




















GO
