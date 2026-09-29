SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select Nome_Tp_Cont from Tipo_container
--spATL_Taxa_Demurrage_BDP_Sel '%','%'
CREATE PROCEDURE [dbo].[spATL_Taxa_Demurrage_BDP_Sel]--'%','%'
(
	@Nome_Tp_Cont as varchar(50),
	@ds_periodo as varchar(50) 
)
AS

select 
	'Saved' [Status],
	Nome_Tp_Cont [Type Of Container], 
	ds_periodo [Period],
	Dias [Days],
	Taxa [Value ($)]
from Taxa_Demurrage_BDP T
	join Tipo_Container TC on TC.Cd_Tp_Cont = T.cd_tp_cont
	join Tipo_Periodo_Demurrage P on P.cd_periodo = T.Periodo
where
	Nome_Tp_Cont like @Nome_Tp_Cont
	and ds_periodo like @ds_periodo

	
GO
