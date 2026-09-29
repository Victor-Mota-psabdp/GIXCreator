SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spMarsPDF]

AS


select distinct nome_arquivo,PS.Num_Proc + '_' +right(DOC.num_proc,(len(doc.num_proc)-3)) + '.pdf' Nome_Doc from pedido_ship PS
Join Nota_Fiscal_lote NF on NF.cd_pedido=PS.cd_pedido
Join Nota_Fiscal_Produto NP on NP.cd_fornecedor=NF.cd_fornecedor and NF.num_nf=NP.num_nf
Join Doc_Anexos DOC on right(DOC.num_proc,(len(doc.num_proc)-3))=ID_NF and len(doc.num_proc)>3 and left(doc.num_proc,2)='NF'






GO
