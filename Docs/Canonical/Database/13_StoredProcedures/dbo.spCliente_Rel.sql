SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  Procedure spCliente_Rel

as

select 
	pe.apelido,MAWB_HEA,HAWB_HEA,Dt_Saida_Mea,tp_frete_hea,nome_tp_tx,cc.cd_tp_moeda,vlr_org_hea
		from house_exp_aer AS HOU

inner join master_exp_aer as mas on (mas.num_proc_mea=hou.num_proc_mea)
inner join pessoa as pp on (cd_consig_hea=cd_pes)
inner join cta_Cte_hou_exp_aer as cc on (cc.num_proc_hea=hou.num_proc_heA and cc.dc_hea='C')
inner join tipo_taxa as tt on (tt.cd_tp_tx=cc.cd_tp_tx)
inner join pessoa as pe on (pe.cd_pes=cd_export_hea)
where pp.apelido like '%GM MÉXICO%' and left(hou.num_proc_hea,5) <> 'EAJOB'
and convert(datetime,Dt_saida_mea,105) >= convert(datetime, '01/01/2004',105) and pft_aer='N'



GO
