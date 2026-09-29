SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--10-06-2008
--Week 24
--inclusão Entrega de Docs para Transporte - Claudio

--30-07-2008
--Inclusão  "Entrada no Terminal",  "Desova",  "Digitação D.I.",  "Receb. Insp. Madeira",  "Envio Docs. Câmbio",  "Envio Docs. Faturamento" e  "Pgto. AFRMM"

--16/02/2011
-- Alteração de Stored 16/02/2011 - Troca dos Unions e colocação da checagem se o processo é desembaraço - Anderson

CREATE Procedure [dbo].[spTracking_Imp_CHB_Rel]--'NO'
@TIPO varchar(2)
as
--Altera por Erbson 20-09-2012 - Stored desativada.
--return 0
IF @TIPO = 'DI'
BEGIN
	select Distinct 
		hou.Num_Proc_HIM 						Processo,
		hou.MAWB_HIM 							MAWB,
		HAWB_HIM 								HAWB,
		Num_Pedido,
		Isnull(Num_Po,PO.numero_po_him) 		Num_PO,
		Navio_HIM 								Navio,
		DEST.Nome_Local 						Destino,
		ETA_LIM 								ETA,
		ATA_LIM 								ATA,
		dbo.fBusca_Tarefa(hou.num_proc_him,60)	Abertura_Pasta,
		ETD_LIM 								ETD,
		ATD_LIM 								ATD,		
		dbo.fBusca_Tarefa(hou.num_proc_him,28)	Entrada_Terminal,
		dbo.fBusca_Tarefa(hou.num_proc_him,29)	Desova,
		dbo.fBusca_Tarefa(hou.num_proc_him,15)	PresencaCarga,
		dbo.fBusca_Tarefa(hou.num_proc_him,27)	Digitacao_DI,
		dbo.fBusca_Tarefa(hou.num_proc_him,4)	Desembaraco,
		dbo.fBusca_Tarefa(hou.num_proc_him,30)	Ins_Madeira,
		dbo.fBusca_Tarefa(hou.num_proc_him,23)	Envio_Docs_Cambio,
		dbo.fBusca_Tarefa(hou.num_proc_him,7)	Entr_Docs_Transp,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_him,13) Prev_Entrega,
		dbo.fBusca_Tarefa(hou.num_proc_him,13)	Entrega_Planta,
		dbo.fBusca_Tarefa(hou.num_proc_him,26)	Envio_Docs_Faturamento,
		dbo.FBusca_Adto(hou.num_proc_him)		Adto, 
		dbo.FBusca_Caixa(hou.num_proc_him)		Rcto,
		dbo.fBusca_Tarefa(hou.num_proc_him,21)	Liberacao_BL,
		dbo.fBusca_Tarefa(hou.num_proc_him,25)	Pgto_AFRMM,
		LI.Numero_PO_HIM 						Num_LI,
		LI.Data_PO_HIM 							Data_LI,
		dbo.fBusca_Tarefa(hou.num_proc_him,20)	Def_LI,
		DI.Numero_PO_Him 						DI, 
		DI.Data_PO_Him 							Data_DI,
		Canal_Lim 								Canal,
		dbo.fBusca_HistoricoDescr_Completo(hou.num_proc_him) Historico,
		FCHB.Data_PC							Prest_Contas,
		dbo.fBusca_Terminal(HOU.Num_Proc_HIM)	Nome_Terminal,
		EP.Dt_Conclusao,
--		NCM.NCM,
--		NCM.Descricao_NCM						Des_NCM,
		PG.Apelido								Nome_Grupo,
		dbo.fBusca_Tarefa(hou.num_proc_him,42)	Red_Container,
		dbo.fBusca_Tarefa(hou.num_proc_him,71)	Recb_pasta_CHB

	from house_imp_mar HOU With (Nolock)
		Join LLp_imp_mar						LLP With (Nolock) on LLP.num_proc_LIM=hou.num_proc_HIM
		left Join Pedido_Ship					PS With (Nolock) on PS.num_proc=hou.num_proc_HIM
		left Join Pedido						PD With (Nolock) on PD.cd_pedido=PS.cd_pedido
		left Join Localidade					DEST With (Nolock) on cd_dst_HIM=DEST.cd_local
		Left Join PO_HIM						DI With (Nolock) on DI.Num_Proc_Him=hou.num_proc_him and DI.id_dc=5
		Left Join PO_HIM						PO With (Nolock) on PO.Num_Proc_Him=hou.num_proc_him and PO.id_dc=1
		left Join Fatura_CHB					FCHB With (Nolock) on HOU.Num_Proc_HIM = FCHB.Processo_PC
		Left Join PO_HIM						LI With (Nolock) on LI.Num_Proc_Him=hou.num_proc_him and LI.id_dc=23
		join Tarefas_Processos					EP With (Nolock) on EP.Num_Proc = HOU.Num_Proc_Him and EP.ID_Task = 13
--		left join Proc_NCM						PNCM on PNCM.Num_Proc = HOU.Num_Proc_Him
--		left join NCM							NCM on PNCM.ID_NCM = NCM.ID_NCM
		join Grupo								G With (Nolock) on G.grupo = right(left(HOU.Num_Proc_HIM,5),3)
		join pessoa								PG With (Nolock) on PG.cd_pes=G.cd_pes_grupo
		Join Tarefas_Processos				PC With (Nolock) on PC.num_proc=hou.num_proc_him and PC.ID_task=13 and PC.dt_Conclusao is null
		Left Join Campo_Processo CPP With (Nolock) on CPP.num_proc=num_proc_lim and id_campo=32
	
	where
		FCHB.Data_PC is null and DI.Numero_PO_Him is not null
				and (Campo_dados <> '2' or Campo_Dados is null)
	
	group by
		hou.Num_Proc_HIM,
		hou.MAWB_HIM ,
		HAWB_HIM,
		Num_Pedido,
		Num_Po,PO.numero_po_him,
		Navio_HIM,
		DEST.Nome_Local,
		ETA_LIM,
		ATA_LIM,
		ETD_LIM,
		ATD_LIM,
		LI.Numero_PO_HIM,
		LI.Data_PO_HIM,
		DI.Numero_PO_Him, 
		DI.Data_PO_Him,
		Canal_Lim,
		FCHB.Data_PC,
		EP.Dt_Conclusao,
--		NCM.NCM,
--		NCM.Descricao_NCM,
		PG.Apelido
	
	Union All

	select 
		Distinct 
		hou.Num_Proc_HIA 						Processo,
		hou.MAWB_HIA 							MAWB,
		HAWB_HIA 								HAWB,
		Num_Pedido,
		Isnull(Num_Po,PO.numero_po_HIA)			Num_PO,
		null	 								Navio,
		DEST.Nome_Local 						Destino,
		ETA_LIA 								ETA,
		ATA_LIA 								ATA,
		dbo.fBusca_Tarefa(hou.num_proc_hia,60)	Abertura_Pasta,
		ETD_LIA									ETD,
		ATD_LIA									ATD,
		dbo.fBusca_Tarefa(hou.num_proc_hia,28)	Entrada_Terminal,
		dbo.fBusca_Tarefa(hou.num_proc_hia,29)	Desova,
		dbo.fBusca_Tarefa(hou.num_proc_hia,15)	PresencaCarga,
		dbo.fBusca_Tarefa(hou.num_proc_hia,27)	Digitacao_DI,
		dbo.fBusca_Tarefa(hou.num_proc_hia,4)	Desembaraco,
		dbo.fBusca_Tarefa(hou.num_proc_hia,30)	Ins_Madeira,
		dbo.fBusca_Tarefa(hou.num_proc_hia,23)	Envio_Docs_Cambio,
		dbo.fBusca_Tarefa(hou.num_proc_hia,7)	Entr_Docs_Transp,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_hia,13) Prev_Entrega,
		dbo.fBusca_Tarefa(hou.num_proc_hia,13)	Entrega_Planta,
		dbo.fBusca_Tarefa(hou.num_proc_hia,26)	Envio_Docs_Faturamento,
		dbo.FBusca_Adto(hou.num_proc_hia)		Adto, 
		dbo.FBusca_Caixa(hou.num_proc_hia)		Rcto,
		dbo.fBusca_Tarefa(hou.num_proc_hia,21)	Liberacao_BL,
		dbo.fBusca_Tarefa(hou.num_proc_hia,25)	Pgto_AFRMM,
		LI.Numero_PO_HIA 						Num_LI,
		LI.Data_PO_HIA 							Data_LI,
		dbo.fBusca_Tarefa(hou.num_proc_hia,20)	Def_LI,
		DI.Numero_PO_Hia 						DI, 
		DI.Data_PO_Hia 							Data_DI,
		Canal_Lia 								Canal,
		dbo.fBusca_HistoricoDescr_Completo(hou.num_proc_hia) Historico,
		FCHB.Data_PC							Prest_Contas,
		dbo.fBusca_Terminal(HOU.Num_Proc_HIA)	Nome_Terminal,
		EP.Dt_Conclusao,
--		NCM.NCM,
--		NCM.Descricao_NCM						Des_NCM,
		PG.Apelido								Nome_Grupo,
		dbo.fBusca_Tarefa(hou.num_proc_hia,42)	Red_Container,
		dbo.fBusca_Tarefa(hou.num_proc_hia,71)	Recb_pasta_CHB

	from house_imp_Aer HOU With (Nolock)
		Join LLp_imp_Aer LLP With (Nolock) on LLP.num_proc_LIA=hou.num_proc_HIA
		left Join Pedido_Ship PS With (Nolock) on PS.num_proc=hou.num_proc_HIA
		left Join Pedido PD With (Nolock) on PD.cd_pedido=PS.cd_pedido
		left Join Localidade DEST With (Nolock) on cd_dst_HIA=DEST.cd_local
		Left Join PO_HIA DI With (Nolock) on DI.Num_Proc_HIA=hou.num_proc_HIA and DI.id_dc=5
		Left Join PO_HIA PO With (Nolock) on PO.Num_Proc_HIA=hou.num_proc_HIA and PO.id_dc=1
		left Join Fatura_CHB FCHB With (Nolock) on HOU.Num_Proc_HIA = FCHB.Processo_PC
		Left Join PO_HIA LI With (Nolock) on LI.Num_Proc_HIA=hou.num_proc_HIA and LI.id_dc=23
		join Tarefas_Processos EP With(NoLock) on  EP.Num_Proc = HOU.Num_Proc_Hia and EP.ID_Task = 13
--		left join Proc_NCM PNCM on PNCM.Num_Proc = HOU.Num_Proc_Hia
--		left join NCM NCM on PNCM.ID_NCM = NCM.ID_NCM
		join Grupo G With (Nolock) on G.grupo= right(left(HOU.Num_Proc_HIA,5),3)
		join pessoa PG With (Nolock) on PG.cd_pes=G.cd_pes_grupo
		Join Tarefas_Processos				PC With (Nolock) on PC.num_proc=hou.num_proc_hiA and PC.ID_task=13 and PC.dt_Conclusao is null

	where
		FCHB.Data_PC is null and DI.Numero_PO_Hia is not null
	group by
		hou.Num_Proc_HIA,
		hou.MAWB_HIA ,
		HAWB_HIA,
		Num_Pedido,
		Num_Po,PO.numero_po_HIA,
		DEST.Nome_Local,
		ETA_LIA,
		ATA_LIA,
		ETD_LIA,
		ATD_LIA,
		LI.Numero_PO_HIA,
		LI.Data_PO_HIA,
		DI.Numero_PO_HIA, 
		DI.Data_PO_HIA,
		Canal_LIA,
		FCHB.Data_PC,
		EP.Dt_Conclusao,
--		NCM.NCM,
--		NCM.Descricao_NCM,
		PG.Apelido
	Union All
	select 
		Distinct
		hou.Num_Proc_HIO 						Processo,
		hou.MAWB_HIO 							MAWB,
		HAWB_HIO 								HAWB,
		Num_Pedido,
		Isnull(Num_Po,PO.numero_po_HIO)			Num_PO,
		null	 								Navio,
		DEST.Nome_Local 						Destino,
		ETA_LIO 								ETA,
		ATA_LIO 								ATA,
		dbo.fBusca_Tarefa(hou.num_proc_hio,60)	Abertura_Pasta,
		ETD_LIO									ETD,
		ATD_LIO									ATD,			
		dbo.fBusca_Tarefa(hou.num_proc_hio,28)	Entrada_Terminal,
		dbo.fBusca_Tarefa(hou.num_proc_hio,29)	Desova,
		dbo.fBusca_Tarefa(hou.num_proc_hio,15)	PresencaCarga,
		dbo.fBusca_Tarefa(hou.num_proc_hio,27)	Digitacao_DI,
		dbo.fBusca_Tarefa(hou.num_proc_hio,4)	Desembaraco,
		dbo.fBusca_Tarefa(hou.num_proc_hio,30)	Ins_Madeira,
		dbo.fBusca_Tarefa(hou.num_proc_hio,23)	Envio_Docs_Cambio,
		dbo.fBusca_Tarefa(hou.num_proc_hio,7)	Entr_Docs_Transp,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_hio,13) Prev_Entrega,
		dbo.fBusca_Tarefa(hou.num_proc_hio,13)	Entrega_Planta,
		dbo.fBusca_Tarefa(hou.num_proc_hio,26)	Envio_Docs_Faturamento,
		dbo.FBusca_Adto(hou.num_proc_hio)		Adto, 
		dbo.FBusca_Caixa(hou.num_proc_hio)		Rcto,
		dbo.fBusca_Tarefa(hou.num_proc_hio,21)	Liberacao_BL,
		dbo.fBusca_Tarefa(hou.num_proc_hio,25)	Pgto_AFRMM,
		LI.Numero_PO_HIo 						Num_LI,
		LI.Data_PO_HIo 							Data_LI,
		dbo.fBusca_Tarefa(hou.num_proc_hio,20)	Def_LI,
		DI.Numero_PO_Hio 						DI, 
		DI.Data_PO_Hio 							Data_DI,
		Canal_Lio 								Canal,
		dbo.fBusca_HistoricoDescr_Completo(hou.num_proc_hio) Historico,
		FCHB.Data_PC							Prest_Contas,
		dbo.fBusca_Terminal(HOU.Num_Proc_HIO)	Nome_Terminal,
		EP.Dt_Conclusao,
--		NCM.NCM,
--		NCM.Descricao_NCM,
		PG.Apelido								Nome_Grupo,
		dbo.fBusca_Tarefa(hou.num_proc_hio,42)	Red_Container,
		dbo.fBusca_Tarefa(hou.num_proc_hio,71)	Recb_pasta_CHB
	
	from house_imp_Out HOU With (Nolock)
		Join LLp_imp_Out LLP With (Nolock) on LLP.num_proc_LIO=hou.num_proc_HIO
		left Join Pedido_Ship PS With (Nolock) on PS.num_proc=hou.num_proc_HIO
		left Join Pedido PD With (Nolock) on PD.cd_pedido=PS.cd_pedido
		left Join Localidade DEST With (Nolock) on cd_dst_HIO=DEST.cd_local
		Left Join PO_HIO DI With (Nolock) on DI.Num_Proc_HIO=hou.num_proc_HIO and DI.id_dc=5
		Left Join PO_HIO PO With (Nolock) on PO.Num_Proc_HIO=hou.num_proc_HIO and PO.id_dc=1
		left Join Fatura_CHB FCHB With (Nolock) on HOU.Num_Proc_HIO = FCHB.Processo_PC
		Left Join PO_HIO LI With (Nolock) on LI.Num_Proc_HIO=hou.num_proc_HIO and LI.id_dc=23
		join Tarefas_Processos EP with(nolock) on EP.Num_Proc = HOU.Num_Proc_Hio and EP.ID_Task = 13
--		left join Proc_NCM PNCM on PNCM.Num_Proc = HOU.Num_Proc_Hio
--		left join NCM NCM on PNCM.ID_NCM = NCM.ID_NCM
		join Grupo G With (Nolock) on G.grupo= right(left(HOU.Num_Proc_HIO,5),3)
		join pessoa PG With (Nolock) on PG.cd_pes=G.cd_pes_grupo
	where
		FCHB.Data_PC is null and DI.Numero_PO_Hio is not null
	group by
		hou.Num_Proc_HIO,
		hou.MAWB_HIO ,
		HAWB_HIO,
		Num_Pedido,
		Num_Po,PO.numero_po_HIO,
		DEST.Nome_Local,
		ETA_LIO,
		ATA_LIO,
		ETD_LIO,
		ATD_LIO,
		LI.Numero_PO_HIO,
		LI.Data_PO_HIO,
		DI.Numero_PO_HIO, 
		DI.Data_PO_HIO,
		Canal_LIO,
		FCHB.Data_PC,
		EP.Dt_Conclusao,
--		NCM.NCM,
--		NCM.Descricao_NCM,
		PG.Apelido
END
ELSE
BEGIN
	select Distinct 
		hou.Num_Proc_HIM 						Processo,
		hou.MAWB_HIM 							MAWB,
		HAWB_HIM 								HAWB,
		Num_Pedido,
		Isnull(Num_Po,PO.numero_po_him) 		Num_PO,
		Navio_HIM 								Navio,
		DEST.Nome_Local 						Destino,
		ETA_LIM 								ETA,
		ATA_LIM 								ATA,
		dbo.fBusca_Tarefa(hou.num_proc_him,60)	Abertura_Pasta,
		ETD_LIM									ETD,
		ATD_LIM									ATD,
		dbo.fBusca_Tarefa(hou.num_proc_him,28)	Entrada_Terminal,
		dbo.fBusca_Tarefa(hou.num_proc_him,29)	Desova,
		dbo.fBusca_Tarefa(hou.num_proc_him,15)	PresencaCarga,
		dbo.fBusca_Tarefa(hou.num_proc_him,27)	Digitacao_DI,
		dbo.fBusca_Tarefa(hou.num_proc_him,4)	Desembaraco,
		dbo.fBusca_Tarefa(hou.num_proc_him,30)	Ins_Madeira,
		dbo.fBusca_Tarefa(hou.num_proc_him,23)	Envio_Docs_Cambio,
		dbo.fBusca_Tarefa(hou.num_proc_him,7)	Entr_Docs_Transp,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_him,13) Prev_Entrega,
		dbo.fBusca_Tarefa(hou.num_proc_him,13)	Entrega_Planta,
		dbo.fBusca_Tarefa(hou.num_proc_him,26)	Envio_Docs_Faturamento,
		dbo.FBusca_Adto(hou.num_proc_him)		Adto, 
		dbo.FBusca_Caixa(hou.num_proc_him)		Rcto,
		dbo.fBusca_Tarefa(hou.num_proc_him,21)	Liberacao_BL,
		dbo.fBusca_Tarefa(hou.num_proc_him,25)	Pgto_AFRMM,
		LI.Numero_PO_HIM 						Num_LI,
		LI.Data_PO_HIM 							Data_LI,
		dbo.fBusca_Tarefa(hou.num_proc_him,20)	Def_LI,
		DI.Numero_PO_Him 						DI, 
		DI.Data_PO_Him 							Data_DI,
		Canal_Lim 								Canal,
		dbo.fBusca_HistoricoDescr_Completo(hou.num_proc_him) Historico,
		FCHB.Data_PC							Prest_Contas,
		dbo.fBusca_Terminal(HOU.Num_Proc_HIM)	Nome_Terminal,
		EP.Dt_Conclusao,
--		NCM.NCM,
--		NCM.Descricao_NCM,
		PG.Apelido								Nome_Grupo,
		dbo.fBusca_Tarefa(hou.num_proc_him,42)	Red_Container,
		dbo.fBusca_Tarefa(hou.num_proc_him,71)	Recb_pasta_CHB
		

	from house_imp_mar HOU With (Nolock)
		Join LLp_imp_mar LLP With (Nolock) on LLP.num_proc_LIM=hou.num_proc_HIM
		left Join Pedido_Ship PS With (Nolock) on PS.num_proc=hou.num_proc_HIM
		left Join Pedido PD With (Nolock) on PD.cd_pedido=PS.cd_pedido
		left Join Localidade DEST With (Nolock) on cd_dst_HIM=DEST.cd_local
		Left Join PO_HIM DI With (Nolock) on DI.Num_Proc_Him=hou.num_proc_him and DI.id_dc=5
		Left Join PO_HIM PO With (Nolock) on PO.Num_Proc_Him=hou.num_proc_him and PO.id_dc=1
		left Join Fatura_CHB FCHB With (Nolock) on HOU.Num_Proc_HIM = FCHB.Processo_PC
		Left Join PO_HIM LI With (Nolock) on LI.Num_Proc_Him=hou.num_proc_him and LI.id_dc=23
		join Tarefas_Processos EP With(NoLock) on EP.Num_Proc = HOU.Num_Proc_Him and EP.ID_Task = 13
--		left join Proc_NCM PNCM on PNCM.Num_Proc = HOU.Num_Proc_Him
--		left join NCM NCM on PNCM.ID_NCM = NCM.ID_NCM
		join Grupo G With (Nolock) on G.grupo= right(left(HOU.Num_Proc_HIM,5),3)
		join pessoa PG With (Nolock) on PG.cd_pes=G.cd_pes_grupo
		Left Join Campo_Processo CPP With (Nolock) on CPP.num_proc=num_proc_lim and id_campo=32
		LEft Join hist_geral With (Nolock) on  HSGprocesso=num_proc_lim and cd_tp_ocor=28
	where
		FCHB.Data_PC is null and DI.Numero_PO_Him is null
		and (Campo_dados <> '2' or Campo_Dados is null)
		and hsgprocesso is null and convert(datetime,HOU.Dt_Emis_HIM,105) >= getdate() -365
	group by
		hou.Num_Proc_HIM,
		hou.MAWB_HIM ,
		HAWB_HIM,
		Num_Pedido,
		Num_Po,PO.numero_po_him,
		Navio_HIM,
		DEST.Nome_Local,
		ETA_LIM,
		ATA_LIM,
		ETD_LIM,
		ATD_LIM,
		LI.Numero_PO_HIM,
		LI.Data_PO_HIM,
		DI.Numero_PO_Him, 
		DI.Data_PO_Him,
		Canal_Lim,
		FCHB.Data_PC,
		EP.Dt_Conclusao,
--		NCM.NCM,
--		NCM.Descricao_NCM,
		PG.Apelido
	Union All

	select distinct 
		hou.Num_Proc_HIA 						Processo,
		hou.MAWB_HIA 							MAWB,
		HAWB_HIA 								HAWB,
		Num_Pedido,
		Isnull(Num_Po,PO.numero_po_HIA)			Num_PO,
		null	 								Navio,
		DEST.Nome_Local 						Destino,
		ETA_LIA 								ETA,
		ATA_LIA 								ATA,
		dbo.fBusca_Tarefa(hou.num_proc_hia,60)	Abertura_Pasta,
		ETD_LIA									ETD,
		ATD_LIA									ATD,
		dbo.fBusca_Tarefa(hou.num_proc_hia,28)	Entrada_Terminal,
		dbo.fBusca_Tarefa(hou.num_proc_hia,29)	Desova,
		dbo.fBusca_Tarefa(hou.num_proc_hia,15)	PresencaCarga,
		dbo.fBusca_Tarefa(hou.num_proc_hia,27)	Digitacao_DI,
		dbo.fBusca_Tarefa(hou.num_proc_hia,4)	Desembaraco,
		dbo.fBusca_Tarefa(hou.num_proc_hia,30)	Ins_Madeira,
		dbo.fBusca_Tarefa(hou.num_proc_hia,23)	Envio_Docs_Cambio,
		dbo.fBusca_Tarefa(hou.num_proc_hia,7)	Entr_Docs_Transp,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_hia,13) Prev_Entrega,
		dbo.fBusca_Tarefa(hou.num_proc_hia,13)	Entrega_Planta,
		dbo.fBusca_Tarefa(hou.num_proc_hia,26)	Envio_Docs_Faturamento,
		dbo.FBusca_Adto(hou.num_proc_hia)		Adto, 
		dbo.FBusca_Caixa(hou.num_proc_hia)		Rcto,
		dbo.fBusca_Tarefa(hou.num_proc_hia,21)	Liberacao_BL,
		dbo.fBusca_Tarefa(hou.num_proc_hia,25)	Pgto_AFRMM,
		LI.Numero_PO_HIA 						Num_LI,
		LI.Data_PO_HIA 							Data_LI,
		dbo.fBusca_Tarefa(hou.num_proc_hia,20)	Def_LI,
		DI.Numero_PO_Hia 						DI, 
		DI.Data_PO_Hia 							Data_DI,
		Canal_Lia 								Canal,
		dbo.fBusca_HistoricoDescr_Completo(hou.num_proc_hia) Historico,
		FCHB.Data_PC							Prest_Contas,
		dbo.fBusca_Terminal(HOU.Num_Proc_HIA)	Nome_Terminal,
		EP.Dt_Conclusao,
--		NCM.NCM,
--		NCM.Descricao_NCM,
		PG.Apelido								Nome_Grupo,
		dbo.fBusca_Tarefa(hou.num_proc_hia,42)	Red_Container,
		dbo.fBusca_Tarefa(hou.num_proc_hia,71)	Recb_pasta_CHB
		
	from house_imp_Aer HOU With (Nolock)
		Join LLp_imp_Aer LLP With (Nolock) on LLP.num_proc_LIA=hou.num_proc_HIA
		left Join Pedido_Ship PS With (Nolock) on PS.num_proc=hou.num_proc_HIA
		left Join Pedido PD With (Nolock) on PD.cd_pedido=PS.cd_pedido
		left Join Localidade DEST With (Nolock) on cd_dst_HIA=DEST.cd_local
		Left Join PO_HIA DI With (Nolock) on DI.Num_Proc_HIA=hou.num_proc_HIA and DI.id_dc=5
		Left Join PO_HIA PO With (Nolock) on PO.Num_Proc_HIA=hou.num_proc_HIA and PO.id_dc=1
		left Join Fatura_CHB FCHB With (Nolock) on HOU.Num_Proc_HIA = FCHB.Processo_PC
		Left Join PO_HIA LI With (Nolock) on LI.Num_Proc_HIA=hou.num_proc_HIA and LI.id_dc=23
		join Tarefas_Processos EP With (Nolock) on EP.Num_Proc = HOU.Num_Proc_Hia and EP.ID_Task = 13
--		left join Proc_NCM PNCM on PNCM.Num_Proc = HOU.Num_Proc_Hia
--		left join NCM NCM on PNCM.ID_NCM = NCM.ID_NCM
		join Grupo G With (Nolock) on G.grupo= right(left(HOU.Num_Proc_HIA,5),3)
		join pessoa PG With (Nolock) on PG.cd_pes=G.cd_pes_grupo
		Left Join Campo_Processo CPP With (Nolock) on CPP.num_proc=num_proc_lia and id_campo=32
		LEft Join hist_geral With (Nolock) on  HSGprocesso=num_proc_lia and cd_tp_ocor=28
	where
		FCHB.Data_PC is null and DI.Numero_PO_Hia is null
			and (Campo_dados <> '2' or Campo_Dados is null)
			and hsgprocesso is null and convert(datetime,HOU.Dt_Emis_HIA,105) >= getdate() -365
	group by
		hou.Num_Proc_HIA,
		hou.MAWB_HIA ,
		HAWB_HIA,
		Num_Pedido,
		Num_Po,PO.numero_po_HIA,
		DEST.Nome_Local,
		ETA_LIA,
		ATA_LIA,
		ETD_LIA,
		ATD_LIA,
		LI.Numero_PO_HIA,
		LI.Data_PO_HIA,
		DI.Numero_PO_HIA, 
		DI.Data_PO_HIA,
		Canal_LIA,
		FCHB.Data_PC,
		EP.Dt_Conclusao,
--		NCM.NCM,
--		NCM.Descricao_NCM,
		PG.Apelido

	Union All


	select DISTINCT
		hou.Num_Proc_HIO 						Processo,
		hou.MAWB_HIO 							MAWB,
		HAWB_HIO 								HAWB,
		Num_Pedido,
		Isnull(Num_Po,PO.numero_po_HIO)			Num_PO,
		null	 								Navio,
		DEST.Nome_Local 						Destino,
		ETA_LIO 								ETA,
		ATA_LIO 								ATA,
		dbo.fBusca_Tarefa(hou.num_proc_hio,60)	Abertura_Pasta,
		ETD_LIO									ETD,
		ATD_LIO									ATD,
		dbo.fBusca_Tarefa(hou.num_proc_hio,28)	Entrada_Terminal,
		dbo.fBusca_Tarefa(hou.num_proc_hio,29)	Desova,
		dbo.fBusca_Tarefa(hou.num_proc_hio,15)	PresencaCarga,
		dbo.fBusca_Tarefa(hou.num_proc_hio,27)	Digitacao_DI,
		dbo.fBusca_Tarefa(hou.num_proc_hio,4)	Desembaraco,
		dbo.fBusca_Tarefa(hou.num_proc_hio,30)	Ins_Madeira,
		dbo.fBusca_Tarefa(hou.num_proc_hio,23)	Envio_Docs_Cambio,
		dbo.fBusca_Tarefa(hou.num_proc_hio,7)	Entr_Docs_Transp,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_hio,13) Prev_Entrega,
		dbo.fBusca_Tarefa(hou.num_proc_hio,13)	Entrega_Planta,
		dbo.fBusca_Tarefa(hou.num_proc_hio,26)	Envio_Docs_Faturamento,
		dbo.FBusca_Adto(hou.num_proc_hio)		Adto, 
		dbo.FBusca_Caixa(hou.num_proc_hio)		Rcto,
		dbo.fBusca_Tarefa(hou.num_proc_hio,21)	Liberacao_BL,
		dbo.fBusca_Tarefa(hou.num_proc_hio,25)	Pgto_AFRMM,
		LI.Numero_PO_HIo 						Num_LI,
		LI.Data_PO_HIo 							Data_LI,
		dbo.fBusca_Tarefa(hou.num_proc_hio,20)	Def_LI,
		DI.Numero_PO_Hio 						DI, 
		DI.Data_PO_Hio 							Data_DI,
		Canal_Lio 								Canal,
		dbo.fBusca_HistoricoDescr_Completo(hou.num_proc_hio) Historico,
		FCHB.Data_PC							Prest_Contas,
		dbo.fBusca_Terminal(HOU.Num_Proc_HIO)	Nome_Terminal,
		EP.Dt_Conclusao,
--		NCM.NCM,
--		NCM.Descricao_NCM,
		PG.Apelido								Nome_Grupo,
		dbo.fBusca_Tarefa(hou.num_proc_hio,42)	Red_Container,
		dbo.fBusca_Tarefa(hou.num_proc_hio,71)	Recb_pasta_CHB
		

	from house_imp_Out HOU With (Nolock)
		Join LLp_imp_Out LLP With (Nolock) on LLP.num_proc_LIO=hou.num_proc_HIO
		left Join Pedido_Ship PS With (Nolock) on PS.num_proc=hou.num_proc_HIO
		left Join Pedido PD With (Nolock) on PD.cd_pedido=PS.cd_pedido
		left Join Localidade DEST With (Nolock) on cd_dst_HIO=DEST.cd_local
		Left Join PO_HIO DI With (Nolock) on DI.Num_Proc_HIO=hou.num_proc_HIO and DI.id_dc=5
		Left Join PO_HIO PO With (Nolock) on PO.Num_Proc_HIO=hou.num_proc_HIO and PO.id_dc=1
		left Join Fatura_CHB FCHB With (Nolock) on HOU.Num_Proc_HIO = FCHB.Processo_PC
		Left Join PO_HIO LI With (Nolock) on LI.Num_Proc_HIO=hou.num_proc_HIO and LI.id_dc=23
		join Tarefas_Processos EP With (Nolock) on EP.Num_Proc = HOU.Num_Proc_Hio and EP.ID_Task = 13
--		left join Proc_NCM PNCM on PNCM.Num_Proc = HOU.Num_Proc_Hio
--		left join NCM NCM on PNCM.ID_NCM = NCM.ID_NCM
		join Grupo G With (Nolock) on G.grupo= right(left(HOU.Num_Proc_HIO,5),3)
		join pessoa PG With (Nolock) on PG.cd_pes=G.cd_pes_grupo
		LEft Join hist_geral With (Nolock) on  HSGprocesso=num_proc_lio and cd_tp_ocor=28
	where
		FCHB.Data_PC is null and DI.Numero_PO_Hio is null and hsgprocesso is null and convert(datetime,HOU.Dt_Emis_HIO,105) >= getdate() -365
	group by
		hou.Num_Proc_HIO,
		hou.MAWB_HIO ,
		HAWB_HIO,
		Num_Pedido,
		Num_Po,PO.numero_po_HIO,
		DEST.Nome_Local,
		ETA_LIO,
		ATA_LIO,
		ETD_LIO,
		ATD_LIO,
		LI.Numero_PO_HIO,
		LI.Data_PO_HIO,
		DI.Numero_PO_HIO, 
		DI.Data_PO_HIO,
		Canal_LIO,
		FCHB.Data_PC,
		EP.Dt_Conclusao,
--		NCM.NCM,
--		NCM.Descricao_NCM,
		PG.Apelido
END







GO
