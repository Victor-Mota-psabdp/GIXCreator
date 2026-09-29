SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE       Procedure [dbo].[spItensAberto_Rel] --'Federal%', '%','01/01/2002', '06/15/2009' 
		
	@apelido 		VarChar(25),
	@Modal			VarChar(2),
	@DataInicial	VarChar(10),
	@DataFinal		VarChar(10)

AS

--Importação Aérea

Select 
	upper(Cta.Num_Proc_HIA) Num_Proc_HIA,pp.apelido, Nome_tp_tx,cta.dc_hia,vlr_org_hia,Dt_Prev_Pgto_HIA,'Yes' SN,Nome_tp_moeda
from 
	Cta_cte_hou_imp_aer CTA
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Pessoa pp on pp.cd_pes=cd_cred_dev_hia
	Join Tipo_Moeda TM on TM.cd_tp_moeda=CTA.cd_Tp_moeda
	Left Join Caixa_Hou_Imp_Aer CXA on CTA.num_proc_hia=CXA.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO'
Where 
	Apelido like @Apelido and left(cta.num_proc_hia,2) like @Modal and convert(datetime,Dt_Ins_hia,105) between @DataInicial and @DataFinal
	AND LEFT(CTA.NUM_PROC_HIA,5) <> 'IAJOB' and cxa.num_lcto is null and desp_org_hia='N'

UNION

Select 
	upper(Cta.Num_Proc_mia) Num_Proc_HIA,pp.apelido, Nome_tp_tx,cta.dc_mia,vlr_org_mia,Dt_Prev_Pgto_mia, 'Yes' SN,Nome_TP_Moeda
from 
	Cta_cte_mas_imp_aer CTA
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Pessoa pp on pp.cd_pes=cd_cred_dev_mia
	Join Tipo_Moeda TM on TM.cd_tp_moeda=CTA.cd_Tp_moeda
	Left Join Caixa_mas_Imp_Aer CXA on CTA.num_proc_mia=CXA.num_proc_mia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mia=cxa.dc_mia and num_lcto <> 'PROVISÓRIO'
Where 
	Apelido like @Apelido and left(cta.num_proc_mia,2) like @Modal and convert(datetime,Dt_Ins_mia,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null and desp_org_mia='N'

UNION

--Exportação Aerea
Select 
	upper(Cta.Num_Proc_hea) Num_Proc_HIA,pp.apelido, Nome_tp_tx,cta.dc_hea,vlr_org_hea,Dt_Prev_Pgto_hea,'Yes' SN,Nome_Tp_Moeda
from 
	Cta_cte_hou_exp_aer CTA
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Pessoa pp on pp.cd_pes=cd_cred_dev_hea
	Join Tipo_Moeda TM on TM.cd_tp_moeda=CTA.cd_Tp_moeda
	Left Join Caixa_Hou_exp_Aer CXA on CTA.num_proc_hea=CXA.num_proc_hea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hea and num_lcto <> 'PROVISÓRIO'
Where 
	 Apelido like @Apelido and left(cta.num_proc_hea,2) like @Modal and convert(datetime,Dt_Ins_hea,105) between @DataInicial and @DataFinal
	AND LEFT(CTA.NUM_PROC_hea,5) <> 'EAJOB' and cxa.num_lcto is null and desp_dst_hea='N'

UNION

Select 
	upper(Cta.Num_Proc_mea) Num_Proc_HIA,pp.apelido, Nome_tp_tx,cta.dc_mea,vlr_org_mea,Dt_Prev_Pgto_mea,'Yes' SN,Nome_Tp_Moeda
from 
	Cta_cte_mas_exp_aer CTA
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Pessoa pp on pp.cd_pes=cd_cred_dev_mea
	Left Join Caixa_mas_exp_Aer CXA on CTA.num_proc_mea=CXA.num_proc_mea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mea=cxa.dc_mea and num_lcto <> 'PROVISÓRIO'
	Join Tipo_Moeda TM on TM.cd_tp_moeda=CTA.cd_Tp_moeda
Where 
	 Apelido like @Apelido and left(cta.num_proc_mea,2) like @Modal and convert(datetime,Dt_Ins_mea,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null and desp_dst_mea='N'

UNION
--Importação Maritima
Select 
	upper(Cta.Num_Proc_him) Num_Proc_HIA,pp.apelido, Nome_tp_tx,cta.dc_him,vlr_org_him,Dt_Prev_Pgto_him, 'Yes' SN,Nome_Tp_Moeda
from 
	Cta_cte_hou_imp_mar CTA
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Pessoa pp on pp.cd_pes=cd_cred_dev_him
	Join Tipo_Moeda TM on TM.cd_tp_moeda=CTA.cd_Tp_moeda
	Left Join Caixa_Hou_Imp_mar CXA on CTA.num_proc_him=CXA.num_proc_him and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him and num_lcto <> 'PROVISÓRIO'
Where 
	 Apelido like @Apelido and left(cta.num_proc_him,2) like @Modal and convert(datetime,Dt_Ins_him,105) between @DataInicial and @DataFinal
	AND LEFT(CTA.NUM_PROC_him,5) <> 'IMJOB' and cxa.num_lcto is null and desp_org_him='N'

UNION

Select 
	upper(Cta.Num_Proc_mim) Num_Proc_HIA,pp.apelido, Nome_tp_tx,cta.dc_mim,vlr_org_mim,Dt_Prev_Pgto_mim,'Yes' SN,Nome_Tp_Moeda
from 
	Cta_cte_mas_imp_mar CTA
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Pessoa pp on pp.cd_pes=cd_cred_dev_mim
	Join Tipo_Moeda TM on TM.cd_tp_moeda=CTA.cd_Tp_moeda
	Left Join Caixa_mas_Imp_mar CXA on CTA.num_proc_mim=CXA.num_proc_mim and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_mim and num_lcto <> 'PROVISÓRIO'
Where 
	 Apelido like @Apelido and left(cta.num_proc_mim,2) like @Modal and convert(datetime,Dt_Ins_mim,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null and desp_org_mim='N'

UNION

--Exportação Maritima

Select 
	upper(Cta.Num_Proc_hem) Num_Proc_HIA,pp.apelido, Nome_tp_tx,cta.dc_hem,vlr_org_hem,Dt_Prev_Pgto_hem,'Yes' SN,Nome_Tp_Moeda
from 
	Cta_cte_hou_exp_mar CTA
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Pessoa pp on pp.cd_pes=cd_cred_dev_hem
	Join Tipo_Moeda TM on TM.cd_tp_moeda=CTA.cd_Tp_moeda
	Left Join Caixa_Hou_exp_mar CXA on CTA.num_proc_hem=CXA.num_proc_hem and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hem=cxa.dc_hem and num_lcto <> 'PROVISÓRIO'
Where 
	 Apelido like @Apelido and left(cta.num_proc_hem,2) like @Modal and convert(datetime,Dt_Ins_hem,105) between @DataInicial and @DataFinal
	AND LEFT(CTA.NUM_PROC_hem,5) <> 'EMJOB' and cxa.num_lcto is null and desp_dst_hem='N'

UNION

Select 
	upper(Cta.Num_Proc_mem) Num_Proc_HIA,pp.apelido, Nome_tp_tx,cta.dc_mem,vlr_org_mem,Dt_Prev_Pgto_mem,'Yes' SN,Nome_TP_Moeda
from 
	Cta_cte_mas_exp_mar CTA
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Pessoa pp on pp.cd_pes=cd_cred_dev_mem
	Join Tipo_Moeda TM on TM.cd_tp_moeda=CTA.cd_Tp_moeda
	Left Join Caixa_mas_exp_mar CXA on CTA.num_proc_mem=CXA.num_proc_mem and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mem=cxa.dc_mem and num_lcto <> 'PROVISÓRIO'
Where 
	 Apelido like @Apelido and left(cta.num_proc_mem,2) like @Modal and convert(datetime,Dt_Ins_mem,105) between @DataInicial and @DataFinal
	and cxa.num_lcto is null and desp_dst_mem='N'

Union
--Importação Outros
Select 
	upper(Cta.Num_Proc_hio) Num_Proc_HIA,pp.apelido, Nome_tp_tx,cta.dc_hio,vlr_org_hio,Dt_Prev_Pgto_hio,'Yes' SN,Nome_Tp_Moeda
from 
	Cta_cte_hou_imp_out CTA
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Pessoa pp on pp.cd_pes=cd_cred_dev_hio
	Join Tipo_Moeda TM on TM.cd_tp_moeda=CTA.cd_Tp_moeda
	Left Join Caixa_Hou_imp_out CXA on CTA.num_proc_hio=CXA.num_proc_hio and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hio=cxa.dc_hio and num_lcto <> 'PROVISÓRIO'
Where 
	 Apelido like @Apelido and left(cta.num_proc_hio,2) like @Modal and convert(datetime,Dt_Ins_hio,105) between @DataInicial and @DataFinal
	AND cxa.num_lcto is null and desp_org_hio='N'
union
--Exportação Outros

Select 
	upper(Cta.Num_Proc_heo) Num_Proc_HIA,pp.apelido, Nome_tp_tx,cta.dc_heo,vlr_org_heo,Dt_Prev_Pgto_heo,'Yes' SN,Nome_Tp_Moeda
from 
	Cta_cte_hou_exp_out CTA
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Join Pessoa pp on pp.cd_pes=cd_cred_dev_heo
	Join Tipo_Moeda TM on TM.cd_tp_moeda=CTA.cd_Tp_moeda
	Left Join Caixa_Hou_exp_out CXA on CTA.num_proc_heo=CXA.num_proc_heo and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_heo=cxa.dc_heo and num_lcto <> 'PROVISÓRIO'
Where 
	 Apelido like @Apelido and left(cta.num_proc_heo,2) like @Modal and convert(datetime,Dt_Ins_heo,105) between @DataInicial and @DataFinal
	AND  cxa.num_lcto is null and desp_org_heo='N'











GO
