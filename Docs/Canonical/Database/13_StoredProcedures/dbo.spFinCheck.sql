SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  procedure spFinCheck 
		@Fatura	varchar(17)
As

SELECT 
	apelido,Fat.FatCod,dbo.house(left(fat.fatcod,16)) House,nome_tp_Tx, item.cd_tp_moeda, vlr_org,
	Vlr_RS,Paridade

FROM fatura fat

	Join item_fat item on item.fatcod=fat.fatcod
	Join pessoa pp on pp.cd_pes=fat.cd_pes
	Join Tipo_Taxa TT on TT.cd_tp_tx=item.cd_tp_tx
WHERE
	fatStatus=0 and fat.fatcod=@Fatura
	and dbo.fpgto(left(fat.fatcod,16),item.cd_tp_tx,dc) is null



GO
