SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[pCxaHIA_Ins] 
(
@Num_Proc_HIA		varchar(16),
@Cd_Tp_Tx			varchar(3),
@DC_HIA			char(1),
@Num_Lcto			varchar(12), 
@Vlr_Ref_HIA			float,
@Dt_Conv_HIA			varchar(10), 
@Cd_Tp_Par			varchar(3), 
@Par_Moeda_HIA		float,
@Vlr_Pgto_Rcto_HIA		float,
@Num_Rcb_HIA		varchar(12),
@Usuario			Varchar(6),
@Dt_Pgto_Rcto_HIA		VarChar(12)=Null
)
--Parâmetros de Retorno 
--(1) Procedimento concluído com exito 
--(-1) Violação de Chave 
--(-2) Erro no Procedimento 
--(-3) Erro na Inserção do Log 
 AS
	Declare @BooValida	bit 
	Set @BooValida = 1 
	Begin Transaction 
	If Not Exists(Select * From Caixa_Hou_Imp_Aer Where Num_Proc_HIA = @Num_Proc_HIA and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HIA =@DC_HIA and  Num_Lcto = @Num_Lcto)
		Begin 
			if left(@Num_Rcb_HIA, 2)  = 'RA' 
				Begin 
					if exists(select num_ref_ra from remessa_aer where num_ref_ra = @Num_Rcb_HIA and concil_ra = 'S' )
						Begin 
							Set  @BooValida = 0
						End 
				End 
			if @BooValida = 1 
				Begin
					Insert Into 
						Caixa_Hou_Imp_Aer
						(Num_Proc_HIA,Cd_Tp_Tx,DC_HIA,Num_Lcto, Vlr_Ref_HIA,Dt_Conv_HIA,Cd_Tp_Par,Par_Moeda_HIA,Vlr_Pgto_Rcto_HIA,
						Num_Rcb_HIA, Dt_Pgto_Rcto_HIA)
					Values 
						(@Num_Proc_HIA,@Cd_Tp_Tx,@DC_HIA,@Num_Lcto,@Vlr_Ref_HIA,@Dt_Conv_HIA,@Cd_Tp_Par,@Par_Moeda_HIA,@Vlr_Pgto_Rcto_HIA,
						@Num_Rcb_HIA, @Dt_Pgto_Rcto_HIA)
					If @@RowCount = 1 
						Begin 
							Exec pLogCaixa_Ins
								'I', @Num_Proc_HIA, @Cd_Tp_Tx, @DC_HIA, @Num_Lcto, @Vlr_Ref_HIA, @Dt_Conv_HIA, @Cd_Tp_Par, @Par_Moeda_HIA,
								@Vlr_Pgto_Rcto_HIA, Dt_Pgto_Rcto_HIA, @Num_Rcb_HIA, @Usuario
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
					REturn -29
				End 
		End
	Else
		Begin 
			RollBack Transaction
			Return -1 			
		End


GO
