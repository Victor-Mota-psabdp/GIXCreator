SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
--exec spATL_AXXMLHeader2Oracle_Sel '4579',1 
--exec spATL_AXXMLITEM2Oracle_Sel	'4579',1 

Create Procedure [dbo].[spAX_BuscaCancelProcessoHeader2Oracle_Error_SEL]   

as        
  
--select distinct A.id_Ax,A.tipo
--,Case when SOL.ID is not null then isnull(Convert(Varchar(50),SOL.Doc_Number),'SP' + Convert(Varchar(50),SOL.ID)) else 
--				Case when LEN(A.invoice_number) >= 18 then Convert(Varchar(50),A.ID_AX) else			
--					Convert(Varchar(50),A.invoice_number) END END Invoice,
--A.Invoice_Number,A.Numero_Documento,LEN(A.Invoice_Number) Invoice_Number_Lenght,A.Dt_Canc,SOL.Doc_Number
--,XO.Verificado,XO.ErrorMessage
--from ax_Doc A         
-- Join AX_DOC_item I on I.ID_AX=A.id_AX         
-- join Exchange_JMD_AX_ATL E on  I.Num_Proc = E.Num_Proc
-- join AX_DOC_XML_Oracle XO on XO.ID_AX=A.id_AX and XO.Cancel=0
-- left join AX_DOC_XML_Oracle XM on XM.ID_AX=A.id_AX and XM.Cancel=1 
-- left join Sol_Pgto_Cta_Cte SOL on Convert(varchar(25),SOL.ID) = A.Numero_Documento
-- left join vwNF_Fatura_ALL NF on NF.Num_Proc = I.Num_Proc and NF.Cd_Tp_Tx = I.cd_tp_Tx_ATL and NF.DC = I.DC
--where 	
--	XM.Nome_Arquivo is null
--	AND NF.ID is null
--	AND A.dt_canc >'2026-01-01'
--	AND A.Dt_Ins >= '2026-01-01' 
--	and XO.Verificado is not null
--	and XO.ErrorMessage is null
--group by        
-- I.DC,A.id_Ax,I.moeda,A.tipo,I.cd_Tp_Tx_ATL,I.Num_Proc,A.Invoice_Number,A.Numero_Documento,A.Dt_Canc,SOL.Doc_Number,SOL.ID--,SOL.Cd_Cred_Dev    
-- ,XO.Verificado,XO.ErrorMessage
--HAVING        
-- abs(sum(dbo.valor(abs(i.valor),I.DC)))>0.00        
  
  
--UNION 
	
--select distinct O.id_Ax,A.tipo,
--A.Invoice_Number Invoice,
--A.Invoice_Number,A.Numero_Documento,LEN(A.Invoice_Number) Invoice_Number_Lenght,A.Dt_Canc,NF.Fatcod--,A.dt_canc_ax
--,XO.Verificado,XO.ErrorMessage
----A.id_Ax OLD,
--from ax_Doc A 
--	join AX_Doc_Oracle O on O.Invoice_Number = A.Invoice_Number
--	join AX_DOC_XML_Oracle XO on XO.ID_AX=O.id_AX and XO.Cancel=0
--	Join AX_DOC_item I on I.ID_AX=A.id_AX
--	join Exchange_JMD_AX_ATL E on  I.Num_Proc = E.Num_Proc 
--	left join AX_DOC_XML_Oracle XM on XM.ID_AX=O.id_AX and XM.Cancel=1
	
--	join Fatura FAT on FAT.FatCod = A.Invoice_Number
--	left join vwNF_Fatura_ALL NF on NF.Num_Proc = I.Num_Proc and NF.Cd_Tp_Tx = I.cd_tp_Tx_ATL and NF.DC = I.DC
--	where 
--		id_ax = '4294'
--	--O.id_ax not in ('5906') AND 
--	XM.Nome_Arquivo is null	AND 
--	NF.ID is null
--	AND A.dt_canc_ax >'2026-01-01'
--	AND A.Dt_Ins >= '2026-01-01' 
--	and XO.Verificado is not null
--	and XO.ErrorMessage is null
--group by        
-- I.DC,A.id_Ax,O.id_Ax,I.moeda,A.tipo,I.cd_Tp_Tx_ATL,I.Num_Proc,A.Invoice_Number,A.Numero_Documento,A.Dt_Canc
--,XO.Verificado,XO.ErrorMessage,NF.Fatcod,A.dt_canc_ax
--HAVING        
-- abs(sum(dbo.valor(abs(i.valor),I.DC)))>0.00 

--UNION 
	
select distinct A.id_Ax,A.tipo,
A.Invoice_Number Invoice,
A.Invoice_Number,A.Numero_Documento,LEN(A.Invoice_Number) Invoice_Number_Lenght,FAT.Dt_Canc,FAT.Fatcod--,A.dt_canc_ax
,XO.Verificado,XO.ErrorMessage
--A.id_Ax OLD,
from AX_Doc_Oracle A 
	join vwNF_Fatura_ALL FAT on FAT.FatCod = A.Invoice_Number
	join AX_DOC_XML_Oracle XO on XO.ID_AX=A.id_AX and XO.Cancel=0
	Join AX_DOC_Item_Oracle I on I.ID_AX=A.id_AX
	join Exchange_JMD_AX_ATL E on  I.Num_Proc = E.Num_Proc 
	left join AX_DOC_XML_Oracle XM on XM.ID_AX=A.id_AX and XM.Cancel=1
	where 
		A.id_ax = '4294' and	
		XM.Nome_Arquivo is null	
		--AND FAT.Dt_Canc >'2026-01-01'
		AND FAT.FatDtEmissao >= '2026-01-01' 
		and XO.Verificado is not null
		and XO.ErrorMessage is null
group by        
 I.DC,A.id_Ax,A.id_Ax,I.moeda,A.tipo,I.cd_Tp_Tx_ATL,I.Num_Proc,A.Invoice_Number,A.Numero_Documento,FAT.Dt_Canc
,XO.Verificado,XO.ErrorMessage,FAT.Fatcod,A.dt_canc_ax
HAVING        
 abs(sum(dbo.valor(abs(i.valor),I.DC)))>0.00 

GO
