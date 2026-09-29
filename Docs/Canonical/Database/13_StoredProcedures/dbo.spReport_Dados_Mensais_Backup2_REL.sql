SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spReport_Dados_Mensais_Backup2_REL]
	@Grupo varchar(30),
	@DtInicial datetime,
	@DtFinal datetime

AS	

Declare @Cd_Grupo as varchar(10)
--Declare @Grupo as varchar(30)
--set @Grupo = 'Grupo Taminco'
Set @Cd_Grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)
exec dbo.spATL_CalculaPercentual_Ins @Cd_Grupo

declare @TAB table
	(
		[Modal]						varchar(30),
		[Month of Clearance]		varchar(100),				
		[BDP Ref.]					varchar(200),
		[ETD Date]					Datetime,
		[ATD Date]					Datetime,
		[Register Date]				varchar(10),
		[Docs Received Date]		Datetime,
		[ETA Date]					Datetime,
		[ATA Date]					Datetime,		
		[Port Entry Date]			Datetime,
		[Customs Transmission Date]	Datetime,
		[Entry Number]				varchar(200),	
		[Channel]					varchar(50),
		[Terminal]					varchar(200),
		[Warehouse Payment - Date]		Datetime,
		[NFE Draft - Date]				Datetime,	
		[Customs Clearance Date]		Datetime,
		[NF Date]						Datetime,
		[Transport. Doc Delivery Date]		Datetime,
		[Shipper]							varchar(200),
		[Origin]							varchar(200),
		[Destination]						varchar(200),
		[Country of Origin]					varchar(200),
		[House]								varchar(200),
		[Master]									varchar(200),
		[CNPJ]										varchar(200),
		[Incoterm]									varchar(200),	
		--[Netweight KG– Shipment] float,
		--[Gross Weight - Shipment - Value] float,
		[Netweight KG– Shipment]			decimal(18,3),
		[Gross Weight - Shipment - Value]	decimal(18,3),
		[Item]								varchar(10),	
		[ICMS - Value]								float,
		[% ICMS]			float,
		[Import Duty Value]							float,
		[% II]				float,
		[IPI - Value]								float,
		[% IPI]				float,
		[PIS - Value]								float,
		[% PIS]			float,	
		[Cofins - Value]							float,
		[% Cofins]		float,
		[AFRMM Value]						float,
		[Siscomex Value]					float,
		[Product ID]						varchar(200),
		[Product Description]				varchar(200),
		[Container Qty]						varchar(200),
		[Containers]						varchar(200),
		[PO Number]							varchar(200),		
		[Customer PO]						varchar(200),		
		[Freight Currency]					varchar(200),
		[FOB Value]		float,
		[FOB - USD]		float,				
		[NCM]								varchar(200),
		[Terminal Pier Name]				varchar(200),
		CD_Pedido int, 
		Cd_Produto int,
		[Percentual]float
	)	


insert into
			@TAB (
				[Modal],[Month of Clearance],[BDP Ref.],[ETD Date],[ATD Date],
			[Register Date],[Docs Received Date],[ETA Date],[ATA Date],[Port Entry Date],
			[Customs Transmission Date],[Entry Number],[Channel],[Terminal],[Warehouse Payment - Date],
			[NFE Draft - Date],[Customs Clearance Date],[NF Date],[Transport. Doc Delivery Date],
			[Shipper],[Origin],	[Destination],[Country of Origin],
			[House],[Master],[CNPJ],[Incoterm],
			--[Netweight KG– Shipment],[Gross Weight - Shipment - Value],
			[Item],
			[ICMS - Value],[Import Duty Value],[IPI - Value],[PIS - Value],[Cofins - Value],
			[AFRMM Value],[Siscomex Value],	[Product ID],[Product Description],[Container Qty],	
			[Containers],[PO Number],[Customer PO],[Freight Currency],[NCM],[Terminal Pier Name],
			CD_Pedido,Cd_Produto,[Percentual]
			
			)
		select
			HOU.Modal										[Modal],
			(datename(mm,TP4.Dt_Conclusao))					[Month of Clearance],	
			HOU.Num_Proc									[BDP Ref.],	
			HOU.ETD											[ETD Date],
			HOU.ATD											[ATD Date],
			HOU.Dt_Emis										[Register Date],
			TP16.Dt_Conclusao								[Docs Received Date],
			HOU.ETA											[ETA Date],
			HOU.ATA											[ATA Date],
			TP15.Dt_Conclusao								[Port Entry Date],
			--TP4.Dt_Conclusao								[Customs Transmission Date],
			dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'5')		[Customs Transmission Date],
			dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'5')		[Entry Number],	
			HOU.Canal										[Channel],
			T.Nome_Terminal									[Terminal],
			CXAArmazenagem.Dt_Pgto_Rcto_HIA	* [dbo].[fBuscaPorcentagem_CdPedido](HOU.Num_Proc,PS.Item,PS.cd_pedido)	[Warehouse Payment - Date],
			TP67.Dt_Conclusao								[NFE Draft - Date],	
			TP4.Dt_Conclusao								[Customs Clearance Date],
			dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'10')		[NF Date],
			TP7.Dt_Conclusao								[Transport. Doc Delivery Date],
			SHIP.Nome_Raz_Soc								[Shipper],
			LO.Nome_Local									[Origin],
			LD.Nome_Local									[Destination],
			LO.Pais_Local									[Country of Origin],
			HOU.HAWB										[House],
			HOU.MAWB										[Master],
			CONSIG.Num_CPF_CNPJ								[CNPJ],
			P.Incoterm										[Incoterm],	
			--PD.Peso_Liquido_TOT								[Netweight KG– Shipment],
			--PD.Peso_Bruto_TOT								[Gross Weight - Shipment - Value],
			PS.Item,
			CCXAC.Vlr_Item_Custo * [dbo].[fBuscaPorcentagem_CdPedido](HOU.Num_Proc,PS.Item,PS.cd_pedido)	[ICMS - Value],
			--NFDet.ALIQ_ICMS									[% ICMS],
			CCXAA.Vlr_Item_Custo* [dbo].[fBuscaPorcentagem_CdPedido](HOU.Num_Proc,PS.Item,PS.cd_pedido)							[Import Duty Value],
			--NFDet.ALIQ_II									[% II],
			CCXAB.Vlr_Item_Custo* [dbo].[fBuscaPorcentagem_CdPedido](HOU.Num_Proc,PS.Item,PS.cd_pedido)							[IPI - Value],
			--NFDet.ALIQ_IPI									[% IPI], 
			CCXAO.Vlr_Item_Custo* [dbo].[fBuscaPorcentagem_CdPedido](HOU.Num_Proc,PS.Item,PS.cd_pedido)							[PIS - Value],
			--NFDet.VL_ALIQ_PIS								[% PIS],
			CCXAP.Vlr_Item_Custo* [dbo].[fBuscaPorcentagem_CdPedido](HOU.Num_Proc,PS.Item,PS.cd_pedido)							[Cofins - Value],
			--NFDet.VL_ALIQ_COFINS							[% Cofins],
			CCXAM.Vlr_Item_Custo* [dbo].[fBuscaPorcentagem_CdPedido](HOU.Num_Proc,PS.Item,PS.cd_pedido)							[AFRMM Value],
			CCXAD.Vlr_Item_Custo* [dbo].[fBuscaPorcentagem_CdPedido](HOU.Num_Proc,PS.Item,PS.cd_pedido)							[Siscomex Value],
			PC.cd_Proc_Cliente								[Product ID], 
			PC.Produto_Descr								[Product Description],
			[dbo].[Qty_Container](HOU.Num_Proc)				[Container Qty],
			[dbo].[fBusca_Containers] (HOU.Num_Proc)		[Containers],
			dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'1')		[PO Number],
			dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'9')		[Customer PO],	
			HOU.Moeda_invoice								[Freight Currency],
			PC.NCM_Cliente									[NCM],
			OPER.Descricao_OP								[Terminal Pier Name],
			PS.cd_pedido,
			PS.cd_produto,PP.Percentual
		from vwHouse_Imp HOU with(nolock)
		left Join Pessoa SHIP					with(nolock) on Hou.Cd_Export = SHIP.Cd_Pes
		left Join Pessoa CONSIG					with(nolock) on HOU.Cd_Consig = CONSIG.Cd_Pes
		Left Outer Join Pessoa_LLP PLL			with(nolock) on HOU.Cd_Consig = PLL.Cd_Pes
		Left Outer Join Grupo G					with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
		Left Outer Join pessoa	PG				with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
		Join Localidade LO						with(nolock) on LO.cd_local = HOU.Cd_Org
		Join Localidade LD						with(nolock) on LD.cd_local = HOU.Cd_Dst
		Left Outer Join Tarefas_Processos TP4	with(nolock) on HOU.Num_Proc = TP4.Num_Proc and TP4.ID_Task = '4'
		Left Outer Join Tarefas_Processos TP15  with(nolock) on HOU.Num_Proc = TP15.Num_Proc and TP15.ID_Task = '15'
		Left Outer Join Tarefas_Processos TP67  with(nolock) on HOU.Num_Proc = TP67.Num_Proc and TP67.ID_Task = '67'
		Left Outer Join Tarefas_Processos TP7	with(nolock) on HOU.Num_Proc = TP7.Num_Proc and TP7.ID_Task = '7'
		Left Outer Join Tarefas_Processos TP16  with(nolock) on HOU.Num_Proc = TP16.Num_Proc and TP16.ID_Task = '16'
		Left Outer Join Terminal T	with(nolock) on HOU.Cd_Terminal = T.Cd_Terminal
		Left Outer Join Campo_Processo CP139	with(nolock) on HOU.Num_Proc = CP139.Num_Proc AND CP139.Id_Campo = '139' 
		Left Outer Join Tipo_operador_portuario OPER with(nolock) on CP139.Campo_Dados = OPER.Descricao_OP 

		Left Join Pedido_Ship PS				with(nolock) on HOU.Num_Proc = PS.Num_Proc
		left Join Pedido_Det PD				with(nolock) on PS.cd_pedido = PD.Cd_pedido and PS.cd_produto = PD.Cd_Produto and PS.Lote = PD.Lote and PS.Item = PD.Item
		left Join Pedido P					with(nolock) on PD.cd_pedido = P.Cd_pedido
		left Join Produto_Cliente PC			with(nolock) on PD.Cd_Produto = PC.cd_prod and PD.Cd_Produto = PC.cd_prod
		left Outer Join vwcxas CXAArmazenagem	with(nolock) on HOU.Num_Proc = CXAArmazenagem.Num_Proc_HIA and CXAArmazenagem.DC_HIA='C' and CXAArmazenagem.cd_tp_Tx in (select cd_tp_Tx from tipo_taxa where nome_tp_tx like 'Armazenagem%')
		Left Outer Join Custo_Cliente CCXAC with(nolock)on HOU.Num_Proc = CCXAC.Num_Proc and CCXAC.Cd_tp_tx = 'XAC' and CCXAC.Cd_Pedido = PS.Cd_pedido and CCXAC.Cd_Produto = PS.cd_produto
		Left Outer Join Custo_Cliente CCXAA with(nolock)on HOU.Num_Proc = CCXAA.Num_Proc and CCXAA.Cd_tp_tx = 'XAA' and CCXAA.Cd_Pedido = PS.Cd_pedido and CCXAA.Cd_Produto = PS.cd_produto
		Left Outer Join Custo_Cliente CCXAB with(nolock)on HOU.Num_Proc = CCXAB.Num_Proc and CCXAB.Cd_tp_tx = 'XAB' and CCXAB.Cd_Pedido = PS.Cd_pedido and CCXAB.Cd_Produto = PS.cd_produto
		Left Outer Join Custo_Cliente CCXAO with(nolock)on HOU.Num_Proc = CCXAO.Num_Proc and CCXAO.Cd_tp_tx = 'XAO' and CCXAO.Cd_Pedido = PS.Cd_pedido and CCXAO.Cd_Produto = PS.cd_produto
		Left Outer Join Custo_Cliente CCXAP with(nolock)on HOU.Num_Proc = CCXAP.Num_Proc and CCXAP.Cd_tp_tx = 'XAP' and CCXAP.Cd_Pedido = PS.Cd_pedido and CCXAP.Cd_Produto = PS.cd_produto
		Left Outer Join Custo_Cliente CCXAM with(nolock)on HOU.Num_Proc = CCXAM.Num_Proc and CCXAM.Cd_tp_tx = 'XAM' and CCXAM.Cd_Pedido = PS.Cd_pedido and CCXAM.Cd_Produto = PS.cd_produto
		Left Outer Join Custo_Cliente CCXAD with(nolock)on HOU.Num_Proc = CCXAD.Num_Proc and CCXAD.Cd_tp_tx = 'XAD' and CCXAD.Cd_Pedido = PS.Cd_pedido and CCXAD.Cd_Produto = PS.cd_produto
		--Left Outer Join Nota_Cliente NC with(nolock) on HOU.Num_Proc = NC.Num_Proc
		--Left Outer Join Nota_Fiscal_Cliente_Det NFDet with(nolock) on NC.ID_NF = NFDet.ID_NF and NC.CD_Cliente = NFDet.Cd_Cliente and PS.cd_pedido = NFDet.Cd_Pedido and PS.cd_produto = NFDet.Cd_Produto
		join Percentual_Produto_Hexion PP with(nolock) on PS.Cd_Pedido = PP.Cd_pedido and PS.Cd_Produto = PP.Cd_Produto and PS.Num_Proc = PP.Num_Proc and PS.Item = PP.Item
		
		--where HOU.Num_Proc = 'IASLA201701003BR'
		where convert(Datetime,HOU.dt_emis,105)  between @DtInicial and @DtFinal
				and (PG.Apelido = @Grupo or @Grupo = 'GRUPO ALL')
	
		
	Begin
	--Update com base na NOTA_CLIENTE
		Update T
		set 
			--NFDet.ALIQ_ICMS								[% ICMS],
			[% ICMS] = ALIQ_ICMS,
			--NFDet.ALIQ_II									[% II],
			[% II] = ALIQ_II,	
			--NFDet.ALIQ_IPI								[% IPI], 
			[% IPI] = ALIQ_IPI,
			--NFDet.VL_ALIQ_PIS								[% PIS],
			[% PIS] = VL_ALIQ_PIS,
			--NFDet.VL_ALIQ_COFINS							[% Cofins],
			[% Cofins] = VL_ALIQ_COFINS,
			--sum(NFDet.Vlr_Total_ITem-isnull(NFDet.vlr_frete,0)
			--	-isnull(NFDet.vlr_seguro,0)-isnull(NFDet.vl_ii,0)
			--		-isnull(NFDet.ACRESCIMOS,0))			[FOB Value],
			[FOB Value] = totFOB,
			--(case when[Paridade] = 0 then 0 else
			--	Cast(sum(NFDet.Vlr_Total_ITem-isnull(NFDet.vlr_frete,0)
			--		-isnull(NFDet.vlr_seguro,0)-isnull(NFDet.vl_ii,0)
			--		-isnull(NFDet.ACRESCIMOS,0)) /[Paridade] 
			--		as decimal(18,2))End)					[FOB - USD],
			[FOB - USD] = totFOBUSD,
			
			[Netweight KG– Shipment] = cast(Peso_Liquido as decimal(18,3)),
			[Gross Weight - Shipment - Value] = cast(Peso_Bruto as decimal(18,3))
		from 
			@TAB T
			join
			(
			Select 
				sum(ALIQ_ICMS) ALIQ_ICMS,
				sum(ALIQ_II) ALIQ_II,
				sum(ALIQ_IPI) ALIQ_IPI,
				sum(VL_ALIQ_PIS) VL_ALIQ_PIS,
				sum(VL_ALIQ_COFINS) VL_ALIQ_COFINS,
						
				sum(Vlr_Total_ITem-isnull(vlr_frete,0)
				-isnull(vlr_seguro,0)-isnull(vl_ii,0)
				-isnull(ACRESCIMOS,0))	 totFOB,
				
				(case when[Paridade] = 0 then 0 else
				Cast(sum(Vlr_Total_ITem-isnull(vlr_frete,0)
					-isnull(vlr_seguro,0)-isnull(vl_ii,0)
					-isnull(ACRESCIMOS,0)) /[Paridade] 
					as decimal(18,2))End)	totFOBUSD,
					Num_Proc,Cd_Produto,--cd_pedido,
					sum(Peso_Liquido) Peso_Liquido,
					sum(Peso_Bruto) Peso_Bruto		
						
			from nota_fiscal_cliente_det NFCD
			join nota_cliente NC on NC.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
			group by 
				--ALIQ_ICMS,ALIQ_II,ALIQ_IPI,VL_ALIQ_PIS,VL_ALIQ_COFINS,[Paridade],
				--Peso_Liquido,Peso_Bruto,
				[Paridade],Cd_Produto,num_proc,cd_pedido
			) A on A.num_proc = T.[BDP Ref.] and A.cd_produto = T.cd_produto-- and A.cd_pedido=T.CD_Pedido
	End
	
	--BEGIN
	--update @TAB
	--	set 
	--		[FOB Value] = [FOB Value] * [dbo].[fBuscaPorcentagem_CdPedido]([BDP Ref.],Item,cd_pedido),	
	--		[FOB - USD] = [FOB - USD] * [dbo].[fBuscaPorcentagem_CdPedido]([BDP Ref.],Item,cd_pedido)
	
	--END
	
		
		
select 
		[Modal],
		[Month of Clearance],				
		[BDP Ref.],
		[ETD Date],
		[ATD Date],
		[Register Date],
		[Docs Received Date],
		[ETA Date],
		[ATA Date],		
		[Port Entry Date],
		[Customs Transmission Date]	,
		[Entry Number],	
		[Channel],
		[Terminal],
		[Warehouse Payment - Date],
		[NFE Draft - Date],	
		[Customs Clearance Date],
		[NF Date],
		[Transport. Doc Delivery Date],
		[Shipper],
		[Origin],
		[Destination],
		[Country of Origin],
		[House],
		[Master],
		[CNPJ],
		[Incoterm],
		cast([Netweight KG– Shipment] * [Percentual] as decimal(18,2))	[Netweight KG– Shipment],		
		--isnull(convert(varchar(25),[Netweight KG– Shipment]),'0,000') [Netweight KG– Shipment],
		--isnull(convert(varchar(25),[Gross Weight - Shipment - Value]),'0,000') [Gross Weight - Shipment - Value],
		cast([Gross Weight - Shipment - Value] * [Percentual] as decimal(18,2))	[Gross Weight - Shipment - Value],	
		[Item],
		isnull([ICMS - Value],0) [ICMS - Value],		
		cast([% ICMS] * [Percentual] as decimal(18,2))	[% ICMS],	
		--isnull([% ICMS],0) [% ICMS],
		isnull([Import Duty Value],0) [Import Duty Value],
		cast([% II] * [Percentual] as decimal(18,2))	[% II],
		--isnull([% II],0) [% II],
		isnull([IPI - Value],0)	[IPI - Value],
		cast([% IPI] * [Percentual] as decimal(18,2))	[% IPI],
		--isnull([% IPI],0)	[% IPI],
		isnull([PIS - Value],0)	[PIS - Value],
		cast([% PIS] * [Percentual] as decimal(18,2))	[% PIS],
		--isnull([% PIS],0)	[% PIS],	
		isnull([Cofins - Value],0)	[Cofins - Value],
		cast([% Cofins] * [Percentual] as decimal(18,2))	[% Cofins],
		--isnull([% Cofins],0)	[% Cofins],
		isnull([AFRMM Value],0)	[AFRMM Value],
		isnull([Siscomex Value],0)	[Siscomex Value],
		[Product ID],
		[Product Description],
		[Container Qty],
		[Containers],
		[PO Number]	,		
		[Customer PO],		
		isnull([Freight Currency],0)	[Freight Currency],
		cast([FOB Value] * [Percentual] as decimal(18,2))	[FOB Value],
		--isnull([FOB Value],0)	[FOB Value],
		cast([FOB - USD] * [Percentual] as decimal(18,2))	[FOB - USD],
		--isnull([FOB - USD],0)	[FOB - USD],				
		[NCM]
		--[Terminal Pier Name] 
	from @tab
GO
