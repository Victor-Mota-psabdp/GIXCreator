SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE          procedure spExpUS_Rel (
		@DataInicial varchar(10),
		@DataFinal varchar(10)
)
AS

select 
	left(dst.Bitri,2) Bitri,hou.cd_org_hea Origem, hou.cd_dst_hea Destino, hou.hawb_hea,hou.peso_tax Peso_House,
	sum(hbl.peso_tax) Peso_Total,hou.cd_tp_moeda, Vlr_Frete_MEA,hou.Vlr_Frete_Tot_HEA,
	dbo.Profit_AER(hou.NUM_PROC_HEA) profit,hou.peso_real_hea,mas.dt_saida_mea,left(voo_mea,2) Voo,MAWB_MEA

from house_exp_aer HOU
Join house_exp_aer hbl on HBL.num_proc_mea=HOU.num_proc_mea
Join Localidade ORG on org.cd_local=hou.cd_org_hea
Join Localidade DST on dst.cd_local=hou.cd_dst_hea
join masteR_exp_aer mas on mas.num_proC_mea=hou.num_proc_mea and left(mas.num_proc_mea,5) <> 'EASSZ'
Where convert(datetime,dt_saida_mea,105) between @DataInicial and @DataFinal
group by 
	dst.bitri ,hou.cd_org_hea , hou.cd_dst_hea , 
	hou.cd_tp_moeda, Vlr_Frete_MEA, hou.Vlr_Frete_Tot_HEA, 
	org.nome_local, dst.nome_local, 
	dbo.Profit_AER(hou.NUM_PROC_HEA),hou.hawb_hea,hou.peso_tax,hou.peso_real_hea,mas.dt_saida_mea,left(voo_mea,2),MAWB_MEA












GO
