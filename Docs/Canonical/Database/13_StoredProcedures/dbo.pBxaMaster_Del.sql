SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pBxaMaster_Del    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE [dbo].[pBxaMaster_Del]
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
			If Exists(Select * From Caixa_Mas_Imp_Mar Where Num_Proc_MIM = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_MIM =@DC and Num_Rcb_MIM = '')
				Begin 
					if exists(Select num_proc_mim from Caixa_mas_Imp_Mar Where Num_Proc_mim = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_mim =@DC and Num_Rcb_mim is not null AND Num_Rcb_mim <> '')
						Begin 
							Rollback Transaction 
							Return -19
						End

					Delete
						Caixa_Mas_Imp_Mar
					Where 
						Num_Proc_MIM = @Num_Proc and 
						Cd_Tp_Tx = @Cd_Tp_Tx and 
						DC_MIM = @DC and 
						Num_Rcb_MIM = ''
					If @@RowCount = 1 	
						Begin 
							Exec pLogCaixa_Ins
								'E', @Num_Proc, @Cd_Tp_Tx, @DC, @Num_Lcto, @Vlr_Ref, @Dt_Conv, @Cd_Tp_Par, @Par_Moeda,
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
					RollBack Transaction 
					Return -1 
				End 
 		End
	If Left(@Num_Proc, 2) = 'IA'
		Begin 
			Begin Transaction 
			If Exists(Select * From Caixa_Mas_Imp_Aer Where Num_Proc_MIA = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_MIA =@DC and Num_Rcb_MIA = '')
				Begin 
					if exists(Select num_proc_mia from Caixa_mas_Imp_aer Where Num_Proc_mia = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_mia =@DC and Num_Rcb_mia is not null AND Num_Rcb_miA <> '')
						Begin 
							Rollback Transaction 
							Return -19
						End
					Delete
						Caixa_Mas_Imp_Aer
					Where 
						Num_Proc_MIA = @Num_Proc and 
						Cd_Tp_Tx = @Cd_Tp_Tx and 
						DC_MIA = @DC and 
						Num_Rcb_MIA = ''
					If @@RowCount = 1 	
						Begin 
							Exec pLogCaixa_Ins
								'E', @Num_Proc, @Cd_Tp_Tx, @DC, @Num_Lcto, @Vlr_Ref, @Dt_Conv, @Cd_Tp_Par, @Par_Moeda,
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
					Rollback Transaction 
					Return - 1 
				End 
 		End
	If Left(@Num_Proc, 2) = 'EM'
		Begin 
			Begin Transaction 
			If Exists(Select * From Caixa_Mas_Exp_Mar Where Num_Proc_MEM = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_MEM =@DC and Num_Rcb_MEM = '')
				Begin 
					if exists(Select num_proc_mem from Caixa_mas_exp_mar Where Num_Proc_mem = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_mem =@DC and Num_Rcb_mem is not null AND Num_Rcb_mem <> '')
						Begin 
							Rollback Transaction 
							Return -19
						End
					Delete
						Caixa_Mas_Exp_Mar
					Where 
						Num_Proc_MEM = @Num_Proc and 
						Cd_Tp_Tx = @Cd_Tp_Tx and 
						DC_MEM = @DC and 
						Num_Rcb_MEM = ''
					If @@RowCount = 1 	
						Begin 
							Exec pLogCaixa_Ins
								'E', @Num_Proc, @Cd_Tp_Tx, @DC, @Num_Lcto, @Vlr_Ref, @Dt_Conv, @Cd_Tp_Par, @Par_Moeda,
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
					Rollback Transaction 
					Return - 1
				End 
 		End
	If Left(@Num_Proc, 2) = 'EA'
		Begin 
			Begin Transaction 
			If Exists(Select * From Caixa_Mas_Exp_Aer Where Num_Proc_MEA = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_MEA =@DC and Num_Rcb_MEA = '')
				Begin 
					if exists(Select num_proc_mea from Caixa_mas_exp_aer Where Num_Proc_mea = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_mea =@DC and Num_Rcb_mea is not null AND Num_Rcb_mea <> '')
						Begin 
							Rollback Transaction 
							Return -19
						End
					Delete
						Caixa_Mas_Exp_Aer
					Where 
						Num_Proc_MEA = @Num_Proc and 
						Cd_Tp_Tx = @Cd_Tp_Tx and 
						DC_MEA = @DC and 
						Num_Rcb_MEA = ''
					If @@RowCount = 1 	
						Begin 
							Exec pLogCaixa_Ins
								'E', @Num_Proc, @Cd_Tp_Tx, @DC, @Num_Lcto, @Vlr_Ref, @Dt_Conv, @Cd_Tp_Par, @Par_Moeda,
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
					Commit Transaction 
					Return 1 
				End 
 		End





GO
