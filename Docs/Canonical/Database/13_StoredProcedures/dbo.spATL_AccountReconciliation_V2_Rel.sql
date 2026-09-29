SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spATL_AccountReconciliation_V2_Rel]'GRUPO ROHM & HAAS','2012-05-01','2012-06-04'
--[spATL_AccountReconciliation_V2_Rel]'Grupo Styron','2012-05-01','2012-05-31'
--[spATL_AccountReconciliation_V2_Rel]'Grupo Dow','2012-05-01','2012-05-31'

CREATE Procedure	[dbo].[spATL_AccountReconciliation_V2_Rel]-- 'Grupo Dow','2013-12-01','2013-12-31'
	@Grupo varchar(30),
	@DtInicial datetime,
	@DtFinal datetime
As

declare @TAB table
	(
	[Month]					varchar(20),	
	[Ordering Customer]		varchar(max),
	[Consignee]				varchar(max),
	[Country of Destination]varchar(100),
	[SAP Order nbr]			varchar(max),
	[PO]					varchar(max),
	[BDP Reference]			varchar(16),
	[Destination]			varchar(100),
	[Payment Date]			datetime,
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
	[Pgto. ICMS]			datetime,
	[N.Transmissao]         Varchar(max)
	)

	declare @cd_pes_grupo varchar(10)
	Set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa With(nolock) where apelido=@Grupo)
	
	Begin
		insert into
			@TAB ([Month],[Ordering Customer],[Consignee],[Country of Destination],[SAP Order nbr]	,[PO],
			[BDP Reference],[Destination],[Payment Date],[Desembaraço],[BCO SISCOMEX],[BCO ICMS],[LABAMA],
			[Pgto. AFRMM],[Pgto. ICMS],[N.Transmissao] )
		--Select
		--	(datename(MM,DI.data_PO_him) + ' - ' + convert(char(4),year(DI.data_PO_him)))[Month],
		--	OC.Nome_Raz_Soc													[Ordering Customer],
		--	CS.Nome_Raz_Soc													[Consignee],
		--	LC.Pais_Local													[Country of Destination],
		--	dbo.fBusca_PO_NumPedido(HOU.Num_Proc_HIM,'Num_Pedido')			[Order Nbr],
		--	dbo.fBusca_PO_NumPedido(HOU.Num_Proc_HIM,'PO')					[PO],
		--	HOU.Num_Proc_HIM												[BDP Reference],
		--	DST.Nome_Local													[Destination],
		--	DI.data_PO_him													[Payment Date],
		--	t4.dt_conclusao													[Desembaraço],		
		--	''																[BCO SISCOMEX],
		--	''																[BCO ICMS],			
		--	''																[LABAMA],	
		--	t25.dt_conclusao												[Pgto. AFRMM],
		--	t24.dt_conclusao												[Pgto. ICMS]		,
		--	dbo.fBusca_TipoDocCliente ('N',hou.num_proc_him,68) [N.Transmissao] 
		--from 
		--	House_Imp_MAR			HOU With(nolock)
		--	Join LLP_Imp_MAR		LLP With(nolock) on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
		--	Left Join Pedido_Ship 	PS  With(nolock) on HOU.Num_Proc_HIM = PS.Num_Proc
		--	Left Join Pedido		P	With(nolock)  on PS.Cd_Pedido = P.Cd_Pedido
		--	Join Pessoa				CS  With(nolock)  on HOU.Cd_Consig_HIM = CS.Cd_Pes	
		--	Join Pessoa				OC  with(nolock)  on P.Cd_Buyer = OC.Cd_Pes 
		--	Join Localidade			LC  with(nolock)  on HOU.Cd_Dst_HIM =  LC.Cd_Local
		--	left Join PO_him 		DI  with(nolock)  on DI.Num_Proc_him =HOU.Num_Proc_Him and DI.ID_DC = 5
		----	left Join PO_him 		T  with(nolock)  on DI.Num_Proc_him =HOU.Num_Proc_Him and T.ID_DC = 5

		--	Join Pessoa_LLP			PLL with(nolock)  on PLL.Cd_Pes=HOU.Cd_Consig_HIM and PLL.Cd_Pes_Grupo=@cd_pes_grupo
		--	Join Localidade			DST with(nolock)  on DST.cd_local=cd_dst_him
		--	Left Join tarefas_processos T25 With(nolock)  on T25.num_proc=num_proc_lim and t25.ID_Task=25
		--	Left Join tarefas_processos T24 With(nolock)  on T24.num_proc=num_proc_lim and t24.ID_Task=24
		--	Left Join tarefas_processos T4 With(nolock)  on T4.num_proc=num_proc_lim and t4.ID_Task=4
		--Where
		--	(ATA_LIM between @DtInicial and @DtFinal or DI.data_po_him between @DtInicial and @DtFinal)
		--Group By
		--	HOU.Dt_Emis_HIM,OC.Nome_Raz_Soc,CS.Nome_Raz_Soc,LC.Pais_Local,HOU.Num_Proc_HIM,DI.data_PO_him,
		--	DST.Nome_Local,t4.dt_conclusao,t24.dt_conclusao,t25.dt_conclusao
--Alterado em 11/03/2026 solicitado por Luciana e alterado por Leandro
		SELECT
    (DATENAME(MM, COALESCE(DI.data_PO_him, DUIMP.data_PO_him)) + ' - ' +
    CONVERT(char(4), YEAR(COALESCE(DI.data_PO_him, DUIMP.data_PO_him)))) AS [Month],
    OC.Nome_Raz_Soc                                                  [Ordering Customer],
    CS.Nome_Raz_Soc                                                  [Consignee],
    LC.Pais_Local                                                    [Country of Destination],
    dbo.fBusca_PO_NumPedido(HOU.Num_Proc_HIM,'Num_Pedido')           [Order Nbr],
    dbo.fBusca_PO_NumPedido(HOU.Num_Proc_HIM,'PO')                   [PO],
    HOU.Num_Proc_HIM                                                 [BDP Reference],
    DST.Nome_Local                                                   [Destination],
    COALESCE(DI.data_PO_him, DUIMP.data_PO_him)                      [Payment Date],
    t4.dt_conclusao                                                  [Desembaraço],     
    ''                                                               [BCO SISCOMEX],
    ''                                                               [BCO ICMS],         
    ''                                                               [LABAMA],   
    t25.dt_conclusao                                                 [Pgto. AFRMM],
    t24.dt_conclusao                                                 [Pgto. ICMS],
    COALESCE(
        dbo.fBusca_TipoDocCliente('N', hou.num_proc_him, 68),
        dbo.fBusca_TipoDocCliente('N', hou.num_proc_him, 288)
    ) AS [N.Transmissao]
FROM 
    House_Imp_MAR            HOU   WITH(NOLOCK)
    JOIN LLP_Imp_MAR         LLP   WITH(NOLOCK) ON HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
    LEFT JOIN Pedido_Ship    PS    WITH(NOLOCK) ON HOU.Num_Proc_HIM = PS.Num_Proc
    LEFT JOIN Pedido         P     WITH(NOLOCK) ON PS.Cd_Pedido = P.Cd_Pedido
    JOIN Pessoa              CS    WITH(NOLOCK) ON HOU.Cd_Consig_HIM = CS.Cd_Pes
    JOIN Pessoa              OC    WITH(NOLOCK) ON P.Cd_Buyer = OC.Cd_Pes
    JOIN Localidade          LC    WITH(NOLOCK) ON HOU.Cd_Dst_HIM = LC.Cd_Local
    LEFT JOIN PO_him         DI    WITH(NOLOCK) ON DI.Num_Proc_him = HOU.Num_Proc_Him AND DI.ID_DC = 5
    LEFT JOIN PO_him         DUIMP WITH(NOLOCK) ON DUIMP.Num_Proc_him = HOU.Num_Proc_Him AND DUIMP.ID_DC = 237
    JOIN Pessoa_LLP          PLL   WITH(NOLOCK) ON PLL.Cd_Pes = HOU.Cd_Consig_HIM AND PLL.Cd_Pes_Grupo = @cd_pes_grupo
    JOIN Localidade          DST   WITH(NOLOCK) ON DST.cd_local = cd_dst_him
    LEFT JOIN tarefas_processos T25 WITH(NOLOCK) ON T25.num_proc = num_proc_lim AND T25.ID_Task = 25
    LEFT JOIN tarefas_processos T24 WITH(NOLOCK) ON T24.num_proc = num_proc_lim AND T24.ID_Task = 24
    LEFT JOIN tarefas_processos T4  WITH(NOLOCK) ON T4.num_proc = num_proc_lim AND T4.ID_Task = 4
WHERE
    (ATA_LIM BETWEEN @DtInicial AND @DtFinal 
     OR COALESCE(DI.data_po_him, DUIMP.data_po_him) BETWEEN @DtInicial AND @DtFinal)
GROUP BY
    HOU.Dt_Emis_HIM,
    OC.Nome_Raz_Soc,
    CS.Nome_Raz_Soc,
    LC.Pais_Local,
    HOU.Num_Proc_HIM,
    COALESCE(DI.data_PO_him, DUIMP.data_PO_him),
    DST.Nome_Local,
    t4.dt_conclusao,
    t24.dt_conclusao,
    t25.dt_conclusao

		UNION ALL

		--Select 
		--	datename(MM,DI.data_PO_hia) + ' - ' + convert(char(4),year(DI.data_PO_hia))[Month],
		--	OC.Nome_Raz_Soc													[Ordering Customer],
		--	CS.Nome_Raz_Soc													[Consignee],
		--	LC.Pais_Local													[Country of Destination],
		--	dbo.fBusca_PO_NumPedido(HOU.Num_Proc_HIA,'Num_Pedido')			[Order Nbr]	,
		--	dbo.fBusca_PO_NumPedido(HOU.Num_Proc_HIA,'PO')					[PO],
		--	HOU.Num_Proc_HIA												[BDP Reference],
		--	DST.Nome_Local													[Destination],
		--	DI.data_PO_hia													[Payment Date],
		--	t4.dt_conclusao													[Desembaraço],	
		--	''																[BCO SISCOMEX],
		--	''																[BCO ICMS],			
		--	''																[LABAMA],	
		--	t25.dt_conclusao												[Pgto. AFRMM],
		--	t24.dt_conclusao												[Pgto. ICMS]	,
		--		dbo.fBusca_TipoDocCliente ('N',hou.num_proc_hia,68) [N.Transmissao] 
		--from 
		--	House_Imp_Aer			HOU with(nolock) 
		--	Join LLP_Imp_Aer		LLP with(nolock) on HOU.Num_Proc_HIA = LLP.Num_Proc_Lia
		--	Left Join Pedido_Ship 	PS  with(nolock) on HOU.Num_Proc_HIA = PS.Num_Proc
		--	Left Join Pedido		P   with(nolock) on PS.Cd_Pedido = P.Cd_Pedido
		--	Join Pessoa				CS  with(nolock) on HOU.Cd_Consig_HIA = CS.Cd_Pes and CS.desat_pes = 'N'
		--	Join Pessoa				OC  with(nolock) on P.Cd_Buyer = OC.Cd_Pes and OC.desat_pes = 'N'
		--	Join Localidade			LC  with(nolock) on HOU.Cd_Dst_HIA =  LC.Cd_Local
		--	Left Join PO_hia 		DI  with(nolock) on DI.Num_Proc_hia 	=HOU.Num_Proc_Hia and DI.ID_DC = 5
		--	Join Pessoa_LLP			PLL with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIA and PLL.Cd_Pes_Grupo=@cd_pes_grupo
		--	Join Localidade			DST with(nolock) on DST.cd_local=cd_dst_hia
		--	Left Join tarefas_processos T25 With(nolock) on T25.num_proc=num_proc_lia and t25.ID_Task=25
		--	Left Join tarefas_processos T24 With(nolock) on T24.num_proc=num_proc_lia and t24.ID_Task=24
		--	Left Join tarefas_processos T4  With(nolock) on T4.num_proc=num_proc_lia and t4.ID_Task=4
		--Where
		--	(ATA_LIA between @DtInicial and @DtFinal or DI.data_po_hia between @DtInicial and @DtFinal)
		--Group by
		--	HOU.Dt_Emis_HIA,OC.Nome_Raz_Soc,CS.Nome_Raz_Soc,LC.Pais_Local,HOU.Num_Proc_HIA,DI.data_PO_hia,DST.Nome_Local,
		--	t4.dt_conclusao,t24.dt_conclusao,t25.dt_conclusao

		SELECT 
    (
        DATENAME(MM, COALESCE(DI.data_PO_hia, DUIMP.data_PO_hia)) + ' - ' + 
        CONVERT(char(4), YEAR(COALESCE(DI.data_PO_hia, DUIMP.data_PO_hia)))
    ) AS [Month],
    OC.Nome_Raz_Soc                                                                 [Ordering Customer],
    CS.Nome_Raz_Soc                                                                 [Consignee],
    LC.Pais_Local                                                                   [Country of Destination],
    dbo.fBusca_PO_NumPedido(HOU.Num_Proc_HIA,'Num_Pedido')                          [Order Nbr],
    dbo.fBusca_PO_NumPedido(HOU.Num_Proc_HIA,'PO')                                  [PO],
    HOU.Num_Proc_HIA                                                                [BDP Reference],
    DST.Nome_Local                                                                  [Destination],
    COALESCE(DI.data_PO_hia, DUIMP.data_PO_hia)                                     [Payment Date],
    t4.dt_conclusao                                                                 [Desembaraço],
    ''                                                                              [BCO SISCOMEX],
    ''                                                                              [BCO ICMS],
    ''                                                                              [LABAMA],
    t25.dt_conclusao                                                                [Pgto. AFRMM],
    t24.dt_conclusao                                                                [Pgto. ICMS],
    COALESCE(
        dbo.fBusca_TipoDocCliente('N', hou.num_proc_hia, 68),
        dbo.fBusca_TipoDocCliente('N', hou.num_proc_hia, 288)
    ) AS [N.Transmissao]
FROM 
    House_Imp_Aer           HOU   WITH(NOLOCK)
    JOIN LLP_Imp_Aer        LLP   WITH(NOLOCK) ON HOU.Num_Proc_HIA = LLP.Num_Proc_LIA
    LEFT JOIN Pedido_Ship   PS    WITH(NOLOCK) ON HOU.Num_Proc_HIA = PS.Num_Proc
    LEFT JOIN Pedido        P     WITH(NOLOCK) ON PS.Cd_Pedido = P.Cd_Pedido
    JOIN Pessoa             CS    WITH(NOLOCK) ON HOU.Cd_Consig_HIA = CS.Cd_Pes AND CS.desat_pes = 'N'
    JOIN Pessoa             OC    WITH(NOLOCK) ON P.Cd_Buyer = OC.Cd_Pes AND OC.desat_pes = 'N'
    JOIN Localidade         LC    WITH(NOLOCK) ON HOU.Cd_Dst_HIA = LC.Cd_Local
    LEFT JOIN PO_hia        DI    WITH(NOLOCK) ON DI.Num_Proc_hia = HOU.Num_Proc_HIA AND DI.ID_DC = 5
    LEFT JOIN PO_hia        DUIMP WITH(NOLOCK) ON DUIMP.Num_Proc_hia = HOU.Num_Proc_HIA AND DUIMP.ID_DC = 237
    JOIN Pessoa_LLP         PLL   WITH(NOLOCK) ON PLL.Cd_Pes = HOU.Cd_Consig_HIA AND PLL.Cd_Pes_Grupo = @cd_pes_grupo
    JOIN Localidade         DST   WITH(NOLOCK) ON DST.cd_local = cd_dst_hia
    LEFT JOIN tarefas_processos T25 WITH(NOLOCK) ON T25.num_proc = num_proc_lia AND T25.ID_Task = 25
    LEFT JOIN tarefas_processos T24 WITH(NOLOCK) ON T24.num_proc = num_proc_lia AND T24.ID_Task = 24
    LEFT JOIN tarefas_processos T4  WITH(NOLOCK) ON T4.num_proc = num_proc_lia AND T4.ID_Task = 4
WHERE
    (
        ATA_LIA BETWEEN @DtInicial AND @DtFinal
        OR COALESCE(DI.data_PO_hia, DUIMP.data_PO_hia) BETWEEN @DtInicial AND @DtFinal
    )
GROUP BY
    HOU.Dt_Emis_HIA,
    OC.Nome_Raz_Soc,
    CS.Nome_Raz_Soc,
    LC.Pais_Local,
    HOU.Num_Proc_HIA,
    COALESCE(DI.data_PO_hia, DUIMP.data_PO_hia),
    DST.Nome_Local,
    t4.dt_conclusao,
    t24.dt_conclusao,
    t25.dt_conclusao

		UNION ALL

		--Select 
		--	datename(MM,DI.data_PO_hio) + ' - ' + convert(char(4),year(DI.data_PO_hio))[Month],
		--	OC.Nome_Raz_Soc													[Ordering Customer],
		--	CS.Nome_Raz_Soc													[Consignee],
		--	LC.Pais_Local													[Country of Destination],
		--	dbo.fBusca_PO_NumPedido(HOU.Num_Proc_HIO,'Num_Pedido')			[Order Nbr]	,
		--	dbo.fBusca_PO_NumPedido(HOU.Num_Proc_HIO,'PO')					[PO],
		--	HOU.Num_Proc_HIO												[BDP Reference],
		--	DST.Nome_Local													[Destination],
		--	DI.data_PO_hio													[Payment Date],
		--	t4.dt_conclusao													[Desembaraço],			
		--	''																[BCO SISCOMEX],	
		--	''																[BCO ICMS],			
		--	''																[LABAMA],			
		--	t25.dt_conclusao												[Pgto. AFRMM],
		--	t24.dt_conclusao												[Pgto. ICMS],
		--		dbo.fBusca_TipoDocCliente ('N',hou.num_proc_hio,68) [N.Transmissao] 
		--from
		--	House_IMP_OUT		HOU	with(nolock) 
		--	Join LLP_IMP_OUT	LLP with(nolock) on HOU.Num_Proc_HIO = LLP.Num_Proc_LIO
		--	Join Pedido_Ship 	PS  with(nolock) on HOU.Num_Proc_HIO = PS.Num_Proc
		--	Join Pedido			P   with(nolock) on PS.Cd_Pedido = P.Cd_Pedido
		--	Join Pessoa			CS  with(nolock) on HOU.Cd_Consig_HIO = CS.Cd_Pes	and CS.desat_pes = 'N'
		--	Join Pessoa			OC  with(nolock) on P.Cd_Buyer = OC.Cd_Pes and OC.desat_pes = 'N'
		--	Join Localidade		LC  with(nolock) on HOU.Cd_Dst_HIO =  LC.Cd_Local
		--	Left Join PO_hio 	DI  with(nolock) on DI.Num_Proc_hio 	=HOU.Num_Proc_Hio and DI.ID_DC = 5
		--	Join Pessoa_LLP		PLL with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIO and PLL.Cd_Pes_Grupo=@cd_pes_grupo
		--	Join Localidade		DST with(nolock) on DST.cd_local=cd_dst_hio
		--	Left Join tarefas_processos T25 With(nolock) on T25.num_proc=num_proc_liO and t25.ID_Task=25
		--	Left Join tarefas_processos T24 With(nolock) on T24.num_proc=num_proc_liO and t24.ID_Task=24
		--	Left Join tarefas_processos T4	With(nolock)  on T4.num_proc=num_proc_liO and t4.ID_Task=4
		--Where
		--	(ATA_LIO between @DtInicial and @DtFinal or DI.data_po_hio between @DtInicial and @DtFinal)
		--Group by
		--	convert(datetime,Dt_Emis_HIO,105),OC.Nome_Raz_Soc,CS.Nome_Raz_Soc,LC.Pais_Local,HOU.Num_Proc_HIO,DI.Data_PO_hio,
		--	DST.Nome_Local,t4.dt_conclusao,t24.dt_conclusao,t25.dt_conclusao

		SELECT 
    (
        DATENAME(MM, COALESCE(DI.data_PO_hio, DUIMP.data_PO_hio)) + ' - ' + 
        CONVERT(char(4), YEAR(COALESCE(DI.data_PO_hio, DUIMP.data_PO_hio)))
    ) AS [Month],
    OC.Nome_Raz_Soc                                                                 [Ordering Customer],
    CS.Nome_Raz_Soc                                                                 [Consignee],
    LC.Pais_Local                                                                   [Country of Destination],
    dbo.fBusca_PO_NumPedido(HOU.Num_Proc_HIO,'Num_Pedido')                          [Order Nbr],
    dbo.fBusca_PO_NumPedido(HOU.Num_Proc_HIO,'PO')                                  [PO],
    HOU.Num_Proc_HIO                                                                [BDP Reference],
    DST.Nome_Local                                                                  [Destination],
    COALESCE(DI.data_PO_hio, DUIMP.data_PO_hio)                                     [Payment Date],
    t4.dt_conclusao                                                                 [Desembaraço],
    ''                                                                              [BCO SISCOMEX],
    ''                                                                              [BCO ICMS],
    ''                                                                              [LABAMA],
    t25.dt_conclusao                                                                [Pgto. AFRMM],
    t24.dt_conclusao                                                                [Pgto. ICMS],
    COALESCE(
        dbo.fBusca_TipoDocCliente('N', hou.num_proc_hio, 68),
        dbo.fBusca_TipoDocCliente('N', hou.num_proc_hio, 288)
    ) AS [N.Transmissao]
FROM
    House_IMP_OUT      HOU   WITH(NOLOCK)
    JOIN LLP_IMP_OUT   LLP   WITH(NOLOCK) ON HOU.Num_Proc_HIO = LLP.Num_Proc_LIO
    JOIN Pedido_Ship   PS    WITH(NOLOCK) ON HOU.Num_Proc_HIO = PS.Num_Proc
    JOIN Pedido        P     WITH(NOLOCK) ON PS.Cd_Pedido = P.Cd_Pedido
    JOIN Pessoa        CS    WITH(NOLOCK) ON HOU.Cd_Consig_HIO = CS.Cd_Pes AND CS.desat_pes = 'N'
    JOIN Pessoa        OC    WITH(NOLOCK) ON P.Cd_Buyer = OC.Cd_Pes AND OC.desat_pes = 'N'
    JOIN Localidade    LC    WITH(NOLOCK) ON HOU.Cd_Dst_HIO = LC.Cd_Local
    LEFT JOIN PO_hio   DI    WITH(NOLOCK) ON DI.Num_Proc_hio = HOU.Num_Proc_HIO AND DI.ID_DC = 5
    LEFT JOIN PO_hio   DUIMP WITH(NOLOCK) ON DUIMP.Num_Proc_hio = HOU.Num_Proc_HIO AND DUIMP.ID_DC = 237
    JOIN Pessoa_LLP    PLL   WITH(NOLOCK) ON PLL.Cd_Pes = HOU.Cd_Consig_HIO AND PLL.Cd_Pes_Grupo = @cd_pes_grupo
    JOIN Localidade    DST   WITH(NOLOCK) ON DST.cd_local = cd_dst_hio
    LEFT JOIN tarefas_processos T25 WITH(NOLOCK) ON T25.num_proc = num_proc_lio AND T25.ID_Task = 25
    LEFT JOIN tarefas_processos T24 WITH(NOLOCK) ON T24.num_proc = num_proc_lio AND T24.ID_Task = 24
    LEFT JOIN tarefas_processos T4  WITH(NOLOCK) ON T4.num_proc = num_proc_lio AND T4.ID_Task = 4
WHERE
    (
        ATA_LIO BETWEEN @DtInicial AND @DtFinal
        OR COALESCE(DI.data_PO_hio, DUIMP.data_PO_hio) BETWEEN @DtInicial AND @DtFinal
    )
GROUP BY
    CONVERT(datetime, Dt_Emis_HIO, 105),
    OC.Nome_Raz_Soc,
    CS.Nome_Raz_Soc,
    LC.Pais_Local,
    HOU.Num_Proc_HIO,
    COALESCE(DI.data_PO_hio, DUIMP.data_PO_hio),
    DST.Nome_Local,
    t4.dt_conclusao,
    t24.dt_conclusao,
    t25.dt_conclusao
	Option (hash JOIN)
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
		where 
			[Payment Date] is not null
	End

	Begin
		Update @TAB
		set
			--Total Siscomex = vlr_II + vlr_IPI + vlr_SISC + vlr_PIS + vlr_Cofins + vlr_ANTIDUMPING)
			[TOTAL SISCOMEX]= [I.I.] + [I.P.I.] + [TX. SISC] + [PIS/PASEP] + [COFINS] + [DIREITOS ANTIDUMPING]
		where 
			[Payment Date] is not null
	End

	Begin
		Update @TAB
		set
			--TOTAL IMPOSTOS = vlr_II + vlr_IPI + vlr_SISC + vlr_PIS + vlr_Cofins + vlr_ICMS + vlr_ANTIDUMPING)
			[TOTAL IMPOSTOS] =	[TOTAL SISCOMEX] +  [ICMS]
		where 
			[Payment Date] is not null		
	End

	select * from @TAB where [Payment Date] is not null



GO
