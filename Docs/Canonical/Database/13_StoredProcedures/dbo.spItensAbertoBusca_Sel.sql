SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE       Procedure [dbo].[spItensAbertoBusca_Sel] --'%', '%', '%' , '%', '%2001%'
		
	@Apelido 		VarChar(50),
	@Taxa			VarChar(50),
	@JOB			VarChar(18),
	@CNPJ			VarChar(20),
	@NF				Varchar(12)

AS

	
if @NF <> '%'
	--Importação Aérea

	Select 
		DISTINCT upper(Cta.Num_Proc_HIA) Num_Proc, pp.apelido, Nome_tp_tx,cta.dc_hia DC,vlr_org_hia vlr_org,Dt_Prev_Pgto_HIA Dt_Prev_Pgto,'Yes' SN,Nome_tp_moeda
	from 
		Cta_cte_hou_imp_aer CTA
		Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
		Join Pessoa pp with(nolock) on pp.cd_pes=cd_cred_dev_hia
		Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=CTA.cd_Tp_moeda
		Left Join Caixa_Hou_Imp_Aer CXA on CTA.num_proc_hia=CXA.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO'
	Where 
		PP.Apelido like @Apelido and TT.Nome_tp_tx like @Taxa and CTA.Num_proc_hia like @JOB and PP.Num_CPF_CNPJ like @CNPJ and CTA.Num_NF_HIA like @NF
		AND LEFT(CTA.NUM_PROC_HIA,5) <> 'IAJOB' and cxa.num_lcto is null and desp_org_hia='N'

	UNION ALL

	Select 
		DISTINCT upper(Cta.Num_Proc_mia) Num_Proc,pp.apelido, Nome_tp_tx,cta.dc_mia DC,vlr_org_mia Vlr_Og,Dt_Prev_Pgto_mia Dt_Prev_Pgto, 'Yes' SN,Nome_TP_Moeda
	from 
		Cta_cte_mas_imp_aer CTA
		Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
		Join Pessoa pp with(nolock) on pp.cd_pes=cd_cred_dev_mia
		Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=CTA.cd_Tp_moeda
		Left Join Caixa_mas_Imp_Aer CXA on CTA.num_proc_mia=CXA.num_proc_mia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mia=cxa.dc_mia and num_lcto <> 'PROVISÓRIO'
	Where 
		PP.Apelido like @Apelido and TT.Nome_tp_tx like @Taxa and CTA.Num_proc_mia like @JOB and PP.Num_CPF_CNPJ like @CNPJ and CTA.Num_NF_mIA like @NF
		and cxa.num_lcto is null and desp_org_mia='N'

	UNION ALL

	--Exportação Aerea
	Select 
		DISTINCT upper(Cta.Num_Proc_hea) Num_Proc ,pp.apelido, Nome_tp_tx,cta.dc_hea DC,vlr_org_hea Vlr_Org,Dt_Prev_Pgto_hea Dt_Prev_Pgto,'Yes' SN,Nome_Tp_Moeda
	from 
		Cta_cte_hou_exp_aer CTA
		Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
		Join Pessoa pp with(nolock) on pp.cd_pes=cd_cred_dev_hea
		Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=CTA.cd_Tp_moeda
		Left Join Caixa_Hou_exp_Aer CXA on CTA.num_proc_hea=CXA.num_proc_hea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hea and num_lcto <> 'PROVISÓRIO'
	Where 
		PP.Apelido like @Apelido and TT.Nome_tp_tx like @Taxa and CTA.Num_proc_hea like @JOB and PP.Num_CPF_CNPJ like @CNPJ and CTA.Num_NF_HEA like @NF
		AND LEFT(CTA.NUM_PROC_hea,5) <> 'EAJOB' and cxa.num_lcto is null and desp_dst_hea='N'

	UNION ALL

	Select 
		DISTINCT upper(Cta.Num_Proc_mea) Num_Proc,pp.apelido, Nome_tp_tx,cta.dc_mea DC,vlr_org_mea Vlr_Org,Dt_Prev_Pgto_mea Dt_Prev_Pgto,'Yes' SN,Nome_Tp_Moeda
	from 
		Cta_cte_mas_exp_aer CTA
		Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
		Join Pessoa pp with(nolock) on pp.cd_pes=cd_cred_dev_mea
		Left Join Caixa_mas_exp_Aer CXA on CTA.num_proc_mea=CXA.num_proc_mea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mea=cxa.dc_mea and num_lcto <> 'PROVISÓRIO'
		Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=CTA.cd_Tp_moeda
	Where 
		PP.Apelido like @Apelido and TT.Nome_tp_tx like @Taxa and CTA.Num_proc_mea like @JOB and PP.Num_CPF_CNPJ like @CNPJ and CTA.Num_NF_mea like @NF
		and cxa.num_lcto is null and desp_dst_mea='N'

	UNION ALL
	--Importação Maritima
	Select 
		DISTINCT upper(Cta.Num_Proc_him) Num_Proc,pp.apelido, Nome_tp_tx,cta.dc_him DC,vlr_org_him Vlr_Org,Dt_Prev_Pgto_him Dt_Prec_Pgto, 'Yes' SN,Nome_Tp_Moeda
	from 
		Cta_cte_hou_imp_mar CTA
		Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
		Join Pessoa pp with(nolock) on pp.cd_pes=cd_cred_dev_him
		Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=CTA.cd_Tp_moeda
		Left Join Caixa_Hou_Imp_mar CXA on CTA.num_proc_him=CXA.num_proc_him and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him and num_lcto <> 'PROVISÓRIO'
	Where 
		PP.Apelido like @Apelido and TT.Nome_tp_tx like @Taxa and CTA.Num_proc_him like @JOB and PP.Num_CPF_CNPJ like @CNPJ and CTA.Num_NF_Him like @NF
		AND LEFT(CTA.NUM_PROC_him,5) <> 'IMJOB' and cxa.num_lcto is null and desp_org_him='N'

	UNION ALL

	Select 
		DISTINCT upper(Cta.Num_Proc_mim) Num_Proc,pp.apelido, Nome_tp_tx,cta.dc_mim DC,vlr_org_mim Vlr_Org,Dt_Prev_Pgto_mim Dt_Prev_Pgto,'Yes' SN,Nome_Tp_Moeda
	from 
		Cta_cte_mas_imp_mar CTA
		Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
		Join Pessoa pp with(nolock) on pp.cd_pes=cd_cred_dev_mim
		Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=CTA.cd_Tp_moeda
		Left Join Caixa_mas_Imp_mar CXA on CTA.num_proc_mim=CXA.num_proc_mim and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_mim and num_lcto <> 'PROVISÓRIO'
	Where 
		PP.Apelido like @Apelido and TT.Nome_tp_tx like @Taxa and CTA.Num_proc_mim like @JOB and PP.Num_CPF_CNPJ like @CNPJ and CTA.Num_NF_mim like @NF
		and cxa.num_lcto is null and desp_org_mim='N'

	UNION ALL

	--Exportação Maritima

	Select 
		DISTINCT upper(Cta.Num_Proc_hem) Num_Proc,pp.apelido, Nome_tp_tx,cta.dc_hem DC,vlr_org_hem Vlr_Org,Dt_Prev_Pgto_hem Dt_Prev_Pgto,'Yes' SN,Nome_Tp_Moeda
	from 
		Cta_cte_hou_exp_mar CTA
		Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
		Join Pessoa pp with(nolock) on pp.cd_pes=cd_cred_dev_hem
		Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=CTA.cd_Tp_moeda
		Left Join Caixa_Hou_exp_mar CXA on CTA.num_proc_hem=CXA.num_proc_hem and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hem=cxa.dc_hem and num_lcto <> 'PROVISÓRIO'
	Where 
		PP.Apelido like @Apelido and TT.Nome_tp_tx like @Taxa and CTA.Num_proc_hem like @JOB and PP.Num_CPF_CNPJ like @CNPJ and CTA.Num_NF_Hem like @NF
		AND LEFT(CTA.NUM_PROC_hem,5) <> 'EMJOB' and cxa.num_lcto is null and desp_dst_hem='N'

	UNION

	Select 
		DISTINCT upper(Cta.Num_Proc_mem) Num_Proc,pp.apelido, Nome_tp_tx,cta.dc_mem DC,vlr_org_mem Vlr_Org,Dt_Prev_Pgto_mem Dt_Prev_Pgto,'Yes' SN,Nome_TP_Moeda
	from 
		Cta_cte_mas_exp_mar CTA
		Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
		Join Pessoa pp with(nolock) on pp.cd_pes=cd_cred_dev_mem
		Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=CTA.cd_Tp_moeda
		Left Join Caixa_mas_exp_mar CXA on CTA.num_proc_mem=CXA.num_proc_mem and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mem=cxa.dc_mem and num_lcto <> 'PROVISÓRIO'
	Where 
		PP.Apelido like @Apelido and TT.Nome_tp_tx like @Taxa and CTA.Num_proc_mem like @JOB and PP.Num_CPF_CNPJ like @CNPJ and CTA.Num_NF_mem like @NF
		and cxa.num_lcto is null and desp_dst_mem='N'

	Union ALL
	--Importação Outros
	Select 
		DISTINCT upper(Cta.Num_Proc_hio) Num_Proc,pp.apelido, Nome_tp_tx,cta.dc_hio DC,vlr_org_hio Vlr_Org,Dt_Prev_Pgto_hio Dt_Prev_Pgto,'Yes' SN,Nome_Tp_Moeda
	from 
		Cta_cte_hou_imp_out CTA
		Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
		Join Pessoa pp with(nolock) on pp.cd_pes=cd_cred_dev_hio
		Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=CTA.cd_Tp_moeda
		Left Join Caixa_Hou_imp_out CXA on CTA.num_proc_hio=CXA.num_proc_hio and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hio=cxa.dc_hio and num_lcto <> 'PROVISÓRIO'
	Where 
		PP.Apelido like @Apelido and TT.Nome_tp_tx like @Taxa and CTA.Num_proc_hio like @JOB and PP.Num_CPF_CNPJ like @CNPJ and CTA.Num_NF_HIo like @NF
		AND cxa.num_lcto is null and desp_org_hio='N'
	
	union ALL
	--Exportação Outros

	Select 
		DISTINCT upper(Cta.Num_Proc_heo) Num_Proc,pp.apelido, Nome_tp_tx,cta.dc_heo DC,vlr_org_heo Vlr_Org,Dt_Prev_Pgto_heo Dt_Prev_Pgto,'Yes' SN,Nome_Tp_Moeda
	from 
		Cta_cte_hou_exp_out CTA
		Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
		Join Pessoa pp with(nolock) on pp.cd_pes=cd_cred_dev_heo
		Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=CTA.cd_Tp_moeda
		Left Join Caixa_Hou_exp_out CXA on CTA.num_proc_heo=CXA.num_proc_heo and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_heo=cxa.dc_heo and num_lcto <> 'PROVISÓRIO'
	Where 
		PP.Apelido like @Apelido and TT.Nome_tp_tx like @Taxa and CTA.Num_proc_heo like @JOB and PP.Num_CPF_CNPJ like @CNPJ and CTA.Num_NF_Heo like @NF
		AND  cxa.num_lcto is null and desp_org_heo='N'

else

	--Importação Aérea

	Select 
		DISTINCT upper(Cta.Num_Proc_HIA) Num_Proc, pp.apelido, Nome_tp_tx,cta.dc_hia DC,vlr_org_hia vlr_org,Dt_Prev_Pgto_HIA Dt_Prev_Pgto,'Yes' SN,Nome_tp_moeda
	from 
		Cta_cte_hou_imp_aer CTA
		Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
		Join Pessoa pp with(nolock) on pp.cd_pes=cd_cred_dev_hia
		Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=CTA.cd_Tp_moeda
		Left Join Caixa_Hou_Imp_Aer CXA on CTA.num_proc_hia=CXA.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO'
	Where 
		PP.Apelido like @Apelido and TT.Nome_tp_tx like @Taxa and CTA.Num_proc_hia like @JOB and PP.Num_CPF_CNPJ like @CNPJ 
		AND LEFT(CTA.NUM_PROC_HIA,5) <> 'IAJOB' and cxa.num_lcto is null and desp_org_hia='N'

	UNION ALL

	Select 
		DISTINCT upper(Cta.Num_Proc_mia) Num_Proc,pp.apelido, Nome_tp_tx,cta.dc_mia DC,vlr_org_mia Vlr_Og,Dt_Prev_Pgto_mia Dt_Prev_Pgto, 'Yes' SN,Nome_TP_Moeda
	from 
		Cta_cte_mas_imp_aer CTA
		Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
		Join Pessoa pp with(nolock) on pp.cd_pes=cd_cred_dev_mia
		Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=CTA.cd_Tp_moeda
		Left Join Caixa_mas_Imp_Aer CXA on CTA.num_proc_mia=CXA.num_proc_mia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mia=cxa.dc_mia and num_lcto <> 'PROVISÓRIO'
	Where 
		PP.Apelido like @Apelido and TT.Nome_tp_tx like @Taxa and CTA.Num_proc_mia like @JOB and PP.Num_CPF_CNPJ like @CNPJ 
		and cxa.num_lcto is null and desp_org_mia='N'

	UNION ALL

	--Exportação Aerea
	Select 
		DISTINCT upper(Cta.Num_Proc_hea) Num_Proc ,pp.apelido, Nome_tp_tx,cta.dc_hea DC,vlr_org_hea Vlr_Org,Dt_Prev_Pgto_hea Dt_Prev_Pgto,'Yes' SN,Nome_Tp_Moeda
	from 
		Cta_cte_hou_exp_aer CTA
		Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
		Join Pessoa pp with(nolock) on pp.cd_pes=cd_cred_dev_hea
		Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=CTA.cd_Tp_moeda
		Left Join Caixa_Hou_exp_Aer CXA on CTA.num_proc_hea=CXA.num_proc_hea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hea and num_lcto <> 'PROVISÓRIO'
	Where 
		PP.Apelido like @Apelido and TT.Nome_tp_tx like @Taxa and CTA.Num_proc_hea like @JOB and PP.Num_CPF_CNPJ like @CNPJ 
		AND LEFT(CTA.NUM_PROC_hea,5) <> 'EAJOB' and cxa.num_lcto is null and desp_dst_hea='N'

	UNION

	Select 
		DISTINCT upper(Cta.Num_Proc_mea) Num_Proc,pp.apelido, Nome_tp_tx,cta.dc_mea DC,vlr_org_mea Vlr_Org,Dt_Prev_Pgto_mea Dt_Prev_Pgto,'Yes' SN,Nome_Tp_Moeda
	from 
		Cta_cte_mas_exp_aer CTA
		Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
		Join Pessoa pp with(nolock) on pp.cd_pes=cd_cred_dev_mea
		Left Join Caixa_mas_exp_Aer CXA on CTA.num_proc_mea=CXA.num_proc_mea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mea=cxa.dc_mea and num_lcto <> 'PROVISÓRIO'
		Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=CTA.cd_Tp_moeda
	Where 
		PP.Apelido like @Apelido and TT.Nome_tp_tx like @Taxa and CTA.Num_proc_mea like @JOB and PP.Num_CPF_CNPJ like @CNPJ
		and cxa.num_lcto is null and desp_dst_mea='N'

	UNION ALL
	--Importação Maritima
	Select 
		DISTINCT upper(Cta.Num_Proc_him) Num_Proc,pp.apelido, Nome_tp_tx,cta.dc_him DC,vlr_org_him Vlr_Org,Dt_Prev_Pgto_him Dt_Prec_Pgto, 'Yes' SN,Nome_Tp_Moeda
	from 
		Cta_cte_hou_imp_mar CTA
		Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
		Join Pessoa pp with(nolock) on pp.cd_pes=cd_cred_dev_him
		Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=CTA.cd_Tp_moeda
		Left Join Caixa_Hou_Imp_mar CXA on CTA.num_proc_him=CXA.num_proc_him and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him and num_lcto <> 'PROVISÓRIO'
	Where 
		PP.Apelido like @Apelido and TT.Nome_tp_tx like @Taxa and CTA.Num_proc_him like @JOB and PP.Num_CPF_CNPJ like @CNPJ
		AND LEFT(CTA.NUM_PROC_him,5) <> 'IMJOB' and cxa.num_lcto is null and desp_org_him='N'

	UNION ALL

	Select 
		DISTINCT upper(Cta.Num_Proc_mim) Num_Proc,pp.apelido, Nome_tp_tx,cta.dc_mim DC,vlr_org_mim Vlr_Org,Dt_Prev_Pgto_mim Dt_Prev_Pgto,'Yes' SN,Nome_Tp_Moeda
	from 
		Cta_cte_mas_imp_mar CTA
		Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
		Join Pessoa pp with(nolock) on pp.cd_pes=cd_cred_dev_mim
		Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=CTA.cd_Tp_moeda
		Left Join Caixa_mas_Imp_mar CXA on CTA.num_proc_mim=CXA.num_proc_mim and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_mim and num_lcto <> 'PROVISÓRIO'
	Where 
		PP.Apelido like @Apelido and TT.Nome_tp_tx like @Taxa and CTA.Num_proc_mim like @JOB and PP.Num_CPF_CNPJ like @CNPJ
		and cxa.num_lcto is null and desp_org_mim='N'

	UNION ALL

	--Exportação Maritima

	Select 
		DISTINCT upper(Cta.Num_Proc_hem) Num_Proc,pp.apelido, Nome_tp_tx,cta.dc_hem DC,vlr_org_hem Vlr_Org,Dt_Prev_Pgto_hem Dt_Prev_Pgto,'Yes' SN,Nome_Tp_Moeda
	from 
		Cta_cte_hou_exp_mar CTA
		Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
		Join Pessoa pp with(nolock) on pp.cd_pes=cd_cred_dev_hem
		Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=CTA.cd_Tp_moeda
		Left Join Caixa_Hou_exp_mar CXA on CTA.num_proc_hem=CXA.num_proc_hem and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hem=cxa.dc_hem and num_lcto <> 'PROVISÓRIO'
	Where 
		PP.Apelido like @Apelido and TT.Nome_tp_tx like @Taxa and CTA.Num_proc_hem like @JOB and PP.Num_CPF_CNPJ like @CNPJ
		AND LEFT(CTA.NUM_PROC_hem,5) <> 'EMJOB' and cxa.num_lcto is null and desp_dst_hem='N'

	UNION

	Select 
		DISTINCT upper(Cta.Num_Proc_mem) Num_Proc,pp.apelido, Nome_tp_tx,cta.dc_mem DC,vlr_org_mem Vlr_Org,Dt_Prev_Pgto_mem Dt_Prev_Pgto,'Yes' SN,Nome_TP_Moeda
	from 
		Cta_cte_mas_exp_mar CTA
		Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
		Join Pessoa pp with(nolock) on pp.cd_pes=cd_cred_dev_mem
		Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=CTA.cd_Tp_moeda
		Left Join Caixa_mas_exp_mar CXA on CTA.num_proc_mem=CXA.num_proc_mem and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_mem=cxa.dc_mem and num_lcto <> 'PROVISÓRIO'
	Where 
		PP.Apelido like @Apelido and TT.Nome_tp_tx like @Taxa and CTA.Num_proc_mem like @JOB and PP.Num_CPF_CNPJ like @CNPJ
		and cxa.num_lcto is null and desp_dst_mem='N'

	Union ALL
	--Importação Outros
	Select 
		DISTINCT upper(Cta.Num_Proc_hio) Num_Proc,pp.apelido, Nome_tp_tx,cta.dc_hio DC,vlr_org_hio Vlr_Org,Dt_Prev_Pgto_hio Dt_Prev_Pgto,'Yes' SN,Nome_Tp_Moeda
	from 
		Cta_cte_hou_imp_out CTA
		Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
		Join Pessoa pp with(nolock) on pp.cd_pes=cd_cred_dev_hio
		Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=CTA.cd_Tp_moeda
		Left Join Caixa_Hou_imp_out CXA on CTA.num_proc_hio=CXA.num_proc_hio and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hio=cxa.dc_hio and num_lcto <> 'PROVISÓRIO'
	Where 
		PP.Apelido like @Apelido and TT.Nome_tp_tx like @Taxa and CTA.Num_proc_hio like @JOB and PP.Num_CPF_CNPJ like @CNPJ
		AND cxa.num_lcto is null and desp_org_hio='N'
	
	union ALL
	--Exportação Outros

	Select 
		DISTINCT upper(Cta.Num_Proc_heo) Num_Proc,pp.apelido, Nome_tp_tx,cta.dc_heo DC,vlr_org_heo Vlr_Org,Dt_Prev_Pgto_heo Dt_Prev_Pgto,'Yes' SN,Nome_Tp_Moeda
	from 
		Cta_cte_hou_exp_out CTA
		Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=CTA.cd_tp_tx
		Join Pessoa pp with(nolock) on pp.cd_pes=cd_cred_dev_heo
		Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=CTA.cd_Tp_moeda
		Left Join Caixa_Hou_exp_out CXA on CTA.num_proc_heo=CXA.num_proc_heo and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_heo=cxa.dc_heo and num_lcto <> 'PROVISÓRIO'
	Where 
		PP.Apelido like @Apelido and TT.Nome_tp_tx like @Taxa and CTA.Num_proc_heo like @JOB and PP.Num_CPF_CNPJ like @CNPJ
		AND  cxa.num_lcto is null and desp_org_heo='N'














GO
