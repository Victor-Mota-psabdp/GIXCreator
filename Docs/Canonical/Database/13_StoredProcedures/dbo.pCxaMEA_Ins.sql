SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[pCxaMEA_Ins] 
(
@Num_Proc_MEA		varchar(16),
@Cd_Tp_Tx			varchar(3),
@DC_MEA			char(1),
@Num_Lcto			varchar(12), 
@Vlr_Ref_MEA			float,
@Dt_Conv_MEA		varchar(10), 
@Cd_Tp_Par			varchar(3), 
@Par_Moeda_MEA		float,
@Vlr_Pgto_Rcto_MEA		float,
@Num_Rcb_MEA		varchar(12),
@Usuario			Varchar(6)
)
--Parâmetros de Retorno 
--(1) Procedimento concluído com exito 
--(-1) Violação de Chave 
--(-2) Erro no Procedimento 
--(-3) Erro na Inserção do Log 
 AS
	Declare @booValida bit
	Set @booValida = 1
	Begin Transaction 
	If Not Exists(Select * From Caixa_Mas_Exp_Aer Where Num_Proc_MEA = @Num_Proc_MEA and Cd_Tp_Tx = @Cd_Tp_Tx and DC_MEA =@DC_MEA )
		Begin 
			if left(@Num_Rcb_MEA, 2)  = 'RA' 
				Begin 
					if exists(select num_ref_ra from remessa_aer where num_ref_ra = @Num_Rcb_MEA and concil_ra = 'S' )
						Begin 
							Set  @BooValida = 0
						End 
				End
			If @booValida =  1 
				Begin 
					Insert Into 
						Caixa_Mas_Exp_Aer
						(Num_Proc_MEA,Cd_Tp_Tx,DC_MEA,Num_Lcto, Vlr_Ref_MEA,Dt_Conv_MEA,Cd_Tp_Par,Par_Moeda_MEA,Vlr_Pgto_Rcto_MEA,
						Num_Rcb_MEA)
					Values 
						(@Num_Proc_MEA,@Cd_Tp_Tx,@DC_MEA,@Num_Lcto,@Vlr_Ref_MEA,@Dt_Conv_MEA,@Cd_Tp_Par,@Par_Moeda_MEA,@Vlr_Pgto_Rcto_MEA,
						@Num_Rcb_MEA)
					If @@RowCount = 1 
						Begin 
							Exec pLogCaixa_Ins
								'I', @Num_Proc_MEA, @Cd_Tp_Tx, @DC_MEA, @Num_Lcto, @Vlr_Ref_MEA, @Dt_Conv_MEA, @Cd_Tp_Par, @Par_Moeda_MEA,
								@Vlr_Pgto_Rcto_MEA, Null, @Num_Rcb_MEA, @Usuario
							If @@RowCount = 1 
								Begin 
									Commit Transaction 
									Return 1 
								End 
							Else 
								Begin 
									Rollback Transaction 
									Return -3 
								End 
						End 
					Else
						Begin 
							RollBack Transaction 
							Return -2
						End 
				End
			Else
				Begin 
					Rollback Transaction
					Return -29

				End
		End
	Else
		Begin 
			RollBack Transaction
			Return -1 			
		End




GO
