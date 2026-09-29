SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--incluido os 2 tipos de BO
create Procedure [dbo].[spAX_BuscaProcessoHeaderNewCanc_SEL]
	as
select 
	distinct DC,A.id_Ax,moeda,tipo,cd_Tp_Tx_ATL,I.Num_Proc 
from ax_Doc A 
	Join AX_DOC_item I on I.ID_AX=A.id_AX 
	join Exchange_JMD_AX_ATL E on  I.Num_Proc = E.Num_Proc 
where 
	A.dt_canc is not null 
	and A.dt_canc_Ax  is null 
	and cd_pessoa_Ax is not null 
	and I.cd_tp_TX is not null 
	and valor > 0.00 
	and I.cd_tp_Tx <> '000.1'
group by
	DC,A.id_Ax,moeda,tipo,cd_Tp_Tx_ATL,I.Num_Proc
HAVING
	abs(sum(dbo.valor(abs(valor),DC)))>0.00	
GO
