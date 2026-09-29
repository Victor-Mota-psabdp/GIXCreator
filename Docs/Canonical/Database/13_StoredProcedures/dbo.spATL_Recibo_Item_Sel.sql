SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_Recibo_Item_Sel] --7
(	
	@ID BigInt	
)
as

Declare @Select bit

Set @Select = 1

select 
	@Select			[Select],
	ID_Item			[Item],
	Nome_Tp_Tx		[Charge],
	DC				[D/C],
	Nome_Tp_Moeda	[Currency Name],
	Vlr_Ref			[Value],
	Par_Moeda		[Exchange Rate],
	Vlr_Ref_Total	[Total Value]
from Recibo_item R
	Join Tipo_Taxa TT	with(nolock) on R.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Join Tipo_Moeda	TM	with(nolock) on R.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
where  
	R.ID = @ID
GO
