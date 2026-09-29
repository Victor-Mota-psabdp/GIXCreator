SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCxaHIM_Ins    Script Date: 17/10/2002 07:32:48 ******/
CREATE PROCEDURE [dbo].[pCxaHIM_Ins] 
(
@Num_Proc_HIM		varchar(16),
@Cd_Tp_Tx			varchar(3),
@DC_HIM			char(1),
@Num_Lcto			varchar(12), 
@Vlr_Ref_HIM			float,
@Dt_Conv_HIM			varchar(10), 
@Cd_Tp_Par			varchar(3), 
@Par_Moeda_HIM		float,
@Vlr_Pgto_Rcto_HIM		float,
@Num_Rcb_HIM		varchar(12),
@Usuario			Varchar(6),
@Dt_Pgto_Rcto_HIM		VarChar(12)
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
	If Not Exists(Select * From Caixa_Hou_Imp_Mar Where Num_Proc_HIM = @Num_Proc_HIM and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HIM =@DC_HIM and  Num_Lcto = @Num_Lcto)
		Begin 
			if left(@Num_Rcb_HIM, 2)  = 'RM' 
				Begin 
					if exists(select num_ref_rm from remessa_mar where num_ref_rm = @Num_Rcb_HIM and concil_rM = 'S' )
						Begin 
							Set  @BooValida = 0
						End 
				End 
			If @booValida = 1 
				Begin
					Insert Into 
						Caixa_Hou_Imp_Mar
						(Num_Proc_HIM,Cd_Tp_Tx,DC_HIM,Num_Lcto, Vlr_Ref_HIM,Dt_Conv_HIM,Cd_Tp_Par,Par_Moeda_HIM,Vlr_Pgto_Rcto_HIM,
						Num_Rcb_HIM, Dt_Pgto_Rcto_HIM)
					Values 
						(@Num_Proc_HIM,@Cd_Tp_Tx,@DC_HIM,@Num_Lcto,@Vlr_Ref_HIM,@Dt_Conv_HIM,@Cd_Tp_Par,@Par_Moeda_HIM,@Vlr_Pgto_Rcto_HIM,
						@Num_Rcb_HIM, @Dt_Pgto_Rcto_HIM)
					If @@RowCount = 1 
						Begin 
							Exec pLogCaixa_Ins
								'I', @Num_Proc_HIM, @Cd_Tp_Tx, @DC_HIM, @Num_Lcto, @Vlr_Ref_HIM, @Dt_Conv_HIM, @Cd_Tp_Par, @Par_Moeda_HIM,
								@Vlr_Pgto_Rcto_HIM, @Dt_Pgto_Rcto_HIM, @Num_Rcb_HIM, @Usuario
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
					REturn - 29
				End
		End
	Else
		Begin 
			RollBack Transaction
			Return -1 			
		End


GO
