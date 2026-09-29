SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spNF_Fatura_Docs_Rel] --1

@ID int

As

	select  
		TDC.Nome_DC, EO.Numero_PO_HBO Num_Doc, EO.Data_PO_HBO Data_Doc, '-' Anexo
	from 
		NF_Fatura_Item NFI
		Left Join PO_HBO EO on EO.Num_Proc_HBO=NFI.Num_proc
		Join Tipo_Doc_Cliente TDC on TDC.ID_DC=EO.ID_DC		
	where 	
		NFI.ID = @ID

UNION

	select  
		TDC.Nome_DC, IM.Numero_PO_HIM Num_Doc, IM.Data_PO_HIM Data_Doc, '-' Anexo
	from
		NF_Fatura_Item NFI
		Left Join PO_HIM IM on IM.Num_Proc_HIM=NFI.Num_proc		
		Join Tipo_Doc_Cliente TDC on TDC.ID_DC=IM.ID_DC		
	where
		NFI.ID = @ID

UNION

	select  
		TDC.Nome_DC, EM.Numero_PO_HEM Num_Doc, EM.Data_PO_HEM Data_Doc, '-' Anexo
	from 
		NF_Fatura_Item NFI
		Left Join PO_HEM EM on EM.Num_Proc_HEM=NFI.Num_proc	
		Join Tipo_Doc_Cliente TDC on TDC.ID_DC=EM.ID_DC	
	where 	
		NFI.ID = @ID

UNION
	select  
		TDC.Nome_DC, EO.Numero_PO_HEO Num_Doc, EO.Data_PO_HEO Data_Doc, '-' Anexo
	from 
		NF_Fatura_Item NFI
		Left Join PO_HEO EO on EO.Num_Proc_HEO=NFI.Num_proc
		Join Tipo_Doc_Cliente TDC on TDC.ID_DC=EO.ID_DC		
	where 	
		NFI.ID = @ID

UNION
	select  
		TDC.Nome_DC, IA.Numero_PO_HIA Num_Doc, IA.Data_PO_HIA Data_Doc, '-' Anexo
	from 
		NF_Fatura_Item NFI
		Left Join PO_HIA IA on IA.Num_Proc_HIA=NFI.Num_proc	
		Join Tipo_Doc_Cliente TDC on TDC.ID_DC=IA.ID_DC	
	where 	
		NFI.ID = @ID

UNION
	select  
		TDC.Nome_DC, IO.Numero_PO_HIO Num_Doc, IO.Data_PO_HIO Data_Doc, '-' Anexo
	from 
		NF_Fatura_Item NFI
		Left Join PO_HIO IO on IO.Num_Proc_HIO=NFI.Num_proc	
		Join Tipo_Doc_Cliente TDC on TDC.ID_DC=IO.ID_DC	
	where 	
		NFI.ID = @ID

UNION
	select  
		TDC.Nome_DC, MAS.Numero_PO Num_Doc, MAS.Data_PO Data_Doc, '-' Anexo
	from 	
		NF_Fatura_Item NFI
		Left Join PO_Master MAS on MAS.Num_Proc_Master=NFI.Num_proc	
		Join Tipo_Doc_Cliente TDC on TDC.ID_DC=MAS.ID_DC	
	where 	
		NFI.ID = @ID
order by
	Data_Doc desc,
	Anexo,
	TDC.Nome_DC


GO
