SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE    procedure spFinCheckDet 

		@apelido varchar(25),
		@DataInicial	varchar(10),
		@DataFinal	varchar(10)
As

SELECT 
	apelido,Fat.FatCod,dbo.house(left(fat.fatcod,16)) House,item.cd_tp_moeda, sum(vlr_org) TOTAL, FatDtVenc

FROM fatura fat

	Join item_fat item on item.fatcod=fat.fatcod
	Join pessoa pp on pp.cd_pes=fat.cd_pes
	Join Tipo_Taxa TT on TT.cd_tp_tx=item.cd_tp_tx
WHERE
	fatStatus=1 and apelido like @apelido	
	and dbo.fpgto(left(fat.fatcod,16),item.cd_tp_tx,dc) is null 
	and fatdtvenc between convert(datetime, @dataInicial,105) and convert(datetime,@datafinal,105)
GROUP BY

	fat.FatDtVenc,apelido,Fat.FatCod,dbo.house(left(fat.fatcod,16)),item.cd_tp_moeda






GO
