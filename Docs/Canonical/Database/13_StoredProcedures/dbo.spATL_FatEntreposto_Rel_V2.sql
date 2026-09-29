SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[spATL_FatEntreposto_Rel_V2]  'GRUPO LYONDELL BASEL','', '2016-01-01','2017-08-09'
CREATE procedure [dbo].[spATL_FatEntreposto_Rel_V2] 

(
@Grupo varchar(20),
@Num_Proc varchar(16),
@DtInicial datetime,
@DtFinal datetime
)
as
	
if @Num_Proc = '' Begin  set @Num_Proc = '%' End
	declare @TAB table
	(
		[BDP Ref.]									 char(16),
		[PO Number]									 varchar(MAX),
		[Delivery Note]								 varchar(MAX),
		[Product ID]								 varchar(MAX),
		[Product Description]						 varchar(MAX),
		[Netweight KG Shipment]						 decimal(18,3),
		[Gross Weight - Shipment - Value]			 decimal(18,3),
		[Master]									 varchar(50),
		[Vessel]									 varchar(50),
		[Voyage]									 varchar(10),
		[Destination]								 varchar(50),
		[Terminal]									 varchar(30),
		[ATA Date]									 Datetime,
		[Inland Trucker]							 varchar(30),
		[DA Number]									 varchar(MAX),
		[Customs Clearance Date]					 Datetime,
		[AFRMM Value]								 float,
		[Siscomex Value]							 float, 
		[Warehousing Value]							 float, 
		[Tax Deductible Warehouse Value]			 float,
		[Tax Deductible Warehouse]					 float, 
		[Port Entry Value]							 float,
		[No Invasive inspection value]				 float,
		[Independent Trustee Value]					 float,
		[ISPS Value]								 float,
		[Customs Brokerage Value]					 float,
		[Tax Deductible for Customs Brokerage value] float,
		[Tax Deductible for Customs Brokerage]		 float,
		[Advancement - Value]						 float, 
		[BL fee]									 float,
		[Damage Protection Charge Value]			 float,
		[Siscarga]									 float,
		[Desconsolidation Value]					 float,
		[Drop Of Value]								 float,
		[THC Value]									 float,
		[Inland Freight Value]						 float,
		[Container Repair Value]					 float,
		[Armed Escort value]						 float,
		[Total value per STO]						 float
	)

	Begin
		insert into
			@TAB (
					[BDP Ref.],	[PO Number],[Delivery Note],[Product ID],[Product Description],
					[Netweight KG Shipment],[Gross Weight - Shipment - Value],[Master],[Vessel],[Voyage],[Destination],
					[Terminal],[ATA Date],[Inland Trucker],[DA Number],[Customs Clearance Date],[Advancement - Value]
				)
		select
			distinct
			HOU.Num_Proc,
			PD.Num_PO,
			[dbo].[fBusca_PRODUTO_Lote](HOU.Num_Proc),
			[dbo].[fBusca_PRODUTOID](HOU.Num_Proc),
			[dbo].[fBusca_PRODUTO](HOU.Num_Proc),
			HOU.Peso_Liquido,
			HOU.Peso_Bruto,
			HOU.MAWB,
			HOU.Vessel,
			HOU.Viagem,
			Dst.Nome_Local,
			TM.Nome_Terminal,
			HOU.ATA,
			TR.Apelido,
			dbo.fBusca_Docs_PO_Modal_COALESCE(HOU.Num_Proc,59),
			TP4.Dt_Conclusao,
			(select sum(vlr_pgto_Rcto_hia) Valor from vwcxas with(nolock) 
			where num_proc_hia=HOU.Num_Proc and dc_hia='C' and cd_tp_Tx in 
			(select cd_tp_Tx from tipo_taxa with(nolock) where nome_tp_tx like 'Adiantamento%'))	
		from
			vwHouse_Imp HOU with(nolock)
			left join Pedido_Ship PS with(nolock) on HOU.Num_Proc = PS.Num_Proc
			left join Pedido PD with(nolock) on PS.cd_pedido = PD.Cd_pedido
			left join Pedido_Det PDet with(nolock) on PD.Cd_pedido = PDet.Cd_Pedido and PS.cd_produto = PDet.Cd_Produto and PS.Item = PDet.Item and PS.Lote = PDet.Lote
			left join Produto_Cliente PC with(nolock) on PS.cd_produto = PC.cd_prod
			left join Localidade Dst with(nolock) on HOU.Cd_Dst = Dst.Cd_Local
			left join Terminal TM with(nolock) on HOU.Cd_Terminal = TM.Cd_Terminal
			left join Pessoa TR with(nolock) on HOU.cd_transportadora = TR.Cd_Pes
			--left join vwPO_Imp DA with(nolock) on HOU.Num_Proc = DA.Num_Proc 
			Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig
			join Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
			join pessoa	PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
			left join Campo_Processo CP45 with(nolock) on HOU.Num_Proc = CP45.Num_Proc and CP45.Id_Campo = 45
			left join Tarefas_Processos TP4 with(nolock) on HOU.Num_Proc = TP4.Num_Proc and TP4.ID_Task = 4
			where 
				CP45.Campo_Dados = 1 and (HOU.Num_Proc = @Num_Proc or @Num_Proc='%') and convert(datetime,HOU.Dt_Emis,103) between @DtInicial and @DtFinal and  (PG.Apelido like @Grupo or @Grupo ='Grupo ALL')
	End		
	
	Begin
		Update @TAB
		set
			[AFRMM Value] = [dbo].[fBusca_Custo_Processo]([BDP Ref.],'%AFRMM%'),
			[Siscomex Value] = [dbo].[fBusca_Custo_Processo]([BDP Ref.],'%Siscomex%'),
			[Warehousing Value] = [dbo].[fBusca_Custo_Processo]([BDP Ref.],'VISTORIA DE CNTR%') 
									+ [dbo].[fBusca_Custo_Processo]([BDP Ref.],'Posicionamento de CNTR%')
									+ [dbo].[fBusca_Custo_Processo]([BDP Ref.],'Armazenagem%')
									+ [dbo].[fBusca_Custo_Processo]([BDP Ref.],'Estadia%')
									+ [dbo].[fBusca_Custo_Processo]([BDP Ref.],'Movimentação de Container%')
									+ [dbo].[fBusca_Custo_Processo]([BDP Ref.],'Movimentacao CNTR%')
									+ [dbo].[fBusca_Custo_Processo]([BDP Ref.],'Pesagem%')
									+ [dbo].[fBusca_Custo_Processo]([BDP Ref.],'Posicionamento%'),
			[Tax Deductible Warehouse] = 0.9075,
			[Port Entry Value] = [dbo].[fBusca_Custo_Processo]([BDP Ref.],'PRESENÇA DE CARGA%'),
			[No Invasive inspection value] = [dbo].[fBusca_Custo_Processo]([BDP Ref.],'VISTORIA DE CNTR%')
												+ [dbo].[fBusca_Custo_Processo]([BDP Ref.],'Invasive inspection%')
												+ [dbo].[fBusca_Custo_Processo]([BDP Ref.],'Inspeção - CHB%'),
			[Independent Trustee Value] = [dbo].[fBusca_Custo_Processo]([BDP Ref.],'Fiel Depositário%')
											+ [dbo].[fBusca_Custo_Processo]([BDP Ref.],'Independent Trustee%'),
			[ISPS Value] = [dbo].[fBusca_Custo_Processo]([BDP Ref.],'ISPS - CHB%'),						
			[Customs Brokerage Value] = [dbo].[fBusca_Custo_Processo]([BDP Ref.],'Serviço de DA Entreposto 1')
										+ [dbo].[fBusca_Custo_Processo]([BDP Ref.],'Emissão DTA SUL 1'),
			[Tax Deductible for Customs Brokerage] = 0.9385,
			[BL fee] = [dbo].[fBusca_Custo_Processo]([BDP Ref.],'Liberação de BL%'),
			[Damage Protection Charge Value] = [dbo].[fBusca_Custo_Processo]([BDP Ref.],'%damage protection%'),
			[Siscarga] = [dbo].[fBusca_Custo_Processo]([BDP Ref.],'TAXA SISCARGA%'),
			[Desconsolidation Value] = [dbo].[fBusca_Custo_Processo]([BDP Ref.],'Desconsolidação%'),
			[Drop Of Value] = [dbo].[fBusca_Custo_Processo]([BDP Ref.],'Drop off%'),
			[THC Value] = [dbo].[fBusca_Custo_Processo]([BDP Ref.],'THC%')
							+ [dbo].[fBusca_Custo_Processo]([BDP Ref.],'capatazias%'),
			[Inland Freight Value] = [dbo].[fBusca_Custo_Processo]([BDP Ref.],'%Frete Interno%')
										+ [dbo].[fBusca_Custo_Processo]([BDP Ref.],'%Inland%')
										+ [dbo].[fBusca_Custo_Processo]([BDP Ref.],'Transporte Mercadoria%'),
			[Container Repair Value] = [dbo].[fBusca_Custo_Processo]([BDP Ref.],'%Reparo de Container%') 
										+ [dbo].[fBusca_Custo_Processo]([BDP Ref.],'%DESPESA CONTAINER%')
										+ [dbo].[fBusca_Custo_Processo]([BDP Ref.],'%Deposito% Container%')
										+ [dbo].[fBusca_Custo_Processo]([BDP Ref.],'%Devolução de CNTR%'),	
			[Armed Escort value] = [dbo].[fBusca_Custo_Processo]([BDP Ref.],'%Escolta%') 
									+ [dbo].[fBusca_Custo_Processo]([BDP Ref.],'%Armed Escort%')
	End
	
	Begin
			Update @TAB
			set				
				[Tax Deductible Warehouse Value] = isnull([Warehousing Value],0) * isnull([Tax Deductible Warehouse],1),
				[Tax Deductible for Customs Brokerage value] = isnull([Customs Brokerage Value],0) * isnull([Tax Deductible for Customs Brokerage],1)		
	End
	
	Begin
			Update @TAB
			set				
				[Total value per STO] = isnull([AFRMM Value],0) + isnull([Tax Deductible Warehouse Value],0) 
										+ isnull([Port Entry Value],0) + isnull([No Invasive inspection value],0) + isnull([Independent Trustee Value],0)
										+ isnull([ISPS Value],0) + isnull([Tax Deductible for Customs Brokerage value],0) + isnull([BL fee],0)
										+ isnull([Damage Protection Charge Value],0) + isnull([Siscarga],0) + isnull([Desconsolidation Value],0)
										+ isnull([Drop Of Value],0) + isnull([THC Value],0) + isnull([Inland Freight Value],0) + isnull([Container Repair Value],0)
										+ isnull([Armed Escort value],0)
									
	End
	
	Select 
		--[BDP Ref.] ,
		[PO Number],
		--[Delivery Note],
		[Product ID],
		[Product Description],
		--[Netweight KG Shipment] ,
		--[Gross Weight - Shipment - Value],
		--[Master],
		--[Vessel],
		--[Voyage],
		[Destination],
		--[Terminal] ,
		[ATA Date],
		--[Inland Trucker] ,
		--[DA Number],
		[Customs Clearance Date],
		[AFRMM Value],
		[Siscomex Value], 
		[Warehousing Value], 
		cast([Tax Deductible Warehouse Value] as decimal(18,2)) [Tax Deductible Warehouse Value],
		[Port Entry Value]							 ,
		[No Invasive inspection value]				 ,
		[Independent Trustee Value]					 ,
		[ISPS Value]								 ,
		[Customs Brokerage Value]					 ,
		cast([Tax Deductible for Customs Brokerage value] as decimal(18,2)) [Tax Deductible for Customs Brokerage value],
		[BL fee]									 ,
		[Damage Protection Charge Value]			 ,
		[Siscarga]									 ,
		[Desconsolidation Value]					 ,
		[Drop Of Value]								 ,
		[THC Value]									 ,
		[Inland Freight Value]						 ,
		[Container Repair Value]					 ,
		[Armed Escort value]						 ,
		[Advancement - Value]						 , 
		cast([Total value per STO] as decimal(18,2)) [Total value per STO]					 
	From
		@TAB
GO
