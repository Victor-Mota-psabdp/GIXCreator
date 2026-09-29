SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spATL_BDP_AccountReconciliation_Rel]'GRUPO ROHM & HAAS','2012-05-01','2012-06-04'
--[spATL_BDP_AccountReconciliation_Rel]'Grupo Styron','2012-05-01','2012-05-31'
--[spATL_BDP_AccountReconciliation_Rel]'Grupo Dow','2012-05-01','2012-05-31'
--MINOR 100-175777 -CADU-13/08/2020

CREATE Procedure	[dbo].[spATL_BDP_AccountReconciliationCorteva_Rel]-- 'GRUPO CORTEVA','2021-05-01','2021-05-31'
(
@Grupo varchar(30),
@DtInicial datetime,
@DtFinal datetime
)
As

	/*
		8/13/2021 - Stored has been created to attend specific Corteva Requirements
			
	*/
	declare @TAB table
	(
	[Date]					datetime,
	[Ordering Customer]		varchar(100),
	[Consignee]				varchar(100),
	[Country of Destination]varchar(100),
	[Order Nbr]				varchar(200),
	[PO]					varchar(200),
	[NF]					Varchar(200),
	[BDP Reference]			varchar(16),
	[Destination]			varchar(100),
	[Payment Date]			datetime,
	[DI Number]				varchar(200),
	[Desembaraço]			datetime,
	[I.I.]					float,
	[I.P.I.]				float,
	[TX. SISC]				float,
	[PIS/PASEP]				float,
	[COFINS]				float,	
	[DIREITOS ANTIDUMPING]	float,
	[TOTAL SISCOMEX]		float,
	[BCO SISCOMEX]			varchar(1),
	[ICMS]					float,
	[BCO ICMS]				varchar(1),
	[TOTAL IMPOSTOS]		float,
	[LABAMA]				varchar(1),
	[AFRMM]					float,	
	[Pgto. AFRMM]			datetime,
	[Pgto. ICMS]			datetime

	)


	

	declare @cd_pes_grupo varchar(10)
	Set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)
	
	Begin
		insert into
			@TAB ([Date],[Ordering Customer],[Consignee],[Country of Destination],[Order Nbr],[PO],[NF],
			[BDP Reference],[Destination],[Payment Date],[DI Number],[Desembaraço],[BCO SISCOMEX],[BCO ICMS],[LABAMA],
			[Pgto. AFRMM],[Pgto. ICMS])
		Select
			convert(datetime,HOU.Dt_Emis_HIM,105)							[Date],
			OC.Nome_Raz_Soc													[Ordering Customer],
			CS.Nome_Raz_Soc													[Consignee],
			LC.Pais_Local													[Country of Destination],
			dbo.fBusca_PO_NumPedido(HOU.Num_Proc_HIM,'Num_Pedido')			[Order Nbr],
			dbo.fBusca_PO_NumPedido(HOU.Num_Proc_HIM,'PO')					[PO],
			dbo.fBusca_TipoDocCliente('N',hou.Num_Proc_HIM,10)				[Nota Fiscal],
			HOU.Num_Proc_HIM												[BDP Reference],
			DST.Nome_Local													[Destination],
			DI.data_PO_him													[Payment Date],
			DI.NUMERO_PO_HIM												[DI Number],
			t4.dt_conclusao													[Desembaraço],		
			''																[BCO SISCOMEX],
			''																[BCO ICMS],			
			''																[LABAMA],	
			t25.dt_conclusao												[Pgto. AFRMM],
			t24.dt_conclusao												[Pgto. ICMS]		
		from 
			House_Imp_MAR			HOU With(nolock)
			Join LLP_Imp_MAR		LLP With(nolock) on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
			Left Join Pedido_Ship 	PS  With(nolock) on HOU.Num_Proc_HIM = PS.Num_Proc
			Left Join Pedido		P	With(nolock)  on PS.Cd_Pedido = P.Cd_Pedido
			Join Pessoa				CS  With(nolock)  on HOU.Cd_Consig_HIM = CS.Cd_Pes	
			Join Pessoa				OC  with(nolock)  on P.Cd_Buyer = OC.Cd_Pes 
			Join Localidade			LC  with(nolock)  on HOU.Cd_Dst_HIM =  LC.Cd_Local
			Join PO_him 			DI  with(nolock)  on DI.Num_Proc_him 	=HOU.Num_Proc_Him and DI.ID_DC = 5
			Join Pessoa_LLP			PLL with(nolock)  on PLL.Cd_Pes=HOU.Cd_Consig_HIM and PLL.Cd_Pes_Grupo=@cd_pes_grupo
			Join Localidade			DST with(nolock)  on DST.cd_local=cd_dst_him
			Left Join tarefas_processos T25 With(nolock)  on T25.num_proc=num_proc_lim and t25.ID_Task=25
			Left Join tarefas_processos T24 With(nolock)  on T24.num_proc=num_proc_lim and t24.ID_Task=24
			Left Join tarefas_processos T4 With(nolock)  on T4.num_proc=num_proc_lim and t4.ID_Task=4
		Where
			DI.data_PO_him is not null
			and DI.numero_po_him not like 'Courier%'
			and DI.data_PO_him between @DtInicial and @DtFinal
		Group By
			HOU.Dt_Emis_HIM,OC.Nome_Raz_Soc,CS.Nome_Raz_Soc,LC.Pais_Local,HOU.Num_Proc_HIM,DI.data_PO_him,
			DST.Nome_Local,t4.dt_conclusao,t24.dt_conclusao,t25.dt_conclusao,
			DI.NUMERO_PO_HIM

		UNION ALL

		Select 
			convert(datetime,HOU.Dt_Emis_HIA,105)							[Date],
			OC.Nome_Raz_Soc													[Ordering Customer],
			CS.Nome_Raz_Soc													[Consignee],
			LC.Pais_Local													[Country of Destination],
			dbo.fBusca_PO_NumPedido(HOU.Num_Proc_HIA,'Num_Pedido')			[Order Nbr]	,
			dbo.fBusca_PO_NumPedido(HOU.Num_Proc_HIA,'PO')					[PO],
			dbo.fBusca_TipoDocCliente('N',hou.Num_Proc_HIA,10)				[Nota Fiscal],
			HOU.Num_Proc_HIA												[BDP Reference],
			DST.Nome_Local													[Destination],
			DI.data_PO_hia													[Payment Date],
			DI.NUMERO_PO_HIa												[DI Number],
			t4.dt_conclusao													[Desembaraço],	
			''																[BCO SISCOMEX],
			''																[BCO ICMS],			
			''																[LABAMA],	
			t25.dt_conclusao												[Pgto. AFRMM],
			t24.dt_conclusao												[Pgto. ICMS]	
		from 
			House_Imp_Aer HOU with(nolock) 
			Join LLP_Imp_Aer	LLP with(nolock)  on HOU.Num_Proc_HIA = LLP.Num_Proc_Lia
			Left Join Pedido_Ship 	PS  with(nolock)  on HOU.Num_Proc_HIA = PS.Num_Proc
			Left Join Pedido		P   with(nolock)  on PS.Cd_Pedido = P.Cd_Pedido
			Join Pessoa			CS with(nolock)   on HOU.Cd_Consig_HIA = CS.Cd_Pes and CS.desat_pes = 'N'
			Join Pessoa			OC  with(nolock)  on P.Cd_Buyer = OC.Cd_Pes and OC.desat_pes = 'N'
			Join Localidade		LC  with(nolock)  on HOU.Cd_Dst_HIA =  LC.Cd_Local
			Left Join PO_hia 	DI  with(nolock)  on DI.Num_Proc_hia 	=HOU.Num_Proc_Hia and DI.ID_DC = 5
			Join Pessoa_LLP		PLL with(nolock)  on PLL.Cd_Pes=HOU.Cd_Consig_HIA and PLL.Cd_Pes_Grupo=@cd_pes_grupo
			Join Localidade		DST with(nolock)  on DST.cd_local=cd_dst_hia
			Left Join tarefas_processos T25 With(nolock)  on T25.num_proc=num_proc_lia and t25.ID_Task=25
			Left Join tarefas_processos T24 With(nolock)  on T24.num_proc=num_proc_lia and t24.ID_Task=24
			Left Join tarefas_processos T4 With(nolock)  on T4.num_proc=num_proc_lia and t4.ID_Task=4
		Where
			DI.data_PO_hia is not null
			and DI.numero_po_hia not like 'Courier%'
			and DI.data_PO_hia between @DtInicial and @DtFinal
		Group by
			HOU.Dt_Emis_HIA,OC.Nome_Raz_Soc,CS.Nome_Raz_Soc,LC.Pais_Local,HOU.Num_Proc_HIA,DI.data_PO_hia,DST.Nome_Local,
			t4.dt_conclusao,t24.dt_conclusao,t25.dt_conclusao,
			DI.NUMERO_PO_HIa

		UNION ALL

		Select 
			convert(datetime,HOU.Dt_Emis_HIO,105)							[Date],
			OC.Nome_Raz_Soc													[Ordering Customer],
			CS.Nome_Raz_Soc													[Consignee],
			LC.Pais_Local													[Country of Destination],
			dbo.fBusca_PO_NumPedido(HOU.Num_Proc_HIO,'Num_Pedido')			[Order Nbr]	,
			dbo.fBusca_PO_NumPedido(HOU.Num_Proc_HIO,'PO')					[PO],
			dbo.fBusca_TipoDocCliente('N',hou.Num_Proc_HIO,10)				[Nota Fiscal],
			HOU.Num_Proc_HIO												[BDP Reference],
			DST.Nome_Local													[Destination],
			DI.data_PO_hio													[Payment Date],
			DI.NUMERO_PO_HIO												[DI Number],
			t4.dt_conclusao													[Desembaraço],			
			''																[BCO SISCOMEX],	
			''																[BCO ICMS],			
			''																[LABAMA],			
			t25.dt_conclusao												[Pgto. AFRMM],
			t24.dt_conclusao												[Pgto. ICMS]
		from
			House_IMP_OUT HOU	with(nolock) 
			Join LLP_IMP_OUT	LLP with(nolock)  on HOU.Num_Proc_HIO = LLP.Num_Proc_LIO
			Join Pedido_Ship 	PS  with(nolock)  on HOU.Num_Proc_HIO = PS.Num_Proc
			Join Pedido			P   with(nolock)  on PS.Cd_Pedido = P.Cd_Pedido
			Join Pessoa			CS  with(nolock)  on HOU.Cd_Consig_HIO = CS.Cd_Pes	and CS.desat_pes = 'N'
			Join Pessoa			OC  with(nolock)  on P.Cd_Buyer = OC.Cd_Pes and OC.desat_pes = 'N'
			Join Localidade		LC  with(nolock)  on HOU.Cd_Dst_HIO =  LC.Cd_Local
			--Join Custo_Cliente	CU  on HOU.Num_Proc_HIO=CU.Num_Proc
			Left Join PO_hio 	DI  with(nolock)  on DI.Num_Proc_hio 	=HOU.Num_Proc_Hio and DI.ID_DC = 5
		--	Join Pessoa_LLP		PLL on PLL.Cd_Pes=CS.Cd_Pes and PLL.Cd_Pes_Grupo='1'
			Join Pessoa_LLP		PLL with(nolock)  on PLL.Cd_Pes=HOU.Cd_Consig_HIO and PLL.Cd_Pes_Grupo=@cd_pes_grupo
			Join Localidade		DST with(nolock)  on DST.cd_local=cd_dst_hio
			Left Join tarefas_processos T25 With(nolock)  on T25.num_proc=num_proc_liO and t25.ID_Task=25
			Left Join tarefas_processos T24 With(nolock)  on T24.num_proc=num_proc_liO and t24.ID_Task=24
			Left Join tarefas_processos T4 With(nolock)  on T4.num_proc=num_proc_liO and t4.ID_Task=4
		Where
			DI.data_PO_hio is not null
			and DI.numero_po_hio not like 'Courier%'	
			and DI.data_PO_hio between @DtInicial and @DtFinal
		Group by
			convert(datetime,Dt_Emis_HIO,105),OC.Nome_Raz_Soc,CS.Nome_Raz_Soc,LC.Pais_Local,HOU.Num_Proc_HIO,DI.Data_PO_hio,
			DST.Nome_Local,t4.dt_conclusao,t24.dt_conclusao,t25.dt_conclusao,
			DI.numero_po_hio
	End

	Begin
		--Update com base na CUSTO_ProcessoTAB
		Update @TAB
		set
		[I.I.] = dbo.fBusca_CustoProcessoTAB([BDP Reference],'%Imposto de Imp%'),
		[I.P.I.] = (dbo.fBusca_CustoProcessoTAB([BDP Reference],'%Impos% Prod% Ind%') +  dbo.fBusca_CustoProcessoTAB([BDP Reference],'IPI%')),
		[TX. SISC] = dbo.fBusca_CustoProcessoTAB([BDP Reference],'%SISComeX%')	,
		[PIS/PASEP] = dbo.fBusca_CustoProcessoTAB([BDP Reference],'%PIS%'),
		[COFINS] = dbo.fBusca_CustoProcessoTAB([BDP Reference],'%Cofins%'),
		[DIREITOS ANTIDUMPING] = dbo.fBusca_CustoProcessoTAB([BDP Reference],'%DUMPING%'),
		[ICMS] = dbo.fBusca_CustoProcessoTAB([BDP Reference],'%ICMS%'),
		[AFRMM] = dbo.fBusca_CustoProcessoTAB([BDP Reference],'%AFRMM%')	
	End

	Begin
		Update @TAB
		set
			--Total Siscomex = vlr_II + vlr_IPI + vlr_SISC + vlr_PIS + vlr_Cofins + vlr_ANTIDUMPING)
			[TOTAL SISCOMEX]= [I.I.] + [I.P.I.] + [TX. SISC] + [PIS/PASEP] + [COFINS] + [DIREITOS ANTIDUMPING]
	End

	Begin
		Update @TAB
		set
		--TOTAL IMPOSTOS = vlr_II + vlr_IPI + vlr_SISC + vlr_PIS + vlr_Cofins + vlr_ICMS + vlr_ANTIDUMPING)
		[TOTAL IMPOSTOS] =	[TOTAL SISCOMEX] +  [ICMS]		
	End

	select * from @TAB where [Payment Date] is not null order by 9


GO
