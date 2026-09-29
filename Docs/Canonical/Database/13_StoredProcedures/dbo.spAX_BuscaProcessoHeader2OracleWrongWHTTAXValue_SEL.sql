SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--exec spATL_AXXMLHeader2Oracle_Sel '7991',0 
--exec spATL_AXXMLITEM2Oracle_Sel '7991',0

--select * from ax_doc_xml_oracle where ErrorMessage like '%negative amount%' 
--update ax_doc_xml_oracle set Retransmitted = 1 where ErrorMessage like '%negative amount%' 
--select * from ax_doc_XML_Oracle where id_ax in (23053,23180) order by 3

CREATE Procedure [dbo].[spAX_BuscaProcessoHeader2OracleWrongWHTTAXValue_SEL]   --4989

as        
 
select distinct A.id_Ax,A.tipo,A.Invoice_Number Invoice, A.Invoice_Number,A.Numero_Documento,LEN(A.Invoice_Number) Invoice_Number_Lenght,A.Dt_Canc,null Doc_Number
,A.Dt_Ins
from AX_DOC_Oracle A         
 Join AX_DOC_Item_Oracle I with(nolock) on I.ID_AX=A.id_AX         
 join Exchange_JMD_AX_ATL E with(nolock) on I.Num_Proc = E.Num_Proc   
 left join AX_DOC_XML_Oracle XM with(nolock) on XM.ID_AX=A.id_AX and XM.Cancel=0 
where	
	A.ID_AX in ( select ID_AX from ax_doc_xml_oracle where ErrorMessage like '%negative amount%' and ISNULL(Retransmitted,0)=0 )
	--and A.Invoice_Number in ('IASWB202603009BRA','IASWB202604025BRA')
group by        
 DC,A.id_Ax,moeda,tipo,cd_Tp_Tx_ATL,I.Num_Proc,A.Invoice_Number,A.Numero_Documento,A.Dt_Canc
 ,A.Dt_Ins
HAVING        
 abs(sum(dbo.valor(abs(valor),DC)))>0.00  
 order by 1





GO
