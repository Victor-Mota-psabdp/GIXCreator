SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pFatGeracao_Ins 
(
@StrMachine		VarChar(30), 
@StrOldFat		VarChar(17)='',
@Num_Proc		VarChar(16), 
@Obs			VarChar(300)='',
@DtVenc		Datetime,
@Usuario		VarChar(6), 
@NumFat		VarChar(17)='' OUTPUT,
@cpmf			Decimal(10,2)=0
)
AS
	Declare  @IntFat 		Int 
	Declare @Cd_Pes		VarChar(10) 
	Declare @Cd_Tp_Tx		Char(3)
	Begin Transaction 
	Set @IntFat = (IsNull((Select TOP 1 ASCII(Right(FatCod,1)) From Item_Fat Where Num_Proc = @Num_Proc Order by FatCod Desc),64)) + 1 
	Set @NumFat = (Select Distinct TmpProcesso From Tmp_Fatura Where StrMachine = @StrMachine) + Char(@IntFat)

	If Left(@Num_Proc, 2) = 'EA'
		Begin 
			Set @Cd_Pes = (Select Cd_Export_HEA From House_Exp_Aer Where Num_Proc_HEA = @Num_Proc)
			Set @Cd_Tp_Tx = 'C$' + Cast(((IsNull((Select max(right(cd_tp_tx, 1)) from cta_cte_hou_exp_aer where Num_Proc_HEA = @Num_Proc and cd_Tp_Tx like 'C$%' ), 0)) + 1) as char(1))
			Delete From cta_cte_hou_exp_aer  Where Num_Proc_HEA = @Num_Proc and DC_HEA = 'C' and Cd_Tp_Tx in (Select Cd_Tp_Tx From Fatura Where FatCod = @StrOldFat and Cd_Tp_Tx like 'C$%' ) 			
			If @@Error > 0 
				Begin 
					Rollback Transaction 
					Return -13 
				End 

			if @cpmf > 0 
				Begin 
					Insert into cta_cte_hou_exp_aer (Num_Proc_HEA, Cd_Tp_Tx, DC_HEA, Org_Ins_HEA, Dt_Ins_HEA, Cd_Tp_Moeda, Vlr_Org_HEA,Dt_Prev_Pgto_HEA, Cd_Cred_Dev_HEA, Desp_Dst_HEA,  
							CPMF_HEA,Comp_RP_HEA, Comp_DN_HEA, Comp_CN_HEA, Comp_CPA_HEA, Num_DCN_HEA) 
					Values (@Num_Proc, @Cd_Tp_Tx, 'C', 'Sistema', dbo.strhoje(getdate()), 'REL', @cpmf, dbo.strhoje(getdate()), @Cd_Pes, 'N', 'N', 'S', 'N', 'N', 'N', null)
					If @@Error > 0 
						Begin 
							Rollback Transaction 
							Return -12 
						End 
				End 

		End 
	If Left(@Num_Proc, 2) = 'EM'
		Begin 
			Set @Cd_Pes = (Select Cd_Export_HEM From House_Exp_Mar Where Num_Proc_HEM = @Num_Proc)
			Set @Cd_Tp_Tx = 'C$' + Cast(((IsNull((Select max(right(cd_tp_tx, 1)) from cta_cte_hou_exp_mar where Num_Proc_HEM = @Num_Proc and cd_Tp_Tx like 'C$%' ), 0)) + 1) as char(1))
			Delete From cta_cte_hou_exp_mar  Where Num_Proc_HEM = @Num_Proc and DC_HEM = 'C' and Cd_Tp_Tx in (Select Cd_Tp_Tx From Fatura Where FatCod = @StrOldFat and Cd_Tp_Tx like 'C$%' ) 			
			If @@Error > 0 
				Begin 
					Rollback Transaction 
					Return -12 
				End 

			if @cpmf > 0 
				Begin 
					Insert into cta_cte_hou_exp_mar (Num_Proc_HEM, Cd_Tp_Tx, DC_HEM, Org_Ins_HEM, Dt_Ins_HEM, Cd_Tp_Moeda, Vlr_Org_HEM,Dt_Prev_Pgto_HEM, Cd_Cred_Dev_HEM, Desp_Dst_HEM,  
							CPMF_HEM,Comp_RP_HEM, Comp_DN_HEM, Comp_CN_HEM, Comp_CPA_HEM, Num_DCN_HEM) 
					Values (@Num_Proc, @Cd_Tp_Tx, 'C', 'Sistema', dbo.strhoje(getdate()), 'REL', @cpmf, dbo.strhoje(getdate()), @Cd_Pes, 'N', 'N', 'S', 'N', 'N', 'N', null)
					If @@Error > 0 
						Begin 
							Rollback Transaction 
							Return -12 
						End 
				End 
		End 

	If Left(@Num_Proc, 2) = 'IA'
		Begin 
			Set @Cd_Pes = (Select Cd_Import_HIA From House_Imp_Aer Where Num_Proc_HIA = @Num_Proc)
			Set @Cd_Tp_Tx = 'C$' + Cast(((IsNull((Select max(right(cd_tp_tx, 1)) from cta_cte_hou_imp_aer where Num_Proc_HIA = @Num_Proc and cd_Tp_Tx like 'C$%' ), 0)) + 1) as char(1))
			Delete From cta_cte_hou_imp_aer  Where Num_Proc_HIA = @Num_Proc and DC_HIA = 'C' and Cd_Tp_Tx in (Select Cd_Tp_Tx From Fatura Where FatCod = @StrOldFat and Cd_Tp_Tx like 'C$%' ) 			
			If @@Error > 0 
				Begin 
					Rollback Transaction 
					Return -12 
				End 
			if @cpmf > 0 
				Begin 
					Insert into cta_cte_hou_imp_aer (Num_Proc_HIA, Cd_Tp_Tx, DC_HIA, Org_Ins_HIA, Dt_Ins_HIA, Cd_Tp_Moeda, Vlr_Org_HIA,Dt_Prev_Pgto_HIA, Cd_Cred_Dev_HIA, Desp_Org_HIA,  
							CPMF_HIA,Comp_RP_HIA, Comp_DN_HIA, Comp_CN_HIA, Comp_CPA_HIA, Num_DCN_HIA) 
					Values (@Num_Proc, @Cd_Tp_Tx, 'C', 'Sistema', dbo.strhoje(getdate()), 'REL', @cpmf, dbo.strhoje(getdate()), @Cd_Pes, 'N', 'N', 'S', 'N', 'N', 'N', null)
					If @@Error > 0 
						Begin 
							Rollback Transaction 
							Return -12 
						End 
				End
		End 

	If Left(@Num_Proc, 2) = 'IM'
		Begin 
			Set @Cd_Pes = (Select Cd_Import_HIM From House_Imp_Mar Where Num_Proc_HIM = @Num_Proc)
			Set @Cd_Tp_Tx = 'C$' + Cast(((IsNull((Select max(right(cd_tp_tx, 1)) from cta_cte_hou_imp_mar where Num_Proc_HIM = @Num_Proc and cd_Tp_Tx like 'C$%' ), 0)) + 1) as char(1))
			Delete From cta_cte_hou_imp_mar  Where Num_Proc_HIM = @Num_Proc and DC_HIM = 'C' and Cd_Tp_Tx in (Select Cd_Tp_Tx From Fatura Where FatCod = @StrOldFat and Cd_Tp_Tx like 'C$%' ) 			
			If @@Error > 0 
				Begin 
					Rollback Transaction 
					Return -12 
				End 

			if @cpmf > 0 
				Begin 
					Insert into cta_cte_hou_imp_mar (Num_Proc_HIM, Cd_Tp_Tx, DC_HIM, Org_Ins_HIM, Dt_Ins_HIM, Cd_Tp_Moeda, Vlr_Org_HIM,Dt_Prev_Pgto_HIM, Cd_Cred_Dev_HIM, Desp_Org_HIM,  
							CPMF_HIM, Comp_RP_HIM, Comp_DN_HIM, Comp_CN_HIM, Comp_CPA_HIM, Num_DCN_HIM) 
					Values (@Num_Proc, @Cd_Tp_Tx, 'C', 'Sistema', dbo.strhoje(getdate()), 'REL', @cpmf, dbo.strhoje(getdate()), @Cd_Pes, 'N', 'N', 'S', 'N', 'N', 'N', null)
					If @@Error > 0 
						Begin 
							Rollback Transaction 
							Return -12 
						End 
				End 
		End 

	Insert Into Fatura (FatCod, Cd_Pes, FatDtVenc, FatObs, FatStatus) Values (@NumFat, @Cd_Pes, @DtVenc, @Obs, 1)
	If @@Error <>0
		Begin 
			RollBack Transaction 
			Return -1 
		End 

	Insert into Fat_Log (FatCod, Cd_Usuario, FatOper, FatDtOper)  values (@NumFat, @Usuario, 'I', getdate())

	If @@Error <>0
		Begin 
			RollBack Transaction 
			Return -2
		End 

	Insert Into Item_Fat (FatCod, Num_Proc, Cd_Tp_Tx, DC, Cd_Tp_Moeda, Vlr_Org, Vlr_RS, Paridade ) 
	Select @NumFat, @Num_Proc, TmpCd_Tp_Tx, TmpDC, TmpCdTpMoeda, Vlr_Org = Case When TmpVlrRef Is Not Null then TmpVlrOrg - TmpVlrRef Else TmpVlrOrg End, TmpVlrRS, TmpParidade From Tmp_fatura
		Where StrMachine = @StrMachine and TmpProcesso = @Num_Proc and (TmpVlrOrg - TmpVlrRef ) >0

	If @@Error <>0
		Begin 
			RollBack Transaction 
			Return -2
		End 

	

	if @cpmf > 0 
		Begin 
			Insert Into Item_Fat (FatCod, Num_Proc, Cd_Tp_Tx, DC, Cd_Tp_Moeda, Vlr_Org, Vlr_RS, Paridade) 
			values( @NumFat, @Num_Proc, @Cd_Tp_Tx, 'C', 'REL', @cpmf, @cpmf, 1 )
		
			If @@Error <>0
				Begin 
					RollBack Transaction 
					Return -4
				End 

		End 

	If @StrOldFat <> '' 
		Begin 
			Update Fatura Set FatStatus = 0 Where FatCod = @StrOldFat 
			If @@Error <>0
				Begin 
					RollBack Transaction 
					Return -3
				End 

			Insert into Fat_Log (FatCod, Cd_Usuario, FatOper, FatDtOper)  values (@StrOldFat, @Usuario, 'C', getdate())
			If @@Error <>0
				Begin 
					RollBack Transaction 
					Return -3
				End 

			Else
				Begin 
					Commit Transaction 
					Return 1
				End 
		End
	Else
		Begin 
			If @@Error <>0
				Begin 
					RollBack Transaction 
					Return -4
				End 
			Else
				Begin 
					Commit Transaction 
					Return 1
				End 
		End
GO
