SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pBxaMaster_Ins    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE pBxaMaster_Ins 
(
@Num_Proc			varchar(14),
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
			If Exists(Select * From Caixa_Mas_Imp_Mar Where Num_Proc_MIM = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_MIM =@DC and Num_Rcb_MIM = '')
				Begin 
					Update 
						Caixa_Mas_Imp_Mar
					Set 
						Num_Lcto = @Num_Lcto, 
						Vlr_Ref_MIM=@Vlr_Ref,
						Dt_Conv_MIM=@Dt_Conv,
						Cd_Tp_Par=@Cd_Tp_Par,
						Par_Moeda_MIM=@Par_Moeda,
						Vlr_Pgto_Rcto_MIM=@Vlr_Pgto_Rcto,
						Num_Rcb_MIM=@Num_Rcb, 
						Dt_Pgto_Rcto_MIM = @Dt_Pgto_Rcto
					Where 
						Num_Proc_MIM = @Num_Proc and 
						Cd_Tp_Tx = @Cd_Tp_Tx and 
						DC_MIM = @DC and 
						Num_Rcb_MIM = ''
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
						Caixa_Mas_Imp_Mar
						(Num_Proc_MIM,Cd_Tp_Tx,DC_MIM,Num_Lcto, Vlr_Ref_MIM,Dt_Conv_MIM,Cd_Tp_Par,Par_Moeda_MIM,Vlr_Pgto_Rcto_MIM,
						Num_Rcb_MIM, Dt_Pgto_Rcto_MIM)
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
			If Exists(Select * From Caixa_Mas_Imp_Aer Where Num_Proc_MIA = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_MIA =@DC and Num_Rcb_MIA = '')
				Begin 
					Update 
						Caixa_Mas_Imp_Aer
					Set 
						Num_Lcto = @Num_Lcto, 
						Vlr_Ref_MIA=@Vlr_Ref,
						Dt_Conv_MIA=@Dt_Conv,
						Cd_Tp_Par=@Cd_Tp_Par,
						Par_Moeda_MIA=@Par_Moeda,
						Vlr_Pgto_Rcto_MIA=@Vlr_Pgto_Rcto,
						Num_Rcb_MIA=@Num_Rcb, 
						Dt_Pgto_Rcto_MIA = @Dt_Pgto_Rcto
					Where 
						Num_Proc_MIA = @Num_Proc and 
						Cd_Tp_Tx = @Cd_Tp_Tx and 
						DC_MIA = @DC and 
						Num_Rcb_MIA = ''
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
						Caixa_Mas_Imp_Aer
						(Num_Proc_MIA,Cd_Tp_Tx,DC_MIA,Num_Lcto, Vlr_Ref_MIA,Dt_Conv_MIA,Cd_Tp_Par,Par_Moeda_MIA,Vlr_Pgto_Rcto_MIA,
						Num_Rcb_MIA, Dt_Pgto_Rcto_MIA)
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
			If Exists(Select * From Caixa_Mas_Exp_Mar Where Num_Proc_MEM = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_MEM =@DC and Num_Rcb_MEM = '')
				Begin 
					Update 
						Caixa_Mas_Exp_Mar
					Set 
						Num_Lcto = @Num_Lcto, 
						Vlr_Ref_MEM=@Vlr_Ref,
						Dt_Conv_MEM=@Dt_Conv,
						Cd_Tp_Par=@Cd_Tp_Par,
						Par_Moeda_MEM=@Par_Moeda,
						Vlr_Pgto_Rcto_MEM=@Vlr_Pgto_Rcto,
						Num_Rcb_MEM=@Num_Rcb, 
						Dt_Pgto_Rcto_MEM = @Dt_Pgto_Rcto
					Where 
						Num_Proc_MEM = @Num_Proc and 
						Cd_Tp_Tx = @Cd_Tp_Tx and 
						DC_MEM = @DC and 
						Num_Rcb_MEM = ''
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
						Caixa_Mas_Exp_Mar
						(Num_Proc_MEM,Cd_Tp_Tx,DC_MEM,Num_Lcto, Vlr_Ref_MEM,Dt_Conv_MEM,Cd_Tp_Par,Par_Moeda_MEM,Vlr_Pgto_Rcto_MEM,
						Num_Rcb_MEM, Dt_Pgto_Rcto_MEM)
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
			If Exists(Select * From Caixa_Mas_Exp_Aer Where Num_Proc_MEA = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_MEA =@DC and Num_Rcb_MEA = '')
				Begin 
					Update 
						Caixa_Mas_Exp_Aer
					Set 
						Num_Lcto = @Num_Lcto, 
						Vlr_Ref_MEA=@Vlr_Ref,
						Dt_Conv_MEA=@Dt_Conv,
						Cd_Tp_Par=@Cd_Tp_Par,
						Par_Moeda_MEA=@Par_Moeda,
						Vlr_Pgto_Rcto_MEA=@Vlr_Pgto_Rcto,
						Num_Rcb_MEA=@Num_Rcb, 
						Dt_Pgto_Rcto_MEA = @Dt_Pgto_Rcto
					Where 
						Num_Proc_MEA = @Num_Proc and 
						Cd_Tp_Tx = @Cd_Tp_Tx and 
						DC_MEA = @DC and 
						Num_Rcb_MEA = ''
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
						Caixa_Mas_Exp_Aer
						(Num_Proc_MEA,Cd_Tp_Tx,DC_MEA,Num_Lcto, Vlr_Ref_MEA,Dt_Conv_MEA,Cd_Tp_Par,Par_Moeda_MEA,Vlr_Pgto_Rcto_MEA,
						Num_Rcb_MEA, Dt_Pgto_Rcto_MEA)
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



GO
