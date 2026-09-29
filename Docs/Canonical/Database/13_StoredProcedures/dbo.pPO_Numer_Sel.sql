SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE pPO_Numer_Sel
(
@Num_Proc	VarChar(14) 
)
AS
	Declare @Modal	Char(2)
	Set @Modal = Left(@Num_Proc, 2) 
	If @Modal = 'IA'
		Select 
			Numero_PO_HIA as Numero_PO
		From 
			PO_HIA 
		Where
			Num_Proc_HIA = @Num_Proc
		Order by 
			Numero_PO_HIA

	If @Modal = 'IM'
		Select 
			Numero_PO_HIM as Numero_PO
		From 
			PO_HIM 
		Where
			Num_Proc_HIM = @Num_Proc
		Order by 
			Numero_PO_HIM
	If @Modal = 'EA'
		Select 
			Numero_PO_HEA as Numero_PO
		From 
			PO_HEA 
		Where
			Num_Proc_HEA = @Num_Proc
		Order by 
			Numero_PO_HEA
	If @Modal = 'EM'
		Select 
			Numero_PO_HEM as Numero_PO
		From 
			PO_HEM 
		Where
			Num_Proc_HEM = @Num_Proc
		Order by 
			Numero_PO_HEM

GO
