SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






create         Procedure [dbo].[spComprovCTB_Rel] 
		
	@Lcto	VarChar(16)

AS

SELECT  HEA.Num_Proc_HEA NP,
	HEA.DC_HEA DC,
	Num_Lcto,
	Par_Moeda_HEA ParMoeda,
	Vlr_Pgto_Rcto_HEA VlrPGTO,
	Dt_Pgto_Rcto_HEA DtPGTO,
	Num_Rcb_HEA NR,
	PP.Apelido,
	PP.Num_CPF_CNPJ

	FROM Caixa_Hou_Exp_Aer HEA

	left join Cta_Cte_Hou_Exp_Aer CC on HEA.Num_Proc_HEA = CC.Num_Proc_HEA and HEA.cd_tp_tx = CC.cd_tp_tx and HEA.dc_hea = CC.DC_hea
	left Join Pessoa PP 		 on CC.cd_cred_dev_HEA = PP.cd_pes

	WHERE 
	Num_Lcto = @Lcto

UNION ALL


SELECT  HEM.Num_Proc_HEM NP,
	HEM.DC_HEM DC,
	Num_Lcto,
	Par_Moeda_HEM ParMoeda,
	Vlr_Pgto_Rcto_HEM VlrPGTO,
	Dt_Pgto_Rcto_HEM DtPGTO,
	Num_Rcb_HEM NR,
	PP.Apelido,
	PP.Num_CPF_CNPJ

	FROM Caixa_Hou_Exp_Mar HEM

	left join Cta_Cte_Hou_Exp_Mar CC on HEM.Num_Proc_HEM = CC.Num_Proc_HEM and HEM.cd_tp_tx = CC.cd_tp_tx and HEM.dc_hem = CC.DC_hem
	left Join Pessoa PP 		 on CC.cd_cred_dev_HEM = PP.cd_pes

	WHERE 
	Num_Lcto = @Lcto


UNION ALL


SELECT  HIA.Num_Proc_HIA NP,
	HIA.DC_HIA DC,
	Num_Lcto,
	Par_Moeda_HIA ParMoeda,
	Vlr_Pgto_Rcto_HIA VlrPGTO,
	Dt_Pgto_Rcto_HIA DtPGTO,
	Num_Rcb_HIA NR,
	PP.Apelido,
	PP.Num_CPF_CNPJ

	FROM Caixa_Hou_Imp_Aer HIA
	
	left join Cta_Cte_Hou_Imp_Aer CC on HIA.Num_Proc_HIA = CC.Num_Proc_HIA and HIA.cd_tp_tx = CC.cd_tp_tx and HIA.dc_hia = CC.DC_hia
	left Join Pessoa PP 		 on CC.cd_cred_dev_HIA = PP.cd_pes

	WHERE 
	Num_Lcto = @Lcto


UNION ALL


SELECT  HIM.Num_Proc_HIM NP,
	HIM.DC_HIM DC,
	Num_Lcto,
	Par_Moeda_HIM ParMoeda,
	Vlr_Pgto_Rcto_HIM VlrPGTO,
	Dt_Pgto_Rcto_HIM DtPGTO,
	Num_Rcb_HIM NR,
	PP.Apelido,
	PP.Num_CPF_CNPJ

	FROM Caixa_Hou_Imp_Mar HIM
	
	left join Cta_Cte_Hou_Imp_Mar CC on HIM.Num_Proc_HIM = CC.Num_Proc_HIM and HIM.cd_tp_tx = CC.cd_tp_tx and HIM.dc_him = CC.DC_him
	left Join Pessoa PP 		 on CC.cd_cred_dev_HIM = PP.cd_pes

	WHERE 
	Num_Lcto = @Lcto


UNION ALL


SELECT  MEA.Num_Proc_MEA NP,
	MEA.DC_MEA DC,
	Num_Lcto,
	Par_Moeda_MEA ParMoeda,
	Vlr_Pgto_Rcto_MEA VlrPGTO,
	Dt_Pgto_Rcto_MEA DtPGTO,
	Num_Rcb_MEA NR,
	PP.Apelido,
	PP.Num_CPF_CNPJ

	FROM Caixa_Mas_Exp_Aer MEA
	
	left join Cta_Cte_Mas_Exp_Aer CC on MEA.Num_Proc_MEA = CC.Num_Proc_MEA and MEA.cd_tp_tx = CC.cd_tp_tx and MEA.dc_Mea = CC.DC_Mea
	left Join Pessoa PP 		 on CC.cd_cred_dev_MEA = PP.cd_pes

	WHERE
	Num_Lcto = @Lcto


UNION ALL


SELECT  MEM.Num_Proc_MEM NP,
	MEM.DC_MEM DC,
	Num_Lcto,
	Par_Moeda_MEM ParMoeda,
	Vlr_Pgto_Rcto_MEM VlrPGTO,
	Dt_Pgto_Rcto_MEM DtPGTO,
	Num_Rcb_MEM NR,
	PP.Apelido,
	PP.Num_CPF_CNPJ

	FROM Caixa_Mas_Exp_Mar MEM
	
	left join Cta_Cte_Mas_Exp_Mar CC on MEM.Num_Proc_MEM = CC.Num_Proc_MEM and MEM.cd_tp_tx = CC.cd_tp_tx and MEM.dc_mem = CC.DC_mem
	left Join Pessoa PP 		 on CC.cd_cred_dev_MEM = PP.cd_pes

	WHERE
	Num_Lcto =  @Lcto


UNION ALL


SELECT  MIA.Num_Proc_MIA NP,
	MIA.DC_MIA DC,
	Num_Lcto,
	Par_Moeda_MIA ParMoeda,
	Vlr_Pgto_Rcto_MIA VlrPGTO,
	Dt_Pgto_Rcto_MIA DtPGTO,
	Num_Rcb_MIA NR,
	PP.Apelido,
	PP.Num_CPF_CNPJ

	FROM Caixa_Mas_Imp_Aer MIA
	
	left join Cta_Cte_Mas_Imp_Aer CC on MIA.Num_Proc_MIA = CC.Num_Proc_MIA and MIA.cd_tp_tx = CC.cd_tp_tx and MIA.dc_mia = CC.DC_mia
	left Join Pessoa PP 		 on CC.cd_cred_dev_MIA = PP.cd_pes

	WHERE 
	Num_Lcto = @Lcto


UNION ALL


SELECT  MIM.Num_Proc_MIM NP,
	MIM.DC_MIM DC,
	Num_Lcto,
	Par_Moeda_MIM ParMoeda,
	Vlr_Pgto_Rcto_MIM VlrPGTO,
	Dt_Pgto_Rcto_MIM DtPGTO,
	Num_Rcb_MIM NR,
	PP.Apelido,
	PP.Num_CPF_CNPJ

	FROM Caixa_Mas_Imp_Mar MIM
	
	left join Cta_Cte_Mas_Imp_Mar CC on MIM.Num_Proc_MIM = CC.Num_Proc_MIM and MIM.cd_tp_tx = CC.cd_tp_tx and MIM.dc_Mim = CC.DC_Mim
	left Join Pessoa PP 		 on CC.cd_cred_dev_MIM = PP.cd_pes

	WHERE
	Num_Lcto = @Lcto 





GO
