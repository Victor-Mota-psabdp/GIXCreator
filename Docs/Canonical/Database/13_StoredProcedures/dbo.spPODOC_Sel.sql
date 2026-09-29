SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spPODOC_Sel] --'13/0849507-4',5
		@num_doc	Varchar(16),
		@ID_DC		int

AS


--Busca numero de documentos em todos os modais
--utilizado para Intergração BO, DOW
--23-06 - Anderson

		Select 
				Numero_PO_HIM Num_Doc,Data_PO_HIM Data_DC,num_proc_him
		From
				Po_Him
		Where
				numero_po_him=@num_doc and 
				ID_DC=@ID_DC

union

		Select 
				Numero_PO_HIO Num_Doc,Data_PO_HIO Data_DC,num_proc_hio
		From
				Po_HiO
		Where
				numero_po_hio=@num_doc and 
				ID_DC=@ID_DC

union
			Select 
				Numero_PO_HIA Num_Doc,Data_PO_HIA Data_DC,num_proc_hia
		From
				Po_HiA
		Where
				numero_po_hia=@num_doc and 
				ID_DC=@ID_DC
	
union
		Select 
				Numero_PO_HEA Num_Doc,Data_PO_HEA Data_DC,num_proc_hea
		From
				Po_HEA
		Where
				numero_po_hea=@num_doc and 
				ID_DC=@ID_DC
	
union
		Select 
				Numero_PO_HEM Num_Doc,Data_PO_HEM Data_DC,num_proc_hem
		From
				Po_HEM
		Where
				numero_po_hem=@num_doc and 
				ID_DC=@ID_DC
union
		Select 
				Numero_PO_HEO Num_Doc,Data_PO_HEO Data_DC,num_proc_heo
		From
				Po_HEO
		Where
				numero_po_heo=@num_doc and 
				ID_DC=@ID_DC

Union 




		Select 
				Null Num_Doc,Null  Data_DC,'IMFMC' num_proc_him

order by 1 desc
GO
