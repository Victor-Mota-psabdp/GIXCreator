SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

Create Procedure vwPO_Rel

as

select num_proc_him,ID_PO_HIM ID_PO,numero_po_him Numero, Data_PO_HIM,Nome_DC from po_him PO
Join Tipo_Doc_Cliente TC on TC.id_Dc=PO.Id_DC

union


select num_proc_hem,ID_PO_HEM ID_PO,numero_po_hem Numero, Data_PO_HeM,Nome_DC from po_hem PO
Join Tipo_Doc_Cliente TC on TC.id_Dc=PO.Id_DC

union


select num_proc_hia,ID_PO_HIA ID_PO,numero_po_hia Numero, Data_PO_HIa,Nome_DC from po_hia PO
Join Tipo_Doc_Cliente TC on TC.id_Dc=PO.Id_DC

union


select num_proc_hea,ID_PO_HEA ID_PO,numero_po_hea Numero, Data_PO_Hea,Nome_DC from po_hea PO
Join Tipo_Doc_Cliente TC on TC.id_Dc=PO.Id_DC

UNION


select num_proc_heo,ID_PO_HEO ID_PO,numero_po_hEO Numero, Data_PO_HEO,Nome_DC from po_hEO PO
Join Tipo_Doc_Cliente TC on TC.id_Dc=PO.Id_DC

union


select num_proc_hio,ID_PO_HIO ID_PO,numero_po_hIO Numero, Data_PO_HIO,Nome_DC from po_hIO PO
Join Tipo_Doc_Cliente TC on TC.id_Dc=PO.Id_DC



GO
