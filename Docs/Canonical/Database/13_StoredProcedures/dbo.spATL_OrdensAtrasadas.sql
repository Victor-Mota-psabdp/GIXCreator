SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spATL_OrdensAtrasadas] 'P20904,1'
CREATE procedure [dbo].[spATL_OrdensAtrasadas]
		@Grupo varchar(8)

as
declare @TAB table
	(
		[STATUS]	VARCHAR(10),
		[ORDEM]		VARCHAR(100),
		[NUMERO PO]	VARCHAR(100),
		[CUSTOMER PO]	VARCHAR(100),
		[PO GROUP]	VARCHAR(5),
		[ETD]	DATETIME,
		[ATD]	DATETIME,	
		[ETA]	DATETIME,
		[ATA]	DATETIME,
		[PRESENÇA - PREVISÃO]	DATETIME,
		[PRESENÇA - CONCLUSÃO]	DATETIME,
		[REGISTRO DI - PREVISÃO]	DATETIME,
		[REGISTRO DI - CONCLUSÃO]	DATETIME,
		[PARAMETRIZAÇÃO - PREVISÃO]	DATETIME,
		[PARAMETRIZAÇÃO - CONCLUSÃO]	DATETIME,
		[DESEMBARAÇO - PREVISÃO]	DATETIME,
		[DESEMBARAÇO - CONCLUSÃO]	DATETIME,
		[ENTREGA TRANSP. - PREVISÃO]	DATETIME,
		[ENTREGA TRANSP. - CONCLUSÃO]	DATETIME,
		[ENTREGA PLANTA - PREVISÃO]	DATETIME,
		[DIAS EM ATRASO]	INT,
		[PO REQ. DATE - ORIGINAL]	DATETIME,
		[PO REQ. DATE - AJUSTADO]	DATETIME,
		[JOB]						VARCHAR(16),
		[HISTÓRICO]					VARCHAR(2000),
		[SAP - CONTACT]				VARCHAR(50),
		[CSR - DESK]					VARCHAR(50),
		--Não são exibidos no excel.
		[DI_DATA]					DATETIME,
		[CANAL]						VARCHAR(50),
		[MODAL]						Char(2)
		)
	
Begin
	Insert into @TAB(
		[STATUS],[ORDEM],[NUMERO PO],[CUSTOMER PO],
		[PO GROUP],[ETD],[ATD],[ETA],[ATA],[PRESENÇA - PREVISÃO],[PRESENÇA - CONCLUSÃO],[REGISTRO DI - PREVISÃO],
		[REGISTRO DI - CONCLUSÃO],[PARAMETRIZAÇÃO - PREVISÃO],[PARAMETRIZAÇÃO - CONCLUSÃO],[DESEMBARAÇO - PREVISÃO],[DESEMBARAÇO - CONCLUSÃO],
		[ENTREGA TRANSP. - PREVISÃO],[ENTREGA TRANSP. - CONCLUSÃO],[ENTREGA PLANTA - PREVISÃO],[DIAS EM ATRASO],
		[PO REQ. DATE - ORIGINAL],[PO REQ. DATE - AJUSTADO],[JOB],[HISTÓRICO],[SAP - CONTACT],[CSR - DESK],[DI_DATA],
		[CANAL],[MODAL])
		select DISTINCT
			'OK'						[STATUS],
			Num_pedido					[Ordem],
			num_po						[NUMERO PO],
			Customer_PO					[CUSTOMER PO],
			PO_GRP						[PO GROUP],
			ETD_LIA						[ETD],
			ATD_LIA						[ATD],
			ETA_LIA						[ETA],
			ATA_LIA						[ATA],
			NULL						[PRESENÇA - PREVISÃO],
			Presenca.Dt_Conclusao		[PRESENÇA - CONCLUSÃO],
			(Case WHEN ATA_LIA is null THEN ETA_LIA + 2 ELSE ATA_LIA + 2 END)	[REGISTRO DI - PREVISÃO],
			Registro.dt_previsao		[REGISTRO DI - CONCLUSÃO],
			(Case WHEN ATA_LIA is null THEN ETA_LIA + 3 ELSE ATA_LIA + 3 END) [PARAMETRIZAÇÃO - PREVISÃO],
			NULL						[PARAMETRIZAÇÃO - CONCLUSÃO],
			(Case WHEN ATA_LIA is null THEN ETA_LIA + 6 ELSE ATA_LIA + 6 END) [DESEMBARAÇO - PREVISÃO],
			DDP.dt_conclusao			[DESEMBARAÇO - CONCLUSÃO],
			NULL						[ENTREGA TRANSP. - PREVISÃO],
			NULL						[ENTREGA TRANSP. - CONCLUSÃO],
			(Case WHEN ATA_LIA is null THEN ETA_LIA + 9 ELSE ATA_LIA + 9 END)[ENTREGA PLANTA - PREVISÃO],
			0							[DIAS EM ATRASO],
			DL_Chegada					[PO REQ. DATE - ORIGINAL],
			NULL						[PO REQ. DATE - AJUSTADO],
			Num_Proc_lia				[JOB],
			dbo.fBusca_HistoricoOrdensAtrasadas(num_proc_lia,getdate()) [HISTÓRICO],
			cd_pes_ctt					[SAP - CONTACT],
			CSR.Nome_Usuario			[CSR - DESK],
			DI.Data_PO_HIA				[DI_DATA],
			Canal_Lia					[CANAL],
			'IA'						[MODAL]
		 from 
			llp_imp_aer LLP With(nolock)
			Join house_imp_aer			HOU With(nolock) on LLP.Num_proc_lia = HOU.Num_proc_hia
			Join Pessoa_LLP				PLL	With(nolock) on HOU.Cd_Consig_Hia = PLL.Cd_Pes and PLL.Cd_Pes_Grupo in ('P20904','1')
			Join Pedido_ship			PS With(nolock) on LLP.num_proc_lia=PS.num_proc
			Join Pedido					PD With(nolock) on PD.cd_pedido=PS.cd_pedido
			Left Join Usuario_Cliente	US With(nolock) on PO_Responsible=US.cd_usuario and US.Cd_Cliente in ('P20904','1')
			Left Join Usuario_Cliente	UD With(nolock) on PD.Cd_Userid=UD.cd_usuario and UD.Cd_Cliente in ('P20904','1')
			Left Join Usuario_Cliente	CSR With(nolock) on PD.Cd_CSRID=CSR.cd_usuario and CSR.Cd_Cliente in ('P20904','1')
			Left Join Tarefas_Processos Presenca With(nolock) on LLP.num_proc_lia=Presenca.num_proc and Presenca.Id_task=15
			Left Join Tarefas_Processos Registro With (nolock) on LLP.num_proc_lia=Registro.num_proc and Registro.Id_task=9
			Left Join PO_HIA			DI on DI.num_proc_hia=num_proc_lia and DI.ID_DC=5
			Left Join Tarefas_Processos DDP With(nolock) on LLP.num_proc_lia=DDP.num_proc and DDP.Id_task=4
			Left Join Tarefas_Processos DOOR With (nolock) on LLP.num_proc_lia=DOOR.num_proc and DOOR.Id_task=13
			Join Pedido_Det				PDD With(nolock) on PDD.cd_pedido=PS.cd_pedido and ps.item=pdd.item and ps.cd_produto=PDd.cd_produto
		where
			Door.Dt_Conclusao  is null  
			-- and substring(num_proc_lia,3,3) in ('CSR','STB')
			
			and etd_lia >=getdatE()-365
			AND ISNULL(DDP.DT_CONCLUSAO,GETDATE())>=GETDATE()-120
			AND ISNULL(ID_STATUS,0) <> 9 
			--and Num_proc_Lia = 'IACSR201207072BR'
		Group by
			Num_Proc_LIA,Num_pedido,num_po,
			Customer_PO,US.Nome_Usuario,UD.Nome_Usuario,
			ETD_LIA,ATD_LIA,ETA_LIA,ATA_LIA,Presenca.Dt_previsao,
			Presenca.Dt_Conclusao,Canal_LIA,DI.Data_PO_HIA,
			DI.Numero_PO_HIA,DI.Data_PO_HIA,DDP.dt_previsao,
			DDP.dt_conclusao,DOOR.Dt_Previsao,Door.Dt_Conclusao,
			PO_GRP,DL_Chegada,cd_pes_ctt ,CSR.nome_usuario,Registro.dt_previsao
			
		union all

		select DISTINCT
			'OK'						[STATUS],
			Num_pedido					[ORDEM],
			num_po						[NUMERO PO],
			Customer_PO					[CUSTOMER PO],
			PO_GRP						[PO GROUP],
			ETD_LIO						[ETD],
			ATD_LIO						[ATD],
			ETA_LIO						[ETA],
			ATA_LIO						[ATA],
			NULL						[PRESENÇA - PREVISÃO],
			Presenca.Dt_Conclusao		[PRESENÇA - CONCLUSÃO],
			(Case WHEN ATA_LIO is null THEN ETA_LIO + 1 ELSE ATA_LIO + 1 END)	[REGISTRO DI - PREVISÃO],
			DI.Data_PO_hio				[REGISTRO DI - CONCLUSÃO],
			(Case WHEN ATA_LIO is null THEN ETA_LIO + 2 ELSE ATA_LIO + 2 END) [PARAMETRIZAÇÃO - PREVISÃO],
			NULL						[PARAMETRIZAÇÃO - CONCLUSÃO],
			(Case WHEN ATA_LIO is null THEN ETA_LIO + 2 ELSE ATA_LIO + 2 END) [DESEMBARAÇO - PREVISÃO],
			DDP.dt_conclusao			[DESEMBARAÇO - CONCLUSÃO],
			NULL						[ENTREGA TRANSP. - PREVISÃO],
			NULL						[ENTREGA TRANSP. - CONCLUSÃO],
			(Case WHEN ATA_LIO is null THEN ETA_LIO + 10 ELSE ATA_LIO + 10 END)[ENTREGA PLANTA - PREVISÃO],
			0							[DIAS EM ATRASO],
			DL_Chegada					[PO REQ. DATE - ORIGINAL],
			NULL						[PO REQ. DATE - AJUSTADO],
			Num_Proc_lio				[JOB],
			dbo.fBusca_HistoricoOrdensAtrasadas(num_proc_lio,getdate()) [HISTÓRICO],
			cd_pes_ctt					[SAP - CONTACT],
			CSR.Nome_Usuario			[CSR - DESK],
			DI.Data_PO_hio				[DI_DATA],
			Canal_lio					[CANAL],
			'IO'						[MODAL]
		 from 
			llp_imp_out LLP With(nolock)
			Join house_imp_out			HOU With(nolock) on LLP.Num_proc_lio = HOU.Num_proc_hio
			Join Pessoa_LLP				PLL	With(nolock) on HOU.Cd_Consig_Hio = PLL.Cd_Pes and PLL.Cd_Pes_Grupo in ('P20904','1')
			Join Pedido_ship			PS With(nolock) on num_proc_lio=PS.num_proc
			Join Pedido					PD With(nolock) on PD.cd_pedido=PS.cd_pedido
			Left Join Usuario_Cliente	US With(nolock)on PO_Responsible=US.cd_usuario and US.Cd_Cliente in ('P20904','1')
			Left Join Usuario_Cliente	UD With(nolock) on PD.Cd_Userid=UD.cd_usuario and UD.Cd_Cliente in ('P20904','1')
			Left Join Usuario_Cliente	CSR With(nolock) on PD.Cd_CSRID=CSR.cd_usuario and CSR.Cd_Cliente in ('P20904','1')
			Left Join Tarefas_Processos Presenca With(nolock) on LLP.num_proc_lio=Presenca.num_proc and Presenca.Id_task=15
			Left Join Tarefas_Processos Registro  With(nolock) on LLP.num_proc_lio=Registro.num_proc and Registro.Id_task=9
			Left Join PO_hio			DI With(nolock) on DI.num_proc_hio=num_proc_lio and DI.ID_DC=5
			Left Join Tarefas_Processos DDP With(nolock) on LLP.num_proc_lio=DDP.num_proc and DDP.Id_task=4
			Left Join Tarefas_Processos DOOR With(nolock) on LLP.num_proc_lio=DOOR.num_proc and DOOR.Id_task=13
			Join Pedido_Det				PDD With(nolock) on PDD.cd_pedido=PS.cd_pedido and ps.item=pdd.item and ps.cd_produto=PDd.cd_produto

		where --Atd_lio is not null and 
			Door.Dt_Conclusao  is null
			--and substring(num_proc_lio,3,3) in ('CSR','STB')
			and etd_lio >=getdatE()-365
			AND ISNULL(ID_STATUS,0) <> 9
			AND ISNULL(DDP.DT_CONCLUSAO,GETDATE())>=GETDATE()-120
			--and num_proc_lio = 'IOCSR201205029BR'
		Group by
			Num_Proc_LIO,Num_pedido,num_po,
			Customer_PO,US.Nome_Usuario,UD.Nome_Usuario,
			ETD_LIO,ATD_LIO,ETA_LIO,ATA_LIO,Presenca.Dt_previsao,
			Presenca.Dt_Conclusao,Canal_LIO,DI.Data_PO_HIO,
			DI.Numero_PO_HIO,DI.Data_PO_HIO,DDP.dt_previsao,
			DDP.dt_conclusao,DOOR.Dt_Previsao,Door.Dt_Conclusao,
			PO_GRP,DL_Chegada,cd_pes_ctt ,CSR.nome_usuario
			
		
union all
		select 
			'OK'							[STATUS],
			Num_pedido						[ORDEM],
			num_po							[NUMERO PO],
			Customer_PO						[CUSTOMER PO],
			PO_GRP							[PO GROUP],
			ETD_LIM							[ETD],
			ATD_LIM							[ATD],
			ETA_LIM							[ETA],
			ATA_LIM							[ATA],
			NULL							[PRESENÇA - PREVISÃO],
			Presenca.Dt_Conclusao			[PRESENÇA - CONCLUSÃO],
			(Case WHEN ATA_LIM is null THEN ETA_LIM + 3 ELSE ATA_LIM + 3 END)	[REGISTRO DI - PREVISÃO],
			DI.Data_PO_him					[REGISTRO DI - CONCLUSÃO],
			(Case WHEN ATA_LIM is null THEN ETA_LIM + 4 ELSE ATA_LIM + 4 END) [PARAMETRIZAÇÃO - PREVISÃO],
			NULL							[PARAMETRIZAÇÃO - CONCLUSÃO],
			(Case WHEN ATA_LIM is null THEN ETA_LIM + 7 ELSE ATA_LIM + 7 END)[DESEMBARAÇO - PREVISÃO],
			DDP.dt_conclusao				[DESEMBARAÇO - CONCLUSÃO],
			NULL							[ENTREGA TRANSP. - PREVISÃO],
			NULL							[ENTREGA TRANSP. - CONCLUSÃO],
			(Case WHEN ATA_LIM is null THEN ETA_LIM + 20 ELSE ATA_LIM + 20 END)[ENTREGA PLANTA - PREVISÃO],
			0								[DIAS EM ATRASO],
			DL_Chegada						[PO REQ. DATE - ORIGINAL],
			NULL							[PO REQ. DATE - AJUSTADO],
			Num_Proc_lim					[JOB],
			dbo.fBusca_HistoricoOrdensAtrasadas(num_proc_lim,getdate()) [HISTÓRICO],
			cd_pes_ctt						[SAP - CONTACT],
			CSR.Nome_Usuario				[CSR - DESK],
			DI.Data_PO_him					[DI_DATA],
			Canal_lim						[CANAL],
			'IM'							[MODAL]
		 from 
			llp_imp_mar LLP With(nolock)
			Join house_imp_mar			HOU With(nolock) on LLP.Num_proc_lim = HOU.Num_proc_him
			Join Pessoa_LLP				PLL	With(nolock) on HOU.Cd_Consig_Him = PLL.Cd_Pes and PLL.Cd_Pes_Grupo in ('P20904','1')
			Join Pedido_ship				PS With(nolock) on num_proc_lim=PS.num_proc
			Join Pedido						PD With(nolock) on PD.cd_pedido=PS.cd_pedido
			Left Join Usuario_Cliente		US With(nolock) on PO_Responsible=US.cd_usuario and US.Cd_Cliente in ('P20904','1')
			Left Join Usuario_Cliente		UD With(nolock) on PD.Cd_Userid=UD.cd_usuario and UD.Cd_Cliente in ('P20904','1')
			Left Join Usuario_Cliente		CSR With(nolock) on PD.Cd_CSRID=CSR.cd_usuario and CSR.Cd_Cliente in ('P20904','1')
			Left Join Tarefas_Processos		Presenca  With(nolock) on LLP.num_proc_lim=Presenca.num_proc and Presenca.Id_task=15
			Left Join Tarefas_Processos		Registro With(nolock)  on LLP.num_proc_lim=Registro.num_proc and Registro.Id_task=9
			Left Join PO_him				DI on DI.num_proc_him=num_proc_lim and DI.ID_DC=5
			Left Join Tarefas_Processos		DDP  With(nolock) on LLP.num_proc_lim=DDP.num_proc and DDP.Id_task=4
			Left Join Tarefas_Processos		DOOR With(nolock) on LLP.num_proc_lim=DOOR.num_proc and DOOR.Id_task=13
			Join Pedido_Det					PDD With(nolock) on PDD.cd_pedido=PS.cd_pedido and ps.item=pdd.item and ps.cd_produto=PDd.cd_produto
		where 
			Door.Dt_Conclusao  is null
			--and substring(num_proc_lim,3,3) in ('CSR','STB')
			and etd_lim >=getdatE()-365
			AND ISNULL(ID_STATUS,0) <> 9
			AND ISNULL(DDP.DT_CONCLUSAO,GETDATE())>=GETDATE()-120
			--and Num_Proc_lim = 'IMCSR201111103BR'
		Group by
			Num_Proc_lim,Num_pedido,num_po,
			Customer_PO,US.Nome_Usuario,UD.Nome_Usuario,
			ETD_lim,ATD_lim,ETA_lim,ATA_lim,Presenca.Dt_previsao,
			Presenca.Dt_Conclusao,Canal_lim,DI.Data_PO_him,
			DI.Numero_PO_him,DI.Data_PO_him,DDP.dt_previsao,
			DDP.dt_conclusao,DOOR.Dt_Previsao,Door.Dt_Conclusao,
			PO_GRP,DL_Chegada,cd_pes_ctt ,CSR.nome_usuario
option(hash join)
End

	--[STATUS]
	Update @TAB
	set [STATUS] = 'ATRASADO'
	where ATA is null and ETA < getdate()
	
	--[PRESENÇA - PREVISÃO]
	Update @TAB
	set	[PRESENÇA - PREVISÃO] = (Case WHEN ATA is null THEN ETA + 1 ELSE ATA + 1 END)
	--[PRESENÇA - CONCLUSÃO]
	Update @TAB
	set	[PRESENÇA - CONCLUSÃO] = (Case WHEN ATA is null THEN ETA + 1 ELSE ATA + 1 END)
	where [PRESENÇA - CONCLUSÃO] is null and ([DESEMBARAÇO - CONCLUSÃO] is not null or [CANAL] is not null or [DI_DATA] is null)
		--*[STATUS]
		Update @TAB
		set	[STATUS] = 'ATRASADO'
		where [PRESENÇA - CONCLUSÃO] is null and [PRESENÇA - PREVISÃO] < getdate()
	
	--[REGISTRO DI - CONCLUSÃO]

	Update @TAB
	set [REGISTRO DI - CONCLUSÃO] = (Case WHEN [ATA] is null THEN [ETA] + (Case [MODAL]
																			WHEN 'IA' THEN 2
																			WHEN 'IM' THEN 3
																			WHEN 'IO' THEN 1 END) 
															 ELSE [ATA] + (Case [MODAL]
																			WHEN 'IA' THEN 2
																			WHEN 'IM' THEN 3
																			WHEN 'IO' THEN 1 END) 
	END)
	where [REGISTRO DI - CONCLUSÃO] is null and ([DESEMBARAÇO - CONCLUSÃO] is not null or [CANAL] is not null or [DI_DATA] is null)
		--*[STATUS]
		Update @TAB
		set	[STATUS] = 'ATRASADO'
		where [REGISTRO DI - CONCLUSÃO] is null and [REGISTRO DI - PREVISÃO] < getdate()
	
	--[PARAMETRIZAÇÃO - CONCLUSÃO]	
	Update @TAB
	set [REGISTRO DI - CONCLUSÃO] = (Case WHEN [ATA] is null THEN [ETA] + (Case [MODAL]
																			WHEN 'IA' THEN 3
																			WHEN 'IM' THEN 4
																			WHEN 'IO' THEN 2 END) 
															  ELSE [ATA] + (Case [MODAL]
																			WHEN 'IA' THEN 3
																			WHEN 'IM' THEN 4
																			WHEN 'IO' THEN 2 END) 
	END)
	where [REGISTRO DI - CONCLUSÃO] is null and ([DESEMBARAÇO - CONCLUSÃO] is not null or [CANAL] is not null)
		--*[STATUS]
		Update @TAB
		set	[STATUS] = 'ATRASADO'
		where [PARAMETRIZAÇÃO - CONCLUSÃO] is null and [PARAMETRIZAÇÃO - PREVISÃO] < getdate()
	
	--[DESEMBARAÇO - CONCLUSÃO]
		--*[STATUS]
		Update @TAB
		set	[STATUS] = 'ATRASADO'
		where [DESEMBARAÇO - CONCLUSÃO] is null and [DESEMBARAÇO - PREVISÃO] < getdate()

	--[DIAS EM ATRASO]
		--*ATA
		Update @TAB
		set [DIAS EM ATRASO] = convert(int,getdate() - [ETA])
		where [ATA] is null
		--*PRESENÇA
		Update @TAB
		set [DIAS EM ATRASO] = convert(int,getdate() - [PRESENÇA - PREVISÃO])
		where [PRESENÇA - CONCLUSÃO] is null
		Update @TAB
		set [DIAS EM ATRASO] = convert(int,[PRESENÇA - CONCLUSÃO] - [PRESENÇA - PREVISÃO])
		where [PRESENÇA - CONCLUSÃO] > [PRESENÇA - PREVISÃO]
		--*REGISTRO DE DI
		Update @TAB
		set [DIAS EM ATRASO] = convert(int,getdate() - [REGISTRO DI - PREVISÃO])
		where [REGISTRO DI - CONCLUSÃO] is null
		Update @TAB
		set [DIAS EM ATRASO] = convert(int,[REGISTRO DI - CONCLUSÃO] - [REGISTRO DI - PREVISÃO])
		where [REGISTRO DI - CONCLUSÃO] > [REGISTRO DI - PREVISÃO]
		--*PARAMETRIZAÇÃO
		Update @TAB
		set [DIAS EM ATRASO] = convert(int,getdate() - [PARAMETRIZAÇÃO - PREVISÃO])
		Where [PARAMETRIZAÇÃO - CONCLUSÃO] is null
		Update @TAB
		set [DIAS EM ATRASO] = convert(int,[PARAMETRIZAÇÃO - CONCLUSÃO] - [PARAMETRIZAÇÃO - PREVISÃO])
		where [PARAMETRIZAÇÃO - CONCLUSÃO] > [PARAMETRIZAÇÃO - PREVISÃO]
		--*DESEMBARAÇO
		Update @TAB
		set [DIAS EM ATRASO] = convert(int,getdate() - [DESEMBARAÇO - PREVISÃO])
		where [DESEMBARAÇO - CONCLUSÃO] is null
		Update @TAB
		set [DIAS EM ATRASO] = convert(int,[DESEMBARAÇO - CONCLUSÃO] - [DESEMBARAÇO - PREVISÃO])
		where [DESEMBARAÇO - CONCLUSÃO] > [DESEMBARAÇO - PREVISÃO]
		
	--[PO REQ. DATE - AJUSTADO]
	Update @TAB
	set [PO REQ. DATE - AJUSTADO] = convert(int,[ENTREGA PLANTA - PREVISÃO] + [DIAS EM ATRASO])
		--*[STATUS]
		Update @TAB
		set	[STATUS] = 'OK'
		Update @TAB
		set	[STATUS] = 'ATRASADO'
		where convert(int,[PO REQ. DATE - AJUSTADO] - [PO REQ. DATE - ORIGINAL]) >= -4

select 
		[STATUS],
		[ORDEM],
		[NUMERO PO],
		[CUSTOMER PO],
		[PO GROUP],
		[ETD],
		[ATD],
		[ETA],
		[ATA],
		[PRESENÇA - PREVISÃO],
		[PRESENÇA - CONCLUSÃO],
		[REGISTRO DI - PREVISÃO],
		[REGISTRO DI - CONCLUSÃO],
		[PARAMETRIZAÇÃO - PREVISÃO],
		[PARAMETRIZAÇÃO - CONCLUSÃO],
		[DESEMBARAÇO - PREVISÃO],
		[DESEMBARAÇO - CONCLUSÃO],
		[ENTREGA TRANSP. - PREVISÃO],
		[ENTREGA TRANSP. - CONCLUSÃO],
		[ENTREGA PLANTA - PREVISÃO],
		[DIAS EM ATRASO],
		[PO REQ. DATE - ORIGINAL],
		[PO REQ. DATE - AJUSTADO],
		[JOB],
		[HISTÓRICO],
		[SAP - CONTACT],
		[CSR - DESK]
from
	@TAB




GO
