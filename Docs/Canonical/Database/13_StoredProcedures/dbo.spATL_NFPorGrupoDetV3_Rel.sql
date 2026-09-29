SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 -- 185	Faturamento Detalhado Por Grupo e Localidade	spATL_NFPorGrupoDetV3_Rel
 --alterado para view 02/07/2018
--[spATL_NFPorGrupoDetV3_Rel]'ALL','2018-01-01','2018-12-31'
CREATE Procedure [dbo].[spATL_NFPorGrupoDetV3_Rel] --'ALL','2014-01-01','2014-12-31'
	@Grupo varchar(50),
	@DataInicial Datetime,
	@DataFinal Datetime
AS

--DECLARE	@Grupo varchar(50)
--DECLARE	@DataInicial Datetime
--DECLARE	@DataFinal Datetime
--SET @Grupo =''
--SET @DataInicial = '2018-01-01'
--SET @DataInicial = '2018-12-31'

if @Grupo = '' 
	begin
		Set @Grupo = 'ALL'
	End

select
	LEFT(cta.num_proc,2)			[Modal],
	(Case when @Grupo ='GRUPO DOW' then
		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
	else PP.Apelido end)			[Grupo],
	HOU.Num_proc					[JOB],
	HOU.Master						[Ref Consolidada],
	sum(dbo.valor(Valor_ARP,DC))	[Valor],
	CLI.Apelido						[Cliente],
	month(Dt_Fatura)				[Mes],
	Nome_Local						[Localidade]
	,US.nome_usuario					[Nome Usuario]	
from 
	vwFaturasValidasArg CTA		with(nolock)
	Join vwClienteALLJOBS HOU	with(nolock) on hou.num_proc=CTA.Num_Proc
	Join Pessoa CLI				with(nolock) on HOU.cd_cliente=CLI.cd_pes
	LEFT Join Pessoa_LLP PLLP	with(nolock) on HOU.cd_cliente=PLLP.cd_pes
	LEFT Join Pessoa PP			with(nolock) on PP.cd_pes=cd_pes_grupo	
	LEFT Join Localidade Org	with(nolock) on Org.cd_local=ISNULL(HOU.Cd_local,'0')
	join Usuario US				with(nolock)  on US.cd_usuario = HOU.cd_usuario					
Where
	Dt_Fatura  between @dataInicial and @DataFinal
	and (PP.Apelido = @Grupo or @Grupo = 'ALL') 

Group by PP.Apelido,CLI.Apelido,Month(Dt_Fatura),HOU.Num_proc,HOU.Master,(Case when @Grupo ='GRUPO DOW' then
	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end)
	,nome_local,LEFT(cta.num_proc,2)
	,US.nome_usuario
		
UNION ALL
--Master
select
	LEFT(cta.num_proc,2)			[Modal],
	(Case when @Grupo ='GRUPO DOW' then
		(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
	else PP.Apelido end)			[Grupo],
	HOU.Num_proc					[JOB],
	HOU.Master						[Ref Consolidada],
	sum(dbo.valor(Valor_ARP,DC))	[Valor],
	CLI.Apelido						[Cliente],
	month(Dt_Fatura)				[Mes],
	Nome_Local						[Localidade]
	,US.nome_usuario					[Nome Usuario]	
from 
	vwFaturasValidasArg CTA		with(nolock)
	Join vwClienteALLJOBS HOU	with(nolock) on hou.num_proc=CTA.Num_Proc
	Join Pessoa CLI				with(nolock) on HOU.cd_cliente=CLI.cd_pes
	left Join Pessoa_LLP PLLP	with(nolock) on HOU.cd_cliente=PLLP.cd_pes
	left Join Pessoa PP			with(nolock) on PP.cd_pes=cd_pes_grupo
	LEFT Join Localidade Org	with(nolock) on Org.cd_local=ISNULL(HOU.Cd_local,'0')
	join Usuario US				with(nolock)  on US.cd_usuario = HOU.cd_usuario				
Where
	year(Dt_Fatura)=YEAR(getdate())
	and Dt_Fatura <=getdate()
	and (PP.Apelido = @Grupo or @Grupo  = 'ALL')  		
Group by PP.Apelido,CLI.Apelido,Month(Dt_Fatura),HOU.Num_proc,HOU.Master,(Case when @Grupo ='GRUPO DOW' then
	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end)
	,nome_local,LEFT(cta.num_proc,2)
	,US.nome_usuario

--select 
--	'IM' Modal ,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end)  Grupo,
--	HOU.Num_proc_him [JOB],HOU.Num_proc_mim [Ref Consolidada],
--	sum(dbo.valor(Valor_ARP,DC)) Valor, CLI.Apelido Cliente,month(Dt_Fatura) Mes
--	,Nome_Local Localidade,US.nome_usuario
--from 
--	Fatura_Arg_Det CTA  with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join House_imp_mar hou with(nolock)  on hou.num_proc_him=cta.num_proc
--	Join JOB_imp_mar JOB with(nolock)  on JOB.num_proc_him=cta.num_proc
--	join Usuario US	with(nolock)  on US.cd_usuario = JOB.cd_usuario
--	Join Pessoa CLI with(nolock)  on HOU.cd_consig_him=CLI.cd_pes
--	Join Pessoa_LLP PLLP with(nolock)  on cd_consig_him=PLLP.cd_pes
--	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--	Join Localidade Org with(nolock) on Org.cd_local=Cd_dst_him
--Where
--	--year(Dt_Fatura)=2014
--	--and Dt_Fatura <=getdate()
--	Dt_Fatura  between @dataInicial and @DataFinal
--	--and PP.Apelido = @Grupo
--	and (PP.Apelido = @Grupo or @Grupo = 'ALL') 
--Group by PP.Apelido,CLI.Apelido ,Month(Dt_Fatura),HOU.Num_proc_him,HOU.Num_proc_mim,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) 
--	,Nome_Local,US.nome_usuario


--Union All


--select 
--	'IA' Modal ,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) Grupo,
--	HOU.Num_proc_hia [JOB],HOU.Num_proc_mia [Ref Consolidada],
--	sum(dbo.valor(Valor_ARP,DC)) Valor,CLI.Apelido Cliente,month(Dt_Fatura) Mes
--	,Nome_Local Localidade,US.nome_usuario
--from 
--	Fatura_Arg_Det CTA with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join House_imp_aer hou with(nolock)  on hou.num_proc_hia=cta.num_proc
--	Join JOB_imp_aer JOB with(nolock)  on JOB.num_proc_hia=cta.num_proc
--	join Usuario US	with(nolock)  on US.cd_usuario = JOB.cd_usuario
--	Join Pessoa CLI with(nolock)  on HOU.cd_consig_hia=CLI.cd_pes
--	Join Pessoa_LLP PLLP with(nolock)  on cd_consig_hia=PLLP.cd_pes
--	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--	Join Localidade Org with(nolock) on Org.cd_local=Cd_Dst_HIA
--Where
--	--year(Dt_Fatura)=2014
--	--and Dt_Fatura <=getdate()
--	Dt_Fatura  between @dataInicial and @DataFinal
--	--and PP.Apelido = @Grupo
--	and (PP.Apelido = @Grupo or @Grupo = 'ALL')
--Group by PP.Apelido,CLI.Apelido ,Month(Dt_Fatura),HOU.Num_proc_hia,HOU.Num_proc_mia,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) 
--	,Nome_Local,US.nome_usuario
--Union All

--select 
--	'IO' Modal ,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) Grupo,
--	HOU.Num_proc_hio JOB,'JOB' [Ref Consolidada],
--	sum(dbo.valor(Valor_ARP,DC)) Valor,CLI.Apelido Cliente,month(Dt_Fatura) Mes
--	,Nome_Local Localidade,US.nome_usuario
--from 
--	Fatura_Arg_Det CTA with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join House_imp_Out hou with(nolock)  on hou.num_proc_hio=cta.num_proc
--	Join llp_imp_Out JOB with(nolock)  on JOB.num_proc_lio=cta.num_proc
--	join Usuario US	with(nolock)  on US.cd_usuario = JOB.cd_usuario
--	Join Pessoa CLI with(nolock)  on HOU.cd_consig_hio=CLI.cd_pes
--	Join Pessoa_LLP PLLP with(nolock)  on cd_consig_hio=PLLP.cd_pes
--	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--	Join Localidade Org with(nolock) on Org.cd_local=Cd_Dst_HIO
--Where
--	--year(Dt_Fatura)=2014
--	--and Dt_Fatura <=getdate()
--	Dt_Fatura  between @dataInicial and @DataFinal
--	--and PP.Apelido = @Grupo
--	and (PP.Apelido = @Grupo or @Grupo = 'ALL')
--Group by PP.Apelido,CLI.Apelido ,Month(Dt_Fatura),HOU.Num_proc_hio,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end)
--	,Nome_Local,US.nome_usuario

--Union All


--select 
--	'EO' Modal ,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) Grupo,
--	Hou.Num_proc_heo JOB,'JOB'[Ref Consolidada],
--	sum(dbo.valor(Valor_ARP,DC)) Valor,CLI.Apelido Cliente,month(Dt_Fatura) Mes
--	,Nome_Local Localidade,US.nome_usuario
--from 
--	Fatura_Arg_Det CTA with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join House_exp_Out hou with(nolock)  on hou.num_proc_heo=cta.num_proc
--	Join llp_exp_Out JOB with(nolock)  on JOB.num_proc_leo=cta.num_proc
--	join Usuario US	with(nolock)  on US.cd_usuario = JOB.cd_usuario
--	Join Pessoa CLI with(nolock)  on HOU.cd_export_heo=CLI.cd_pes
--	Join Pessoa_LLP PLLP with(nolock)  on cd_export_heo=PLLP.cd_pes
--	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--	Join Localidade Org  with(nolock) on Org.cd_local=Cd_Org_HEO
--Where
--	--year(Dt_Fatura)=2014
--	--and Dt_Fatura <=getdate()
--	Dt_Fatura  between @dataInicial and @DataFinal
--	--and PP.Apelido = @Grupo
--	and (PP.Apelido = @Grupo or @Grupo = 'ALL')
--Group by PP.Apelido,CLI.Apelido ,Month(Dt_Fatura),Hou.Num_proc_heo,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) 
--	,Nome_Local,US.nome_usuario
	
--Union All

--select 
--	'EM' Modal ,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) Grupo,
--	Hou.Num_proc_hem JOB,HOU.Num_proc_mem [Ref Consolidada],
--	sum(dbo.valor(Valor_ARP,DC)) Valor,CLI.Apelido Cliente,month(Dt_Fatura) Mes
--	,Nome_Local Localidade,US.nome_usuario
--from 
--	Fatura_Arg_Det CTA with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join House_exp_MAR hou with(nolock)  on hou.num_proc_hem=cta.num_proc
--	Join JOB_exp_mar JOB with(nolock)  on JOB.num_proc_hem=cta.num_proc
--	join Usuario US	with(nolock)  on US.cd_usuario = JOB.cd_usuario
--	Join Pessoa CLI with(nolock)  on HOU.cd_export_hem=CLI.cd_pes
--	Join Pessoa_LLP PLLP with(nolock)  on cd_export_hem=PLLP.cd_pes
--	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--	Join Localidade Org with(nolock) on Org.cd_local=cd_org_hem
--Where
--	--year(Dt_Fatura)=2014
--	--and Dt_Fatura <=getdate()
--	Dt_Fatura  between @dataInicial and @DataFinal
--	--and PP.Apelido = @Grupo
--	and (PP.Apelido = @Grupo or @Grupo = 'ALL')
--Group by PP.Apelido,CLI.Apelido ,Month(Dt_Fatura),Hou.Num_proc_hem,HOU.Num_proc_mem ,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) 
--	,Nome_Local,US.nome_usuario

--Union All

--select distinct
--	'EA' Modal ,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end)Grupo,
--	HOU.Num_proc_hea JOBs,HOU.Num_proc_mea [Ref Consolidada],
--	sum(dbo.valor(Valor_ARP,DC)) Valor,CLI.Apelido Cliente,month(Dt_Fatura) Mes
--	,Nome_Local Localidade,US.nome_usuario
--from 
--	Fatura_Arg_Det CTA with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join House_exp_AER hou with(nolock)  on hou.num_proc_hea=cta.num_proc
--	Join JOB_exp_aer JOB with(nolock)  on JOB.num_proc_hea=cta.num_proc
--	join Usuario US	with(nolock)  on US.cd_usuario = JOB.cd_usuario
--	Join Pessoa CLI with(nolock)  on HOU.cd_export_hea=CLI.cd_pes
--	Join Pessoa_LLP PLLP with(nolock)  on cd_export_hea=PLLP.cd_pes
--	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--	Join Localidade Org with(nolock) on Org.cd_local=Cd_Org_HEA
--Where
--	--year(Dt_Fatura)=2014
--	--and Dt_Fatura <=getdate()
--	Dt_Fatura  between @dataInicial and @DataFinal
--	--and PP.Apelido = @Grupo
--	and (PP.Apelido = @Grupo or @Grupo = 'ALL')
--Group by PP.Apelido,CLI.Apelido ,Month(Dt_Fatura),HOU.Num_proc_hea,HOU.Num_proc_mea ,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) 
--	,Nome_Local,US.nome_usuario

--OPTION(HASH JOIN)
GO
