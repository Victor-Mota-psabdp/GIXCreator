SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_ProductCosts_Por_JOB_EM_Rel]'EAAMZ201603001BR'
--[spATL_ProductCosts_Por_JOB_EM_Rel]'GRUPO AMAZONAS', '2017-11-01', '2017-11-30'
Create Procedure [dbo].[spATL_ProductCosts_Por_JOB_EM_Rel_Test]--'GRUPO AMAZONAS', '2017-11-01', '2017-11-30'
(
	@JOB	varchar(16),
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime	
)
AS

	declare @TAB table
	(
		[DATA DE DESEMBARAÇO]			Datetime,
		[SALES ORDER]					varchar(1000),
		[SHIPPER]						varchar(60),
		[CNPJ]							varchar(20),
		[CONSIGNEE]						varchar(60),		
		[INCOTERM]						varchar(50),
		[ORIGIN]						varchar(50),
		[DESTINATION]					varchar(50),
		[TIPO DE FRETE]					varchar(50),
		[DATA DE EMBARQUE]				Datetime,		
		[VALOR DA INVOICE]				varchar(50),
		[VALOR DO FRETE]				varchar(50),
		[MOEDA DO FRETE]				varchar(50),
		[CERTIFICADO DE ORIGEM (CUSTO FIESP)] float,
		[CARTA DE CRÉDITO]				float,
		[CONSULARIZAÇÃO]				float,
		[SEGURO]						float,
		[LIBERAÇÃO BL]					float,
		[CORREÇÃO BL]					float,
		[ISPS]							float,
		[ARMAZENAGEM]					float,
		[CAPATAZIA (THC)]				float,
		[POSICIONAMENTO]				float,
		[MOTOBOY]						float,
		[COURIER]						float,
		[CUSTOS DE DESEMBARAÇO (BDP)]	float,
		[GESTÃO DE EXPORTAÇÃO (BDP)]	float,
		[EMISSÃO DE DOCUMENTOS (BDP)]	float,
		[EMISSÃO DO COO (BDP)]			float,
		[EMISSÃO DO RE (BDP)]			float,
		[TOTAL DAS DESPESAS + SERVIÇOS BDP]	float,
		[INSPEÇÃO NÃO INVASIVA]			float,
		[VALOR DOS ACRÉSCIMOS (DI)]		float,
		[OUTROS CUSTOS DO PROCESSO]		float,
		[CUSTOS LOGÍSTICOS TOTAIS]		float,
		[BDP Job]						char(16),	
		
		[Total Custos]					float,			
		
		CD_Pedido			int, 
		Cd_Produto			int,
		[RE Number]			varchar(1000)
		
		
	)

	Declare @Cd_Grupo as varchar(10)
	Set @Cd_Grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)

	Begin
		insert into
			@TAB ([BDP Job],CD_Pedido,Cd_Produto,
			[SALES ORDER],[SHIPPER],[Consignee],[CNPJ],[Incoterm],
			[ORIGIN],[DESTINATION],
			[TIPO DE FRETE],[DATA DE DESEMBARAÇO],			
			[RE Number],[DATA DE EMBARQUE],[VALOR DA INVOICE],
			[VALOR DO FRETE],[MOEDA DO FRETE]			
			)
		select distinct
			HOU.Num_Proc_HeM,PS.CD_Pedido,PS.Cd_Produto,dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_Hem,'3'),
			SHP.Nome_Raz_Soc,CNS.Nome_Raz_Soc,SHP.Num_CPF_CNPJ,HOU.cd_tp_oper,ORG.Nome_Local,DST.Nome_Local,
			(Case when HOU.Tp_Frete_HeM ='P' then 'Prepaid' else 'Collect' end),
			dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc_Hem,'4'),dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_Hem,'4'),
			ETA_Lem,LLP.Cd_Moeda_Invoice + ' ' + CONVERT(varchar(25), LLP.vlr_Invoice),
			HOU.Cd_Tp_Moeda + ' ' + CONVERT(varchar(25), HOU.Vlr_Frete_Tot_HEM),MOE.Nome_Tp_Moeda
		from
			House_EXP_Mar HOU with(nolock)
			join llp_Exp_mar LLP with(nolock) on LLP.num_proc_lem = HOU.num_proc_hem
			join pessoa CNS with(nolock) on CNS.cd_pes = HOU.Cd_Consig_HEM
			join Pessoa	SHP	with(nolock) on SHP.cd_pes = HOU.Cd_Export_HEM			
			left JOIN Localidade ORG with(nolock) on HOU.Cd_Org_HEM	= ORG.cd_local
			left JOIN Localidade DST with(nolock) on HOU.Cd_Dst_Hem	= DST.cd_local
			join pessoa_LLP GR with(nolock) on GR.cd_pes = HOU.Cd_Export_HEM and GR.cd_pes_grupo = @Cd_Grupo
			join Pedido_Ship PS with(nolock) on HOU.Num_Proc_HEM = PS.num_proc
			left join Tipo_Moeda MOE  with(nolock) on MOE.Cd_Tp_Moeda = HOU.Cd_Tp_Moeda	
			join Tarefas_Processos TP40 with(nolock) on HOU.Num_Proc_HEM = TP40.num_proc --and TP40.id_task = 76	
		where
			HOU.Num_Proc_Hem = @JOB	and
			TP40.dt_conclusao between @DtInicial and @DtFinal
			--and LLP.Id_status = 8	
		
	UNION ALL
		select distinct 
			HOU.Num_Proc_HEA,PS.CD_Pedido,PS.Cd_Produto,dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HeA,'3'),
			SHP.Nome_Raz_Soc,CNS.Nome_Raz_Soc,SHP.Num_CPF_CNPJ,HOU.cd_tp_oper,ORG.Nome_Local,DST.Nome_Local,
			(Case when HOU.Tp_Frete_HEA ='P' then 'Prepaid' else 'Collect' end),
			dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc_HeA,'4'),dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HeA,'4'),
			ETA_Lea,LLP.Cd_Moeda_Invoice + ' ' + CONVERT(varchar(25), LLP.vlr_Invoice),
			HOU.Cd_Tp_Moeda + ' ' + CONVERT(varchar(25),HOU.Vlr_Frete_Tot_HEA),MOE.Nome_Tp_Moeda
		from
			House_exP_aer HOU with(nolock)
			join llp_exp_aer LLP with(nolock) on LLP.num_proc_lea = HOU.num_proc_hea
			join pessoa CNS with(nolock) on CNS.cd_pes = HOU.cd_consig_hea
			join Pessoa	SHP	with(nolock) on SHP.cd_pes = HOU.Cd_Export_HeA			
			left JOIN Localidade ORG with(nolock) on HOU.Cd_Org_HeA	= ORG.cd_local
			left JOIN Localidade DST with(nolock) on HOU.Cd_Dst_HeA	= DST.cd_local			
			join pessoa_LLP GR with(nolock) on GR.cd_pes = HOU.Cd_Export_HEA and GR.cd_pes_grupo = @Cd_Grupo
			join Pedido_Ship PS with(nolock) on HOU.num_proc_hea = PS.num_proc		
			left join Tipo_Moeda MOE  with(nolock) on MOE.Cd_Tp_Moeda = HOU.Cd_Tp_Moeda
			join Tarefas_Processos TP40 with(nolock) on HOU.num_proc_hea = TP40.num_proc --and TP40.id_task = 76
		where
			HOU.Num_Proc_HeA = @JOB and	
			TP40.dt_conclusao between @DtInicial and @DtFinal
			--and LLP.Id_status = 8
	UNION ALL
		select distinct 
			HOU.Num_Proc_HEO,PS.CD_Pedido,PS.Cd_Produto,dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEO,'3'),
			SHP.Nome_Raz_Soc,CNS.Nome_Raz_Soc,SHP.Num_CPF_CNPJ, HOU.cd_tp_oper,	ORG.Nome_Local,DST.Nome_Local,
			(Case when HOU.Tp_Frete_HEO ='P' then 'Prepaid' else 'Collect' end),
			dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc_HEO,'4'),dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HEO,'4'),
			ATA_Leo,LLP.Cd_Moeda_Invoice + ' ' + CONVERT(varchar(25),LLP.vlr_Invoice),
			HOU.Cd_Tp_Moeda + ' ' + CONVERT(varchar(25),HOU.Vlr_Frete_Efet_HEO),MOE.Nome_Tp_Moeda
		from
			House_Exp_Out HOU with(nolock)
			join llp_exp_out LLP with(nolock) on LLP.num_proc_leo = HOU.num_proc_heo
			join pessoa CNS with(nolock) on CNS.cd_pes = HOU.Cd_Consig_HEO
			join Pessoa	SHP	with(nolock) on SHP.cd_pes = HOU.Cd_Export_Heo			
			left JOIN Localidade ORG with(nolock) on HOU.Cd_Org_HEO	= ORG.cd_local
			left JOIN Localidade DST with(nolock) on HOU.Cd_Dst_Heo	= DST.cd_local			
			join pessoa_LLP GR with(nolock) on GR.cd_pes = HOU.Cd_Export_HEO and GR.cd_pes_grupo = @Cd_Grupo
			join Pedido_Ship PS with(nolock) on HOU.num_proc_heo = PS.num_proc		
			left join Tipo_Moeda MOE  with(nolock) on MOE.Cd_Tp_Moeda = HOU.Cd_Tp_Moeda
			
			join Tarefas_Processos TP40 with(nolock) on HOU.num_proc_heo = TP40.num_proc --and TP40.id_task = 76
		where
			HOU.Num_Proc_HEO = @JOB	and
			TP40.dt_conclusao between @DtInicial and @DtFinal
			--and LLP.Id_status = 8			
	End	
	
	Begin
		--Update com base na CUSTO_CLIENTE
		Update @TAB
		set		
		[CERTIFICADO DE ORIGEM (CUSTO FIESP)] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'CERTIFICADO%DE%ORIGEM%'),
		[CARTA DE CRÉDITO] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'CARTA%DE%CRÉDITO%'), 
		[CONSULARIZAÇÃO] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'CONSULARIZAÇÃO%'), 
		[SEGURO] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'SEGURO%'),
		[LIBERAÇÃO BL] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Lib%BL%'),
		[CORREÇÃO BL] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'CORREÇÃO%BL%'),
		[ISPS] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'ISPS%'),
		[ARMAZENAGEM] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%Armazenagem%'),
		[CAPATAZIA (THC)] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'THC%'),
		[POSICIONAMENTO] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto, 'Posicionamento%'),
		[MOTOBOY]= dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto, 'MOTOBOY%'),
		[COURIER]= dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto, 'COURIER%'),		
		[CUSTOS DE DESEMBARAÇO (BDP)] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Serviços%Prestados%DESPACHO%'),
		[GESTÃO DE EXPORTAÇÃO (BDP)] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'Servicos%Gestão%'),
		[EMISSÃO DE DOCUMENTOS (BDP)] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'EMISSÃO%DE%DOCUMENTOS%'),
		[EMISSÃO DO COO (BDP)] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'EMISSÃO%Certificado%Origem%'),		
		[EMISSÃO DO RE (BDP)]= dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'EMISSÃO%De%RE%'),
		[INSPEÇÃO NÃO INVASIVA] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto, 'INSPEÇÃO%'),
		[VALOR DOS ACRÉSCIMOS (DI)] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto, '%ACRÉSCIMOS%'),	
		[OUTROS CUSTOS DO PROCESSO] = dbo.fBusca_Custo([BDP Job],CD_Pedido, Cd_Produto,'%')
	End
	
	Begin
		Update @TAB
		set	
			[TOTAL DAS DESPESAS + SERVIÇOS BDP] = 
				isnull([CERTIFICADO DE ORIGEM (CUSTO FIESP)],0) +
				isnull([CARTA DE CRÉDITO],0) +
				isnull([CONSULARIZAÇÃO] ,0) +
				isnull([SEGURO] ,0) +	
				isnull([LIBERAÇÃO BL] ,0) +
				isnull([CORREÇÃO BL],0) +
				isnull([ISPS],0) +
				isnull([ARMAZENAGEM] ,0) +
				isnull([CAPATAZIA (THC)]  ,0) +
				isnull([POSICIONAMENTO]  ,0)+
				isnull([MOTOBOY]  ,0)+
				isnull([COURIER]  ,0)+
				isnull([CUSTOS DE DESEMBARAÇO (BDP)] ,0) +
				isnull([GESTÃO DE EXPORTAÇÃO (BDP)],0) +
				isnull([EMISSÃO DE DOCUMENTOS (BDP)] ,0) +
				isnull([EMISSÃO DO COO (BDP)] ,0) +
				isnull([EMISSÃO DO RE (BDP)],0) +
				isnull([INSPEÇÃO NÃO INVASIVA],0) +
				isnull([VALOR DOS ACRÉSCIMOS (DI)],0)
	End
	
	Begin
		Update @TAB
		set	
			[OUTROS CUSTOS DO PROCESSO]	= isnull([OUTROS CUSTOS DO PROCESSO],0)  - isnull([TOTAL DAS DESPESAS + SERVIÇOS BDP],0)			
	End
	
	Begin
		Update @TAB
		set	
			[CUSTOS LOGÍSTICOS TOTAIS]  = isnull([OUTROS CUSTOS DO PROCESSO],0)  + isnull([TOTAL DAS DESPESAS + SERVIÇOS BDP],0)	
	End
	
	
	select
		datename(month,[DATA DE DESEMBARAÇO]) + ' - ' + convert(varchar(10),datepart(year,[DATA DE DESEMBARAÇO])) [MONTH],	
		[SALES ORDER],
		[SHIPPER],
		[CONSIGNEE],
		[CNPJ],
		[INCOTERM],
		[ORIGIN],
		[DESTINATION],
		[TIPO DE FRETE]	,
		--[DATA DE DESEMBARAÇO],
		[DATA DE EMBARQUE],		
		[VALOR DA INVOICE],
		[VALOR DO FRETE],
		[MOEDA DO FRETE],
		sum([CERTIFICADO DE ORIGEM (CUSTO FIESP)])	[CERTIFICADO DE ORIGEM (CUSTO FIESP)],
		sum([CARTA DE CRÉDITO])				[CARTA DE CRÉDITO],
		sum([CONSULARIZAÇÃO])				[CONSULARIZAÇÃO],
		sum([SEGURO])						[SEGURO],
		sum([LIBERAÇÃO BL])					[LIBERAÇÃO BL],
		sum([CORREÇÃO BL])					[CORREÇÃO BL],
		sum([ISPS])							[ISPS],
		sum([ARMAZENAGEM])					[ARMAZENAGEM],
		sum([CAPATAZIA (THC)])				[CAPATAZIA (THC)],
		sum([POSICIONAMENTO])				[POSICIONAMENTO],
		sum([MOTOBOY])						[MOTOBOY],
		sum([COURIER])						[COURIER],		
		sum([CUSTOS DE DESEMBARAÇO (BDP)])		[CUSTOS DE DESEMBARAÇO (BDP)],
		sum([GESTÃO DE EXPORTAÇÃO (BDP)])	[GESTÃO DE EXPORTAÇÃO (BDP)],
		sum([EMISSÃO DE DOCUMENTOS (BDP)])	[EMISSÃO DE DOCUMENTOS (BDP)],
		sum([EMISSÃO DO COO (BDP)])			[EMISSÃO DO COO (BDP)],
		sum([EMISSÃO DO RE (BDP)])			[EMISSÃO DO RE (BDP)],
		sum([INSPEÇÃO NÃO INVASIVA])		[INSPEÇÃO NÃO INVASIVA],
		sum([VALOR DOS ACRÉSCIMOS (DI)])	[VALOR DOS ACRÉSCIMOS (DI)],
		sum([TOTAL DAS DESPESAS + SERVIÇOS BDP])[TOTAL DAS DESPESAS + SERVIÇOS BDP],
		sum([OUTROS CUSTOS DO PROCESSO])	[OUTROS CUSTOS DO PROCESSO],
		sum([CUSTOS LOGÍSTICOS TOTAIS])		[CUSTOS LOGÍSTICOS TOTAIS],		
		[BDP Job]						[BDP REFERENCE]		
	from 
		@TAB
		
	GRoup by
		[DATA DE DESEMBARAÇO],[SALES ORDER],[SHIPPER],
		[CONSIGNEE],[INCOTERM],[ORIGIN],[DESTINATION],
		[TIPO DE FRETE],[DATA DE EMBARQUE],	[VALOR DO FRETE],
		[MOEDA DO FRETE],[VALOR DA INVOICE],[CNPJ],[BDP Job]

GO
