SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

Create Procedure spPO_Rel

as

select Nome_Dc,Num_Proc_him,Numero_PO_Him,Data_PO_Him from po_him PO
Join tipo_doc_cliente TC on TC.ID_DC=PO.ID_DC

union

select Nome_Dc,Num_Proc_hia,Numero_PO_Hia,Data_PO_Hia from po_hia PO
Join tipo_doc_cliente TC on TC.ID_DC=PO.ID_DC

union

select Nome_Dc,Num_Proc_hea,Numero_PO_Hea,Data_PO_Hea from po_hea PO
Join tipo_doc_cliente TC on TC.ID_DC=PO.ID_DC

union


select Nome_Dc,Num_Proc_hem,Numero_PO_Hem,Data_PO_Hem from po_hem PO
Join tipo_doc_cliente TC on TC.ID_DC=PO.ID_DC



GO
