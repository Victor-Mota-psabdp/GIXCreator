SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE                         		procedure spEvol_Fatur 

	(
		@DataInicial VarChar(10),
		@DataFinal VarChar(10),
		@DataInicial_ant VarChar(10),
		@DataFinal_ant VarChar(10),
		@cdpes varchar(10),
		@cdvend varchar(5),
		@cdcust varchar (5)
	)
AS

--Exportao Aerea

	select 
		'EA' Modal,hea.num_proc_hea, upper (ps.nome_raz_soc) Cliente,count(hea.job_hea) Emb_exp_aer, 
		0 embarques_atual,--DBO.Soma_Embarques_cli (@DataInicial, @DataFinal,hea.cd_export_hea, usv.cd_usuario, usc.cd_usuario) Processos_Atual, 
		DBO.Soma_Embarques_cli (@DataInicial_ant, @DataFinal_ant,hea.cd_export_hea, usv.cd_usuario, usc.cd_usuario) Processos_ant, 
		DBO.spresultado(hea.num_proc_hea) Faturamento_Atual_hou, dbo.spresultado_mas(hea.num_proc_hea) Faturamento_Atual_mas,
		dbo.soma_receita_cli(@DataInicial_ant,cd_export_hea, usv.cd_usuario, usc.cd_usuario) Faturamento_ant, 
		Isnull(USV.nome_usuario,'SEM VENDEDOR') Vendedor, USC.nome_usuario CSR 
	from 
		job_exp_aer JEM
		join house_exp_aer hea on JEM.num_proc_hea = hea.job_hea
		left join usuario USV on isnull(JEM.cd_vendedor,'COM') = USV.cd_usuario
		left join usuario USC on JEM.cd_usuario = USC.cd_usuario
		left join pessoa PS on hea.cd_export_hea = Ps.cd_pes
		left join master_exp_aer mea on hea.num_proc_mea = mea.num_proc_mea
	where 
		hea.cd_export_hea like @cdpes and usv.cd_usuario like @cdvend and usc.cd_usuario like @cdcust and convert (datetime, mea.dt_saida_mea, 105) between @DataInicial and @DataFinal
	group by  
		ps.nome_raz_soc, USC.nome_usuario, 
		Isnull(USV.nome_usuario,'SEM VENDEDOR'),
		HEA.cd_export_hea,
		usv.cd_usuario, 
		usc.cd_usuario,
		hea.num_proc_hea,
		DBO.spresultado(hea.num_proc_hea), 
		dbo.spresultado_mas(hea.num_proc_hea) 
	
UNION
--Exportao Maritimo
	
	select 
		'EM' Modal,hem.num_proc_hem, upper (ps.nome_raz_soc) Cliente,count(hem.job_hem) Emb_Exp_mar, 
		0 embarques_atual,--DBO.Soma_Embarques_cli (@DataInicial, @DataFinal,hem.cd_export_hem, usv.cd_usuario, usc.cd_usuario) Processos_Atual, 
		DBO.Soma_Embarques_cli (@DataInicial_ant, @DataFinal_ant,hem.cd_export_hem, usv.cd_usuario, usc.cd_usuario) Processos_ant, 
		DBO.spResultado (hem.num_proc_hem)Faturamento_Atual_hou, dbo.spResultado_mas(hem.num_proc_hem) Faturamento_Atual_mas, 
		dbo.soma_receita_cli(@DataInicial_ant,cd_export_hem,usv.cd_usuario, usc.cd_usuario) Faturamento_ant, 
		Isnull(USV.nome_usuario, 'SEM VENDEDOR') Vendedor, USC.nome_usuario CSR 
	from 
		job_exp_Mar JEM
		join house_exp_mar HEM on JEM.num_proc_hem = HEM.job_hem
		left join usuario USV on isnull(JEM.cd_vendedor,'COM') = USV.cd_usuario
		left join usuario USC on JEM.cd_usuario = USC.cd_usuario
		left join pessoa PS on HEM.cd_export_hem = Ps.cd_pes
		left join master_exp_mar MEM on HEM.num_proc_mem = MEM.num_proc_mem
		where HEM.cd_export_hem like @cdpes and usv.cd_usuario like @cdvend and usc.cd_usuario like @cdcust and convert (datetime, mem.dt_saida_mem, 105) between @DataInicial and @DataFinal
		group by  
			ps.nome_raz_soc, 
			USC.nome_usuario, 
			Isnull(USV.nome_usuario,'SEM VENDEDOR'),
			HEM.cd_export_hem,
			usv.cd_usuario, 
			usc.cd_usuario,
			hem.num_proc_hem,
			DBO.spResultado (hem.num_proc_hem), 
			dbo.spResultado_mas(hem.num_proc_hem)
	
UNION
--Importao Aerea

	select 
		'IA' Modal,hia.num_proc_hia,upper (ps.nome_raz_soc) Cliente,count(hia.job_hia) Emb_imp_aer, 
		0 embarques_atual,--DBO.Soma_Embarques_cli (@DataInicial, @DataFinal,hia.cd_import_hia, usv.cd_usuario, usc.cd_usuario) Processos_Atual, 
		DBO.Soma_Embarques_cli (@DataInicial_ant, @DataFinal_ant,hia.cd_import_hia, usv.cd_usuario, usc.cd_usuario) Processos_ant, 
		dbo.spresultado(hia.num_proc_hia) Faturamento_Atual_hou, dbo.spresultado_mas(hia.num_proc_hia) Faturamento_Atual_mas,
		dbo.soma_receita_cli(@DataInicial_ant,cd_import_hia,usv.cd_usuario,usc.cd_usuario)Faturamento_ant, 
		Isnull(USV.nome_usuario,'SEM VENDEDOR'), USC.nome_usuario CSR 
	from 
		job_imp_aer JIA
		join house_imp_aer hia on JIA.num_proc_hia = hia.job_hia
		left join usuario USV on JIA.cd_vendedor = USV.cd_usuario
		left join usuario USC on JIA.cd_usuario = USC.cd_usuario
		left join pessoa PS on hia.cd_import_hia = Ps.cd_pes
		left join master_imp_aer mia on hia.num_proc_mia = mia.num_proc_mia
	where 
		hia.cd_import_hia like @cdpes and usv.cd_usuario like @cdvend and usc.cd_usuario like @cdcust and convert (datetime, MIA.dt_cheg_MIA, 105) between @DataInicial and @DataFinal
		group by  
			ps.nome_raz_soc, 
			USC.nome_usuario, 
			Isnull(USV.nome_usuario,'SEM VENDEDOR'),
			hia.cd_import_hia,
			usv.cd_usuario, 
			usc.cd_usuario,
			hia.num_proc_hia,
			dbo.spresultado(hia.num_proc_hia), 
			dbo.spresultado_mas(hia.num_proc_hia)
	
UNION
--Importao Maritima

	select 
		'IM' Modal,him.num_proc_him, upper (ps.nome_raz_soc) Cliente,count(him.job_him) Emb_imp_mar,
		0 embarques_atual,--DBO.Soma_Embarques_cli (@DataInicial, @DataFinal,him.cd_import_him, usv.cd_usuario, usc.cd_usuario) Processos_Atual, 
		DBO.Soma_Embarques_cli (@DataInicial_ant, @DataFinal_ant,him.cd_import_him,usv.cd_usuario, usc.cd_usuario) Processos_ant, 
		DBO.spresultado (him.num_proc_him)Faturamento_Atual_hou, dbo.spresultado_mas(him.num_proc_him) Faturamento_Atual_mas, 
		dbo.soma_receita_cli(@DataInicial_ant, cd_import_him,usv.cd_usuario, usc.cd_usuario) Faturamento_ant_mas, 
		Isnull(USV.nome_usuario,'SEM VENDEDOR'), USC.nome_usuario CSR 
	from 
		job_imp_mar JIM
		join house_imp_mar him on JIM.num_proc_him = him.job_him
		left join usuario USV on JIM.cd_vendedor = USV.cd_usuario
		left join usuario USC on JIM.cd_usuario = USC.cd_usuario
		left join pessoa PS on him.cd_import_him = Ps.cd_pes
		left join master_imp_mar mim on him.num_proc_mim = mim.num_proc_mim
	where 
		him.cd_import_him like @cdpes and usv.cd_usuario like @cdvend and 
		usc.cd_usuario like @cdcust and convert (datetime, MIM.dt_atrac_MIM, 105) between @DataInicial and @DataFinal
	group by  
		ps.nome_raz_soc, 
		USC.nome_usuario, 
		Isnull(USV.nome_usuario,'SEM VENDEDOR'),
		him.cd_import_him,
		usv.cd_usuario, 
		usc.cd_usuario,
		him.num_proc_him,
		DBO.spresultado (him.num_proc_him),
		dbo.spresultado_mas(him.num_proc_him) 








GO
