SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure spJIBuscaPO_Rel
	
		@Num_Po	varchar(40),
		@ID_DC	int,
		@Modal	Varchar(3)

AS

Select 
	Numero_PO_Him Numero, Data_PO_HIM Data 
From	
	PO_HIM 
Where
	Numero_Po_Him=@Num_PO and ID_DC=@ID_DC and Num_proc_him like @Modal


UNION

Select 
	Numero_PO_Hio Numero, Data_PO_HIo Data 
From	
	PO_HIo
Where
	Numero_Po_Hio=@Num_PO and ID_DC=@ID_DC and Num_proc_hio like @Modal

UNION

Select 
	Numero_PO_Hia Numero, Data_PO_HIa Data 
From	
	PO_HIa
Where
	Numero_Po_Hia=@Num_PO and ID_DC=@ID_DC and Num_proc_hia like @Modal

union


Select 
	Numero_PO_hem Numero, Data_PO_hem Data 
From	
	PO_hem 
Where
	Numero_Po_hem=@Num_PO and ID_DC=@ID_DC and Num_proc_hem like @Modal


UNION

Select 
	Numero_PO_heo Numero, Data_PO_heo Data 
From	
	PO_heo
Where
	Numero_Po_heo=@Num_PO and ID_DC=@ID_DC and Num_proc_heo like @Modal

UNION

Select 
	Numero_PO_hea Numero, Data_PO_hea Data 
From	
	PO_hea
Where
	Numero_Po_hea=@Num_PO and ID_DC=@ID_DC and Num_proc_hea like @Modal


GO
