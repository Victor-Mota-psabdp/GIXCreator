SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCxaMIM_Upd    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pCxaMIM_Upd
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
--(-2) Erro no Procedimento 
--(-3) Erro na Inserção do Log 
--(-4) Processo de Remessa
 AS
	Declare @NumRec VarChar(12) 
	Begin Transaction 
	Set @NumRec = IsNull((Select Num_Rcb_MIM From Caixa_Mas_Imp_Mar Where Num_Proc_MIM = @Num_Proc_MIM and Cd_Tp_Tx = @Cd_Tp_Tx and DC_MIM = @DC_MIM),'')
	If @NumRec <>  'RM'
		Begin 
			Update 
				Caixa_Mas_Imp_Mar
			Set 
				Vlr_Ref_MIM=@Vlr_Ref_MIM,
				Dt_Conv_MIM=@Dt_Conv_MIM,
				Cd_Tp_Par=@Cd_Tp_Par,
				Par_Moeda_MIM=@Par_Moeda_MIM,
				Vlr_Pgto_Rcto_MIM=@Vlr_Pgto_Rcto_MIM,
				Num_Rcb_MIM=@Num_Rcb_MIM
			Where 
				Num_Proc_MIM = @Num_Proc_MIM and 
				Cd_Tp_Tx = @Cd_Tp_Tx and 
				DC_MIM = @DC_MIM and 
				Num_Lcto=@Num_Lcto
			If @@RowCount = 1 
				Begin 
					Exec pLogCaixa_Ins
						'I', @Num_Proc_MIM, @Cd_Tp_Tx, @DC_MIM, @Num_Lcto, @Vlr_Ref_MIM, @Dt_Conv_MIM, @Cd_Tp_Par, @Par_Moeda_MIM,
						@Vlr_Pgto_Rcto_MIM,Null, @Num_Rcb_MIM, @Usuario
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
			RollBack Transaction
			Return -4 
		End



GO
