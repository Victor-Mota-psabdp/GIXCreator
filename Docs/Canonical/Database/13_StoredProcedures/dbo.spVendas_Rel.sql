SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure spVendas_Rel 
			@DataInicial datetime,
			@DataFinal datetime
AS
--Importação Aérea

SELECT 
	apelido,nome_usuario,  org.Nome_local Origem, 
	dst.nome_local Destino,sum(vlr_org_hia*Par_moeda) Valor, count(distinct(hou.num_proc_hia))Qty,  dt_fech 
FROM 
	vendas_fechamento VF
	Left Join house_imp_aer hou on VF.cd_org=cd_org_hia and VF.cd_dst=cd_dst_hia and VF.cd_pes=cd_import_hia
	Left Join cta_cte_hou_imp_aer cta on cta.num_proc_hia=hou.num_proc_hia and cd_tp_tx in (select cd_tp_tx from tipo_taxa where pft_aer='S') and cta.dc_hia='C'
	Join pessoa pp on pp.cd_pes=VF.cd_pes
	Join Usuario US on US.cd_usuario=VF.cd_vendedor
	Join Localidade org on org.cd_local=cd_org
	Join Localidade dst on dst.cd_local=cd_dst
	LEFT JOIN Master_imp_aer mas on mas.num_proc_mia=hou.num_proc_mia
	left join paridade par on par.cd_tp_moeda=cta.cd_Tp_moeda and dt_par=dt_cheg_mia and cd_Tp_par='OFC'
Where 
	convert(datetime,dt_cheg_mia,105) between @DataInicial and @DataFinal
	and left(cd_prop,2)='IA' or mas.num_proc_mia is null
GROUP BY
	apelido,nome_usuario, org.nome_local,dst.nome_local,Dt_Fech


UNION
--Importação Maritima

SELECT 
	apelido,nome_usuario,  org.Nome_local Origem, 
	dst.nome_local Destino,sum(vlr_org_him*par_moeda) Valor,count(distinct(hou.num_proc_him)) Qty,Dt_Fech
 
FROM 
	vendas_fechamento VF
	Left Join house_imp_mar hou on VF.cd_org=cd_org_him and VF.cd_dst=cd_dst_him and VF.cd_pes=cd_import_him
	Left Join cta_cte_hou_imp_mar cta on cta.num_proc_him=hou.num_proc_him and cd_tp_tx in (select cd_tp_tx from tipo_taxa where pft_aer='S') and cta.dc_him='C'
	Join pessoa pp on pp.cd_pes=VF.cd_pes
	Join Usuario US on US.cd_usuario=VF.cd_vendedor
	Join Localidade org on org.cd_local=cd_org
	Join Localidade dst on dst.cd_local=cd_dst
	LEFT JOIN Master_imp_mar mas on mas.num_proc_mim=hou.num_proc_mim
	left join paridade par on par.cd_tp_moeda=cta.cd_Tp_moeda and dt_par=dt_atrac_mim and cd_Tp_par='OFC'
Where 
	convert(datetime,dt_atrac_mim,105) between @DataInicial and @DataFinal
	and left(cd_prop,2)='IM' or mas.num_proc_mim is null
GROUP BY
	apelido,nome_usuario, org.nome_local,dst.nome_local,Dt_Fech


UNION
--Exportação Maritima
SELECT 
	apelido,nome_usuario,  org.Nome_local Origem, 
	dst.nome_local Destino,sum(vlr_org_hem*par_moeda) Valor,count(distinct(hou.num_proc_hem)) Qty,Dt_Fech
 
FROM 
	vendas_fechamento VF
	Left Join house_exp_mar hou on VF.cd_org=cd_org_hem and VF.cd_dst=cd_dst_hem and VF.cd_pes=cd_export_hem
	Left Join cta_cte_hou_exp_mar cta on cta.num_proc_hem=hou.num_proc_hem and cd_tp_tx in (select cd_tp_tx from tipo_taxa where pft_aer='S') and cta.dc_hem='C'
	Join pessoa pp on pp.cd_pes=VF.cd_pes
	Join Usuario US on US.cd_usuario=VF.cd_vendedor
	Join Localidade org on org.cd_local=cd_org
	Join Localidade dst on dst.cd_local=cd_dst
	LEFT JOIN Master_exp_mar mas on mas.num_proc_mem=hou.num_proc_mem
	left join paridade par on par.cd_tp_moeda=cta.cd_Tp_moeda and dt_par=dt_saida_mem and cd_Tp_par='OFC'
Where 
	convert(datetime,dt_saida_mem,105) between @DataInicial and @DataFinal
	and left(cd_prop,2)='EM' or mas.num_proc_mem is null
GROUP BY
	apelido,nome_usuario, org.nome_local,dst.nome_local,Dt_Fech



UNION

SELECT 
	apelido,nome_usuario, org.Nome_local Origem, 
	dst.nome_local Destino,sum(vlr_org_hea*par_moeda) Valor, count(distinct(hou.num_proc_hea)) Qty,  Dt_Fech
 
FROM 
	vendas_fechamento VF
	Left Join house_exp_aer hou on VF.cd_org=cd_org_hea and VF.cd_dst=cd_dst_hea and VF.cd_pes=cd_export_hea
	Left Join cta_cte_hou_exp_aer cta on cta.num_proc_hea=hou.num_proc_hea and cd_tp_tx in (select cd_tp_tx from tipo_taxa where pft_aer='S') and cta.dc_hea='C'
	Join pessoa pp on pp.cd_pes=VF.cd_pes
	Join Usuario US on US.cd_usuario=VF.cd_vendedor
	Join Localidade org on org.cd_local=cd_org
	Join Localidade dst on dst.cd_local=cd_dst
	LEFT JOIN Master_exp_aer mas on mas.num_proc_mea=hou.num_proc_mea
	left join paridade par on par.cd_tp_moeda=cta.cd_Tp_moeda and dt_par=dt_saida_mea and cd_Tp_par='OFC'
Where 
	convert(datetime,dt_saida_mea,105) between @DataInicial and @DataFinal
	and left(cd_prop,2)='EA' or mas.num_proc_mea is null
GROUP BY
	apelido,nome_usuario, org.nome_local,dst.nome_local,Dt_Fech

 




GO
