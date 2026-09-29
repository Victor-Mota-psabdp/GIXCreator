SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pBaseNF_Sel 
(
@Nota_Fiscal	Varchar(12),
@site		Char(1) 
)
AS
	Select 
		*
	From 
		Base_Nota_Fiscal as BNF Join Pessoa as PS on (BNF.Cd_Pes = PS.Cd_Pes )
		Left Outer Join Endereco as Ender on (PS.Cd_Pes = Ender.Cd_Pes and  Ender.Cd_Tp_End = 'COM')
	Where
		BNF.Nota_Fiscal = @Nota_Fiscal  and 
		BNF.Ref_Acesso = @Site



GO
