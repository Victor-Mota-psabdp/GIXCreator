SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
create procedure spAKZO_EmbalagensVol_Rel
(
@ID int
)
as
Select
	Inv_Cli.ID_INV,
	Inv_Det.Item,
	Inv_Det.Quantidade	Qtd,
	TE.Nome_Tp_Embal	Embal,
	VOL.qtd_Vol_EM		Qtd_Vol,
	VE.Nome_Tp_Embal	Nome_Embal
from
	Invoice_Det Inv_Det
	Join Invoice_Cliente		Inv_CLI		on Inv_CLI.ID_Inv	=INV_DET.ID_Inv
	left join Tipo_Embalagem TE on TE.Cd_Tp_Embal = Inv_Det.Cd_Embalagem
	Left Join volume_exp_mar	VOL		on VOL.Num_Proc_HEM	=INV_CLI.Num_Proc and INV_DET.Item = Convert(Int,VOL.Item_EM)
	left join Tipo_Embalagem VE on VE.Cd_Tp_Embal 	=VOL.Cd_Tp_Embal
where
	Inv_Det.ID_Inv = @ID
order by
	Inv_Det.Item
GO
