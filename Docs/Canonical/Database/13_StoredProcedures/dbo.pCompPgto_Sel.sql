SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCompPgto_Sel    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE pCompPgto_Sel 
(
@Lcto		VarChar(14)
)
 AS
	(Select  
		Cxa.Num_Lcto, Cta.Num_Proc_MIM as Referencia, MIM.MAWB_MIM as BL,  'Master' as Tipo, Tx.Nome_Tp_Tx as Taxa, 
		Ps.Apelido as Credor, Cta.DC_MIM as DC, Cxa.Vlr_Pgto_Rcto_MIM as Valor
	From 
		cta_cte_mas_imp_mar as Cta Join Caixa_mas_imp_mar as Cxa on (Cta.Num_Proc_MIM = Cxa.Num_Proc_MIM and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_MIM = Cxa.DC_MIM)
		Join Master_imp_mar as MIM on Cta.Num_Proc_mim = MIM.Num_Proc_mim 
		Join Tipo_Taxa as Tx on Cta.Cd_Tp_Tx = Tx.Cd_Tp_Tx
		Join Pessoa as PS on Cta.Cd_Cred_Dev_MIM = PS.Cd_Pes 
	Where 
		Cxa.Num_Lcto = @Lcto
	Union 
	Select  
		Cxa.Num_Lcto, Cta.Num_Proc_HIM as Referencia, HIM.HAWB_HIM as BL, 'House' as Tipo, Tx.Nome_Tp_Tx as Taxa, 
		Ps.Apelido as Credor, Cta.DC_HIM as DC, Cxa.Vlr_Pgto_Rcto_HIM as Valor
	From 
		cta_cte_hou_imp_mar as Cta Join Caixa_hou_imp_mar as Cxa on (Cta.Num_Proc_HIM = Cxa.Num_Proc_HIM and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HIM = Cxa.DC_HIM)
		Join House_Imp_mar as HIM on Cta.Num_Proc_HIM = HIM.Num_Proc_HIM
		Join Tipo_Taxa as Tx on Cta.Cd_Tp_Tx = Tx.Cd_Tp_Tx
		Join Pessoa as PS on Cta.Cd_Cred_Dev_HIM = PS.Cd_Pes 
	Where 
		Cxa.Num_Lcto = @Lcto
	Union 
	Select  
		Cxa.Num_Lcto, Cta.Num_Proc_MEM as Referencia, MEM.MAWB_MEM as BL,  'Master' as Tipo, Tx.Nome_Tp_Tx as Taxa, 
		Ps.Apelido as Credor, Cta.DC_MEM as DC, Cxa.Vlr_Pgto_Rcto_MEM as Valor
	From 
		cta_cte_mas_exp_mar as Cta Join Caixa_mas_exp_mar as Cxa on (Cta.Num_Proc_MEM = Cxa.Num_Proc_MEM and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_MEM = Cxa.DC_MEM)
		Join Master_Exp_mar as MEM on Cta.Num_Proc_MEM = MEM.Num_Proc_MEM
		Join Tipo_Taxa as Tx on Cta.Cd_Tp_Tx = Tx.Cd_Tp_Tx
		Join Pessoa as PS on Cta.Cd_Cred_Dev_MEM = PS.Cd_Pes 
	Where 
		Cxa.Num_Lcto = @Lcto
	Union 
	Select  
		Cxa.Num_Lcto, Cta.Num_Proc_HEM as Referencia, HEM.HAWB_HEM as BL, 'House' as Tipo, Tx.Nome_Tp_Tx as Taxa, 
		Ps.Apelido as Credor, Cta.DC_HEM as DC, Cxa.Vlr_Pgto_Rcto_HEM as Valor
	From 
		cta_cte_hou_exp_mar as Cta Join Caixa_hou_exp_mar as Cxa on (Cta.Num_Proc_HEM = Cxa.Num_Proc_HEM and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HEM = Cxa.DC_HEM)
		Join House_Exp_Mar as HEM on Cta.Num_Proc_HEM = HEM.Num_Proc_HEM
		Join Tipo_Taxa as Tx on Cta.Cd_Tp_Tx = Tx.Cd_Tp_Tx
		Join Pessoa as PS on Cta.Cd_Cred_Dev_HEM = PS.Cd_Pes 
	Where 
		Cxa.Num_Lcto = @Lcto
	Union 
	Select  
		Cxa.Num_Lcto, Cta.Num_Proc_MIA as Referencia, MIA.MAWB_MIA as BL,  'Master' as Tipo, Tx.Nome_Tp_Tx as Taxa, 
		Ps.Apelido as Credor, Cta.DC_MIA as DC, Cxa.Vlr_Pgto_Rcto_MIA as Valor
	From 
		cta_cte_mas_imp_aer as Cta Join Caixa_mas_imp_aer as Cxa on (Cta.Num_Proc_MIA = Cxa.Num_Proc_MIA and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_MIA = Cxa.DC_MIA)
		Join Master_imp_Aer as MIA on Cta.Num_Proc_MIA = MIA.Num_Proc_MIA
		Join Tipo_Taxa as Tx on Cta.Cd_Tp_Tx = Tx.Cd_Tp_Tx
		Join Pessoa as PS on Cta.Cd_Cred_Dev_MIA = PS.Cd_Pes 
	Where 
		Cxa.Num_Lcto = @Lcto
	Union 
	Select  
		Cxa.Num_Lcto, Cta.Num_Proc_HIA as Referencia, HIA.HAWB_HIA as BL, 'House' as Tipo, Tx.Nome_Tp_Tx as Taxa, 
		Ps.Apelido as Credor, Cta.DC_HIA as DC, Cxa.Vlr_Pgto_Rcto_HIA as Valor
	From 
		cta_cte_hou_imp_aer as Cta Join Caixa_hou_imp_aer as Cxa on (Cta.Num_Proc_HIA = Cxa.Num_Proc_HIA and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HIA = Cxa.DC_HIA)
		Join House_Imp_Aer as HIA on Cta.Num_Proc_HIA = HIA.Num_Proc_HIA
		Join Tipo_Taxa as Tx on Cta.Cd_Tp_Tx = Tx.Cd_Tp_Tx
		Join Pessoa as PS on Cta.Cd_Cred_Dev_HIA = PS.Cd_Pes 
	Where 
		Cxa.Num_Lcto = @Lcto
	Union 
---
	Select  
		Cxa.Num_Lcto, Cta.Num_Proc_MEA as Referencia, MEA.MAWB_MEA as BL,  'Master' as Tipo, Tx.Nome_Tp_Tx as Taxa, 
		Ps.Apelido as Credor, Cta.DC_MEA as DC, Cxa.Vlr_Pgto_Rcto_MEA as Valor
	From 
		cta_cte_mas_exp_aer as Cta Join Caixa_mas_exp_aer as Cxa on (Cta.Num_Proc_MEA = Cxa.Num_Proc_MEA and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_MEA = Cxa.DC_MEA)
		Join Master_Exp_Aer as MEA on Cta.Num_Proc_MEA = MEA.Num_Proc_MEA
		Join Tipo_Taxa as Tx on Cta.Cd_Tp_Tx = Tx.Cd_Tp_Tx
		Join Pessoa as PS on Cta.Cd_Cred_Dev_MEA = PS.Cd_Pes 
	Where 
		Cxa.Num_Lcto = @Lcto
	Union 
	Select  
		Cxa.Num_Lcto, Cta.Num_Proc_HEA as Referencia, HEA.HAWB_HEA as BL, 'House' as Tipo, Tx.Nome_Tp_Tx as Taxa, 
		Ps.Apelido as Credor, Cta.DC_HEA as DC, Cxa.Vlr_Pgto_Rcto_HEA as Valor
	From 
		cta_cte_hou_exp_aer as Cta Join Caixa_hou_exp_aer as Cxa on (Cta.Num_Proc_HEA = Cxa.Num_Proc_HEA and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HEA = Cxa.DC_HEA)
		Join House_Exp_Aer as HEA on Cta.Num_Proc_HEA = HEA.Num_Proc_HEA
		Join Tipo_Taxa as Tx on Cta.Cd_Tp_Tx = Tx.Cd_Tp_Tx
		Join Pessoa as PS on Cta.Cd_Cred_Dev_HEA = PS.Cd_Pes 
	Where 
		Cxa.Num_Lcto = @Lcto

	Union 
	Select  
		Cxa.Num_Lcto, Cta.Num_Proc_HEO as Referencia, HEO.HAWB_HEO as BL, 'House' as Tipo, Tx.Nome_Tp_Tx as Taxa, 
		Ps.Apelido as Credor, Cta.DC_HEO as DC, Cxa.Vlr_Pgto_Rcto_HEO as Valor
	From 
		cta_cte_hou_exp_out as Cta Join Caixa_hou_exp_Out as Cxa on (Cta.Num_Proc_HEO = Cxa.Num_Proc_HEO and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HEO = Cxa.DC_HEO)
		Join House_Exp_Out as HEO on Cta.Num_Proc_HEO = HEO.Num_Proc_HEO
		Join Tipo_Taxa as Tx on Cta.Cd_Tp_Tx = Tx.Cd_Tp_Tx
		Join Pessoa as PS on Cta.Cd_Cred_Dev_HEO = PS.Cd_Pes 
	Where 
		Cxa.Num_Lcto = @Lcto
	Union 
	Select  
		Cxa.Num_Lcto, Cta.Num_Proc_HIO as Referencia, HIO.HAWB_HIO as BL, 'House' as Tipo, Tx.Nome_Tp_Tx as Taxa, 
		Ps.Apelido as Credor, Cta.DC_HIO as DC, Cxa.Vlr_Pgto_Rcto_HIO as Valor
	From 
		cta_cte_hou_imp_out as Cta Join Caixa_hou_imp_out as Cxa on (Cta.Num_Proc_HIO = Cxa.Num_Proc_HIO and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HIO = Cxa.DC_HIO)
		Join House_Imp_Out as HIO on Cta.Num_Proc_HIO = HIO.Num_Proc_HIO
		Join Tipo_Taxa as Tx on Cta.Cd_Tp_Tx = Tx.Cd_Tp_Tx
		Join Pessoa as PS on Cta.Cd_Cred_Dev_HIO = PS.Cd_Pes 
	Where 
		Cxa.Num_Lcto = @Lcto)
GO
