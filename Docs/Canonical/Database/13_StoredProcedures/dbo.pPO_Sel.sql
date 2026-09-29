SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pPO_Sel
(
@Num_Proc	VarChar(16),
@Modal 	VarChar(2)
)
AS
	If @Modal = 'IA'
		Select 
			Num_Proc_HIA as Num_Proc,
			ID_PO_HIA as ID_PO, 
			Numero_PO_HIA as Nr_PO,
			Data_PO_HIA  as Data_PO
		From 
			PO_HIA 
		Where
			Num_Proc_HIA = @Num_Proc


	If @Modal = 'EA'
		Select 
			Num_Proc_HEA as Num_Proc,
			ID_PO_HEA as ID_PO, 
			Numero_PO_HEA as Nr_PO,
			Data_PO_HEA  as Data_PO
		From 
			PO_HEA 
		Where
			Num_Proc_HEA = @Num_Proc
	If @Modal = 'IM'
		Select 
			Num_Proc_HIM as Num_Proc,
			ID_PO_HIM as ID_PO, 
			Numero_PO_HIM as Nr_PO,
			Data_PO_HIM  as Data_PO
		From 
			PO_HIM 
		Where
			Num_Proc_HIM = @Num_Proc

	If @Modal = 'EM'
		Select 
			Num_Proc_HEM as Num_Proc,
			ID_PO_HEM as ID_PO, 
			Numero_PO_HEM as Nr_PO,
			Data_PO_HEM  as Data_PO
		From 
			PO_HEM 
		Where
			Num_Proc_HEM = @Num_Proc

GO
