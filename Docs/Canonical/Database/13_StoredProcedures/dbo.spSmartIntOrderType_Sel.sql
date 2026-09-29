SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Tipo_Pedido = cadu: 01/12/2022 18:42h - included 5
CREATE Procedure [dbo].[spSmartIntOrderType_Sel]
	@Num_proc Varchar(16)

AS

select top 1 
	(
	Case  
		When cd_tipo='3' then 'Inter-Company'
		When cd_tipo='5' then 'Pre-Booking'
		When cd_tipo= '2' and upper(left(@num_proc,1))='I' then 'Third'
		When cd_tipo= '2' and upper(left(@num_proc,1))='E' then 'Indent'
		else 'Samples'
	End
	) Saida
from 
	pedido_ship PS with(nolock)
	Join Pedido PD with(nolock) on PD.cd_pedido=PS.cd_pedido
Where 
	num_proc=@Num_PRoc

GO
