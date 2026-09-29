SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Procedure [dbo].[spBuscaPO_Sel]
		@numero	Varchar(100),
		@ID_DC		int

AS


--Busca numero de documentos em todos os modais
--utilizado para Intergração BO, DOW
--23-06 - Anderson

	
		Select 
				Numero_PO_HIM Num_Doc,Data_PO_HIM Data_DC,NUM_PROC_HIM JOB
		From
				Po_Him
		Where
				Numero_PO_HIM=@numero and 
				ID_DC=@ID_DC
	
UNION

		Select 
				Numero_PO_HIO Num_Doc,Data_PO_HIO Data_DC,NUM_PROC_HIO
		From
				Po_HiO
		Where
					Numero_PO_HIO=@numero and 
					ID_DC=@ID_DC
UNION
		Select 
				Numero_PO_HIA Num_Doc,Data_PO_HIA Data_DC, NUM_PROC_HIA
		From
				Po_HiA
		Where
				Numero_PO_HIA=@numero and 
				ID_DC=@ID_DC


GO
