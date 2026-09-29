SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure spConsulFin 

		@Apelido varchar(30)

AS

SELECT
	Dbo.house(left(Fat.FatCod,16)) , Fat.FatCod,Nome_tp_Tx,
	Nome_Raz_Soc,fatDtVenc,cd_tp_moeda,Vlr_Org,item.Vlr_Rs,Paridade 
FROM
	fatura fat
	inner join item_fat item on item.fatcod=fat.fatcod
	inner join tipo_taxa tt on tt.cd_tp_tx=item.cd_tp_Tx
	inner join pessoa pp on pp.cd_pes=fat.cd_pes

WHERE

	apelido like @apelido


GO
