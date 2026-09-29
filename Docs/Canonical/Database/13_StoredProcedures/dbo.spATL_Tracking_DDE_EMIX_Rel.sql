SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_Tracking_DDE_EMIX_Rel]--'2017-08-01'
	@DtInicial datetime
As

	Declare @Grupo varchar(20)
	set @Grupo = '%'

	select	DISTINCT	
		LLP.Num_Proc_Lem		[BDP Ref.],		
		PG.Apelido				[Grupo],
		CSN.Apelido				[Exportador],
		CSN.Num_CPF_CNPJ		[CNPJ],
		DST.Nome_Local			[Embarque],
		P12.Data_PO_HEM			[Data da DDE],		
		P12.Numero_PO_HEM		[Numero da DDE],
		P12.dt_ins				[Data Inserção da DDE],
		(case when D12.Nome_Arquivo is not null then	'YES' else 'NO' end)	[PDF - DDE],
		XDDE.Retorno_Erro		[Retorno Emix DDE],
		T195.Dt_Conclusao		[Data do Inicio de Transito],
		T196.Dt_Conclusao		[Data do Transito Concluido],
		T4.Dt_Conclusao			[Data do Desembaraco],
		P4.Data_PO_HEM			[Data da RE],
		P4.Numero_PO_HEM		[Numero da RE],
		P4.dt_ins				[Data Inserção da RE],
		(case when D4.Nome_Arquivo is not null then	'YES' else 'NO' end)	[PDF - RE],
		XRE.Retorno_Erro		[Retorno Emix RE],
		T15.Dt_Conclusao		[Data da Averbação],		
		LLp.Canal_Lem			[Canal]
	from
		LLP_exp_Mar LLP with(nolock)
		Join House_exp_Mar HOU with(nolock) on LLP.num_proc_LEM=HOU.Num_Proc_HEM
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Export_HEM
		left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Export_HEM = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Export_HEM = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
		join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo		
		join Pessoa CSN with(nolock) on CSN.cd_pes=HOU.Cd_Export_HEM	
		left Join Localidade DST with(nolock) on HOU.cd_org_HEM=DST.cd_local		
		Left Join PO_HEM P12 with(nolock) on P12.Num_Proc_HEM=HOU.num_proc_hEM and P12.ID_DC=12
		Left Join PO_HEM P4 with(nolock) on P4.Num_Proc_HEM=HOU.num_proc_hEM and P4.ID_DC=4
		Left Join Doc_anexos D12 with(nolock) on D12.Num_Proc=HOU.num_proc_hEM and D12.ID_DC=12
		Left Join Doc_anexos D4 with(nolock) on D4.Num_Proc=HOU.num_proc_hEm and D4.ID_DC=4			
		Left Join Tarefas_Processos T4  with(nolock) on LLP.Num_Proc_LEM= T4.num_proc and  T4.id_task=4
		Left Join Tarefas_Processos T15  with(nolock) on LLP.Num_Proc_LEM= T15.num_proc and  T15.id_task=15
		Left Join Tarefas_Processos T195  with(nolock) on LLP.Num_Proc_Lem= T195.num_proc and  T195.id_task=195	
		Left Join Tarefas_Processos T196  with(nolock) on LLP.Num_Proc_Lem= T196.num_proc and  T196.id_task=196
		left join E_MIX_XML XDDE with(nolock) on XDDE.Num_Proc = LLP.num_proc_LEM and XDDE.id_consulta_tipo = 20
		left join E_MIX_XML XRE with(nolock) on XRE.Num_Proc = LLP.num_proc_LEM and XRE.id_consulta_tipo = 18	
	where
		P12.dt_ins	>= @DtInicial	
		and left(P12.Numero_PO_HEM,4) != '2170'
		and ID_Empresa.Cd_Pes is not null
		and ID_CNPJ.Cd_Pes is not null
	
	
	
UNION all

	select DISTINCT
		LLP.Num_Proc_Lea		[BDP Ref.],		
		PG.Apelido				[Grupo],
		CSN.Apelido				[Exportador],
		CSN.Num_CPF_CNPJ		[CNPJ],
		DST.Nome_Local			[Embarque],
		P12.Data_PO_HEA			[Data da DDE],		
		P12.Numero_PO_HEA		[Numero da DDE],
		P12.dt_ins				[Data Inserção da DDE],
		(case when D12.Nome_Arquivo is not null then	'YES' else 'NO' end)	[PDF - DDE],
		XDDE.Retorno_Erro		[Retorno Emix],
		T195.Dt_Conclusao		[Data do Inicio de Transito],
		T196.Dt_Conclusao		[Data do Transito Concluido],
		T4.Dt_Conclusao			[Data do Desembaraco],
		P4.Data_PO_HEA			[Data da RE],
		P4.Numero_PO_HEA		[Numero da RE],
		P4.dt_ins				[Data Inserção da RE],
		(case when D4.Nome_Arquivo is not null then	'YES' else 'NO' end)	[PDF - RE],
		XRE.Retorno_Erro		[Retorno Emix RE],
		T15.Dt_Conclusao		[Data da Averbação],		
		LLp.Canal_Lea			[Canal]
	from
		LLP_Exp_Aer LLP with(nolock)
		Join House_Exp_Aer HOU with(nolock) on LLP.num_proc_LEA=HOU.num_proc_HEA
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Export_HEA
		left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Export_HEA = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Export_HEA = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
		join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo		
		join Pessoa CSN with(nolock) on CSN.cd_pes=HOU.Cd_Export_HEA	
		left Join Localidade DST with(nolock) on HOU.cd_org_HEA=DST.cd_local		
		Left Join PO_HEA P12 with(nolock) on P12.Num_Proc_HEA=HOU.num_proc_hEA and P12.ID_DC=12	
		Left Join PO_HEA P4 with(nolock) on P4.Num_Proc_HEA=HOU.num_proc_hEa and P4.ID_DC=4	
		Left Join Doc_anexos D12 with(nolock) on D12.Num_Proc=HOU.num_proc_hEA and D12.ID_DC=12	
		Left Join Doc_anexos D4 with(nolock) on D4.Num_Proc=HOU.num_proc_hEa and D4.ID_DC=4
		Left Join Tarefas_Processos T4  with(nolock) on LLP.num_proc_lEA= T4.num_proc and  T4.id_task=4
		Left Join Tarefas_Processos T15  with(nolock) on LLP.Num_Proc_Lea= T15.num_proc and  T15.id_task=15
		Left Join Tarefas_Processos T195  with(nolock) on LLP.Num_Proc_Lea= T195.num_proc and  T195.id_task=195	
		Left Join Tarefas_Processos T196  with(nolock) on LLP.Num_Proc_Lea= T196.num_proc and  T196.id_task=196	
		left join E_MIX_XML XDDE with(nolock) on XDDE.Num_Proc = LLP.Num_Proc_Lea and XDDE.id_consulta_tipo = 20
		left join E_MIX_XML XRE with(nolock) on XRE.Num_Proc = LLP.Num_Proc_Lea and XRE.id_consulta_tipo = 18
	where
		P12.dt_ins	>= @DtInicial
		and left(P12.Numero_PO_HEA,4) != '2170'
		and ID_Empresa.Cd_Pes is not null
		and ID_CNPJ.Cd_Pes is not null
		
UNION ALL

	select DISTINCT
		LLP.Num_Proc_Leo		[BDP Ref.],		
		PG.Apelido				[Grupo],
		CSN.Apelido				[Exportador],
		CSN.Num_CPF_CNPJ		[CNPJ],
		DST.Nome_Local			[Embarque],
		P12.Data_PO_HEO		[Data da DDE],		
		P12.Numero_PO_HEO		[Numero da DDE],
		P12.dt_ins				[Data Inserção da DDE],
		(case when D12.Nome_Arquivo is not null then	'YES' else 'NO' end)	[PDF - DDE],
		XDDE.Retorno_Erro		[Retorno Emix],
		T195.Dt_Conclusao		[Data do Inicio de Transito],
		T196.Dt_Conclusao		[Data do Transito Concluido],
		T4.Dt_Conclusao			[Data do Desembaraco],
		P4.Data_PO_HEO			[Data da RE],
		P4.Numero_PO_HEO		[Numero da RE],
		P4.dt_ins				[Data Inserção da RE],
		(case when D4.Nome_Arquivo is not null then	'YES' else 'NO' end)	[PDF - RE],
		XRE.Retorno_Erro		[Retorno Emix RE],
		T15.Dt_Conclusao		[Data da Averbação],		
		LLp.Canal_Leo			[Canal]
	from
		LLP_Exp_Out LLP with(nolock)
		Join House_Exp_Out HOU with(nolock) on LLP.num_proc_LEO=HOU.num_proc_HEO
		left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Export_HEO = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Export_HEO = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Export_HEO		
		join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
		join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo		
		join Pessoa CSN with(nolock) on CSN.cd_pes=HOU.Cd_Export_HEO	
		left Join Localidade DST with(nolock) on HOU.cd_org_HEO=DST.cd_local		
		Left Join PO_HEO P12 with(nolock) on P12.Num_Proc_HEO=HOU.num_proc_hEO and P12.ID_DC=12	
		Left Join PO_HEO P4 with(nolock) on P4.Num_Proc_HEO=HOU.Num_Proc_HEO and P4.ID_DC=4	
		Left Join Doc_anexos D12 with(nolock) on D12.Num_Proc=HOU.num_proc_hEO and D12.ID_DC=12	
		Left Join Doc_anexos D4 with(nolock) on D4.Num_Proc=HOU.num_proc_hEO and D4.ID_DC=4		
		Left Join Tarefas_Processos T4  with(nolock) on LLP.num_proc_lEO= T4.num_proc and  T4.id_task=4
		Left Join Tarefas_Processos T15  with(nolock) on LLP.Num_Proc_Leo= T15.num_proc and  T15.id_task=15	
		Left Join Tarefas_Processos T195  with(nolock) on LLP.Num_Proc_Leo= T195.num_proc and  T195.id_task=195	
		Left Join Tarefas_Processos T196  with(nolock) on LLP.Num_Proc_Leo= T196.num_proc and  T196.id_task=196	
		left join E_MIX_XML XDDE with(nolock) on XDDE.Num_Proc = LLP.Num_Proc_Leo and XDDE.id_consulta_tipo = 20
		left join E_MIX_XML XRE with(nolock) on XRE.Num_Proc = LLP.Num_Proc_Leo and XRE.id_consulta_tipo = 18
	where
		P12.dt_ins	>= @DtInicial 
		and left(P12.Numero_PO_HEO,4) != '2170'
		and ID_Empresa.Cd_Pes is not null
		and ID_CNPJ.Cd_Pes is not null
		
	order by [Data Inserção da DDE] desc
OPTION(HASH JOIN)
GO
