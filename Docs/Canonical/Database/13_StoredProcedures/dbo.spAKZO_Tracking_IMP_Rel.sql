SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spAKZO_Tracking_IMP_Rel]

As
	select
		'OCEAN'												Modal,
		HOU.Num_Proc_HIM									Ref_BDP,
		PG.Apelido											Nome_Grupo,
		CSN.Apelido											Consignee,
		CSN.Num_CPF_CNPJ									CNPJ,
		HOU.MAWB_HIM										Master,
		HOU.HAWB_HIM										House,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,1)		PO,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,9)		CustomerPO,
		dbo.fBusca_GMID(HOU.Num_Proc_HIM)					Cod_Prod,
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIM)				Produto,
		Org.Nome_Local										Origem,
		Dst.Nome_Local										Destino,
		Nome_Armador										Carrier,
		Navio_HIM											Navio_Voo,
		dbo.fBusca_Containers_IM_Numero(HOU.Num_Proc_HIM)	Containers,
		TERM.Nome_Terminal,
		UC.Nome_Usuario										Nome_PO,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,23)		LI,
		dbo.fBusca_Tarefa(hou.num_proc_him,20)				Def_LI,
		ETD_LIM												ETD,
		ATD_LIM												ATD,
		ETA_LIM												ETA,
		ATA_LIM												ATA,
		dbo.fBusca_Tarefa(hou.num_proc_him,16)				ChegadaDOCs,
		dbo.fBusca_Tarefa(HOU.Num_Proc_HIM,16)				Chegada_Docs,
		dbo.fBusca_Tarefa(hou.num_proc_him,28)				Entrada_Terminal,
		dbo.fBusca_Tarefa(hou.num_proc_him,15)				Presenca_Carga,
		DI.Numero_PO_Him									DI, 
		DI.Data_PO_Him										Data_DI,
		dbo.fBusca_Tarefa(hou.num_proc_him,4)				Dt_Desemb,
		Canal_Lim											Canal,
		dbo.fBusca_Tarefa(hou.num_proc_him,7)				Entr_Docs_Transp,
		dbo.fBusca_Tarefa(hou.num_proc_him,13)				Entrega_Planta,
		dbo.fBusca_HistoricoDescr(hou.num_proc_him,0,getdate()) Historico,
--Para pegar os casos de JOBs que foram Cancelados (transferidos para outro JOB) atender a regra de OPEN para CLOSED
		isnull(max(FCHB.Data_PC),CAN.HSGData)				Prest_Contas,
		dbo.fBusca_Tarefa(hou.num_proc_him,29)				Desova,
		dbo.fBusca_Tarefa(hou.num_proc_him,27)				Digitacao,
		dbo.fBusca_Tarefa(hou.num_proc_him,67)				NFE,
		HOU.Obs_HIM											Notes,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_Him, 5)		N_LI,
		isnull(dbo.fBusca_Tarefa(hou.num_proc_him,59), dbo.FBusca_Adto(hou.num_proc_him)) Sol_Numerario,
		SHP.Apelido											Shipper,
		(case when HOU.Num_Proc_Mim = 'JOB' then null else HOU.Num_Proc_Mim end) Ref_Consolidada,
		TP.NOME_Tp_Oper										Incoterm,
		dbo.FBusca_Docs(hou.num_proc_him,44)				SN_BL_Original,
		dbo.fbusca_docs(hou.num_proc_him,2)					SN_Invoice,
		dbo.fbusca_docs(hou.num_proc_him,11)				SN_Packing,
		dbo.fbusca_docs(hou.num_proc_him,20)				SN_Doc_Embarque,
		dbo.fbusca_docs(hou.num_proc_him,47)				SN_Shipping,
		dbo.fbusca_docs(hou.num_proc_him,5)					SN_DI_Number,
		dbo.fbusca_docs(hou.num_proc_him,41)				SN_AFRMM,
		dbo.fbusca_docs(hou.num_proc_him,6)					SN_CI_Number,
		dbo.fbusca_docs(hou.num_proc_him,60)				SN_Prestacao,
		DTRE.dt_envio										Dt_Re,
		DTDSE.dt_envio										Dt_DSE,
		DTDDE.dt_envio										Dt_DDE,
		dbo.fbusca_docs_po_modal(HOU.num_proc_him,10)		Num_NF,
		DTCOMP.campo_dados									Dt_AFComprov,
		DTAVERB.campo_dados									DT_AFAverb,
		dbo.fbusca_docs(hou.num_proc_him,4)					Tp_doc_RE,
		dbo.fbusca_docs(hou.num_proc_him,26)				Tp_doc_DSE,
		vd.descricao										Urgente
	from
		house_imp_mar HOU
		Join LLP_Imp_Mar				LLP on LLP.num_proc_LIM=hou.num_proc_HIM
		left Join Job_Imp_Mar			JOB on JOB.num_proc_him=hou.num_proc_him
		left Join Armador				ARM on ARM.cd_armador=job.cd_armador
		left Join Pedido_Ship			PS on PS.num_proc=hou.num_proc_HIM
		left Join Pedido				PD on PD.cd_pedido=PS.cd_pedido
		Left Join Pedido_Det			PDET	on PDET.cd_pedido=PS.cd_pedido
		left Join Produto_cliente		PC on PC.cd_prod=ps.cd_produto
		left Join Localidade			Org on hou.cd_org_HIM=Org.cd_local
		left Join Localidade			Dst on cd_dst_HIM=DSt.cd_local
		Left Join Terminal				TERM on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Join PO_HIM				DI on DI.Num_Proc_Him=hou.num_proc_him and DI.id_dc=5
		Join Pessoa_LLP					PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIM and PLL.Cd_Pes_Grupo in (select Cd_Pes_Grupo from grupo where Smart_IMP = 'AKZ')
		Left Join Usuario_Cliente		UC on UC.cd_usuario=PD.PO_Responsible and PLL.Cd_Pes_Grupo in (select Cd_Pes_Grupo from grupo where Smart_IMP = 'AKZ')
		Join Pessoa						CSN on CSN.cd_pes=HOU.Cd_Consig_HIM
		left Join Fatura_CHB			FCHB on HOU.Num_Proc_HIM = FCHB.Processo_PC or HOU.Num_Proc_MIM = FCHB.Processo_PC
		join Grupo						G on G.grupo= right(left(HOU.Num_Proc_HIM,5),3)
		join pessoa						PG on PG.cd_pes=G.cd_pes_grupo
		left join Adiantamento_Cliente	AC on AC.Num_Proc = Hou.Num_proc_Him
		left join Pessoa				SHP on SHP.cd_pes = HOU.cd_export_him
		left Join Tipo_Oper				TP on HOU.cd_tp_oper = TP.Cd_tp_oper
		left join Hist_Geral			CAN on CAN.HSGProcesso=HOU.Num_Proc_HIM and CAN.cd_tp_ocor='28'
		left join doc_anexos			DTRE on DTRE.num_proc = LLP.num_proc_lim and DTRE.id_dc = '4'
		left join doc_anexos			DTDSE on DTDSE.num_proc = LLP.num_proc_lim and DTDSE.id_dc = '26'
		left join doc_anexos			DTDDE on DTDDE.num_proc = LLP.num_proc_lim and DTDDE.id_dc = '12'
		left join campo_processo		DTCOMP on DTCOMP.NUm_proc = LLP.Num_proc_lim and DTCOMP.id_campo = '41'
		left join campo_processo		DTAVERB on DTAVERB.NUm_proc = LLP.Num_proc_lim and DTAVERB.id_campo = '42'
		left join campo_processo      	CP on LLP.num_proc_lim=cp.num_proc and cp.id_campo=36
		left join verdade				VD on cp.campo_dados = VD.id
	where
		(right(left(HOU.Num_Proc_HIM,9),4)='2009' or right(left(HOU.Num_Proc_HIM,9),4)='2010')
--		and HOU.Num_Proc_HIM='IMCAR20090501401'
	group by
		HOU.Num_Proc_HIM,
		HOU.HAWB_HIM,HOU.MAWB_HIM,
		CSN.Apelido,
		CSN.Num_CPF_CNPJ,
		Org.Nome_Local,
		Dst.Nome_Local,
		Nome_Armador,
		Navio_HIM,
		TERM.Nome_Terminal,
		UC.Nome_Usuario,
		ETD_LIM,
		ATD_LIM,
		ETA_LIM,
		ATA_LIM,
		DI.Numero_PO_Him, 
		DI.Data_PO_Him,
		Canal_Lim,
		PG.Apelido,
		HOU.Obs_HIM,
		SHP.Apelido,
		HOU.Num_Proc_Mim,
		TP.NOME_Tp_Oper,
		CAN.HSGData,
		DTRE.dt_envio,
		DTDSE.dt_envio,
		DTDDE.dt_envio,
		DTCOMP.campo_dados,
		DTAVERB.campo_dados,
		DTRE.dt_envio,
		DTDSE.dt_envio,
		DTDDE.dt_envio,
		DTCOMP.campo_dados,
		DTAVERB.campo_dados,
		vd.descricao

UNION
	select
		'AIR'													Modal,
		HOU.Num_Proc_HIA										Ref_BDP,
		PG.Apelido												Nome_Grupo,
		CSN.Apelido												Consignee,
		CSN.Num_CPF_CNPJ										CNPJ,
		HOU.MAWB_HIA											Master,
		HOU.HAWB_HIA											House,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIA,1)			PO,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIA,9)			CustomerPO,
		dbo.fBusca_GMID(HOU.Num_Proc_HIA)						Cod_Prod,
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIA)					Produto,
		Org.Nome_Local											Origem,
		Dst.Nome_Local											Destino,
		Nome_Cia_Aer											Carrier,
		Voo_HIA													Navio_Voo,
		isnull(dbo.fBusca_Containers_IM(HOU.Num_Proc_HIA),
		dbo.fBusca_Volumes(HOU.Num_Proc_HIA))					Containers,
		TERM.Nome_Terminal,
		UC.Nome_Usuario,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIA,23)			LI,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,20)					Def_LI,
		ETD_LIA													ETD,
		ATD_LIA													ATD,
		ETA_LIA													ETA,
		ATA_LIA													ATA,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,16)					ChegadaDOCs,
		dbo.fBusca_Tarefa(HOU.Num_Proc_HIa,16)					Chegada_Docs,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,28)					Entrada_Terminal,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,15)					Presenca_Carga,
		DI.Numero_PO_HIA										DI, 
		DI.Data_PO_HIA											Data_DI,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,4)					Dt_Desemb,
		Canal_LIA												Canal,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,7)					Entr_Docs_Transp,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,13)					Entrega_Planta,
		dbo.fBusca_HistoricoDescr(hou.num_proc_HIA,0,getdate()) Historico,
--Para pegar os casos de JOBs que foram Cancelados (transferidos para outro JOB) atender a regra de OPEN para CLOSED
		isnull(max(FCHB.Data_PC),CAN.HSGData)					Prest_Contas,
		dbo.fBusca_Tarefa(hou.num_proc_hia,29)					Desova,
		dbo.fBusca_Tarefa(hou.num_proc_hia,27)					Digitacao,
		dbo.fBusca_Tarefa(hou.num_proc_hia,67)					NFE,
		HOU.Obs_HIA												Notes,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_Hia, 5)			N_LI,
		isnull(dbo.fBusca_Tarefa(hou.num_proc_hia,59),
		dbo.FBusca_Adto(hou.num_proc_hia))						Sol_Numerario,
		SHP.Apelido												Shipper,
		(case when HOU.Num_Proc_Mia = 'JOB' then null else HOU.Num_Proc_Mia end) Ref_Consolidada,
		TP.NOME_Tp_Oper											Incoterm,
		dbo.FBusca_Docs(hou.num_proc_hia,44)					SN_BL_Original,
		dbo.fbusca_docs(hou.num_proc_hia,2)						SN_Invoice,
		dbo.fbusca_docs(hou.num_proc_hia,11)					SN_Packing,
		dbo.fbusca_docs(hou.num_proc_hia,20)					SN_Doc_Embarque,
		dbo.fbusca_docs(hou.num_proc_hia,47)					SN_Shipping,
		dbo.fbusca_docs(hou.num_proc_hia,5)						SN_DI_Number,
		dbo.fbusca_docs(hou.num_proc_hia,41)					SN_AFRMM,
		dbo.fbusca_docs(hou.num_proc_hia,6)						SN_CI_Number,
		dbo.fbusca_docs(hou.num_proc_hia,60)					SN_Prestacao,
		DTRE.dt_envio											Dt_Re,
		DTDSE.dt_envio											Dt_DSE,
		DTDDE.dt_envio											Dt_DDE,
		dbo.fbusca_docs_po_modal(HOU.num_proc_hia,10)			Num_NF,
		DTCOMP.campo_dados										Dt_AFComprov,
		DTAVERB.campo_dados										DT_AFAverb,
		dbo.fbusca_docs(hou.num_proc_hia,4)						Tp_doc_RE,
		dbo.fbusca_docs(hou.num_proc_hia,26)					Tp_doc_DSE,
		vd.descricao											Urgente
	from
		house_imp_Aer HOU
		Join LLP_Imp_Aer				LLP on LLP.num_proc_LIA=hou.num_proc_HIA
		left Join Job_Imp_Aer			JOB on JOB.num_proc_HIA=hou.num_proc_HIA
		left Join Cia_Aerea				CIA on CIA.Cd_Cia_Aer=JOB.Cd_Cia_Aer
		left Join Pedido_Ship			PS on PS.num_proc=hou.num_proc_HIA
		left Join Pedido				PD on PD.cd_pedido=PS.cd_pedido
		Left Join Pedido_Det			PDET on PDET.cd_pedido=PS.cd_pedido
		left Join Produto_cliente		PC on PC.cd_prod=ps.cd_produto
		left Join Localidade			Org on hou.cd_org_HIA=Org.cd_local
		left Join Localidade			Dst on cd_dst_HIA=DSt.cd_local
		Left Join Terminal				TERM on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Join PO_HIA				DI on DI.Num_Proc_HIA=hou.num_proc_HIA and DI.id_dc=5
		Join Pessoa_LLP					PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIA and PLL.Cd_Pes_Grupo in (select Cd_Pes_Grupo from grupo where Smart_IMP = 'AKZ')
		Left Join Usuario_Cliente		UC on UC.cd_usuario=PD.PO_Responsible and PLL.Cd_Pes_Grupo in (select Cd_Pes_Grupo from grupo where Smart_IMP = 'AKZ')
		Join Pessoa						CSN on CSN.cd_pes=HOU.Cd_Consig_HIA
		left Join Fatura_CHB			FCHB on HOU.Num_Proc_HIA = FCHB.Processo_PC or HOU.Num_Proc_MIA = FCHB.Processo_PC
		join Grupo						G on G.grupo= right(left(HOU.Num_Proc_HIa,5),3)
		join pessoa						PG on PG.cd_pes=G.cd_pes_grupo
		left join Adiantamento_Cliente	AC on AC.Num_Proc = Hou.Num_proc_Hia
		left join Pessoa				SHP on SHP.cd_pes = HOU.cd_export_hia
		left Join Tipo_Oper				TP on HOU.cd_tp_oper = TP.Cd_tp_oper
		left join Hist_Geral			CAN on CAN.HSGProcesso=HOU.Num_Proc_HIA and CAN.cd_tp_ocor='28'
		left join doc_anexos			DTRE on DTRE.num_proc = LLP.num_proc_lia and DTRE.id_dc = '4'
		left join doc_anexos			DTDSE on DTDSE.num_proc = LLP.num_proc_lia and DTDSE.id_dc = '26'
		left join doc_anexos			DTDDE on DTDDE.num_proc = LLP.num_proc_lia and DTDDE.id_dc = '12'
		left join campo_processo		DTCOMP on DTCOMP.NUm_proc = LLP.Num_proc_lia and DTCOMP.id_campo = '41'
		left join campo_processo		DTAVERB on DTAVERB.NUm_proc = LLP.Num_proc_lia and DTAVERB.id_campo = '42'
		left join campo_processo      	CP on LLP.num_proc_lia=cp.num_proc and cp.id_campo=36
		left join verdade				VD on cp.campo_dados = VD.id
	where
		(right(left(HOU.Num_Proc_HIA,9),4)='2009' or right(left(HOU.Num_Proc_HIA,9),4)='2010')
	group by
		HOU.Num_Proc_HIA,
		HOU.HAWB_HIA,HOU.MAWB_HIA,
		CSN.Apelido,
		CSN.Num_CPF_CNPJ,
		Org.Nome_Local,
		Dst.Nome_Local,
		Nome_Cia_Aer,
		Voo_HIA,
		TERM.Nome_Terminal,
		UC.Nome_Usuario,
		ETD_LIA,
		ATD_LIA,
		ETA_LIA,
		ATA_LIA,
		DI.Numero_PO_HIA, 
		DI.Data_PO_HIA,
		Canal_LIA,
		PG.Apelido,
		HOU.Obs_HIA,
		SHP.Apelido,
		HOU.Num_Proc_Mia,
		TP.NOME_Tp_Oper,
		CAN.HSGData,
		DTRE.dt_envio,
		DTDSE.dt_envio,
		DTDDE.dt_envio,
		DTCOMP.campo_dados,
		DTAVERB.campo_dados,
		DTRE.dt_envio,
		DTDSE.dt_envio,
		DTDDE.dt_envio,
		DTCOMP.campo_dados,
		DTAVERB.campo_dados,
		vd.descricao

UNION
	select
		'OTHERS'										Modal,
		HOU.Num_Proc_HIO								Ref_BDP,
		PG.Apelido										Nome_Grupo,
		CSN.Apelido										Consignee,
		CSN.Num_CPF_CNPJ								CNPJ,
		HOU.MAWB_HIO									Master,
		HOU.HAWB_HIO									House,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIO,1)	PO,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIO,9)	CustomerPO,
		dbo.fBusca_GMID(HOU.Num_Proc_HIO)				Cod_Prod,
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIO)			Produto,
		Org.Nome_Local									Origem,
		Dst.Nome_Local									Destino,
		CIA.Apelido										Carrier,
		Voo_HIo											Navio_Voo,
		dbo.fBusca_Containers_IM_Numero(HOU.Num_Proc_HIO) Containers,
		TERM.Nome_Terminal,
		UC.Nome_Usuario											Nome_PO,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIO,23)			LI,
		dbo.fBusca_Tarefa(hou.Num_Proc_HIO,20)					Def_LI,
		ETD_LIO													ETD,
		ATD_LIO													ATD,
		ETA_LIO													ETA,
		ATA_LIO													ATA,
		dbo.fBusca_Tarefa(hou.Num_Proc_HIO,16)					ChegadaDOCs,
		dbo.fBusca_Tarefa(HOU.Num_Proc_HIo,16)					Chegada_Docs,
		dbo.fBusca_Tarefa(hou.Num_Proc_HIO,28)					Entrada_Terminal,
		dbo.fBusca_Tarefa(hou.Num_Proc_HIO,15)					Presenca_Carga,
		DI.Numero_PO_HIO										DI, 
		DI.Data_PO_HIO											Data_DI,
		dbo.fBusca_Tarefa(hou.Num_Proc_HIO,4)					Dt_Desemb,
		Canal_LIO												Canal,
		dbo.fBusca_Tarefa(hou.Num_Proc_HIO,7)					Entr_Docs_Transp,
		dbo.fBusca_Tarefa(hou.Num_Proc_HIO,13)					Entrega_Planta,
		dbo.fBusca_HistoricoDescr(hou.Num_Proc_HIO,0,getdate()) Historico,
--Para pegar os casos de JOBs que foram Cancelados (transferidos para outro JOB) atender a regra de OPEN para CLOSED
		isnull(max(FCHB.Data_PC),CAN.HSGData)					Prest_Contas,
		dbo.fBusca_Tarefa(hou.Num_Proc_HIO,29)					Desova,
		dbo.fBusca_Tarefa(hou.Num_Proc_HIO,27)					Digitacao,
		dbo.fBusca_Tarefa(hou.Num_Proc_HIO,67)					NFE,
		HOU.Obs_HIO												Notes,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_HIO, 5)			N_LI,
		isnull(dbo.fBusca_Tarefa(hou.num_proc_hio,59), dbo.FBusca_Adto(hou.num_proc_hio)) Sol_Numerario,
		SHP.Apelido												Shipper,
		''	Ref_Consolidada,
		TP.NOME_Tp_Oper											Incoterm,
		dbo.FBusca_Docs(hou.num_proc_hio,44)					SN_BL_Original,
		dbo.fbusca_docs(hou.num_proc_hio,2)						SN_Invoice,
		dbo.fbusca_docs(hou.num_proc_hio,11)					SN_Packing,
		dbo.fbusca_docs(hou.num_proc_hio,20)					SN_Doc_Embarque,
		dbo.fbusca_docs(hou.num_proc_hio,47)					SN_Shipping,
		dbo.fbusca_docs(hou.num_proc_hio,5)						SN_DI_Number,
		dbo.fbusca_docs(hou.num_proc_hio,41)					SN_AFRMM,
		dbo.fbusca_docs(hou.num_proc_hio,6)						SN_CI_Number,
		dbo.fbusca_docs(hou.num_proc_hio,60)					SN_Prestacao,
		DTRE.dt_envio											Dt_Re,
		DTDSE.dt_envio											Dt_DSE,
		DTDDE.dt_envio											Dt_DDE,
		dbo.fbusca_docs_po_modal(HOU.num_proc_hio,10)			Num_NF,
		DTCOMP.campo_dados										Dt_AFComprov,
		DTAVERB.campo_dados										DT_AFAverb,
		dbo.fbusca_docs(hou.num_proc_hio,4)						Tp_doc_RE,
		dbo.fbusca_docs(hou.num_proc_hio,26)					Tp_doc_DSE,
		vd.descricao											Urgente
	from
		house_imp_out HOU
		Join LLP_Imp_out								LLP on LLP.num_proc_LIO=hou.Num_Proc_HIO
--		left Join Job_Imp_Out							JOB on JOB.Num_Proc_HIO=hou.Num_Proc_HIO
--		left Join Armador								ARM on ARM.cd_armador=job.cd_armador
		left Join Pedido_Ship							PS on PS.num_proc=hou.Num_Proc_HIO
		left Join Pedido								PD on PD.cd_pedido=PS.cd_pedido
		Left Join Pedido_Det							PDET on PDET.cd_pedido=PS.cd_pedido
		left Join Produto_cliente						PC on PC.cd_prod=ps.cd_produto
		left Join Localidade							Org on hou.cd_org_HIO=Org.cd_local
		left Join Localidade							Dst on cd_dst_HIO=DSt.cd_local
		Left Join Terminal								TERM on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Join PO_HIO								DI on DI.Num_Proc_HIO=hou.Num_Proc_HIO and DI.id_dc=5
		Join Pessoa_LLP									PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIO and PLL.Cd_Pes_Grupo in (select Cd_Pes_Grupo from grupo where Smart_IMP = 'AKZ')
		Left Join Usuario_Cliente						UC on UC.cd_usuario=PD.PO_Responsible and PLL.Cd_Pes_Grupo in (select Cd_Pes_Grupo from grupo where Smart_IMP = 'AKZ')
		Join Pessoa										CSN on CSN.cd_pes=HOU.Cd_Consig_HIO
		left Join pessoa								CIA on CIA.cd_pes=llp.cd_carrier
		left Join Fatura_CHB							FCHB on HOU.Num_Proc_HIO = FCHB.Processo_PC
		join Grupo										G on G.grupo= right(left(HOU.Num_Proc_HIO,5),3)
		join pessoa										PG on PG.cd_pes=G.cd_pes_grupo
		left join Adiantamento_Cliente					AC on AC.Num_Proc = Hou.Num_Proc_HIO
		left join Pessoa								SHP on SHP.cd_pes = HOU.cd_export_HIO
		left Join Tipo_Oper								TP on HOU.cd_tp_oper = TP.Cd_tp_oper
		left join Hist_Geral							CAN on CAN.HSGProcesso=HOU.Num_Proc_HIO and CAN.cd_tp_ocor='28'
		left join doc_anexos							DTRE on DTRE.num_proc = LLP.num_proc_lio and DTRE.id_dc = '4'
		left join doc_anexos							DTDSE on DTDSE.num_proc = LLP.num_proc_lio and DTDSE.id_dc = '26'
		left join doc_anexos							DTDDE on DTDDE.num_proc = LLP.num_proc_lio and DTDDE.id_dc = '12'
		left join campo_processo						DTCOMP on DTCOMP.NUm_proc = LLP.Num_proc_lio and DTCOMP.id_campo = '41'
		left join campo_processo						DTAVERB on DTAVERB.NUm_proc = LLP.Num_proc_lio and DTAVERB.id_campo = '42'
		left join campo_processo      					CP on LLP.num_proc_lio=cp.num_proc and cp.id_campo=36
		left join verdade								VD on cp.campo_dados = VD.id
	where
		(right(left(HOU.Num_Proc_HIO,9),4)='2009' or right(left(HOU.Num_Proc_HIO,9),4)='2010')
	group by
		HOU.Num_Proc_HIO,
		HOU.HAWB_HIO,HOU.MAWB_HIO,
		CSN.Apelido,
		CSN.Num_CPF_CNPJ,
		Org.Nome_Local,
		Dst.Nome_Local,
		CIA.Apelido,
		Voo_HIo,
		TERM.Nome_Terminal,
		UC.Nome_Usuario,
		ETD_LIO,
		ATD_LIO,
		ETA_LIO,
		ATA_LIO,
		DI.Numero_PO_HIO, 
		DI.Data_PO_HIO,
		Canal_LIO,
		PG.Apelido,
		HOU.Obs_HIO,
		SHP.Apelido,
		TP.NOME_Tp_Oper,
		CAN.HSGData,
		DTRE.dt_envio,
		DTDSE.dt_envio,
		DTDDE.dt_envio,
		DTCOMP.campo_dados,
		DTAVERB.campo_dados,
		DTRE.dt_envio,
		DTDSE.dt_envio,
		DTDDE.dt_envio,
		DTCOMP.campo_dados,
		DTAVERB.campo_dados,
		vd.descricao








GO
