SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pDEMRAE_Item_Ins
(
@Remessa	VarChar(16) ,
@StrMachine	VarChar(30)
)
AS
	Declare @House		VarChar(20) 
	Declare @Cd_Tp_moeda	VarChar(3)
	Declare @Vlr_Org		Decimal(18,2)
	Declare @Tx_Dol		Float
	Declare @Tx_Conv		Float
	Declare @Incoterm 		VarChar(3) 
	Declare @Transportador		VarChar(50) 
	Declare @CNPJ_Transp		VarChar(20)
	Declare @Pais_Trans		VarChar(30) 
	Declare @IE			Char(1)  
	Declare @Line			Int 
	Declare @Page			Int 
	Declare @Vlr_Ded		Decimal(18, 2) 

	Delete Tmp_DEMRAE Where StrMachine =@StrMachine 

	Declare CurDEMRAE Cursor For 
	Select 
		HIA.HAWB_HIA as House, Cte.Cd_Tp_Moeda, Cte.Vlr_Org_HIA, RA.Tx_Dol_RA, RA.Tx_Conv_RA, HIA.Cd_Tp_Oper as Incoterm,
		Cia.Nome_Raz_Soc as Transportador, Cia.Num_CPF_CNPJ as CNPJ, Origem.Pais_Local, 'I' as IE
	From 
		Cta_Cte_Hou_Imp_Aer as Cte Join Caixa_Hou_Imp_Aer as Cxa on Cxa.Num_proc_HIA = Cte.Num_Proc_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx and Cxa.DC_HIA = Cte.DC_HIA
		Join Remessa_Aer as RA on RA.Num_Ref_RA = Cxa.Num_Rcb_HIA 
		Join House_Imp_Aer as HIA on HIA.Num_Proc_HIA = Cte.Num_proc_HIA
		Join Master_Imp_Aer as MIA on MIA.Num_Proc_MIA = HIA.Num_proc_MIA 
		Join Pessoa as CIA on CIA.Cd_Pes = MIA.Cd_Export_MIA 
		Join Localidade as Origem on Origem.Cd_Local = MIA.Cd_Org_MIA 
	Where
		Cte.Cd_Tp_Tx = 'FRT' and 
		Cte.Comp_DN_HIA = 'N' and 
		Cte.Comp_CN_HIA = 'N'  and 
		Cte.Desp_Org_HIA = 'N' and
		Cxa.Num_Rcb_HIA = @Remessa

	Union 

	Select 
		HEA.HAWB_HEA as House, Cte.Cd_Tp_Moeda, Cte.Vlr_Org_HEA, RA.Tx_Dol_RA, RA.Tx_Conv_RA, HEA.Cd_Tp_Oper as Incoterm,
		Cia.Nome_Raz_Soc as Transportador, Cia.Num_CPF_CNPJ as CNPJ, Origem.Pais_Local, 'E' as IE
	From 
		Cta_Cte_Hou_Exp_Aer as Cte Join Caixa_Hou_Exp_Aer as Cxa on Cxa.Num_proc_HEA = Cte.Num_Proc_HEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx and Cxa.DC_HEA = Cte.DC_HEA
		Join Remessa_Aer as RA on RA.Num_Ref_RA = Cxa.Num_Rcb_HEA 
		Join House_Exp_Aer as HEA on HEA.Num_Proc_HEA = Cte.Num_proc_HEA
		Join Master_Exp_Aer as MEA on MEA.Num_Proc_MEA = HEA.Num_proc_MEA 
		Join Pessoa as CIA on CIA.Cd_Pes = MEA.Cd_Export_MEA 
		Join Localidade as Origem on Origem.Cd_Local = MEA.Cd_Org_MEA 
	Where
		Cte.Cd_Tp_Tx = 'FRT' and 
		Cte.Comp_DN_HEA = 'N' and 
		Cte.Comp_CN_HEA = 'N'  and 
		Cte.Desp_Dst_HEA = 'N' and
		Cxa.Num_Rcb_HEA = @Remessa

	Set @Line = 0
	Set @Page = 1


	Set @Vlr_Ded = IsNull((Select Sum(Cte.Vlr_Org_HIA) * @Tx_Dol From Cta_Cte_hou_Imp_Aer as Cte Join Caixa_Hou_Imp_Aer as Cxa on Cxa.Num_proc_HIA = Cte.Num_Proc_HIA and Cxa.DC_HIA = Cte.DC_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HIA = 'S')) and Cxa.Num_Rcb_HIA = @Remessa and Cte.Cd_Tp_Moeda = 'USD'  and Cte.DC_HIA = 'C'),0) - IsNull((Select Sum(Cte.Vlr_Org_HIA) * @Tx_Dol From Cta_Cte_hou_Imp_Aer as Cte Join Caixa_Hou_Imp_Aer as Cxa on Cxa.Num_proc_HIA = Cte.Num_Proc_HIA and Cxa.DC_HIA = Cte.DC_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HIA = 'S')) and Cxa.Num_Rcb_HIA = @Remessa and Cte.Cd_Tp_Moeda = 'USD'  and  Cte.DC_HIA = 'D'),0)  + 
			IsNull((Select Sum(Cte.Vlr_Org_HIA) * @Tx_Conv From Cta_Cte_hou_Imp_Aer as Cte Join Caixa_Hou_Imp_Aer as Cxa on Cxa.Num_proc_HIA = Cte.Num_Proc_HIA and Cxa.DC_HIA = Cte.DC_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HIA = 'S')) and Cxa.Num_Rcb_HIA = @Remessa and Cte.Cd_Tp_Moeda <> 'USD'  and Cte.DC_HIA = 'C'),0) - IsNull((Select Sum(Cte.Vlr_Org_HIA) * @Tx_Conv From Cta_Cte_hou_Imp_Aer as Cte Join Caixa_Hou_Imp_Aer as Cxa on Cxa.Num_proc_HIA = Cte.Num_Proc_HIA and Cxa.DC_HIA = Cte.DC_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HIA = 'S')) and Cxa.Num_Rcb_HIA = @Remessa and Cte.Cd_Tp_Moeda <> 'USD'  and Cte.DC_HIA = 'D'),0) 

	Set @Vlr_Ded = @Vlr_Ded + IsNull((Select Sum(Cte.Vlr_Org_HEA) * @Tx_Dol From Cta_Cte_hou_Exp_Aer as Cte Join Caixa_Hou_Exp_Aer as Cxa on Cxa.Num_proc_HEA = Cte.Num_Proc_HEA and Cxa.DC_HEA = Cte.DC_HEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HEA = 'S')) and Cxa.Num_Rcb_HEA = @Remessa and Cte.Cd_Tp_Moeda = 'USD'  and Cte.DC_HEA = 'C'),0) - IsNull((Select Sum(Cte.Vlr_Org_HEA) * @Tx_Dol From Cta_Cte_hou_Exp_Aer as Cte Join Caixa_Hou_Exp_Aer as Cxa on Cxa.Num_proc_HEA = Cte.Num_Proc_HEA and Cxa.DC_HEA = Cte.DC_HEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HEA = 'S')) and Cxa.Num_Rcb_HEA = @Remessa and Cte.Cd_Tp_Moeda = 'USD'  and Cte.DC_HEA = 'D'),0)  + 
			IsNull((Select Sum(Cte.Vlr_Org_HEA) * @Tx_Conv From Cta_Cte_hou_Exp_Aer as Cte Join Caixa_Hou_Exp_Aer as Cxa on Cxa.Num_proc_HEA = Cte.Num_Proc_HEA and Cxa.DC_HEA = Cte.DC_HEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HEA = 'S')) and Cxa.Num_Rcb_HEA = @Remessa and Cte.Cd_Tp_Moeda <> 'USD'  and Cte.DC_HEA = 'C'),0) - IsNull((Select Sum(Cte.Vlr_Org_HEA) * @Tx_Conv From Cta_Cte_hou_Exp_Aer as Cte Join Caixa_Hou_Exp_Aer as Cxa on Cxa.Num_proc_HEA = Cte.Num_Proc_HEA and Cxa.DC_HEA = Cte.DC_HEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HEA = 'S')) and Cxa.Num_Rcb_HEA = @Remessa and Cte.Cd_Tp_Moeda <> 'USD'  and Cte.DC_HEA = 'D'),0) 


	Open CurDEMRAE 
	Fetch Next From CurDEMRAE Into  @House, @Cd_Tp_Moeda, @Vlr_Org,  @Tx_Dol, @Tx_Conv, @Incoterm, @Transportador, @CNPJ_Transp, @Pais_Trans, @IE
	While @@Fetch_Status = 0 
		Begin 
			If @Line >= 30 
				Begin 
					Set @Line = 1 
					Set @Page = @Page + 1 
				End 
			Else
				Set @Line = @Line + 1 

			Insert Into Tmp_DEMRAE Values (@StrMachine, @Remessa, @House, @Cd_Tp_Moeda, @Vlr_Org, @Vlr_Ded, @Tx_Dol, @Tx_Conv, @Incoterm, @Transportador, @CNPJ_Transp, @Pais_Trans, @IE, @Line, @Page)
			If @@Error <> 0 
				Return -1 

			Fetch Next From CurDEMRAE Into  @House, @Cd_Tp_Moeda, @Vlr_Org, @Tx_Dol, @Tx_Conv, @Incoterm, @Transportador, @CNPJ_Transp, @Pais_Trans, @IE
		End 
	
	Close CurDEMRAE 
	Deallocate CurDEMRAE

GO
