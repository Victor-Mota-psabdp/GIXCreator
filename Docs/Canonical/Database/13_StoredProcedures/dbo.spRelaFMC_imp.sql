SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Incluido modal truck
--[dbo].[spRelaFMC_imp] 'FMC'
CREATE  Procedure [dbo].[spRelaFMC_imp] 
(
@Grupo as varchar(3)
)
As

	declare @Cd_Grupo as varchar(10)
	set @Cd_Grupo = (select Cd_Pes_Grupo from grupo where Grupo = @Grupo)
--Imp Mar

select distinct
	HOU.Num_Proc_Him													Processo,
	hou.MAWB_HIM														MAWB,
	HAWB_HIM															HAWB,
	ETA_LIM																ETA,
	ATA_LIM																ATA,
	ETD_LIM																ETD,
	ATD_LIM																ATD, 
	Nome_Armador														Armador,
	Navio_HIM Navio, 
	Num_Pedido, 
	dbo.fBusca_TipoDocCliente('N', HOU.Num_Proc_Him, 1)					Num_PO,
	dbo.fBusca_TipoDocCliente('N', HOU.Num_Proc_Him, 9)					Customer_PO,
	Org.Nome_Local														Origem,
	Dst.Nome_Local														Destino,
	TP.Dt_Previsao,
	TP.Dt_Conclusao,	
	Isnull(Business_Group_Descr,Produto_Descr)							Business_Group_Descr,
	null Tipo,
	Canal_Lim															Canal,
	dbo.fBusca_HistoricoDescr(HOU.Num_Proc_Him,0,getdate())				Historico_Completo,
--	dbo.fBusca_HistoricoDescr_Completo(HOU.Num_Proc_Him)				Historico_Completo,
	dbo.FBusca_Adto(HOU.Num_Proc_Him)									Adto, 
	dbo.FBusca_Caixa(HOU.Num_Proc_Him)									Caixa, 
	dbo.fBusca_TipoDocCliente('N', HOU.Num_Proc_Him, 5)					DI, 
	dbo.fBusca_TipoDocCliente('D', HOU.Num_Proc_Him, 5)					Data_DI,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Him,3)								Liberacao_BL,
	ENTREGA.dt_previsao													Prev_Entrega,
	Entrega.dt_conclusao												Entrega_Planta,
	dbo.fBusca_TipoDocCliente('D', HOU.Num_Proc_Him, 23)				Data_LI,
	dbo.fBusca_TipoDocCliente('N', HOU.Num_Proc_Him, 23)				Num_LI,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Him,20)								Def_LI,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Him,23)								Envio_Docs_Cambio,
	Isnull(dbo.fBusca_Historico_DataFU(HOU.Num_Proc_Him,54),ETA_Lim +7)	Previsao,
	PO_GRP,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Him,7)								Entr_Docs_Transp,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Him,26)								Envio_Docs_Fat,
	PRESENCA.DT_Conclusao												Presenca_Carga,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Him,27)								Digitacao_DI,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Him,28)								Entrada_Terminal,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Him,29)								Desova,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Him,30)								Receb_Insp_Madeira,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Him,39)								Autoriz_Embarque,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Him,17)								Soli_DTA,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Him,18)								Libe_DTA,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Him,19)								Remocao,
	dbo.fBusca_Historico_DataFU(HOU.Num_Proc_Him,13)					Sol_Insp_Produto,
	TERM.Nome_Terminal,
	isnull(dbo.fBusca_Tarefa(hou.num_proc_him,14),dbo.fBusca_Tarefa(hou.num_proc_him,40)) Prest_Contas,
	PC.Cd_Proc_Cliente,
	dbo.fBusca_PRODUTO(HOU.Num_Proc_Him)								Produto_Descr,
	dbo.fBusca_TipoDocCliente('N', HOU.Num_Proc_Him, 25)				Requerimento,
	UC.Nome_Usuario,
	PS.Qty,
	dbo.fBusca_Containers_IM(HOU.Num_Proc_Him)							Containers,
	dbo.fBusca_TipoDocCliente('N', HOU.Num_Proc_Him, 45)				Num_DTA,
	PD.Dl_Chegada														Prev_Entre_Plan,
	HOU.Dt_Emis_HIM														Abertura_JOB,
	BB.Apelido															Buyer,
	PDET.UoM															UOM,
	PDET.Peso_Liquido_TOT												KG,
	dbo.fBusca_TipoDocCliente('D', HOU.Num_Proc_Him, 23)				Emissao_LI,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Him,51)								Entrada_Reque,
	dbo.fBusca_Tarefa_Prev(HOU.Num_Proc_Him,52)							Prev_Ini_Prod,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Him,52)								Ini_Prod,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Him,53)								Descarga,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Him,16)								Docs_BDP,
	FCHB.Data_PC														Cobranca,
	dbo.fBusca_TipoDocCliente('N', HOU.Num_Proc_Him, 2)					Invoice_Num,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Him,54)								Lib_P_Remocao,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Him,55)								Chegada_EADI,
	TP.Dt_Conclusao														Desembaraco_DI,
--	CMIM.Dt_Vcto_Devol_IM Dt_Vcto_Devol,
--	CMIM.Dt_Devol_IM Dt_Devol,
	PD.Incoterm,
	dbo.fbusca_TEUS(HOU.Num_Proc_Him)									TEUS,
	PD.Planta,
	Entrega.Dt_Previsao													Chegada_Estimada,
	PD.Dl_Chegada														Chegada_Requerida,
	dbo.fBusca_CampoCliente(HOU.Num_Proc_Him, 1)						Fabricante,
	dbo.fBusca_CampoCliente(HOU.Num_Proc_Him, 2)						Terminal_Entrada,
	dbo.fBusca_CampoCliente(HOU.Num_Proc_Him, 3)						Devolution_Term,
	dbo.fBusca_CampoCliente(HOU.Num_Proc_Him, 4)						Canal_DTA,
	LLP.Vlr_Invoice														Valor_Invoice,
	PLA.nome_local														Planta_Origem,
	DSTF.nome_local														Local_Destino,
	PCB.concentracao													Concentracao,
	convert(datetime, dbo.fBusca_CampoCliente(HOU.Num_Proc_Him, 28), 105) BL_DATE,
	convert(datetime, dbo.fBusca_CampoCliente(HOU.Num_Proc_Him, 29), 105) vencimento_fatura,
	PDET.Peso_Bruto_TOT													Peso_Bruto,
	dbo.fbusca_docs_po_modal(HOU.num_proc_him,10)						NF,
	LLP.Original_ETA_LIM + 15											Prev_Entr_Original,
	PS.Item,
	DRAFT.Dt_Conclusao													Aprova_Draft
from
	house_imp_mar HOU With(nolock)
	 INNER HASH  JOIN		LLp_imp_mar					LLP With(nolock) on LLP.num_proc_LIM=HOU.Num_Proc_Him
	left HASH JOIN	Job_imp_mar					JOB With(nolock) on JOB.num_proc_him=HOU.Num_Proc_Him
	left HASH JOIN	Armador						ARM With(nolock) on ARM.cd_armador=job.cd_armador
	left HASH JOIN	Pedido_Ship					PS With(nolock) on PS.num_proc=HOU.Num_Proc_Him
	INNER HASH JOIN		Pedido						PD With(nolock) on PD.cd_pedido=PS.cd_pedido 
	left HASH JOIN	Pessoa						BB With(nolock) on BB.cd_pes=PD.cd_buyer
	Left HASH JOIN	Pedido_Det					PDET With(nolock) on PDET.cd_produto=PS.cd_produto and PDET.cd_pedido=PS.cd_pedido and pdet.lote=ps.lote and pdet.item=ps.item --and PDET.cd_produto=PS.cd_produto and (PDET.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PDET.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	left HASH JOIN	Produto_cliente				PC With(nolock) on PC.cd_prod=ps.cd_produto
	left HASH JOIN	DE_Para_Produto				DP With(nolock) on DP.gmid=cd_proc_cliente
	left HASH JOIN	Localidade					Org With(nolock)	on hou.cd_org_HIM=Org.cd_local
	left HASH JOIN	Localidade					Dst With(nolock)	on cd_dst_HIM=DSt.cd_local
	Left HASH JOIN	Tarefas_Processos			PRESENCA  With (nolock) on PRESENCA.num_proc=Num_Proc_LIM and PRESENCA.ID_Task=15
	Left HASH JOIN	Tarefas_Processos			DRAFT  With (nolock) on DRAFT.num_proc=Num_Proc_LIM and DRAFT.ID_Task=41
	Left HASH JOIN	Tarefas_Processos			TP With (nolock) on TP.num_proc=Num_Proc_LIM and TP.ID_Task=4
	Left HASH JOIN	Tarefas_Processos			ENTREGA  With (nolock) on ENTREGA.num_proc=Num_Proc_LIM and ENTREGA.ID_Task=13
	Left HASH JOIN	Terminal					TERM With(nolock) on LLP.Cd_Terminal = TERM.Cd_Terminal
	left HASH JOIN	Fatura_CHB					FCHB With(nolock) on HOU.Num_Proc_Him = FCHB.Processo_PC and FCHB.fatura_pc = (select max(fatura_pc) from fatura_chb where processo_pc = hou.num_proc_him)
	Left HASH JOIN	Usuario_Cliente				UC With(nolock) on UC.cd_usuario=PD.PO_Responsible and UC.Cd_Cliente=@Cd_Grupo
--	left HASH JOIN	Container_HOU_IMP_MAR CHIM on CHIM.Num_Proc_HIM = HOU.Num_Proc_Him
--	Left HASH JOIN	Container_MAS_IMP_MAR CMIM on CMIM.Num_Proc_MIM = CHIM.Num_Proc_MIM and CHIM.item_cont_im = CMIM.item_cont_im
	left HASH JOIN	Localidade					PLA With(nolock)	on LLP.cd_planta_lim = PLA.cd_local
	left HASH JOIN	Localidade					DSTF With(nolock) on LLP.cd_dstFinal_lim=DSTF.cd_local
	left HASH JOIN	Produto_chb					PCB With(nolock) on PCB.cd_prod = PS.cd_produto and PCB.concentracao is not null
	Left HASH JOIN   Hist_Geral					CNL with (nolock) on LLP.num_proc_lim=CNL.hsgprocesso and cd_tp_ocor='28'
	INNER  HASH JOIN Pessoa_LLP							PLLP with(nolock) on PLLP.cd_pes=cd_consig_him
where
	 CNL.hsgprocesso is null
	 AND ETD_LIM >=getdate()-365
	 and PLLP.cd_pes_grupo=@cd_Grupo
group by
	PRESENCA.Dt_Conclusao,
	TP.DT_Conclusao,
	Draft.Dt_Conclusao,
	Entrega.Dt_Previsao,
	Entrega.Dt_Conclusao,
	HOU.Num_Proc_Him,
	hou.MAWB_HIM,
	HAWB_HIM,
	ETA_LIM,
	ATA_LIM,
	ETD_LIM,
	ATD_LIM,
	Nome_Armador,
	Navio_HIM,
	Num_Pedido,
--	Num_Po,
--	Customer_PO,
	Org.Nome_Local,
	Dst.Nome_Local,
	TP.Dt_Previsao,
	TP.Dt_Conclusao,
	Isnull(Business_Group_Descr,Produto_Descr),
	ATA_LIM,
	Canal_Lim,
	PO_GRP,
	TERM.Nome_Terminal,
	PC.Cd_Proc_Cliente,
	PC.Produto_Descr,
	UC.Nome_Usuario,
	PS.Qty,
	PD.Dl_Chegada,
	HOU.Dt_Emis_HIM,
	BB.Apelido,
	PDET.UoM,
	PDET.Peso_Liquido_TOT,
	FCHB.Data_PC,
--	CMIM.Dt_Vcto_Devol_IM,
--	CMIM.Dt_Devol_IM,
	PD.Incoterm,
	PD.Planta,
	PD.Dl_Chegada,
	LLP.Vlr_Invoice,
	PLA.nome_local,
	DSTF.nome_local,
	PCB.Concentracao,
	PDET.Peso_Bruto_TOT,
	LLP.Original_ETA_LIM,
	PS.Item

UNION ALL
--Imp Aer
select distinct
	hou.Num_Proc_HIA												Processo,
	hou.MAWB_HIA													MAWB,
	HAWB_HIA														HAWB,
	ETA_LIA															ETA,
	ATA_LIA															ATA,
	ETD_LIA															ETD,
	ATD_LIA															ATD,
	Nome_Cia_Aer													Armador,
	Voo_HIA															Navio,
	Num_Pedido, 
	dbo.fBusca_TipoDocCliente('N', HOU.Num_Proc_Hia, 1)				Num_PO,
	dbo.fBusca_TipoDocCliente('N', HOU.Num_Proc_Hia, 9)				Customer_PO,
	Org.Nome_Local													Origem,
	Dst.Nome_Local													Destino,
	TP.Dt_Previsao,
	TP.Dt_Conclusao,
	Isnull(Business_Group_Descr,Produto_Descr)						Business_Group_Descr,
	null,
	Canal_Lia														Canal,
	dbo.fBusca_HistoricoDescr(hou.num_proc_hia,0,getdate())			Historico_Completo,
--	dbo.fBusca_HistoricoDescr_Completo(hou.num_proc_hia)			Historico_Completo,
	dbo.FBusca_Adto(hou.num_proc_hia)								Adto,
	dbo.FBusca_Caixa(hou.num_proc_hia)								Caixa,
	dbo.fBusca_Docs_PO_Modal(hou.num_proc_hia,5)					DI,
	DI.Data_PO_Hia													Data_DI,
	dbo.fBusca_Tarefa(hou.num_proc_hia,3)							Liberacao_BL,
	dbo.fBusca_Tarefa_Prev(hou.num_proc_hia,13)						Prev_Entrega,
	dbo.fBusca_Tarefa(hou.num_proc_hia,13)							Entrega_Planta,
	LI.Data_PO_HIA													Data_LI,
	LI.Numero_PO_HIA												Num_LI,
	dbo.fBusca_Tarefa(hou.num_proc_hia,20)							Def_LI,
	dbo.fBusca_Tarefa(hou.num_proc_hia,23)							Envio_Docs_Cambio,
	Isnull(dbo.fBusca_Historico_DataFU(hou.num_proc_hia,54),ETA_Lia +7)	Previsao,
	PO_GRP,
	dbo.fBusca_Tarefa(hou.num_proc_hia,7)							Entr_Docs_Transp,
	dbo.fBusca_Tarefa(hou.num_proc_hia,26)							Envio_Docs_Fat,
	dbo.fBusca_Tarefa(hou.num_proc_hia,15)							Presenca_Carga,
	dbo.fBusca_Tarefa(hou.num_proc_hia,27)							Digitacao_DI,
	dbo.fBusca_Tarefa(hou.num_proc_hia,15)							Entrada_Terminal, -- o mesmo q a presença d carga
	dbo.fBusca_Tarefa(hou.num_proc_hia,29)							Desova,
	dbo.fBusca_Tarefa(hou.num_proc_hia,30)							Receb_Insp_Madeira,
	dbo.fBusca_Tarefa(hou.num_proc_hia,39)							Autoriz_Embarque,
	dbo.fBusca_Tarefa(hou.num_proc_hia,17)							Soli_DTA,
	dbo.fBusca_Tarefa(hou.num_proc_hia,18)							Libe_DTA,
	dbo.fBusca_Tarefa(hou.num_proc_hia,19)							Remocao,
	dbo.fBusca_Historico_DataFU(hou.num_proc_hiA,13)				Sol_Insp_Produto,
	TERM.Nome_Terminal,
	isnull(dbo.fBusca_Tarefa(hou.num_proc_hia,14),dbo.fBusca_Tarefa(hou.num_proc_hia,40)) Prest_Contas,
	PC.Cd_Proc_Cliente,
	PC.Produto_Descr,
	RQ.Numero_PO_HIA												Requerimento,
	UC.Nome_Usuario,
	PS.Qty,
	'N/A'															Containers,
	DTA.numero_PO_HIA Num_DTA,
	PD.Dl_Chegada													Prev_Entre_Plan,
	HOU.Dt_Emis_HIA Abertura_JOB,
	BB.Apelido														Buyer,
	PDET.UoM														UOM,
	PDET.Peso_Liquido_TOT											KG,
	LI.Data_PO_HIA													Emissao_LI,
	dbo.fBusca_Tarefa(hou.num_proc_hia,51)							Entrada_Reque,
	dbo.fBusca_Tarefa_Prev(hou.num_proc_hia,52)						Prev_Ini_Prod,
	dbo.fBusca_Tarefa(hou.num_proc_hia,52)							Ini_Prod,
	dbo.fBusca_Tarefa(hou.num_proc_hia,53)							Descarga,
	dbo.fBusca_Tarefa(hou.num_proc_hia,16)							Docs_BDP,
	FCHB.Data_PC													Cobranca,
	INV.Numero_PO_HIA Invoice_Num,
	dbo.fBusca_Tarefa(hou.num_proc_hia,54)							Lib_P_Remocao,
	dbo.fBusca_Tarefa(hou.num_proc_hia,55)							Chegada_EADI,
	dbo.fBusca_Tarefa(hou.num_proc_hia,4)							Desembaraco_DI,
--	'N/A' Dt_Vcto_Devol,
--	'N/A' Dt_Devol,
	PD.Incoterm,
	dbo.fbusca_TEUS(hou.num_proc_hia)								TEUS,
	PD.Planta,
	dbo.fBusca_Tarefa_Prev(hou.num_proc_hia,13)						Chegada_Estimada,
	PD.Dl_Chegada													Chegada_Requerida,
	FAB.Campo_Dados													Fabricante,
	TE.Campo_Dados													Terminal_Entrada,
	DT.Campo_Dados													Devolution_Term,
	CDTA.Campo_Dados												Canal_DTA,
	LLP.Vlr_Invoice													Valor_Invoice,
	PLA.nome_local													Planta_Origem,
	DSTF.nome_local													Local_Destino,
	PCB.concentracao												Concentracao,
	convert(datetime, dbo.fBusca_CampoCliente(hou.num_proc_hia, 28), 105) BL_DATE,
	convert(datetime, dbo.fBusca_CampoCliente(hou.num_proc_hia, 29), 105) vencimento_fatura,
	PDET.Peso_Bruto_TOT,
	dbo.fbusca_docs_po_modal(HOU.num_proc_hia,10)					NF,
	LLP.Original_ETA_LIA + 7										Prev_Entr_Original,
	PS.Item,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Hia,41)								Aprova_Draft
from
	house_imp_AER HOU With(nolock)
	INNER HASH JOIN LLp_imp_AER				LLP With(nolock) on LLP.num_proc_LIA=hou.num_proc_HIA
	left HASH JOIN Job_imp_aer			JOB With(nolock) on JOB.num_proc_hia=HOU.num_proc_hia
	left HASH JOIN Cia_Aerea				ARM With(nolock) on ARM.cd_cia_Aer=job.cd_cia_aer
	left HASH JOIN Pedido_Ship			PS With(nolock) on PS.num_proc=hou.num_proc_HIA
	INNER HASH JOIN Pedido						PD With(nolock) on PD.cd_pedido=PS.cd_pedido and PD.Cd_Grupo=@Cd_Grupo
	left HASH JOIN Pessoa				BB With(nolock) on BB.cd_pes=PD.cd_buyer
	Left HASH JOIN Pedido_Det			PDET With(nolock) on PDET.cd_pedido=PS.cd_pedido and PDET.cd_pedido=PS.cd_pedido and pdet.lote=ps.lote and pdet.item=ps.item
	left HASH JOIN Produto_cliente		PC With(nolock) on PC.cd_prod=ps.cd_produto
	left HASH JOIN DE_Para_Produto		DP With(nolock) on DP.gmid=cd_proc_cliente
	left HASH JOIN Localidade			Org With(nolock) on hou.cd_org_HIA=Org.cd_local
	left HASH JOIN Localidade			Dst With(nolock) on cd_dst_HIA=DSt.cd_local
	Left HASH JOIN Tarefas_Processos		TP With (nolock) on TP.num_proc=hou.num_proc_HIA and TP.ID_Task=4
	Left HASH JOIN PO_HIA				DI With(nolock) on DI.Num_Proc_Hia=hou.num_proc_hia and id_dc=5
	Left HASH JOIN PO_HIA				PO With(nolock) on PO.Num_Proc_Hia=hou.num_proc_hia and PO.id_dc=1
	Left HASH JOIN PO_HIA				Customer_PO With(nolock) on Customer_PO.Num_Proc_Hia=hou.num_proc_hia and Customer_PO.id_dc=9
	Left HASH JOIN PO_HIA				LI With(nolock) on LI.Num_Proc_Hia=hou.num_proc_hia and LI.id_dc=23
	Left HASH JOIN PO_HIA				RQ With(nolock) on RQ.Num_Proc_Hia=hou.num_proc_hia and RQ.id_dc=25
	Left HASH JOIN PO_HIA				DTA With(nolock) on DTA.Num_Proc_Hia = hou.num_proc_hia and DTA.id_dc=45
	Left HASH JOIN PO_HIA				INV With(nolock) on INV.Num_Proc_Hia = hou.num_proc_hia and INV.id_dc=2
	Left HASH JOIN Tarefas_Processos		ENTREGA  With (nolock) on ENTREGA.num_proc=hou.num_proc_HIA and ENTREGA.ID_Task=13
	Left HASH JOIN Terminal				TERM With(nolock) on LLP.Cd_Terminal = TERM.Cd_Terminal
	left HASH JOIN Fatura_CHB			FCHB With(nolock) on HOU.Num_Proc_HIA = FCHB.Processo_PC and FCHB.fatura_pc = (select max(fatura_pc) from fatura_chb where processo_pc = hou.num_proc_hia)
--	HASH JOIN Pessoa_LLP					PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIA and PLL.Cd_Pes_Grupo='362'
	Left HASH JOIN Usuario_Cliente		UC With(nolock) on UC.cd_usuario=PD.PO_Responsible and UC.Cd_Cliente=PD.Cd_Grupo
	left HASH JOIN campo_processo		FAB With(nolock) on FAB.Num_Proc = HOU.Num_proc_HIa and FAB.id_campo = '1'
	left HASH JOIN campo_processo		TE With(nolock) on TE.Num_Proc = HOU.Num_Proc_HIa and TE.ID_campo = '2'
	left HASH JOIN campo_processo		DT With(nolock) on DT.Num_Proc = HOU.Num_Proc_HIa and DT.ID_campo = '3'
	left HASH JOIN campo_processo		CDTA With(nolock) on CDTA.Num_Proc = HOU.Num_Proc_HIa and CDTA.ID_Campo = '4'
	left HASH JOIN Localidade			PLA With(nolock) on LLP.cd_planta_lia = PLA.cd_local
	left HASH JOIN Localidade			DSTF With(nolock) on LLP.cd_dstFinal_lia=DSTF.cd_local
	left HASH JOIN Produto_chb			PCB With(nolock) on PCB.cd_prod = PS.cd_produto and PCB.concentracao is not null
	Left HASH JOIN Hist_Geral			CNL With(nolock) on LLP.num_proc_lia=CNL.hsgprocesso and cd_tp_ocor='28'
where
	 CNL.hsgprocesso is null
			 AND ETD_LIA >=getdate()-365

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
--	Num_Po,
--	Customer_PO,
	Org.Nome_Local,
	Dst.Nome_Local,
	TP.Dt_Previsao,
	TP.Dt_Conclusao,
	Isnull(Business_Group_Descr,Produto_Descr),
	Canal_Lia,
	DI.Numero_PO_Hia,
	DI.Data_PO_Hia,
	PO.Numero_PO_HIA,
	Customer_PO.Numero_PO_HIA,
	/*FCHB.Data_PC,
	*/LI.Data_PO_HIA,
	LI.Numero_PO_HIA,
	PO_GRP,
	TERM.Nome_Terminal,
	/*FCHB.Data_PC,
	*/PC.Cd_Proc_Cliente,
	PC.Produto_Descr,
	RQ.Numero_PO_HIA,
	UC.Nome_Usuario,
	PS.Qty,
	DTA.numero_PO_HIA,
	PD.Dl_Chegada,
	HOU.Dt_Emis_HIA,
	BB.Apelido,
	PDET.UoM,
	PDET.Peso_Liquido_TOT,
	LI.Data_PO_HIA,
	FCHB.Data_PC,
	INV.Numero_PO_HIA,
	PD.Incoterm,
	PD.Planta,
	PD.Dl_Chegada,
	FAB.Campo_Dados,
	TE.Campo_Dados,
	DT.Campo_Dados,
	CDTA.Campo_Dados,
	LLP.Vlr_Invoice,
	PLA.nome_local,
	DSTF.nome_local,
	PCB.Concentracao,
	PDET.Peso_Bruto_TOT,
	LLP.Original_ETA_LIA,
	PS.Item

UNION ALL
--Imp Out
select distinct
	HOU.Num_Proc_Hio													Processo,
	hou.MAWB_HIO														MAWB,
	HAWB_HIO															HAWB,
	ETA_LIO																ETA,
	ATA_LIO																ATA,
	ETD_LIO																ETD,
	ATD_LIO																ATD, 
	ARM.Nome_Raz_Soc													Armador,
	null																Navio, 
	Num_Pedido, 
	dbo.fBusca_TipoDocCliente('N', HOU.Num_Proc_Hio, 1)					Num_PO,
	dbo.fBusca_TipoDocCliente('N', HOU.Num_Proc_Hio, 9)					Customer_PO,
	Org.Nome_Local														Origem,
	Dst.Nome_Local														Destino,
	TP.Dt_Previsao,
	TP.Dt_Conclusao,	
	Isnull(Business_Group_Descr,Produto_Descr)							Business_Group_Descr,
	null Tipo,
	Canal_LiO															Canal,
	dbo.fBusca_HistoricoDescr(HOU.Num_Proc_Hio,0,getdate())				Historico_Completo,
	dbo.FBusca_Adto(HOU.Num_Proc_Hio)									Adto, 
	dbo.FBusca_Caixa(HOU.Num_Proc_Hio)									Caixa, 
	dbo.fBusca_TipoDocCliente('N', HOU.Num_Proc_Hio, 5)					DI, 
	dbo.fBusca_TipoDocCliente('D', HOU.Num_Proc_Hio, 5)					Data_DI,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Hio,3)								Liberacao_BL,
	dbo.fBusca_Tarefa_Prev(HOU.Num_Proc_Hio,13)							Prev_Entrega,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Hio,13)								Entrega_Planta,
	dbo.fBusca_TipoDocCliente('D', HOU.Num_Proc_Hio, 23)				Data_LI,
	dbo.fBusca_TipoDocCliente('N', HOU.Num_Proc_Hio, 23)				Num_LI,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Hio,20)								Def_LI,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Hio,23)								Envio_Docs_Cambio,
	Isnull(dbo.fBusca_Historico_DataFU(HOU.Num_Proc_Hio,54),ETA_Lio +7)	Previsao,
	PO_GRP,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Hio,7)								Entr_Docs_Transp,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Hio,26)								Envio_Docs_Fat,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Hio,15)								Presenca_Carga,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Hio,27)								Digitacao_DI,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Hio,28)								Entrada_Terminal,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Hio,29)								Desova,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Hio,30)								Receb_Insp_Madeira,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Hio,39)								Autoriz_Embarque,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Hio,17)								Soli_DTA,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Hio,18)								Libe_DTA,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Hio,19)								Remocao,
	dbo.fBusca_Historico_DataFU(HOU.Num_Proc_Hio,13)					Sol_Insp_Produto,
	TERM.Nome_Terminal,
	isnull(dbo.fBusca_Tarefa(hou.num_proc_hio,14),dbo.fBusca_Tarefa(hou.num_proc_hio,40)) Prest_Contas,
	PC.Cd_Proc_Cliente,
	dbo.fBusca_PRODUTO(HOU.Num_Proc_Hio)								Produto_Descr,
	dbo.fBusca_TipoDocCliente('N', HOU.Num_Proc_Hio, 25)				Requerimento,
	UC.Nome_Usuario,
	PS.Qty,
	dbo.fBusca_Containers_IM(HOU.Num_Proc_Hio)							Containers,
	dbo.fBusca_TipoDocCliente('N', HOU.Num_Proc_Hio, 45)				Num_DTA,
	PD.Dl_Chegada														Prev_Entre_Plan,
	HOU.Dt_Emis_HIO														Abertura_JOB,
	BB.Apelido															Buyer,
	PDET.UoM															UOM,
	PDET.Peso_Liquido_TOT												KG,
	dbo.fBusca_TipoDocCliente('D', HOU.Num_Proc_Hio, 23)				Emissao_LI,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Hio,51)								Entrada_Reque,
	dbo.fBusca_Tarefa_Prev(HOU.Num_Proc_Hio,52)							Prev_Ini_Prod,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Hio,52)								Ini_Prod,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Hio,53)								Descarga,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Hio,16)								Docs_BDP,
	FCHB.Data_PC														Cobranca,
	dbo.fBusca_TipoDocCliente('N', HOU.Num_Proc_Hio, 2)					Invoice_Num,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Hio,54)								Lib_P_Remocao,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Hio,55)								Chegada_EADI,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Hio,4)								Desembaraco_DI,
	PD.Incoterm,
	dbo.fbusca_TEUS(HOU.Num_Proc_Hio)									TEUS,
	PD.Planta,
	dbo.fBusca_Tarefa_Prev(HOU.Num_Proc_Hio,13)							Chegada_Estimada,
	PD.Dl_Chegada														Chegada_Requerida,
	dbo.fBusca_CampoCliente(HOU.Num_Proc_Hio, 1)						Fabricante,
	dbo.fBusca_CampoCliente(HOU.Num_Proc_Hio, 2)						Terminal_Entrada,
	dbo.fBusca_CampoCliente(HOU.Num_Proc_Hio, 3)						Devolution_Term,
	dbo.fBusca_CampoCliente(HOU.Num_Proc_Hio, 4)						Canal_DTA,
	LLP.Vlr_Invoice														Valor_Invoice,
	PLA.nome_local														Planta_Origem,
	DSTF.nome_local														Local_Destino,
	PCB.concentracao													Concentracao,
	convert(datetime, dbo.fBusca_CampoCliente(HOU.Num_Proc_Hio, 28), 105) BL_DATE,
	convert(datetime, dbo.fBusca_CampoCliente(HOU.Num_Proc_Hio, 29), 105) vencimento_fatura,
	PDET.Peso_Bruto_TOT													Peso_Bruto,
	dbo.fbusca_docs_po_modal(HOU.num_proc_hio,10)						NF,
	LLP.Original_ETA_LIO + 15											Prev_Entr_Original,
	PS.Item,
	dbo.fBusca_Tarefa(HOU.Num_Proc_Hio,41)								Aprova_Draft
from
	house_imp_out HOU With(nolock)
	INNER HASH JOIN		LLp_imp_out					LLP With(nolock) on LLP.num_proc_LIO=HOU.Num_Proc_Hio
	left HASH JOIN	Pessoa						ARM With(nolock) on ARM.cd_pes=llp.cd_carrier
	left HASH JOIN	Pedido_Ship					PS With(nolock) on PS.num_proc=HOU.Num_Proc_Hio
	INNER HASH JOIN		Pedido						PD With(nolock) on PD.cd_pedido=PS.cd_pedido and PD.Cd_Grupo=@Cd_Grupo
	left HASH JOIN	Pessoa						BB With(nolock) on BB.cd_pes=PD.cd_buyer
	Left HASH JOIN	Pedido_Det					PDET With(nolock) on PDET.cd_produto=PS.cd_produto and PDET.cd_pedido=PS.cd_pedido and pdet.lote=ps.lote and pdet.item=ps.item --and PDET.cd_produto=PS.cd_produto and (PDET.ITEM=PS.ITEM OR PS.ITEM IS NULL) AND (PDET.LOTE=PS.LOTE OR PS.LOTE IS NULL)
	left HASH JOIN	Produto_cliente				PC With(nolock) on PC.cd_prod=ps.cd_produto
	left HASH JOIN	DE_Para_Produto				DP With(nolock) on DP.gmid=cd_proc_cliente
	left HASH JOIN	Localidade					Org With(nolock)on hou.cd_org_HIO=Org.cd_local
	left HASH JOIN	Localidade					Dst With(nolock)on cd_dst_HIO=DSt.cd_local
	Left HASH JOIN	Tarefas_Processos			TP With (nolock) on TP.num_proc=HOU.Num_Proc_Hio and TP.ID_Task=4
	Left HASH JOIN	Tarefas_Processos			ENTREGA  With (nolock) on ENTREGA.num_proc=HOU.Num_Proc_Hio and ENTREGA.ID_Task=13
	Left HASH JOIN	Terminal					TERM With(nolock) on LLP.Cd_Terminal = TERM.Cd_Terminal
	left HASH JOIN	Fatura_CHB					FCHB With(nolock) on HOU.Num_Proc_Hio = FCHB.Processo_PC and FCHB.fatura_pc = (select max(fatura_pc) from fatura_chb where processo_pc = hou.num_proc_hio)
	Left HASH JOIN	Usuario_Cliente				UC With(nolock) on UC.cd_usuario=PD.PO_Responsible and UC.Cd_Cliente=@Cd_Grupo
	left HASH JOIN	Localidade					PLA With(nolock)on LLP.cd_planta_lio = PLA.cd_local
	left HASH JOIN	Localidade					DSTF With(nolock) on LLP.cd_dstFinal_lio=DSTF.cd_local
	left HASH JOIN	Produto_chb					PCB With(nolock) on PCB.cd_prod = PS.cd_produto and PCB.concentracao is not null
	Left HASH JOIN   Hist_Geral					CNL With(nolock) on LLP.num_proc_lio=CNL.hsgprocesso and cd_tp_ocor='28'
where
	 CNL.hsgprocesso is null
	And 	 ETD_LIO >=getdate()-365

group by
	HOU.Num_Proc_Hio,
	hou.MAWB_HIO,
	HAWB_HIO,
	ETA_LIO,
	ATA_LIO,
	ETD_LIO,
	ATD_LIO,
	ARM.Nome_Raz_Soc,
	Num_Pedido,
	Org.Nome_Local,
	Dst.Nome_Local,
	TP.Dt_Previsao,
	TP.Dt_Conclusao,
	Isnull(Business_Group_Descr,Produto_Descr),
	ATA_LIO,
	Canal_Lio,
	PO_GRP,
	TERM.Nome_Terminal,
	PC.Cd_Proc_Cliente,
	PC.Produto_Descr,
	UC.Nome_Usuario,
	PS.Qty,
	PD.Dl_Chegada,
	HOU.Dt_Emis_HIO,
	BB.Apelido,
	PDET.UoM,
	PDET.Peso_Liquido_TOT,
	FCHB.Data_PC,
	PD.Incoterm,
	PD.Planta,
	PD.Dl_Chegada,
	LLP.Vlr_Invoice,
	PLA.nome_local,
	DSTF.nome_local,
	PCB.Concentracao,
	PDET.Peso_Bruto_TOT,
	LLP.Original_ETA_LIO,
	PS.Item
--OPTION (HASH HASH JOIN) 



GO
