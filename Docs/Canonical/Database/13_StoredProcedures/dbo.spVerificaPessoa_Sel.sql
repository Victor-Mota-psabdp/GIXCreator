SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure spVerificaPessoa_Sel
	@Cd_pes Varchar(10)

as


select cd_cred_dev_hia from vwcta_cte
where
	convert(datetime,dt_ins_hia,105)>='01-01-2007'
	and cd_cred_dev_hia=@Cd_pes
union  all

select cd_consig_him from house_imp_mar
where
	(cd_consig_him=@Cd_pes or cd_export_him=@cd_pes or cd_import_him=@cd_pes)
	and convert(datetime,dt_emis_him,105)>='01-01-2007'
	

union all

select cd_consig_hia from house_imp_aer
where
	(cd_consig_hia=@Cd_pes or cd_export_hia=@cd_pes or cd_import_hia=@cd_pes)
	and convert(datetime,dt_emis_hia,105)>='01-01-2007'

union all

select cd_consig_hio from house_imp_out
where
	(cd_consig_hio=@Cd_pes or cd_export_hio=@cd_pes or cd_import_hio=@cd_pes)
	and convert(datetime,dt_emis_hio,105)>='01-01-2007'


union all

select cd_consig_heo from house_exp_out
where
	(cd_consig_heo=@Cd_pes or cd_export_heo=@cd_pes or cd_notify_heo=@cd_pes)
	and convert(datetime,dt_emis_heo,105)>='01-01-2007'

union all

select cd_consig_hea from house_exp_aer
where
	(cd_consig_hea=@Cd_pes or cd_export_hea=@cd_pes )	and 
	convert(datetime,dt_emis_hea,105)>='01-01-2007'

union all

select cd_consig_hem from house_exp_mar
where
	(cd_consig_hem=@Cd_pes or cd_export_hem=@cd_pes) 
	and convert(datetime,dt_emis_hem,105)>='01-01-2007'

union all

select cd_cliente from customer_profile
where
	cd_cliente=@cd_pes and data >='01-01-2007'

union all

select cd_pes from pgto_rcto_div
where cd_pes=@cd_pes and convert(datetime,dt_pgto_Rcto_div,105)>='01-01-2007'

GO
