SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pBxaHouse_Ins    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE [dbo].[pBxaHouse_Ins] 
(
@Num_Proc			varchar(16),
@Cd_Tp_Tx			varchar(3),
@DC				char(1),
@Num_Lcto			varchar(12), 
@Vlr_Ref			float,
@Dt_Conv			varchar(10), 
@Cd_Tp_Par			varchar(3), 
@Par_Moeda			float,
@Vlr_Pgto_Rcto		float,
@Dt_Pgto_Rcto			VarChar(10), 
@Num_Rcb			varchar(12),
@Usuario			Varchar(6)
)
--Parâmetros de Retorno 
--(1) Procedimento concluído com exito 
--(-4) Erro no Procedimento de Insert/Update 
--(-5) Erro na Inserção do Log
 AS
	If Left(@Num_Proc, 2) = 'IM'
		Begin 
			Begin Transaction 
			If Exists(Select * From Caixa_Hou_Imp_Mar Where Num_Proc_HIM = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HIM =@DC and Num_Rcb_HIM = '')
				Begin 
					Update 
						Caixa_Hou_Imp_Mar
					Set 
						Num_Lcto = @Num_Lcto, 
						Vlr_Ref_HIM=@Vlr_Ref,
						Dt_Conv_HIM=@Dt_Conv,
						Cd_Tp_Par=@Cd_Tp_Par,
						Par_Moeda_HIM=@Par_Moeda,
						Vlr_Pgto_Rcto_HIM=@Vlr_Pgto_Rcto,
						Num_Rcb_HIM=@Num_Rcb, 
						Dt_Pgto_Rcto_HIM = @Dt_Pgto_Rcto
					Where 
						Num_Proc_HIM = @Num_Proc and 
						Cd_Tp_Tx = @Cd_Tp_Tx and 
						DC_HIM = @DC and 
						Num_Rcb_HIM = ''
					If @@RowCount = 1 	
						Begin 
							Exec pLogCaixa_Ins
								'I', @Num_Proc, @Cd_Tp_Tx, @DC, @Num_Lcto, @Vlr_Ref, @Dt_Conv, @Cd_Tp_Par, @Par_Moeda,
								@Vlr_Pgto_Rcto, @Dt_Pgto_Rcto, @Num_Rcb, @Usuario
							If @@RowCount = 1 
								Begin 
									Commit Transaction 
									Return 1 
								End 
							Else 
								Begin 
									Rollback Transaction 
									Return - 5 
								End 
						End 
					Else
						Begin 
							RollBack Transaction 
							Return - 4 
						End
				End 
			Else
				Begin 
					Insert Into 
						Caixa_Hou_Imp_Mar
						(Num_Proc_HIM,Cd_Tp_Tx,DC_HIM,Num_Lcto, Vlr_Ref_HIM,Dt_Conv_HIM,Cd_Tp_Par,Par_Moeda_HIM,Vlr_Pgto_Rcto_HIM,
						Num_Rcb_HIM, Dt_Pgto_Rcto_HIM)
					Values 
						(@Num_Proc,@Cd_Tp_Tx,@DC,@Num_Lcto,@Vlr_Ref,@Dt_Conv,@Cd_Tp_Par,@Par_Moeda,@Vlr_Pgto_Rcto,
						@Num_Rcb, @Dt_Pgto_Rcto)
					If @@RowCount = 1 
						Begin 
							Exec pLogCaixa_Ins
								'I', @Num_Proc, @Cd_Tp_Tx, @DC, @Num_Lcto, @Vlr_Ref, @Dt_Conv, @Cd_Tp_Par, @Par_Moeda,
								@Vlr_Pgto_Rcto,@Dt_Pgto_Rcto, @Num_Rcb, @Usuario
							If @@RowCount = 1 
								Begin 
									Commit Transaction 
									Return 1 
								End 
							Else 
								Begin 
									Rollback Transaction 
									Return - 5 
								End 
						End 
				End 
 		End
	If Left(@Num_Proc, 2) = 'IA'
		Begin 
			Begin Transaction 
			If Exists(Select * From Caixa_Hou_Imp_Aer Where Num_Proc_HIA = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HIA =@DC and Num_Rcb_HIA = '')
				Begin 
					Update 
						Caixa_Hou_Imp_Aer
					Set 
						Num_Lcto = @Num_Lcto, 
						Vlr_Ref_HIA=@Vlr_Ref,
						Dt_Conv_HIA=@Dt_Conv,
						Cd_Tp_Par=@Cd_Tp_Par,
						Par_Moeda_HIA=@Par_Moeda,
						Vlr_Pgto_Rcto_HIA=@Vlr_Pgto_Rcto,
						Num_Rcb_HIA=@Num_Rcb, 
						Dt_Pgto_Rcto_HIA = @Dt_Pgto_Rcto
					Where 
						Num_Proc_HIA = @Num_Proc and 
						Cd_Tp_Tx = @Cd_Tp_Tx and 
						DC_HIA = @DC and 
						Num_Rcb_HIA = ''
					If @@RowCount = 1 	
						Begin 
							Exec pLogCaixa_Ins
								'I', @Num_Proc, @Cd_Tp_Tx, @DC, @Num_Lcto, @Vlr_Ref, @Dt_Conv, @Cd_Tp_Par, @Par_Moeda,
								@Vlr_Pgto_Rcto, @Dt_Pgto_Rcto, @Num_Rcb, @Usuario
							If @@RowCount = 1 
								Begin 
									Commit Transaction 
									Return 1 
								End 
							Else 
								Begin 
									Rollback Transaction 
									Return - 5 
								End 
						End 
					Else
						Begin 
							RollBack Transaction 
							Return - 4 
						End
				End 
			Else
				Begin 
					Insert Into 
						Caixa_Hou_Imp_Aer
						(Num_Proc_HIA,Cd_Tp_Tx,DC_HIA,Num_Lcto, Vlr_Ref_HIA,Dt_Conv_HIA,Cd_Tp_Par,Par_Moeda_HIA,Vlr_Pgto_Rcto_HIA,
						Num_Rcb_HIA, Dt_Pgto_Rcto_HIA)
					Values 
						(@Num_Proc,@Cd_Tp_Tx,@DC,@Num_Lcto,@Vlr_Ref,@Dt_Conv,@Cd_Tp_Par,@Par_Moeda,@Vlr_Pgto_Rcto,
						@Num_Rcb, @Dt_Pgto_Rcto)
					If @@RowCount = 1 
						Begin 
							Exec pLogCaixa_Ins
								'I', @Num_Proc, @Cd_Tp_Tx, @DC, @Num_Lcto, @Vlr_Ref, @Dt_Conv, @Cd_Tp_Par, @Par_Moeda,
								@Vlr_Pgto_Rcto,@Dt_Pgto_Rcto, @Num_Rcb, @Usuario
							If @@RowCount = 1 
								Begin 
									Commit Transaction 
									Return 1 
								End 
							Else 
								Begin 
									Rollback Transaction 
									Return - 5 
								End 
						End 
				End 
 		End
	If Left(@Num_Proc, 2) = 'EM'
		Begin 
			Begin Transaction 
			If Exists(Select * From Caixa_Hou_Exp_Mar Where Num_Proc_HEM = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HEM =@DC and Num_Rcb_HEM = '')
				Begin 
					Update 
						Caixa_Hou_Exp_Mar
					Set 
						Num_Lcto = @Num_Lcto, 
						Vlr_Ref_HEM=@Vlr_Ref,
						Dt_Conv_HEM=@Dt_Conv,
						Cd_Tp_Par=@Cd_Tp_Par,
						Par_Moeda_HEM=@Par_Moeda,
						Vlr_Pgto_Rcto_HEM=@Vlr_Pgto_Rcto,
						Num_Rcb_HEM=@Num_Rcb, 
						Dt_Pgto_Rcto_HEM = @Dt_Pgto_Rcto
					Where 
						Num_Proc_HEM = @Num_Proc and 
						Cd_Tp_Tx = @Cd_Tp_Tx and 
						DC_HEM = @DC and 
						Num_Rcb_HEM = ''
					If @@RowCount = 1 	
						Begin 
							Exec pLogCaixa_Ins
								'I', @Num_Proc, @Cd_Tp_Tx, @DC, @Num_Lcto, @Vlr_Ref, @Dt_Conv, @Cd_Tp_Par, @Par_Moeda,
								@Vlr_Pgto_Rcto, @Dt_Pgto_Rcto, @Num_Rcb, @Usuario
							If @@RowCount = 1 
								Begin 
									Commit Transaction 
									Return 1 
								End 
							Else 
								Begin 
									Rollback Transaction 
									Return - 5 
								End 
						End 
					Else
						Begin 
							RollBack Transaction 
							Return - 4 
						End
				End 
			Else
				Begin 
					Insert Into 
						Caixa_Hou_Exp_Mar
						(Num_Proc_HEM,Cd_Tp_Tx,DC_HEM,Num_Lcto, Vlr_Ref_HEM,Dt_Conv_HEM,Cd_Tp_Par,Par_Moeda_HEM,Vlr_Pgto_Rcto_HEM,
						Num_Rcb_HEM, Dt_Pgto_Rcto_HEM)
					Values 
						(@Num_Proc,@Cd_Tp_Tx,@DC,@Num_Lcto,@Vlr_Ref,@Dt_Conv,@Cd_Tp_Par,@Par_Moeda,@Vlr_Pgto_Rcto,
						@Num_Rcb, @Dt_Pgto_Rcto)
					If @@RowCount = 1 
						Begin 
							Exec pLogCaixa_Ins
								'I', @Num_Proc, @Cd_Tp_Tx, @DC, @Num_Lcto, @Vlr_Ref, @Dt_Conv, @Cd_Tp_Par, @Par_Moeda,
								@Vlr_Pgto_Rcto,@Dt_Pgto_Rcto, @Num_Rcb, @Usuario
							If @@RowCount = 1 
								Begin 
									Commit Transaction 
									Return 1 
								End 
							Else 
								Begin 
									Rollback Transaction 
									Return - 5 
								End 
						End 
				End 
 		End
	If Left(@Num_Proc, 2) = 'EA'
		Begin 
			Begin Transaction 
			If Exists(Select * From Caixa_Hou_Exp_Aer Where Num_Proc_HEA = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HEA =@DC and Num_Rcb_HEA = '')
				Begin 
					Update 
						Caixa_Hou_Exp_Aer
					Set 
						Num_Lcto = @Num_Lcto, 
						Vlr_Ref_HEA=@Vlr_Ref,
						Dt_Conv_HEA=@Dt_Conv,
						Cd_Tp_Par=@Cd_Tp_Par,
						Par_Moeda_HEA=@Par_Moeda,
						Vlr_Pgto_Rcto_HEA=@Vlr_Pgto_Rcto,
						Num_Rcb_HEA=@Num_Rcb, 
						Dt_Pgto_Rcto_HEA = @Dt_Pgto_Rcto
					Where 
						Num_Proc_HEA = @Num_Proc and 
						Cd_Tp_Tx = @Cd_Tp_Tx and 
						DC_HEA = @DC and 
						Num_Rcb_HEA = ''
					If @@RowCount = 1 	
						Begin 
							Exec pLogCaixa_Ins
								'I', @Num_Proc, @Cd_Tp_Tx, @DC, @Num_Lcto, @Vlr_Ref, @Dt_Conv, @Cd_Tp_Par, @Par_Moeda,
								@Vlr_Pgto_Rcto, @Dt_Pgto_Rcto, @Num_Rcb, @Usuario
							If @@RowCount = 1 
								Begin 
									Commit Transaction 
									Return 1 
								End 
							Else 
								Begin 
									Rollback Transaction 
									Return - 5 
								End 
						End 
					Else
						Begin 
							RollBack Transaction 
							Return - 4 
						End
				End 
			Else
				Begin 
					Insert Into 
						Caixa_Hou_Exp_Aer
						(Num_Proc_HEA,Cd_Tp_Tx,DC_HEA,Num_Lcto, Vlr_Ref_HEA,Dt_Conv_HEA,Cd_Tp_Par,Par_Moeda_HEA,Vlr_Pgto_Rcto_HEA,
						Num_Rcb_HEA, Dt_Pgto_Rcto_HEA)
					Values 
						(@Num_Proc,@Cd_Tp_Tx,@DC,@Num_Lcto,@Vlr_Ref,@Dt_Conv,@Cd_Tp_Par,@Par_Moeda,@Vlr_Pgto_Rcto,
						@Num_Rcb, @Dt_Pgto_Rcto)
					If @@RowCount = 1 
						Begin 
							Exec pLogCaixa_Ins
								'I', @Num_Proc, @Cd_Tp_Tx, @DC, @Num_Lcto, @Vlr_Ref, @Dt_Conv, @Cd_Tp_Par, @Par_Moeda,
								@Vlr_Pgto_Rcto,@Dt_Pgto_Rcto, @Num_Rcb, @Usuario
							If @@RowCount = 1 
								Begin 
									Commit Transaction 
									Return 1 
								End 
							Else 
								Begin 
									Rollback Transaction 
									Return - 5 
								End 
						End 
				End 
 		End

	If Left(@Num_Proc, 2) = 'EO' 
		Begin 
			Begin Transaction 
			If Exists(Select * From Caixa_Hou_Exp_Out Where Num_Proc_HEO = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HEO =@DC and Num_Rcb_HEO = '')
				Begin 
					Update 
						Caixa_Hou_Exp_Out
					Set 
						Num_Lcto = @Num_Lcto, 
						Vlr_Ref_HEO=@Vlr_Ref,
						Dt_Conv_HEO=@Dt_Conv,
						Cd_Tp_Par=@Cd_Tp_Par,
						Par_Moeda_HEO=@Par_Moeda,
						Vlr_Pgto_Rcto_HEO=@Vlr_Pgto_Rcto,
						Num_Rcb_HEO=@Num_Rcb, 
						Dt_Pgto_Rcto_HEO = @Dt_Pgto_Rcto
					Where 
						Num_Proc_HEO = @Num_Proc and 
						Cd_Tp_Tx = @Cd_Tp_Tx and 
						DC_HEO = @DC and 
						Num_Rcb_HEO = ''
					If @@RowCount = 1 	
						Begin 
							Exec pLogCaixa_Ins
								'I', @Num_Proc, @Cd_Tp_Tx, @DC, @Num_Lcto, @Vlr_Ref, @Dt_Conv, @Cd_Tp_Par, @Par_Moeda,
								@Vlr_Pgto_Rcto, @Dt_Pgto_Rcto, @Num_Rcb, @Usuario
							If @@RowCount = 1 
								Begin 
									Commit Transaction 
									Return 1 
								End 
							Else 
								Begin 
									Rollback Transaction 
									Return - 5 
								End 
						End 
					Else
						Begin 
							RollBack Transaction 
							Return - 4 
						End
				End 
			Else
				Begin 
					Insert Into 
						Caixa_Hou_Exp_Out
						(Num_Proc_HEO,Cd_Tp_Tx,DC_HEO,Num_Lcto, Vlr_Ref_HEO,Dt_Conv_HEO,Cd_Tp_Par,Par_Moeda_HEO,Vlr_Pgto_Rcto_HEO,
						Num_Rcb_HEO, Dt_Pgto_Rcto_HEO, Num_ND_HEO)
					Values 
						(@Num_Proc,@Cd_Tp_Tx,@DC,@Num_Lcto,@Vlr_Ref,@Dt_Conv,@Cd_Tp_Par,@Par_Moeda,@Vlr_Pgto_Rcto,
						@Num_Rcb, @Dt_Pgto_Rcto, '')
					If @@RowCount = 1 
						Begin 
							Exec pLogCaixa_Ins
								'I', @Num_Proc, @Cd_Tp_Tx, @DC, @Num_Lcto, @Vlr_Ref, @Dt_Conv, @Cd_Tp_Par, @Par_Moeda,
								@Vlr_Pgto_Rcto,@Dt_Pgto_Rcto, @Num_Rcb, @Usuario
							If @@RowCount = 1 
								Begin 
									Commit Transaction 
									Return 1 
								End 
							Else 
								Begin 
									Rollback Transaction 
									Return - 5 
								End 
						End 
				End 
 		End


	If Left(@Num_Proc, 2) = 'IO' 
		Begin 
			Begin Transaction 
			If Exists(Select * From Caixa_Hou_Imp_Out Where Num_Proc_HIO = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HIO =@DC and Num_Rcb_HIO = '')
				Begin 
					Update 
						Caixa_Hou_Imp_Out
					Set 
						Num_Lcto = @Num_Lcto, 
						Vlr_Ref_HIO=@Vlr_Ref,
						Dt_Conv_HIO=@Dt_Conv,
						Cd_Tp_Par=@Cd_Tp_Par,
						Par_Moeda_HIO=@Par_Moeda,
						Vlr_Pgto_Rcto_HIO=@Vlr_Pgto_Rcto,
						Num_Rcb_HIO=@Num_Rcb, 
						Dt_Pgto_Rcto_HIO = @Dt_Pgto_Rcto
					Where 
						Num_Proc_HIO = @Num_Proc and 
						Cd_Tp_Tx = @Cd_Tp_Tx and 
						DC_HIO = @DC and 
						Num_Rcb_HIO = ''
					If @@RowCount = 1 	
						Begin 
							Exec pLogCaixa_Ins
								'I', @Num_Proc, @Cd_Tp_Tx, @DC, @Num_Lcto, @Vlr_Ref, @Dt_Conv, @Cd_Tp_Par, @Par_Moeda,
								@Vlr_Pgto_Rcto, @Dt_Pgto_Rcto, @Num_Rcb, @Usuario
							If @@RowCount = 1 
								Begin 
									Commit Transaction 
									Return 1 
								End 
							Else 
								Begin 
									Rollback Transaction 
									Return - 5 
								End 
						End 
					Else
						Begin 
							RollBack Transaction 
							Return - 4 
						End
				End 
			Else
				Begin 
					Insert Into 
						Caixa_Hou_Imp_Out
						(Num_Proc_HIO,Cd_Tp_Tx,DC_HIO,Num_Lcto, Vlr_Ref_HIO,Dt_Conv_HIO,Cd_Tp_Par,Par_Moeda_HIO,Vlr_Pgto_Rcto_HIO,
						Num_Rcb_HIO, Dt_Pgto_Rcto_HIO, Num_ND_HIO)
					Values 
						(@Num_Proc,@Cd_Tp_Tx,@DC,@Num_Lcto,@Vlr_Ref,@Dt_Conv,@Cd_Tp_Par,@Par_Moeda,@Vlr_Pgto_Rcto,
						@Num_Rcb, @Dt_Pgto_Rcto, '')
					If @@RowCount = 1 
						Begin 
							Exec pLogCaixa_Ins
								'I', @Num_Proc, @Cd_Tp_Tx, @DC, @Num_Lcto, @Vlr_Ref, @Dt_Conv, @Cd_Tp_Par, @Par_Moeda,
								@Vlr_Pgto_Rcto,@Dt_Pgto_Rcto, @Num_Rcb, @Usuario
							If @@RowCount = 1 
								Begin 
									Commit Transaction 
									Return 1 
								End 
							Else 
								Begin 
									Rollback Transaction 
									Return - 5 
								End 
						End 
				End 
 		End




GO
