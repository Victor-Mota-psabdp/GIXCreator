SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pBxaHouse_Del    Script Date: 28/10/2002 14:37:35 ******/
/****** Object:  Stored Procedure dbo.pBxaHouse_Del    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE [dbo].[pBxaHouse_Del]
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
	Declare @Recibo 	varchar(20) 
	
	If Left(@Num_Proc, 2) = 'IM'
		Begin 
			Begin Transaction 

			If Exists(Select * From Caixa_Hou_Imp_Mar Where Num_Proc_HIM = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HIM =@DC )
				Begin 
					if exists(Select num_proc_him from Caixa_Hou_Imp_Mar Where Num_Proc_HIM = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HIM =@DC and Num_Rcb_HIM is not null AND Num_Rcb_HIM <> '')
						Begin 
							Rollback Transaction 
							Return -19
						End

					Set @Recibo = (Select IsNull(Num_Rcb_HIM , '')  From Caixa_Hou_Imp_Mar Where Num_Proc_HIM = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HIM = @DC )
					Delete
						Caixa_Hou_Imp_Mar
					Where 
						Num_Proc_HIM = @Num_Proc and 
						Cd_Tp_Tx = @Cd_Tp_Tx and 
						DC_HIM = @DC 

					If @@RowCount = 1 	
						Begin 
							Exec pLogCaixa_Ins
								'E', @Num_Proc, @Cd_Tp_Tx, @DC, @Num_Lcto, @Vlr_Ref, @Dt_Conv, @Cd_Tp_Par, @Par_Moeda,
								@Vlr_Pgto_Rcto, @Dt_Pgto_Rcto, @Num_Rcb, @Usuario
							If @@RowCount = 1 
								Begin 
									If @Recibo <> '' 
										Update Caixa_Hou_Imp_Mar Set Num_Rcb_Him = '' where Num_Rcb_Him = @Recibo 	

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
			If Exists(Select * From Caixa_Hou_Imp_Aer Where Num_Proc_HIA = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HIA =@DC )
				Begin 
					if exists(Select num_proc_hia from Caixa_Hou_Imp_aer Where Num_Proc_hia = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_hia =@DC and Num_Rcb_hia is not null AND Num_Rcb_HIA <> '')
						Begin 
							Rollback Transaction 
							Return -19
						End

					Set @Recibo = (Select IsNull(Num_Rcb_HIA , '')  From Caixa_Hou_Imp_Aer Where Num_Proc_HIA = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HIA = @DC )

					Delete
						Caixa_Hou_Imp_Aer
					Where 
						Num_Proc_HIA = @Num_Proc and 
						Cd_Tp_Tx = @Cd_Tp_Tx and 
						DC_HIA = @DC 

					If @@RowCount = 1 	
						Begin 
							If @Recibo <> '' 
								Update Caixa_Hou_Imp_Aer Set Num_Rcb_Hia = '' where Num_Rcb_Hia = @Recibo 	

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
			If Exists(Select * From Caixa_Hou_Exp_Mar Where Num_Proc_HEM = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HEM =@DC )
				Begin 
					if exists(Select num_proc_hem from Caixa_Hou_exp_mar Where Num_Proc_hem = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_hem =@DC and Num_Rcb_hem is not null AND Num_Rcb_HEM <> '')
						Begin 
							Rollback Transaction 
							Return -19
						End

					Set @Recibo = (Select IsNull(Num_Rcb_HEM , '')  From Caixa_Hou_Exp_Mar Where Num_Proc_HEM = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HEM = @DC )

					Delete
						Caixa_Hou_Exp_Mar
					Where 
						Num_Proc_HEM = @Num_Proc and 
						Cd_Tp_Tx = @Cd_Tp_Tx and 
						DC_HEM = @DC 

					If @@RowCount = 1 	
						Begin 

							If @Recibo <> '' 
								Update Caixa_Hou_Exp_Mar Set Num_Rcb_Hem = '' where Num_Rcb_Hem = @Recibo 	

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
			If Exists(Select * From Caixa_Hou_Exp_Aer Where Num_Proc_HEA = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HEA =@DC)
				Begin 
					Set @Recibo = (Select IsNull(Num_Rcb_HEA , '')  From Caixa_Hou_Exp_Aer Where Num_Proc_HEA = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HEA = @DC )
					if exists(Select num_proc_hea from Caixa_Hou_exp_aer Where Num_Proc_hea = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_hea =@DC and Num_Rcb_hea is not null AND Num_Rcb_HEA <> '' )
						Begin 
							Rollback Transaction 
							Return -19
						End

					Delete
						Caixa_Hou_Exp_Aer
					Where 
						Num_Proc_HEA = @Num_Proc and 
						Cd_Tp_Tx = @Cd_Tp_Tx and 
						DC_HEA = @DC 

					If @@RowCount = 1 	
						Begin 
							Exec pLogCaixa_Ins
								'E', @Num_Proc, @Cd_Tp_Tx, @DC, @Num_Lcto, @Vlr_Ref, @Dt_Conv, @Cd_Tp_Par, @Par_Moeda,
								@Vlr_Pgto_Rcto, @Dt_Pgto_Rcto, @Num_Rcb, @Usuario
							If @@RowCount = 1 
								Begin 
									If @Recibo <> '' 
										Update Caixa_Hou_Exp_Aer Set Num_Rcb_HEA = '' where Num_Rcb_HEA = @Recibo 	


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


	If Left(@Num_Proc, 2) = 'IO'
		Begin 
			Begin Transaction 
			If Exists(Select * From Caixa_Hou_Imp_Out Where Num_Proc_HIO = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HIO =@DC)
				Begin 
					Set @Recibo = (Select IsNull(Num_Rcb_HIO , '')  From Caixa_Hou_Imp_Out Where Num_Proc_HIO = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HIO = @DC )
					if exists(Select num_proc_hio from Caixa_Hou_imp_out Where Num_Proc_hio = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_hio =@DC and Num_Rcb_hio is not null AND Num_Rcb_HIO <> '')
						Begin 
							Rollback Transaction 
							Return -19
						End

					Delete
						Caixa_Hou_Imp_Out
					Where 
						Num_Proc_HIO = @Num_Proc and 
						Cd_Tp_Tx = @Cd_Tp_Tx and 
						DC_HIO = @DC 

					If @@RowCount = 1 	
						Begin 
							Exec pLogCaixa_Ins
								'E', @Num_Proc, @Cd_Tp_Tx, @DC, @Num_Lcto, @Vlr_Ref, @Dt_Conv, @Cd_Tp_Par, @Par_Moeda,
								@Vlr_Pgto_Rcto, @Dt_Pgto_Rcto, @Num_Rcb, @Usuario
							If @@RowCount = 1 
								Begin 
									If @Recibo <> '' 
										Update Caixa_Hou_Imp_Out Set Num_Rcb_HIO = '' where Num_Rcb_HIO = @Recibo 	


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


	If Left(@Num_Proc, 2) = 'EO'
		Begin 
			Begin Transaction 
			If Exists(Select * From Caixa_Hou_Exp_Out Where Num_Proc_HEO = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HEO =@DC)
				Begin 
					Set @Recibo = (Select IsNull(Num_Rcb_HEO , '')  From Caixa_Hou_Exp_Out Where Num_Proc_HEO = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HEO = @DC )
					if exists(Select num_proc_heo from Caixa_Hou_exp_out Where Num_Proc_heo = @Num_Proc and Cd_Tp_Tx = @Cd_Tp_Tx and DC_heo =@DC and Num_Rcb_heo is not null AND Num_Rcb_HEO <> '')
						Begin 
							Rollback Transaction 
							Return -19
						End
					Delete
						Caixa_Hou_Exp_Out
					Where 
						Num_Proc_HEO = @Num_Proc and 
						Cd_Tp_Tx = @Cd_Tp_Tx and 
						DC_HEO = @DC 

					If @@RowCount = 1 	
						Begin 
							Exec pLogCaixa_Ins
								'E', @Num_Proc, @Cd_Tp_Tx, @DC, @Num_Lcto, @Vlr_Ref, @Dt_Conv, @Cd_Tp_Par, @Par_Moeda,
								@Vlr_Pgto_Rcto, @Dt_Pgto_Rcto, @Num_Rcb, @Usuario
							If @@RowCount = 1 
								Begin 
									If @Recibo <> '' 
										Update Caixa_Hou_Exp_Out Set Num_Rcb_HEO = '' where Num_Rcb_HEO = @Recibo 	


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
