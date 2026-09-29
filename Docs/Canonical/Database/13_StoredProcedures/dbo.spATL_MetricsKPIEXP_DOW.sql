SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--spATL_MetricsKPIEXP_DOW 'Grupo Dow','2012-01-01','2012-01-31'

CREATE Procedure [dbo].[spATL_MetricsKPIEXP_DOW] 
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
as

	declare @cd_pes_grupo varchar(10)
	Set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)

	set @grupo = (select grupo from grupo where cd_pes_grupo = @cd_pes_grupo)

select distinct
	LLP.Num_proc_lem																[Job],
	num_pedido																		[Order Number],
	(case when Isnull(right(cm.cd_tp_cont,1),nome_tp_Carga) = 'T' then 'Isotank'
		when Isnull(right(cm.cd_tp_cont,1),nome_tp_Carga) = 'B' then 'Bulk Cargo'
		else 'Vessel-Container' end)												[Dispatch],
	org.nome_local																	[Origem],
	dst.nome_local																	[Destino],
	'Marítimo'																		[Modal],
	atd_lem																			[ATD],
	left(datename(month,atd_lem),3)													[Month ATD],	
	t12.dt_conclusao																[Doc Sent],
	dbo.quantidade_dias(atd_lem,t12.dt_conclusao)									[Biz Days],
	business_group_descr															[Business Group], 
	Business_Descr																	[Business Name],	
	(Case when Form_A is not null then '1'
		else '0' end)																[Form A],
	(case when datediff(day,atd_lem,t12.dt_conclusao) < '0' then '1'
		else datediff(day,atd_lem,t12.dt_conclusao) end)							[Run Days],
	(case when pa.cd_pais = 'AR' then '300'
		else '200' end)																[Destination],
	''																				[Plant ID]
from house_exp_mar HOU with(nolock)
	Join LLP_exp_MAr LLP with(nolock) on LLP.num_proc_lem=hou.num_proc_hem
	Join Localidade ORG with(nolock) on ORG.cd_local=cd_org_hem
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_hem
	Left Join Pedido_Ship PS with(nolock) on PS.num_proc=num_proc_lem
	Left Join Produto_Cliente PC with(nolock) on PC.cd_prod=PS.cd_produto
	Left Join De_ParA_PRoduto DPP with(nolock) on DPP.gmid=cd_proc_cliente		
	Join Tipo_Carga TC with(nolock) on TC.cd_tp_carga=LLP.cd_tp_carga
	Left Join Container_hou_exp_mar CH with(nolock) on num_proc_lem=CH.num_proc_hem
	Left Join Container_mas_exp_mar CM with(nolock) on CH.num_proc_mem=CM.num_proc_mem and CH.item_cont_em=CM.item_cont_em
	Left Join Pedido PD with(nolock) on PD.cd_pedido=PS.cd_pedido
	Join Pais PA with(nolock) on PA.cd_pais=DST.cd_pais
	Join Pessoa_LLP PP with(nolock) on PP.cd_pes=cd_export_hem
	Left Join tarefas_processos T12 with(nolock) on T12.num_proc=num_proc_lem and t12.id_task=12
Where atd_lem is not null
	and substring(num_proc_lem,3,3) = @grupo
	and atd_lem between @DtInicial and @DtFinal

UNION ALL

select distinct
	LLP.Num_proc_leo																[Job],
	num_pedido																		[Order Number],		
	(case LLP.tipo_leo when 'T' then 'Truck' else 'Rail' end)						[Dispatch],
	org.nome_local																	[Origem],
	dst.nome_local																	[Destino],
	(case LLP.tipo_leo when 'T' then 'Rodoviário' else 'Ferroviário' end)			[Modal],
	atd_leo																			[ATD],
	left(datename(month,atd_leo),3)													[Month ATD],	
	t12.dt_conclusao																[Doc Sent],
	dbo.quantidade_dias(atd_leo,t12.dt_conclusao)									[Biz Days],
	business_group_descr															[Business Group], 
	Business_Descr																	[Business Name],	
	'0'																				[Form A],
	(case when datediff(day,atd_leo,t12.dt_conclusao) < '0' then '1'
		else datediff(day,atd_leo,t12.dt_conclusao) end)							[Run Days],
	(case when pa.cd_pais = 'AR' then '300'
		else '200' end)																[Destination],
	''																				[Plant ID]
from house_exp_out HOU
	Join LLP_exp_out LLP with(nolock) on LLP.num_proc_leo=hou.num_proc_heo
	Join Localidade ORG with(nolock) on ORG.cd_local=cd_org_heo
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_heo
	Left Join Pedido_Ship PS with(nolock) on PS.num_proc=num_proc_leo
	Left Join Produto_Cliente PC with(nolock) on PC.cd_prod=PS.cd_produto
	Left Join De_ParA_PRoduto DPP with(nolock) on DPP.gmid=cd_proc_cliente
	Left Join tarefas_processos T12 with(nolock) on T12.num_proc=num_proc_leo and T12.id_task=12
	Left Join Pedido PD with(nolock) on PD.cd_pedido=PS.cd_pedido	
	Join Pais PA with(nolock) on PA.cd_pais=DST.cd_pais
	Join Pessoa_LLP PP with(nolock) on PP.cd_pes=cd_export_heo
Where atd_leo is not null
	and substring(num_proc_leo,3,3) = @grupo
	and atd_leo between @DtInicial and @DtFinal

UNION ALL

select distinct
	LLP.Num_proc_lea																[Job],
	num_pedido																		[Order Number],	
	'Air'																			[Dispatch],	
	org.nome_local																	[Origem],
	dst.nome_local																	[Destino],
	'Aéreo'																			[Modal],
	atd_lea																			[ATD],
	left(datename(month,atd_lea),3)													[Month ATD],
	t12.dt_conclusao																[Doc Sent],
	dbo.quantidade_dias(atd_lea,t12.dt_conclusao)									[Biz Days],
	business_group_descr															[Business Group], 
	Business_Descr																	[Business Name],	
	(Case when Form_A is not null then '1'
		else '0' end)																[Form A],
	(case when datediff(day,atd_lea,t12.dt_conclusao) < '0' then '1'
		else datediff(day,atd_lea,t12.dt_conclusao) end)							[Run Days],
	(case when pa.cd_pais = 'AR' then '300'
		else '200' end)																[Destination],
	''																				[Plant ID]
from house_exp_aer HOU with(nolock)
	Join LLP_exp_aer LLP with(nolock) on LLP.num_proc_lea=hou.num_proc_hea
	Join Localidade ORG with(nolock) on ORG.cd_local=cd_org_hea
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_hea
	Left Join Pedido_Ship PS with(nolock) on PS.num_proc=num_proc_lea
	Left Join Produto_Cliente PC with(nolock) on PC.cd_prod=PS.cd_produto
	Left Join De_ParA_PRoduto DPP with(nolock) on DPP.gmid=cd_proc_cliente
	Left Join tarefas_processos T12 with(nolock) on T12.num_proc=num_proc_lea and T12.id_task=12
	Left Join Pedido PD with(nolock) on PD.cd_pedido=PS.cd_pedido	
	Join Pais PA with(nolock) on PA.cd_pais=DST.cd_pais
	Join Pessoa_LLP PP with(nolock) on PP.cd_pes=cd_export_hea
Where atd_lea is not null
	and substring(num_proc_lea,3,3) = @grupo
	and atd_lea between @DtInicial and @DtFinal

OPTION(HASH JOIN)
GO
