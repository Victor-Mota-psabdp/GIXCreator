SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--SELECT * from house_imp_mar where num_proc_him='IMIFB20100703901'

CREATE        Procedure [dbo].[spPgto_Rcto_Rel] --'LA2010090001'
		
	@Num_Lcto	VarChar(16)

-- Alterado por anderson em 03-03
-- Claudio 		isnull(HOU.MAWB_HiM,MAS.MAWB_MiM) Master
AS

	SELECT
		PR.Num_Lcto	Num_Lcto, 
		PR.Cd_Banco Cd_Banco, 
		PR.Cd_Agencia Cd_Agencia, 
		PR.Num_Cta_Cte Num_Cta_Cte, 
		PR.DC DC, 
		PR.Dt_Pgto_Rcto Dt_Pgto_Rcto, 
		PR.Num_Doc Num_Doc, 
		PR.Vlr_Doc Vlr_Doc, 
		P.Apelido Apelido, 
		PR.Dt_Vcto Dt_Vcto, 
		PR.Concil Concil, 
		PR.Cta_Cte_Cliente Cta_Cte_Cliente, 
		PR.Ck_Doctos Ck_Doctos,
		TT.nome_tp_tx Nome_Tp_Tx,
		Par_Moeda_HEM Par_Moeda,
		CC.Titular Titular,
		PR.Forma_Pgto_Rcto Forma_Pgto_Rcto,
		CH.Num_Proc_HEM Num_Proc,
		CH.Vlr_Ref_HEM Vlr_Ref,
		CH.Vlr_Pgto_Rcto_HEM Vlr_Pgto_Rcto,
		CH.DC_HEM DC_DET,
		isnull(HOU.MAWB_HEM,MAS.MAWB_MEM) Master,
		dbo.fbusca_docs_po_modal(HOU.Num_proc_hem,'1') PO
	FROM
		Pgto_Rcto PR
		join Cta_Cte CC on PR.Num_Cta_Cte = CC.Num_Cta_Cte
		left outer join caixa_hou_exp_mar CH on PR.Num_Lcto = CH.Num_Lcto
		left outer join cta_cte_hou_exp_mar CCT on CH.Num_proc_hem = CCT.Num_proc_hem and CH.cd_tp_tx = CCT.cd_tp_tx and CH.DC_HEM = CCT.DC_HEM 
		left outer join house_exp_mar HOU on CH.Num_proc_hem = HOU.Num_proc_hem
		left outer join master_exp_mar MAS on HOU.Num_proc_mem = MAS.Num_proc_mem
		left outer join  tipo_taxa TT on CH.Cd_Tp_Tx = TT.Cd_Tp_Tx
		left outer join  Pessoa P on CCT.Cd_cred_dev_hem = P.Cd_Pes
	where
		PR.Num_Lcto = @Num_Lcto

Union

	SELECT
		PR.Num_Lcto	Num_Lcto,
		PR.Cd_Banco Cd_Banco, 
		PR.Cd_Agencia Cd_Agencia, 
		PR.Num_Cta_Cte Num_Cta_Cte, 
		PR.DC DC, 
		PR.Dt_Pgto_Rcto Dt_Pgto_Rcto, 
		PR.Num_Doc Num_Doc, 
		PR.Vlr_Doc Vlr_Doc, 
		P.Apelido Apelido, 
		PR.Dt_Vcto Dt_Vcto, 
		PR.Concil Concil, 
		PR.Cta_Cte_Cliente Cta_Cte_Cliente, 
		PR.Ck_Doctos Ck_Doctos,
		TT.nome_tp_tx Nome_Tp_Tx,
		Par_Moeda_heo Par_Moeda,
		CC.Titular Titular,
		PR.Forma_Pgto_Rcto Forma_Pgto_Rcto,
		CH.Num_Proc_heo Num_Proc,
		CH.Vlr_Ref_heo Vlr_Ref,
		CH.Vlr_Pgto_Rcto_heo Vlr_Pgto_Rcto,
		CH.DC_heo DC_DET,
		NULL Master,
		dbo.fbusca_docs_po_modal(CH.Num_proc_heo,'1') PO
	FROM 
		Pgto_Rcto PR
		join Cta_Cte CC on PR.Num_Cta_Cte = CC.Num_Cta_Cte
		left outer join caixa_hou_exp_out CH on PR.Num_Lcto = CH.Num_Lcto
		left outer join cta_cte_hou_exp_out CCT on CH.Num_proc_heo = CCT.Num_proc_heo and CH.cd_tp_tx = CCT.cd_tp_tx and CH.DC_heo = CCT.DC_heo 
		left outer join  tipo_taxa TT on CH.Cd_Tp_Tx = TT.Cd_Tp_Tx
		left outer join  Pessoa P on CCT.Cd_cred_dev_heo = P.Cd_Pes
	where 
		PR.Num_Lcto = @Num_Lcto

Union

	SELECT
		PR.Num_Lcto	Num_Lcto, 
		PR.Cd_Banco Cd_Banco, 
		PR.Cd_Agencia Cd_Agencia, 
		PR.Num_Cta_Cte Num_Cta_Cte, 
		PR.DC DC, 
		PR.Dt_Pgto_Rcto Dt_Pgto_Rcto, 
		PR.Num_Doc Num_Doc, 
		PR.Vlr_Doc Vlr_Doc, 
		P.Apelido Apelido, 
		PR.Dt_Vcto Dt_Vcto, 
		PR.Concil Concil, 
		PR.Cta_Cte_Cliente Cta_Cte_Cliente, 
		PR.Ck_Doctos Ck_Doctos,
		TT.nome_tp_tx Nome_Tp_Tx,
		Par_Moeda_hea Par_Moeda,
		CC.Titular Titular,
		PR.Forma_Pgto_Rcto Forma_Pgto_Rcto,
		CH.Num_Proc_hea Num_Proc,
		CH.Vlr_Ref_hea Vlr_Ref,
		CH.Vlr_Pgto_Rcto_hea Vlr_Pgto_Rcto,
		CH.DC_hea DC_DET,
		isnull(HOU.MAWB_HEA,MAS.MAWB_MEA) Master,
		dbo.fbusca_docs_po_modal(HOU.Num_proc_hea,'1') PO
	FROM 
		Pgto_Rcto PR
		join Cta_Cte CC on PR.Num_Cta_Cte = CC.Num_Cta_Cte
		left outer join caixa_hou_exp_aer CH on PR.Num_Lcto = CH.Num_Lcto
		left outer join cta_cte_hou_exp_aer CCT on CH.Num_proc_hea = CCT.Num_proc_hea and CH.cd_tp_tx = CCT.cd_tp_tx and CH.DC_hea = CCT.DC_hea 
		left outer join house_exp_aer HOU on CH.Num_proc_hea = HOU.Num_proc_hea
		left outer join master_exp_aer MAS on HOU.Num_proc_mea = MAS.Num_proc_mea
		left outer join  tipo_taxa TT on CH.Cd_Tp_Tx = TT.Cd_Tp_Tx
		left outer join  Pessoa P on CCT.Cd_cred_dev_hea = P.Cd_Pes
	where
		PR.Num_Lcto = @Num_Lcto

Union

	SELECT
		PR.Num_Lcto	Num_Lcto, 
		PR.Cd_Banco Cd_Banco, 
		PR.Cd_Agencia Cd_Agencia, 
		PR.Num_Cta_Cte Num_Cta_Cte, 
		PR.DC DC, 
		PR.Dt_Pgto_Rcto Dt_Pgto_Rcto, 
		PR.Num_Doc Num_Doc, 
		PR.Vlr_Doc Vlr_Doc, 
		P.Apelido Apelido, 
		PR.Dt_Vcto Dt_Vcto, 
		PR.Concil Concil, 
		PR.Cta_Cte_Cliente Cta_Cte_Cliente, 
		PR.Ck_Doctos Ck_Doctos,
		TT.nome_tp_tx Nome_Tp_Tx,
		Par_Moeda_him Par_Moeda,
		CC.Titular Titular,
		PR.Forma_Pgto_Rcto Forma_Pgto_Rcto,
		CH.Num_Proc_him Num_Proc,
		CH.Vlr_Ref_him Vlr_Ref,
		CH.Vlr_Pgto_Rcto_him Vlr_Pgto_Rcto,
		CH.DC_him DC_DET,
--		MAS.MAWB_MIM Master
		isnull(HOU.MAWB_HIM, MAS.MAWB_MIM) Master,
		dbo.fbusca_docs_po_modal(HOU.Num_proc_him,'1') PO
	FROM 
		Pgto_Rcto PR
		join Cta_Cte CC on PR.Num_Cta_Cte = CC.Num_Cta_Cte
		left outer join caixa_hou_imp_mar CH on PR.Num_Lcto = CH.Num_Lcto
		left outer join cta_cte_hou_imp_mar CCT on CH.Num_proc_him = CCT.Num_proc_him and CH.cd_tp_tx = CCT.cd_tp_tx and CH.DC_him = CCT.DC_him 
		left outer join house_imp_mar HOU on CH.Num_proc_him = HOU.Num_proc_him
		left outer join master_imp_mar MAS on HOU.Num_proc_mim = MAS.Num_proc_mim
		left outer join  tipo_taxa TT on CH.Cd_Tp_Tx = TT.Cd_Tp_Tx
		left outer join  Pessoa P on CCT.Cd_cred_dev_him = P.Cd_Pes
	where 
		PR.Num_Lcto = @Num_Lcto

Union

	SELECT  
		PR.Num_Lcto	Num_Lcto, 
		PR.Cd_Banco Cd_Banco, 
		PR.Cd_Agencia Cd_Agencia, 
		PR.Num_Cta_Cte Num_Cta_Cte, 
		PR.DC DC, 
		PR.Dt_Pgto_Rcto Dt_Pgto_Rcto, 
		PR.Num_Doc Num_Doc, 
		PR.Vlr_Doc Vlr_Doc, 
		P.Apelido Apelido, 
		PR.Dt_Vcto Dt_Vcto, 
		PR.Concil Concil, 
		PR.Cta_Cte_Cliente Cta_Cte_Cliente, 
		PR.Ck_Doctos Ck_Doctos,
		TT.nome_tp_tx Nome_Tp_Tx,
		Par_Moeda_hio Par_Moeda,
		CC.Titular Titular,
		PR.Forma_Pgto_Rcto Forma_Pgto_Rcto,
		CH.Num_Proc_hio Num_Proc,
		CH.Vlr_Ref_hio Vlr_Ref,
		CH.Vlr_Pgto_Rcto_hio Vlr_Pgto_Rcto,
		CH.DC_hio DC_DET,
		Null Master,
		dbo.fbusca_docs_po_modal(CH.Num_proc_hio,'1') PO
	FROM 
		Pgto_Rcto PR
		join Cta_Cte CC on PR.Num_Cta_Cte = CC.Num_Cta_Cte
		left outer join caixa_hou_imp_out CH on PR.Num_Lcto = CH.Num_Lcto
		left outer join cta_cte_hou_imp_out CCT on CH.Num_proc_hio = CCT.Num_proc_hio and CH.cd_tp_tx = CCT.cd_tp_tx and CH.DC_hio = CCT.DC_hio 
		left outer join  tipo_taxa TT on CH.Cd_Tp_Tx = TT.Cd_Tp_Tx
		left outer join  Pessoa P on CCT.Cd_cred_dev_hio = P.Cd_Pes
	where 
		PR.Num_Lcto = @Num_Lcto

Union

	SELECT
		PR.Num_Lcto	Num_Lcto, 
		PR.Cd_Banco Cd_Banco, 
		PR.Cd_Agencia Cd_Agencia, 
		PR.Num_Cta_Cte Num_Cta_Cte, 
		PR.DC DC, 
		PR.Dt_Pgto_Rcto Dt_Pgto_Rcto, 
		PR.Num_Doc Num_Doc, 
		PR.Vlr_Doc Vlr_Doc, 
		P.Apelido Apelido, 
		PR.Dt_Vcto Dt_Vcto, 
		PR.Concil Concil, 
		PR.Cta_Cte_Cliente Cta_Cte_Cliente, 
		PR.Ck_Doctos Ck_Doctos,
		TT.nome_tp_tx Nome_Tp_Tx,
		Par_Moeda_hia Par_Moeda,
		CC.Titular Titular,
		PR.Forma_Pgto_Rcto Forma_Pgto_Rcto,
		CH.Num_Proc_hia Num_Proc,
		CH.Vlr_Ref_hia Vlr_Ref,
		CH.Vlr_Pgto_Rcto_hia Vlr_Pgto_Rcto,
		CH.DC_hia DC_DET, 
--		MAS.MAWB_MIA Master
		isnull(HOU.MAWB_HIA,MAS.MAWB_MIA) Master,
		dbo.fbusca_docs_po_modal(HOU.Num_proc_hia,'1') PO
	FROM 
		Pgto_Rcto PR
		join Cta_Cte CC on PR.Num_Cta_Cte = CC.Num_Cta_Cte
		left outer join caixa_hou_imp_aer CH on PR.Num_Lcto = CH.Num_Lcto
		left outer join cta_cte_hou_imp_aer CCT on CH.Num_proc_hia = CCT.Num_proc_hia and CH.cd_tp_tx = CCT.cd_tp_tx and CH.DC_hia = CCT.DC_hia 
		left outer join house_imp_aer HOU on CH.Num_proc_hia = HOU.Num_proc_hia
		left outer join master_imp_aer MAS on HOU.Num_proc_mia = MAS.Num_proc_mia		
		left outer join  tipo_taxa TT on CH.Cd_Tp_Tx = TT.Cd_Tp_Tx
		left outer join  Pessoa P on CCT.Cd_cred_dev_hia = P.Cd_Pes
	where 
		PR.Num_Lcto = @Num_Lcto

Union

	SELECT  
		PR.Num_Lcto	Num_Lcto, 
		PR.Cd_Banco Cd_Banco, 
		PR.Cd_Agencia Cd_Agencia, 
		PR.Num_Cta_Cte Num_Cta_Cte, 
		PR.DC DC, 
		PR.Dt_Pgto_Rcto Dt_Pgto_Rcto, 
		PR.Num_Doc Num_Doc, 
		PR.Vlr_Doc Vlr_Doc, 
		P.Apelido Apelido, 
		PR.Dt_Vcto Dt_Vcto, 
		PR.Concil Concil, 
		PR.Cta_Cte_Cliente Cta_Cte_Cliente, 
		PR.Ck_Doctos Ck_Doctos,
		TT.nome_tp_tx Nome_Tp_Tx,
		Par_Moeda_mem Par_Moeda,
		CC.Titular Titular,
		PR.Forma_Pgto_Rcto Forma_Pgto_Rcto,
		CH.Num_Proc_mem Num_Proc,
		CH.Vlr_Ref_mem Vlr_Ref,
		CH.Vlr_Pgto_Rcto_mem Vlr_Pgto_Rcto,
		CH.DC_mem DC_DET, 
		MAS.MAWB_MEM Master,
		null PO
	FROM 
		Pgto_Rcto PR
		join Cta_Cte CC on PR.Num_Cta_Cte = CC.Num_Cta_Cte
		left outer join caixa_mas_exp_mar CH on PR.Num_Lcto = CH.Num_Lcto
		left outer join cta_cte_mas_exp_mar CCT on CH.Num_proc_mem = CCT.Num_proc_mem and CH.cd_tp_tx = CCT.cd_tp_tx and CH.DC_mem = CCT.DC_mem 
		left outer join master_exp_mar MAS on CCT.Num_proc_mem = MAS.Num_proc_mem		
		left outer join  tipo_taxa TT on CH.Cd_Tp_Tx = TT.Cd_Tp_Tx
		left outer join  Pessoa P on CCT.Cd_cred_dev_mem = P.Cd_Pes
	where 
		PR.Num_Lcto = @Num_Lcto

Union

	SELECT
		PR.Num_Lcto	Num_Lcto, 
		PR.Cd_Banco Cd_Banco, 
		PR.Cd_Agencia Cd_Agencia, 
		PR.Num_Cta_Cte Num_Cta_Cte, 
		PR.DC DC, 
		PR.Dt_Pgto_Rcto Dt_Pgto_Rcto, 
		PR.Num_Doc Num_Doc, 
		PR.Vlr_Doc Vlr_Doc, 
		P.Apelido Apelido, 
		PR.Dt_Vcto Dt_Vcto, 
		PR.Concil Concil, 
		PR.Cta_Cte_Cliente Cta_Cte_Cliente, 
		PR.Ck_Doctos Ck_Doctos,
		TT.nome_tp_tx Nome_Tp_Tx,
		Par_Moeda_mea Par_Moeda,
		CC.Titular Titular,
		PR.Forma_Pgto_Rcto Forma_Pgto_Rcto,
		CH.Num_Proc_mea Num_Proc,
		CH.Vlr_Ref_mea Vlr_Ref,
		CH.Vlr_Pgto_Rcto_mea Vlr_Pgto_Rcto,
		CH.DC_mea DC_DET,
		MAS.MAWB_MEA Master,
		null PO
	FROM 
		Pgto_Rcto PR
		join Cta_Cte CC on PR.Num_Cta_Cte = CC.Num_Cta_Cte
		left outer join caixa_mas_exp_aer CH on PR.Num_Lcto = CH.Num_Lcto
		left outer join cta_cte_mas_exp_aer CCT on CH.Num_proc_mea = CCT.Num_proc_mea and CH.cd_tp_tx = CCT.cd_tp_tx and CH.DC_mea = CCT.DC_mea 
		left outer join master_exp_aer MAS on CCT.Num_proc_mea = MAS.Num_proc_mea
		left outer join  tipo_taxa TT on CH.Cd_Tp_Tx = TT.Cd_Tp_Tx
		left outer join  Pessoa P on CCT.Cd_cred_dev_mea = P.Cd_Pes
	where 
		PR.Num_Lcto = @Num_Lcto

Union

	SELECT
		PR.Num_Lcto	Num_Lcto, 
		PR.Cd_Banco Cd_Banco, 
		PR.Cd_Agencia Cd_Agencia, 
		PR.Num_Cta_Cte Num_Cta_Cte, 
		PR.DC DC, 
		PR.Dt_Pgto_Rcto Dt_Pgto_Rcto, 
		PR.Num_Doc Num_Doc, 
		PR.Vlr_Doc Vlr_Doc, 
		P.Apelido Apelido, 
		PR.Dt_Vcto Dt_Vcto, 
		PR.Concil Concil, 
		PR.Cta_Cte_Cliente Cta_Cte_Cliente, 
		PR.Ck_Doctos Ck_Doctos,
		TT.nome_tp_tx Nome_Tp_Tx,
		Par_Moeda_mim Par_Moeda,
		CC.Titular Titular,
		PR.Forma_Pgto_Rcto Forma_Pgto_Rcto,
		CH.Num_Proc_mim Num_Proc,
		CH.Vlr_Ref_mim Vlr_Ref,
		CH.Vlr_Pgto_Rcto_mim Vlr_Pgto_Rcto,
		CH.DC_mim DC_DET,
		MAS.MAWB_MIM Master,
		null PO
	FROM 
		Pgto_Rcto PR
		join Cta_Cte CC on PR.Num_Cta_Cte = CC.Num_Cta_Cte
		left outer join caixa_mas_imp_mar CH on PR.Num_Lcto = CH.Num_Lcto
		left outer join cta_cte_mas_imp_mar CCT on CH.Num_proc_mim = CCT.Num_proc_mim and CH.cd_tp_tx = CCT.cd_tp_tx and CH.DC_mim = CCT.DC_mim 
		left outer join master_imp_mar MAS on CCT.Num_proc_mim = MAS.Num_proc_mim
		left outer join  tipo_taxa TT on CH.Cd_Tp_Tx = TT.Cd_Tp_Tx
		left outer join  Pessoa P on CCT.Cd_cred_dev_mim = P.Cd_Pes
	where 
		PR.Num_Lcto = @Num_Lcto

Union

	SELECT
		PR.Num_Lcto	Num_Lcto,
		PR.Cd_Banco Cd_Banco, 
		PR.Cd_Agencia Cd_Agencia, 
		PR.Num_Cta_Cte Num_Cta_Cte, 
		PR.DC DC, 
		PR.Dt_Pgto_Rcto Dt_Pgto_Rcto, 
		PR.Num_Doc Num_Doc, 
		PR.Vlr_Doc Vlr_Doc, 
		P.Apelido Apelido, 
		PR.Dt_Vcto Dt_Vcto, 
		PR.Concil Concil, 
		PR.Cta_Cte_Cliente Cta_Cte_Cliente, 
		PR.Ck_Doctos Ck_Doctos,
		TT.nome_tp_tx Nome_Tp_Tx,
		Par_Moeda_mia Par_Moeda,
		CC.Titular Titular,
		PR.Forma_Pgto_Rcto Forma_Pgto_Rcto,
		CH.Num_Proc_mia Num_Proc,
		CH.Vlr_Ref_mia Vlr_Ref,
		CH.Vlr_Pgto_Rcto_mia Vlr_Pgto_Rcto,
		CH.DC_mia DC_DET,
		MAS.MAWB_MIA Master,
		null PO
	FROM 
		Pgto_Rcto PR
		join Cta_Cte CC on PR.Num_Cta_Cte = CC.Num_Cta_Cte
		left outer join caixa_mas_imp_aer CH on PR.Num_Lcto = CH.Num_Lcto
		left outer join cta_cte_mas_imp_aer CCT on CH.Num_proc_mia = CCT.Num_proc_mia and CH.cd_tp_tx = CCT.cd_tp_tx and CH.DC_mia = CCT.DC_mia 
		left outer join master_imp_aer MAS on CCT.Num_proc_mia = MAS.Num_proc_mia
		left outer join  tipo_taxa TT on CH.Cd_Tp_Tx = TT.Cd_Tp_Tx
		left outer join  Pessoa P on CCT.Cd_cred_dev_mia = P.Cd_Pes
	where 
		PR.Num_Lcto = @Num_Lcto


order by Num_Proc


GO
