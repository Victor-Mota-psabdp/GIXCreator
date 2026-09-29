SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from AX_DOC_XML_Oracle where ID_AX = 1812134
--select * from ax_Doc where ID_AX = 1812134
  
CREATE Procedure [dbo].[spAX_BuscaCancelProcessoHeader2Oracle_Test_SEL]   

as        
  
select distinct A.id_Ax,A.tipo
from ax_Doc A         
 Join AX_DOC_item I on I.ID_AX=A.id_AX         
 join Exchange_JMD_AX_ATL E on  I.Num_Proc = E.Num_Proc 
 left join AX_DOC_XML_Oracle_Test XM on  XM.ID_AX=A.id_AX and XM.Cancel=1
where 
	--A.id_Ax = 0 and
	XM.Nome_Arquivo is null
	AND A.dt_canc_Ax > '2026-01-01'    
group by        
 DC,A.id_Ax,moeda,tipo,cd_Tp_Tx_ATL,I.Num_Proc        
HAVING        
 abs(sum(dbo.valor(abs(valor),DC)))>0.00         
   

--union
 
--select distinct A.id_Ax,A.tipo
--from AX_DOC_Oracle_Test A         
-- Join AX_DOC_Item_Oracle_Test I with(nolock) on I.ID_AX=A.id_AX         
-- join Exchange_JMD_AX_ATL E with(nolock) on I.Num_Proc = E.Num_Proc
-- join vwNF_FaturaValidas_Canc NF on NF.Num_Proc = I.Num_Proc and NF.Cd_Tp_Tx = I.cd_tp_Tx_ATL and NF.DC = I.DC
-- left join AX_DOC_XML_Oracle_Test XM with(nolock) on XM.ID_AX=A.id_AX and XM.Cancel=1
--where
--	XM.Nome_Arquivo is null
--	and NF.dt_canc is not null
--group by        
-- I.DC,A.id_Ax,I.Moeda,tipo,I.cd_Tp_Tx_ATL,I.Num_Proc 
--HAVING        
-- abs(sum(dbo.valor(abs(I.Valor),I.DC)))>0.00
 

   
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
	--(
	--	1785429,1785417,1785441
	----1785224,1789448,1779001 --1785919
	--)
	--and A.dt_canc_Ax  > getdate() -90
GO
