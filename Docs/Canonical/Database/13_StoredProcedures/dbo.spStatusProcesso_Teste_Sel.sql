SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
("A - All Process")
("N - Negative Process only")
("W - without defined status")
*/
CREATE Procedure [dbo].[spStatusProcesso_Teste_Sel]--'Grupo Rhodia','2018-01-01','2018-01-05',8
		@Grupo			Varchar(50),
		@DataInicial	Datetime,
		@DataFinal		Datetime,
		@Tipo			Varchar(1)			

AS	

If @Tipo = 'R'
	Begin
		Set @Tipo = 'N'
		Set @DataInicial= cast(year(getdate()-1)as varchar(4))+ '-01'+'-01'
		Set @DataFinal=getdate()-1
	End

Select 
	Apelido Grupo,
	HOU.num_proc Job,
	Nome_Local Porto,
	Isnull(Dt_Conclusao,HOU.ATA) Data,
	--[dbo].[fBusca_HistoricoDescr](num_proc,95,getdate()) Ultimo_Historico ,
	NULL Ultimo_Historico ,
	sum(dbo.valor(isnull(vlr_pgto_rcto_him,0),dc_him)) Saldo_Caixa,
	Status_Descricao,
	convert(Datetime,HOU.Dt_Criacao,105) Data_Job 
From 
	vwClienteALLJOBS HOU with(nolock)
	Join Localidade DST with(nolock) on DST.cd_local=HOU.Cd_local
	Join Pessoa_LLP PPL with(nolock) on PPL.cd_pes=HOU.cd_cliente
	Join Pessoa PP with(nolock) on PP.cd_pes=cd_pes_Grupo
	Left Join Caixa_Hou_Imp_MAR CXA on CXA.num_proc_him=HOU.num_proc
	Left Join tipo_status_processo TS with(nolock) on HOU.id_status=TS.id_status
	Left Join Tarefas_Processos TP with(nolock) on TP.num_proc=HOU.num_proc and id_task=4
Where
	(@Grupo='%' or Apelido=@Grupo)
	and convert(Datetime,HOU.Dt_Criacao,105) between @DataInicial and @DataFinal
	and 
	(
		(@Tipo='N' AND (dbo.fBuscaSaldoCaixa_Sel(HOU.num_proc) <0 and isnull(HOU.id_status,0)<> 6 ))
	OR
		(@Tipo='A')
	OR
		(@Tipo='W' AND HOU.id_status is null)
	OR
		(cast(HOU.ID_status as varchar(1))= @tipo)	
	)
Group by Apelido ,HOU.num_proc ,Nome_Local ,Dt_Conclusao,HOU.ATA,Status_Descricao,HOU.Dt_Criacao

union all
Select 
	Apelido Grupo,Num_proc_master Job,Nome_Local Porto,Isnull(Dt_Conclusao,ATA_Master) Data,[dbo].[fBusca_HistoricoDescr](num_proc_master,95,getdate()) Ultimo_Historico ,dbo.fBuscaSaldoCaixa_Sel(num_proc_master) Saldo_Caixa, Null, convert(Datetime,dt_emis_mim,105) Data_Job
From 
	LLP_Master LLP with(nolock)
	Left Join Tarefas_Master TP with(nolock) on TP.num_proc=num_proc_master and id_task=4
	Join master_imp_mar MAS with(nolock) on num_proc_master=num_proc_mim
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_mim
	Join Pessoa_LLP PPL with(nolock) on PPL.cd_pes=Cd_Consig_mim
	Join Pessoa PP with(nolock) on PP.cd_pes=cd_pes_Grupo

Where
	(@Grupo='%' or Apelido=@Grupo)
	and convert(Datetime,dt_emis_mim,105) between @DataInicial and @DataFinal
	and 
	(
		dbo.fBuscaSaldoCaixa_Sel(num_proc_mim) <0 and @Tipo='N'  
				Or
			@Tipo='A'
				)
	and num_proc_master like 'IMCLI%'


Union All

Select 
	Apelido Grupo,Num_proc_master Job,Nome_Local Porto,Isnull(Dt_Conclusao,ATA_Master) Data,
	[dbo].[fBusca_HistoricoDescr](num_proc_master,95,getdate()) Ultimo_Historico ,
	dbo.fBuscaSaldoCaixa_Sel(num_proc_master) Saldo_Caixa, Null,
	 convert(Datetime,dt_emis_MIA,105) Data_Job
From 
	LLP_Master LLP with(nolock)
	Left Join Tarefas_Master TP with(nolock) on TP.num_proc=num_proc_master and id_task=4
	Join master_imp_aer MAS with(nolock) on num_proc_master=num_proc_mia
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_mia
	Join Pessoa_LLP PPL with(nolock) on PPL.cd_pes=Cd_Consig_mia
	Join Pessoa PP with(nolock) on PP.cd_pes=cd_pes_Grupo

Where
	(@Grupo='%' or Apelido=@Grupo)
	and convert(Datetime,dt_emis_mia,105) between @DataInicial and @DataFinal
	and 
	(
		dbo.fBuscaSaldoCaixa_Sel(num_proc_master) <0 and @Tipo='0'
				Or
			@Tipo='1'
			
	)
	and num_proc_master like 'IACLI%'

/*
Select 
	Apelido Grupo,Num_Proc_Lim Job,Nome_Local Porto,Isnull(Dt_Conclusao,ATA_LIM) Data,
	[dbo].[fBusca_HistoricoDescr](num_proc_lim,95,getdate()) Ultimo_Historico ,
	sum(dbo.valor(isnull(vlr_pgto_rcto_him,0),dc_him)) Saldo_Caixa,Status_Descricao,
	convert(Datetime,dt_emis_him,105) Data_Job --dbo.fBuscaSaldoCaixa_Sel(num_proc_lim) Saldo_Caixa
From 
	LLP_Imp_Mar LLP with(nolock)
	Left Join Tarefas_Processos TP with(nolock) on TP.num_proc=num_proc_lim and id_task=4
	Join House_Imp_Mar hou with(nolock) on hou.num_proc_him=num_proc_lim
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_him
	Join Pessoa_LLP PPL with(nolock) on PPL.cd_pes=Cd_Consig_Him
	Join Pessoa PP with(nolock) on PP.cd_pes=cd_pes_Grupo
	Left Join Caixa_Hou_Imp_MAR CXA on cxa.num_proc_him=num_proc_lim
	Left Join tipo_status_processo TS with(nolock) on LLP.id_status=TS.id_status
Where
	(@Grupo='%' or Apelido=@Grupo)
	and convert(Datetime,dt_emis_him,105) between @DataInicial and @DataFinal
	and 
	(
		(dbo.fBuscaSaldoCaixa_Sel(num_proc_lim) <0 and @Tipo='N' and isnull(LLP.id_status,0)<>6 )
				Or
			(@Tipo='A')
				Or
			(cast(LLP.ID_status as varchar(1))=@tipo)
			Or
			(LLP.id_status is null and @Tipo='W')		
			
		)
Group by Apelido ,Num_Proc_Lim ,Nome_Local ,Dt_Conclusao,ATA_LIM,Status_Descricao,dt_emis_him


Union all

Select 
	Apelido,Num_Proc_Lia Job,Nome_Local Porto,Isnull(Dt_Conclusao,ATA_LIA) Data,[dbo].
	[fBusca_HistoricoDescr](num_proc_lia,95,getdate()) Ultimo_Historico  ,
	sum(dbo.valor(isnull(vlr_pgto_rcto_hia,0),dc_hia)) Saldo_Caixa, Status_Descricao,convert(Datetime,dt_emis_hia,105) Data_Job
From 
	LLP_Imp_AER LLP with(nolock)
	Left Join Tarefas_Processos TP with(nolock) on TP.num_proc=num_proc_lia and id_task=4
	Join House_Imp_AER hou with(nolock) on hou.num_proc_hia=num_proc_lia
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_hia
	Join Pessoa_LLP PPL with(nolock) on PPL.cd_pes=Cd_Consig_Hia
	Join Pessoa PP with(nolock) on PP.cd_pes=cd_pes_Grupo
	Left Join Caixa_hou_imp_aer CXA on CXA.num_proc_hia=num_proc_lia
	Left Join tipo_status_processo TS with(nolock) on LLP.id_status=TS.id_status
Where
	(@Grupo='%' or Apelido=@Grupo)
	and convert(Datetime,dt_emis_hia,105) between @DataInicial and @DataFinal
	and (
		dbo.fBuscaSaldoCaixa_Sel(num_proc_lia) <0 and @Tipo='N'  and isnull(LLP.id_status,0)<>6
				Or
			@Tipo='A'
				Or
			cast(LLP.ID_status as varchar(1))=@tipo
				Or
				(LLP.id_status is null and @Tipo='W')
		)
Group by 
	Apelido,Num_Proc_Lia ,Nome_Local ,Isnull(Dt_Conclusao,ATA_LIA) ,Status_Descricao,dt_emis_hia 
	
Union All

Select 
	Apelido, Num_Proc_Lio Job,Nome_Local Porto,Isnull(Dt_Conclusao,ATA_LIO) Data,[dbo].[fBusca_HistoricoDescr](num_proc_lio,95,getdate()) Ultimo_Historico  ,dbo.fBuscaSaldoCaixa_Sel(num_proc_lio) Saldo_Caixa,Status_Descricao,convert(Datetime,dt_emis_hio,105) Data_Job
From 
	LLP_Imp_Out LLP with(nolock)
	Left Join Tarefas_Processos TP with(nolock) on TP.num_proc=num_proc_lio and id_task=4
	Join House_Imp_Out hou with(nolock) on hou.num_proc_hio=num_proc_lio
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_hio
	Join Pessoa_LLP PPL with(nolock) on PPL.cd_pes=Cd_Consig_Hio
	Join Pessoa PP with(nolock) on PP.cd_pes=cd_pes_Grupo
	Left Join tipo_status_processo TS with(nolock) on LLP.id_status=TS.id_status
Where
	(@Grupo='%' or Apelido=@Grupo)

	and convert(Datetime,dt_emis_hio,105) between @DataInicial and @DataFinal
	and 	(
		dbo.fBuscaSaldoCaixa_Sel(num_proc_lio) <0 and @Tipo='N'  and isnull(LLP.id_status,0)<>6
				Or
			@Tipo='A'
				Or
			cast(LLP.ID_status as varchar(1))=@tipo
				OR
				(LLP.id_status is null and @Tipo='W')
		)


Union all

Select 
	Apelido,Num_Proc_LEM Job,Nome_Local Porto,Isnull(Dt_Conclusao,ATD_LEM) Data,
	[dbo].[fBusca_HistoricoDescr](num_proc_LEM,95,getdate()) Ultimo_Historico ,
	dbo.fBuscaSaldoCaixa_Sel(num_proc_lem) Saldo_Caixa, Status_Descricao, convert(Datetime,dt_emis_hem,105) Data_Job
From 
	LLP_Exp_Mar LLP with(nolock)
	Left Join Tarefas_Processos TP with(nolock) on TP.num_proc=num_proc_lem and id_task=4
	Join House_exp_Mar hou with(nolock) on hou.num_proc_hem=num_proc_lem
	Join Localidade DST with(nolock) on DST.cd_local=cd_ORG_hem
	Join Pessoa_LLP PPL with(nolock) on PPL.cd_pes=Cd_Export_Hem
	Join Pessoa PP with(nolock) on PP.cd_pes=cd_pes_Grupo
	Left Join tipo_status_processo TS with(nolock) on LLP.id_status=TS.id_status
Where
	(@Grupo='%' or Apelido=@Grupo)
	and convert(Datetime,dt_emis_hem,105) between @DataInicial and @DataFinal

	And		(
		dbo.fBuscaSaldoCaixa_Sel(num_proc_lem) <0 and @Tipo='N'  and isnull(LLP.id_status,0)<>6
				Or
			@Tipo='A'
				Or
			cast(LLP.ID_status as varchar(1))=@tipo
			Or
			(LLP.id_status is null and @Tipo='W')
		)


Union aLL

Select 
	Apelido,Num_Proc_LEa Job,Nome_Local Porto,Isnull(Dt_Conclusao,ATd_LEA) Data,[dbo].[fBusca_HistoricoDescr](num_proc_lEa,95,getdate()) Ultimo_Historico  ,dbo.fBuscaSaldoCaixa_Sel(num_proc_lea) Saldo_Caixa, Status_Descricao, convert(Datetime,dt_emis_hea,105) Data_Job
From 
	LLP_EXP_AER LLP with(nolock)
	Left Join Tarefas_Processos TP with(nolock) on TP.num_proc=num_proc_lEa and id_task=4
	Join House_exp_AER hou with(nolock) on hou.num_proc_hEa=num_proc_lEa
	Join Localidade DST with(nolock) on DST.cd_local=cd_ORG_hEa
	Join Pessoa_LLP PPL with(nolock) on PPL.cd_pes=Cd_Export_Hea
	Join Pessoa PP with(nolock) on PP.cd_pes=cd_pes_Grupo
	Left Join tipo_status_processo TS with(nolock) on LLP.id_status=TS.id_status
Where
	(@Grupo='%' or Apelido=@Grupo)
		and convert(Datetime,dt_emis_hea,105) between @DataInicial and @DataFinal
	and 
	(
		dbo.fBuscaSaldoCaixa_Sel(num_proc_lea) <0 and @Tipo='N'  and isnull(LLP.id_status,0)<>6
				Or
			@Tipo='A'
				Or
			cast(LLP.ID_status as varchar(1))=@tipo
				Or
			(LLP.id_status is null and @Tipo='W')
		)

Union All

Select 
	Apelido,Num_Proc_Leo Job,Nome_Local Porto,Isnull(Dt_Conclusao,ATD_LEO) Data,[dbo].[fBusca_HistoricoDescr](num_proc_leo,95,getdate()) Ultimo_Historico  ,dbo.fBuscaSaldoCaixa_Sel(num_proc_leo) Saldo_Caixa, Status_Descricao, convert(Datetime,dt_emis_heo,105) Data_Job
From 
	LLP_exp_Out LLP with(nolock)
	Left Join Tarefas_Processos TP with(nolock) on TP.num_proc=num_proc_leo and id_task=4
	Join House_EXP_Out hou with(nolock) on hou.num_proc_heo=num_proc_leo
	Join Localidade DST with(nolock) on DST.cd_local=cd_org_heo
	Join Pessoa_LLP PPL with(nolock) on PPL.cd_pes=Cd_Export_Heo
	Join Pessoa PP with(nolock) on PP.cd_pes=cd_pes_Grupo
	Left Join tipo_status_processo TS with(nolock) on LLP.id_status=TS.id_status
Where
	(@Grupo='%' or Apelido=@Grupo)
	and convert(Datetime,dt_emis_heo,105) between @DataInicial and @DataFinal
	and 
	(
		dbo.fBuscaSaldoCaixa_Sel(num_proc_leo) <0 and @Tipo='N'  and isnull(LLP.id_status,0)<>6
				Or
			@Tipo='A'
				Or
			cast(LLP.ID_status as varchar(1))=@tipo
			OR
			(LLP.id_status is null and @Tipo='W')	
	)


union all
Select 
	Apelido Grupo,Num_proc_master Job,Nome_Local Porto,Isnull(Dt_Conclusao,ATA_Master) Data,[dbo].[fBusca_HistoricoDescr](num_proc_master,95,getdate()) Ultimo_Historico ,dbo.fBuscaSaldoCaixa_Sel(num_proc_master) Saldo_Caixa, Null, convert(Datetime,dt_emis_mim,105) Data_Job
From 
	LLP_Master LLP with(nolock)
	Left Join Tarefas_Master TP with(nolock) on TP.num_proc=num_proc_master and id_task=4
	Join master_imp_mar MAS with(nolock) on num_proc_master=num_proc_mim
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_mim
	Join Pessoa_LLP PPL with(nolock) on PPL.cd_pes=Cd_Consig_mim
	Join Pessoa PP with(nolock) on PP.cd_pes=cd_pes_Grupo

Where
	(@Grupo='%' or Apelido=@Grupo)
	and convert(Datetime,dt_emis_mim,105) between @DataInicial and @DataFinal
	and 
	(
		dbo.fBuscaSaldoCaixa_Sel(num_proc_mim) <0 and @Tipo='N'  
				Or
			@Tipo='A'
				)
	and num_proc_master like 'IMCLI%'


Union All

Select 
	Apelido Grupo,Num_proc_master Job,Nome_Local Porto,Isnull(Dt_Conclusao,ATA_Master) Data,
	[dbo].[fBusca_HistoricoDescr](num_proc_master,95,getdate()) Ultimo_Historico ,
	dbo.fBuscaSaldoCaixa_Sel(num_proc_master) Saldo_Caixa, Null,
	 convert(Datetime,dt_emis_MIA,105) Data_Job
From 
	LLP_Master LLP with(nolock)
	Left Join Tarefas_Master TP with(nolock) on TP.num_proc=num_proc_master and id_task=4
	Join master_imp_aer MAS with(nolock) on num_proc_master=num_proc_mia
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_mia
	Join Pessoa_LLP PPL with(nolock) on PPL.cd_pes=Cd_Consig_mia
	Join Pessoa PP with(nolock) on PP.cd_pes=cd_pes_Grupo

Where
	(@Grupo='%' or Apelido=@Grupo)
	and convert(Datetime,dt_emis_mia,105) between @DataInicial and @DataFinal
	and 
	(
		dbo.fBuscaSaldoCaixa_Sel(num_proc_master) <0 and @Tipo='0'
				Or
			@Tipo='1'
			
	)
	and num_proc_master like 'IACLI%'

*/





GO
