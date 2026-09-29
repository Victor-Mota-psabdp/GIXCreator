SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE  PROCEDURE SpJobRel

		@Cliente	varchar(30)

As
if @cliente=''
	select house_imp_aer.num_proc_hia as PROCESSO, apelido as CLIENTE, numero_po_hia as PO, Origem.Nome_local as DE, Destino.nome_local as PARA from house_imp_Aer

	inner join pessoa on (cd_import_hia=cd_pes)
	left join po_hia on (job_hia=po_hia.num_proc_hia)
	inner join localidade as Origem on (origem.cd_local=cd_org_hia)
	inner join localidade as Destino on (destino.cd_local=cd_dst_hia) 

	where left(house_imp_aer.num_proc_hia,5)='IAJOB'


	union

	select house_imp_mar.num_proc_him as PROCESSO, apelido as CLIENTE, numero_PO_HIM as PO, Origem.Nome_local as DE, Destino.nome_local as PARA from house_imp_mar

	inner join pessoa on (cd_imporT_him=cd_pes)
	left join po_him on (job_him=po_him.num_proc_him)
	inner join localidade as Origem on (origem.cd_local=cd_org_him)
	inner join localidade as Destino on (destino.cd_local=cd_dst_him) 

	where left(housE_imp_mar.num_proc_him, 5) = 'IMJOB'
	

	union

	select house_EXp_aer.num_proc_hea as PROCESSO, apelido as CLIENTE, numero_po_hEa as PO, Origem.Nome_local as DE, Destino.nome_local as PARA from house_EXP_Aer

	inner join pessoa on (cd_export_hea=cd_pes)
	left join po_hea on (job_hea=po_hea.num_proc_hea)
	inner join localidade as Origem on (origem.cd_local=cd_org_hea)
	inner join localidade as Destino on (destino.cd_local=cd_dst_hea) 
	
	where left(house_exp_aer.num_proc_hea,5)='EAJOB'
	

	union

	select house_exp_mar.num_proc_hem as PROCESSO, apelido as CLIENTE, numero_po_hem as PO, Origem.Nome_local as DE, Destino.nome_local as PARA from house_exp_mar
	
	inner join pessoa on (cd_export_hem=cd_pes)
	left join po_hem on (job_hem=po_hem.num_proc_hem)
	inner join localidade as Origem on (origem.cd_local=cd_org_hem)
	inner join localidade as Destino on (destino.cd_local=cd_dst_hem) 

	where left(house_exp_mar.num_proc_hem,5)='EMJOB'

else

	select house_imp_aer.num_proc_hia as PROCESSO, apelido as CLIENTE, numero_po_hia as PO, Origem.Nome_local as DE, Destino.nome_local as PARA from house_imp_Aer

	inner join pessoa on (cd_import_hia=cd_pes)
	left join po_hia on (job_hia=po_hia.num_proc_hia)
	inner join localidade as Origem on (origem.cd_local=cd_org_hia)
	inner join localidade as Destino on (destino.cd_local=cd_dst_hia) 

	where left(house_imp_aer.num_proc_hia,5)='IAJOB' and apelido=@cliente


	union

	select house_imp_mar.num_proc_him as PROCESSO, apelido as CLIENTE, numero_PO_HIM as PO, Origem.Nome_local as DE, Destino.nome_local as PARA from house_imp_mar

	inner join pessoa on (cd_imporT_him=cd_pes)
	left join po_him on (job_him=po_him.num_proc_him)
	inner join localidade as Origem on (origem.cd_local=cd_org_him)
	inner join localidade as Destino on (destino.cd_local=cd_dst_him) 

	where left(housE_imp_mar.num_proc_him, 5) = 'IMJOB' and apelido=@cliente
	

	union

	select house_EXp_aer.num_proc_hea as PROCESSO, apelido as CLIENTE, numero_po_hEa as PO, Origem.Nome_local as DE, Destino.nome_local as PARA from house_EXP_Aer

	inner join pessoa on (cd_export_hea=cd_pes)
	left join po_hea on (job_hea=po_hea.num_proc_hea)
	inner join localidade as Origem on (origem.cd_local=cd_org_hea)
	inner join localidade as Destino on (destino.cd_local=cd_dst_hea) 
		
	where left(house_exp_aer.num_proc_hea,5)='EAJOB' and apelido=@cliente
	

	union

	select house_exp_mar.num_proc_hem as PROCESSO, apelido as CLIENTE, numero_po_hem as PO, Origem.Nome_local as DE, Destino.nome_local as PARA from house_exp_mar
	
	inner join pessoa on (cd_export_hem=cd_pes)
	left join po_hem on (job_hem=po_hem.num_proc_hem)
	inner join localidade as Origem on (origem.cd_local=cd_org_hem)
	inner join localidade as Destino on (destino.cd_local=cd_dst_hem) 

	where left(house_exp_mar.num_proc_hem,5)='EMJOB' and apelido=@cliente
GO
