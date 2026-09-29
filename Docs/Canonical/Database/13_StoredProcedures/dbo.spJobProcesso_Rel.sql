SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE      procedure	spJobProcesso_Rel 
	
		@CSR	varchar(5),
		@Abertura varchar(9)
As

	select 
		US.Nome_Usuario CSR,
		Job_him JOB,
		HOU.num_proc_him Processo, 
		VD.Nome_Usuario Vendedor, 
		Dt_Emis_Him Abertura,
		PSC.Apelido Consignee,
		PSS.Apelido Shipper,
		dbo.spResultado(HOU.num_proc_him)+dbo.spresultado_mas(HOU.num_proc_him)Resultado,
		Convert(Datetime,dt_atrac_mim,105) Data_Oper
	from 
		house_imp_mar HOU
		join job_imp_mar JIM on JIM.num_proc_him=HOU.job_him and left(HOU.num_proc_him,5) <> 'IMJOB'
		join usuario US on  JIM.cd_usuario = US.cd_usuario
		left join pessoa PSC on HOU.cd_consig_him = PSC.cd_pes
		left join pessoa PSS on HOU.cd_import_him = PSS.cd_pes
		left join usuario VD on JIM.cd_vendedor = VD.cd_usuario
		Join Master_imp_mar mas on mas.num_proc_mim=hou.num_proc_mim
	where
 		US.cd_usuario like @CSR and dt_atrac_mim Like @Abertura

Union ALL

	select 
		US.Nome_Usuario CSR,
		Job_hem JOB,
		HOU.num_proc_hem Processo, 
		VD.Nome_Usuario Vendedor, 
		Dt_Emis_hem Abertura,
		PSC.Apelido Consignee,
		PSS.Apelido Shipper, 
		dbo.spResultado(HOU.num_proc_hem)+dbo.spresultado_mas(HOU.num_proc_hem)Resultado,
		Convert(Datetime,Dt_Saida_Mem,105) Data_Oper
	from 
		house_exp_mar HOU

		join job_exp_mar JEM on JEM.num_proc_hem=HOU.job_hem and left(HOU.num_proc_hem,5) <> 'EMJOB'
		join usuario US on  JEM.cd_usuario = US.cd_usuario
		left join pessoa PSC on HOU.cd_consig_hem = PSC.cd_pes
		left join pessoa PSS on HOU.cd_export_hem = PSS.cd_pes
		left join usuario VD on JEM.cd_vendedor = VD.cd_usuario
		Join Master_exp_mar mas on mas.num_proc_mem=hou.num_proc_mem	
	where
 		US.cd_usuario like @CSR and Dt_saida_mem Like @Abertura

Union All

	select 
		US.Nome_Usuario CSR,
		Job_hea JOB,
		HOU.num_proc_hea Processo, 
		VD.Nome_Usuario Vendedor, 
		Dt_Emis_hea Abertura, 
		PSC.Apelido Consignee,
		PSS.Apelido Shipper,
		dbo.spResultado(HOU.num_proc_hea)+dbo.spresultado_mas(HOU.num_proc_hea)Resultado,
		Convert(Datetime,dt_saida_mea,105) Dt_Oper
	from 
		house_exp_aer HOU

		join job_exp_aer JEA on JEA.num_proc_hea=HOU.job_hea and left(HOU.num_proc_hea,5) <> 'EAJOB'
		join usuario US on  JEA.cd_usuario = US.cd_usuario
		left join pessoa PSC on HOU.cd_consig_hea = PSC.cd_pes
		left join pessoa PSS on HOU.cd_export_hea = PSS.cd_pes
		left join usuario VD on JEA.cd_vendedor = VD.cd_usuario
		Join Master_Exp_Aer mas on mas.num_proc_mea=hou.num_proc_mea	
	where
 		US.cd_usuario like @CSR and Dt_Saida_mea Like @Abertura

Union All

	select 
		US.Nome_Usuario CSR,
		Job_hia JOB,
		HOU.num_proc_hia Processo, 
		VD.Nome_Usuario Vendedor, 
		Dt_Emis_hia Abertura, 
		PSC.Apelido Consignee,
		PSS.Apelido Shipper,
		dbo.spResultado(HOU.num_proc_hia)+dbo.spresultado_mas(HOU.num_proc_hia),
		Convert(Datetime,dt_cheg_mia,105) Dt_Oper
	from 
		house_imp_aer HOU

		join job_imp_aer JIA on JIA.num_proc_hia=HOU.job_hia and left(HOU.num_proc_hia,5) <> 'IAJOB'
		join usuario US on  JIA.cd_usuario = US.cd_usuario
		left join pessoa PSC on HOU.cd_consig_hia = PSC.cd_pes
		left join pessoa PSS on HOU.cd_import_hia = PSS.cd_pes
		left join usuario VD on JIA.cd_vendedor = VD.cd_usuario
		Join Master_Imp_Aer mas on mas.num_proc_mia=hou.num_proc_mia
	where
 		US.cd_usuario like @CSR and dt_cheg_mia Like @Abertura









GO
