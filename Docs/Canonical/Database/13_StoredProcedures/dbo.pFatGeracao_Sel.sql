SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pFatGeracao_Sel
(
@StrMachine 		VarChar(30)
)
AS

		Select 
			*			
		From 
			Tmp_Fatura  as TP Join  Tipo_Taxa as TT on TT.Cd_Tp_Tx  = TP.TmpCd_Tp_Tx 
		Where 
			StrMachine = @StrMachine 




GO
