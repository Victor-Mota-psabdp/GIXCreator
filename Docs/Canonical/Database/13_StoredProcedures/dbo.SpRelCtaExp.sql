SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE SpRelCtaExp

as



select 
	cta.num_proc_hea, mawb_hea, hawb_hea, de.nome_local as Origem, 
	para.nome_local as Destino, dt_saida_mea, ex.apelido as Exportador, 
	cs.apelido as Consignee, Qtd_tot_vol_hea,   Peso_real_hea, tp_frete_hea, 
	nome_tp_tx, cta.cd_tp_moeda, vlr_org_hea


from 
	cta_cte_hou_exp_aer as cta

inner join house_exp_aer as hou on (cta.num_proc_hea=hou.num_proc_heA)
inner join master_exp_aer as mas on (mas.num_proc_mea=hou.num_proc_mea)
inner join localidade as de on (de.cd_local=hou.cd_org_hea)
inner join localidade as para on (para.cd_local=hou.cd_dst_hea)
inner join pessoa as cs on (hou.cd_consig_hea=cs.cd_pes)
inner join pessoa as ex on (hou.cd_export_hea=ex.cd_pes)
inner join pessoa as cd on (cd.cd_pes=cd_cred_dev_hea)
inner join tipo_taxa as tt on (tt.cd_tp_tx=cta.cd_tp_Tx)

where	
	cs.apelido like 'GM%' and 
	(dt_saida_mea like '%%/02/2004' or dt_saida_mea like '%%/12/2003')
	and cd.apelido like 'GM %'
	and desp_dst_hea='N'



GO
