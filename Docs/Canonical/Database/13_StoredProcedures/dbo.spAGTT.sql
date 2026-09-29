SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


















CREATE      Procedure spAGTT  --'01-01-2007','01-31-2007','%'
		(
		 @DataInicial char(10),
		 @DataFinal char(10),
		 @Agente   Varchar(50)
		)

--spRentTT '12-01-2006','12-31-2006'
as

Select 
	CTA.Num_Proc_HIA,AGT.APelido Agent, SHP.Apelido Shipper, PP.Apelido Consignee, cta.cd_tp_moeda, cta.dc_hia,sum(vlr_org_hia) Valor,cast(usd.Par_moeda as float) Paridade_USD, cast(par.Par_Moeda as float)Paridade,Nome_usuario, month(convert(datetime,dt_ins_hia,105)) Mes
From
	House_Imp_Aer HOU 
	Join Master_Imp_Aer MAS on MAS.num_proc_mia=hou.num_proc_mia
	Join Cta_cte_hou_imp_Aer CTA on CTA.num_proc_hia=hou.num_proc_hia
	LEft Join Paridade PAR on PAR.cd_tp_moeda=cta.cd_tp_moeda and converT(datetime,par.dt_par,105)=converT(datetime,dt_ins_hia,105) and par.cd_tp_par='OFC'
	Left Join Paridade USD on USD.cd_tp_moeda='USD' and converT(datetime,usd.dt_par,105)=converT(datetime,dt_ins_hia,105) and usd.cd_tp_par='OFC'
	Join Localidade Org on Org.cd_local=cd_org_mia
	Join Localidade Dst on Dst.cd_local=cd_dst_mia
	Join Pessoa AGT on AGT.cd_pes=cd_export_mia
	Join Pessoa PP on PP.cd_pes=cd_consig_hia
	Join Pessoa SHP on SHP.cd_pes=cd_export_hia
	Left Join Vendas_Fechamento VF on Cd_Import_hia=VF.cd_pes and cd_org_mia=cd_org and cd_dst_mia=cd_dst and dt_perd is null
	Left Join Usuario US on VF.cd_vendedor=US.cd_usuario
Where
	convert(datetime,dt_ins_hia,105) between @datainicial and @datafinal and desp_org_hia='N' and 
	 cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc) and
	left(hou.num_proc_hia,5) <> 'IAJOB' and agt.apelido like @Agente AND CTA.CD_tP_TX NOT IN (SELECT CD_TP_tX FROM TIPO_TAXA WHERE NOME_TP_TX LIKE '%dEMURRAGE%')
Group by
	cta.num_proc_hia,cta.dc_hia,AGT.APelido, SHP.Apelido, PP.Apelido, cta.cd_tp_moeda, usd.Par_moeda,par.Par_Moeda ,Nome_usuario, month(convert(datetime,dt_ins_hia,105))


UNION ALL

Select 
	hou.num_proc_hia,AGT.APelido Agent, SHP.Apelido Shipper, PP.Apelido Consignee, cta.cd_tp_moeda, cta.dc_mia, sum(vlr_org_Mia*Isnull(dbo.spPar_MASC(num_proc_hia, rateio_Tx),1)),cast(usd.Par_moeda as float)Paridade_USD, cast(par.Par_Moeda as float)Paridade,Nome_usuario, month(convert(datetime,dt_ins_mia,105)) Mes
From
	House_Imp_Aer HOU 
	Join Master_Imp_Aer MAS on MAS.num_proc_mia=hou.num_proc_mia
	Join Cta_cte_mas_imp_Aer CTA on CTA.num_proc_Mia=hou.num_proc_Mia
	LEft Join Paridade PAR on PAR.cd_tp_moeda=cta.cd_tp_moeda and converT(datetime,par.dt_par,105)=converT(datetime,dt_ins_mia,105) and par.cd_tp_par='OFC'
	Left Join Paridade USD on USD.cd_tp_moeda='USD' and converT(datetime,usd.dt_par,105)=converT(datetime,dt_ins_mia,105) and usd.cd_tp_par='OFC'
	Join Localidade Org on Org.cd_local=cd_org_mia
	Join Localidade Dst on Dst.cd_local=cd_dst_mia
	Join Pessoa AGT on AGT.cd_pes=cd_export_mia
	Join Pessoa PP on PP.cd_pes=cd_consig_hia
	Join Pessoa SHP on SHP.cd_pes=cd_export_hia
	Left Join Vendas_Fechamento VF on Cd_Import_hia=VF.cd_pes and cd_org_mia=cd_org and cd_dst_mia=cd_dst and dt_perd is null
	Left Join Usuario US on VF.cd_vendedor=US.cd_usuario
	jOIN Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_Tx
Where
	convert(datetime,dt_ins_Mia,105) between @datainicial and @datafinal and desp_org_mia='N' and 
	 cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc) and
	left(hou.num_proc_hia,5) <> 'IAJOB' and agt.apelido like @Agente AND CTA.CD_tP_TX NOT IN (SELECT CD_TP_tX FROM TIPO_TAXA WHERE NOME_TP_TX LIKE '%dEMURRAGE%')
Group by
	hou.num_proc_hia,AGT.APelido, SHP.Apelido, PP.Apelido, cta.cd_tp_moeda, usd.Par_moeda,par.Par_Moeda ,Nome_usuario,cta.dc_mia, month(convert(datetime,dt_ins_mia,105)) 


UNION


Select 
	hou.num_proc_hea,AGT.APelido Agent, SHP.Apelido Shipper, PP.Apelido Consignee, cta.cd_tp_moeda, cta.dc_hea,sum(vlr_org_hea),cast(usd.Par_moeda as float) Paridade_USD, cast(par.Par_Moeda as float) Paridade,Nome_usuario, month(convert(datetime,dt_ins_hea,105)) 
From
	House_exp_Aer HOU 
	Join Master_exp_Aer MAS on MAS.num_proc_mea=hou.num_proc_mea
	Join Cta_cte_hou_exp_Aer CTA on CTA.num_proc_hea=hou.num_proc_hea
	LEft Join Paridade PAR on PAR.cd_tp_moeda=cta.cd_tp_moeda and converT(datetime,par.dt_par,105)=converT(datetime,dt_ins_hea,105) and par.cd_tp_par='OFC'
	Left Join Paridade USD on USD.cd_tp_moeda='USD' and converT(datetime,usd.dt_par,105)=converT(datetime,dt_ins_hea,105) and usd.cd_tp_par='OFC'
	Join Localidade Org on Org.cd_local=cd_org_mea
	Join Localidade Dst on Dst.cd_local=cd_dst_mea
	Join Pessoa AGT on AGT.cd_pes=cd_Consig_mea
	Join Pessoa PP on PP.cd_pes=cd_consig_hea
	Join Pessoa SHP on SHP.cd_pes=cd_export_hea
	Left Join Vendas_Fechamento VF on Cd_export_hea=VF.cd_pes and cd_org_mea=cd_org and cd_dst_mea=cd_dst and dt_perd is null
	Left Join Usuario US on VF.cd_vendedor=US.cd_usuario
Where
	convert(datetime,dt_ins_hea,105) between @datainicial and @datafinal and desp_DST_hea='N' and 
	 cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc) and
	left(hou.num_proc_hea,5) <> 'EAJOB' and agt.apelido like @Agente AND CTA.CD_tP_TX NOT IN (SELECT CD_TP_tX FROM TIPO_TAXA WHERE NOME_TP_TX LIKE '%dEMURRAGE%')
Group by
	hou.num_proc_hea,cta.dc_hea,AGT.APelido, SHP.Apelido, PP.Apelido, cta.cd_tp_moeda, usd.Par_moeda,par.Par_Moeda ,Nome_usuario, month(convert(datetime,dt_ins_hea,105)) 


UNION ALL

Select 
	hou.num_proc_hea,AGT.APelido Agent, SHP.Apelido Shipper, PP.Apelido Consignee, cta.cd_tp_moeda, cta.dc_mea, sum(vlr_org_mea*Isnull(dbo.spPar_MASC(num_proc_hea, rateio_Tx),1)),cast(usd.Par_moeda as float) Paridade_USD, Cast(par.Par_Moeda as float)Paridade,Nome_usuario, month(convert(datetime,dt_ins_mea,105)) 
From
	House_exp_Aer HOU 
	Join Master_exp_Aer MAS on MAS.num_proc_mea=hou.num_proc_mea
	Join Cta_cte_mas_exp_Aer CTA on CTA.num_proc_mea=hou.num_proc_mea
	LEft Join Paridade PAR on PAR.cd_tp_moeda=cta.cd_tp_moeda and converT(datetime,par.dt_par,105)=converT(datetime,dt_ins_mea,105) and par.cd_tp_par='OFC'
	Left Join Paridade USD on USD.cd_tp_moeda='USD' and converT(datetime,usd.dt_par,105)=converT(datetime,dt_ins_mea,105) and usd.cd_tp_par='OFC'
	Join Localidade Org on Org.cd_local=cd_org_mea
	Join Localidade Dst on Dst.cd_local=cd_dst_mea
	Join Pessoa AGT on AGT.cd_pes=cd_Consig_mea
	Join Pessoa PP on PP.cd_pes=cd_consig_hea
	Join Pessoa SHP on SHP.cd_pes=cd_export_hea
	Left Join Vendas_Fechamento VF on Cd_export_hea=VF.cd_pes and cd_org_mea=cd_org and cd_dst_mea=cd_dst and dt_perd is null
	Left Join Usuario US on VF.cd_vendedor=US.cd_usuario
	jOIN Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_Tx
Where
	convert(datetime,dt_ins_mea,105) between @datainicial and @datafinal and desp_DST_mea='N' and 
	 cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc) and
	left(hou.num_proc_hea,5) <> 'EAJOB' and agt.apelido like @Agente AND CTA.CD_tP_TX NOT IN (SELECT CD_TP_tX FROM TIPO_TAXA WHERE NOME_TP_TX LIKE '%dEMURRAGE%')
Group by
	hou.num_proC_hea,cta.dc_mea,AGT.APelido, SHP.Apelido, PP.Apelido, cta.cd_tp_moeda, usd.Par_moeda,par.Par_Moeda ,Nome_usuario, month(convert(datetime,dt_ins_mea,105))


UNION

Select 
	hou.num_proc_him, AGT.APelido Agent, SHP.Apelido Shipper, PP.Apelido Consignee, cta.cd_tp_moeda, cta.dc_him,sum(vlr_org_HIM),cast(usd.Par_moeda as float) Paridade_USD, Cast(par.Par_Moeda as float) Paridade,Nome_usuario, month(convert(datetime,dt_ins_him,105)) Mes
From
	House_Imp_MAR HOU 
	Join Master_Imp_MAR MAS on MAS.num_proc_MIM=hou.num_proc_MIM
	Join Cta_cte_hou_imp_MAR CTA on CTA.num_proc_HIM=hou.num_proc_HIM
	LEft Join Paridade PAR on PAR.cd_tp_moeda=cta.cd_tp_moeda and converT(datetime,par.dt_par,105)=converT(datetime,dt_ins_HIM,105) and par.cd_tp_par='OFC'
	Left Join Paridade USD on USD.cd_tp_moeda='USD' and converT(datetime,usd.dt_par,105)=converT(datetime,dt_ins_HIM,105) and usd.cd_tp_par='OFC'
	Join Localidade Org on Org.cd_local=cd_org_MIM
	Join Localidade Dst on Dst.cd_local=cd_dst_MIM
	Join Pessoa AGT on AGT.cd_pes=cd_export_MIM
	Join Pessoa PP on PP.cd_pes=cd_consig_HIM
	Join Pessoa SHP on SHP.cd_pes=cd_export_HIM
	Left Join Vendas_Fechamento VF on Cd_Import_HIM=VF.cd_pes and cd_org_MIM=cd_org and cd_dst_MIM=cd_dst and dt_perd is null
	Left Join Usuario US on VF.cd_vendedor=US.cd_usuario
Where
	convert(datetime,dt_ins_HIM,105) between @datainicial and @datafinal and desp_org_HIM='N' and 
	 cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc) and
	left(hou.num_proc_HIM,5) <> 'IMJOB' and agt.apelido like @Agente AND CTA.CD_tP_TX NOT IN (SELECT CD_TP_tX FROM TIPO_TAXA WHERE NOME_TP_TX LIKE '%dEMURRAGE%')
Group by
	hou.num_proC_him,cta.dc_him,AGT.APelido, SHP.Apelido, PP.Apelido, cta.cd_tp_moeda, usd.Par_moeda,par.Par_Moeda ,Nome_usuario, month(convert(datetime,dt_ins_him,105)) 


UNION ALL

Select 
	hou.num_proC_him,AGT.APelido Agent, SHP.Apelido Shipper, PP.Apelido Consignee, cta.cd_tp_moeda, cta.dc_mim,sum(vlr_org_MIM*Isnull(dbo.spPar_MASC(num_proc_HIM, rateio_Tx),1)),cast(usd.Par_moeda as float) Paridade_USD, cast(par.Par_Moeda as floaT) Paridade,Nome_usuario, month(convert(datetime,dt_ins_mim,105)) Mes
From
	House_Imp_MAR HOU 
	Join Master_Imp_MAR MAS on MAS.num_proc_MIM=hou.num_proc_MIM
	Join Cta_cte_mas_imp_MAR CTA on CTA.num_proc_MIM=hou.num_proc_MIM
	LEft Join Paridade PAR on PAR.cd_tp_moeda=cta.cd_tp_moeda and converT(datetime,par.dt_par,105)=converT(datetime,dt_ins_MIM,105) and par.cd_tp_par='OFC'
	Left Join Paridade USD on USD.cd_tp_moeda='USD' and converT(datetime,usd.dt_par,105)=converT(datetime,dt_ins_MIM,105) and usd.cd_tp_par='OFC'
	Join Localidade Org on Org.cd_local=cd_org_MIM
	Join Localidade Dst on Dst.cd_local=cd_dst_MIM
	Join Pessoa AGT on AGT.cd_pes=cd_export_MIM
	Join Pessoa PP on PP.cd_pes=cd_consig_HIM
	Join Pessoa SHP on SHP.cd_pes=cd_export_HIM
	Left Join Vendas_Fechamento VF on Cd_Import_HIM=VF.cd_pes and cd_org_MIM=cd_org and cd_dst_MIM=cd_dst and dt_perd is null
	Left Join Usuario US on VF.cd_vendedor=US.cd_usuario
	jOIN Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_Tx
Where
	convert(datetime,dt_ins_MIM,105) between @datainicial and @datafinal and desp_org_MIM='N' and 
	 cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc) and
	left(hou.num_proc_HIM,5) <> 'IMJOB' and agt.apelido like @Agente AND CTA.CD_tP_TX NOT IN (SELECT CD_TP_tX FROM TIPO_TAXA WHERE NOME_TP_TX LIKE '%dEMURRAGE%')
Group by
	hou.num_proC_him,cta.dc_mim,AGT.APelido, SHP.Apelido, PP.Apelido, cta.cd_tp_moeda, usd.Par_moeda,par.Par_Moeda ,Nome_usuario, month(convert(datetime,dt_ins_mim,105)) 


UNION


Select 
	hou.num_proc_hem,AGT.APelido Agent, SHP.Apelido Shipper, PP.Apelido Consignee, cta.cd_tp_moeda, cta.dc_hem,sum(vlr_org_HEM),cast(usd.Par_moeda as float) Paridade_USD, cast(par.Par_Moeda as float)Paridade,Nome_usuario, month(convert(datetime,dt_ins_hem,105)) 
From
	House_exp_MAR HOU 
	Join Master_exp_MAR MAS on MAS.num_proc_MEM=hou.num_proc_MEM
	Join Cta_cte_hou_exp_MAR CTA on CTA.num_proc_HEM=hou.num_proc_HEM
	LEft Join Paridade PAR on PAR.cd_tp_moeda=cta.cd_tp_moeda and converT(datetime,par.dt_par,105)=converT(datetime,dt_ins_HEM,105) and par.cd_tp_par='OFC'
	Left Join Paridade USD on USD.cd_tp_moeda='USD' and converT(datetime,usd.dt_par,105)=converT(datetime,dt_ins_HEM,105) and usd.cd_tp_par='OFC'
	Join Localidade Org on Org.cd_local=cd_org_MEM
	Join Localidade Dst on Dst.cd_local=cd_dst_MEM
	Join Pessoa AGT on AGT.cd_pes=cd_Consig_MEM
	Join Pessoa PP on PP.cd_pes=cd_consig_HEM
	Join Pessoa SHP on SHP.cd_pes=cd_export_HEM
	Left Join Vendas_Fechamento VF on Cd_export_HEM=VF.cd_pes and cd_org_MEM=cd_org and cd_dst_MEM=cd_dst and dt_perd is null
	Left Join Usuario US on VF.cd_vendedor=US.cd_usuario
Where
	convert(datetime,dt_ins_HEM,105) between @datainicial and @datafinal and desp_DST_HEM='N' and 
	 cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc) and
	left(hou.num_proc_HEM,5) <> 'EMJOB' and agt.apelido like @Agente AND CTA.CD_tP_TX NOT IN (SELECT CD_TP_tX FROM TIPO_TAXA WHERE NOME_TP_TX LIKE '%dEMURRAGE%')
Group by
	hou.num_proC_hem,cta.dc_hem,AGT.APelido, SHP.Apelido, PP.Apelido, cta.cd_tp_moeda, usd.Par_moeda,par.Par_Moeda ,Nome_usuario, month(convert(datetime,dt_ins_hem,105))


UNION ALL

Select 
	hou.num_proC_hem,AGT.APelido Agent, SHP.Apelido Shipper, PP.Apelido Consignee, cta.cd_tp_moeda, cta.dc_mem,sum(vlr_org_MEM*Isnull(dbo.spPar_MASC(num_proc_HEM, rateio_Tx),1)),cast(usd.Par_moeda as float) Paridade_USD, cast(par.Par_Moeda as float) Paridade,Nome_usuario, month(convert(datetime,dt_ins_mem,105)) Mes
From
	House_exp_MAR HOU 
	Join Master_exp_MAR MAS on MAS.num_proc_MEM=hou.num_proc_MEM
	Join Cta_cte_mas_exp_MAR CTA on CTA.num_proc_MEM=hou.num_proc_MEM
	LEft Join Paridade PAR on PAR.cd_tp_moeda=cta.cd_tp_moeda and converT(datetime,par.dt_par,105)=converT(datetime,dt_ins_MEM,105) and par.cd_tp_par='OFC'
	Left Join Paridade USD on USD.cd_tp_moeda='USD' and converT(datetime,usd.dt_par,105)=converT(datetime,dt_ins_MEM,105) and usd.cd_tp_par='OFC'
	Join Localidade Org on Org.cd_local=cd_org_MEM
	Join Localidade Dst on Dst.cd_local=cd_dst_MEM
	Join Pessoa AGT on AGT.cd_pes=cd_Consig_MEM
	Join Pessoa PP on PP.cd_pes=cd_consig_HEM
	Join Pessoa SHP on SHP.cd_pes=cd_export_HEM
	Left Join Vendas_Fechamento VF on Cd_export_HEM=VF.cd_pes and cd_org_MEM=cd_org and cd_dst_MEM=cd_dst and dt_perd is null
	Left Join Usuario US on VF.cd_vendedor=US.cd_usuario
	jOIN Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_Tx
Where
	convert(datetime,dt_ins_MEM,105) between @datainicial and @datafinal and desp_DST_MEM='N' and 
	 cta.cd_tp_tx not in (select cd_tp_tx from param_aekcontabil_taxas_exc) and
	left(hou.num_proc_HEM,5) <> 'EMJOB' and agt.apelido like @Agente AND CTA.CD_tP_TX NOT IN (SELECT CD_TP_tX FROM TIPO_TAXA WHERE NOME_TP_TX LIKE '%dEMURRAGE%')
Group by
	hou.num_proC_hem,cta.dc_mem,AGT.APelido, SHP.Apelido, PP.Apelido, cta.cd_tp_moeda, usd.Par_moeda,par.Par_Moeda ,Nome_usuario, month(convert(datetime,dt_ins_mem,105)) 








GO
