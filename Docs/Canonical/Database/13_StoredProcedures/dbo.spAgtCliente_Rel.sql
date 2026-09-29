SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  Procedure spAgtCliente_Rel 

	@dataInicial varchar(4)

AS

SELECT 
	sh.apelido Shipper, pp.Apelido Cliente, pp.cd_tp_grupo, 
	count(distinct(hou.num_proc_hia)) Embarques, 
	sum(dbo.valor(cta.vlr_Pgto_NF_hia,cta.dc_hia)) Faturamento 
FROM 
	MASTER_IMP_AER mas
	Join PESSOA SH ON sh.cd_pes=cd_export_mia
	Join house_imp_aer hou on hou.num_proc_mia=mas.num_proc_mia
	Join pessoa pp on pp.cd_pes=cd_import_hia
	Join cta_cte_hou_imp_aer cta on cta.num_proc_hia=hou.num_proc_hia

where 
	year(convert(datetime,dt_cheg_mia,105))=@Datainicial

GROUP BY
	sh.apelido , pp.Apelido ,pp.cd_tp_grupo


UNION ALL


SELECT 
	sh.apelido Shipper, pp.Apelido Cliente, pp.cd_tp_grupo, 
	count(distinct(hou.num_proc_him)) Embarques, 
	sum(dbo.valor(cta.vlr_Pgto_NF_him,cta.dc_him)) Faturamento 

FROM 
	MASTER_IMP_mar mas
	JOIN PESSOA SH ON sh.cd_pes=cd_export_mim
	Join house_imp_mar hou on hou.num_proc_mim=mas.num_proc_mim
	Join pessoa pp on pp.cd_pes=cd_import_him
	Join cta_cte_hou_imp_mar cta on cta.num_proc_him=hou.num_proc_him

WHERE
	year(convert(datetime,dt_atrac_mim,105))=@Datainicial

GROUP BY
	sh.apelido , pp.Apelido ,pp.cd_tp_grupo

UNION ALL

SELECT 
	sh.apelido Shipper, pp.Apelido Cliente, pp.cd_tp_grupo, 
	count(distinct(hou.num_proc_HEA)) Embarques, 
	sum(dbo.valor(cta.vlr_Pgto_NF_HEA,cta.dc_HEA)) Faturamento 
FROM 
	MASTER_exp_AER mas
	Join PESSOA SH ON sh.cd_pes=cd_CONSIG_MEA
	Join house_EXP_aer hou on hou.num_proc_MEA=mas.num_proc_MEA
	Join pessoa pp on pp.cd_pes=cd_EXport_HEA
	Join cta_cte_hou_EXP_aer cta on cta.num_proc_HEA=hou.num_proc_HEA

where 
	year(convert(datetime,dt_SAIDA_MEA,105))=@Datainicial

GROUP BY
	sh.apelido , pp.Apelido ,pp.cd_tp_grupo

UNION ALL

SELECT 
	sh.apelido Shipper, pp.Apelido Cliente, pp.cd_tp_grupo, 
	count(distinct(hou.num_proc_HEM)) Embarques, 
	sum(dbo.valor(cta.vlr_Pgto_NF_HEM,cta.dc_HEM)) Faturamento 
FROM 
	MASTER_exp_MAR mas
	Join PESSOA SH ON sh.cd_pes=cd_CONSIG_MEM
	Join house_EXP_MAR hou on hou.num_proc_MEM=mas.num_proc_MEM
	Join pessoa pp on pp.cd_pes=cd_EXport_HEM
	Join cta_cte_hou_EXP_MAR cta on cta.num_proc_HEM=hou.num_proc_HEM

where 
	year(convert(datetime,dt_SAIDA_MEM,105))=@Datainicial

GROUP BY
	sh.apelido , pp.Apelido ,pp.cd_tp_grupo







GO
