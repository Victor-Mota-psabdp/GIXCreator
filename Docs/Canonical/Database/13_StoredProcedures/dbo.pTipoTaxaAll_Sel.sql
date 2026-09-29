SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pTipoTaxaAll_Sel 
(
@Cd_Tp_Tx	VarChar(3)
)
 AS
	Select 
		TT.*, CtbA.Nome_Cta_Ctb as Nome_Cta_Ctb_Atv, CtbP.Nome_Cta_Ctb as Nome_Cta_Ctb_Pas, 
		CtbA.Cd_Cta_Ctb_Red as Cd_Cta_Ctb_Red_Atv, CtbP.Cd_Cta_Ctb_Red as Cd_Cta_Ctb_Red_Pas
		
	From 
		Tipo_Taxa as TT Left Outer Join Cta_Ctb as CtbA on CtbA.Cd_Cta_Ctb = TT.Cd_Cta_Ctb_Atv
		Left Outer Join Cta_Ctb as CtbP on CtbP.Cd_Cta_Ctb = TT.Cd_Cta_Ctb_Pas 
	Where
		Cd_Tp_Tx = @Cd_Tp_Tx 

GO
