SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_MetricsKPI_DOW]'GRUPO ROHM & HAAS','2012-01-01','2012-12-31'

CREATE Procedure [dbo].[spATL_MetricsKPI_DOW_GI]--'GRUPO ROHM & HAAS','2012-01-01','2012-12-31'
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
as

	declare @cd_pes_grupo varchar(10)
	Set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)

	set @grupo = (select grupo from grupo where cd_pes_grupo = @cd_pes_grupo)

select distinct
	LLP.Num_proc_lim																[Job],
	num_pedido																		[Order Number],	
	t10.dt_previsao																	[Planned Goods Issue],
	t10.dt_conclusao																[Actual Goods Issue],
	(case when cd_tipo = '2' then 'Third' 
			when cd_tipo = '3' then 'Dow-to-Dow'
			else 'Sample' end)														[Order Type],	
	'Marítimo'																		[Modal],	 
	(case when Isnull(right(cm.cd_tp_cont,1),nome_tp_Carga) = 'T' then 'Isotank'
		when Isnull(right(cm.cd_tp_cont,1),nome_tp_Carga) = 'Truck' then 'Truck'
		else 'Vessel-Container' end)												[Dispatch],	
	LI.Numero_PO_HIM																[LI],
	TC.nome_tp_carga																[Container],
	org.nome_local																	[Porto de Origem],
	dst.nome_local																	[Porto de Destino],
	ETD_LIM																			[ETD], 
	ATD_LIM																			[ATD], 
	ETA_LIM																			[ETA],
	ata_lim																			[ATA],
	(case when t7.Dt_Conclusao is not null then t7.Dt_Conclusao
		when NF.Data_PO_HIM < t4.Dt_Conclusao then t4.dt_conclusao 
		else NF.Data_PO_HIM end)													[Docs. Deliv],
	datename(month,T4.dt_conclusao)													[Month Clearance],
	Canal_lim																		[Canal],	
	(case when substring(LLP.Num_proc_lim,3,1) = 'R' and business_group_descr is null then 'ROH'
		else business_group_descr end)												[Business Group],
	(case when substring(LLP.Num_proc_lim,3,1) = 'R' and Business_Descr is null then 'ROH'
		else Business_Descr end)													[Business Name],
	Isnull(T13.dt_conclusao,getdate())												[Good Receipt]	
from house_imp_mar HOU With(nolock)
	Join LLP_Imp_MAr LLP With(nolock) on LLP.num_proc_lim=hou.num_proc_him
	Join Localidade ORG With(nolock)  on ORG.cd_local=cd_org_him
	Join Localidade DST With(nolock)  on DST.cd_local=cd_dst_him
	Left Join Pedido_Ship PS With(nolock)  on PS.num_proc=num_proc_lim
	Left Join Produto_Cliente PC With(nolock)  on PC.cd_prod=PS.cd_produto
	Left Join De_ParA_PRoduto DPP With(nolock)  on DPP.gmid=cd_proc_cliente	
	Left Join tarefas_processos T4 With(nolock)  on T4.num_proc=num_proc_lim and t4.ID_Task=4
	Left Join tarefas_processos T15 With(nolock)  on T15.num_proc=num_proc_lim and t15.ID_Task=15
	Left Join tarefas_processos T7 With(nolock)  on T7.num_proc=num_proc_lim and t7.ID_Task=7
	Left Join tarefas_processos T13 With(nolock)  on T13.num_proc=num_proc_lim and t13.ID_Task=13
	Left Join tarefas_processos T10 With(nolock)  on T10.num_proc=num_proc_lim and t10.ID_Task=10
	Join Tipo_Carga TC With(nolock)  on TC.cd_tp_carga=LLP.cd_tp_carga
	Left Join Container_hou_imp_mar CH With(nolock)  on num_proc_lim=CH.num_proc_him
	Left Join Container_mas_imp_mar CM With(nolock)  on CH.num_proc_mim=CM.num_proc_mim and CH.item_cont_im=CM.item_cont_im
	left join tipo_container CC on CM.cd_tp_cont=CC.cd_tp_cont
	Left Join Pedido PD With(nolock)  on PD.cd_pedido=PS.cd_pedido
	Left Join PO_HIM LI With(nolock)  on num_proc_lim=li.num_proc_him and LI.id_dc=23
	Join Pessoa PP With(nolock)  on PP.cd_pes=cd_consig_him
	Left Join PO_HIM NF With(nolock)  on num_proc_lim=NF.num_proc_him and NF.ID_DC=10
Where T4.dt_conclusao is not null
	and substring(num_proc_lim,3,3) = @grupo 
	and T4.dt_conclusao between @DtInicial and @DtFinal


Union ALL

select distinct
	LLP.Num_proc_lio																[Job],
	num_pedido																		[Order Number],
	t10.dt_previsao																	[Planned Goods Issue],
	t10.dt_conclusao																[Actual Goods Issue],		
	(case when cd_tipo = '2' then 'Third' 
			when cd_tipo = '3' then 'Dow-to-Dow'
			else 'Sample' end)														[Order Type],
	(case LLP.tipo_lio when 'T' then 'Rodoviario' else 'Ferroviário' end)			[Modal],	 
	(case LLP.tipo_lio when 'T' then 'Truck' else 'Rail' end)						[Dispatch],
	LI.Numero_PO_Hio																[LI],
	'LCL'																			[Container],
	org.nome_local																	[Porto de Origem],
	dst.nome_local																	[Porto de Destino],
	ETD_LIO																			[ETD], 
	ATD_LIO																			[ATD], 
	ETA_LIO																			[ETA],
	ata_lio																			[ATA],
		(case when t7.Dt_Conclusao is not null then t7.Dt_Conclusao
		when NF.Data_PO_HIo < t4.Dt_Conclusao then t4.dt_conclusao 
		else NF.Data_PO_HIo end)													[Docs. Deliv],
	datename(month,T4.dt_conclusao)													[Month Clearance],
	Canal_lio																		[Canal],
	(case when substring(LLP.Num_proc_lio,3,1) = 'R' and business_group_descr is null then 'ROH'
		else business_group_descr end)												[Business Group],
	(case when substring(LLP.Num_proc_lio,3,1) = 'R' and Business_Descr is null then 'ROH'
		else Business_Descr end)													[Business Name],
	Isnull(T13.dt_conclusao,getdate())												[Good Receipt]
from house_imp_out HOU
	Join LLP_Imp_out LLP with (nolock) on LLP.num_proc_lio=hou.num_proc_hio
	Join Localidade ORG with (nolock)  on ORG.cd_local=cd_org_hio
	Join Localidade DST with (nolock)  on DST.cd_local=cd_dst_hio
	Left Join Pedido_Ship PS with (nolock)  on PS.num_proc=num_proc_lio
	Left Join Produto_Cliente PC with (nolock)  on PC.cd_prod=PS.cd_produto
	Left Join De_ParA_PRoduto DPP with (nolock)  on DPP.gmid=cd_proc_cliente
	Left Join tarefas_processos T4 With(nolock)  on T4.num_proc=num_proc_lio and t4.ID_Task=4
	Left Join tarefas_processos T15 With(nolock)  on T15.num_proc=num_proc_lio and t15.ID_Task=15
	Left Join tarefas_processos T7 With(nolock)  on T7.num_proc=num_proc_lio and t7.ID_Task=7
	Left Join tarefas_processos T13 With(nolock)  on T13.num_proc=num_proc_lio and t13.ID_Task=13
	Left Join tarefas_processos T10 With(nolock)  on T10.num_proc=num_proc_lio and t10.ID_Task=10
	Left Join Pedido PD with (nolock)  on PD.cd_pedido=PS.cd_pedido
	Left Join PO_hio LI with (nolock)  on num_proc_lio=li.num_proc_hio and id_dc=23
	Join Pessoa PP with (nolock)  on PP.cd_pes=cd_consig_hio
	Left Join PO_HIO NF on num_proc_lio=NF.num_proc_hio and NF.ID_DC=10

Where 
--	T4.dt_conclusao is not null
--	and 
	substring(num_proc_lio,3,3) = @grupo 
	and T4.dt_conclusao between @DtInicial and @DtFinal

UNION ALL

select distinct
	LLP.Num_proc_lia																[Job],
	num_pedido																		[Order Number],
	t10.dt_previsao																	[Planned Goods Issue],
	t10.dt_conclusao																[Actual Goods Issue],		
	(case when cd_tipo = '2' then 'Third' 
			when cd_tipo = '3' then 'Dow-to-Dow'
			else 'Sample' end)														[Order Type],
	'Aéreo'																			[Modal],	 
	'Air'																			[Dispatch],	
	LI.Numero_PO_HIA																[LI],
	'LCL'																			[Container],
	org.nome_local																	[Porto de Origem],
	dst.nome_local																	[Porto de Destino],
	ETD_LIA																			[ETD], 
	ATD_LIA																			[ATD], 
	ETA_LIA																			[ETA],
	ata_lia																			[ATA],
	(case when t7.Dt_Conclusao is not null then t7.Dt_Conclusao
		when NF.Data_PO_HIa < t4.Dt_Conclusao then t4.dt_conclusao 
		else NF.Data_PO_HIa end)													[Docs. Deliv],
	datename(month,T4.dt_conclusao)													[Month Clearance],
	Canal_lia																		[Canal],
	(case when substring(LLP.Num_proc_lia,3,1) = 'R' and business_group_descr is null then 'ROH'
		else business_group_descr end)												[Business Group],
	(case when substring(LLP.Num_proc_lia,3,1) = 'R' and Business_Descr is null then 'ROH'
		else Business_Descr end)													[Business Name],
	Isnull(T13.dt_conclusao,getdate())												[Good Receipt]
from house_imp_aer HOU
	Join LLP_Imp_aer LLP with (nolock)  on LLP.num_proc_lia=hou.num_proc_hia
	Join Localidade ORG with (nolock)  on ORG.cd_local=cd_org_hia
	Join Localidade DST with (nolock)  on DST.cd_local=cd_dst_hia
	Left Join Pedido_Ship PS with (nolock)  on PS.num_proc=num_proc_lia
	Left Join Produto_Cliente PC with (nolock)  on PC.cd_prod=PS.cd_produto
	Left Join De_ParA_PRoduto DPP with (nolock)  on DPP.gmid=cd_proc_cliente
	Left Join tarefas_processos T4 With(nolock)  on T4.num_proc=num_proc_lia and t4.ID_Task=4
	Left Join tarefas_processos T15 With(nolock)  on T15.num_proc=num_proc_lia and t15.ID_Task=15
	Left Join tarefas_processos T7 With(nolock)  on T7.num_proc=num_proc_lia and t7.ID_Task=7
	Left Join tarefas_processos T13 With(nolock)  on T13.num_proc=num_proc_lia and t13.ID_Task=13
	Left Join tarefas_processos T10 With(nolock)  on T10.num_proc=num_proc_lia and t10.ID_Task=10
	Left Join Pedido PD with (nolock)  on PD.cd_pedido=PS.cd_pedido
	Left Join PO_hia LI with (nolock)  on num_proc_lia=li.num_proc_hia and id_dc=23
	Join Pessoa PP with (nolock)  on PP.cd_pes=cd_consig_hia
	Left Join PO_HIa NF with (nolock)  on num_proc_lia=NF.num_proc_hia and NF.ID_DC=10
Where 
	substring(num_proc_lia,3,3) = @grupo 
	and T4.dt_conclusao between @DtInicial and @DtFinal
GO
