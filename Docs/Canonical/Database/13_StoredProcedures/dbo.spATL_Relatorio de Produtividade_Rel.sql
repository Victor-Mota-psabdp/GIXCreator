SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spATL_Relatorio de Produtividade_Rel]'2015-01-01','2015-01-31'
CREATE Procedure [dbo].[spATL_Relatorio de Produtividade_Rel]--'2015-01-01','2015-01-31'	
	@DataInicial Datetime,
	@DataFinal Datetime
AS

Declare @TAB Table
(
	Data_JOB	Varchar(10),
	Modal		Varchar(2),
	Grupo		Varchar(50),
	JOB			Varchar(16),
	Cliente		Varchar(100),
	PO			Varchar(100),
	DATA_PO		Datetime,
	DI			Varchar(100),
	DATA_DI		Datetime,
	LI			Varchar(100),
	DATA_LI		Datetime,
	SUB			Varchar(100),
	DATA_SUB		Datetime
)

insert into @TAB
	select 
		HOU.dt_emis_him Data_JOB,
		'IM' Modal ,
		PP.Apelido Grupo,
		HOU.Num_proc_him [JOB], 
		CLI.Apelido Cliente,	
		P.Num_Pedido PO,
		P.Dt_Pedido Data_PO,
		DI.Numero_PO_HIM DI,
		DI.Data_PO_HIM Data_DI,
		LI.Num_LI LI,
		LI.Dt_LI Data_LI,
		SUB.Num_LI SUB,
		SUB.Dt_LI Data_SUB	
		
		--Quantidade de POs		
		--quantidade de DIs  Marítimas	
		--Quantidade de Lis	
		--Quantidade de LIs  Sub

	from 
		House_Imp_Mar			HOU with(nolock)
		left Join Pedido_Ship	PS	With(nolock)on PS.Num_Proc = HOU.Num_Proc_HIM
		left join pedido		P	With(nolock)on P.Cd_pedido = PS.cd_pedido		
		left join PO_HIM		DI	With(nolock)on DI.Num_Proc_HIM = HOU.Num_Proc_HIM and DI.ID_DC = 5
		left join Solicitacao_LI LI with(nolock)on LI.Num_Proc = HOU.Num_Proc_HIM and LI.ID_Tipo_LI = 1 
		left join Solicitacao_LI SUB with(nolock)on SUB.Num_Proc = HOU.Num_Proc_HIM and SUB.ID_Tipo_LI = 4
		Join Pessoa				CLI with(nolock)on HOU.cd_consig_him=CLI.cd_pes
		Join Pessoa_LLP			PLLP with(nolock)on cd_consig_him=PLLP.cd_pes
		Join Pessoa				PP with(nolock)on PP.cd_pes=cd_pes_grupo
	Where
		convert(datetime,HOU.dt_emis_him,105) between '2015-01-01' and '2015-01-31'	
		--and PP.Apelido = 'GRUPO LEVIS'
	--Group by PP.Apelido,HOU.dt_emis_him,CLI.Apelido,HOU.Num_proc_him,DI.Numero_PO_HIM,	DI.Data_PO_HIM,LI.Num_LI,LI.Dt_LI,SUB.Num_LI,
	--	SUB.Dt_LI,P.Num_Pedido,P.Dt_Pedido
	order by HOU.Dt_Emis_HIM,PP.Apelido


--select Data_JOB, Grupo, COUNT(PO) PO, COUNT(DI) DI ,COUNT(LI) LI ,COUNT(SUB) SUB from @TAB
--Group by Grupo,Data_JOB

select DATA_PO, Grupo, COUNT(PO) PO from @TAB
Group by Grupo,DATA_PO 
Having COUNT(DI) > 0
order by DATA_PO

select Data_DI, Grupo,  COUNT(DI) DI from @TAB 
Group by Grupo,DATA_DI
Having COUNT(DI) > 0
order by DATA_DI

select Data_LI, Grupo,COUNT(LI) LI  from @TAB 
Group by Grupo,DATA_LI
Having COUNT(LI) > 0
order by DATA_LI

select Data_SUB, Grupo,COUNT(SUB) SUB from @TAB
Group by Grupo,DATA_SUB
Having COUNT(SUB) > 0
order by DATA_SUB

select * from @TAB


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
--	Join Localidade Org on Org.cd_local=Cd_Dst_HIA
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
--	Join Localidade Org on Org.cd_local=Cd_Dst_HIO
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
--	Join Localidade Org on Org.cd_local=Cd_Org_HEO
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
--	Join Localidade Org on Org.cd_local=cd_org_hem
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
--	Join Localidade Org on Org.cd_local=Cd_Org_HEA
--Where
--	--year(Dt_Fatura)=2014
--	--and Dt_Fatura <=getdate()
--	Dt_Fatura  between @dataInicial and @DataFinal
--	--and PP.Apelido = @Grupo
--	and (PP.Apelido = @Grupo or @Grupo = 'ALL')
--Group by PP.Apelido,CLI.Apelido ,Month(Dt_Fatura),HOU.Num_proc_hea,HOU.Num_proc_mea ,(Case when @Grupo ='GRUPO DOW' then
--	(Case when substring(CLI.Apelido,1,8) = 'DOW AGRO' then 'Grupo DOW AGRO' else 'Grupo Dow' end) else PP.Apelido end) 
--	,Nome_Local,US.nome_usuario

GO
