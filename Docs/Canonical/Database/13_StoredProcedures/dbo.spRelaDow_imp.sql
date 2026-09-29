SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE       Procedure [dbo].[spRelaDow_imp] --'0'
(
	@Tipo	bit -- 0 = Open, 1 = Closed
)
as

select
	Distinct
	hou.Num_Proc_HIM										Processo,
	hou.MAWB_HIM											MAWB,
	HAWB_HIM												HAWB,
	ETA_LIM													ETA,
	ATA_LIM													ATA,
	ETD_LIM													ETD,
	ATD_LIM													ATD, 
	Nome_Armador											Armador,
	Navio_HIM												Navio, 
	Num_Pedido, 
	Isnull(PO.numero_po_him,Num_Po)							Num_PO,
	isnull(Customer_PO.numero_PO_HIM,Customer_PO)			Customer_PO,
	Org.Nome_Local											Origem,
	Dst.Nome_Local											Destino,
	TP.Dt_Previsao,
	TP.Dt_Conclusao,
	Business_Group_Descr,
	null Tipo,
	Canal_Lim												Canal,
	dbo.fBusca_HistoricoDescr(hou.num_proc_him,0,getdate()) Historico,
	dbo.fBusca_HistoricoDescr_Completo(hou.num_proc_him)	Historico_Completo,
	dbo.FBusca_Adto(hou.num_proc_him)						Adto, 
	dbo.FBusca_Caixa(hou.num_proc_him)						Caixa, 
	DI.Numero_PO_Him										DI, 
	DI.Data_PO_Him											Data_DI,
	dbo.fBusca_Tarefa(hou.num_proc_him,3)					Liberacao_BL,
	ENTREGA.Dt_Previsao										Prev_Entrega,
	ENTREGA.Dt_Conclusao									Entrega_Planta,
	LI.Data_PO_HIM											Data_LI,
	LI.Numero_PO_HIM										Num_LI,
	DefLI.DT_Conclusao										Def_LI,
	ECambio.Dt_Conclusao									Envio_Docs_Cambio,
	(ETA_Lim +7)											Previsao,
	PO_GRP,
	DOCT.DT_Conclusao										Entr_Docs_Transp,
	EnvFAT.Dt_Conclusao										Envio_Docs_Fat,
	PRESENCA.Dt_Conclusao									Presenca_Carga,
	DIG.Dt_Conclusao										Digitacao_DI,
	ENTTErm.Dt_Conclusao									Entrada_Terminal,
	DESOVA.Dt_Conclusao										Desova,
	Madeira.Dt_Conclusao									Receb_Insp_Madeira,
	TERM.Nome_Terminal,
	max(FCHB.Data_PC)										Prest_Contas,
	isnull(PD.Cd_Tipo,'4')									Tipo_Ordem,
	PD.Status,
	NCM.NCM,
	NCM.Descricao_NCM										Des_NCM,
	PD.Planta,
	dbo.fBusca_Containers(hou.num_proc_him)					Containers,
	dbo.Qty_Container(hou.num_proc_him)						Qtde,
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,2)			num_invoice
from
	house_imp_mar HOU						With(nolock)
	Join LLp_imp_mar LLP					With(nolock)  on LLP.num_proc_LIM=hou.num_proc_HIM --and LLP.Ata_lim > getdate() - 180
	Left Join Tarefas_Processos DEFLI		with (nolock) on num_proc_lim=DEFLI.num_proc and DEFLI.id_task=20
	Left Join Tarefas_Processos ChegDocs	with (nolock) on num_proc_lim=ChegDocs.num_proc and ChegDocs.id_task=16
	Left Join Tarefas_Processos ENTTErm		with (nolock) on num_proc_lim=ENTTErm.num_proc and ENTTErm.id_task=28
	Left Join Tarefas_Processos PRESENCA	with (nolock) on num_proc_lim=PRESENCA.num_proc and PRESENCA.id_task=15
	Left Join Tarefas_Processos DESEMB		with (nolock) on num_proc_lim=DESEMB.num_proc and DESEMB.id_task=15
	Left Join Tarefas_Processos DOCT		with (nolock) on num_proc_lim=DOCT.num_proc and DOCT.id_task=7
	Left Join Tarefas_Processos DESOVA		with (nolock) on num_proc_lim=DESOVA.num_proc and DESOVA.id_task=29
	Left Join Tarefas_Processos DIG			with (nolock) on num_proc_lim=DIG.num_proc and DIG.id_task=27
	Left Join Tarefas_Processos EnvFAT		with (nolock) on num_proc_lim=EnvFAT.num_proc and EnvFAT.id_task=26
	Left Join Tarefas_Processos Madeira		with (nolock) on num_proc_lim=Madeira.num_proc and Madeira.id_task=30
	Left Join Tarefas_Processos ECambio		with (nolock) on num_proc_lim=ECambio.num_proc and ECambio.id_task=23
	Left Join Tarefas_Processos	ENTREGA		with (nolock) on ENTREGA.num_proc=hou.num_proc_HIM and ENTREGA.ID_Task=13

	left Join Job_imp_mar				JOB  With(nolock) on JOB.num_proc_him=hou.num_proc_him
	left Join Armador					ARM With(nolock) on ARM.cd_armador=job.cd_armador
	left Join Pedido_Ship				PS With(nolock) on PS.num_proc=hou.num_proc_HIM
	left Join Pedido					PD With(nolock) on PD.cd_pedido=PS.cd_pedido
	Left Join Pedido_Det				PDET With(nolock) on PDET.cd_pedido=PS.cd_pedido --and PDET.cd_produto=PS.cd_produto and (PDET.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PDET.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	left Join Produto_cliente			PC With(nolock) on PC.cd_prod=ps.cd_produto
	left Join DE_Para_Produto			DP With(nolock) on DP.gmid=cd_proc_cliente
	left Join Localidade				Org With(nolock) on hou.cd_org_HIM=Org.cd_local
	left Join Localidade				Dst With(nolock) on cd_dst_HIM=DSt.cd_local
	Left Join Tarefas_Processos			TP With(nolock) on TP.num_proc=hou.num_proc_HIM and TP.ID_Task=4
	Left Join PO_HIM					DI With(nolock) on DI.Num_Proc_Him=hou.num_proc_him and DI.id_dc=5
	Left Join PO_HIM					PO With(nolock) on PO.Num_Proc_Him=hou.num_proc_him and PO.id_dc=1
	Left Join PO_HIM					Customer_PO With(nolock) on Customer_PO.Num_Proc_Him=hou.num_proc_him and Customer_PO.id_dc=9
	Left Join PO_HIM					LI With(nolock) on LI.Num_Proc_Him=hou.num_proc_him and LI.id_dc=23
	Left Join Terminal					TERM With(nolock) on LLP.Cd_Terminal = TERM.Cd_Terminal
	left Join Fatura_CHB				FCHB With(nolock) on HOU.Num_Proc_HIM = FCHB.Processo_PC
	Join Pessoa_LLP						PLL With(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIM and PLL.Cd_Pes_Grupo='1'
	left join Proc_NCM					PNCM With(nolock) on PNCM.Num_Proc = HOU.Num_Proc_Him
	left join NCM						NCM With(nolock) on PNCM.ID_NCM = NCM.ID_NCM
where
	Etd_Lim >=getdate()-180 and (
	((( isnull(PD.Cd_Tipo,'4') = '4' and FCHB.Data_PC is not null) or ENTREGA.Dt_Conclusao is not null or PD.status = 'E') and TP.dt_Conclusao > = '2012-01-01' and @Tipo = 1)
	or
	( ENTREGA.Dt_Conclusao is null and PD.status <> 'E' and @Tipo = 0)
	)
group by
	ECambio.Dt_Conclusao,
	DefLI.DT_Conclusao,
	Madeira.Dt_Conclusao,
	EnvFat.Dt_Conclusao,
	DESOVA.DT_Conclusao,
	PRESENCA.Dt_Conclusao,
	DIG.Dt_Conclusao,
	DOCT.DT_Conclusao,
	hou.Num_Proc_HIM,
	hou.MAWB_HIM,
	HAWB_HIM,
	ETA_LIM,
	ATA_LIM,
	ETD_LIM,
	ATD_LIM,
	Nome_Armador,
	Navio_HIM,
	Num_Pedido,
	Num_Po,
	Customer_PO,
	Org.Nome_Local,
	Dst.Nome_Local,
	TP.Dt_Previsao,
	TP.Dt_Conclusao,
	Business_Group_Descr,
	ATA_LIM,
	Canal_Lim,
	dbo.FBusca_Adto(hou.num_proc_him),
	dbo.FBusca_Caixa(hou.num_proc_him),
	DI.Numero_PO_Him,
	DI.Data_PO_Him,
	po.numero_po_him,
	customer_PO.numero_po_him,
	/*FCHB.Data_PC,
	*/LI.Data_PO_HIM,
	LI.Numero_PO_HIM,
	PO_GRP,
	TERM.Nome_Terminal,
	PD.Cd_Tipo,
	PD.Status,
	NCM.NCM,
	NCM.Descricao_NCM,
	PD.Planta,
	ENTREGA.Dt_Conclusao,
	ENTREGA.Dt_Previsao,
	ENTTErm.Dt_Conclusao


UNION ALL

select
	Distinct
	hou.Num_Proc_HIA										Processo,
	hou.MAWB_HIA											MAWB,
	HAWB_HIA												HAWB,
	ETA_LIA													ETA,
	ATA_LIA													ATA,
	ETD_LIA													ETD,
	ATD_LIA													ATD,
	Nome_Cia_Aer											Armador,
	Voo_HIA													Navio,
	Num_Pedido, 
	Isnull(po.numero_po_hia,Num_Po)							num_po,
	Isnull(Customer_PO.numero_po_hia,
	Customer_PO)											Customer_PO,
	Org.Nome_Local											Origem,
	Dst.Nome_Local											Destino,
	TP.Dt_Previsao,
	TP.Dt_Conclusao,
	Business_Group_Descr,
	null,
	Canal_Lia												Canal,
	dbo.fBusca_HistoricoDescr(hou.num_proc_hia,0,getdate()) Historico,
	dbo.fBusca_HistoricoDescr_Completo(hou.num_proc_hia)	Historico_Completo,
	dbo.FBusca_Adto(hou.num_proc_hia)						Adto,
	dbo.FBusca_Caixa(hou.num_proc_hia)						Caixa,
	DI.Numero_PO_Hia DI, DI.Data_PO_Hia						Data_DI,
--	dbo.fBusca_Tarefa(hou.num_proc_hia,3)					Liberacao_BL,
	LIBER.DT_Conclusao										Liberacao_BL,
	ENTREGA.Dt_Previsao										Prev_Entrega,
	ENTREGA.Dt_Conclusao									Entrega_Planta,
	LI.Data_PO_HIA											Data_LI,
	LI.Numero_PO_HIA										Num_LI,
--	dbo.fBusca_Tarefa(hou.num_proc_hia,20)					Def_LI,
	DEFLI.Dt_Conclusao										Def_LI,
--	dbo.fBusca_Tarefa(hou.num_proc_hia,23)					Envio_Docs_Cambio,
	ECambio.Dt_Conclusao									Envio_Docs_Cambio,
	Isnull(dbo.fBusca_Historico_DataFU(hou.num_proc_hia,54),ETA_Lia +7)	Previsao,
	PO_GRP,
--	dbo.fBusca_Tarefa(hou.num_proc_hia,7)					Entr_Docs_Transp,
	DOCT.Dt_Conclusao										Entr_Docs_Transp,	
--	dbo.fBusca_Tarefa(hou.num_proc_hia,26)					Envio_Docs_Fat,
	EnvFAT.Dt_Conclusao										Envio_Docs_Fat,
--	dbo.fBusca_Tarefa(hou.num_proc_hia,15)					Presenca_Carga,
	DESEMB.Dt_Conclusao										Presenca_Carga,
--	dbo.fBusca_Tarefa(hou.num_proc_hia,27)					Digitacao_DI,
	DIG.Dt_Conclusao										Digitacao_DI,
--	dbo.fBusca_Tarefa(hou.num_proc_hia,28)					Entrada_Terminal,
	ENTTErm.Dt_Conclusao									Entrada_Terminal,
--	dbo.fBusca_Tarefa(hou.num_proc_hia,29)					Desova,
	DESOVA.Dt_Conclusao										Desova,
--	dbo.fBusca_Tarefa(hou.num_proc_hia,30)					Receb_Insp_Madeira,
	Madeira.Dt_Conclusao									Receb_Insp_Madeira,
	TERM.Nome_Terminal,
	max(FCHB.Data_PC)										Prest_Contas,
	isnull(PD.Cd_Tipo,'4')									Tipo_Ordem,
	PD.Status,
	NCM.NCM,
	NCM.Descricao_NCM										Des_NCM,
	PD.Planta,
	Null													Containers,
	Null													Qtde,
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIA,2)			num_invoice
from
	house_imp_AER HOU With(nolock)
	Join LLp_imp_AER			LLP With(nolock) on LLP.num_proc_LIA=hou.num_proc_HIA --and LLP.Ata_liA > getdate() - 180

	Left Join Tarefas_Processos TP			WITH (NOLOCK) on hou.num_proc_HIA	=	TP.num_proc			and TP.ID_Task=4
	Left join Tarefas_processos LIBER		WITH (nolock) on hou.num_proc_HIA	=	LIBER.num_proc		and LIBER.id_task=3
	Left Join Tarefas_Processos ENTREGA		WITH (NOLOCK) on hou.num_proc_HIA	=	ENTREGA.num_proc	and ENTREGA.ID_Task=13
	Left Join Tarefas_Processos DEFLI		with (nolock) on hou.num_proc_HIA	=	DEFLI.num_proc		and DEFLI.id_task=20
	Left Join Tarefas_Processos ECambio		with (nolock) on hou.num_proc_HIA	=	ECambio.num_proc	and ECambio.id_task=23
	Left Join Tarefas_Processos DOCT		with (nolock) on hou.num_proc_HIA	=	DOCT.num_proc		and DOCT.id_task=7
	Left Join Tarefas_Processos EnvFAT		with (nolock) on hou.num_proc_HIA	=	EnvFAT.num_proc		and EnvFAT.id_task=26
	Left Join Tarefas_Processos DESEMB		with (nolock) on hou.num_proc_HIA	=	DESEMB.num_proc		and DESEMB.id_task=15
	Left Join Tarefas_Processos DIG			with (nolock) on hou.num_proc_HIA	=	DIG.num_proc		and DIG.id_task=27
	Left Join Tarefas_Processos ENTTErm		with (nolock) on hou.num_proc_HIA	=	ENTTErm.num_proc	and ENTTErm.id_task=28
	Left Join Tarefas_Processos DESOVA		with (nolock) on hou.num_proc_HIA	=	DESOVA.num_proc		and DESOVA.id_task=29
	Left Join Tarefas_Processos Madeira		with (nolock) on hou.num_proc_HIA	=	Madeira.num_proc	and Madeira.id_task=30


	left Join Job_imp_aer		JOB With(nolock) on JOB.num_proc_hia=HOU.num_proc_hia
	left Join Cia_Aerea			ARM With(nolock) on ARM.cd_cia_Aer=job.cd_cia_aer
	left Join Pedido_Ship		PS With(nolock) on PS.num_proc=hou.num_proc_HIA
	left Join Pedido			PD With(nolock) on PD.cd_pedido=PS.cd_pedido
	Left Join Pedido_Det		PDET With(nolock) on PDET.cd_pedido=PS.cd_pedido --and PDET.cd_produto=PS.cd_produto and (PDET.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PDET.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	left Join Produto_cliente	PC With(nolock) on PC.cd_prod=ps.cd_produto
	left Join DE_Para_Produto	DP With(nolock) on DP.gmid=cd_proc_cliente
	left Join Localidade		Org With(nolock) on hou.cd_org_HIA=Org.cd_local
	left Join Localidade		Dst With(nolock) on cd_dst_HIA=DSt.cd_local
	
	Left Join PO_HIA			DI With(nolock) on DI.Num_Proc_Hia=hou.num_proc_hia and id_dc=5
	Left Join PO_HIA			PO With(nolock) on PO.Num_Proc_Hia=hou.num_proc_hia and PO.id_dc=1
	Left Join PO_HIA			Customer_PO With(nolock) on Customer_PO.Num_Proc_Hia=hou.num_proc_hia and Customer_PO.id_dc=9
	Left Join PO_HIA			LI With(nolock) on LI.Num_Proc_Hia=hou.num_proc_hia and LI.id_dc=23
	
	Left Join Terminal			TERM With(nolock) on LLP.Cd_Terminal = TERM.Cd_Terminal
	left Join Fatura_CHB		FCHB With(nolock) on HOU.Num_Proc_HIA = FCHB.Processo_PC
	Join Pessoa_LLP				PLL With(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIA and PLL.Cd_Pes_Grupo='1'
	left join Proc_NCM			PNCM With(nolock) on PNCM.Num_Proc = HOU.Num_Proc_Hia
	left join NCM				NCM With(nolock) on PNCM.ID_NCM = NCM.ID_NCM
where
	ETD_LIA >=getdate()-180 
	and
	(	
	((( isnull(PD.Cd_Tipo,'4') = '4' and FCHB.Data_PC is not null) or ENTREGA.Dt_Conclusao is not null or PD.status = 'E') and TP.dt_Conclusao > = '2012-01-01' and @Tipo = 1)
	or
	( ENTREGA.Dt_Conclusao is null and PD.status <> 'E' and @Tipo = 0)
	)
group by
	hou.Num_Proc_HIA,
	hou.MAWB_HIA,
	HAWB_HIA,
	ETA_LIA,
	ATA_LIA,
	ETD_LIA,
	ATD_LIA,
	Nome_Cia_Aer,
	Voo_HIA,
	Num_Pedido,
	Num_Po,
	Customer_PO,
	Org.Nome_Local,
	Dst.Nome_Local,
	TP.Dt_Previsao,
	TP.Dt_Conclusao,
	Business_Group_Descr,
	Canal_Lia,
	dbo.FBusca_Adto(hou.num_proc_hia),
	dbo.FBusca_Caixa(hou.num_proc_hia),
	DI.Numero_PO_Hia,
	DI.Data_PO_Hia,
	PO.Numero_PO_HIA,
	Customer_PO.Numero_PO_HIA,
	/*FCHB.Data_PC,
	*/LI.Data_PO_HIA,
	LI.Numero_PO_HIA,
	PO_GRP,
	TERM.Nome_Terminal,
	PD.Cd_Tipo,
	PD.Status,
	NCM.NCM,
	NCM.Descricao_NCM,
	PD.Planta,
	ENTREGA.Dt_Conclusao,
	ENTREGA.Dt_Previsao,

	LIBER.DT_Conclusao,
	DEFLI.Dt_Conclusao,
	ECambio.Dt_Conclusao,
	DOCT.Dt_Conclusao,
	EnvFAT.Dt_Conclusao,
	DESEMB.Dt_Conclusao,
	DIG.Dt_Conclusao,
	ENTTErm.Dt_Conclusao,
	DESOVA.Dt_Conclusao,
	Madeira.Dt_Conclusao

UNION ALL

select Distinct
	hou.Num_Proc_HIO									Processo,
	MAWB_HIO											MAWB,
	HAWB_HIO											HAWB,
	ETA_LIO												ETA,
	ATA_LIO												ATA,
	ETD_LIO												ETD,
	ATD_LIO												ATD,
	Nome_Raz_Soc										Armador,
	Null Navio,
	Num_Pedido, 
	ISNULL(PO.NUMERO_PO_HIO,Num_Po)						NUM_PO,
	ISNULL(CUSTOMER_PO.NUMERO_PO_HIO,Customer_PO)		CUSTOMER_PO,
	Org.Nome_Local										Origem,
	Dst.Nome_Local										Destino,
	TP.Dt_Previsao,
	TP.Dt_Conclusao,
	Business_Group_Descr,
	Tipo_LIO,
	Canal_Lio											Canal,
	dbo.fBusca_HistoricoDescr(hou.num_proc_hio,0,getdate()),
	dbo.fBusca_HistoricoDescr_Completo(hou.num_proc_hio) Historico_Completo,
	dbo.FBusca_Adto(hou.num_proc_hio),
	dbo.FBusca_Caixa(hou.num_proc_hio),
	DI.Numero_PO_Hio									DI,
	DI.Data_PO_Hio										Data_DI,
--	dbo.fBusca_Tarefa(hou.num_proc_hio,3)				Liberacao_BL,
	LIBER.Dt_Conclusao									Liberacao_BL,
	ENTREGA.Dt_Previsao									Prev_Entrega,
	ENTREGA.Dt_Conclusao								Entrega_Planta,
	LI.Data_PO_HIO										Data_LI,
	LI.Numero_PO_HIO									Num_LI,
--	dbo.fBusca_Tarefa(hou.num_proc_hio,20)				Def_LI,
	DEFLI.Dt_Conclusao									Def_LI,
--	dbo.fBusca_Tarefa(hou.num_proc_hio,23)				Envio_Docs_Cambio,
	ECambio.Dt_Conclusao								Envio_Docs_Cambio,	
	Isnull(dbo.fBusca_Historico_DataFU(hou.num_proc_hio,54),
	ETA_Lio +7)											Previsao,
	PO_GRP,
--	dbo.fBusca_Tarefa(hou.num_proc_hio,7)				Entr_Docs_Transp,
	DOCT.Dt_Conclusao									Entr_Docs_Transp,
--	dbo.fBusca_Tarefa(hou.num_proc_hio,26)				Envio_Docs_Fat,
	EnvFAT.Dt_Conclusao									Envio_Docs_Fat,
--	dbo.fBusca_Tarefa(hou.num_proc_hio,15)				Presenca_Carga,
	DESEMB.Dt_Conclusao									Presenca_Carga,
--	dbo.fBusca_Tarefa(hou.num_proc_hio,27)				Digitacao_DI,
	DIG.Dt_Conclusao									Digitacao_DI,	
--	dbo.fBusca_Tarefa(hou.num_proc_hio,28)				Entrada_Terminal,
	ENTTErm.Dt_Conclusao								Entrada_Terminal,
--	dbo.fBusca_Tarefa(hou.num_proc_hio,29)				Desova,
	DESOVA.Dt_Conclusao									Desova,
--	dbo.fBusca_Tarefa(hou.num_proc_hio,30)				Receb_Insp_Madeira,
	Madeira.Dt_Conclusao								Receb_Insp_Madeira,	
	TERM.Nome_Terminal,
	max(FCHB.Data_PC)									Prest_Contas,
	isnull(PD.Cd_Tipo,'4')								Tipo_Ordem,
	PD.Status,
	NCM.NCM,
	NCM.Descricao_NCM									Des_NCM,
	PD.Planta,
	dbo.fBusca_Containers(hou.num_proc_hio)				Containers,
	dbo.Qty_Container(hou.num_proc_hio)					Qtde,
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIo,2)		num_invoice
from
	house_imp_out		HOU With(nolock)
	Join LLp_imp_out	LLP With(nolock) on LLP.num_proc_LIO=hou.num_proc_HIO --and LLP.Ata_liO > getdate() - 180

	Left Join Tarefas_Processos	TP			WITH(NOLOCK) on	hou.num_proc_HIO	=	TP.num_proc			and TP.ID_Task=4	
	Left join Tarefas_processos LIBER		WITH(NOLOCK) on	hou.num_proc_HIO	=	LIBER.num_proc		and LIBER.id_task=3
	Left Join Tarefas_Processos	ENTREGA		WITH(NOLOCK) on	hou.num_proc_HIO	=	ENTREGA.num_proc	and ENTREGA.ID_Task=13
	Left Join Tarefas_Processos DEFLI		WITH(NOLOCK) on	hou.num_proc_HIO	=	DEFLI.num_proc		and DEFLI.id_task=20
	Left Join Tarefas_Processos ECambio		WITH(NOLOCK) on	hou.num_proc_HIO	=	ECambio.num_proc	and ECambio.id_task=23
	Left Join Tarefas_Processos DOCT		WITH(NOLOCK) on	hou.num_proc_HIO	=	DOCT.num_proc		and DOCT.id_task=7
	Left Join Tarefas_Processos EnvFAT		WITH(NOLOCK) on	hou.num_proc_HIO	=	EnvFAT.num_proc		and EnvFAT.id_task=26
	Left Join Tarefas_Processos DESEMB		WITH(NOLOCK) on	hou.num_proc_HIO	=	DESEMB.num_proc		and DESEMB.id_task=15
	Left Join Tarefas_Processos DIG			WITH(NOLOCK) on	hou.num_proc_HIO	=	DIG.num_proc		and DIG.id_task=27
	Left Join Tarefas_Processos ENTTErm		WITH(NOLOCK) on	hou.num_proc_HIO	=	ENTTErm.num_proc	and ENTTErm.id_task=28
	Left Join Tarefas_Processos DESOVA		WITH(NOLOCK) on	hou.num_proc_HIO	=	DESOVA.num_proc		and DESOVA.id_task=29
	Left Join Tarefas_Processos Madeira		WITH(NOLOCK) on	hou.num_proc_HIO	=	Madeira.num_proc	and Madeira.id_task=30

	left Join Pessoa					ARM With(nolock) on ARM.cd_pes=llp.cd_carrier
	left Join Pedido_Ship				PS With(nolock) on PS.num_proc=hou.num_proc_HIO
	left Join Pedido					PD With(nolock) on PD.cd_pedido=PS.cd_pedido
	Left Join Pedido_Det				PDET With(nolock) on PDET.cd_pedido=PS.cd_pedido --and PDET.cd_produto=PS.cd_produto and (PDET.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PDET.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	left Join Produto_cliente			PC With(nolock) on PC.cd_prod=ps.cd_produto
	left Join DE_Para_Produto			DP With(nolock) on DP.gmid=cd_proc_cliente
	left Join Localidade				Org With(nolock) on hou.cd_org_HIO=Org.cd_local
	left Join Localidade				Dst With(nolock) on cd_dst_HIO=DSt.cd_local
	
	Left Join PO_HIO					DI With(nolock) on DI.Num_Proc_Hio=hou.num_proc_hio and id_dc=5
	Left Join PO_HIo					PO With(nolock) on PO.Num_Proc_HiO=hou.num_proc_hiO and PO.id_dc=1
	Left Join PO_HIO					Customer_PO With(nolock) on Customer_PO.Num_Proc_HiO=hou.num_proc_hiO and Customer_PO.id_dc=9
	Left Join PO_HIO					LI With(nolock) on LI.Num_Proc_Hio=hou.num_proc_hio and LI.id_dc=23
	
	Left Join Terminal					TERM With(nolock) on LLP.Cd_Terminal = TERM.Cd_Terminal
	left Join Fatura_CHB				FCHB With(nolock) on HOU.Num_Proc_HIO = FCHB.Processo_PC
	Join Pessoa_LLP						PLL With(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIO and PLL.Cd_Pes_Grupo='1'
	left join Proc_NCM					PNCM With(nolock) on PNCM.Num_Proc = HOU.Num_Proc_Hio
	left join NCM						NCM With(nolock) on PNCM.ID_NCM = NCM.ID_NCM
where
	Etd_LiO >=getdate()-180 And (
	((( isnull(PD.Cd_Tipo,'4') = '4' and FCHB.Data_PC is not null) or ENTREGA.Dt_Conclusao is not null or PD.status = 'E') and TP.dt_Conclusao > = '2012-01-01' and @Tipo = 1)
	or
	( ENTREGA.Dt_Conclusao is null and PD.status <> 'E' and @Tipo = 0)
	)	
group by
	hou.Num_Proc_HIO,
	MAWB_HIO,
	HAWB_HIO,
	ETA_LIO,
	ATA_LIO,
	ETD_LIO,
	ATD_LIO,
	Nome_Raz_Soc,
	Num_Pedido,
	Num_Po,
	Customer_PO,
	Org.Nome_Local,
	Dst.Nome_Local,
	TP.Dt_Previsao,
	TP.Dt_Conclusao,
	Business_Group_Descr,
	Tipo_LIO,
	Canal_LiO,
	dbo.FBusca_Adto(hou.num_proc_hio),
	dbo.FBusca_Caixa(hou.num_proc_hio),
	DI.Numero_PO_Hio,
	DI.Data_PO_Hio,
	PO.Numero_PO_HIO,
	Customer_PO.Numero_PO_HIO,
	/*FCHB.Data_PC,
	*/LI.Data_PO_HIO,
	LI.Numero_PO_HIO,
	PO_GRP,
	TERM.Nome_Terminal,
	PD.Cd_Tipo,
	PD.Status,
	NCM.NCM,
	NCM.Descricao_NCM,
	PD.Planta,
	ENTREGA.Dt_Conclusao,
	ENTREGA.Dt_Previsao,
	LIBER.DT_Conclusao,
	DEFLI.Dt_Conclusao,
	ECambio.Dt_Conclusao,
	DOCT.Dt_Conclusao,
	EnvFAT.Dt_Conclusao,
	DESEMB.Dt_Conclusao,
	DIG.Dt_Conclusao,
	ENTTErm.Dt_Conclusao,
	DESOVA.Dt_Conclusao,
	Madeira.Dt_Conclusao

order by 

	Processo




GO
