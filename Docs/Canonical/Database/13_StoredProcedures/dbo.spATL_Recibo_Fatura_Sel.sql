SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_Recibo_Fatura_Sel]--'EMAET201407002BRA'
(	
	@FatCod Varchar(17)
)
as

Declare @Select bit

Set @Select = 0

select 
@Select [Select],
0	[Item],
TT.Nome_Tp_Tx		[Charge],
FAT.DC				[D/C],
TM.Nome_Tp_Moeda	[Currency],
--P.Apelido			[Creditor/Debitor],
FAT.Vlr_Org			[Value],
FAT.Paridade		[Exchange Rate],
FAT.Vlr_RS			[Total Value]
from vwFaturasValidas FAT
Join Tipo_Taxa TT	with(nolock) on FAT.Cd_Tp_Tx = TT.Cd_Tp_Tx
Join Tipo_Moeda	TM	with(nolock) on FAT.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
--Join Pessoa P		with(nolock) on FAT.Cd_Pes_Fat = P.Cd_Pes
where 
	FAT.FatCod = @FatCod

GO
