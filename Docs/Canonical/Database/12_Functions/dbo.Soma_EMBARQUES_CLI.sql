SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










CREATE         Function Soma_EMBARQUES_CLI   


	(
		@DataInicial  Varchar(10),
		@DataFinal VarChar(10),
		@cdpes varchar(10),
		@cdvend varchar(5)= NULL,
		@cdcust varchar (5)
	)
RETURNS int

Begin

--Exportação Aerea	
	
	Declare @Saida int

	set @Saida=
		IsNull((select count (HEA.job_hea)Tot_exp_aer_hou from house_exp_aer HEA
		  join master_exp_aer MEA on HEA.num_proc_mea = MEA.num_proc_mea
		  join job_exp_aer JEA on hea.job_hea = JEA.num_proc_hea
		  left join usuario USV on JEA.cd_vendedor = USV.cd_usuario
		  left join usuario USC on JEA.cd_usuario = USC.cd_usuario
		  where convert (datetime, MEA.dt_saida_mea, 105) between @DataInicial and @DataFinal and HEA.cd_export_hea = @cdpes and USV.cd_usuario like  isnull(@cdvend,'%') and USC.cd_usuario = @cdcust and left(HEA.job_hea, 5) = 'eajob') 
		  ,0)

--Exportação Maritima

	set @Saida = @saida +(
	IsNull((select count (HEM.job_HEM)Tot_exp_mar_hou from house_exp_mar HEM
		  join master_exp_mar mem on HEM.num_proc_mem = mem.num_proc_mem
		  join job_exp_mar JEM on heM.job_hem = JEM.num_proc_hem
		  left join usuario USV on JEM.cd_vendedor = USV.cd_usuario
		  left join usuario USC on JEM.cd_usuario = USC.cd_usuario
		  where convert (datetime, mem.dt_saida_mem, 105) between @DataInicial and @DataFinal and HEM.cd_export_HEM = @cdpes and USV.cd_usuario like isnull(@cdvend,'%') and USC.cd_usuario = @cdcust  and left(HEM.job_HEM, 5) = 'emjob')
		  ,0))

--Importação Aerea

	set @Saida = @saida +(
		IsNull((select count (HIA.job_HIA)Tot_imp_aer_hou from house_imp_aer HIA
		  join master_imp_aer MIA on HIA.num_proc_MIA = MIA.num_proc_MIA
		  join job_imp_aer JIA on hia.job_hia = JIA.num_proc_hia
		  left join usuario USV on JIA.cd_vendedor = USV.cd_usuario
		  left join usuario USC on JIA.cd_usuario = USC.cd_usuario
		  where convert (datetime, MIA.dt_cheg_MIA, 105) between @DataInicial and @DataFinal and HIA.cd_import_HIA = @cdpes and USV.cd_usuario like  isnull(@cdvend,'%') and USC.cd_usuario = @cdcust and left(HIA.job_HIA, 5) = 'Iajob')
		  ,0))


--Importação Maritimo

	set @Saida = @saida +(
		IsNull((select count (HIM.job_HIM)Tot_imp_mar_hou from house_imp_mar HIM
		  join master_imp_mar MIM on HIM.num_proc_MIM = MIM.num_proc_MIM
		  join job_imp_mar JIM on hiM.job_him = JIM.num_proc_hiM
		  left join usuario USV on JIM.cd_vendedor = USV.cd_usuario
		  left join usuario USC on JIM.cd_usuario = USC.cd_usuario
		  where convert (datetime, MIM.dt_atrac_MIM, 105) between @DataInicial and @DataFinal and HIM.cd_import_HIM = @cdpes and USV.cd_usuario like IsNull(@cdvend,'%') and USC.cd_usuario = @cdcust and left(HIM.job_HIM, 5) = 'imjob')
		  ,0))



	Return @SAida

END










GO
