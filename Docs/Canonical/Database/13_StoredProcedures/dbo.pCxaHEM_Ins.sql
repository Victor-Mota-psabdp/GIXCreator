SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[pCxaHEM_Ins] 
(
@Num_Proc_HEM		varchar(16),
@Cd_Tp_Tx			varchar(3),
@DC_HEM			char(1),
@Num_Lcto			varchar(12), 
@Vlr_Ref_HEM			float,
@Dt_Conv_HEM		varchar(10), 
@Cd_Tp_Par			varchar(3), 
@Par_Moeda_HEM		float,
@Vlr_Pgto_Rcto_HEM		float,
@Num_Rcb_HEM		varchar(12),
@Usuario			Varchar(6),
@Dt_Pgto_Rcto_HEM		VarChar(12)=Null
)
--Parâmetros de Retorno 
--(1) Procedimento concluído com exito 
--(-1) Violação de Chave 
--(-2) Erro no Procedimento 
--(-3) Erro na Inserção do Log 
 AS
	Declare @Boovalida bit
	Set @BooValida = 1
	Begin Transaction 
	If Not Exists(Select * From Caixa_Hou_Exp_Mar Where Num_Proc_HEM = @Num_Proc_HEM and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HEM =@DC_HEM )
		Begin 
			if left(@Num_Rcb_HEM, 2) = 'RM' 
				Begin 
					if exists(select num_ref_rm from remessa_mar where num_ref_rm = @Num_Rcb_HEM and concil_rm = 'S' )
						Begin 
							Set  @BooValida = 0
						End 
				End 
			if @booValida = 1 
				Begin 
					Insert Into 
						Caixa_Hou_Exp_Mar
						(Num_Proc_HEM,Cd_Tp_Tx,DC_HEM,Num_Lcto, Vlr_Ref_HEM,Dt_Conv_HEM,Cd_Tp_Par,Par_Moeda_HEM,Vlr_Pgto_Rcto_HEM,
						Num_Rcb_HEM, Dt_Pgto_Rcto_HEM)
					Values 
						(@Num_Proc_HEM,@Cd_Tp_Tx,@DC_HEM,@Num_Lcto,@Vlr_Ref_HEM,@Dt_Conv_HEM,@Cd_Tp_Par,@Par_Moeda_HEM,@Vlr_Pgto_Rcto_HEM,
						@Num_Rcb_HEM, @Dt_Pgto_Rcto_HEM)
					If @@RowCount = 1 
						Begin 
							Exec pLogCaixa_Ins
								'I', @Num_Proc_HEM, @Cd_Tp_Tx, @DC_HEM, @Num_Lcto, @Vlr_Ref_HEM, @Dt_Conv_HEM, @Cd_Tp_Par, @Par_Moeda_HEM,
								@Vlr_Pgto_Rcto_HEM, @Dt_Pgto_Rcto_HEM, @Num_Rcb_HEM, @Usuario
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
					Return - 29 
				End
		End
	Else
		Begin 
			RollBack Transaction
			Return -1 			
		End


GO
