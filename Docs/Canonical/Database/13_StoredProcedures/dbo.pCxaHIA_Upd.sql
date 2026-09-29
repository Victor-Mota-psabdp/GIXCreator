SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pCxaHIA_Upd
(
@Num_Proc_HIA		varchar(16),
@Cd_Tp_Tx			varchar(3),
@DC_HIA			char(1),
@Num_Lcto			varchar(12), 
@Vlr_Ref_HIA			float,
@Dt_Conv_HIA		varchar(10), 
@Cd_Tp_Par			varchar(3), 
@Par_Moeda_HIA		float,
@Vlr_Pgto_Rcto_HIA		float,
@Num_Rcb_HIA		varchar(12),
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
	Set @NumRec = IsNull((Select Num_Rcb_HIA From Caixa_Hou_Imp_Aer Where Num_Proc_HIA = @Num_Proc_HIA and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HIA = @DC_HIA),'')
	If @NumRec <>  'RM'
		Begin 
			Update 
				Caixa_Hou_Imp_Aer
			Set 
				Vlr_Ref_HIA=@Vlr_Ref_HIA,
				Dt_Conv_HIA=@Dt_Conv_HIA,
				Cd_Tp_Par=@Cd_Tp_Par,
				Par_Moeda_HIA=@Par_Moeda_HIA,
				Vlr_Pgto_Rcto_HIA=@Vlr_Pgto_Rcto_HIA,
				Num_Rcb_HIA=@Num_Rcb_HIA
			Where 
				Num_Proc_HIA = @Num_Proc_HIA and 
				Cd_Tp_Tx = @Cd_Tp_Tx and 
				DC_HIA = @DC_HIA and
				Num_Lcto=@Num_Lcto
			If @@RowCount = 1 
				Begin 
					Exec pLogCaixa_Ins
						'I', @Num_Proc_HIA, @Cd_Tp_Tx, @DC_HIA, @Num_Lcto, @Vlr_Ref_HIA, @Dt_Conv_HIA, @Cd_Tp_Par, @Par_Moeda_HIA,
						@Vlr_Pgto_Rcto_HIA,Null, @Num_Rcb_HIA, @Usuario
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
