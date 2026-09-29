SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_MetricsKPI_BDP]'GRUPO FMC','2012-01-01','2012-01-10'
--[spATL_MetricsKPI_BDP]'GRUPO AKZO POLYMER','2012-01-01','2012-01-10'
--[spATL_MetricsKPI_BDP]'GRUPO CONSAGRO','2012-01-01','2012-01-10'

---[spMetricsKPI_BDP]'2012','FMCPG0362'

 
CREATE Procedure [dbo].[spATL_MetricsKPI_BDP]-- '2009'
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
	right(left(LLP.Num_proc_lim,5),3)												[Order Type],
	'Marítimo'																		[Modal],
	(case when Isnull(right(cm.cd_tp_cont,1),nome_tp_Carga) = 'T' then 'Isotank'
		when Isnull(right(cm.cd_tp_cont,1),nome_tp_Carga) = 'Truck' then 'Truck'
		else 'Vessel-Container' end)												[Dispatch],
	dbo.fBusca_TipoDocCliente('N',num_proc_lim,23)									[LI],
	--LI.Numero_PO_HIM																[LI],
	TC.nome_tp_carga																[Container],
	dst.nome_local																	[Destino],
	ata_lim																			[ATA],	
	T4.dt_conclusao																	[Desembaraco],		
	datename(month,T4.dt_conclusao)													[Month Clearance],
	dbo.quantidade_dias(ata_lim,t4.dt_conclusao)									[Diff Days],
	Canal_lim																		[Canal],
	business_group_descr															[Business Group],
	Business_Descr																	[Business Name],
	'NA'																			[Type],
	'NA'																			[Cliente New],
	datediff(day,ATA_Lim,t4.Dt_Conclusao)											[Dias],
	(case when t7.Dt_Conclusao is not null then t7.Dt_Conclusao
		when NF.Data_PO_HIM < t4.Dt_Conclusao then t4.dt_conclusao 
		else NF.Data_PO_HIM end)													[Doc Del. Date],
	datename(month,(case when t7.Dt_Conclusao is not null then t7.Dt_Conclusao
		when NF.Data_PO_HIM < t4.Dt_Conclusao then t4.dt_conclusao 
		else NF.Data_PO_HIM end))													[Month Doc],
	(case when t7.dt_conclusao is not null then datediff(day,ata_lim,t7.dt_conclusao)
		when nf.data_po_him is not null then datediff(day,ata_lim,nf.data_po_him)
		else datediff(day,ATA_Lim,t4.Dt_Conclusao) end)								[Run Days Docs],

	(case when t7.dt_conclusao is not null then dbo.quantidade_dias(ata_lim,t7.dt_conclusao)
		when nf.data_po_him is not null then dbo.quantidade_dias(ata_lim,nf.data_po_him)
		else dbo.quantidade_dias(ATA_Lim,t4.Dt_Conclusao) end)						[Biz Days Docs], 	
	
	Isnull(T13.dt_conclusao,getdate())												[Good Receipt],
	datename(month,Isnull(T13.dt_conclusao,getdate()))								[Month GR],

	(case when datediff(day,ata_lim,T13.dt_conclusao) is null then dbo.quantidade_dias(ata_lim,t4.dt_conclusao)
			when
			datediff(day,ata_lim,T13.dt_conclusao) is not null and (datediff(day,ata_lim,T13.dt_conclusao) > datediff(day,ATA_Lim,t4.Dt_Conclusao)) then datediff(day,ata_lim,T13.dt_conclusao)
			else
			dbo.quantidade_dias(ata_lim,t4.dt_conclusao) end)							[Run Days GR],
	 

	(case when dbo.quantidade_dias(ata_lim,T13.dt_conclusao) is null then dbo.quantidade_dias(ata_lim,t4.dt_conclusao)
		when		
		dbo.quantidade_dias(ata_lim,T13.dt_conclusao) is not null and (dbo.quantidade_dias(ata_lim,T13.dt_conclusao) > dbo.quantidade_dias(ata_lim,t4.dt_conclusao)) then  dbo.quantidade_dias(ata_lim,T13.dt_conclusao)
		else 
		dbo.quantidade_dias(ATA_Lim,t4.Dt_Conclusao) end)					[Biz Days GR],
	t15.dt_conclusao																[Presenca],
	dbo.quantidade_dias(t15.dt_conclusao,t4.dt_conclusao)							[Dias uteis Presenca x Desembaraco],
	DI.Data_PO_Him																	[Registro da DI],
	dbo.quantidade_dias(t15.dt_conclusao,DI.Data_po_him)							[Registro DI x Presenca],
	datediff(day,t15.Dt_Conclusao,DI.Data_PO_Him)									[Dias PC x DI Dias Corridos],
	t40.dt_conclusao																[Prestacao de Contas],
	datediff(day,Isnull(T13.dt_conclusao,getdate()),t40.dt_conclusao)				[Dias GR x Prestacao CC],
	t29.dt_conclusao																[Desova],
	t55.dt_conclusao																[Entrada No Terminal],
	DB.Numero_PO_HIM																[Drawback],
	(case when datediff(day,t29.dt_conclusao,t55.dt_conclusao) is null then 'NA'
		else cast(datediff(day,t29.dt_conclusao,t55.dt_conclusao) as varchar(5))end)[Dias Desova x Entrada no Terminal],

	t7.dt_conclusao																	[Doc para Transporte] ,
	datediff(day,t4.dt_conclusao,t7.dt_conclusao)									[Dias Doc Transporte x Desembaraço],
	CP72.Campo_Dados																[DTA],
	org.nome_local																	[Origem],
	ATD_LIM																			[ATD],
	(case when t79.dt_conclusao is null then FC.Data_PC
		else t79.dt_conclusao end)													[Envio de Draft],
	dta.Data_PO_Him																	[Registro Dta],
	t18.dt_conclusao																[Lib. DTA],	
	t20.dt_conclusao																[Def. LI],

	(case when datediff(day,ata_lim,Isnull(T13.dt_conclusao,getdate())) is null then 'NA'
		else cast(datediff(day,ata_lim,Isnull(T13.dt_conclusao,getdate())) as varchar(5))end)[GR vs ATA],
	(case when datediff(day,ata_lim,t15.dt_conclusao) is null then 'NA'
		else cast(datediff(day,ata_lim,t15.dt_conclusao) as varchar(5))end)			[Presença vs ATA],
	datename(month,t40.dt_conclusao)												[Mth P.C],
	(case when datediff(day,Isnull(T13.dt_conclusao,getdate()),t40.dt_conclusao) is null then 'NA'
		else cast(datediff(day,Isnull(T13.dt_conclusao,getdate()),t40.dt_conclusao) as varchar(5))end)[PC vs GR],
	(case when datediff(day,atd_lim,ata_lim) is null then 'NA'
		else cast(datediff(day,atd_lim,ata_lim) as varchar(5))end)					[ATD vs ATA],
	(case when datediff(day,DI.Data_PO_Him,T4.dt_conclusao) is null then 'NA'
		else cast(datediff(day,DI.Data_PO_Him,T4.dt_conclusao) as varchar(5))end)	[Registro vs Desem],
	(case when datediff(day,t15.dt_conclusao,t20.dt_conclusao) is null then 'NA'
		else cast(datediff(day,t15.dt_conclusao,t20.dt_conclusao) as varchar(5))end)[Presenca vs Def. LI],
	(case when datediff(day,dta.Data_PO_Him,ata_lim) is null then 'NA'
		else cast(datediff(day,dta.Data_PO_Him,ata_lim) as varchar(5))end)			[DTA vs ATA],
	(case when datediff(day,t18.dt_conclusao,dta.Data_PO_Him)	 is null then 'NA'
		else cast(datediff(day,t18.dt_conclusao,dta.Data_PO_Him) as varchar(5))end)	[Lib DTA vs Reg. DTA],
	(case when datediff(day,t55.dt_conclusao,t18.dt_conclusao)	 is null then 'NA'
		else cast(datediff(day,t55.dt_conclusao,t18.dt_conclusao) as varchar(5))end)[Cheg. EADI vs Lib. DTA],
	(case when datediff(day,t20.dt_conclusao,DI.Data_PO_Him)	 is null then 'NA'
		else cast(datediff(day,t20.dt_conclusao,DI.Data_PO_Him) as varchar(5))end)	[Registro DI vs Def. LI],
	[dbo].[fBusca_PRODUTO] (num_proc_lim)											[Produto],
	(case when datediff(day,ata_lim,Isnull(T13.dt_conclusao,getdate())) is null then 'NA'
		else cast(datediff(day,ata_lim,Isnull(T13.dt_conclusao,getdate())) as varchar(5))end)[Docs Del. vs ATA],
	(case when datediff(day,t7.dt_conclusao,Isnull(T13.dt_conclusao,getdate())) is null then 'NA'
		else cast(datediff(day,t7.dt_conclusao,Isnull(T13.dt_conclusao,getdate())) as varchar(5))end)[Docs Del. vs GR],
	dbo.quantidade_dias(t7.dt_conclusao,t40.dt_conclusao)							[Prest.Contas vs Docs. Deliv],
	(case when datediff(day,T4.dt_conclusao,t40.dt_conclusao) is null then 'NA'
		else cast(datediff(day,T4.dt_conclusao,t40.dt_conclusao) as varchar(5))end)	[Prest.Contas vs Desemb.]

from house_imp_mar HOU		With(nolock)
	Join LLP_Imp_MAr LLP	With(nolock) on LLP.num_proc_lim=hou.num_proc_him
	Join Localidade ORG		With(nolock) on ORG.cd_local=cd_org_him
	Join Localidade DST		With(nolock) on DST.cd_local=cd_dst_him
	Left Join Pedido_Ship PS With(nolock) on PS.num_proc=num_proc_lim
	Left Join Produto_Cliente PC With(nolock) on PC.cd_prod=PS.cd_produto
	Left Join De_ParA_PRoduto DPP With(nolock) on DPP.gmid=cd_proc_cliente	
	Join Tipo_Carga TC With(nolock) on TC.cd_tp_carga=LLP.cd_tp_carga
	Left Join Container_hou_imp_mar CH With(nolock) on num_proc_lim=CH.num_proc_him
	Left Join Container_mas_imp_mar CM With(nolock) on CH.num_proc_mim=CM.num_proc_mim and CH.item_cont_im=CM.item_cont_im
	Left Join Pedido PD With(nolock) on PD.cd_pedido=PS.cd_pedido	
	Join Pessoa PP With(nolock) on PP.cd_pes=cd_consig_him
	Left Join PO_HIM DI With(nolock) on num_proc_lim=DI.num_proc_him and DI.ID_DC=5
	Left Join PO_HIM NF With(nolock) on num_proc_lim=NF.num_proc_him and NF.ID_DC=10
	Left Join PO_HIM LI With(nolock)  on num_proc_lim=li.num_proc_him and LI.id_dc=23	
	Left Join PO_HIM DB With(nolock) on num_proc_lim=DB.num_proc_him and DB.ID_DC=24	
	Left Join PO_HIM DTA With(nolock)  on num_proc_lim=dta.num_proc_him and dta.id_dc=45
	Left Join tarefas_processos T4 With(nolock)  on T4.num_proc=num_proc_lim and t4.ID_Task=4
	Left Join tarefas_processos T7 With(nolock)  on T7.num_proc=num_proc_lim and t7.ID_Task=7
	Left Join tarefas_processos T10 With(nolock)  on T10.num_proc=num_proc_lim and t10.ID_Task=10
	Left Join tarefas_processos T13 With(nolock)  on T13.num_proc=num_proc_lim and t13.ID_Task=13
	Left Join tarefas_processos T15 With(nolock)  on T15.num_proc=num_proc_lim and t15.ID_Task=15
	Left Join tarefas_processos T18 With(nolock)  on T18.num_proc=num_proc_lim and t18.ID_Task=18
	Left Join tarefas_processos T20 With(nolock)  on T20.num_proc=num_proc_lim and t20.ID_Task=20
	Left Join tarefas_processos T29 With(nolock)  on T29.num_proc=num_proc_lim and t29.ID_Task=29
	Left Join tarefas_processos T40 With(nolock)  on T40.num_proc=num_proc_lim and t40.ID_Task=40
	Left Join tarefas_processos T55 With(nolock)  on T55.num_proc=num_proc_lim and t55.ID_Task=55	
	Left Join tarefas_processos T56 With(nolock)  on T56.num_proc=num_proc_lim and t56.ID_Task=56	
	Left Join tarefas_processos T79 With(nolock)  on T79.num_proc=num_proc_lim and t79.ID_Task=79	
	Left Join campo_processo CP72 With(nolock)  on CP72.num_proc=num_proc_lim and CP72.ID_campo=72
	left join Fatura_Chb FC with(nolock) on FC.Processo_pc = num_proc_lim and status_pc = 'E'
Where T4.dt_conclusao is not null
	and substring(num_proc_lim,3,3) = @grupo 
	and T4.dt_conclusao between @DtInicial and @DtFinal

UNION ALL

	select distinct
	LLP.Num_proc_lio																[Job],
	num_pedido																		[Order Number],
	right(left(LLP.Num_proc_lio,5),3)												[Order Type],
	'Rodoviario'																	[Modal],
	'Truck'																			[Dispatch],
	dbo.fBusca_TipoDocCliente('N',num_proc_lio,23)									[LI],
	--LI.Numero_PO_HIM																[LI],
	'LCL'																			[Container],
	dst.nome_local																	[Destino],
	ata_lio																			[ATA],	
	T4.dt_conclusao																	[Desembaraco],		
	datename(month,T4.dt_conclusao)													[Month Clearance],
	dbo.quantidade_dias(ata_lio,t4.dt_conclusao)									[Diff Days],
	Canal_lio																		[Canal],
	business_group_descr															[Business Group],
	Business_Descr																	[Business Name],
	'NA'																			[Type],
	'NA'																			[Cliente New],
	datediff(day,ATA_Lio,t4.Dt_Conclusao)											[Dias],
	(case when t7.Dt_Conclusao is not null then t7.Dt_Conclusao
		when NF.Data_PO_HIO < t4.Dt_Conclusao then t4.dt_conclusao 
		else NF.Data_PO_HIO end)													[Doc Del. Date],
	datename(month,(case when t7.Dt_Conclusao is not null then t7.Dt_Conclusao
		when NF.Data_PO_HIO < t4.Dt_Conclusao then t4.dt_conclusao 
		else NF.Data_PO_HIO end))													[Month Doc],
	(case when t7.dt_conclusao is not null then datediff(day,ata_lio,t7.dt_conclusao)
		when nf.data_po_hio is not null then datediff(day,ata_lio,nf.data_po_hio)
		else datediff(day,ATA_Lio,t4.Dt_Conclusao) end)								[Run Days Docs],

	(case when t7.dt_conclusao is not null then dbo.quantidade_dias(ata_lio,t7.dt_conclusao)
		when nf.data_po_hio is not null then dbo.quantidade_dias(ata_lio,nf.data_po_hio)
		else dbo.quantidade_dias(ATA_Lio,t4.Dt_Conclusao) end)						[Biz Days Docs], 	
	
	Isnull(T13.dt_conclusao,getdate())												[Good Receipt],
	datename(month,Isnull(T13.dt_conclusao,getdate()))								[Month GR],

	(case when datediff(day,ata_lio,T13.dt_conclusao) is null then dbo.quantidade_dias(ata_lio,t4.dt_conclusao)
			when
			datediff(day,ata_lio,T13.dt_conclusao) is not null and (datediff(day,ata_lio,T13.dt_conclusao) > datediff(day,ATA_Lio,t4.Dt_Conclusao)) then datediff(day,ata_lio,T13.dt_conclusao)
			else
			dbo.quantidade_dias(ata_lio,t4.dt_conclusao) end)							[Run Days GR],
	 

	(case when dbo.quantidade_dias(ata_lio,T13.dt_conclusao) is null then dbo.quantidade_dias(ata_lio,t4.dt_conclusao)
		when		
		dbo.quantidade_dias(ata_lio,T13.dt_conclusao) is not null and (dbo.quantidade_dias(ata_lio,T13.dt_conclusao) > dbo.quantidade_dias(ata_lio,t4.dt_conclusao)) then  dbo.quantidade_dias(ata_lio,T13.dt_conclusao)
		else 
		dbo.quantidade_dias(ATA_Lio,t4.Dt_Conclusao) end)					[Biz Days GR],
	t15.dt_conclusao																[Presenca],
	dbo.quantidade_dias(t15.dt_conclusao,t4.dt_conclusao)							[Dias uteis Presenca x Desembaraco],
	DI.Data_PO_Hio																	[Registro da DI],	
	dbo.quantidade_dias(t15.dt_conclusao,DI.Data_po_hio)							[Registro DI x Presenca],
	datediff(day,t15.Dt_Conclusao,DI.Data_PO_Hio)									[Dias PC x DI Dias Corridos],
	t40.dt_conclusao																[Prestacao de Contas],
	datediff(day,Isnull(T13.dt_conclusao,getdate()),t40.dt_conclusao)				[Dias GR x Prestacao CC],
	t29.dt_conclusao																[Desova],
	t55.dt_conclusao																[Entrada No Terminal],
	DB.Numero_PO_HIo																[Drawback],
	(case when datediff(day,t29.dt_conclusao,t55.dt_conclusao) is null then 'NA'
		else cast(datediff(day,t29.dt_conclusao,t55.dt_conclusao) as varchar(5))end)[Dias Desova x Entrada no Terminal],

	t7.dt_conclusao																	[Doc para Transporte] ,
	datediff(day,t4.dt_conclusao,t7.dt_conclusao)									[Dias Doc Transporte x Desembaraço],
	CP72.Campo_Dados																[DTA],
	org.nome_local																	[Origem],
	ATD_LIo																			[ATD],
	(case when t79.dt_conclusao is null then FC.Data_PC
		else t79.dt_conclusao end)													[Envio de Draft],
	dta.Data_PO_Hio																	[Registro Dta],
	t18.dt_conclusao																[Lib. DTA],	
	t20.dt_conclusao																[Def. LI],
	(case when datediff(day,ata_lio,Isnull(T13.dt_conclusao,getdate())) is null then 'NA'
		else cast(datediff(day,ata_lio,Isnull(T13.dt_conclusao,getdate())) as varchar(5))end)[GR vs ATA],
	(case when datediff(day,ata_lio,t15.dt_conclusao) is null then 'NA'
		else cast(datediff(day,ata_lio,t15.dt_conclusao) as varchar(5))end)			[Presença vs ATA],
	datename(month,t40.dt_conclusao)												[Mth P.C],
	(case when datediff(day,Isnull(T13.dt_conclusao,getdate()),t40.dt_conclusao) is null then 'NA'
		else cast(datediff(day,Isnull(T13.dt_conclusao,getdate()),t40.dt_conclusao) as varchar(5))end)[PC vs GR],
	(case when datediff(day,atd_lio,ata_lio) is null then 'NA'
		else cast(datediff(day,atd_lio,ata_lio) as varchar(5))end)					[ATD vs ATA],
	(case when datediff(day,DI.Data_PO_Hio,T4.dt_conclusao) is null then 'NA'
		else cast(datediff(day,DI.Data_PO_Hio,T4.dt_conclusao) as varchar(5))end)	[Registro vs Desem],
	(case when datediff(day,t15.dt_conclusao,t20.dt_conclusao) is null then 'NA'
		else cast(datediff(day,t15.dt_conclusao,t20.dt_conclusao) as varchar(5))end)[Presenca vs Def. LI],
	(case when datediff(day,dta.Data_PO_Hio,ata_lio) is null then 'NA'
		else cast(datediff(day,dta.Data_PO_Hio,ata_lio) as varchar(5))end)			[DTA vs ATA],
	(case when datediff(day,t18.dt_conclusao,dta.Data_PO_Hio)	 is null then 'NA'
		else cast(datediff(day,t18.dt_conclusao,dta.Data_PO_Hio) as varchar(5))end)	[Lib DTA vs Reg. DTA],
	(case when datediff(day,t55.dt_conclusao,t18.dt_conclusao)	 is null then 'NA'
		else cast(datediff(day,t55.dt_conclusao,t18.dt_conclusao) as varchar(5))end)[Cheg. EADI vs Lib. DTA],
	(case when datediff(day,t20.dt_conclusao,DI.Data_PO_Hio)	 is null then 'NA'
		else cast(datediff(day,t20.dt_conclusao,DI.Data_PO_Hio) as varchar(5))end)	[Registro DI vs Def. LI],
	[dbo].[fBusca_PRODUTO] (num_proc_lio)											[Produto],	
		(case when datediff(day,ata_lio,Isnull(T13.dt_conclusao,getdate())) is null then 'NA'
		else cast(datediff(day,ata_lio,Isnull(T13.dt_conclusao,getdate())) as varchar(5))end)[Docs Del. vs ATA],
	(case when datediff(day,t7.dt_conclusao,Isnull(T13.dt_conclusao,getdate())) is null then 'NA'
		else cast(datediff(day,t7.dt_conclusao,Isnull(T13.dt_conclusao,getdate())) as varchar(5))end)[Docs Del. vs GR],
	dbo.quantidade_dias(t7.dt_conclusao,t40.dt_conclusao)							[Prest.Contas vs Docs. Deliv],
	(case when datediff(day,T4.dt_conclusao,t40.dt_conclusao) is null then 'NA'
		else cast(datediff(day,T4.dt_conclusao,t40.dt_conclusao) as varchar(5))end)	[Prest.Contas vs Desemb.]
from house_imp_out HOU With(nolock)
	Join LLP_Imp_out LLP With(nolock) on LLP.num_proc_lio=hou.num_proc_hio
	Join Localidade ORG With(nolock) on ORG.cd_local=cd_org_hio
	Join Localidade DST With(nolock) on DST.cd_local=cd_dst_hio
	Left Join Pedido_Ship PS With(nolock) on PS.num_proc=num_proc_lio
	Left Join Produto_Cliente PC With(nolock) on PC.cd_prod=PS.cd_produto
	Left Join De_ParA_PRoduto DPP With(nolock) on DPP.gmid=cd_proc_cliente
	Left Join Pedido PD With(nolock) on PD.cd_pedido=PS.cd_pedido
	Join Pessoa PP With(nolock) on PP.cd_pes=cd_consig_hio		
	Left Join PO_HIo DI With(nolock) on num_proc_lio=DI.num_proc_hio and DI.ID_DC=5
	Left Join PO_HIo NF With(nolock) on num_proc_lio=NF.num_proc_hio and NF.ID_DC=10
--	Left Join PO_HIM LI With(nolock)  on num_proc_lim=li.num_proc_him and LI.id_dc=23	
	Left Join PO_HIo DB With(nolock) on num_proc_lio=DB.num_proc_hio and DB.ID_DC=24	
	Left Join PO_HIo DTA With(nolock)  on num_proc_lio=dta.num_proc_hio and dta.id_dc=45
	Left Join tarefas_processos T4 With(nolock)  on T4.num_proc=num_proc_lio and t4.ID_Task=4
	Left Join tarefas_processos T7 With(nolock)  on T7.num_proc=num_proc_lio and t7.ID_Task=7
	Left Join tarefas_processos T10 With(nolock)  on T10.num_proc=num_proc_lio and t10.ID_Task=10
	Left Join tarefas_processos T13 With(nolock)  on T13.num_proc=num_proc_lio and t13.ID_Task=13
	Left Join tarefas_processos T15 With(nolock)  on T15.num_proc=num_proc_lio and t15.ID_Task=15
	Left Join tarefas_processos T18 With(nolock)  on T18.num_proc=num_proc_lio and t18.ID_Task=18
	Left Join tarefas_processos T20 With(nolock)  on T20.num_proc=num_proc_lio and t20.ID_Task=20
	Left Join tarefas_processos T29 With(nolock)  on T29.num_proc=num_proc_lio and t29.ID_Task=29
	Left Join tarefas_processos T40 With(nolock)  on T40.num_proc=num_proc_lio and t40.ID_Task=40
	Left Join tarefas_processos T55 With(nolock)  on T55.num_proc=num_proc_lio and t55.ID_Task=55	
	Left Join tarefas_processos T56 With(nolock)  on T56.num_proc=num_proc_lio and t56.ID_Task=56	
	Left Join tarefas_processos T79 With(nolock)  on T79.num_proc=num_proc_lio and t79.ID_Task=79	
	Left Join campo_processo CP72 With(nolock)  on CP72.num_proc=num_proc_lio and CP72.ID_campo=72
	left join Fatura_Chb FC with(nolock) on FC.Processo_pc = num_proc_lio and status_pc = 'E'
Where T4.dt_conclusao is not null
	and substring(num_proc_lio,3,3) = @grupo 
	and T4.dt_conclusao between @DtInicial and @DtFinal


UNION ALL

select distinct
	LLP.Num_proc_lia																[Job],
	num_pedido																		[Order Number],
	right(left(LLP.Num_proc_lia,5),3)												[Order Type],
	'Aéreo'																			[Modal],
	'Air'																			[Dispatch],
	dbo.fBusca_TipoDocCliente('N',num_proc_lia,23)									[LI],
	--LI.Numero_PO_HIM																[LI],
	'LCL'																			[Container],
	dst.nome_local																	[Destino],
	ata_lia																			[ATA],	
	T4.dt_conclusao																	[Desembaraco],		
	datename(month,T4.dt_conclusao)													[Month Clearance],
	dbo.quantidade_dias(ata_lia,t4.dt_conclusao)									[Diff Days],
	Canal_lia																		[Canal],
	business_group_descr															[Business Group],
	Business_Descr																	[Business Name],
	'NA'																			[Type],
	'NA'																			[Cliente New],
	datediff(day,ATA_Lia,t4.Dt_Conclusao)											[Dias],
	(case when t7.Dt_Conclusao is not null then t7.Dt_Conclusao
		when NF.Data_PO_HIa < t4.Dt_Conclusao then t4.dt_conclusao 
		else NF.Data_PO_HIa end)													[Doc Del. Date],
	datename(month,(case when t7.Dt_Conclusao is not null then t7.Dt_Conclusao
		when NF.Data_PO_HIa < t4.Dt_Conclusao then t4.dt_conclusao 
		else NF.Data_PO_HIa end))													[Month Doc],
	(case when t7.dt_conclusao is not null then datediff(day,ata_lia,t7.dt_conclusao)
		when nf.data_po_hia is not null then datediff(day,ata_lia,nf.data_po_hia)
		else datediff(day,ATA_Lia,t4.Dt_Conclusao) end)								[Run Days Docs],

	(case when t7.dt_conclusao is not null then dbo.quantidade_dias(ata_lia,t7.dt_conclusao)
		when nf.data_po_hia is not null then dbo.quantidade_dias(ata_lia,nf.data_po_hia)
		else dbo.quantidade_dias(ATA_Lia,t4.Dt_Conclusao) end)						[Biz Days Docs], 	
	
	Isnull(T13.dt_conclusao,getdate())												[Good Receipt],
	datename(month,Isnull(T13.dt_conclusao,getdate()))								[Month GR],

	(case when datediff(day,ata_lia,T13.dt_conclusao) is null then dbo.quantidade_dias(ata_lia,t4.dt_conclusao)
			when
			datediff(day,ata_lia,T13.dt_conclusao) is not null and (datediff(day,ata_lia,T13.dt_conclusao) > datediff(day,ATA_Lia,t4.Dt_Conclusao)) then datediff(day,ata_lia,T13.dt_conclusao)
			else
			dbo.quantidade_dias(ata_lia,t4.dt_conclusao) end)							[Run Days GR],
	 

	(case when dbo.quantidade_dias(ata_lia,T13.dt_conclusao) is null then dbo.quantidade_dias(ata_lia,t4.dt_conclusao)
		when		
		dbo.quantidade_dias(ata_lia,T13.dt_conclusao) is not null and (dbo.quantidade_dias(ata_lia,T13.dt_conclusao) > dbo.quantidade_dias(ata_lia,t4.dt_conclusao)) then  dbo.quantidade_dias(ata_lia,T13.dt_conclusao)
		else 
		dbo.quantidade_dias(ATA_Lia,t4.Dt_Conclusao) end)					[Biz Days GR],
	t15.dt_conclusao																[Presenca],
	dbo.quantidade_dias(t15.dt_conclusao,t4.dt_conclusao)							[Dias uteis Presenca x Desembaraco],
	DI.Data_PO_Hia																	[Registro da DI],	
	dbo.quantidade_dias(t15.dt_conclusao,DI.Data_po_hia)							[Registro DI x Presenca],
	datediff(day,t15.Dt_Conclusao,DI.Data_PO_Hia)									[Dias PC x DI Dias Corridos],
	t40.dt_conclusao																[Prestacao de Contas],
	datediff(day,Isnull(T13.dt_conclusao,getdate()),t40.dt_conclusao)				[Dias GR x Prestacao CC],
	t29.dt_conclusao																[Desova],
	t55.dt_conclusao																[Entrada No Terminal],
	DB.Numero_PO_HIa																[Drawback],
	(case when datediff(day,t29.dt_conclusao,t55.dt_conclusao) is null then 'NA'
		else cast(datediff(day,t29.dt_conclusao,t55.dt_conclusao) as varchar(5))end)[Dias Desova x Entrada no Terminal],
	
	t7.dt_conclusao																	[Doc para Transporte] ,
	datediff(day,t4.dt_conclusao,t7.dt_conclusao)									[Dias Doc Transporte x Desembaraço],
	CP72.Campo_Dados																[DTA],
	org.nome_local																	[Origem],
	ATD_LIa																			[ATD],
	(case when t79.dt_conclusao is null then FC.Data_PC
		else t79.dt_conclusao end)													[Envio de Draft],
	dta.Data_PO_Hia																	[Registro Dta],
	t18.dt_conclusao																[Lib. DTA],	
	t20.dt_conclusao																[Def. LI],
	(case when datediff(day,ata_lia,Isnull(T13.dt_conclusao,getdate())) is null then 'NA'
		else cast(datediff(day,ata_lia,Isnull(T13.dt_conclusao,getdate())) as varchar(5))end)[GR vs ATA],
	(case when datediff(day,ata_lia,t15.dt_conclusao) is null then 'NA'
		else cast(datediff(day,ata_lia,t15.dt_conclusao) as varchar(5))end)			[Presença vs ATA],
	datename(month,t40.dt_conclusao)												[Mth P.C],
	(case when datediff(day,Isnull(T13.dt_conclusao,getdate()),t40.dt_conclusao) is null then 'NA'
		else cast(datediff(day,Isnull(T13.dt_conclusao,getdate()),t40.dt_conclusao) as varchar(5))end)[PC vs GR],
	(case when datediff(day,atd_lia,ata_lia) is null then 'NA'
		else cast(datediff(day,atd_lia,ata_lia) as varchar(5))end)					[ATD vs ATA],
	(case when datediff(day,DI.Data_PO_Hia,T4.dt_conclusao) is null then 'NA'
		else cast(datediff(day,DI.Data_PO_Hia,T4.dt_conclusao) as varchar(5))end)	[Registro vs Desem],
	(case when datediff(day,t15.dt_conclusao,t20.dt_conclusao) is null then 'NA'
		else cast(datediff(day,t15.dt_conclusao,t20.dt_conclusao) as varchar(5))end)[Presenca vs Def. LI],
	(case when datediff(day,dta.Data_PO_Hia,ata_lia) is null then 'NA'
		else cast(datediff(day,dta.Data_PO_Hia,ata_lia) as varchar(5))end)			[DTA vs ATA],
	(case when datediff(day,t18.dt_conclusao,dta.Data_PO_Hia)	 is null then 'NA'
		else cast(datediff(day,t18.dt_conclusao,dta.Data_PO_Hia) as varchar(5))end)	[Lib DTA vs Reg. DTA],
	(case when datediff(day,t55.dt_conclusao,t18.dt_conclusao)	 is null then 'NA'
		else cast(datediff(day,t55.dt_conclusao,t18.dt_conclusao) as varchar(5))end)[Cheg. EADI vs Lib. DTA],
	(case when datediff(day,t20.dt_conclusao,DI.Data_PO_Hia)	 is null then 'NA'
		else cast(datediff(day,t20.dt_conclusao,DI.Data_PO_Hia) as varchar(5))end)	[Registro DI vs Def. LI],
	[dbo].[fBusca_PRODUTO] (num_proc_lia)											[Produto],	
	(case when datediff(day,ata_lia,Isnull(T13.dt_conclusao,getdate())) is null then 'NA'
		else cast(datediff(day,ata_lia,Isnull(T13.dt_conclusao,getdate())) as varchar(5))end)[Docs Del. vs ATA],
	(case when datediff(day,t7.dt_conclusao,Isnull(T13.dt_conclusao,getdate())) is null then 'NA'
		else cast(datediff(day,t7.dt_conclusao,Isnull(T13.dt_conclusao,getdate())) as varchar(5))end)[Docs Del. vs GR],
	dbo.quantidade_dias(t7.dt_conclusao,t40.dt_conclusao)							[Prest.Contas vs Docs. Deliv],
	(case when datediff(day,T4.dt_conclusao,t40.dt_conclusao) is null then 'NA'
		else cast(datediff(day,T4.dt_conclusao,t40.dt_conclusao) as varchar(5))end)	[Prest.Contas vs Desemb.]
from house_imp_aer HOU With(nolock)
	Join LLP_Imp_aer LLP With(nolock) on LLP.num_proc_lia=hou.num_proc_hia
	Join Localidade ORG With(nolock) on ORG.cd_local=cd_org_hia
	Join Localidade DST With(nolock) on DST.cd_local=cd_dst_hia
	Left Join Pedido_Ship PS With(nolock) on PS.num_proc=num_proc_lia
	Left Join Produto_Cliente PC With(nolock) on PC.cd_prod=PS.cd_produto
	Left Join De_ParA_PRoduto DPP With(nolock) on DPP.gmid=cd_proc_cliente
	Left Join Pedido PD With(nolock) on PD.cd_pedido=PS.cd_pedido
	Join Pessoa PP With(nolock) on PP.cd_pes=cd_consig_hia		
	Left Join PO_HIa DI With(nolock) on num_proc_lia=DI.num_proc_hia and DI.ID_DC=5
	Left Join PO_HIa NF With(nolock) on num_proc_lia=NF.num_proc_hia and NF.ID_DC=10
--	Left Join PO_HIM LI With(nolock)  on num_proc_lim=li.num_proc_him and LI.id_dc=23	
	Left Join PO_HIa DB With(nolock) on num_proc_lia=DB.num_proc_hia and DB.ID_DC=24	
	Left Join PO_HIa DTA With(nolock)  on num_proc_lia=dta.num_proc_hia and dta.id_dc=45
	Left Join tarefas_processos T4 With(nolock)  on T4.num_proc=num_proc_lia and t4.ID_Task=4
	Left Join tarefas_processos T7 With(nolock)  on T7.num_proc=num_proc_lia and t7.ID_Task=7
	Left Join tarefas_processos T10 With(nolock)  on T10.num_proc=num_proc_lia and t10.ID_Task=10
	Left Join tarefas_processos T13 With(nolock)  on T13.num_proc=num_proc_lia and t13.ID_Task=13
	Left Join tarefas_processos T15 With(nolock)  on T15.num_proc=num_proc_lia and t15.ID_Task=15
	Left Join tarefas_processos T18 With(nolock)  on T18.num_proc=num_proc_lia and t18.ID_Task=18
	Left Join tarefas_processos T20 With(nolock)  on T20.num_proc=num_proc_lia and t20.ID_Task=20
	Left Join tarefas_processos T29 With(nolock)  on T29.num_proc=num_proc_lia and t29.ID_Task=29
	Left Join tarefas_processos T40 With(nolock)  on T40.num_proc=num_proc_lia and t40.ID_Task=40
	Left Join tarefas_processos T55 With(nolock)  on T55.num_proc=num_proc_lia and t55.ID_Task=55	
	Left Join tarefas_processos T56 With(nolock)  on T56.num_proc=num_proc_lia and t56.ID_Task=56	
	Left Join tarefas_processos T79 With(nolock)  on T79.num_proc=num_proc_lia and t79.ID_Task=79	
	Left Join campo_processo CP72 With(nolock)  on CP72.num_proc=num_proc_lia and CP72.ID_campo=72
	left join Fatura_Chb FC with(nolock) on FC.Processo_pc = num_proc_lia and status_pc = 'E'
Where T4.dt_conclusao is not null
	and substring(num_proc_lia,3,3) = @grupo 
	and T4.dt_conclusao between @DtInicial and @DtFinal
--

GO
