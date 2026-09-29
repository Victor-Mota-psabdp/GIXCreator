SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pParamContab_Sel  
AS
	Select 
		PC.CtaRecAer, CtaRA.Cd_Cta_Ctb_Red as CtaRecAer_Red, 
		PC.CtaRecMar, CtaRM.Cd_Cta_Ctb_Red as CtaRecMar_Red, 
		PC.CtaRecRec, CtaRR.Cd_Cta_Ctb_Red as CtaRecRec_Red, 
		PC.CtaDesOpr, CtaDO.Cd_Cta_Ctb_Red as CtaDesOpr_Red, 
		PC.CtaDesAdm, CtaDA.Cd_Cta_Ctb_Red as CtaDesAdm_Red, 
		PC.CtaForn, CtaFo.Cd_Cta_Ctb_Red as CtaForn_Red, 
		PC.CtaPrjOpr, CtaPO.Cd_Cta_Ctb_Red as CtaPrjOpr_Red,
		PC.Ult_Contab
	From 
		Param_Contab as PC Join Cta_Ctb as CtaRA  on CtaRA.Cd_Cta_Ctb = PC.CtaRecAer
		Join Cta_Ctb as CtaRM  on CtaRM.Cd_Cta_Ctb = PC.CtaRecMar
		Join Cta_Ctb as CtaRR  on CtaRR.Cd_Cta_Ctb = PC.CtaRecRec
		Join Cta_Ctb as CtaDO  on CtaDO.Cd_Cta_Ctb = PC.CtaDesOpr
		Join Cta_Ctb as CtaDA  on CtaDA.Cd_Cta_Ctb = PC.CtaDesAdm
		Join Cta_Ctb as CtaFo  on CtaFo.Cd_Cta_Ctb = PC.CtaForn
		Join Cta_Ctb as CtaPO  on CtaPO.Cd_Cta_Ctb = PC.CtaPrjOpr

GO
