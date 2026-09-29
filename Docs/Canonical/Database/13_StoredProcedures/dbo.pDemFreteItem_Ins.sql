SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pDemFreteItem_Ins
(
@Remessa	VarChar(16) ,
@StrMachine	VarChar(30)
)
AS
	Declare @House		VarChar(20) 
	Declare @Master		VarChar(20) 
	Declare @Cd_Tp_moeda	VarChar(3)
	Declare @Vlr_Org		Decimal(18,2)
	Declare @Tx_Dol		Float
	Declare @Tx_Conv		Float
	Declare @Transportador		VarChar(50) 
	Declare @CNPJ_Transp		VarChar(20)
	Declare @Pais_Trans		VarChar(30) 
	Declare @IE			Char(1)  
	Declare @Line			Int 
	Declare @Page			Int 
	Declare @Vlr_Ded		Decimal(18, 2) 

	Declare @Processo		Varchar(16)
	Declare @Vlr_Frete		Float 
	Declare @Vlr_DedExp		Float 
	Declare @Incoterm		VarChar(3) 
	Declare @Tot_Frete		Float 
	Declare @Vlr_Frete_Efet		Float 	
	Declare @CD_Destino 		VarChar(10)
	Declare @Destino 		VarChar(50)
	Declare @Ender_Destino 	VarChar(90)
	Declare @Cd_Tp_Moeda_RA	Varchar(3) 

	Delete Tmp_Item_Demonst_Frete Where StrMachine =@StrMachine 

	If Left(@Remessa, 2) = 'RA'
		Set @Cd_Destino =  Isnull(((Select Cd_Pes From Remessa_Aer Where Num_Ref_Ra = @Remessa)),'')
	Else
		Set @Cd_Destino =  Isnull(((Select Cd_Pes From Remessa_Mar Where Num_Ref_RM = @Remessa)),'')


	Set @Destino =  (Select Nome_Raz_Soc From Pessoa Where Cd_Pes = @Cd_Destino)
	Set @Ender_Destino = IsNull((Select Rua + ', ' + Compl_End  + ',  ' + Cidade + ', ' + UF + ' - ' + Pais From Endereco Where Cd_Pes = @Cd_Destino and Cd_Tp_End = 'COM'),'')			
	Set @Line = 0

	If Left(@Remessa, 2) = 'RA'
		Begin 
			Declare CurPlanRem Cursor For 
			Select 
				Distinct HIA.Num_Proc_HIA Processo , HIA.HAWB_HIA House, MIA.MAWB_MIA Master, HIA.Cd_Tp_Oper, Tx_Dol_RA, Tx_Conv_RA, Vlr_Frete_Efet_HIA, Cd_Tp_Moeda_C_RA
			From 	
				Cta_Cte_Hou_Imp_Aer as Cte Join Caixa_Hou_Imp_Aer as Cxa on Cxa.Num_proc_HIA = Cte.Num_Proc_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx and Cxa.DC_HIA = Cte.DC_HIA
				Join Remessa_Aer as RA on RA.Num_Ref_RA = Cxa.Num_Rcb_HIA 
				Join House_Imp_Aer as HIA on HIA.Num_Proc_HIA = Cte.Num_proc_HIA
				Join Master_Imp_Aer as MIA on MIA.Num_proc_MIA = HIA.Num_Proc_MIA 
			Where
				Cxa.Num_Rcb_HIA = @Remessa
		
			Open CurPlanRem 
			Fetch Next From CurPlanRem Into  @Processo, @House, @Master, @Incoterm , @Tx_Dol, @Tx_Conv, @Vlr_Frete_Efet, @Cd_Tp_Moeda_RA
			While @@Fetch_Status = 0 
				Begin 
					--If @Line >= 30 
					--	Begin 
					--		Set @Line = 1 
					--		Set @Page = @Page + 1 
					--	End 
					--Else
						Set @Line = @Line + 1 
		
					Set @Vlr_Frete = IsNull((Select Cte.Vlr_Org_HIA From Cta_Cte_Hou_Imp_Aer as Cte Join Caixa_Hou_Imp_Aer as Cxa on Cxa.Num_proc_HIA = Cte.Num_Proc_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx and Cxa.DC_HIA = Cte.DC_HIA 	Where Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_DN_HIA = 'N' and Cte.Comp_CN_HIA = 'N'  and Cte.Desp_Org_HIA = 'N' and Cxa.Num_Rcb_HIA = @Remessa and Cte.Num_Proc_HIA = @Processo),0)
						
					Set @Vlr_Ded = IsNull((Select Sum(Cte.Vlr_Org_HIA) * @Tx_Dol From Cta_Cte_hou_Imp_Aer as Cte Join Caixa_Hou_Imp_Aer as Cxa on Cxa.Num_proc_HIA = Cte.Num_Proc_HIA and Cxa.DC_HIA = Cte.DC_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HIA = 'S')) and Cxa.Num_Rcb_HIA = @Remessa and Cte.Num_Proc_HIA = @Processo and Cte.Cd_Tp_Moeda = 'USD'  and Cte.DC_HIA = 'C'),0) - IsNull((Select Sum(Cte.Vlr_Org_HIA) * @Tx_Dol From Cta_Cte_hou_Imp_Aer as Cte Join Caixa_Hou_Imp_Aer as Cxa on Cxa.Num_proc_HIA = Cte.Num_Proc_HIA and Cxa.DC_HIA = Cte.DC_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HIA = 'S')) and Cxa.Num_Rcb_HIA = @Remessa and Cte.Num_Proc_HIA = @Processo and Cte.Cd_Tp_Moeda = 'USD'  and  Cte.DC_HIA = 'D'),0)  + 
							IsNull((Select Sum(Cte.Vlr_Org_HIA) * @Tx_Conv From Cta_Cte_hou_Imp_Aer as Cte Join Caixa_Hou_Imp_Aer as Cxa on Cxa.Num_proc_HIA = Cte.Num_Proc_HIA and Cxa.DC_HIA = Cte.DC_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HIA = 'S')) and Cxa.Num_Rcb_HIA = @Remessa and Cte.Num_Proc_HIA = @Processo and Cte.Cd_Tp_Moeda <> 'USD'  and Cte.DC_HIA = 'C'),0) - IsNull((Select Sum(Cte.Vlr_Org_HIA) * @Tx_Conv From Cta_Cte_hou_Imp_Aer as Cte Join Caixa_Hou_Imp_Aer as Cxa on Cxa.Num_proc_HIA = Cte.Num_Proc_HIA and Cxa.DC_HIA = Cte.DC_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HIA = 'S')) and Cxa.Num_Rcb_HIA = @Remessa and Cte.Num_Proc_HIA = @Processo and Cte.Cd_Tp_Moeda <> 'USD'  and Cte.DC_HIA = 'D'),0) 
		
		
					--Set @Vlr_Ded = IsNull((Select Sum(Cte.Vlr_Org_HIA) * @Tx_Dol From Cta_Cte_hou_Imp_Aer as Cte Join Caixa_Hou_Imp_Aer as Cxa on Cxa.Num_proc_HIA = Cte.Num_Proc_HIA and Cxa.DC_HIA = Cte.DC_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HIA = 'S')) and Cxa.Num_Rcb_HIA = @Remessa and Cte.Cd_Tp_Moeda = 'USD'  and Cte.DC_HIA = 'C' and Cte.Num_Proc_HIA = @Processo),0) - IsNull((Select Sum(Cte.Vlr_Org_HIA) * @Tx_Dol From Cta_Cte_hou_Imp_Aer as Cte Join Caixa_Hou_Imp_Aer as Cxa on Cxa.Num_proc_HIA = Cte.Num_Proc_HIA and Cxa.DC_HIA = Cte.DC_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HIA = 'S')) and Cxa.Num_Rcb_HIA = @Remessa and Cte.Num_Proc_HIA = @Processo and Cte.Cd_Tp_Moeda = 'USD'  and  Cte.DC_HIA = 'D'),0)  + 
					--		IsNull((Select Sum(Cte.Vlr_Org_HIA) * @Tx_Conv From Cta_Cte_hou_Imp_Aer as Cte Join Caixa_Hou_Imp_Aer as Cxa on Cxa.Num_proc_HIA = Cte.Num_Proc_HIA and Cxa.DC_HIA = Cte.DC_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HIA = 'S')) and Cxa.Num_Rcb_HIA = @Remessa and Cte.Cd_Tp_Moeda <> 'USD'  and Cte.DC_HIA = 'C' and Cte.Num_Proc_HIA = @Processo),0) - IsNull((Select Sum(Cte.Vlr_Org_HIA) * @Tx_Conv From Cta_Cte_hou_Imp_Aer as Cte Join Caixa_Hou_Imp_Aer as Cxa on Cxa.Num_proc_HIA = Cte.Num_Proc_HIA and Cxa.DC_HIA = Cte.DC_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HIA = 'S')) and Cxa.Num_Rcb_HIA = @Remessa and Cte.Cd_Tp_Moeda <> 'USD'  and Cte.DC_HIA = 'D' and Cte.Num_Proc_HIA = @Processo),0) 
		
		
					Insert Into Tmp_Item_Demonst_Frete Values (@StrMachine, @Remessa, @Master, @House, @Vlr_Frete, @Vlr_Ded, @Incoterm, @Page, @Line,@Vlr_Frete_Efet, @Cd_Tp_Moeda_RA, @Destino, @Ender_Destino) 		
			
					Fetch Next From CurPlanRem Into  @Processo, @House, @Master, @Incoterm , @Tx_Dol, @Tx_Conv, @Vlr_Frete_Efet, @Cd_Tp_Moeda_RA
					
				End 
		
		
		
		
			Close CurPlanRem 
			Deallocate CurPlanRem 
		
		
			Set @Vlr_DedExp = IsNull((Select Cte.Vlr_Org_HEA From Cta_Cte_Hou_Exp_Aer as Cte Join Caixa_Hou_Exp_Aer as Cxa on Cxa.Num_proc_HEA = Cte.Num_Proc_HEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx and Cxa.DC_HEA = Cte.DC_HEA Where Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_DN_HEA = 'N' and Cte.Comp_CN_HEA = 'N'  and Cte.Desp_Dst_HEA = 'N' and Cxa.Num_Rcb_HEA = @Remessa),0)
				
			Set @Vlr_DedExp = @Vlr_DedExp + IsNull((Select Sum(Cte.Vlr_Org_HEA) * @Tx_Dol From Cta_Cte_hou_Exp_Aer as Cte Join Caixa_Hou_Exp_Aer as Cxa on Cxa.Num_proc_HEA = Cte.Num_Proc_HEA and Cxa.DC_HEA = Cte.DC_HEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HEA = 'S')) and Cxa.Num_Rcb_HEA = @Remessa and Cte.Cd_Tp_Moeda = 'USD'  and Cte.DC_HEA = 'C'  ),0) - IsNull((Select Sum(Cte.Vlr_Org_HEA) * @Tx_Dol From Cta_Cte_hou_Exp_Aer as Cte Join Caixa_Hou_Exp_Aer as Cxa on Cxa.Num_proc_HEA = Cte.Num_Proc_HEA and Cxa.DC_HEA = Cte.DC_HEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HEA = 'S')) and Cxa.Num_Rcb_HEA = @Remessa and Cte.Cd_Tp_Moeda = 'USD'  and  Cte.DC_HEA = 'D'),0)  + 
					IsNull((Select Sum(Cte.Vlr_Org_HEA) * @Tx_Conv From Cta_Cte_hou_Exp_Aer as Cte Join Caixa_Hou_Exp_Aer as Cxa on Cxa.Num_proc_HEA = Cte.Num_Proc_HEA and Cxa.DC_HEA = Cte.DC_HEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HEA = 'S')) and Cxa.Num_Rcb_HEA = @Remessa and Cte.Cd_Tp_Moeda <> 'USD'  and Cte.DC_HEA = 'C' ),0) - IsNull((Select Sum(Cte.Vlr_Org_HEA) * @Tx_Conv From Cta_Cte_hou_Exp_Aer as Cte Join Caixa_Hou_Exp_Aer as Cxa on Cxa.Num_proc_HEA = Cte.Num_Proc_HEA and Cxa.DC_HEA = Cte.DC_HEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HEA = 'S')) and Cxa.Num_Rcb_HEA = @Remessa and Cte.Cd_Tp_Moeda <> 'USD'  and Cte.DC_HEA = 'D'),0) 

		End 
	Else
		Begin 

			Declare CurPlanRem Cursor For 
			Select 
				Distinct HIM.Num_Proc_HIM Processo , HIM.HAWB_HIM House, MIM.MAWB_MIM Master, HIM.Cd_Tp_Oper, Tx_Dol_RM, Tx_Conv_RM, Vlr_Frete_Efet_HIM, Cd_Tp_Moeda_C_RM
			From 	
				Cta_Cte_Hou_Imp_Mar as Cte Join Caixa_Hou_Imp_Mar as Cxa on Cxa.Num_proc_HIM = Cte.Num_Proc_HIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx and Cxa.DC_HIM = Cte.DC_HIM
				Join Remessa_Mar as RM on RM.Num_Ref_RM = Cxa.Num_Rcb_HIM 
				Join House_Imp_Mar as HIM on HIM.Num_Proc_HIM = Cte.Num_proc_HIM
				Join Master_Imp_Mar as MIM on MIM.Num_proc_MIM = HIM.Num_Proc_MIM 
			Where
				Cxa.Num_Rcb_HIM = @Remessa
		
			Open CurPlanRem 
			Fetch Next From CurPlanRem Into  @Processo, @House, @Master, @Incoterm , @Tx_Dol, @Tx_Conv, @Vlr_Frete_Efet, @Cd_Tp_Moeda_RA
			While @@Fetch_Status = 0 
				Begin 
					--If @Line >= 30 
					--	Begin 
					--		Set @Line = 1 
					--		Set @Page = @Page + 1 
					--	End 
					--Else
						Set @Line = @Line + 1 
		
					Set @Vlr_Frete = IsNull((Select Cte.Vlr_Org_HIM From Cta_Cte_Hou_Imp_Mar as Cte Join Caixa_Hou_Imp_Mar as Cxa on Cxa.Num_proc_HIM = Cte.Num_Proc_HIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx and Cxa.DC_HIM = Cte.DC_HIM 	Where Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_DN_HIM = 'N' and Cte.Comp_CN_HIM = 'N'  and Cte.Desp_Org_HIM = 'N' and Cxa.Num_Rcb_HIM = @Remessa and Cte.Num_Proc_HIM = @Processo),0)
						
					Set @Vlr_Ded = IsNull((Select Sum(Cte.Vlr_Org_HIM) * @Tx_Dol From Cta_Cte_Hou_Imp_Mar as Cte Join Caixa_Hou_Imp_Mar as Cxa on Cxa.Num_proc_HIM = Cte.Num_Proc_HIM and Cxa.DC_HIM = Cte.DC_HIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HIM = 'S')) and Cxa.Num_Rcb_HIM = @Remessa and Cte.Num_Proc_HIM = @Processo and Cte.Cd_Tp_Moeda = 'USD'  and Cte.DC_HIM = 'C'),0) - IsNull((Select Sum(Cte.Vlr_Org_HIM) * @Tx_Dol From Cta_Cte_Hou_Imp_Mar as Cte Join Caixa_Hou_Imp_Mar as Cxa on Cxa.Num_proc_HIM = Cte.Num_Proc_HIM and Cxa.DC_HIM = Cte.DC_HIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HIM = 'S')) and Cxa.Num_Rcb_HIM = @Remessa and Cte.Num_Proc_HIM = @Processo and Cte.Cd_Tp_Moeda = 'USD'  and  Cte.DC_HIM = 'D'),0)  + 
							IsNull((Select Sum(Cte.Vlr_Org_HIM) * @Tx_Conv From Cta_Cte_Hou_Imp_Mar as Cte Join Caixa_Hou_Imp_Mar as Cxa on Cxa.Num_proc_HIM = Cte.Num_Proc_HIM and Cxa.DC_HIM = Cte.DC_HIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HIM = 'S')) and Cxa.Num_Rcb_HIM = @Remessa and Cte.Num_Proc_HIM = @Processo and Cte.Cd_Tp_Moeda <> 'USD'  and Cte.DC_HIM = 'C'),0) - IsNull((Select Sum(Cte.Vlr_Org_HIM) * @Tx_Conv From Cta_Cte_Hou_Imp_Mar as Cte Join Caixa_Hou_Imp_Mar as Cxa on Cxa.Num_proc_HIM = Cte.Num_Proc_HIM and Cxa.DC_HIM = Cte.DC_HIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HIM = 'S')) and Cxa.Num_Rcb_HIM = @Remessa and Cte.Num_Proc_HIM = @Processo and Cte.Cd_Tp_Moeda <> 'USD'  and Cte.DC_HIM = 'D'),0) 
		
		
					--Set @Vlr_Ded = IsNull((Select Sum(Cte.Vlr_Org_HIM) * @Tx_Dol From Cta_Cte_Hou_Imp_Mar as Cte Join Caixa_Hou_Imp_Mar as Cxa on Cxa.Num_proc_HIM = Cte.Num_Proc_HIM and Cxa.DC_HIM = Cte.DC_HIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HIM = 'S')) and Cxa.Num_Rcb_HIM = @Remessa and Cte.Cd_Tp_Moeda = 'USD'  and Cte.DC_HIM = 'C' and Cte.Num_Proc_HIM = @Processo),0) - IsNull((Select Sum(Cte.Vlr_Org_HIM) * @Tx_Dol From Cta_Cte_Hou_Imp_Mar as Cte Join Caixa_Hou_Imp_Mar as Cxa on Cxa.Num_proc_HIM = Cte.Num_Proc_HIM and Cxa.DC_HIM = Cte.DC_HIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HIM = 'S')) and Cxa.Num_Rcb_HIM = @Remessa and Cte.Num_Proc_HIM = @Processo and Cte.Cd_Tp_Moeda = 'USD'  and  Cte.DC_HIM = 'D'),0)  + 
					--		IsNull((Select Sum(Cte.Vlr_Org_HIM) * @Tx_Conv From Cta_Cte_Hou_Imp_Mar as Cte Join Caixa_Hou_Imp_Mar as Cxa on Cxa.Num_proc_HIM = Cte.Num_Proc_HIM and Cxa.DC_HIM = Cte.DC_HIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HIM = 'S')) and Cxa.Num_Rcb_HIM = @Remessa and Cte.Cd_Tp_Moeda <> 'USD'  and Cte.DC_HIM = 'C' and Cte.Num_Proc_HIM = @Processo),0) - IsNull((Select Sum(Cte.Vlr_Org_HIM) * @Tx_Conv From Cta_Cte_Hou_Imp_Mar as Cte Join Caixa_Hou_Imp_Mar as Cxa on Cxa.Num_proc_HIM = Cte.Num_Proc_HIM and Cxa.DC_HIM = Cte.DC_HIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HIM = 'S')) and Cxa.Num_Rcb_HIM = @Remessa and Cte.Cd_Tp_Moeda <> 'USD'  and Cte.DC_HIM = 'D' and Cte.Num_Proc_HIM = @Processo),0) 
		
		
					Insert Into Tmp_Item_Demonst_Frete Values (@StrMachine, @Remessa, @Master, @House, @Vlr_Frete, @Vlr_Ded, @Incoterm, @Page, @Line,@Vlr_Frete_Efet, @Cd_Tp_Moeda_RA, @Destino, @Ender_Destino) 		
			
					Fetch Next From CurPlanRem Into  @Processo, @House, @Master, @Incoterm , @Tx_Dol, @Tx_Conv, @Vlr_Frete_Efet, @Cd_Tp_Moeda_RA
					
				End 
		
		
		
		
			Close CurPlanRem 
			Deallocate CurPlanRem 
		
		
			Set @Vlr_DedExp = IsNull((Select Cte.Vlr_Org_HEM From Cta_Cte_Hou_Exp_Mar as Cte Join Caixa_Hou_Exp_Mar as Cxa on Cxa.Num_proc_HEM = Cte.Num_Proc_HEM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx and Cxa.DC_HEM = Cte.DC_HEM Where Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_DN_HEM = 'N' and Cte.Comp_CN_HEM = 'N'  and Cte.Desp_Dst_HEM = 'N' and Cxa.Num_Rcb_HEM = @Remessa),0)
				
			Set @Vlr_DedExp = @Vlr_DedExp + IsNull((Select Sum(Cte.Vlr_Org_HEM) * @Tx_Dol From Cta_Cte_Hou_Exp_Mar as Cte Join Caixa_Hou_Exp_Mar as Cxa on Cxa.Num_proc_HEM = Cte.Num_Proc_HEM and Cxa.DC_HEM = Cte.DC_HEM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HEM = 'S')) and Cxa.Num_Rcb_HEM = @Remessa and Cte.Cd_Tp_Moeda = 'USD'  and Cte.DC_HEM = 'C'  ),0) - IsNull((Select Sum(Cte.Vlr_Org_HEM) * @Tx_Dol From Cta_Cte_Hou_Exp_Mar as Cte Join Caixa_Hou_Exp_Mar as Cxa on Cxa.Num_proc_HEM = Cte.Num_Proc_HEM and Cxa.DC_HEM = Cte.DC_HEM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HEM = 'S')) and Cxa.Num_Rcb_HEM = @Remessa and Cte.Cd_Tp_Moeda = 'USD'  and  Cte.DC_HEM = 'D'),0)  + 
					IsNull((Select Sum(Cte.Vlr_Org_HEM) * @Tx_Conv From Cta_Cte_Hou_Exp_Mar as Cte Join Caixa_Hou_Exp_Mar as Cxa on Cxa.Num_proc_HEM = Cte.Num_Proc_HEM and Cxa.DC_HEM = Cte.DC_HEM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HEM = 'S')) and Cxa.Num_Rcb_HEM = @Remessa and Cte.Cd_Tp_Moeda <> 'USD'  and Cte.DC_HEM = 'C' ),0) - IsNull((Select Sum(Cte.Vlr_Org_HEM) * @Tx_Conv From Cta_Cte_Hou_Exp_Mar as Cte Join Caixa_Hou_Exp_Mar as Cxa on Cxa.Num_proc_HEM = Cte.Num_Proc_HEM and Cxa.DC_HEM = Cte.DC_HEM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx  Where  (Cte.Cd_Tp_Tx <> 'FRT' or (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_CN_HEM = 'S')) and Cxa.Num_Rcb_HEM = @Remessa and Cte.Cd_Tp_Moeda <> 'USD'  and Cte.DC_HEM = 'D'),0) 
		End	

	Set @Tot_Frete = IsNull((Select Sum(TmpFreteEfet) From Tmp_Item_Demonst_Frete Where StrMachine = @StrMachine),0) 



	Update Tmp_Item_Demonst_Frete Set TmpDeducao = TmpDeducao + (@Vlr_DedExp * (TmpVlrFrete/@Tot_Frete)) Where StrMachine  = @StrMachine
GO
