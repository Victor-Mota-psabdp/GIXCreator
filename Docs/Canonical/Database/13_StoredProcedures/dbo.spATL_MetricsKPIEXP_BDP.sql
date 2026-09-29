SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spATL_MetricsKPIEXP_BDP]--'Grupo FMC','2011-01-01','2011-12-31'
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
	datename(month,atd_lem)															[Month ATD],
	t4.dt_conclusao																	[Desembaraço],
	dbo.quantidade_dias(atd_lem,t4.dt_conclusao)									[Biz Days],
	RE.Data_PO_HEM																	[Dt RE],
	t66.dt_conclusao																[Draft],
	CO.data_po_hem																	[Dt. Certificado],	
	(case when datediff(day,atd_lem,t4.dt_conclusao) < '0' then '0'
		else datediff(day,atd_lem,t4.dt_conclusao) end)								[Run Days],
	(case when pa.cd_pais = 'AR' then '300'
		else '200' end)																[Destination],
	datediff(day,convert(Datetime,dt_emis_hem,105),RE.DATA_PO_HEM)					[Run Days RE],
	t12.dt_conclusao																[Doc Sent],
	datediff(day,atd_lem,t12.dt_conclusao)											[Run Days],
	right(left(LLP.Num_proc_lem,5),3)												[Group],
	T40.dt_conclusao																[Prestação de Contas],
	T5.dt_conclusao																	[Booking],
	convert(Datetime,dt_emis_hem,105)												[Dt.Criacao],
	(case when datediff(day,t58.dt_conclusao,t5.dt_conclusao) is null then 'NA'
		else cast(datediff(day,t58.dt_conclusao,t5.dt_conclusao) as varchar(5))end) [Booking time],	
	(case when datediff(day,RE.Data_PO_HEM,t66.dt_conclusao) is null then 'NA'
		else cast(datediff(day,RE.Data_PO_HEM,t66.dt_conclusao) as varchar(5))end)	[Draft Time],												
	(case when datediff(day,atd_lem,t12.dt_conclusao) is null then 'NA'
		else cast(datediff(day,atd_lem,t12.dt_conclusao) as varchar(5))end)			[Doc Sent],
	(case when datediff(day,atd_lem,T40.dt_conclusao) is null then 'NA'
		else cast(datediff(day,atd_lem,T40.dt_conclusao) as varchar(5))end)			[P.Contas - Time],										
	(case when datediff(day,T50.dt_conclusao,RE.Data_PO_HEM) is null then 'NA'
		else cast(datediff(day,T50.dt_conclusao,RE.Data_PO_HEM) as varchar(5))end)	[RE - Time],										
	(case when datediff(day,CO.data_po_hem	,T50.dt_conclusao) is null then 'NA'
		else cast(datediff(day,CO.data_po_hem	,T50.dt_conclusao) as varchar(5))end)[Cert. Origem],										
	(case when datediff(day,T21.dt_conclusao,T97.dt_conclusao) is null then 'NA'
		else cast(datediff(day,T21.dt_conclusao,T97.dt_conclusao) as varchar(5))end)[Form A],
	datename(month,T40.dt_conclusao)												[Month P.Contas],
	Nome_Regiao																		[Region],										
	(case when datediff(day,t50.dt_conclusao,T40.dt_conclusao) is null then 'NA'
		else cast(datediff(day,t50.dt_conclusao,T40.dt_conclusao) as varchar(5))end)[/]	
from house_exp_mar HOU with(nolock)
	Join LLP_exp_MAr LLP with(nolock) on LLP.num_proc_lem=hou.num_proc_hem
	Join Localidade ORG with(nolock) on ORG.cd_local=cd_org_hem
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_hem
	Left Join Pedido_Ship PS with(nolock) on PS.num_proc=num_proc_lem
	Left Join PO_HEM RE with(nolock) on RE.num_proc_hem=num_proc_lem and RE.ID_DC=4
	Left Join PO_hem CO with(nolock) on num_proc_lem=CO.num_proc_hem and CO.id_dc=13
	Left Join Produto_Cliente PC with(nolock) on PC.cd_prod=PS.cd_produto
	Left Join De_ParA_PRoduto DPP with(nolock) on DPP.gmid=cd_proc_cliente
	Left Join tarefas_processos T4 with(nolock) on T4.num_proc=num_proc_lem and T4.id_task=4
	Left Join tarefas_processos T66 with(nolock) on T66.num_proc=num_proc_lem and T66.id_task=66
	Left Join tarefas_processos T12 with(nolock) on T12.num_proc=num_proc_lem and t12.id_task=12
	Left Join tarefas_processos T40 with(nolock) on T40.num_proc=num_proc_lem and T40.id_task=40
	Left Join tarefas_processos T5 with(nolock) on T5.num_proc=num_proc_lem and T5.id_task=5
	Left Join tarefas_processos T58 with(nolock) on T58.num_proc=num_proc_lem and T58.id_task=58
	Left Join tarefas_processos T50 with(nolock) on T50.num_proc=num_proc_lem and T50.id_task=50
	Left Join tarefas_processos T97 with(nolock) on T97.num_proc=num_proc_lem and T97.id_task=97
	Left Join tarefas_processos T21 with(nolock) on T21.num_proc=num_proc_lem and T21.id_task=21
	Join Tipo_Carga TC with(nolock) on TC.cd_tp_carga=LLP.cd_tp_carga
	Left Join Container_hou_exp_mar CH with(nolock) on num_proc_lem=CH.num_proc_hem
	Left Join Container_mas_exp_mar CM with(nolock) on CH.num_proc_mem=CM.num_proc_mem and CH.item_cont_em=CM.item_cont_em
	Left Join Pedido PD with(nolock) on PD.cd_pedido=PS.cd_pedido
	Left Join PO_hem IV with(nolock) on num_proc_lem=iV.num_proc_hem and iV.id_dc=2
	Left Join Pais PA with(nolock) on PA.cd_pais=DST.cd_pais
	Left Join Regiao RG with(nolock) on DST.cd_regiao=RG.cd_regiao
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
	(case LLP.tipo_leo when 'T' then 'Rodoviario' else 'Ferroviário' end)			[Modal],
	atd_leo																			[ATD],
	datename(month,atd_leo)															[Month ATD],
	t4.dt_conclusao																	[Desembaraço],
	dbo.quantidade_dias(atd_leo,t4.dt_conclusao)									[Biz Days],
	RE.Data_PO_HEO																	[Dt RE],
	t66.dt_conclusao																[Draft],
	CO.data_po_heo																	[Dt. Certificado],	
	(case when datediff(day,atd_leo,t4.dt_conclusao) < '0' then '0'
		else datediff(day,atd_leo,t4.dt_conclusao) end)								[Run Days],
	(case when pa.cd_pais = 'AR' then '300'
		else '200' end)																[Destination],
	datediff(day,convert(Datetime,dt_emis_heo,105),RE.DATA_PO_HEO)					[Run Days RE],
	t12.dt_conclusao																[Doc Sent],
	datediff(day,atd_leo,t12.dt_conclusao)											[Run Days],
	right(left(LLP.Num_proc_leo,5),3)												[Group],
	T40.dt_conclusao																[Prestação de Contas],
	T5.dt_conclusao																	[Booking],
	convert(Datetime,dt_emis_heo,105)												[Dt.Criacao],
(case when datediff(day,t58.dt_conclusao,t5.dt_conclusao) is null then 'NA'
		else cast(datediff(day,t58.dt_conclusao,t5.dt_conclusao) as varchar(5))end) [Booking time],	
	(case when datediff(day,RE.Data_PO_HEO,t66.dt_conclusao) is null then 'NA'
		else cast(datediff(day,RE.Data_PO_HEO,t66.dt_conclusao) as varchar(5))end)	[Draft Time],												
	(case when datediff(day,atd_leo,t12.dt_conclusao) is null then 'NA'
		else cast(datediff(day,atd_leo,t12.dt_conclusao) as varchar(5))end)			[Doc Sent],
	(case when datediff(day,atd_leo,T40.dt_conclusao) is null then 'NA'
		else cast(datediff(day,atd_leo,T40.dt_conclusao) as varchar(5))end)			[P.Contas - Time],										
	(case when datediff(day,T50.dt_conclusao,RE.Data_PO_HEO) is null then 'NA'
		else cast(datediff(day,T50.dt_conclusao,RE.Data_PO_HEO) as varchar(5))end)	[RE - Time],										
	(case when datediff(day,CO.data_po_heo,T50.dt_conclusao) is null then 'NA'
		else cast(datediff(day,CO.data_po_heo,T50.dt_conclusao) as varchar(5))end)[Cert. Origem],										
	(case when datediff(day,T21.dt_conclusao,T97.dt_conclusao) is null then 'NA'
		else cast(datediff(day,T21.dt_conclusao,T97.dt_conclusao) as varchar(5))end)[Form A],
	datename(month,T40.dt_conclusao)												[Month P.Contas],
	Nome_Regiao																		[Region],										
	(case when datediff(day,t50.dt_conclusao,T40.dt_conclusao) is null then 'NA'
		else cast(datediff(day,t50.dt_conclusao,T40.dt_conclusao) as varchar(5))end)[/]	
from house_exp_out HOU with(nolock)
	Join LLP_exp_out LLP with(nolock) on LLP.num_proc_leo=hou.num_proc_heo
	Join Localidade ORG with(nolock) on ORG.cd_local=cd_org_heo
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_heo
	Left Join Pedido_Ship PS with(nolock) on PS.num_proc=num_proc_leo
	Left Join Produto_Cliente PC with(nolock) on PC.cd_prod=PS.cd_produto
	Left Join De_ParA_PRoduto DPP with(nolock) on DPP.gmid=cd_proc_cliente
	Left Join tarefas_processos T4 with(nolock) on T4.num_proc=num_proc_leo and T4.id_task=4
	Left Join tarefas_processos T66 with(nolock) on T66.num_proc=num_proc_leo and T66.id_task=66
	Left Join tarefas_processos T12 with(nolock) on T12.num_proc=num_proc_leo and t12.id_task=12
	Left Join tarefas_processos T40 with(nolock) on T40.num_proc=num_proc_leo and T40.id_task=40
	Left Join tarefas_processos T5 with(nolock) on T5.num_proc=num_proc_leo and T5.id_task=5
	Left Join tarefas_processos T58 with(nolock) on T58.num_proc=num_proc_leo and T58.id_task=58
	Left Join tarefas_processos T50 with(nolock) on T50.num_proc=num_proc_leo and T50.id_task=50
	Left Join tarefas_processos T97 with(nolock) on T97.num_proc=num_proc_leo and T97.id_task=97
	Left Join tarefas_processos T21 with(nolock) on T21.num_proc=num_proc_leo and T21.id_task=21
	Left Join Pedido PD with(nolock) on PD.cd_pedido=PS.cd_pedido
	Join Pais PA with(nolock) on PA.cd_pais=DST.cd_pais
	Left Join PO_HEo RE with(nolock) on RE.num_proc_heo=num_proc_leo and RE.ID_DC=4
	Left Join PO_heo CO with(nolock) on num_proc_leo=CO.num_proc_heo and CO.id_dc=13	
	Left Join Regiao RG with(nolock) on DST.cd_regiao=RG.cd_regiao
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
	datename(month,atd_lea)															[Month ATD],
	t4.dt_conclusao																	[Desembaraço],
	dbo.quantidade_dias(atd_lea,t4.dt_conclusao)									[Biz Days],
	RE.Data_PO_HEA																	[Dt RE],
	t66.dt_conclusao																[Draft],
	CO.data_po_hea																	[Dt. Certificado],	
	(case when datediff(day,atd_lea,t4.dt_conclusao) < '0' then '0'
		else datediff(day,atd_lea,t4.dt_conclusao) end)								[Run Days],
	(case when pa.cd_pais = 'AR' then '300'
		else '200' end)																[Destination],
	datediff(day,convert(Datetime,dt_emis_hea,105),RE.DATA_PO_HEA)					[Run Days RE],
	t12.dt_conclusao																[Doc Sent],
	datediff(day,atd_lea,t12.dt_conclusao)											[Run Days],
	right(left(LLP.Num_proc_lea,5),3)												[Group],
	T40.dt_conclusao																[Prestação de Contas],
	T5.dt_conclusao																	[Booking],
	convert(Datetime,dt_emis_hea,105)												[Dt.Criacao],
	(case when datediff(day,t58.dt_conclusao,t5.dt_conclusao) is null then 'NA'
		else cast(datediff(day,t58.dt_conclusao,t5.dt_conclusao) as varchar(5))end) [Booking time],	
	(case when datediff(day,RE.Data_PO_HEA,t66.dt_conclusao) is null then 'NA'
		else cast(datediff(day,RE.Data_PO_HEA,t66.dt_conclusao) as varchar(5))end)	[Draft Time],												
	(case when datediff(day,atd_lea,t12.dt_conclusao) is null then 'NA'
		else cast(datediff(day,atd_lea,t12.dt_conclusao) as varchar(5))end)			[Doc Sent],
	(case when datediff(day,atd_lea,T40.dt_conclusao) is null then 'NA'
		else cast(datediff(day,atd_lea,T40.dt_conclusao) as varchar(5))end)			[P.Contas - Time],										
	(case when datediff(day,T50.dt_conclusao,RE.Data_PO_HEA) is null then 'NA'
		else cast(datediff(day,T50.dt_conclusao,RE.Data_PO_HEA) as varchar(5))end)	[RE - Time],										
	(case when datediff(day,CO.data_po_hea	,T50.dt_conclusao) is null then 'NA'
		else cast(datediff(day,CO.data_po_hea	,T50.dt_conclusao) as varchar(5))end)[Cert. Origem],										
	(case when datediff(day,T21.dt_conclusao,T97.dt_conclusao) is null then 'NA'
		else cast(datediff(day,T21.dt_conclusao,T97.dt_conclusao) as varchar(5))end)[Form A],
	datename(month,T40.dt_conclusao)												[Month P.Contas],
	Nome_Regiao																		[Region],										
	(case when datediff(day,t50.dt_conclusao,T40.dt_conclusao) is null then 'NA'
		else cast(datediff(day,t50.dt_conclusao,T40.dt_conclusao) as varchar(5))end)[/]	
from house_exp_aer HOU with(nolock)
	Join LLP_exp_aer LLP with(nolock) on LLP.num_proc_lea=hou.num_proc_hea
	Join Localidade ORG with(nolock) on ORG.cd_local=cd_org_hea
	Join Localidade DST with(nolock) on DST.cd_local=cd_dst_hea
	Left Join Pedido_Ship PS with(nolock) on PS.num_proc=num_proc_lea
	Left Join Produto_Cliente PC with(nolock) on PC.cd_prod=PS.cd_produto
	Left Join De_ParA_PRoduto DPP with(nolock) on DPP.gmid=cd_proc_cliente
	Left Join tarefas_processos T4 with(nolock) on T4.num_proc=num_proc_lea and T4.id_task=4
	Left Join tarefas_processos T66 with(nolock) on T66.num_proc=num_proc_lea and T66.id_task=66
	Left Join tarefas_processos T12 with(nolock) on T12.num_proc=num_proc_lea and t12.id_task=12
	Left Join tarefas_processos T40 with(nolock) on T40.num_proc=num_proc_lea and T40.id_task=40
	Left Join tarefas_processos T5 with(nolock) on T5.num_proc=num_proc_lea and T5.id_task=5
	Left Join tarefas_processos T58 with(nolock) on T58.num_proc=num_proc_lea and T58.id_task=58
	Left Join tarefas_processos T50 with(nolock) on T50.num_proc=num_proc_lea and T50.id_task=50
	Left Join tarefas_processos T97 with(nolock) on T97.num_proc=num_proc_lea and T97.id_task=97
	Left Join tarefas_processos T21 with(nolock) on T21.num_proc=num_proc_lea and T21.id_task=21
	Left Join Pedido PD with(nolock) on PD.cd_pedido=PS.cd_pedido
	Left Join PO_hea LI with(nolock) on num_proc_lea=li.num_proc_hea and li.id_dc=23
	Join Pais PA with(nolock) on PA.cd_pais=DST.cd_pais
	Left Join PO_HEa RE with(nolock) on RE.num_proc_hea=num_proc_lea and RE.ID_DC=4
	Left Join PO_hea CO with(nolock) on num_proc_lea=CO.num_proc_hea and CO.id_dc=13	
	Left Join Regiao RG with(nolock) on DST.cd_regiao=RG.cd_regiao
Where atd_lea is not null
	and substring(num_proc_lea,3,3) = @grupo
	and atd_lea between @DtInicial and @DtFinal
 OPTION(HASH JOIN)
GO
