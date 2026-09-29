SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_ShipmentConfirmation_Rel]--'2012-01-01','2012-03-12'
	@DtInicial datetime,
	@DtFinal datetime
as

select 
	Num_proc				[BDP Ref.],
	dt_envio				[Send Date]
from 
	Alerta_Email_Historico 
where 
	id_alerta_email = '63'
	and dt_envio between @DtInicial and @DtFinal
order by dt_envio
GO
