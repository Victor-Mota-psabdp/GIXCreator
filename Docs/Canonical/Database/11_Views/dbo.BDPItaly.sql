SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW BDPITALY

AS
SELECT 
	'IA' Modal,'Emb' Tipo, pp.apelido,count(distinct(hou.num_proc_hia)) Valor,
	month(convert(datetime,dt_cheg_mia,105)) Mes

FROM house_imp_aer hou

	Join pessoa pp on pp.cd_pes=cd_import_hia
	Join relacao rel on pp.cd_pes=cd_pes_a and cd_tp_rel='AGT'
	Join pessoa Agt on agt.cd_pes=cd_pes_b
	Join Master_Imp_aer mas on mas.num_proc_mia=hou.num_proC_mia

where left(hou.num_proc_hia,5)<>'IAJOB' and year(convert(datetime,dt_cheg_mia,105))=2006

Group by pp.apelido,month(convert(datetime,dt_cheg_mia,105))	

Union all


SELECT 
	'IA' Modal,'REC' Tipo, pp.apelido,SUM(dbo.valor(Vlr_Pgto_NF_HIA,cta.dc_hia))Valor,
	month(emissao) Mes

FROM house_imp_aer hou

	Join pessoa pp on pp.cd_pes=cd_import_hia
	Join relacao rel on pp.cd_pes=cd_pes_a and cd_tp_rel='AGT'
	Join pessoa Agt on agt.cd_pes=cd_pes_b
	Left Outer Join Cta_Cte_hou_imp_aer cta on cta.num_proc_hia=hou.num_proc_hia
	Left Outer Join Base_nota_fiscal nf on cta.num_nf_hia=nota_fiscal and ref_acesso_nf_hia=ref_acesso

where left(hou.num_proc_hia,5)<>'IAJOB' and
year(emissao)=2006

Group by pp.apelido,month(emissao)


UNION ALL



SELECT 
	'IM' Modal,'Emb' Tipo, pp.apelido,count(distinct(hou.num_proc_him)) Valor,
	month(convert(datetime,dt_atrac_mim,105)) Mes

FROM house_imp_mar hou

	Join pessoa pp on pp.cd_pes=cd_import_him
	Join relacao rel on pp.cd_pes=cd_pes_a and cd_tp_rel='AGT'
	Join pessoa Agt on agt.cd_pes=cd_pes_b
	Join Master_Imp_mar mas on mas.num_proc_mim=hou.num_proC_mim

where left(hou.num_proc_him,5)<>'imjob' and year(convert(datetime,dt_atraC_mim,105))=2006

Group by pp.apelido,month(convert(datetime,dt_atrac_mim,105))	

Union all


SELECT 
	'IM' Modal,'REC' Tipo, pp.apelido,SUM(dbo.valor(Vlr_Pgto_NF_him,cta.dc_him))Valor,
	month(emissao) Mes

FROM house_imp_mar hou

	Join pessoa pp on pp.cd_pes=cd_import_him
	Join relacao rel on pp.cd_pes=cd_pes_a and cd_tp_rel='AGT'
	Join pessoa Agt on agt.cd_pes=cd_pes_b
	Left Outer Join Cta_Cte_hou_imp_mar cta on cta.num_proc_him=hou.num_proc_him
	Left Outer Join Base_nota_fiscal nf on cta.num_nf_him=nota_fiscal and ref_acesso_nf_him=ref_acesso

where left(hou.num_proc_him,5)<>'imjob' and
year(emissao)=2006

Group by pp.apelido,month(emissao)





GO
