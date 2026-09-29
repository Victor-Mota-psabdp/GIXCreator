SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Ticket#100-76165
--[spATL_DASHBOARD_IMPORT_CASHFLOW_Rel] 'GRUPO LYONDELL BASEL','2017-01-01','2017-04-08'
CREATE Procedure [dbo].[spATL_DASHBOARD_IMPORT_CASHFLOW_Rel]
(	
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
)
AS


	declare @TAB table
	(
		[BDP Ref.]					varchar(16),
		[Consignee]					varchar(100),				
		[PO Number]					varchar(200),
		[Customer PO]				varchar(200),
		[Delivery Note]				varchar(200),
		[Country of Origin]			varchar(100),
		[Type of Cargo]				varchar(30),
		[Vessel]					varchar(50),
		[Voyage]					varchar(10),
		[Terminal]					varchar(50),
		[ETD Date]					DateTime,
		[ATD Date]					DateTime,
		[ETA Date]					DateTime,
		[ATA Date]					DateTime,
		[Product IDs by Shipment]	varchar(500),
		[Container Qty]				varchar(500),
		[Netweight KG Shipment]		float
	)

	Declare @Cd_Grupo as varchar(10)
	Set @Cd_Grupo = (select top 1 Cd_Pes from pessoa With(nolock) where apelido=@Grupo)

	Begin
		insert into
			@TAB 
			(
				[BDP Ref.],[Consignee],[PO Number],[Customer PO],
				[Delivery Note],
				[Country of Origin],[Type of Cargo],[Vessel],[Voyage],[Terminal],
				[ETD Date],[ATD Date],[ETA Date],[ATA Date],
				[Product IDs by Shipment],[Container Qty],[Netweight KG Shipment]			)		
			
		select
			HOU.Num_Proc,CNS.Apelido,dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'1'),dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'9'),
			[dbo].[fBusca_PRODUTO_Lote](HOU.Num_Proc),
			L.Pais_Local,TC.Nome_Tp_Carga,HOU.Vessel,HOU.Viagem,T.Nome_Terminal,
			HOU.ETD,HOU.ATD,HOU.ETA,HOU.ATA,			
			[dbo].[fBusca_PRODUTO](HOU.Num_Proc) ,[dbo].[Qty_Container](HOU.Num_Proc),HOu.Peso_Liquido
		from
			vwHouse_Imp					HOU with(nolock)
			left join Localidade		L	with(nolock) on L.cd_local = HOU.Cd_Org			
			join pessoa					CNS with(nolock) on CNS.cd_pes = HOU.Cd_Consig
			Left Outer Join Pessoa_LLP  PLL	with(nolock) on HOU.Cd_Consig = PLL.Cd_Pes
			Left Outer Join Grupo		G	with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
			Left Outer Join pessoa		PG	with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
			left join Tipo_Carga		TC	with(nolock) on TC.Cd_Tp_Carga = HOU.Tp_Carga
			Left join Terminal			T	with(nolock) on T.Cd_Terminal = HOU.Cd_Terminal
			left join Tarefas_Processos	TP7 with(nolock) on HOU.num_proc = TP7.num_proc and TP7.id_task = 7
		where			
			convert(datetime,HOU.Dt_Emis,103) between @DtInicial and @DtFinal
			and (PG.Apelido = @Grupo or @Grupo = 'GRUPO ALL')
			and TP7.dt_conclusao is null	
			and isnull(HOU.ID_Status,0) < 9
	End

	
	select * from @TAB 

GO
