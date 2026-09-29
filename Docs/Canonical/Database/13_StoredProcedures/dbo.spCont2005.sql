SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE        procedure spCont2005

	@Cred_Dev varchar (30),
	@Tipo_Taxa varchar (30),
	@DataFinal varchar (10)

As

select 'HEA' Modal, hea.num_proc_hea N_Processo, tt.Nome_tp_tx, ps.apelido, hea.cd_tp_moeda Moeda, hea.vlr_org_hea, PAR.Par_moeda Paridade_Dia,OFC.Par_Moeda Par_Oficial, hea.dc_hea from cta_cte_hou_exp_aer hea
left join caixa_hou_exp_aer chea on chea.num_proc_hea = hea.num_proc_hea and chea.cd_tp_tx = hea.cd_tp_tx and chea.dc_hea = hea.dc_hea and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hea,105) <= @DataFinal
left join paridade PAR on PAR.cd_tp_moeda=hea.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,dt_ins_hea,105) and PAR.cd_tp_par='OFC'
left join paridade OFC on OFC.cd_tp_moeda=hea.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,'31/12/2005',105) and OFC.cd_tp_par='OFC'
join tipo_taxa tt on tt.cd_tp_tx = hea.cd_tp_tx
join pessoa ps on ps.cd_pes = hea.cd_cred_dev_hea
where chea.num_lcto is null and convert(datetime,dt_ins_hea,105) <= '12-31-2005' and tt.nome_tp_tx like @tipo_taxa and ps.apelido like @Cred_Dev and hea.Desp_dst_hea = 'N'

Union

select 'MEA' Modal, mea.num_proc_mea N_Processo, tt.Nome_tp_tx, ps.apelido, mea.cd_tp_moeda Moeda, mea.vlr_org_mea, PAR.Par_moeda Paridade_Dia,OFC.Par_Moeda Par_Oficial, mea.dc_mea from cta_cte_mas_exp_aer mea
left join caixa_mas_exp_aer cmea on cmea.num_proc_mea = mea.num_proc_mea and cmea.cd_tp_tx = mea.cd_tp_tx and cmea.dc_mea = mea.dc_mea and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_mea,105) <= @DataFinal
left join paridade PAR on PAR.cd_tp_moeda=mea.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,dt_ins_mea,105) and PAR.cd_tp_par='OFC'
left join paridade OFC on OFC.cd_tp_moeda=mea.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,'31/12/2005',105) and OFC.cd_tp_par='OFC'
join tipo_taxa tt on tt.cd_tp_tx = mea.cd_tp_tx
join pessoa ps on ps.cd_pes = mea.cd_cred_dev_mea
where cmea.num_lcto is null and convert(datetime,dt_ins_mea,105) <= '12-31-2005' and tt.nome_tp_tx like @tipo_taxa and ps.apelido like @Cred_Dev and mea.Desp_dst_mea = 'N'

Union

select 'HIA' Modal, hia.num_proc_hia N_Processo, tt.Nome_tp_tx, ps.apelido, hia.cd_tp_moeda Moeda, hia.vlr_org_hia, PAR.Par_moeda Paridade_Dia,OFC.Par_Moeda Par_Oficial, hia.dc_hia from cta_cte_hou_imp_aer hia
left join caixa_hou_imp_aer chia on chia.num_proc_hia = hia.num_proc_hia and chia.cd_tp_tx = hia.cd_tp_tx and chia.dc_hia = hia.dc_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105) <= @DataFinal
left join paridade PAR on PAR.cd_tp_moeda=hia.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,dt_ins_hia,105) and PAR.cd_tp_par='OFC'
left join paridade OFC on OFC.cd_tp_moeda=hia.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,'31/12/2005',105) and OFC.cd_tp_par='OFC'
join tipo_taxa tt on tt.cd_tp_tx = hia.cd_tp_tx
join pessoa ps on ps.cd_pes = hia.cd_cred_dev_hia
where chia.num_lcto is null and convert(datetime,dt_ins_hia,105) <= '12-31-2005' and tt.nome_tp_tx like @tipo_taxa and ps.apelido like @Cred_Dev and hia.Desp_org_hia = 'N'


Union

select 'MIA' Modal, mia.num_proc_mia N_Processo, tt.Nome_tp_tx, ps.apelido, mia.cd_tp_moeda Moeda, mia.vlr_org_mia, PAR.Par_moeda Paridade_Dia,OFC.Par_Moeda Par_Oficial, mia.dc_mia from cta_cte_mas_imp_aer mia
left join caixa_mas_imp_aer cmia on cmia.num_proc_mia = mia.num_proc_mia and cmia.cd_tp_tx = mia.cd_tp_tx and cmia.dc_mia = mia.dc_mia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_mia,105) <= @DataFinal
left join paridade PAR on PAR.cd_tp_moeda=mia.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,dt_ins_mia,105) and PAR.cd_tp_par='OFC'
left join paridade OFC on OFC.cd_tp_moeda=mia.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,'31/12/2005',105) and OFC.cd_tp_par='OFC'
join tipo_taxa tt on tt.cd_tp_tx = mia.cd_tp_tx
join pessoa ps on ps.cd_pes = mia.cd_cred_dev_mia
where cmia.num_lcto is null and convert(datetime,dt_ins_mia,105) <= '12-31-2005' and tt.nome_tp_tx like @tipo_taxa and ps.apelido like @Cred_Dev and mia.Desp_org_mia = 'N'

Union

select 'HEM' Modal, hem.num_proc_hem N_Processo, tt.Nome_tp_tx, ps.apelido, hem.cd_tp_moeda Moeda, hem.vlr_org_hem, PAR.Par_moeda Paridade_Dia,OFC.Par_Moeda Par_Oficial, hem.dc_hem from cta_cte_hou_exp_mar hem
left join caixa_hou_exp_mar chem on chem.num_proc_hem = hem.num_proc_hem and chem.cd_tp_tx = hem.cd_tp_tx and chem.dc_hem = hem.dc_hem and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hem,105) <= @DataFinal
left join paridade PAR on PAR.cd_tp_moeda=hem.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,dt_ins_hem,105) and PAR.cd_tp_par='OFC'
left join paridade OFC on OFC.cd_tp_moeda=hem.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,'31/12/2005',105) and OFC.cd_tp_par='OFC'
join tipo_taxa tt on tt.cd_tp_tx = hem.cd_tp_tx
join pessoa ps on ps.cd_pes = hem.cd_cred_dev_hem
where chem.num_lcto is null and convert(datetime,dt_ins_hem,105) <= '12-31-2005' and tt.nome_tp_tx like @tipo_taxa and ps.apelido like @Cred_Dev and hem.Desp_dst_hem = 'N'

Union

select 'MEM' Modal, mem.num_proc_mem N_Processo, tt.Nome_tp_tx, ps.apelido, mem.cd_tp_moeda Moeda, mem.vlr_org_mem, PAR.Par_moeda Paridade_Dia,OFC.Par_Moeda Par_Oficial, mem.dc_mem from cta_cte_mas_exp_mar mem
left join caixa_mas_exp_mar cmem on cmem.num_proc_mem = mem.num_proc_mem and cmem.cd_tp_tx = mem.cd_tp_tx and cmem.dc_mem = mem.dc_mem and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_mem,105) <= @DataFinal
left join paridade PAR on PAR.cd_tp_moeda=mem.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,dt_ins_mem,105) and PAR.cd_tp_par='OFC'
left join paridade OFC on OFC.cd_tp_moeda=mem.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,'31/12/2005',105) and OFC.cd_tp_par='OFC'
join tipo_taxa tt on tt.cd_tp_tx = mem.cd_tp_tx
join pessoa ps on ps.cd_pes = mem.cd_cred_dev_mem
where cmem.num_lcto is null and convert(datetime,dt_ins_mem,105) <= '12-31-2005' and tt.nome_tp_tx like @tipo_taxa and ps.apelido like @Cred_Dev and mem.Desp_dst_mem = 'N'

Union

select 'HIM' Modal, him.num_proc_him N_Processo, tt.Nome_tp_tx, ps.apelido, him.cd_tp_moeda Moeda, him.vlr_org_him, PAR.Par_moeda Paridade_Dia,OFC.Par_Moeda Par_Oficial, him.dc_him from cta_cte_hou_imp_mar him
left join caixa_hou_imp_mar chim on chim.num_proc_him = him.num_proc_him and chim.cd_tp_tx = him.cd_tp_tx and chim.dc_him = him.dc_him and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_him,105) <= @DataFinal
left join paridade PAR on PAR.cd_tp_moeda=him.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,dt_ins_him,105) and PAR.cd_tp_par='OFC'
left join paridade OFC on OFC.cd_tp_moeda=him.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,'31/12/2005',105) and OFC.cd_tp_par='OFC'
join tipo_taxa tt on tt.cd_tp_tx = him.cd_tp_tx
join pessoa ps on ps.cd_pes = him.cd_cred_dev_him
where chim.num_lcto is null and convert(datetime,dt_ins_him,105) <= '12-31-2005' and tt.nome_tp_tx like @tipo_taxa and ps.apelido like @Cred_Dev and him.Desp_org_him = 'N'

Union

select 'MIM' Modal, mim.num_proc_mim N_Processo, tt.Nome_tp_tx, ps.apelido, mim.cd_tp_moeda Moeda, mim.vlr_org_mim, PAR.Par_moeda Paridade_Dia,OFC.Par_Moeda Par_Oficial, mim.dc_mim from cta_cte_mas_imp_mar mim
left join caixa_mas_imp_mar cmim on cmim.num_proc_mim = mim.num_proc_mim and cmim.cd_tp_tx = mim.cd_tp_tx and cmim.dc_mim = mim.dc_mim and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_mim,105) <= @DataFinal
left join paridade PAR on PAR.cd_tp_moeda=mim.cd_tp_moeda and convert(datetime,PAR.dt_par,105)=convert(datetime,dt_ins_mim,105) and PAR.cd_tp_par='OFC'
left join paridade OFC on OFC.cd_tp_moeda=mim.cd_tp_moeda and convert(datetime,OFC.dt_par,105)=convert(datetime,'31/12/2005',105) and OFC.cd_tp_par='OFC'
join tipo_taxa tt on tt.cd_tp_tx = mim.cd_tp_tx
join pessoa ps on ps.cd_pes = mim.cd_cred_dev_mim
where cmim.num_lcto is null and convert(datetime,dt_ins_mim,105) <= '12-31-2005' and tt.nome_tp_tx like @tipo_taxa and ps.apelido like @Cred_Dev and mim.Desp_org_mim = 'N'






GO
