SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pCxaMIA_Upd
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
--(-2) Erro no Procedimento 
--(-3) Erro na Inserção do Log 
--(-4) Processo de Remessa
 AS
	Declare @NumRec VarChar(12) 
	Begin Transaction 
	Set @NumRec = IsNull((Select Num_Rcb_MIA From Caixa_Mas_Imp_Aer Where Num_Proc_MIA = @Num_Proc_MIA and Cd_Tp_Tx = @Cd_Tp_Tx and DC_MIA = @DC_MIA),'')
	If @NumRec <>  'RM'
		Begin 
			Update 
				Caixa_Mas_Imp_Aer
			Set 
				Vlr_Ref_MIA=@Vlr_Ref_MIA,
				Dt_Conv_MIA=@Dt_Conv_MIA,
				Cd_Tp_Par=@Cd_Tp_Par,
				Par_Moeda_MIA=@Par_Moeda_MIA,
				Vlr_Pgto_Rcto_MIA=@Vlr_Pgto_Rcto_MIA,
				Num_Rcb_MIA=@Num_Rcb_MIA
			Where 
				Num_Proc_MIA = @Num_Proc_MIA and 
				Cd_Tp_Tx = @Cd_Tp_Tx and 
				DC_MIA = @DC_MIA and 
				Num_Lcto=@Num_Lcto
			If @@RowCount = 1 
				Begin 
					Exec pLogCaixa_Ins
						'I', @Num_Proc_MIA, @Cd_Tp_Tx, @DC_MIA, @Num_Lcto, @Vlr_Ref_MIA, @Dt_Conv_MIA, @Cd_Tp_Par, @Par_Moeda_MIA,
						@Vlr_Pgto_Rcto_MIA,Null, @Num_Rcb_MIA, @Usuario
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
