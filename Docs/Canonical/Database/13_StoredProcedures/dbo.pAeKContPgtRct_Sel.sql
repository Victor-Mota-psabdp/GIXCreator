SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[pAeKContPgtRct_Sel] 
(
@PgtRct	as VarChar(12)
)
AS	
	Declare @PerFim VarChar(22) 

	Set @PerFim = (Select PkcMes From Param_AekContabil)
	Set @PerFim = (select dbo.fLastDayMonth(@PerFim))
	Select  
		Cte.Num_Proc_HIM Num_Proc, Cte.DC_HIM DC, TT.Cd_Tp_Tx, TT.Nome_Tp_Tx, Contab, Val_Con_Comp, Vlr_Pgto_Rcto_HIM Vlr_Pgto_Rcto, 
		BNF.Nota_Fiscal Num_NF, Vlr_Pgto_NF_HIM Vlr_Pgto_NF, Dt_Ins_HIM Dt_Ins, BNF.Emissao NF_Emissao, Pes.Nome_Raz_Soc
	From 
		Cta_Cte_Hou_Imp_Mar Cte 
		Join Caixa_Hou_Imp_Mar Cxa on Cxa.Num_Proc_HIM = Cte.Num_Proc_HIM and Cxa.DC_HIM = Cte.DC_HIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
		Left Join Base_Nota_Fiscal BNF on BNF.Nota_Fiscal = Cte.Num_NF_HIM and BNF.Ref_Acesso = Cte.Ref_Acesso_NF_HIM  and BNF.Emissao <= Convert(Datetime, @PerFim ,105)
		Join Pessoa Pes on Pes.Cd_Pes = Cte.Cd_Cred_Dev_HIM
	Where 
		(Num_Rcb_HIM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and 
		Cte.Cd_tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)

	Union 

	Select  
		Cte.Num_Proc_HEM Num_Proc, Cte.DC_HEM DC, TT.Cd_Tp_Tx, TT.Nome_Tp_Tx, Contab, Val_Con_Comp, Vlr_Pgto_Rcto_HEM Vlr_Pgto_Rcto, 
		BNF.Nota_Fiscal Num_NF, Vlr_Pgto_NF_HEM Vlr_Pgto_NF, Dt_Ins_HEM Dt_Ins, BNF.Emissao NF_Emissao, Pes.Nome_Raz_Soc
	From 
		Cta_Cte_Hou_Exp_Mar Cte 
		Join Caixa_Hou_Exp_Mar Cxa on Cxa.Num_Proc_HEM = Cte.Num_Proc_HEM and Cxa.DC_HEM = Cte.DC_HEM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
		Left Join Base_Nota_Fiscal BNF on BNF.Nota_Fiscal = Cte.Num_NF_HEM and BNF.Ref_Acesso = Cte.Ref_Acesso_NF_HEM and BNF.Emissao <= Convert(Datetime, @PerFim ,105)
		Join Pessoa Pes on Pes.Cd_Pes = Cte.Cd_Cred_Dev_HEM
	Where 
		(Num_Rcb_HEM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and 
		Cte.Cd_tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)	

	Union 
	Select  
		Cte.Num_Proc_HIO Num_Proc, Cte.DC_HIO DC, TT.Cd_Tp_Tx, TT.Nome_Tp_Tx, Contab, Val_Con_Comp, Vlr_Pgto_Rcto_HIO Vlr_Pgto_Rcto, 
		BNF.Nota_Fiscal Num_NF, Vlr_Pgto_NF_HIO Vlr_Pgto_NF, Dt_Ins_HIO Dt_Ins, BNF.Emissao NF_Emissao, Pes.Nome_Raz_Soc
	From 
		Cta_Cte_Hou_Imp_Out Cte 
		Join Caixa_Hou_Imp_Out Cxa on Cxa.Num_Proc_HIO = Cte.Num_Proc_HIO and Cxa.DC_HIO = Cte.DC_HIO and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
		Left Join Base_Nota_Fiscal BNF on BNF.Nota_Fiscal = Cte.Num_NF_HIO and BNF.Ref_Acesso = Cte.Ref_Acesso_NF_HIO  and BNF.Emissao <= Convert(Datetime, @PerFim ,105)
		Join Pessoa Pes on Pes.Cd_Pes = Cte.Cd_Cred_Dev_HIO
	Where 
		(Num_Rcb_HIO = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and 
		Cte.Cd_tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)

	Union 

	Select  
		Cte.Num_Proc_HEO Num_Proc, Cte.DC_HEO DC, TT.Cd_Tp_Tx, TT.Nome_Tp_Tx, Contab, Val_Con_Comp, Vlr_Pgto_Rcto_HEO Vlr_Pgto_Rcto, 
		BNF.Nota_Fiscal Num_NF, Vlr_Pgto_NF_HEO Vlr_Pgto_NF, Dt_Ins_HEO Dt_Ins, BNF.Emissao NF_Emissao, Pes.Nome_Raz_Soc
	From 
		Cta_Cte_Hou_Exp_Out Cte 
		Join Caixa_Hou_Exp_Out Cxa on Cxa.Num_Proc_HEO = Cte.Num_Proc_HEO and Cxa.DC_HEO = Cte.DC_HEO and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
		Left Join Base_Nota_Fiscal BNF on BNF.Nota_Fiscal = Cte.Num_NF_HEO and BNF.Ref_Acesso = Cte.Ref_Acesso_NF_HEO and BNF.Emissao <= Convert(Datetime, @PerFim ,105)
		Join Pessoa Pes on Pes.Cd_Pes = Cte.Cd_Cred_Dev_HEO
	Where 
		(Num_Rcb_HEO = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and 
		Cte.Cd_tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)	

	Union 


	Select  
		Cte.Num_Proc_HIA Num_Proc, Cte.DC_HIA DC, TT.Cd_Tp_Tx, TT.Nome_Tp_Tx, Contab, Val_Con_Comp, Vlr_Pgto_Rcto_HIA Vlr_Pgto_Rcto, 
		BNF.Nota_Fiscal Num_NF, Vlr_Pgto_NF_HIA Vlr_Pgto_NF, Dt_Ins_HIA Dt_Ins, BNF.Emissao NF_Emissao, Pes.Nome_Raz_Soc
	From 
		Cta_Cte_Hou_Imp_Aer Cte 
		Join Caixa_Hou_Imp_Aer Cxa on Cxa.Num_Proc_HIA = Cte.Num_Proc_HIA and Cxa.DC_HIA = Cte.DC_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
		Left Join Base_Nota_Fiscal BNF on BNF.Nota_Fiscal = Cte.Num_NF_HIA and BNF.Ref_Acesso = Cte.Ref_Acesso_NF_HIA and BNF.Emissao <= Convert(Datetime, @PerFim ,105)
		Join Pessoa Pes on Pes.Cd_Pes = Cte.Cd_Cred_Dev_HIA
	Where 
		(Num_Rcb_HIA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and 
		Cte.Cd_tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)

	Union 


	Select  
		Cte.Num_Proc_HEA Num_Proc, Cte.DC_HEA DC, TT.Cd_Tp_Tx, TT.Nome_Tp_Tx, Contab, Val_Con_Comp, Vlr_Pgto_Rcto_HEA Vlr_Pgto_Rcto, 
		BNF.Nota_Fiscal Num_NF, Vlr_Pgto_NF_HEA Vlr_Pgto_NF, Dt_Ins_HEA Dt_Ins, BNF.Emissao NF_Emissao, Pes.Nome_Raz_Soc
	From 
		Cta_Cte_Hou_Exp_Aer Cte 
		Join Caixa_Hou_Exp_Aer Cxa on Cxa.Num_Proc_HEA = Cte.Num_Proc_HEA and Cxa.DC_HEA = Cte.DC_HEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
		Left Join Base_Nota_Fiscal BNF on BNF.Nota_Fiscal = Cte.Num_NF_HEA and BNF.Ref_Acesso = Cte.Ref_Acesso_NF_HEA and BNF.Emissao <= Convert(Datetime, @PerFim ,105)
		Join Pessoa Pes on Pes.Cd_Pes = Cte.Cd_Cred_Dev_HEA
	Where 
		(Num_Rcb_HEA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and 
		Cte.Cd_tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)

	Union

	Select  
		Cte.Num_Proc_MIM Num_Proc, Cte.DC_MIM DC, TT.Cd_Tp_Tx, TT.Nome_Tp_Tx, Contab, Val_Con_Comp, Vlr_Pgto_Rcto_MIM Vlr_Pgto_Rcto, 
		BNF.Nota_Fiscal Num_NF, Vlr_Pgto_NF_MIM Vlr_Pgto_NF, Dt_Ins_MIM Dt_Ins, BNF.Emissao NF_Emissao, Pes.Nome_Raz_Soc
	From 
		Cta_Cte_Mas_Imp_Mar Cte 
		Join Caixa_Mas_Imp_Mar Cxa on Cxa.Num_Proc_MIM = Cte.Num_Proc_MIM and Cxa.DC_MIM = Cte.DC_MIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
		Left Join Base_Nota_Fiscal BNF on BNF.Nota_Fiscal = Cte.Num_NF_MIM and BNF.Ref_Acesso = Cte.Ref_Acesso_NF_MIM and BNF.Emissao <= Convert(Datetime, @PerFim ,105)
		Join Pessoa Pes on Pes.Cd_Pes = Cte.Cd_Cred_Dev_MIM
	Where 
		(Num_Rcb_MIM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and 
		Cte.Cd_tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)

	Union 

	Select  
		Cte.Num_Proc_MEM Num_Proc, Cte.DC_MEM DC, TT.Cd_Tp_Tx, TT.Nome_Tp_Tx, Contab, Val_Con_Comp, Vlr_Pgto_Rcto_MEM Vlr_Pgto_Rcto, 
		BNF.Nota_Fiscal Num_NF, Vlr_Pgto_NF_MEM Vlr_Pgto_NF, Dt_Ins_MEM Dt_Ins, BNF.Emissao NF_Emissao, Pes.Nome_Raz_Soc
	From 
		Cta_Cte_Mas_Exp_Mar Cte 
		Join Caixa_Mas_Exp_Mar Cxa on Cxa.Num_Proc_MEM = Cte.Num_Proc_MEM and Cxa.DC_MEM = Cte.DC_MEM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
		Left Join Base_Nota_Fiscal BNF on BNF.Nota_Fiscal = Cte.Num_NF_MEM and BNF.Ref_Acesso = Cte.Ref_Acesso_NF_MEM and BNF.Emissao <= Convert(Datetime, @PerFim ,105)
		Join Pessoa Pes on Pes.Cd_Pes = Cte.Cd_Cred_Dev_MEM
	Where 
		(Num_Rcb_MEM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and 
		Cte.Cd_tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)

	Union 

	Select  
		Cte.Num_Proc_MIA Num_Proc, Cte.DC_MIA DC, TT.Cd_Tp_Tx, TT.Nome_Tp_Tx, Contab, Val_Con_Comp, Vlr_Pgto_Rcto_MIA Vlr_Pgto_Rcto, 
		BNF.Nota_Fiscal Num_NF, Vlr_Pgto_NF_MIA Vlr_Pgto_NF, Dt_Ins_MIA Dt_Ins, BNF.Emissao NF_Emissao, Pes.Nome_Raz_Soc
	From 
		Cta_Cte_Mas_Imp_Aer Cte 
		Join Caixa_Mas_Imp_Aer Cxa on Cxa.Num_Proc_MIA = Cte.Num_Proc_MIA and Cxa.DC_MIA = Cte.DC_MIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
		Left Join Base_Nota_Fiscal BNF on BNF.Nota_Fiscal = Cte.Num_NF_MIA and BNF.Ref_Acesso = Cte.Ref_Acesso_NF_MIA and BNF.Emissao <= Convert(Datetime, @PerFim ,105)
		Join Pessoa Pes on Pes.Cd_Pes = Cte.Cd_Cred_Dev_MIA
	Where 
		(Num_Rcb_MIA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and 
		Cte.Cd_tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)

	Union 


	Select  
		Cte.Num_Proc_MEA Num_Proc, Cte.DC_MEA DC, TT.Cd_Tp_Tx, TT.Nome_Tp_Tx, Contab, Val_Con_Comp, Vlr_Pgto_Rcto_MEA Vlr_Pgto_Rcto, 
		BNF.Nota_Fiscal Num_NF, Vlr_Pgto_NF_MEA Vlr_Pgto_NF, Dt_Ins_MEA Dt_Ins, BNF.Emissao NF_Emissao, Pes.Nome_Raz_Soc
	From 
		Cta_Cte_Mas_Exp_Aer Cte 
		Join Caixa_Mas_Exp_Aer Cxa on Cxa.Num_Proc_MEA = Cte.Num_Proc_MEA and Cxa.DC_MEA = Cte.DC_MEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
		Join Tipo_Taxa TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
		Left Join Base_Nota_Fiscal BNF on BNF.Nota_Fiscal = Cte.Num_NF_MEA and BNF.Ref_Acesso = Cte.Ref_Acesso_NF_MEA and BNF.Emissao <= Convert(Datetime, @PerFim ,105)
		Join Pessoa Pes on Pes.Cd_Pes = Cte.Cd_Cred_Dev_MEA
	Where 
		(Num_Rcb_MEA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and 
		Cte.Cd_tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)

GO
