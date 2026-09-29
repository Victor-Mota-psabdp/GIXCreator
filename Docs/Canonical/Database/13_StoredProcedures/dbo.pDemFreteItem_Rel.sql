SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pDemFreteItem_Rel
(
@StrMachine		VarChar(30)
)
AS
	Select * from Tmp_Item_Demonst_Frete Where StrMachine = @StrMachine Order by TmpLine
GO
