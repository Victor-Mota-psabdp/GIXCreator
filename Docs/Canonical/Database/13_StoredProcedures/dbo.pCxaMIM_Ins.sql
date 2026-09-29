SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCxaMIM_Ins    Script Date: 17/10/2002 07:32:48 ******/
CREATE PROCEDURE [dbo].[pCxaMIM_Ins] 
(
@Num_Proc_MIM		varchar(16),
@Cd_Tp_Tx			varchar(3),
@DC_MIM			char(1),
@Num_Lcto			varchar(12), 
@Vlr_Ref_MIM			float,
@Dt_Conv_MIM		varchar(10), 
@Cd_Tp_Par			varchar(3), 
@Par_Moeda_MIM		float,
@Vlr_Pgto_Rcto_MIM		float,
@Num_Rcb_MIM		varchar(12),
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
	If Not Exists(Select * From Caixa_Mas_Imp_Mar Where Num_Proc_MIM = @Num_Proc_MIM and Cd_Tp_Tx = @Cd_Tp_Tx and DC_MIM =@DC_MIM )
		Begin 
			if left(@Num_Rcb_MIM, 2)  = 'RM' 
				Begin 
					if exists(select num_ref_rm from remessa_mar where num_ref_rm = @Num_Rcb_MIM and concil_rm = 'S' )
						Begin 
							Set  @BooValida = 0
						End 
				End 
			If @booValida = 1 
				Begin 
					Insert Into 
						Caixa_Mas_Imp_Mar
						(Num_Proc_MIM,Cd_Tp_Tx,DC_MIM,Num_Lcto, Vlr_Ref_MIM,Dt_Conv_MIM,Cd_Tp_Par,Par_Moeda_MIM,Vlr_Pgto_Rcto_MIM,
						Num_Rcb_MIM)
					Values 
						(@Num_Proc_MIM,@Cd_Tp_Tx,@DC_MIM,@Num_Lcto,@Vlr_Ref_MIM,@Dt_Conv_MIM,@Cd_Tp_Par,@Par_Moeda_MIM,@Vlr_Pgto_Rcto_MIM,
						@Num_Rcb_MIM)
					If @@RowCount = 1 
						Begin 
							Exec pLogCaixa_Ins
								'I', @Num_Proc_MIM, @Cd_Tp_Tx, @DC_MIM, @Num_Lcto, @Vlr_Ref_MIM, @Dt_Conv_MIM, @Cd_Tp_Par, @Par_Moeda_MIM,
								@Vlr_Pgto_Rcto_MIM, Null, @Num_Rcb_MIM, @Usuario
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
			ELse
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
