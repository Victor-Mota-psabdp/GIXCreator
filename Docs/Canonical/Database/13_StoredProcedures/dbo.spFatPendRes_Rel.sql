SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE  procedure spFatPendRes_Rel 



@APELIDO varchar (50),
@INICIAL varchar (10),
@FINAL	varchar (10)

As


select 
	item.fatcod, PS.apelido,  FT.FatDtVenc, sum(dbo.valor(vlr_org,ccea.dc_hea) * isnull(PR.par_moeda,1)) Valor 
from 
	cta_cte_hou_exp_aer ccea
	left join caixa_hou_exp_aer as cea on ccea.num_proc_hea = cea.num_proc_hea and ccea.cd_tp_tx = cea.cd_tp_tx and ccea.dc_hea = cea.dc_hea and cea.num_lcto <> 'Provisório' and Convert(DateTime,dt_pgto_rcto_hea,105) <=@Final
	left join item_fat as item on ccea.num_proc_hea = item.num_proc and ccea.cd_tp_tx = item.cd_tp_tx and ccea.dc_hea = item.dc
	left join pessoa as ps on ccea.cd_cred_dev_hea = ps.cd_pes
	left join fatura FT on item.FatCod = FT.fatcod
	left join paridade PR on  item.cd_tp_moeda = PR.cd_tp_moeda and convert(datetime,dt_par,105) = DBO.hoje(getdate()) and PR.cd_tp_par = 'OFC'
where  
	fatStatus = 1 and cea.num_lcto is null and ps.apelido like @APELIDO and FatDtVenc between @Inicial and @Final 
group by 
	item.fatcod, PS.apelido,  FT.FatDtVenc

union

select 
	item.fatcod, PS.apelido,  FT.FatDtVenc, sum(dbo.valor(vlr_org,ccea.dc_hia) * isnull(PR.par_moeda,1)) Valor 
from 
	cta_cte_hou_imp_aer ccea
	left join caixa_hou_imp_aer as cea on ccea.num_proc_hia = cea.num_proc_hia and ccea.cd_tp_tx = cea.cd_tp_tx and ccea.dc_hia = cea.dc_hia and cea.num_lcto <> 'Provisório' and Convert(DateTime,dt_pgto_rcto_hia,105) <=@Final
	left join item_fat as item on ccea.num_proc_hia = item.num_proc and ccea.cd_tp_tx = item.cd_tp_tx and ccea.dc_hia = item.dc
	left join pessoa as ps on ccea.cd_cred_dev_hia = ps.cd_pes
	left join fatura FT on item.FatCod = FT.fatcod
	left join paridade PR on  item.cd_tp_moeda = PR.cd_tp_moeda and convert(datetime,dt_par,105) = DBO.hoje(getdate()) and PR.cd_tp_par = 'OFC'
where  
	fatStatus = 1 and cea.num_lcto is null and ps.apelido like @APELIDO and FatDtVenc between @Inicial and @Final 
group by 
	item.fatcod, PS.apelido,  FT.FatDtVenc

UNION

select 
	item.fatcod, PS.apelido,  FT.FatDtVenc, sum(dbo.valor(vlr_org,ccea.dc_hem) * isnull(PR.par_moeda,1)) Valor 
from 
	cta_cte_hou_exp_mar ccea
	left join caixa_hou_exp_mar as cea on ccea.num_proc_hem = cea.num_proc_hem and ccea.cd_tp_tx = cea.cd_tp_tx and ccea.dc_hem = cea.dc_hem and cea.num_lcto <> 'Provisório' and Convert(DateTime,dt_pgto_rcto_hem,105) <=@Final
	left join item_fat as item on ccea.num_proc_hem = item.num_proc and ccea.cd_tp_tx = item.cd_tp_tx and ccea.dc_hem = item.dc
	left join pessoa as ps on ccea.cd_cred_dev_hem = ps.cd_pes
	left join fatura FT on item.FatCod = FT.fatcod
	left join paridade PR on  item.cd_tp_moeda = PR.cd_tp_moeda and convert(datetime,dt_par,105) = DBO.hoje(getdate()) and PR.cd_tp_par = 'OFC'
where  
	fatStatus = 1 and cea.num_lcto is null and ps.apelido like @APELIDO and FatDtVenc between @Inicial and @Final 
group by 
	item.fatcod, PS.apelido,  FT.FatDtVenc

union

select 
	item.fatcod, PS.apelido,  FT.FatDtVenc, sum(dbo.valor(vlr_org,ccea.dc_him) * isnull(PR.par_moeda,1)) Valor 
from 
	cta_cte_hou_imp_mar ccea
	left join caixa_hou_imp_mar as cea on ccea.num_proc_him = cea.num_proc_him and ccea.cd_tp_tx = cea.cd_tp_tx and ccea.dc_him = cea.dc_him and cea.num_lcto <> 'Provisório' and Convert(DateTime,dt_pgto_rcto_him,105) <=@Final
	left join item_fat as item on ccea.num_proc_him = item.num_proc and ccea.cd_tp_tx = item.cd_tp_tx and ccea.dc_him = item.dc
	left join pessoa as ps on ccea.cd_cred_dev_him = ps.cd_pes
	left join fatura FT on item.FatCod = FT.fatcod
	left join paridade PR on  item.cd_tp_moeda = PR.cd_tp_moeda and convert(datetime,dt_par,105) = DBO.hoje(getdate()) and PR.cd_tp_par = 'OFC'
where  
	fatStatus = 1 and cea.num_lcto is null and ps.apelido like @APELIDO and FatDtVenc between @Inicial and @Final 
group by 
	item.fatcod, PS.apelido,  FT.FatDtVenc




GO
