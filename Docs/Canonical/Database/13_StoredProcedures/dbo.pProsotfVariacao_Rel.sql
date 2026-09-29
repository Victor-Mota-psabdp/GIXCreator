SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pProsotfVariacao_Rel 
(
@StrMachine		VarChar(30)
)
AS

	Select 
		* , TT.Nome_Tp_Tx, Cta.Nome_Cta_Ctb
	From 
		TMP_Prosoft TMP Join Tipo_Taxa TT on TT.Cd_Tp_Tx = Right(TMP.Num_Doc, 3) 
		Join Cta_Ctb Cta on Cta.Cd_Cta_Ctb_Red = TMP.Cta_Ctb 
	Where
		IDMachine = @StrMachine and len(Cta.Cd_Cta_Ctb) =13
GO
