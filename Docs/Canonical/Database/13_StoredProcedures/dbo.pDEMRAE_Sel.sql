SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pDEMRAE_Sel  
(
@Remessa	VarChar(16),
@StrMachine	VarChar(30)
)
AS
	Declare @Bco_Rem		VarChar(10) 
	Declare @Praca			VarChar(10) 
	Declare @Cd_Tp_Moeda_F_RA	Varchar(3) 
	Declare @Cd_Moeda_Nac	VarChar(3) 
	Declare @Tot_Fecto		Decimal(18,2) 
	Declare @Vlr_Ded		Decimal(18,2) 
	Declare @Tx_Dol		Float 
	Declare @Tx_Conv		Float 
	Declare CurRemessa Cursor For 
		Select 
			Bco.Cod_Banco_Rem as Cd_Banco, Rem.Cod_Praca_RA, Rem.Cd_Tp_Moeda_F_RA, 
			TM.Cod_Nac_Moeda, Rem.Vlr_Tot_Fchto_RA, Tx_Dol_RA, Tx_Conv_RA
		From 	
			Remessa_Aer as Rem Join Banco as Bco on Bco.Cd_Banco = Rem.Cd_Banco Join Tipo_Moeda as TM on TM.Cd_Tp_Moeda = Rem.Cd_Tp_Moeda_F_RA
		Where 
			Num_Ref_RA = @Remessa 

	Open CurRemessa 
	Fetch Next From CurRemessa into  @Bco_Rem, @Praca, @Cd_Tp_Moeda_F_RA, @Cd_Moeda_Nac, @Tot_Fecto, @Tx_Dol, @Tx_Conv

	If @@Fetch_Status <> 0 
		Return -1 

	Set @Vlr_Ded = IsNull((Select Sum(Cte.Vlr_Org_HIA) * @Tx_Dol From Cta_Cte_hou_Imp_Aer as Cte Join Caixa_Hou_Imp_Aer as Cxa on Cxa.Num_proc_HIA = Cte.Num_Proc_HIA and Cxa.DC_HIA = Cte.DC_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HIA = 'S')) and Cxa.Num_Rcb_HIA = @Remessa and Cte.Cd_Tp_Moeda = 'USD'  and Cte.DC_HIA = 'C'),0) - IsNull((Select Sum(Cte.Vlr_Org_HIA) * @Tx_Dol From Cta_Cte_hou_Imp_Aer as Cte Join Caixa_Hou_Imp_Aer as Cxa on Cxa.Num_proc_HIA = Cte.Num_Proc_HIA and Cxa.DC_HIA = Cte.DC_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HIA = 'S')) and Cxa.Num_Rcb_HIA = @Remessa and Cte.Cd_Tp_Moeda = 'USD'  and  Cte.DC_HIA = 'D'),0)  + 
			IsNull((Select Sum(Cte.Vlr_Org_HIA) * @Tx_Conv From Cta_Cte_hou_Imp_Aer as Cte Join Caixa_Hou_Imp_Aer as Cxa on Cxa.Num_proc_HIA = Cte.Num_Proc_HIA and Cxa.DC_HIA = Cte.DC_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HIA = 'S')) and Cxa.Num_Rcb_HIA = @Remessa and Cte.Cd_Tp_Moeda <> 'USD'  and Cte.DC_HIA = 'C'),0) - IsNull((Select Sum(Cte.Vlr_Org_HIA) * @Tx_Conv From Cta_Cte_hou_Imp_Aer as Cte Join Caixa_Hou_Imp_Aer as Cxa on Cxa.Num_proc_HIA = Cte.Num_Proc_HIA and Cxa.DC_HIA = Cte.DC_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HIA = 'S')) and Cxa.Num_Rcb_HIA = @Remessa and Cte.Cd_Tp_Moeda <> 'USD'  and Cte.DC_HIA = 'D'),0) 

	Set @Vlr_Ded = @Vlr_Ded + IsNull((Select Sum(Cte.Vlr_Org_HEA) * @Tx_Dol From Cta_Cte_hou_Exp_Aer as Cte Join Caixa_Hou_Exp_Aer as Cxa on Cxa.Num_proc_HEA = Cte.Num_Proc_HEA and Cxa.DC_HEA = Cte.DC_HEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HEA = 'S')) and Cxa.Num_Rcb_HEA = @Remessa and Cte.Cd_Tp_Moeda = 'USD'  and Cte.DC_HEA = 'C'),0) - IsNull((Select Sum(Cte.Vlr_Org_HEA) * @Tx_Dol From Cta_Cte_hou_Exp_Aer as Cte Join Caixa_Hou_Exp_Aer as Cxa on Cxa.Num_proc_HEA = Cte.Num_Proc_HEA and Cxa.DC_HEA = Cte.DC_HEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HEA = 'S')) and Cxa.Num_Rcb_HEA = @Remessa and Cte.Cd_Tp_Moeda = 'USD'  and Cte.DC_HEA = 'D'),0)  + 
			IsNull((Select Sum(Cte.Vlr_Org_HEA) * @Tx_Conv From Cta_Cte_hou_Exp_Aer as Cte Join Caixa_Hou_Exp_Aer as Cxa on Cxa.Num_proc_HEA = Cte.Num_Proc_HEA and Cxa.DC_HEA = Cte.DC_HEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HEA = 'S')) and Cxa.Num_Rcb_HEA = @Remessa and Cte.Cd_Tp_Moeda <> 'USD'  and Cte.DC_HEA = 'C'),0) - IsNull((Select Sum(Cte.Vlr_Org_HEA) * @Tx_Conv From Cta_Cte_hou_Exp_Aer as Cte Join Caixa_Hou_Exp_Aer as Cxa on Cxa.Num_proc_HEA = Cte.Num_Proc_HEA and Cxa.DC_HEA = Cte.DC_HEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HEA = 'S')) and Cxa.Num_Rcb_HEA = @Remessa and Cte.Cd_Tp_Moeda <> 'USD'  and Cte.DC_HEA = 'D'),0) 

	Close CurRemessa
	Deallocate CurRemessa		

	Select @Remessa as Remessa, @Bco_Rem as Bco_Rem, @Praca as Praca, @Cd_Tp_Moeda_F_RA as Cd_Tp_Moeda_F_RA, @Cd_Moeda_Nac as Cd_Moeda_Nac, @Tot_Fecto as Tot_Fecto, @Tx_Dol as Tx_Dol, @Tx_Conv as Tx_Conv, @Vlr_Ded as Vlr_Ded

GO
