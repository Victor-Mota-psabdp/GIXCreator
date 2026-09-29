SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[pCxaMIA_Ins] 
(
@Num_Proc_MIA		varchar(16),
@Cd_Tp_Tx			varchar(3),
@DC_MIA			char(1),
@Num_Lcto			varchar(12), 
@Vlr_Ref_MIA			float,
@Dt_Conv_MIA		varchar(10), 
@Cd_Tp_Par			varchar(3), 
@Par_Moeda_MIA		float,
@Vlr_Pgto_Rcto_MIA		float,
@Num_Rcb_MIA		varchar(12),
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
	If Not Exists(Select * From Caixa_Mas_Imp_Aer Where Num_Proc_MIA = @Num_Proc_MIA and Cd_Tp_Tx = @Cd_Tp_Tx and DC_MIA =@DC_MIA )
		Begin 
			if left(@Num_Rcb_MIA, 2)  = 'RA' 
				Begin 
					if exists(select num_ref_ra from remessa_aer where num_ref_ra = @Num_Rcb_MIA and concil_ra = 'S' )
						Begin 
							Set  @BooValida = 0
						End 
				End 
			if @booValida = 1 
				Begin 

					Insert Into 
						Caixa_Mas_Imp_Aer
						(Num_Proc_MIA,Cd_Tp_Tx,DC_MIA,Num_Lcto, Vlr_Ref_MIA,Dt_Conv_MIA,Cd_Tp_Par,Par_Moeda_MIA,Vlr_Pgto_Rcto_MIA,
						Num_Rcb_MIA)
					Values 
						(@Num_Proc_MIA,@Cd_Tp_Tx,@DC_MIA,@Num_Lcto,@Vlr_Ref_MIA,@Dt_Conv_MIA,@Cd_Tp_Par,@Par_Moeda_MIA,@Vlr_Pgto_Rcto_MIA,
						@Num_Rcb_MIA)
					If @@RowCount = 1 
						Begin 
							Exec pLogCaixa_Ins
								'I', @Num_Proc_MIA, @Cd_Tp_Tx, @DC_MIA, @Num_Lcto, @Vlr_Ref_MIA, @Dt_Conv_MIA, @Cd_Tp_Par, @Par_Moeda_MIA,
								@Vlr_Pgto_Rcto_MIA, Null, @Num_Rcb_MIA, @Usuario
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
					rollback Transaction
					Return -29

				End
		End
	Else
		Begin 
			RollBack Transaction
			Return -1 			
		End




GO
