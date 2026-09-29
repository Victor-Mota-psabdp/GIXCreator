SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE    Function Soma_Receita_CLI 


	(
		@DataInicial VarChar(10),
		@cd_pes varchar(10),
		@cdSALES varchar(5),
		@cdCSR varchar (5)
	)
RETURNS float

Begin

	Declare @Saida Float
--Exportação Aerea	
			
	Set @Saida=0
		
		set @saida=isnull((	SELECT 
				sum(dbo.spresultado_mas(hou.num_proC_hea))+sum(dbo.spresultado(hou.num_proc_hea)) 
			FROM
				house_exp_Aer HOU
				Join Master_exp_aer MAS on MAS.num_proc_mea=HOU.num_proc_mea
				Join job_exp_aer Job on job_hea=job.num_proc_hea
			WHERE
				cd_export_hea=@cd_pes and cd_usuario=@cdCSR and cd_vendedor=@cdSALES
				and month(convert(datetime,dt_saida_mea,105))=month(@datainicial) and year(convert(datetime,dt_saida_mea,105))=year(@datainicial)
		),0)	

--EXPORTAÇÃO MARITIMA
		
		set @saida=@Saida+isnull((SELECT 
				sum(dbo.spresultado_mas(hou.num_proC_hem)) +sum(dbo.spresultado(hou.num_proc_hem))
			FROM
				house_exp_MAR HOU
				Join Master_exp_MAR MAS on MAS.num_proc_mem=HOU.num_proc_mem
				Join job_exp_mar Job on job_hem=job.num_proc_hem
			WHERE
				cd_export_hem=@cd_pes and cd_usuario=@cdCSR and cd_vendedor=@cdSALES
				and month(convert(datetime,dt_saida_mem,105))=month(@datainicial) and year(convert(datetime,dt_saida_mem,105))=year(@datainicial)
		),0)	


--IMPORTAÇÃO MARITIMA
		set @saida=@Saida+isnull((SELECT 
				sum(dbo.spresultado_mas(hou.num_proC_him)) + sum(dbo.spresultado(hou.num_proc_him))
			FROM
				house_imp_MAR HOU
				Join Master_imp_MAR MAS on MAS.num_proc_mim=HOU.num_proc_mim
				Join job_imp_mar Job on job_him=job.num_proc_him
			WHERE
				cd_import_him=@cd_pes and cd_usuario=@cdCSR and cd_vendedor=@cdSALES
				and month(convert(datetime,dt_atrac_mim,105))=month(@datainicial) and year(convert(datetime,dt_atrac_mim,105))=year(@datainicial)
		),0)	



--IMPORTAÇÃO AÉREO
		set @saida=@Saida+isnull((SELECT 
				sum(dbo.spresultado_mas(hou.num_proC_hiA)) + sum(dbo.spresultado(hou.num_proc_hia))
			FROM
				house_imp_AER HOU
				Join Master_imp_AER MAS on MAS.num_proc_miA=HOU.num_proc_miA
				Join job_imp_AER Job on job_hiA=job.num_proc_hiA
			WHERE
				cd_import_hiA=@cd_pes and cd_usuario=@cdCSR and cd_vendedor=@cdSALES
				and month(convert(datetime,dt_CHEG_miA,105))=month(@datainicial) and year(convert(datetime,dt_CHEG_miA,105))=year(@datainicial)
		),0)	




	Return @Saida

END





GO
