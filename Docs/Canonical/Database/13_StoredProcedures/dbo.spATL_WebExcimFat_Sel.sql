SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure spATL_WebExcimFat_Sel
(
@Num_Proc Varchar(16)
)
as
select 
'N'[Type],
TT.Cd_Tp_Tx_Ofc [Code],
TT.Nome_Tp_Tx_Ing [Description],
Vlr_Org [Amount],
Cd_Tp_Moeda [Currency]
from Fatura FAT
Join Item_Fat IFAT on FAT.FatCod = IFAT.FatCod
join Tipo_Taxa TT on IFAT.Cd_Tp_Tx = TT.Cd_Tp_Tx
where IFAT.Num_Proc = @Num_Proc
GO
