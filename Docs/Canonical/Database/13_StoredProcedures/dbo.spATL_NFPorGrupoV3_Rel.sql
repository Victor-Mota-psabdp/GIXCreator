SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --184	Faturamento Por Grupo e Localidade spATL_NFPorGrupoV3_Rel
 --alterado para view 02/07/2018
--[spATL_NFPorGrupoV3_Rel]'ALL','2018-01-01','2018-12-31'

CREATE Procedure [dbo].[spATL_NFPorGrupoV3_Rel]--'ALL'
	@Grupo varchar(50),
	@DataInicial Datetime,
	@DataFinal Datetime
	
AS

if @Grupo = '' 
	begin
		Set @Grupo = 'ALL'
	End

Declare @ResultadoFinal Table
		(
			Modal		Varchar(2),
			Grupo		Varchar(50),
			Localidade	Varchar(40),
			Janeiro		Decimal(10,2) Default 0,
			JaneiroJOB int Default 0,
			Fevereiro	Decimal(10,2) Default 0,
			FevereiroJOB int Default 0,
			Marco		Decimal(10,2) Default 0,
			MarcoJOB int Default 0,
			Abril		Decimal(10,2) Default 0,
			AbrilJOB int Default 0,
			Maio		Decimal(10,2) Default 0,
			MaioJOB int Default 0,
			Junho		Decimal(10,2) Default 0,
			JunhoJOB int Default 0,
			Julho		Decimal(10,2) Default 0,
			JulhoJOB int Default 0,
			Agosto		Decimal(10,2) Default 0,
			AgostoJOB int Default 0,
			Setembro	Decimal(10,2) Default 0,
			SetembroJOB int Default 0,
			Outubro		Decimal(10,2) Default 0,
			OutubroJOB int Default 0, 
			Novembro	Decimal(10,2) Default 0,
			NovembroJOB int Default 0,
			Dezembro	Decimal(10,2) Default 0,
			DezembroJOB int Default 0
		)

Declare @ResultadoTemp	Table
		(
			Modal	Varchar(2),
			Grupo	Varchar(50),
			Valor	Float,
			Jobs int,
			Mes		int,
			Localidade Varchar(40)


		)

--spNFPorGrupo_Rel  '01-01-2011','10-10-2011'

Insert @ResultadoTemp
	select
		LEFT(cta.num_proc,2)			[Modal],
		(Case when @Grupo ='GRUPO DOW' then
			(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		else PP.Apelido end)			[Grupo],
		sum(dbo.valor(Valor_ARP,DC))	[Valor],
		count(distinct HOU.num_proc)	[JOB],
		month(Dt_Fatura)				[Mes],
		Nome_Local						[Localidade]
	from 
		vwFaturasValidasArg CTA		with(nolock)
		Join vwClienteALLJOBS HOU	with(nolock) on hou.num_proc=CTA.Num_Proc
		Join Pessoa CLI				with(nolock) on HOU.cd_cliente=CLI.cd_pes
		LEFT Join Pessoa_LLP PLLP	with(nolock) on HOU.cd_cliente=PLLP.cd_pes
		LEFT Join Pessoa PP			with(nolock) on PP.cd_pes=cd_pes_grupo	
		LEFT Join Localidade Org	with(nolock) on Org.cd_local=ISNULL(HOU.Cd_local,'0')			
	Where
		Dt_Fatura  between @dataInicial and @DataFinal
		and (PP.Apelido = @Grupo or @Grupo = 'ALL') 

	Group by PP.Apelido,Month(Dt_Fatura),(Case when @Grupo ='GRUPO DOW' then
		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end)
		,nome_local,LEFT(cta.num_proc,2)
		
UNION ALL
	--Master
	select
		LEFT(cta.num_proc,2)			[Modal],
		(Case when @Grupo ='GRUPO DOW' then
			(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		else PP.Apelido end)			[Grupo],
		sum(dbo.valor(Valor_ARP,DC))	[Valor],
		count(distinct HOU.num_proc)	[JOB],
		month(Dt_Fatura)				[Mes],
		Nome_Local						[Localidade]
	from 
		vwFaturasValidasArg CTA		with(nolock)
		Join vwClienteALLJOBS HOU	with(nolock) on hou.Master=CTA.Num_Proc
		Join Pessoa CLI				with(nolock) on HOU.cd_cliente=CLI.cd_pes
		left Join Pessoa_LLP PLLP	with(nolock) on HOU.cd_cliente=PLLP.cd_pes
		left Join Pessoa PP			with(nolock) on PP.cd_pes=cd_pes_grupo
		LEFT Join Localidade Org	with(nolock) on Org.cd_local=ISNULL(HOU.Cd_local,'0')				
	Where
		year(Dt_Fatura)=YEAR(getdate())
		and Dt_Fatura <=getdate()
		and (PP.Apelido = @Grupo or @Grupo  = 'ALL')  		
	Group by 
		PP.Apelido,CLI.Apelido ,Month(Dt_Fatura),cta.num_proc,
		LEFT(cta.num_proc,2),(Case when @Grupo ='GRUPO DOW' then(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO'
		then 'Grupo DOW AGRO' else 'Grupo Dow' end)	else PP.Apelido end)
		,nome_local,LEFT(cta.num_proc,2)


--select 
--	'IM' Modal ,
--		(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) Grupo,
	
--	sum(dbo.valor(Valor_ARP,DC)) Valor,count(distinct HOU.Num_proc_him)JOBs,month(Dt_Fatura) Mes
--	,Nome_Local Localidade
--from 
--	Fatura_Arg_Det CTA  with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join House_imp_mar hou with(nolock)  on hou.num_proc_him=cta.num_proc
--	Join Pessoa CLI with(nolock)  on HOU.cd_consig_him=CLI.cd_pes
--	left Join Pessoa_LLP PLLP with(nolock)  on cd_consig_him=PLLP.cd_pes
--	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--	Join Localidade Org on Org.cd_local=Cd_dst_him
	
--Where
--	--year(Dt_Fatura)=2014
--	--and Dt_Fatura <=getdate()
--	Dt_Fatura  between @dataInicial and @DataFinal
--	and (PP.Apelido = @Grupo or @Grupo = 'ALL')  
--	--and month(Dt_Fatura) in ('01','02','03')
--Group by PP.Apelido,Month(Dt_Fatura),		(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end)
--	,nome_local


--union all
--select 
--	'IO' Modal ,
--		(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) Grupo,
--	sum(dbo.valor(Valor_ARP,DC)) Valor,count(distinct HOU.Num_proc_hio)JOBs,month(Dt_Fatura) Mes
--,Nome_Local Localidade
--from 
--	Fatura_Arg_Det CTA with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join House_imp_Out hou with(nolock)  on hou.num_proc_hio=cta.num_proc
--	Join Pessoa CLI with(nolock)  on HOU.cd_consig_hio=CLI.cd_pes
--	left Join Pessoa_LLP PLLP with(nolock)  on cd_consig_hio=PLLP.cd_pes
--	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--Join Localidade Org on Org.cd_local=Cd_Dst_HIO
--Where
--	--year(Dt_Fatura)=2014
--	--and Dt_Fatura <=getdate()
	
--	Dt_Fatura  between @dataInicial and @DataFinal
--	and (PP.Apelido = @Grupo or @Grupo = 'ALL') 
--	--and month(Dt_Fatura) in ('01','02','03')
--Group by PP.Apelido,Month(Dt_Fatura),			(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end)
--,nome_local


--union all

--select 
--	'IA' Modal ,
--		(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) Grupo
--	,sum(dbo.valor(Valor_ARP,DC)) Valor,count(distinct HOU.Num_proc_hia)JOBs,month(Dt_Fatura) Mes
--,Nome_Local Localidade
--from 
--	Fatura_Arg_Det CTA with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join House_imp_aer hou with(nolock)  on hou.num_proc_hia=cta.num_proc
--	Join Pessoa CLI with(nolock)  on HOU.cd_consig_hia=CLI.cd_pes
--	left Join Pessoa_LLP PLLP with(nolock)  on cd_consig_hia=PLLP.cd_pes
--	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--	Join Localidade Org on Org.cd_local=Cd_Dst_HIA
--Where
--	--year(Dt_Fatura)=2014
--	--and Dt_Fatura <=getdate()
	
--	Dt_Fatura  between @dataInicial and @DataFinal
--	and (PP.Apelido = @Grupo or @Grupo = 'ALL') 
--	--and month(Dt_Fatura) in ('01','02','03')
--Group by PP.Apelido,Month(Dt_Fatura),			(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end)
--,nome_local
--union all




--select 
--	'EO' Modal ,
--		(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) Grupo,
--	sum(dbo.valor(Valor_ARP,DC)) Valor,count(distinct Hou.Num_proc_heo)JOBs,month(Dt_Fatura) Mes
--,Nome_Local Localidade
--from 
--	Fatura_Arg_Det CTA with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join House_exp_Out hou with(nolock)  on hou.num_proc_heo=cta.num_proc
--	Join Pessoa CLI with(nolock)  on HOU.cd_export_heo=CLI.cd_pes
--	left Join Pessoa_LLP PLLP with(nolock)  on cd_export_heo=PLLP.cd_pes
--	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--Join Localidade Org on Org.cd_local=Cd_Org_HEO
--Where
--	--year(Dt_Fatura)=2014
--	--and Dt_Fatura <=getdate()
	
--	Dt_Fatura  between @dataInicial and @DataFinal
--	and (PP.Apelido = @Grupo or @Grupo = 'ALL') 
--	--and month(Dt_Fatura) in ('01','02','03')
--Group by PP.Apelido,Month(Dt_Fatura),		(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end)
--,nome_local
--union all

--select 
--	'EM' Modal ,
--		(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end)Grupo,
	
--	sum(dbo.valor(Valor_ARP,DC)) Valor,count(distinct HOU.Num_proc_hem)JOBs,month(Dt_Fatura) Mes
--,Nome_Local Localidade
--from 
--	Fatura_Arg_Det CTA  with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join House_exp_mar hou with(nolock)  on hou.num_proc_hem=cta.num_proc
--	Join Pessoa CLI with(nolock)  on HOU.cd_export_hem=CLI.cd_pes
--	left Join Pessoa_LLP PLLP with(nolock)  on cd_export_hem=PLLP.cd_pes
--	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--Join Localidade Org on Org.cd_local=cd_org_hem
	
--Where
--	--year(Dt_Fatura)=2014
--	--and Dt_Fatura <=getdate()
	
--	Dt_Fatura  between @dataInicial and @DataFinal
--	and (PP.Apelido = @Grupo or @Grupo = 'ALL')
--	and CTA.cd_tp_Tx <> 'FRT'
--	--and month(Dt_Fatura) in ('01','02','03')
--Group by PP.Apelido,Month(Dt_Fatura),			(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end)
--,nome_local
--union all

--select 
--	'EA' Modal ,
--		(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) Grupo,
--	sum(dbo.valor(Valor_ARP,DC)) Valor,count(distinct HOU.Num_proc_hea)JOBs,month(Dt_Fatura) Mes
--,Nome_Local Localidade
--from 
--	Fatura_Arg_Det CTA with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join House_exp_AER hou with(nolock)  on hou.num_proc_hea=cta.num_proc
--	Join Pessoa CLI with(nolock)  on HOU.cd_export_hea=CLI.cd_pes
--	left Join Pessoa_LLP PLLP with(nolock)  on cd_export_hea=PLLP.cd_pes
--	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--	Join Localidade Org on Org.cd_local=Cd_Org_HEA
--Where
--	--year(Dt_Fatura)=2014
--	--and Dt_Fatura <=getdate()
	
--	Dt_Fatura  between @dataInicial and @DataFinal
--	and (PP.Apelido = @Grupo or @Grupo = 'ALL') 
--	--and month(Dt_Fatura) in ('01','02','03')
--Group by PP.Apelido,Month(Dt_Fatura),			(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end)
--,nome_local

insert @resultadofinal(modal,grupo,localidade)

select distinct Modal,grupo ,localidade from @ResultadoTemp


Update @ResultadoFinal set Janeiro=isnull(Valor,0),JaneiroJOB = isnull(Jobs,0) from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=1 and RT.Localidade = RF.Localidade


Update @ResultadoFinal set Fevereiro=isnull(Valor,0),FevereiroJOB = isnull(Jobs,0) from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=2 and RT.Localidade = RF.Localidade

Update @ResultadoFinal set Marco=isnull(Valor,0),MarcoJOB = isnull(Jobs,0) from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=3 and RT.Localidade = RF.Localidade

Update @ResultadoFinal set Abril=isnull(Valor,0),AbrilJOB = isnull(Jobs,0) from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=4 and RT.Localidade = RF.Localidade

Update @ResultadoFinal set Maio=isnull(Valor,0),MaioJOB = isnull(Jobs,0)  from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=5 and RT.Localidade = RF.Localidade

Update @ResultadoFinal set Junho=isnull(Valor,0),JunhoJOB = isnull(Jobs,0)  from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=6 and RT.Localidade = RF.Localidade

Update @ResultadoFinal set Julho=isnull(Valor,0),JulhoJOB = isnull(Jobs,0)  from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=7 and RT.Localidade = RF.Localidade

Update @ResultadoFinal set Agosto=isnull(Valor,0),AgostoJOB = isnull(Jobs,0)  from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=8 and RT.Localidade = RF.Localidade

Update @ResultadoFinal set Setembro=isnull(Valor,0),SetembroJOB = isnull(Jobs,0)  from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=9 and RT.Localidade = RF.Localidade

Update @ResultadoFinal set Outubro=isnull(Valor,0),OutubroJOB = isnull(Jobs,0)  from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=10

Update @ResultadoFinal set Novembro=isnull(Valor,0),NovembroJOB = isnull(Jobs,0)  from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=11 and RT.Localidade = RF.Localidade

Update @ResultadoFinal set Dezembro=isnull(Valor,0),DezembroJOB = isnull(Jobs,0)  from @ResultadoFinal RF
Join @ResultadoTemp RT on RT.grupo=rf.grupo and RT.modal=RF.Modal and Mes=12 and RT.Localidade = RF.Localidade


select 
		Modal,
		Grupo,
		Localidade,
		Janeiro [Janeiro Value],
		JaneiroJob [Janeiro Number],
		Fevereiro [Fevereiro Value],
		FevereiroJOB [Fevereiro Number],
		Marco [Marco Value], 
		MarcoJOB [Marco Number],
		Abril [Abril Value],
		AbrilJOB [Abril Number],
		Maio [Maio Value],
		MaioJOB [Maio Number],
		Junho [Junho Value],
		JunhoJOB [Junho Number],
		Julho [Julho Value],
		JulhoJOB [Julho Number],
		Agosto [Agosto Value],
		AgostoJOB [Agosto Number],
		Setembro [Setembro Value],
		SetembroJOB [Setembro Number],
		Outubro [Outubro Value],
		OutubroJOB [Outubro Number],
		Novembro [Novembro Value],
		NovembroJOB [Novembro Number],
		Dezembro [Dezembro Value],
		DezembroJOB [Dezembro Number]
From
		@ResultadoFinal

GO
