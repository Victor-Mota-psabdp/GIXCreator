SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   procedure spFaturaFin_rel 
			@modal varchar(2)


as


if @modal='IA' 

	BEGIN
		select 
			apelido,fat.fatcod,item.cd_tp_moeda, sum(dbo.valor( vlr_org,dC)) Valor, dbo.house(num_proc) House,
			fatdtVenc,par_Moeda
		from 
			fatura fat
			Join Item_fat item on item.fatcod=fat.fatcod
			Join pessoa pp on pp.cd_pes=fat.cd_pes
			Left Join Paridade par on par.cd_tp_moeda=item.cd_tp_moeda and cd_Tp_par='IMA' and convert(datetime,dt_par,105)= dbo.hoje(getdate())
		where 
			dbo.fpgto(num_proc,cd_tp_Tx,dc)is null AND LEFT(fat.fatcod,2)='IA'

		group by 
			fat.FatCod,item.cd_tp_moeda, apelido, dbo.house(num_proc),fatdtvenc,par_moeda

	END




GO
