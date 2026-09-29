SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pFatReGeracaoTmp_Ins
(
@Num_Proc		VarChar(16),
@Fatura		VarChar(17),
@StrMachine		VarChar(30)
)
AS
	Begin Transaction 
	Delete Tmp_Fatura Where StrMachine = @StrMachine 
		

	If Left(@Num_Proc, 2) = 'EA' 
		Begin 
			Insert Into Tmp_Fatura
			(StrMachine, TmpProcesso, TmpCd_Tp_Tx, TmpDC, TmpCdTpMoeda, TmpVlrOrg, TmpVlrRef, TmpVlrRS, TmpParidade)	

			Select  
				@StrMachine, @Num_Proc, TT.Cd_TP_Tx ,  Cte.DC_HEA, Cte.Cd_Tp_Moeda, Cte.Vlr_Org_HEA as Vlr_Org, 
				Vlr_Ref  = 
				Case 
					When Sum(Vlr_Ref_HEA) Is Null then 0 
					Else Sum(Vlr_Ref_HEA) 
				End,
 				VlrRS = 
				Case 
					When Avg(Par.Par_Moeda) Is Null and Cte.Cd_Tp_Moeda <> 'REL' then 0 
					When Cte.Cd_Tp_Moeda = 'REL' then Cte.Vlr_Org_HEA 
					Else Avg(Par.Par_Moeda) * Cte.Vlr_Org_HEA 
				End, 
				Paridade = 
				Case 
					When Avg(Par.Par_Moeda) Is Null  and Cte.Cd_Tp_Moeda <> 'REL'   then 0 
					When Cte.Cd_Tp_Moeda = 'REL'  then 1
					Else Avg(Par.Par_Moeda) 
				End
			From 
				Cta_Cte_Hou_Exp_Aer  as Cte Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
				Left Outer Join Caixa_Hou_Exp_Aer as Cxa on Cxa.Num_Proc_HEA = Cte.Num_Proc_HEA and Cxa.DC_HEA = Cte.DC_HEA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
				Left Outer Join Item_Fat  as Itf on Itf.Num_Proc = Cte.Num_Proc_HEA and Itf.DC = Cte.DC_HEA and Itf.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
				Join House_Exp_Aer as HEA on HEA.Num_Proc_HEA = Cte.Num_Proc_HEA
				Left Outer Join Paridade as Par on Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'EXA' and Dt_Par = HEA.Dt_Rcb_Doc_HEA
			Where  
				Cte.Num_Proc_HEA = @Num_Proc AND 
				((Cte.Desp_Dst_HEA = 'N' AND Cte.Comp_RP_HEA = 'S') OR (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_RP_HEA = 'S')) and 
				((Itf.FatCod Is Null) or (Itf.FatCod = @Fatura))

			Group by 
				TT.Cd_Tp_Tx ,  Cte.DC_HEA, Cte.Cd_Tp_Moeda, Cte.Vlr_Org_HEA 

			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return -1 
				End 
			Else
				Begin 
					Commit Transaction 
					Return 1 
				End 

		End 


	If Left(@Num_Proc, 2) = 'EM' 
		Begin 
			Insert Into Tmp_Fatura
			(StrMachine, TmpProcesso, TmpCd_Tp_Tx, TmpDC, TmpCdTpMoeda, TmpVlrOrg, TmpVlrRef)		

			Select  
				@StrMachine, @Num_Proc, TT.Cd_TP_Tx ,  Cte.DC_HEM, Cte.Cd_Tp_Moeda, Cte.Vlr_Org_HEM as Vlr_Org, 
				Vlr_Ref  = 
				Case 
					When Sum(Vlr_Ref_HEM) Is Null then 0 
					Else Sum(Vlr_Ref_HEM) 
				End  
			From 
				Cta_Cte_Hou_Exp_Mar  as Cte Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
				Left Outer Join Caixa_Hou_Exp_Mar as Cxa on Cxa.Num_Proc_HEM = Cte.Num_Proc_HEM and Cxa.DC_HEM = Cte.DC_HEM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
				Left Outer Join Item_Fat  as Itf on Itf.Num_Proc = Cte.Num_Proc_HEM and Itf.DC = Cte.DC_HEM and Itf.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
			Where  
				Cte.Num_Proc_HEM = @Num_Proc AND 
				((Cte.Desp_Dst_HEM = 'N' AND Cte.Comp_RP_HEM = 'S') OR (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_RP_HEM = 'S')) and 
				((Itf.FatCod Is Null) or (Itf.FatCod = @Fatura))

			Group by 
				TT.Cd_Tp_Tx ,  Cte.DC_HEM,   Cte.Cd_Tp_Moeda, Cte.Vlr_Org_HEM 

			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return -1 
				End 
			Else
				Begin 
					Commit Transaction 
					Return 1 
				End 

		End 


	If Left(@Num_Proc, 2) = 'IA' 
		Begin 
			Insert Into Tmp_Fatura
			(StrMachine, TmpProcesso, TmpCd_Tp_Tx, TmpDC, TmpCdTpMoeda, TmpVlrOrg, TmpVlrRef)		
			
			Select  
				@StrMachine, @Num_Proc, TT.Cd_TP_Tx ,  Cte.DC_HIA, Cte.Cd_Tp_Moeda, Cte.Vlr_Org_HIA as Vlr_Org, 
				Vlr_Ref  = 
				Case 
					When Sum(Vlr_Ref_HIA) Is Null then 0 
					Else Sum(Vlr_Ref_HIA) 
				End  
			From 
				Cta_Cte_Hou_Imp_Aer  as Cte Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
				Left Outer Join Caixa_Hou_Imp_Aer as Cxa on Cxa.Num_Proc_HIA = Cte.Num_Proc_HIA and Cxa.DC_HIA = Cte.DC_HIA and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
				Left Outer Join Item_Fat  as Itf on Itf.Num_Proc = Cte.Num_Proc_HIA and Itf.DC = Cte.DC_HIA and Itf.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
			Where  
				Cte.Num_Proc_HIA = @Num_Proc AND 
				((Cte.Desp_Org_HIA = 'N' AND Cte.Comp_RP_HIA = 'S') OR (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_RP_HIA = 'S'))  and 
				((Itf.FatCod Is Null) or (Itf.FatCod = @Fatura))
			Group by 
				TT.Cd_Tp_Tx ,  Cte.DC_HIA,   Cte.Cd_Tp_Moeda, Cte.Vlr_Org_HIA 

			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return -1 
				End 
			Else
				Begin 
					Commit Transaction 
					Return 1 
				End 

		End 


	If Left(@Num_Proc, 2) = 'IM' 
		Begin 
			Insert Into Tmp_Fatura
			(StrMachine, TmpProcesso, TmpCd_Tp_Tx, TmpDC, TmpCdTpMoeda, TmpVlrOrg, TmpVlrRef)		

			Select  
				@StrMachine, @Num_Proc, TT.Cd_TP_Tx ,  Cte.DC_HIM, Cte.Cd_Tp_Moeda, Cte.Vlr_Org_HIM as Vlr_Org, 
				Vlr_Ref  = 
				Case 
					When Sum(Vlr_Ref_HIM) Is Null then 0 
					Else Sum(Vlr_Ref_HIM) 
				End  
			From 
				Cta_Cte_Hou_Imp_Mar  as Cte Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
				Left Outer Join Caixa_Hou_Imp_Mar as Cxa on Cxa.Num_Proc_HIM = Cte.Num_Proc_HIM and Cxa.DC_HIM = Cte.DC_HIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
				Left Outer Join Item_Fat  as Itf on Itf.Num_Proc = Cte.Num_Proc_HIM and Itf.DC = Cte.DC_HIM and Itf.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
			Where  
				Cte.Num_Proc_HIM = @Num_Proc AND 
				((Cte.Desp_Org_HIM = 'N' AND Cte.Comp_RP_HIM = 'S') OR (Cte.Cd_Tp_Tx = 'FRT' and Cte.Comp_RP_HIM = 'S'))  and 
				((Itf.FatCod Is Null) or (Itf.FatCod = @Fatura))
			Group by 
				TT.Cd_Tp_Tx ,  Cte.DC_HIM,   Cte.Cd_Tp_Moeda, Cte.Vlr_Org_HIM 

			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return -1 
				End 
			Else
				Begin 
					Commit Transaction 
					Return 1 
				End 

		End
GO
