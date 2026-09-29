SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 --CADU 22/09/2023 - AND a.DT_INS> GETDATE() -90 
 --[dbo].[spAX_BuscaProcessoHeaderNew_Pending_SEL] 
--[spATL_AXXMLHeader_Pending_SEL] 1755495,'REL',0,'C','XBA','IMEUR202504002BR'
--spATL_AXXMLITEM_Pending_SEL 1755495,'REL',0,'C','XBA','IMEUR202504002BR'

CREATE Procedure [dbo].[spAX_BuscaProcessoHeaderNew_Pending_SEL] 

 as        

    
select  i.DC,A.id_Ax,moeda,tipo,i.cd_Tp_Tx_ATL,I.Num_Proc         
from ax_Doc A (NOLOCK)        
inner Join AX_DOC_item I (NOLOCK)        
 on I.ID_AX=A.id_AX           
inner join Exchange_JMD_AX_ATL E (NOLOCK)         
 on  I.Num_Proc = E.Num_Proc        
left join AX_DOC_XML_NEW axxml (NOLOCK) -- acrescentei esse join        
  on axxml.num_proc = I.num_proc        
  and axxml.cd_tp_Tx_ATL = I.cd_tp_Tx_ATL        
  and axxml.id_ax = I.id_ax         
where 
	--A.dt_Envio_ax is not null -- que ja tenha sido enviado ao ax mas faltaram taxas      
	 --and 
	 axxml.dt_Envio is null  -- mudei aqui        
	 AND 
	 cd_pessoa_Ax is not null           
	 and cd_tp_TX is not null          
	 and valor > 0.00           
	 and I.cd_tp_Tx <> '000.1'  
--  --and Data_Aprovacao >= GETDATE()-31 - cadu 26/07/2021-03/01/2025 
-- and Data_Aprovacao >= GETDATE()-day(GETDATE())  
      
--AND a.DT_INS> GETDATE() -90
--and a.ID_AX in (1780750,1785978,1787031,1788616,1788775)
and a.ID_AX in(1775975,1784399)
order by 2
 
GO
