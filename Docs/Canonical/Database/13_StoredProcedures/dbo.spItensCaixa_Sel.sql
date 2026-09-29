SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE      Procedure [dbo].[spItensCaixa_Sel] 
		
	@Lcto	VarChar(16),
	@Data	VarChar(10)
AS

SELECT  Num_Proc_HEA NP,
	TT.Nome_Tp_Tx,
	DC_HEA DC,
	Num_Lcto,
	Vlr_Ref_HEA Valor,
	TP.Nome_Tp_Par,
	Par_Moeda_HEA ParMoeda,
	Vlr_Pgto_Rcto_HEA VlrPGTO,
	Dt_Pgto_Rcto_HEA DtPGTO,
	Num_Rcb_HEA NR

	FROM Caixa_Hou_Exp_Aer HEA
	
	Left Join Tipo_Taxa TT on HEA.cd_tp_tx = TT.cd_tp_tx
	Left Join Tipo_Paridade TP on HEA.cd_tp_par = TP.cd_Tp_par

	WHERE 
	Num_Lcto = @Lcto --AND Dt_Pgto_Rcto_HEA = @Data


UNION


SELECT  Num_Proc_HEM NP,
	TT.Nome_Tp_Tx,
	DC_HEM DC,
	Num_Lcto,
	Vlr_Ref_HEM Valor,
	TP.Nome_Tp_Par,
	Par_Moeda_HEM ParMoeda,
	Vlr_Pgto_Rcto_HEM VlrPGTO,
	Dt_Pgto_Rcto_HEM DtPGTO,
	Num_Rcb_HEM NR

	FROM Caixa_Hou_Exp_Mar HEM
	
	Left Join Tipo_Taxa TT on HEM.cd_tp_tx = TT.cd_tp_tx
	Left Join Tipo_Paridade TP on HEM.cd_tp_par = TP.cd_Tp_par

	WHERE 
	Num_Lcto = @Lcto --AND Dt_Pgto_Rcto_HEM = @Data


UNION


SELECT  Num_Proc_HIA NP,
	TT.Nome_Tp_Tx,
	DC_HIA DC,
	Num_Lcto,
	Vlr_Ref_HIA Valor,
	TP.Nome_Tp_Par,
	Par_Moeda_HIA ParMoeda,
	Vlr_Pgto_Rcto_HIA VlrPGTO,
	Dt_Pgto_Rcto_HIA DtPGTO,
	Num_Rcb_HIA NR


	FROM Caixa_Hou_Imp_Aer HIA
	
	Left Join Tipo_Taxa TT on HIA.cd_tp_tx = TT.cd_tp_tx
	Left Join Tipo_Paridade TP on HIA.cd_tp_par = TP.cd_Tp_par

	WHERE 
	Num_Lcto = @Lcto --AND Dt_Pgto_Rcto_HIA = @Data


UNION


SELECT  Num_Proc_HIM NP,
	TT.Nome_Tp_Tx,
	DC_HIM DC,
	Num_Lcto,
	Vlr_Ref_HIM Valor,
	TP.Nome_Tp_Par,
	Par_Moeda_HIM ParMoeda,
	Vlr_Pgto_Rcto_HIM VlrPGTO,
	Dt_Pgto_Rcto_HIM DtPGTO,
	Num_Rcb_HIM NR


	FROM Caixa_Hou_Imp_Mar HIM
	
	Left Join Tipo_Taxa TT on HIM.cd_tp_tx = TT.cd_tp_tx
	Left Join Tipo_Paridade TP on HIM.cd_tp_par = TP.cd_Tp_par

	WHERE 
	Num_Lcto = @Lcto --AND Dt_Pgto_Rcto_HIM = @Data


UNION

SELECT  Num_Proc_HIO NP,
	TT.Nome_Tp_Tx,
	DC_HIO DC,
	Num_Lcto,
	Vlr_Ref_HIO Valor,
	TP.Nome_Tp_Par,
	Par_Moeda_HIO ParMoeda,
	Vlr_Pgto_Rcto_HIO VlrPGTO,
	Dt_Pgto_Rcto_HIO DtPGTO,
	Num_Rcb_HIO NR


	FROM Caixa_Hou_Imp_out HIO
	
	Left Join Tipo_Taxa TT on HIO.cd_tp_tx = TT.cd_tp_tx
	Left Join Tipo_Paridade TP on HIO.cd_tp_par = TP.cd_Tp_par

	WHERE 
	Num_Lcto = @Lcto --AND Dt_Pgto_Rcto_HIO = @Data

Union

SELECT  Num_Proc_HEO NP,
	TT.Nome_Tp_Tx,
	DC_HEO DC,
	Num_Lcto,
	Vlr_Ref_HEO Valor,
	TP.Nome_Tp_Par,
	Par_Moeda_HEO ParMoeda,
	Vlr_Pgto_Rcto_HEO VlrPGTO,
	Dt_Pgto_Rcto_HEO DtPGTO,
	Num_Rcb_HEO NR


	FROM Caixa_Hou_Exp_out HEO
	
	Left Join Tipo_Taxa TT on HEO.cd_tp_tx = TT.cd_tp_tx
	Left Join Tipo_Paridade TP on HEO.cd_tp_par = TP.cd_Tp_par

	WHERE 
	Num_Lcto = @Lcto --AND Dt_Pgto_Rcto_HEO = @Data


UNION

SELECT  Num_Proc_MEA NP,
	TT.Nome_Tp_Tx,
	DC_MEA DC,
	Num_Lcto,
	Vlr_Ref_MEA Valor,
	TP.Nome_Tp_Par,
	Par_Moeda_MEA ParMoeda,
	Vlr_Pgto_Rcto_MEA VlrPGTO,
	Dt_Pgto_Rcto_MEA DtPGTO,
	Num_Rcb_MEA NR


	FROM Caixa_Mas_Exp_Aer MEA
	
	Left Join Tipo_Taxa TT on MEA.cd_tp_tx = TT.cd_tp_tx
	Left Join Tipo_Paridade TP on MEA.cd_tp_par = TP.cd_Tp_par

	WHERE
	Num_Lcto = @Lcto --AND Dt_Pgto_Rcto_MEA = @Data


UNION


SELECT  Num_Proc_MEM NP,
	TT.Nome_Tp_Tx,
	DC_MEM DC,
	Num_Lcto,
	Vlr_Ref_MEM Valor,
	TP.Nome_Tp_Par,
	Par_Moeda_MEM ParMoeda,
	Vlr_Pgto_Rcto_MEM VlrPGTO,
	Dt_Pgto_Rcto_MEM DtPGTO,
	Num_Rcb_MEM NR


	FROM Caixa_Mas_Exp_Mar MEM
	
	Left Join Tipo_Taxa TT on MEM.cd_tp_tx = TT.cd_tp_tx
	Left Join Tipo_Paridade TP on MEM.cd_tp_par = TP.cd_Tp_par

	WHERE
	Num_Lcto = @Lcto --AND Dt_Pgto_Rcto_MEM = @Data


UNION


SELECT  Num_Proc_MIA NP,
	TT.Nome_Tp_Tx,
	DC_MIA DC,
	Num_Lcto,
	Vlr_Ref_MIA Valor,
	TP.Nome_Tp_Par,
	Par_Moeda_MIA ParMoeda,
	Vlr_Pgto_Rcto_MIA VlrPGTO,
	Dt_Pgto_Rcto_MIA DtPGTO,
	Num_Rcb_MIA NR


	FROM Caixa_Mas_Imp_Aer MIA
	
	Left Join Tipo_Taxa TT on MIA.cd_tp_tx = TT.cd_tp_tx
	Left Join Tipo_Paridade TP on MIA.cd_tp_par = TP.cd_Tp_par

	WHERE 
	Num_Lcto = @Lcto --AND Dt_Pgto_Rcto_MIA = @Data


UNION


SELECT  Num_Proc_MIM NP,
	TT.Nome_Tp_Tx,
	DC_MIM DC,
	Num_Lcto,
	Vlr_Ref_MIM Valor,
	TP.Nome_Tp_Par,
	Par_Moeda_MIM ParMoeda,
	Vlr_Pgto_Rcto_MIM VlrPGTO,
	Dt_Pgto_Rcto_MIM DtPGTO,
	Num_Rcb_MIM NR


	FROM Caixa_Mas_Imp_Mar MIM
	
	Left Join Tipo_Taxa TT on MIM.cd_tp_tx = TT.cd_tp_tx
	Left Join Tipo_Paridade TP on MIM.cd_tp_par = TP.cd_Tp_par

	WHERE
	Num_Lcto = @Lcto --AND Dt_Pgto_Rcto_MIM = @Data
order by 1






GO
