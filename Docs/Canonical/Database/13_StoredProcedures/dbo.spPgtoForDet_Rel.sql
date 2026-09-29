SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure spPgtoForDet_Rel 
		
		@DataInicial	varchar(10),
		@DataFinal	varchar(10),
		@Apelido	varchar(30)

AS

select 
	CLI.Apelido,MAS.dt_saida_mea, Pais_local, hawb_hea,HOU.num_proc_mea,
	vlr_org_hea 

from 
	house_exp_aer HOU

	inner join master_exp_Aer MAS on MAS.num_proc_mea=HOU.num_proc_mea
	inner join pessoa CLI on CLI.cd_pes=HOU.cd_export_hea
	left outer join cta_cte_hou_exp_aer CTA on CTA.num_proc_hea=HOU.num_proc_hea
	left join pessoa PP on CTA.cd_cred_dev_hea=PP.cd_pes
	inner join localidade DST on DST.cd_local=MAS.cd_dst_mea
where 
	pp.apelido = @apelido
	and convert(datetime,dt_saida_mea,105) between convert(datetime,@datainicial,105)
	and convert(datetime,@datafinal,105)






GO
