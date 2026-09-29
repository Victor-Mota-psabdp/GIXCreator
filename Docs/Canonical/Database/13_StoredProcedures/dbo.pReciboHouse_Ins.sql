SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



/****** Object:  Stored Procedure dbo.pReciboHouse_Ins    Script Date: 17/10/2002 07:32:51 ******/
CREATE  PROCEDURE [dbo].[pReciboHouse_Ins]
(
@Site 				Char(1), 
@Lcto				VarChar(12),
@Num_Proc			VarChar(16),
@CredDev			VarChar(10),		
@Cd_Tp_Tx			VarChar(6), 
@DC				Char(1), 
@Vlr_Ref			Float, 
@Dt_Conv			VarChar(10),
@Cd_Tp_Par			VarChar(3),
@Par_Moeda			Float, 
@Vlr_Pgto_Rcto		Float, 
@Dt_Pgto_Rcto			VarChar(10), 
@Usuario			VarChar(6),
@NewRec			Varchar(12) = '' OUTPUT
)
 AS
	Declare @UltRec 	VarChar(12) 
--	Begin Transaction
	Set @UltRec = (Select Ult_Recibo From Referencia Where Ref_Acesso = @Site)
	Set @NewRec = 'RC' + @Site 
	Set @NewRec = @NewRec + right(Cast(year(GetDate()) as VarChar(4)), 2)

	Set @NewRec = @NewRec + right('0' + Cast(month(GetDate()) as VarChar(2)),2) 
	If left(@UltRec, 7 ) = @NewRec
		Begin
			Set @NewRec = @NewRec +  Right('00000' + Cast((right(@UltRec, 5) +1) as VarChar(5)),5)
		End 
	Else
		Begin 
			Set @NewRec = @NewRec +  Cast('00001' as VarChar(5))
		End 	
	If left(@Num_Proc, 2)  = 'EA'
		Begin
			Update 
				Caixa_Hou_Exp_Aer
			Set
				Num_Rcb_HEA = @NewRec 
			Where
				Num_Proc_HEA = @Num_Proc and 
				Num_Lcto = @Lcto and 
				Num_Rcb_HEA = ''
			If @@RowCount > 0 
				Begin 
					Update 
						Referencia
					Set
						Ult_Recibo   = @NewRec 
					Where 
						Ref_Acesso = @Site
					If @@RowCount = 1 
						Begin 
							Exec pLogCaixa_Ins
								'A', @Num_Proc, @Cd_Tp_Tx, @DC, @Lcto, @Vlr_Ref, @Dt_Conv, @Cd_Tp_Par, @Par_Moeda,
								@Vlr_Pgto_Rcto, Null, @NewRec, @Usuario
							If @@RowCount = 1 
								Begin 
									--Commit Transaction
									Return 1 
								End 
							Else
								Begin 
									--Rollback Transcation
									Return - 3
								End 
						End 
					Else 
						Begin 
							--Commit Transaction
							Return -2
						End 
				End 
			Else
				Begin 
					--RollBack Transaction
					Return -1 
				End 
			
		End 
	If Left(@Num_Proc, 2)  = 'EM'
		Begin
			Update 
				Caixa_Hou_Exp_Mar
			Set
				Num_Rcb_HEM = @NewRec 
			Where
				Num_Proc_HEM = @Num_Proc and 
				Num_Lcto = @Lcto and 
				Num_Rcb_HEM = ''
			If @@RowCount > 0  
				Begin 
					Update 
						Referencia
					Set
						Ult_Recibo   = @NewRec 
					Where 
						Ref_Acesso = @Site
					If @@RowCount = 1 
						Begin 
							Exec pLogCaixa_Ins
								'A', @Num_Proc, @Cd_Tp_Tx, @DC, @Lcto, @Vlr_Ref, @Dt_Conv, @Cd_Tp_Par, @Par_Moeda,
								@Vlr_Pgto_Rcto, Null, @NewRec, @Usuario
							If @@RowCount = 1 
								Begin 
									--Commit Transaction
									Return 1 
								End 
							Else
								Begin 
									--Rollback Transcation
									Return - 3
								End 
						End 
					Else 
						Begin 
							--Commit Transaction
							Return -2
						End 
				End 
			Else
				Begin 
					--RollBack Transaction
					Return -1 
				End 
		End 
	If Left(@Num_Proc, 2)  = 'IA'
		Begin
			Update 
				Caixa_Hou_Imp_Aer
			Set
				Num_Rcb_HIA = @NewRec 
			Where
				Num_Proc_HIA = @Num_Proc and 
				Num_Lcto = @Lcto and 
				Num_Rcb_HIA = ''
			If @@RowCount > 0  
				Begin 
					Update 
						Referencia
					Set
						Ult_Recibo   = @NewRec 
					Where 
						Ref_Acesso = @Site
					If @@RowCount = 1 
						Begin 
							Exec pLogCaixa_Ins
								'A', @Num_Proc, @Cd_Tp_Tx, @DC, @Lcto, @Vlr_Ref, @Dt_Conv, @Cd_Tp_Par, @Par_Moeda,
								@Vlr_Pgto_Rcto, Null, @NewRec, @Usuario
							If @@RowCount = 1 
								Begin 
									--Commit Transaction
									Return 1 
								End 
							Else
								Begin 
									--Rollback Transcation
									Return - 3
								End 
						End 
					Else 
						Begin 
							--Commit Transaction
							Return -2
						End 
				End 
			Else
				Begin 
					--RollBack Transaction
					Return -1 
				End 
		End 	
	If Left(@Num_Proc, 2)  = 'IM'
		Begin
			Update 
				Caixa_Hou_Imp_Mar
			Set
				Num_Rcb_HIM = @NewRec 
			Where
				Num_Proc_HIM = @Num_Proc and 
				Num_Lcto = @Lcto and 
				Num_Rcb_HIM = ''
			If @@RowCount > 0  
				Begin 
					Update 
						Referencia
					Set
						Ult_Recibo   = @NewRec 
					Where 
						Ref_Acesso = @Site
					If @@RowCount = 1 
						Begin 
							Exec pLogCaixa_Ins
								'A', @Num_Proc, @Cd_Tp_Tx, @DC, @Lcto, @Vlr_Ref, @Dt_Conv, @Cd_Tp_Par, @Par_Moeda,
								@Vlr_Pgto_Rcto, Null, @NewRec, @Usuario
							If @@RowCount = 1 
								Begin 
									--Commit Transaction
									Return 1 
								End 
							Else
								Begin 
									--Rollback Transcation
									Return - 3
								End 
						End 
					Else 
						Begin 
							--Commit Transaction
							Return -2
						End 
				End 
			Else
				Begin 
					--RollBack Transaction
					Return -1 
				End 
		End


	If Left(@Num_Proc, 2)  = 'IO'
		Begin
			Update 
				Caixa_Hou_Imp_Out
			Set
				Num_Rcb_HIO = @NewRec 
			Where
				Num_Proc_HIO = @Num_Proc and 
				Num_Lcto = @Lcto and 
				Num_Rcb_HIO = ''
			If @@RowCount > 0  
				Begin 
					Update 
						Referencia
					Set
						Ult_Recibo   = @NewRec 
					Where 
						Ref_Acesso = @Site
					If @@RowCount = 1 
						Begin 
							Exec pLogCaixa_Ins
								'A', @Num_Proc, @Cd_Tp_Tx, @DC, @Lcto, @Vlr_Ref, @Dt_Conv, @Cd_Tp_Par, @Par_Moeda,
								@Vlr_Pgto_Rcto, Null, @NewRec, @Usuario
							If @@RowCount = 1 
								Begin 
									--Commit Transaction
									Return 1 
								End 
							Else
								Begin 
									--Rollback Transcation
									Return - 3
								End 
						End 
					Else 
						Begin 
							--Commit Transaction
							Return -2
						End 
				End 
			Else
				Begin 
					--RollBack Transaction
					Return -1 
				End 
		End

	If left(@Num_Proc, 2)  = 'EO'
		Begin
			Update 
				Caixa_Hou_Exp_Out
			Set
				Num_Rcb_HEO = @NewRec 
			Where
				Num_Proc_HEO = @Num_Proc and 
				Num_Lcto = @Lcto and 
				Num_Rcb_HEO = ''
			If @@RowCount > 0 
				Begin 
					Update 
						Referencia
					Set
						Ult_Recibo   = @NewRec 
					Where 
						Ref_Acesso = @Site
					If @@RowCount = 1 
						Begin 
							Exec pLogCaixa_Ins
								'A', @Num_Proc, @Cd_Tp_Tx, @DC, @Lcto, @Vlr_Ref, @Dt_Conv, @Cd_Tp_Par, @Par_Moeda,
								@Vlr_Pgto_Rcto, Null, @NewRec, @Usuario
							If @@RowCount = 1 
								Begin 
									--Commit Transaction
									Return 1 
								End 
							Else
								Begin 
									--Rollback Transcation
									Return - 3
								End 
						End 
					Else 
						Begin 
							--Commit Transaction
							Return -2
						End 
				End 
			Else
				Begin 
					--RollBack Transaction
					Return -1 
				End 
			
		End 


GO
