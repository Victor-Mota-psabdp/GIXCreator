SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE     procedure spFatPend_Rel 



@APELIDO varchar (50),
@INICIAL varchar (10),
@FINAL	varchar (10)

As

select item.fatcod, PS.apelido, TT.Nome_tp_tx, FT.FatDtVenc, item.cd_tp_moeda, dbo.valor(vlr_org,ccea.dc_hea) Valor, isnull(PR.par_moeda,1) Par_Moeda from cta_cte_hou_exp_aer ccea
left join caixa_hou_exp_aer as cea on ccea.num_proc_hea = cea.num_proc_hea and ccea.cd_tp_tx = cea.cd_tp_tx and ccea.dc_hea = cea.dc_hea and cea.num_lcto <> 'Provisório' and Convert(DateTime,dt_pgto_rcto_hea,105) <=@Final
left join item_fat as item on ccea.num_proc_hea = item.num_proc and ccea.cd_tp_tx = item.cd_tp_tx and ccea.dc_hea = item.dc
left join pessoa as ps on ccea.cd_cred_dev_hea = ps.cd_pes
left join fatura FT on item.FatCod = FT.fatcod
left join tipo_taxa TT on item.cd_tp_tx = TT.cd_tp_tx 
left join paridade PR on  item.cd_tp_moeda = PR.cd_tp_moeda and convert(datetime,dt_par,105) = DBO.hoje(getdate()) and PR.cd_tp_par = 'OFC'
where  fatStatus = 1 and cea.num_lcto is null and ps.apelido like @APELIDO and FatDtVenc between @Inicial and @Final 

union all

select item.fatcod, PS.apelido, TT.Nome_tp_tx, FT.FatDtVenc, item.cd_tp_moeda, dbo.valor(vlr_org,ccia.dc_hia), IsNull(PR.par_moeda,1) from cta_cte_hou_imp_aer ccia
left join caixa_hou_imp_aer as cia on ccia.num_proc_hia = cia.num_proc_hia and ccia.cd_tp_tx = cia.cd_tp_tx and ccia.dc_hia = cia.dc_hia and cia.num_lcto <> 'Provisório' and Convert(DateTime,dt_pgto_rcto_hia,105)<=@Final
left join item_fat as item on ccia.num_proc_hia = item.num_proc and ccia.cd_tp_tx = item.cd_tp_tx and ccia.dc_hia = item.dc
left join pessoa as ps on ccia.cd_cred_dev_hia = ps.cd_pes
left join fatura FT on item.FatCod = FT.fatcod
left join tipo_taxa TT on item.cd_tp_tx = TT.cd_tp_tx 
left join paridade PR on  item.cd_tp_moeda = PR.cd_tp_moeda and convert(datetime,dt_par,105) = DBO.hoje(getdate()) and PR.cd_tp_par = 'OFC'
where  fatStatus = 1 and cia.num_lcto is null and ps.apelido like @APELIDO and FatDtVenc between @Inicial and @Final  

union all

select item.fatcod, PS.apelido, TT.Nome_tp_tx, FT.FatDtVenc, item.cd_tp_moeda, dbo.valor(vlr_org,ccim.dc_him), IsNull(PR.par_moeda,1) Par_Moeda from cta_cte_hou_imp_mar ccim
left join caixa_hou_imp_mar as cim on ccim.num_proc_him = cim.num_proc_him and ccim.cd_tp_tx = cim.cd_tp_tx and ccim.dc_him = cim.dc_him and cim.num_lcto <> 'Provisório' and convert(DateTime,dt_pgto_rcto_him,105)<=@Final
left join item_fat as item on ccim.num_proc_him = item.num_proc and ccim.cd_tp_tx = item.cd_tp_tx and ccim.dc_him = item.dc
left join pessoa as ps on ccim.cd_cred_dev_him = ps.cd_pes
left join fatura FT on item.FatCod = FT.fatcod
left join tipo_taxa TT on item.cd_tp_tx = TT.cd_tp_tx 
left join paridade PR on  item.cd_tp_moeda = PR.cd_tp_moeda and convert(datetime,dt_par,105) = DBO.hoje(getdate()) and PR.cd_tp_par = 'OFC'
where  fatStatus = 1 and cim.num_lcto is null and ps.apelido like @APELIDO and FatDtVenc between @Inicial and @Final  

union all

select item.fatcod, PS.apelido, TT.Nome_tp_tx, FT.FatDtVenc, item.cd_tp_moeda, dbo.valor(vlr_org,ccem.dc_hem), IsNull(PR.par_moeda,1)  from cta_cte_hou_exp_mar ccem
left join caixa_hou_exp_mar as cem on ccem.num_proc_hem = cem.num_proc_hem and ccem.cd_tp_tx = cem.cd_tp_tx and ccem.dc_hem = cem.dc_hem and cem.num_lcto <> 'Provisório' and convert(DateTime,dt_pgto_rcto_hem,105)<=@Final
left join item_fat as item on ccem.num_proc_hem = item.num_proc and ccem.cd_tp_tx = item.cd_tp_tx and ccem.dc_hem = item.dc
left join pessoa as ps on ccem.cd_cred_dev_hem = ps.cd_pes
left join fatura FT on item.FatCod = FT.fatcod
left join tipo_taxa TT on item.cd_tp_tx = TT.cd_tp_tx 
left join paridade PR on  item.cd_tp_moeda = PR.cd_tp_moeda and convert(datetime,dt_par,105) = DBO.hoje(getdate()) and PR.cd_tp_par = 'OFC'
where  fatStatus = 1 and cem.num_lcto is null and ps.apelido like @APELIDO and FatDtVenc between @Inicial and @Final  

union all

select item.fatcod, PS.apelido, TT.Nome_tp_tx, FT.FatDtVenc, item.cd_tp_moeda, dbo.valor(vlr_org,cmea.dc_mea), IsNull(PR.par_moeda,1) from cta_cte_mas_exp_aer cmea
left join caixa_mas_exp_aer as cea on cmea.num_proc_mea = cea.num_proc_mea and cmea.cd_tp_tx = cea.cd_tp_tx and cmea.dc_mea = cea.dc_mea and cea.num_lcto <> 'Provisório' and Convert(DateTime,dt_pgto_rcto_mea,105)<=@Final
left join item_fat as item on cmea.num_proc_mea = item.num_proc and cmea.cd_tp_tx = item.cd_tp_tx and cmea.dc_mea = item.dc
left join pessoa as ps on cmea.cd_cred_dev_mea = ps.cd_pes
left join fatura FT on item.FatCod = FT.fatcod
left join tipo_taxa TT on item.cd_tp_tx = TT.cd_tp_tx 
left join paridade PR on  item.cd_tp_moeda = PR.cd_tp_moeda and convert(datetime,dt_par,105) = DBO.hoje(getdate()) and PR.cd_tp_par = 'OFC'
where  fatStatus = 1 and cea.num_lcto is null and ps.apelido like @APELIDO and FatDtVenc between @Inicial and @Final  






GO
