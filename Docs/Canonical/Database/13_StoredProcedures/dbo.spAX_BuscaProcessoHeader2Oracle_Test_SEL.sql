SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spAX_BuscaProcessoHeader2Oracle_Test_SEL]   

as        
  
select distinct A.id_Ax,A.tipo--,left(A.Invoice_Number,20) Invoice, A.Invoice_Number, A.Numero_Documento,LEN(A.Invoice_Number) Invoice_Number_Lenght,A.Dt_Canc
from ax_Doc A         
 Join AX_DOC_item I on I.ID_AX=A.id_AX         
 join Exchange_JMD_AX_ATL E on  I.Num_Proc = E.Num_Proc   
 left join AX_DOC_XML_Oracle_Test XM on XM.ID_AX=A.id_AX and XM.Cancel=0 
 --join Sol_Pgto_Cta_Cte SOL on Convert(varchar(25),SOL.ID) = A.Numero_Documento
 left join vwNF_FaturaValidas NF on NF.Num_Proc = I.Num_Proc and NF.Cd_Tp_Tx = I.cd_tp_Tx_ATL and NF.DC = I.DC
where
	--A.ID_AX = 1821735
	--A.id_ax in (1808707,1810651,1813517,1815829,1821948,1822712,1822715,227)
	--A.ID_AX in (1814855,1814875,1814879,1814895,1814926,1814929,1824793,1824799,1824908,1825515,1825697,1825825,1825968)
	--A.ID_AX in (1808630,1810786,1811773,1811794,1812705)--(1821735,1822226)
	--A.id_ax in (1818653,1820280,1822266)
	--a.id_ax in (1822712,1822714,1822715,1821948) 
	--a.id_ax in (1805121,1808707,1810651,1813517,1815829)
	--A.ID_AX  in (1805121,1808707,1810651,1813517,1815829,1819659,1821939,1813517) and
	XM.Nome_Arquivo is null
	AND NF.ID is  null
	AND A.DT_Envio_AX > '2025-12-25' 
	--and SOL.ID is null

	--XM.Nome_Arquivo is not  null
	--AND NF.ID is  null
	----AND A.Dt_Ins > '2026-02-01' 
	----and LEN(A.Invoice_Number) > 19

	--and  left(A.Invoice_Number,20) in ('XBA.EAARC202601003BR') and A.ID_AX =1823415-- 1823371
	----1823415
	----,'XBA.EMEUR202512001BR','XBA.IMASH202601007BR','XBA.IMEUR202601001BR','XBA.IMEUR202601002BR','XBA.IMEUR202602001BR','XBA.IMEUR202602002BR')
group by        
 I.DC,A.id_Ax,I.Moeda,A.Tipo,I.cd_tp_Tx_ATL,I.Num_Proc-- ,A.Invoice_Number,A.Numero_Documento,A.Dt_Canc
HAVING        
 abs(sum(dbo.valor(abs(I.Valor),I.DC)))>0.00  
-- order by 3 ,1

--union
 
--select distinct A.id_Ax,A.tipo--,left(A.Invoice_Number,20) Invoice, A.Invoice_Number, A.Numero_Documento,LEN(A.Invoice_Number) Invoice_Number_Lenght,A.Dt_Canc
--from AX_DOC_Oracle_Test A         
-- Join AX_DOC_Item_Oracle_Test I on I.ID_AX=A.id_AX         
-- join Exchange_JMD_AX_ATL E on  I.Num_Proc = E.Num_Proc   
-- left join AX_DOC_XML_Oracle_Test XM on XM.ID_AX=A.id_AX and XM.Cancel=0 
--where	
--	--A.ID_AX in (2068,1467)
--	--A.ID_AX = 1817369 and
--	XM.Nome_Arquivo is null
--	--AND A.DT_Envio_AX > '2025-12-25' 
--	--and SOL.ID is null
--group by        
-- DC,A.id_Ax,moeda,tipo,cd_Tp_Tx_ATL,I.Num_Proc --,A.Invoice_Number,A.Numero_Documento,A.Dt_Canc
--HAVING        
-- abs(sum(dbo.valor(abs(valor),DC)))>0.00  

















 
--UNION

--select distinct A.id_Ax,A.tipo
--from ax_Doc A         
-- Join AX_DOC_item I on I.ID_AX=A.id_AX         
-- join Exchange_JMD_AX_ATL E on  I.Num_Proc = E.Num_Proc   
-- join AX_DOC_XML_Oracle XM on XM.ID_AX=A.id_AX and XM.Cancel=0 
--where
--	XM.Retransmitted = 1
--	--isnull(Verificado,0) =0 
--	--AND XM.Nome_Arquivo is not null
--group by        
-- DC,A.id_Ax,moeda,tipo,cd_Tp_Tx_ATL,I.Num_Proc 
--HAVING        
-- abs(sum(dbo.valor(abs(valor),DC)))>0.00  
 
--union
 
--select distinct A.id_Ax,A.tipo
--from AX_DOC_Oracle A         
-- Join AX_DOC_Item_Oracle I on I.ID_AX=A.id_AX         
-- join Exchange_JMD_AX_ATL E on  I.Num_Proc = E.Num_Proc   
-- join AX_DOC_XML_Oracle XM on XM.ID_AX=A.id_AX and XM.Cancel=0 
--where	
--	XM.Retransmitted = 1
--	--isnull(Verificado,0) = 0 
--	--AND XM.Nome_Arquivo is not null
--group by        
-- DC,A.id_Ax,moeda,tipo,cd_Tp_Tx_ATL,I.Num_Proc 
--HAVING        
-- abs(sum(dbo.valor(abs(valor),DC)))>0.00  
      
   
--UNION        
    
--select  i.DC,A.id_Ax,moeda,tipo,i.cd_Tp_Tx_ATL,I.Num_Proc         
--from ax_Doc A (NOLOCK)        
--inner Join AX_DOC_item I (NOLOCK)        
-- on I.ID_AX=A.id_AX           
--inner join Exchange_JMD_AX_ATL E (NOLOCK)         
-- on  I.Num_Proc = E.Num_Proc        
--left join AX_DOC_XML_NEW axxml (NOLOCK) -- acrescentei esse join        
--  on axxml.num_proc = I.num_proc        
--  and axxml.cd_tp_Tx_ATL = I.cd_tp_Tx_ATL        
--  and axxml.id_ax = I.id_ax         
--where A.dt_Envio_ax is not null -- que ja tenha sido enviado ao ax mas faltaram taxas      
-- and axxml.dt_Envio is null  -- mudei aqui        
-- AND cd_pessoa_Ax is not null           
-- and cd_tp_TX is not null          
-- and valor > 0.00           
-- and I.cd_tp_Tx <> '000.1'  
--  --and Data_Aprovacao >= GETDATE()-31 - cadu 26/07/2021-03/01/2025 
-- and Data_Aprovacao >= GETDATE()-day(GETDATE())  
      
--AND a.DT_INS> GETDATE() -90
    
	--A.ID_AX in 
	--(1808491)
	--(1805895,1808402,1808707,1810282,1810349)
	--(1804941,1805686,1805902,1806342,1808484,1808491,1810448) --sent
	--(1806812,1808181,1808291,1808913,1809117,1809395,1810887,1810895)	 --sent
	--(1807108,1809152,1809765,1810448)	 --sent
	--(1802695,1809180,1809231) --sent
	--(1808707)
	--(1805895,1808402,1810282,1810349)
	
	--(
	--	1805307
	--	--1784029--,--,1805306
	----	1784550,1784345,1784074,1784717
	----	--1785429,1785417,1785441
	----	--1786222
	----	--1789457,1789564,1790826,1791297,1791300
	----	--1779373,1779374

	------1784222,1784289,
	------1784161,1784413,
	------1784029,1783709,1782350,
	------1775230,1779853,
	--------cancel
	------1785224,1789448,1779001,1785919
	--)
	--and 
GO
