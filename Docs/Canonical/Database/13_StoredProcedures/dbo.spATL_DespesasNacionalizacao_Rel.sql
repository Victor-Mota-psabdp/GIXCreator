SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spATL_DespesasNacionalizacao_Rel] 'GRUPO LYONDELL BASEL','2017-01-01','2017-07-05'

CREATE Procedure [dbo].[spATL_DespesasNacionalizacao_Rel]
(	
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
)
AS


	declare @TAB table
	(
		[Modal]						varchar(20),
		[BDP Ref.]					varchar(16),
		[PO Number]					varchar(100),
		[Type of Cargo]				varchar(30),
		[Vessel]					varchar(50),
		[Voyage]					varchar(10),
		[Terminal]					varchar(50),
		[ATA Date]					DateTime,
		[Product IDs by Shipment]	varchar(200),
		[Entry Number]				varchar(50),
		[Customs Clearance Date]	datetime,
		
		[Import Duty Value]			float, --II (Imposto) Value
		[Siscomex Value]			float, --[SISCOMEX (Custo) Value] float,
		[PIS - Value]				float, --[PIS (Imposto) Value] float,
		
		[Cofins - Value]			float, --[COFINS (Imposto) Value] float,
		[ICMS - Value]				float, --[ICMS (Imposto) Value] float,
		[AFRMM Value]				float, --[AFRMM (Custo) Value] float,
		
		[TUP - Value]				float, --??
		[Warehousing Value]			float, --??
		[Customs Brokerage Value]	float, --[Despachante (Custo) Value] float,
		
		[BL Fee Value]				float, --[Lib. B/L (Custo) Value] float,
		[Desconsolidation Value]	float, --[Desconsolidação (Custo) Value] float,
		[THC Value]					float, --[THC (Custo) Value] float,
		
		[ISPS Value]				float, --[ISPS (Custo) Value] float,
		[Advancement - Value]		float, --??
		[Arqueação]					float, --??
		[Handling]					float, --??
		[Exame Laboratorial]		float, --??
		[LI]						float, --??,
		[Taxa Siscarga]				float, --??,
		[Multa]						float, --??,
		CD_Pedido					int, 
		Cd_Produto					int,
		
		[Custo Total]				float,
		[Others Charges]			float,
		[SOP]						float
	)

	Declare @Cd_Grupo as varchar(10)
	Set @Cd_Grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)

	Begin
		insert into
			@TAB 
			([Modal],[BDP Ref.],[PO Number],[Type of Cargo],[Vessel],[Voyage],[Terminal],
			[ATA Date],[Product IDs by Shipment],[Entry Number],[Customs Clearance Date],
			CD_Pedido, Cd_Produto)
			
		select
			HOU.Modal,HOU.Num_Proc,dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'1'),
			TC.Nome_Tp_Carga,HOU.Vessel,HOU.Viagem,			
			T.Nome_Terminal, 
			HOU.ATA,PC.Produto_Descr,dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'5'),
			TP4.dt_conclusao,PS.CD_Pedido, PS.Cd_Produto
		from
			vwHouse_Imp				HOU with(nolock)			
			join pessoa				CNS with(nolock) on CNS.cd_pes = HOU.Cd_Consig
			Left Outer Join Pessoa_LLP PLL	with(nolock) on HOU.Cd_Consig = PLL.Cd_Pes
			Left Outer Join Grupo G			with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
			Left Outer Join pessoa	PG		with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
			left join Tipo_Carga	TC	with(nolock) on TC.Cd_Tp_Carga = HOU.Tp_Carga
			Left join Terminal		T	with(nolock) on T.Cd_Terminal = HOU.Cd_Terminal
			join Pedido_Ship		PS	with(nolock) on HOU.Num_Proc = PS.num_proc
			join Pedido_Det			PD	with(nolock) on PD.Cd_Pedido = PS.Cd_Pedido and PD.Cd_Produto = PS.Cd_Produto and PD.item = PS.item
			join Produto_Cliente	PC	with(nolock) on PS.Cd_Produto = PC.Cd_Prod
			join Tarefas_Processos	TP4 with(nolock) on HOU.num_proc = TP4.num_proc and TP4.id_task = 4					
			left JOIN campo_processo CP45 with(nolock) on CP45.num_proc=HOU.Num_Proc and CP45.id_campo=45
		where	
			--hou.Num_Proc = 'IMLYB201701018BR'		
			TP4.dt_conclusao between @DtInicial and @DtFinal
			and (PG.Apelido = @Grupo or @Grupo = 'GRUPO ALL')
			and isnull(CP45.Campo_Dados,'2') <> '1'	
			
			
	End
	
	Begin
		--Update com base na CUSTO_CLIENTE
		Update @TAB
		set
		[Import Duty Value]		= dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%Imposto%de%Importação%'),
		[Siscomex Value]		= dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%SISCO%'),
		[PIS - Value]			= dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%PIS%'),
		
		[Cofins - Value]		= dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%COFINS%'),
		[ICMS - Value]			= dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%ICMS%'),
		[AFRMM Value]			= dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%AFRMM%'),
		
		[TUP - Value]				= dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%TUP%'),
		[Warehousing Value]			= 
			dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'VISTORIA DE CNTR%') +
			dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'Posicionamento de CNTR%') +
			dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'Armazenagem%') +
			dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'Estadia%') +
			dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'Movimentação de Container%') +
			dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'Movimentacao CNTR%') +
			dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'Pesagem%') +
			dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'Posicionamento%'),
		
		[Customs Brokerage Value]	= dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'Serv%Desp%'),
		
		[BL Fee Value]				= dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'Lib%BL%'),
		[Desconsolidation Value]	= dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'Desconso%'),
		[THC Value]					= dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'THC%') + dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'Capatazia%'),
		
		[ISPS Value]				= dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'ISPS%'),
		
		[Advancement - Value]		= [dbo].[fBusca_CaixaTaxaVlr]([BDP Ref.],'%adiant%','C'),
		
		[Arqueação]					= dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'Arqueacao%'),
		[Handling]					= dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%Handling%'),
		[Exame Laboratorial]		= dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'Exame%Laboratorial%'),
		[LI]						= dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'LI - CHB%'),
		[Taxa Siscarga]				= dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'TAXA SISCARGA%'),
		[Multa]						= dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'Multa%'),
		
		[Custo Total]				= dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'%'),
		
		[Others Charges]			= 		
			dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'Drop off%') +
			dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'Reparo de Container%') +
			dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'Locomoção 1%') +
			dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'Taxa Reparo de Equipamento%'),
			
		[SOP]						= dbo.fBusca_Custo([BDP Ref.],CD_Pedido, Cd_Produto,'SOP 1%')
		
		--"Other Charges", esta deverá contemplar as seguintes taxas: - helio - 4/7
		--"Drop off - CHB"
		--"Reparo de Container - CHB"
		--"Locomoção 1 - CHB"
		--"Taxa Reparo de Equipamento - CHB"
		-- criar uma coluna SOP que contempla os valores da taxa "SOP 1 - CHB"
	End
	
	--Begin
	--	Update @TAB
	--		set
	--		[Others Charges] = [Custo Total] - 
	--		(
	--			isnull([Import Duty Value],0) - 
	--			isnull([Siscomex Value],0) - 
	--			isnull([PIS - Value],0) - 
	--			isnull([Cofins - Value],0) - 
	--			isnull([ICMS - Value],0) - 
	--			isnull([AFRMM Value],0) - 
	--			isnull([TUP - Value],0) - 
	--			isnull([Warehousing Value],0) - 
	--			isnull([Customs Brokerage Value],0) - 
	--			isnull([BL Fee Value],0) - 
	--			isnull([Desconsolidation Value],0) - 
	--			isnull([THC Value],0) - 
	--			isnull([ISPS Value],0) - 
	--			isnull([Arqueação],0) - 
	--			isnull([Handling],0) - 
	--			isnull([Exame Laboratorial],0) - 
	--			isnull([LI],0) - 
	--			isnull([Taxa Siscarga],0) - 
	--			isnull([Multa],0)
	--		)
	--End
	select 
		[Modal],[BDP Ref.],[PO Number],[Type of Cargo],[Vessel],[Voyage],[Terminal],[ATA Date],
		[Product IDs by Shipment],[Entry Number],[Customs Clearance Date],		
		[Import Duty Value],[Siscomex Value],[PIS - Value],[Cofins - Value],[ICMS - Value],[AFRMM Value],
		[TUP - Value],[Warehousing Value],[Customs Brokerage Value],[BL Fee Value],[Desconsolidation Value],
		[THC Value],[ISPS Value],[Advancement - Value],[Arqueação],[Handling],[Exame Laboratorial],[LI],
		[Taxa Siscarga],[Multa]	,[SOP], [Others Charges]	
	from 
		@TAB
	Order by [ATA Date]

GO
