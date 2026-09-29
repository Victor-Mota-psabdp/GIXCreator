SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pProsotfVariacaoRes_Rel 
(
@StrMachine		VarChar(30)
)
AS

	Select 
		Cd_Cta_Ctb_Red, Cta.Nome_Cta_Ctb, TMP.DC_Tax, Sum(Vlr_Lcto) Total 
	From 
		TMP_Prosoft TMP Join Tipo_Taxa TT on TT.Cd_Tp_Tx = Right(TMP.Num_Doc, 3) 
		Join Cta_Ctb Cta on Cta.Cd_Cta_Ctb_Red = TMP.Cta_Ctb and Cta.Ck_Ativo = 'S'
	Where
		IDMachine = @StrMachine
	Group by 
		Cd_Cta_Ctb_Red, Cta.Nome_Cta_Ctb, TMP.DC_Tax

GO
