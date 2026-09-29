SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pParamContab_InsUpd 
(
@CtaRecAer		varchar(13),
@CtaRecMar		varchar(13),
@CtaRecRec		varchar(13),
@CtaDesOpr		varchar(13),
@CtaDesAdm		varchar(13),
@CtaForn		varchar(13),
@CtaPrjOpr		varchar(13),
@Ult_Contab		VarChar(7)
)
AS
	If not Exists(Select * from Param_Contab)
		Insert Into 
			Param_Contab (CtaRecAer, CtaRecMar, CtaRecRec, CtaDesOpr, CtaDesAdm, CtaForn, CtaPrjOpr)
		Values 
			(@CtaRecAer, @CtaRecMar, @CtaRecRec, @CtaDesOpr, @CtaDesAdm, @CtaForn, @CtaPrjOpr)


	Else
		Update 
			Param_Contab 
		Set 
			CtaRecAer = @CtaRecAer,
			CtaRecMar = @CtaRecMar,
			CtaRecRec = @CtaRecRec, 
			CtaDesOpr = @CtaDesOpr, 
			CtaDesAdm = @CtaDesAdm, 
			CtaForn = @CtaForn,
			CtaPrjOpr = @CtaPrjOpr,
			Ult_Contab = @Ult_Contab

GO
