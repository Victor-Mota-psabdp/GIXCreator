SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_TransPriceSolenis_GroupBy_Rel] '2020-01-01','2021-04-02'
--[spATL_TransPriceSolenis_V2_Rel] '2020-01-01','2021-04-02'
--[spATL_TransPriceSolenis_Rel] '2020-02-18','2020-02-18'
CREATE procedure [dbo].[spATL_TransPriceSolenis_V2_Rel]
(
	@DataInicial datetime,
	@DataFinal datetime
)

as
Declare @Grupo varchar(20)
Declare @Cd_Grupo as varchar(10)
set @Grupo = 'Grupo Solenis'
Set @Cd_Grupo = (select top 1 Cd_Pes from pessoa with(nolock) where apelido=@Grupo)


declare @TAB table
	(
		[Ref. BDP]					varchar(16),
		[PO]						varchar(300),
		[Numero da DI]				varchar(50),
		[Data da DI]				Datetime,
		[Data do Desembaraço]		Datetime,
		[Nome do Produto]			varchar(500),
		[Exportador]				varchar(500),
		[Vinculo]					varchar(20),
		[Invoice]					varchar(80),
		[Origem]					varchar(50),
		[Destino]					varchar(50),
		[Destino Final]				varchar(50),
		[Moeda da Invoice]			varchar(50),
		[Paridade da Invoice]		varchar(50),
		[Valor Unitario]			varchar(50),
		[Valor Unitario R$]			varchar(50),
		[Quantidade]				float,		
		[Unidade]					varchar(50),
		[Valor da Invoice]			float,
			[Acrescimos da DI]			float,
		[FOB - R$]					float,
		[CIF R$]					float,
		[NCM]						varchar(50),
		[% II]						decimal(10,2),
		[II - R$]					float,
		[% IPI]						decimal(10,2),
		[IPI - R$]					float,
		[% PIS]						decimal(10,2),
		[PIS - R$]					float,
		[% Cofins]					decimal(10,2),
		[Cofins - R$]				float,
		[Siscomex - R$]				float,
		[% ICMS]					decimal(10,2),
		[ICMS - R$]					float,
		[Numero da Danfe]			varchar(50),
		[Valor da Danfe]			float,
		[Incoterm]					varchar(50),
		[Danfe Recebida em:]		Datetime,
		[CFOP]						varchar(50),
		[Product ID]				varchar(50),
		[Termo de Pagamento]		varchar(50),
		[Embarque]					Datetime,
		[Vencimento]				Datetime,
		[Paridade do Frete]			varchar(50),
		[Moeda do Frete]			varchar(50),
		[Frete]						decimal(18,4),
		[Frete - R$]				decimal(18,4),
		--[Seguro]			float,
		[Seguro - USD]				float,
		[Taxa USD]				float,
		[Seguro - R$]				float,
		[FOB QTY]					float,
		CD_Pedido					int, 
		Cd_Produto					int,
		countPedidos					int,
		[item]					varchar(50),
		[num_pedido]					varchar(50),
		[fBuscaPorcentagem_CdPedido] float,
		[fBuscaPorcentagem_Pedido] float
	)

	insert into	@TAB 
	(
		[Ref. BDP],[PO],[Numero da DI],[Data da DI],[Data do Desembaraço],[Nome do Produto],[Exportador],[Vinculo],[Invoice],
		[Origem],[Destino],[Destino Final],[Moeda da Invoice],
		[Paridade da Invoice],[Quantidade],	[Unidade],			
		[NCM],[% II],[% IPI],[% PIS],[% Cofins], [% ICMS],[Numero da Danfe],
		[Valor da Danfe],[Incoterm],[Danfe Recebida em:],[CFOP],[Product ID],[Termo de Pagamento],[Embarque], [Vencimento],
		[Paridade do Frete], [Moeda do Frete], [Taxa USD],
		[FOB - R$],	[CIF R$],[Frete - R$],
		CD_Pedido,Cd_Produto,[item]	,[num_pedido],[Valor Unitario]
	)
	select 
		HOU.Num_Proc [Ref. BDP],
		left(dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,1),500) [PO],
		left(dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc,5),100) [Numero da DI],
		cast(dbo.fBusca_TipoDocCliente('D',HOU.Num_Proc,5) as datetime) [Data da DI],
		TP4.Dt_Conclusao [Data do Desembaraço],
		PC.Produto_Descr [Nome do Produto],
		SHIPPER.Nome_Raz_Soc [Exportador],
		(Case when Cd_Tipo = '2' and Left(HOU.Num_Proc, 1) = 'I' then 'Third' else
			Case when Cd_Tipo = '2' and Left(HOU.Num_Proc, 1) = 'E' then 'Indent' else
			Case when Cd_Tipo = '3' then 'Inter-company' else
			Case when Cd_Tipo = '4' then 'Samples' else 'Samples' End End End End) [Vinculo],
		left(dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,2),80) [Invoice],
		POrigem.Nome_Pais [Origem],
		Dst.Nome_Local [Destino],
		DSTFinal.Nome_Local [DestinoFinal],
		replace(HOU.Moeda_invoice, 'REL','BRL') [Moeda da Invoice],

		CP31.Campo_Dados						[Paridade da Invoice],
		--ps.qty									[Quantidade],
		NDET.quantidade									[Quantidade],
		PD.UOM [Unidade],
		PD.NCM [NCM],
		cast(NDET.ALIQ_II as decimal(10,2)) [% II],
		cast(NDET.ALIQ_IPI as decimal(10,2)) [% IPI],
		cast(NDET.vl_aliq_pis as decimal(10,2)) [% PIS],
		cast(NDET.VL_ALIQ_COFINS as decimal(10,2)) [% Cofins],
		cast(ALIQ_ICMS as decimal(10,2)) [% ICMS]
		,dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'10') [Numero da Danfe],
		NDET.vlr_nf  [Valor da Danfe],
		HOU.cd_tp_oper [Incoterm],
		cast(dbo.fBusca_TipoDocCliente('D',HOU.Num_Proc,10) as datetime) [Danfe Recebida em:],
		NDET.CFOP [CFOP],
		PC.cd_Proc_Cliente [Product ID],
		TMC.Descricao_Termo [Termo de Pagamento],
		HOU.ATD [Embarque],
		(Case when TMC.Dt_Base = 'Invoice'  then   (Case when dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,2) is not null  then dateadd(day,isnull(TMC.Dias,0),dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,2)) else null End)  else
		Case when TMC.Dt_Base = 'ATD'  then   (Case when HOU.ATD is not null then dateadd(day,isnull(TMC.Dias,0),HOU.ATD) else null End) else null end end)   [Vencimento],
		cast(replace(CP31.Campo_Dados,'.',',') as varchar(50))[Paridade do Frete],
		TM.Nome_Tp_Moeda [Moeda do Frete],
		CP176.Campo_Dados [Taxa USD],
		cast(NDET.totFob as decimal(18,2)) [FOB - R$],
		cast(NDET.CIF as decimal(18,2)) [CIF R$],
		cast(NDET.vlr_frete as decimal(18,2)) [Frete - R$],
		PS.cd_pedido,PS.cd_Produto,ps.Item,P.Num_Pedido,ndet.Vlr_Item
from 
	vwHouse_Imp HOU with(nolock)
	join pessoa_LLP	GR with(nolock) on GR.cd_pes = HOU.Cd_Consig and GR.cd_pes_grupo = @Cd_Grupo
	left join Tarefas_Processos TP4 with(nolock) on TP4.Num_Proc = HOU.Num_Proc and TP4.ID_Task = 4
	join Pedido_Ship PS with(nolock) on HOU.Num_Proc = PS.Num_Proc
	left join Pedido P with(nolock) on PS.cd_pedido = P.Cd_pedido
	left join Pedido_Det PD with(nolock) on PD.cd_pedido = P.Cd_pedido  and PS.cd_produto = PD.Cd_Produto and PS.Lote = PD.Lote and PS.Item = PD.Item
	left join Produto_Cliente PC with(nolock) on PD.Cd_Produto = PC.cd_prod
	join Pessoa SHIPPER with(nolock) on HOU.Cd_Export = SHIPPER.Cd_Pes
	Join Localidade Org with(nolock) on Org.cd_local=cd_org
	left Join Pais POrigem with(nolock) on POrigem.cd_pais=Org.cd_pais
	join Localidade Dst with (nolock) on Dst.cd_local =cd_dst
	left join Localidade DSTFinal with (nolock) on DSTFinal.cd_local =Cd_DstFinal
	left join Campo_Processo CP31 with(nolock) on HOU.Num_Proc = CP31.Num_Proc and CP31.Id_Campo = 31
	left join vwNota_cliente NDET with(nolock) on PS.num_proc = NDET.Num_proc  and PS.cd_produto = NDET.Cd_Produto
	left join Campo_Processo CP87 with(nolock) on HOU.num_proc = CP87.Num_Proc and CP87.id_campo=87
	left Join Campo_Processo CP176 with(nolock) on CP176.Num_Proc = HOU.Num_Proc and CP176.id_campo=176
	Left Join Termo_Pagamento TMC with(nolock) on TMC.cd_termo=CP87.campo_Dados
	left join tipo_moeda TM with(nolock) on TM.Cd_tp_Moeda = HOU.Moeda_Frete
	join Tarefas_Processos TP40 with(nolock) on HOU.Num_Proc = TP40.Num_Proc and TP40.ID_Task = '40'
where  
	--HOU.Num_proc = 'IMSOL202002146BR'
	----and
	TP40.Dt_Conclusao between @DataInicial and @DataFinal


	Begin
		update @TAB
		 set 
			[fBuscaPorcentagem_CdPedido]	=	[dbo].[fBuscaPorcentagem_CdPedido]([Ref. BDP],item,cd_pedido),
			[fBuscaPorcentagem_Pedido]		=	[dbo].[fBuscaPorcentagem_Pedido]([Ref. BDP],cd_pedido)

	End

	Begin
		Update @TAB
		set
			[Acrescimos da DI]	=	[dbo].[fBusca_Custo]([Ref. BDP],CD_Pedido, Cd_Produto,'VALOR%DOS%ACRÉSCIMOS%') *
									[fBuscaPorcentagem_CdPedido],
			[FOB QTY]			=	[dbo].[fBusca_Custo]([Ref. BDP],CD_Pedido, Cd_Produto,'FOB%CHARGES%') *
									[fBuscaPorcentagem_CdPedido],
			[II - R$]			=	[dbo].[fBusca_Custo]([Ref. BDP],CD_Pedido, Cd_Produto,'Imposto%de%Importação%') *
									[fBuscaPorcentagem_CdPedido],
			[Cofins - R$]		=	[dbo].[fBusca_Custo]([Ref. BDP],CD_Pedido, Cd_Produto,'Cofins%')*
									[fBuscaPorcentagem_CdPedido],
			[IPI - R$]			=	[dbo].[fBusca_Custo]([Ref. BDP],CD_Pedido, Cd_Produto,'IPI%')*
									[fBuscaPorcentagem_CdPedido],
			[PIS - R$]			=	[dbo].[fBusca_Custo]([Ref. BDP],CD_Pedido, Cd_Produto,'PIS%')*
									[fBuscaPorcentagem_CdPedido],
			[Siscomex - R$]		=	[dbo].[fBusca_Custo]([Ref. BDP],CD_Pedido, Cd_Produto,'%Siscomex%')*
									[fBuscaPorcentagem_CdPedido],
			[ICMS - R$]			=	[dbo].[fBusca_Custo]([Ref. BDP],CD_Pedido, Cd_Produto,'%ICMS%')*
									[fBuscaPorcentagem_CdPedido],
			[Seguro - R$]		=	[dbo].[fBusca_Custo]([Ref. BDP],CD_Pedido, Cd_Produto,'Seguro%')*
									[fBuscaPorcentagem_CdPedido],

			[FOB - R$]			=	[FOB - R$] * [fBuscaPorcentagem_CdPedido] 
								* [fBuscaPorcentagem_Pedido],
			[CIF R$]			=	[CIF R$]* [fBuscaPorcentagem_CdPedido]	
								* [fBuscaPorcentagem_Pedido],
			[Frete - R$]		=	[Frete - R$]* [fBuscaPorcentagem_CdPedido]	
								* [fBuscaPorcentagem_Pedido],
			[Valor da Danfe]	=	[Valor da Danfe] * [fBuscaPorcentagem_CdPedido]	
								* [fBuscaPorcentagem_Pedido],
			[Quantidade]	=	[Quantidade] * [fBuscaPorcentagem_CdPedido]	
								* [fBuscaPorcentagem_Pedido]

	End


	Begin
		Update @TAB
			set				
				[Valor da Invoice]	= cast([FOB QTY] as decimal(10,2)) / cast([Paridade da Invoice] as decimal(10,4)),
				[Frete]				= [Frete - R$]  /[Paridade da Invoice] ,
				[Seguro - USD]		= [Seguro - R$] / cast([Taxa USD] as decimal(10,4)) 
	End

	Begin
		Update @TAB
			set				
				[Valor Unitario] = [Valor da Invoice] / [Quantidade]				
	End	
	

select 
	--[FOB QTY],
	[Destino Final],[Ref. BDP],[PO],[Numero da DI],[Data da DI],[Data do Desembaraço],[Nome do Produto],[Exportador],
	[Vinculo],[Invoice],[Origem],[Destino],[Moeda da Invoice],
	cast(replace([Paridade da Invoice],'.',',') as varchar(50))  [Paridade da Invoice],
	cast(replace(cast([Valor Unitario] as decimal(18,6)),'.',',') as varchar(50)) [Valor Unitario],
	cast(replace(
		cast(
			cast([Valor Unitario] as decimal(10,2)) / cast([Paridade da Invoice] as decimal(10,4)) 
		as decimal(18,6)),'.',',') 
	as varchar(50)) [Valor Unitario R$],
	
	[Quantidade],[Unidade],
	cast(replace([Valor da Invoice],'.',',') as varchar(50)) [Valor da Invoice],
	[Acrescimos da DI],[FOB - R$],[CIF R$],[NCM],[% II],[II - R$],[% IPI],[IPI - R$],[% PIS],[PIS - R$],
	[% Cofins],[Cofins - R$],[Siscomex - R$],[% ICMS],[ICMS - R$],[Numero da Danfe],[Valor da Danfe],
	[Incoterm],[Danfe Recebida em:],[CFOP],[Product ID],[Termo de Pagamento],[Embarque],
	[Vencimento],[Paridade do Frete],[Moeda do Frete],[Frete],
	[Frete - R$],[Seguro - USD],
	cast(replace(cast([Taxa USD] as decimal(10,4)),'.',',') as varchar(50)) [Taxa USD],
	[Seguro - R$]

from @TAB

--select 	
--	[Destino Final],[Ref. BDP],[PO],[Numero da DI],[Data da DI],[Data do Desembaraço],[Nome do Produto],[Exportador],
--	[Vinculo],[Invoice],[Origem],[Destino],[Moeda da Invoice],[Paridade da Invoice],
--	[Valor Unitario],
--	cast([Valor Unitario] as decimal(10,2)) / cast([Paridade da Invoice] as decimal(10,4)) [Valor Unitario R$],
--	sum([Quantidade]) [Quantidade] ,[Unidade],sum([Valor da Invoice]) [Valor da Invoice],
--	sum([Acrescimos da DI]) [Acrescimos da DI],sum([FOB - R$]) [FOB - R$],sum([CIF R$]) [CIF R$],[NCM],[% II],
--	sum([II - R$]) [II - R$],[% IPI],sum([IPI - R$]) [IPI - R$],[% PIS],sum([PIS - R$]) [PIS - R$],
--	[% Cofins],sum([Cofins - R$])[Cofins - R$] ,sum([Siscomex - R$]) [Siscomex - R$],[% ICMS],sum([ICMS - R$]) [ICMS - R$],
--	[Numero da Danfe],sum([Valor da Danfe]) [Valor da Danfe],
--	[Incoterm],[Danfe Recebida em:],[CFOP],[Product ID],[Termo de Pagamento],[Embarque],
--	[Vencimento],[Paridade do Frete],[Moeda do Frete],sum([Frete]) [Frete],
--	sum([Frete - R$]) [Frete - R$],sum([Seguro - USD]) [Seguro - USD],[Taxa USD],sum([Seguro - R$]) [Seguro - R$]
--from @TAB
--Group By
--	[Destino Final],[Ref. BDP],[PO],[Numero da DI],[Data da DI],[Data do Desembaraço],[Nome do Produto],[Exportador],
--	[Vinculo],[Invoice],[Origem],[Destino],[Moeda da Invoice],[Paridade da Invoice],[Valor Unitario],[Unidade],[NCM],[% II],
--	[% IPI],[% PIS],[% Cofins],[% ICMS],[Numero da Danfe],[Incoterm],[Danfe Recebida em:],[CFOP],[Product ID],[Termo de Pagamento],[Embarque],
--	[Vencimento],[Paridade do Frete],[Moeda do Frete],[Taxa USD]






/*

--[spATL_TransPriceSolenis_GroupBy_Rel] '2020-01-01','2021-04-02'
--[spATL_TransPriceSolenis_V2_Rel] '2020-01-01','2021-04-02'
--[spATL_TransPriceSolenis_Rel] '2020-02-18','2020-02-18'
ALTER procedure [dbo].[spATL_TransPriceSolenis_V2_Rel]
(
	@DataInicial datetime,
	@DataFinal datetime
)

as
Declare @Grupo varchar(20)
Declare @Cd_Grupo as varchar(10)
set @Grupo = 'Grupo Solenis'
Set @Cd_Grupo = (select top 1 Cd_Pes from pessoa with(nolock) where apelido=@Grupo)


declare @TAB table
	(
		[Ref. BDP]					varchar(16),
		[PO]						varchar(300),
		[Numero da DI]				varchar(50),
		[Data da DI]				Datetime,
		[Data do Desembaraço]		Datetime,
		[Nome do Produto]			varchar(500),
		[Exportador]				varchar(500),
		[Vinculo]					varchar(20),
		[Invoice]					varchar(80),
		[Origem]					varchar(50),
		[Destino]					varchar(50),
		[Destino Final]				varchar(50),
		[Moeda da Invoice]			varchar(50),
		[Paridade da Invoice]		varchar(50),
		[Valor Unitario]			varchar(50),
		[Valor Unitario R$]			varchar(50),
		[Quantidade]				float,		
		[Unidade]					varchar(50),
		[Valor da Invoice]			float,
			[Acrescimos da DI]			float,
		[FOB - R$]					float,
		[CIF R$]					float,
		[NCM]						varchar(50),
		[% II]						decimal(10,2),
		[II - R$]					float,
		[% IPI]						decimal(10,2),
		[IPI - R$]					float,
		[% PIS]						decimal(10,2),
		[PIS - R$]					float,
		[% Cofins]					decimal(10,2),
		[Cofins - R$]				float,
		[Siscomex - R$]				float,
		[% ICMS]					decimal(10,2),
		[ICMS - R$]					float,
		[Numero da Danfe]			varchar(50),
		[Valor da Danfe]			float,
		[Incoterm]					varchar(50),
		[Danfe Recebida em:]		Datetime,
		[CFOP]						varchar(50),
		[Product ID]				varchar(50),
		[Termo de Pagamento]		varchar(50),
		[Embarque]					Datetime,
		[Vencimento]				Datetime,
		[Paridade do Frete]			varchar(50),
		[Moeda do Frete]			varchar(50),
		[Frete]						decimal(18,4),
		[Frete - R$]				decimal(18,4),
		--[Seguro]			float,
		[Seguro - USD]				float,
		[Taxa USD]				float,
		[Seguro - R$]				float,
		[FOB QTY]					float,
		CD_Pedido					int, 
		Cd_Produto					int,
		countPedidos					int,
		[item]					varchar(50),
		[num_pedido]					varchar(50),
		[fBuscaPorcentagem_CdPedido] float,
		[fBuscaPorcentagem_Pedido] float
	)

	insert into	@TAB 
	(
		[Ref. BDP],[PO],[Numero da DI],[Data da DI],[Data do Desembaraço],[Nome do Produto],[Exportador],[Vinculo],[Invoice],
		[Origem],[Destino],[Destino Final],[Moeda da Invoice],
		[Paridade da Invoice],[Quantidade],	[Unidade],			
		[NCM],[% II],[% IPI],[% PIS],[% Cofins], [% ICMS],[Numero da Danfe],
		[Valor da Danfe],[Incoterm],[Danfe Recebida em:],[CFOP],[Product ID],[Termo de Pagamento],[Embarque], [Vencimento],
		[Paridade do Frete], [Moeda do Frete], [Taxa USD],
		[FOB - R$],	[CIF R$],[Frete - R$],
		CD_Pedido,Cd_Produto,[item]	,[num_pedido],[Valor Unitario]
	)
	select 
		HOU.Num_Proc [Ref. BDP],
		left(dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,1),500) [PO],
		left(dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc,5),100) [Numero da DI],
		cast(dbo.fBusca_TipoDocCliente('D',HOU.Num_Proc,5) as datetime) [Data da DI],
		TP4.Dt_Conclusao [Data do Desembaraço],
		PC.Produto_Descr [Nome do Produto],
		SHIPPER.Nome_Raz_Soc [Exportador],
		(Case when Cd_Tipo = '2' and Left(HOU.Num_Proc, 1) = 'I' then 'Third' else
			Case when Cd_Tipo = '2' and Left(HOU.Num_Proc, 1) = 'E' then 'Indent' else
			Case when Cd_Tipo = '3' then 'Inter-company' else
			Case when Cd_Tipo = '4' then 'Samples' else 'Samples' End End End End) [Vinculo],
		left(dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,2),80) [Invoice],
		POrigem.Nome_Pais [Origem],
		Dst.Nome_Local [Destino],
		DSTFinal.Nome_Local [DestinoFinal],
		replace(HOU.Moeda_invoice, 'REL','BRL') [Moeda da Invoice],

		CP31.Campo_Dados						[Paridade da Invoice],
		--ps.qty									[Quantidade],
		NDET.quantidade									[Quantidade],
		PD.UOM [Unidade],
		PD.NCM [NCM],
		cast(NDET.ALIQ_II as decimal(10,2)) [% II],
		cast(NDET.ALIQ_IPI as decimal(10,2)) [% IPI],
		cast(NDET.vl_aliq_pis as decimal(10,2)) [% PIS],
		cast(NDET.VL_ALIQ_COFINS as decimal(10,2)) [% Cofins],
		cast(ALIQ_ICMS as decimal(10,2)) [% ICMS]
		,dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'10') [Numero da Danfe],
		NDET.vlr_nf  [Valor da Danfe],
		HOU.cd_tp_oper [Incoterm],
		cast(dbo.fBusca_TipoDocCliente('D',HOU.Num_Proc,10) as datetime) [Danfe Recebida em:],
		NDET.CFOP [CFOP],
		PC.cd_Proc_Cliente [Product ID],
		TMC.Descricao_Termo [Termo de Pagamento],
		HOU.ATD [Embarque],
		(Case when TMC.Dt_Base = 'Invoice'  then   (Case when dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,2) is not null  then dateadd(day,isnull(TMC.Dias,0),dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,2)) else null End)  else
		Case when TMC.Dt_Base = 'ATD'  then   (Case when HOU.ATD is not null then dateadd(day,isnull(TMC.Dias,0),HOU.ATD) else null End) else null end end)   [Vencimento],
		cast(replace(CP31.Campo_Dados,'.',',') as varchar(50))[Paridade do Frete],
		TM.Nome_Tp_Moeda [Moeda do Frete],
		CP176.Campo_Dados [Taxa USD],
		cast(NDET.totFob as decimal(18,2)) [FOB - R$],
		cast(NDET.CIF as decimal(18,2)) [CIF R$],
		cast(NDET.vlr_frete as decimal(18,2)) [Frete - R$],
		PS.cd_pedido,PS.cd_Produto,ps.Item,P.Num_Pedido,ndet.Vlr_Item
from 
	vwHouse_Imp HOU with(nolock)
	join pessoa_LLP	GR with(nolock) on GR.cd_pes = HOU.Cd_Consig and GR.cd_pes_grupo = @Cd_Grupo
	left join Tarefas_Processos TP4 with(nolock) on TP4.Num_Proc = HOU.Num_Proc and TP4.ID_Task = 4
	join Pedido_Ship PS with(nolock) on HOU.Num_Proc = PS.Num_Proc
	left join Pedido P with(nolock) on PS.cd_pedido = P.Cd_pedido
	left join Pedido_Det PD with(nolock) on PD.cd_pedido = P.Cd_pedido  and PS.cd_produto = PD.Cd_Produto and PS.Lote = PD.Lote and PS.Item = PD.Item
	left join Produto_Cliente PC with(nolock) on PD.Cd_Produto = PC.cd_prod
	join Pessoa SHIPPER with(nolock) on HOU.Cd_Export = SHIPPER.Cd_Pes
	Join Localidade Org with(nolock) on Org.cd_local=cd_org
	left Join Pais POrigem with(nolock) on POrigem.cd_pais=Org.cd_pais
	join Localidade Dst with (nolock) on Dst.cd_local =cd_dst
	left join Localidade DSTFinal with (nolock) on DSTFinal.cd_local =Cd_DstFinal
	left join Campo_Processo CP31 with(nolock) on HOU.Num_Proc = CP31.Num_Proc and CP31.Id_Campo = 31
	left join vwNota_cliente NDET with(nolock) on PS.num_proc = NDET.Num_proc  and PS.cd_produto = NDET.Cd_Produto
	left join Campo_Processo CP87 with(nolock) on HOU.num_proc = CP87.Num_Proc and CP87.id_campo=87
	left Join Campo_Processo CP176 with(nolock) on CP176.Num_Proc = HOU.Num_Proc and CP176.id_campo=176
	Left Join Termo_Pagamento TMC with(nolock) on TMC.cd_termo=CP87.campo_Dados
	left join tipo_moeda TM with(nolock) on TM.Cd_tp_Moeda = HOU.Moeda_Frete
	join Tarefas_Processos TP40 with(nolock) on HOU.Num_Proc = TP40.Num_Proc and TP40.ID_Task = '40'
where  
	--HOU.Num_proc = 'IMSOL202002146BR'
	----and
	TP40.Dt_Conclusao between @DataInicial and @DataFinal


	Begin
		update @TAB
		 set 
			[fBuscaPorcentagem_CdPedido]  = [dbo].[fBuscaPorcentagem_CdPedido]([Ref. BDP],item,cd_pedido),
			[fBuscaPorcentagem_Pedido] =[dbo].[fBuscaPorcentagem_Pedido]([Ref. BDP],cd_pedido)

	End

	Begin
		Update @TAB
		set
			[Acrescimos da DI]	=	[dbo].[fBusca_Custo]([Ref. BDP],CD_Pedido, Cd_Produto,'VALOR%DOS%ACRÉSCIMOS%') *
									[dbo].[fBuscaPorcentagem_CdPedido]([Ref. BDP],item,cd_pedido),
			[FOB QTY]			=	[dbo].[fBusca_Custo]([Ref. BDP],CD_Pedido, Cd_Produto,'FOB%CHARGES%') *
									[dbo].[fBuscaPorcentagem_CdPedido]([Ref. BDP],item,cd_pedido),
			[II - R$]			=	[dbo].[fBusca_Custo]([Ref. BDP],CD_Pedido, Cd_Produto,'Imposto%de%Importação%') *
									[dbo].[fBuscaPorcentagem_CdPedido]([Ref. BDP],item,cd_pedido),
			[Cofins - R$]		=	[dbo].[fBusca_Custo]([Ref. BDP],CD_Pedido, Cd_Produto,'Cofins%')*
									[dbo].[fBuscaPorcentagem_CdPedido]([Ref. BDP],item,cd_pedido),
			[IPI - R$]			=	[dbo].[fBusca_Custo]([Ref. BDP],CD_Pedido, Cd_Produto,'IPI%')*
									[dbo].[fBuscaPorcentagem_CdPedido]([Ref. BDP],item,cd_pedido),
			[PIS - R$]			=	[dbo].[fBusca_Custo]([Ref. BDP],CD_Pedido, Cd_Produto,'PIS%')*
									[dbo].[fBuscaPorcentagem_CdPedido]([Ref. BDP],item,cd_pedido),
			[Siscomex - R$]		=	[dbo].[fBusca_Custo]([Ref. BDP],CD_Pedido, Cd_Produto,'%Siscomex%')*
									[dbo].[fBuscaPorcentagem_CdPedido]([Ref. BDP],item,cd_pedido),
			[ICMS - R$]			=	[dbo].[fBusca_Custo]([Ref. BDP],CD_Pedido, Cd_Produto,'%ICMS%')*
									[dbo].[fBuscaPorcentagem_CdPedido]([Ref. BDP],item,cd_pedido),
			[Seguro - R$]		=	[dbo].[fBusca_Custo]([Ref. BDP],CD_Pedido, Cd_Produto,'Seguro%')*
									[dbo].[fBuscaPorcentagem_CdPedido]([Ref. BDP],item,cd_pedido),

			[FOB - R$]			=	[FOB - R$] * [dbo].[fBuscaPorcentagem_CdPedido]([Ref. BDP],item,cd_pedido) 
								* [dbo].[fBuscaPorcentagem_Pedido]([Ref. BDP],cd_pedido),
			[CIF R$]			=	[CIF R$]* [dbo].[fBuscaPorcentagem_CdPedido]([Ref. BDP],item,cd_pedido)	
								* [dbo].[fBuscaPorcentagem_Pedido]([Ref. BDP],cd_pedido),
			[Frete - R$]		=	[Frete - R$]* [dbo].[fBuscaPorcentagem_CdPedido]([Ref. BDP],item,cd_pedido)	
								* [dbo].[fBuscaPorcentagem_Pedido]([Ref. BDP],cd_pedido),
			[Valor da Danfe]	=	[Valor da Danfe] * [dbo].[fBuscaPorcentagem_CdPedido]([Ref. BDP],item,cd_pedido)	
								* [dbo].[fBuscaPorcentagem_Pedido]([Ref. BDP],cd_pedido),
			[Quantidade]	=	[Quantidade] * [dbo].[fBuscaPorcentagem_CdPedido]([Ref. BDP],item,cd_pedido)	
								* [dbo].[fBuscaPorcentagem_Pedido]([Ref. BDP],cd_pedido)

	End


	Begin
		Update @TAB
			set				
				[Valor da Invoice]	= cast([FOB QTY] as decimal(10,2)) / cast([Paridade da Invoice] as decimal(10,4)),
				[Frete]				= [Frete - R$]  /[Paridade da Invoice] ,
				[Seguro - USD]		= [Seguro - R$] / cast([Taxa USD] as decimal(10,4)) 
	End

	Begin
		Update @TAB
			set				
				[Valor Unitario] = [Valor da Invoice] / [Quantidade]				
	End	
	

select 
	--[FOB QTY],
	[Destino Final],[Ref. BDP],[PO],[Numero da DI],[Data da DI],[Data do Desembaraço],[Nome do Produto],[Exportador],
	[Vinculo],[Invoice],[Origem],[Destino],[Moeda da Invoice],
	cast(replace([Paridade da Invoice],'.',',') as varchar(50))  [Paridade da Invoice],
	cast(replace(cast([Valor Unitario] as decimal(18,6)),'.',',') as varchar(50)) [Valor Unitario],
	cast(replace(
		cast(
			cast([Valor Unitario] as decimal(10,2)) / cast([Paridade da Invoice] as decimal(10,4)) 
		as decimal(18,6)),'.',',') 
	as varchar(50)) [Valor Unitario R$],
	
	[Quantidade],[Unidade],
	cast(replace([Valor da Invoice],'.',',') as varchar(50)) [Valor da Invoice],
	[Acrescimos da DI],[FOB - R$],[CIF R$],[NCM],[% II],[II - R$],[% IPI],[IPI - R$],[% PIS],[PIS - R$],
	[% Cofins],[Cofins - R$],[Siscomex - R$],[% ICMS],[ICMS - R$],[Numero da Danfe],[Valor da Danfe],
	[Incoterm],[Danfe Recebida em:],[CFOP],[Product ID],[Termo de Pagamento],[Embarque],
	[Vencimento],[Paridade do Frete],[Moeda do Frete],[Frete],
	[Frete - R$],[Seguro - USD],
	cast(replace(cast([Taxa USD] as decimal(10,4)),'.',',') as varchar(50)) [Taxa USD],
	[Seguro - R$]

from @TAB

--select 	
--	[Destino Final],[Ref. BDP],[PO],[Numero da DI],[Data da DI],[Data do Desembaraço],[Nome do Produto],[Exportador],
--	[Vinculo],[Invoice],[Origem],[Destino],[Moeda da Invoice],[Paridade da Invoice],
--	[Valor Unitario],
--	cast([Valor Unitario] as decimal(10,2)) / cast([Paridade da Invoice] as decimal(10,4)) [Valor Unitario R$],
--	sum([Quantidade]) [Quantidade] ,[Unidade],sum([Valor da Invoice]) [Valor da Invoice],
--	sum([Acrescimos da DI]) [Acrescimos da DI],sum([FOB - R$]) [FOB - R$],sum([CIF R$]) [CIF R$],[NCM],[% II],
--	sum([II - R$]) [II - R$],[% IPI],sum([IPI - R$]) [IPI - R$],[% PIS],sum([PIS - R$]) [PIS - R$],
--	[% Cofins],sum([Cofins - R$])[Cofins - R$] ,sum([Siscomex - R$]) [Siscomex - R$],[% ICMS],sum([ICMS - R$]) [ICMS - R$],
--	[Numero da Danfe],sum([Valor da Danfe]) [Valor da Danfe],
--	[Incoterm],[Danfe Recebida em:],[CFOP],[Product ID],[Termo de Pagamento],[Embarque],
--	[Vencimento],[Paridade do Frete],[Moeda do Frete],sum([Frete]) [Frete],
--	sum([Frete - R$]) [Frete - R$],sum([Seguro - USD]) [Seguro - USD],[Taxa USD],sum([Seguro - R$]) [Seguro - R$]
--from @TAB
--Group By
--	[Destino Final],[Ref. BDP],[PO],[Numero da DI],[Data da DI],[Data do Desembaraço],[Nome do Produto],[Exportador],
--	[Vinculo],[Invoice],[Origem],[Destino],[Moeda da Invoice],[Paridade da Invoice],[Valor Unitario],[Unidade],[NCM],[% II],
--	[% IPI],[% PIS],[% Cofins],[% ICMS],[Numero da Danfe],[Incoterm],[Danfe Recebida em:],[CFOP],[Product ID],[Termo de Pagamento],[Embarque],
--	[Vencimento],[Paridade do Frete],[Moeda do Frete],[Taxa USD]


*/



GO
