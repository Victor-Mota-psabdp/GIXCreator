SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  Procedure [dbo].[spPOCHB_SEl]--'imoxt201705038br'
		@num_proc	varchar(16)

as


select num_proc_him,ID_PO_HIM ID_PO,numero_po_him Numero, Data_PO_HIM,Nome_DC  from po_him PO with(nolock)
Join Tipo_Doc_Cliente TC with(nolock) on TC.id_Dc=PO.Id_DC 
Where num_proc_him=@num_proc

union


select num_proc_hem,ID_PO_HEM ID_PO,numero_po_hem Numero, Data_PO_HeM,Nome_DC from po_hem PO with(nolock)
Join Tipo_Doc_Cliente TC with(nolock) on TC.id_Dc=PO.Id_DC
Where num_proc_hem=@num_proc

union


select num_proc_hia,ID_PO_HIA ID_PO,numero_po_hia Numero, Data_PO_HIa,Nome_DC from po_hia PO with(nolock)
Join Tipo_Doc_Cliente TC with(nolock) on TC.id_Dc=PO.Id_DC
Where num_proc_hia=@num_proc

union


select num_proc_hea,ID_PO_HEA ID_PO,numero_po_hea Numero, Data_PO_Hea,Nome_DC from po_hea PO with(nolock)
Join Tipo_Doc_Cliente TC with(nolock) on TC.id_Dc=PO.Id_DC
Where num_proc_hea=@num_proc

UNION


select num_proc_heo,ID_PO_HEO ID_PO,numero_po_hEO Numero, Data_PO_HEO,Nome_DC from po_hEO PO with(nolock)
Join Tipo_Doc_Cliente TC with(nolock) on TC.id_Dc=PO.Id_DC
Where num_proc_hEO=@num_proc

union

select num_proc_hio,ID_PO_HIO ID_PO,numero_po_hIO Numero, Data_PO_HIO,Nome_DC from po_hIO PO with(nolock)
Join Tipo_Doc_Cliente TC with(nolock) on TC.id_Dc=PO.Id_DC
Where num_proc_hIO=@num_proc

union

select num_proc_master,ID_PO_master ID_PO,numero_po Numero, Data_PO,Nome_DC from po_master PO with(nolock)
Join Tipo_Doc_Cliente TC with(nolock) on TC.id_Dc=PO.Id_DC
Where num_proc_master=@num_proc

union

select Num_Proc_HBO,ID_PO_HBO ID_PO,Numero_PO_HBO Numero, Data_PO_HBO,Nome_DC from PO_HBO PO with(nolock)
Join Tipo_Doc_Cliente TC with(nolock) on TC.id_Dc=PO.Id_DC
Where Num_Proc_HBO=@num_proc








GO
