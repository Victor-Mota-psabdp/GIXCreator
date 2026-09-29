SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--cadu, parece q ninguem usava, pois estava definido o ano 2014
--alterei pra year(Dt_Fatura)=YEAR(getdate()) e grupo all
--177	Faturamento Detalhado por Grupo					spATL_NFPorGrupoDetV2_Rel alterado para view 02/07/2018
--[spATL_NFPorGrupoDetV2_Rel]'ALL'
CREATE Procedure [dbo].[spATL_NFPorGrupoDetV2_Rel]-- 'Grupo OXITENO'
	@Grupo varchar(50)
AS

if @Grupo = '' 
begin
Set @Grupo = 'ALL'
End


Declare @Year as int
set @year = (select YEAR(getdate()))

Declare @ActualDate as Datetime
Declare @Month as int
set @Month = (select Month(getdate()))
if @Month = 1
	begin
		set @ActualDate=(select dateadd(YEAR,-1,getdate()))
		set @Year=(select YEAR(@ActualDate))
	end

print @year


select
		LEFT(cta.num_proc,2)			[Modal],
		(Case when @Grupo ='GRUPO DOW' then
			(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		else PP.Apelido end)			[Grupo],
		cta.num_proc					[JOB],
		sum(dbo.valor(Valor_ARP,DC))	[Valor],
		CLI.Apelido						[Cliente],
		month(Dt_Fatura)				[Mes]
		
	from 
		vwFaturasValidasArg CTA		with(nolock)
		Join Tipo_Taxa TT			with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
		Join vwClienteALLJOBS hou	with(nolock) on hou.num_proc=CTA.Num_Proc
		Join Pessoa CLI				with(nolock) on HOU.cd_cliente=CLI.cd_pes
		left Join Pessoa_LLP PLLP	with(nolock) on HOU.cd_cliente=PLLP.cd_pes
		left Join Pessoa PP			with(nolock) on PP.cd_pes=cd_pes_grupo				
	Where
		year(Dt_Fatura)=@Year --YEAR(getdate())
		and Dt_Fatura <=getdate()
		and (PP.Apelido = @Grupo or @Grupo  = 'ALL')
	Group by 
			PP.Apelido,CLI.Apelido ,Month(Dt_Fatura),cta.num_proc,
			LEFT(cta.num_proc,2),(Case when @Grupo ='GRUPO DOW' then(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' 
			then 'Grupo DOW AGRO' else 'Grupo Dow' end)	else PP.Apelido end)
			
	
		
UNION ALL
	--Master
	select
		LEFT(cta.num_proc,2)			[Modal],
		(Case when @Grupo ='GRUPO DOW' then
			(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end)
		else PP.Apelido end)			[Grupo],
		cta.num_proc					[JOB],
		sum(dbo.valor(Valor_ARP,DC))	[Valor],
		CLI.Apelido						[Cliente],
		month(Dt_Fatura)				[Mes]
	from 
		vwFaturasValidasArg CTA		with(nolock)
		Join Tipo_Taxa TT			with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
		Join vwClienteALLJOBS hou	with(nolock) on hou.Master=CTA.Num_Proc
		Join Pessoa CLI				with(nolock) on HOU.cd_cliente=CLI.cd_pes
		left Join Pessoa_LLP PLLP	with(nolock) on HOU.cd_cliente=PLLP.cd_pes
		left Join Pessoa PP			with(nolock) on PP.cd_pes=cd_pes_grupo				
	Where
		year(Dt_Fatura)=@Year --YEAR(getdate())
		and Dt_Fatura <=getdate()
		and (PP.Apelido = @Grupo or @Grupo  = 'ALL')  		
	Group by 
			PP.Apelido,CLI.Apelido ,Month(Dt_Fatura),cta.num_proc,
			LEFT(cta.num_proc,2),(Case when @Grupo ='GRUPO DOW' then(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' 
			then 'Grupo DOW AGRO' else 'Grupo Dow' end)	else PP.Apelido end)


--old
--select 
--	'IM' Modal ,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end)  Grupo,
--	HOU.Num_proc_him [JOB],sum(dbo.valor(Valor_ARP,DC)) Valor, CLI.Apelido Cliente,month(Dt_Fatura) Mes
--from 
--	Fatura_Arg_Det CTA  with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join House_imp_mar hou with(nolock)  on hou.num_proc_him=cta.num_proc
--	Join Pessoa CLI with(nolock)  on HOU.cd_consig_him=CLI.cd_pes
--	Join Pessoa_LLP PLLP with(nolock)  on cd_consig_him=PLLP.cd_pes
--	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--Where
--	year(Dt_Fatura)=YEAR(getdate())
--	and Dt_Fatura <=getdate()
--	and (PP.Apelido = @Grupo or @Grupo = 'ALL')  
--Group by PP.Apelido,CLI.Apelido ,Month(Dt_Fatura),HOU.Num_proc_him,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) 

--Union All


--select 
--	'IA' Modal ,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) Grupo,HOU.Num_proc_hia [JOB],sum(dbo.valor(Valor_ARP,DC)) Valor,CLI.Apelido Cliente,month(Dt_Fatura) Mes
--from 
--	Fatura_Arg_Det CTA with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join House_imp_aer hou with(nolock)  on hou.num_proc_hia=cta.num_proc
--	Join Pessoa CLI with(nolock)  on HOU.cd_consig_hia=CLI.cd_pes
--	Join Pessoa_LLP PLLP with(nolock)  on cd_consig_hia=PLLP.cd_pes
--	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--Where
--	--year(Dt_Fatura)=2014
--	year(Dt_Fatura)=YEAR(getdate())
--	and Dt_Fatura <=getdate()
--	--and PP.Apelido = @GRupo
--	and (PP.Apelido = @Grupo or @Grupo = 'ALL')  
--Group by PP.Apelido,CLI.Apelido ,Month(Dt_Fatura),HOU.Num_proc_hia,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) 

--Union All

--select 
--	'IO' Modal ,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) Grupo,HOU.Num_proc_hio JOB,sum(dbo.valor(Valor_ARP,DC)) Valor,CLI.Apelido Cliente,month(Dt_Fatura) Mes
--from 
--	Fatura_Arg_Det CTA with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join House_imp_Out hou with(nolock)  on hou.num_proc_hio=cta.num_proc
--	Join Pessoa CLI with(nolock)  on HOU.cd_consig_hio=CLI.cd_pes
--	Join Pessoa_LLP PLLP with(nolock)  on cd_consig_hio=PLLP.cd_pes
--	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--Where
--	--year(Dt_Fatura)=2014
--	year(Dt_Fatura)=YEAR(getdate())
--	and Dt_Fatura <=getdate()
--	--and PP.Apelido = @GRupo
--	and (PP.Apelido = @Grupo or @Grupo = 'ALL')  
--Group by PP.Apelido,CLI.Apelido ,Month(Dt_Fatura),HOU.Num_proc_hio,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end)


--Union All


--select 
--	'EO' Modal ,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) Grupo,Hou.Num_proc_heo JOB,sum(dbo.valor(Valor_ARP,DC)) Valor,CLI.Apelido Cliente,month(Dt_Fatura) Mes
--from 
--	Fatura_Arg_Det CTA with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join House_exp_Out hou with(nolock)  on hou.num_proc_heo=cta.num_proc
--	Join Pessoa CLI with(nolock)  on HOU.cd_export_heo=CLI.cd_pes
--	Join Pessoa_LLP PLLP with(nolock)  on cd_export_heo=PLLP.cd_pes
--	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--Where
--	--year(Dt_Fatura)=2014
--	year(Dt_Fatura)=YEAR(getdate())
--	and Dt_Fatura <=getdate()
--	--and PP.Apelido = @GRupo
--	and (PP.Apelido = @Grupo or @Grupo = 'ALL')  
--Group by PP.Apelido,CLI.Apelido ,Month(Dt_Fatura),Hou.Num_proc_heo,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) 

--Union All


--select 
--	'EM' Modal ,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) Grupo,Hou.Num_proc_hem JOB,sum(dbo.valor(Valor_ARP,DC)) Valor,CLI.Apelido Cliente,month(Dt_Fatura) Mes
--from 
--	Fatura_Arg_Det CTA with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join House_exp_MAR hou with(nolock)  on hou.num_proc_hem=cta.num_proc
--	Join Pessoa CLI with(nolock)  on HOU.cd_export_hem=CLI.cd_pes
--	Join Pessoa_LLP PLLP with(nolock)  on cd_export_hem=PLLP.cd_pes
--	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--Where
--	--year(Dt_Fatura)=2014
--	year(Dt_Fatura)=YEAR(getdate())
--	and Dt_Fatura <=getdate()
--	--and PP.Apelido = @GRupo
--	and (PP.Apelido = @Grupo or @Grupo = 'ALL')  
--Group by PP.Apelido,CLI.Apelido ,Month(Dt_Fatura),Hou.Num_proc_hem,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) 


--Union All

--select distinct
--	'EA' Modal ,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end)   Grupo,HOU.Num_proc_hea JOBs,sum(dbo.valor(Valor_ARP,DC)) Valor,CLI.Apelido Cliente,month(Dt_Fatura) Mes
--from 
--	Fatura_Arg_Det CTA with(nolock)
--	Join Fatura_ARG FAT with(nolock) on CTA.ID_FAT = FAT.ID_FAT and Status <>2
--	Join House_exp_AER hou with(nolock)  on hou.num_proc_hea=cta.num_proc
--	Join Pessoa CLI with(nolock)  on HOU.cd_export_hea=CLI.cd_pes
--	Join Pessoa_LLP PLLP with(nolock)  on cd_export_hea=PLLP.cd_pes
--	Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
--Where
--	--year(Dt_Fatura)=2014
--	year(Dt_Fatura)=YEAR(getdate())
--	and Dt_Fatura <=getdate()
--	--and PP.Apelido = @Grupo
--	and (PP.Apelido = @Grupo or @Grupo = 'ALL')  
--Group by PP.Apelido,CLI.Apelido ,Month(Dt_Fatura),HOU.Num_proc_hea,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) 

GO
