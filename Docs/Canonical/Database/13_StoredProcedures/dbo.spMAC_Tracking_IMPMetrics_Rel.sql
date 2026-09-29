SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













CREATE Procedure [dbo].[spMAC_Tracking_IMPMetrics_Rel] 

As
	select
		UC.nome_usuario									Nome_PO,
		'OCEAN'											Modal,
		HOU.Num_Proc_HIM								Ref_BDP,
		CSN.Apelido										Consignee,
		CSN.Num_CPF_CNPJ								CNPJ,
		HOU.MAWB_HIM									Master,
		HOU.HAWB_HIM									House,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,1)	PO,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,9)	CustomerPO,
		dbo.fBusca_GMID(HOU.Num_Proc_HIM)				Cod_Prod,
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIM)			Produto,
		Org.Nome_Local									Origem,
		Dst.Nome_Local									Destino,
		Nome_Armador									Carrier,
		Navio_HIM										Navio_Voo,
		isnull(dbo.fBusca_Containers_IM(HOU.Num_Proc_HIM),
		dbo.fBusca_Volumes(HOU.Num_Proc_HIM))			Containers,
		TERM.Nome_Terminal,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,23)	LI,
		dbo.fBusca_Tarefa(hou.num_proc_him,20)			Def_LI,
		ETD_LIM											ETD,
		ATD_LIM											ATD,
		ETA_LIM											ETA,
		ATA_LIM											ATA,
		dbo.fBusca_Tarefa(hou.Num_Proc_HIM,16)			ChegadaDOCs,
		dbo.fBusca_Tarefa(HOU.Num_Proc_HIM,16)          Chegada_Docs,
		dbo.fBusca_Tarefa(hou.num_proc_him,28)			Entrada_Terminal,
		dbo.fBusca_Tarefa(hou.num_proc_him,15)			Presenca_Carga,
		DI.Numero_PO_Him								DI, 
		DI.Data_PO_Him									Data_DI,
		dbo.fBusca_Tarefa(hou.num_proc_him,4)			Dt_Desemb,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,3)	DSM_Ref,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,2)	Num_Invoice,
		Canal_Lim										Canal,
		dbo.fBusca_Tarefa(hou.num_proc_him,7)			Entr_Docs_Transp,
		dbo.fBusca_Tarefa(hou.num_proc_him,13)			Entrega_Planta,
		dbo.fBusca_HistoricoDescr(hou.num_proc_him,0,getdate()) Historico,
		max(FCHB.Data_PC)								Prest_Contas,
		dbo.fBusca_Tarefa(hou.num_proc_him,29)			Desova,
		dbo.fBusca_Tarefa(hou.num_proc_him,27)			Digitacao,
		dbo.fBusca_Containers(hou.num_proc_him)			Containers,
--		dbo.Qty_Container(hou.num_proc_him)				Qtde,
		dbo.fBusca_TEUS(hou.num_proc_him)				TEUS,
		dbo.fBusca_Tarefa(hou.num_proc_him,67)			NFE,
		HOU.Obs_HIM										Notes,
		PG.Apelido										Nome_Grupo,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_Him, 5)	N_LI,
		isnull(dbo.fBusca_Tarefa(hou.num_proc_him,59),
		dbo.FBusca_Adto(hou.num_proc_him))				Sol_Numerario,
		SHP.Apelido										Shipper,
		PDET.UoM										Unid,		
		(case when HOU.Num_Proc_Mim = 'JOB' then null else HOU.Num_Proc_Mim end)	Ref_Consolidada,
		TP.NOME_Tp_Oper									Incoterm,
		vd.descricao									Urgente,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_him,13)		Prev_Entrega,
		dbo.fbusca_campocliente(hou.num_proc_him,43)	EnvDrafCom,
		dbo.fBusca_Tarefa(hou.num_proc_him,60)			Abertura_Pasta,
		dbo.fBusca_Tarefa(hou.num_proc_him,46)			Solict_LI,
		dbo.fBusca_Tarefa(hou.num_proc_him,41)			Aprova_draft,
		dbo.fBusca_Tarefa(hou.num_proc_him,21)			Lib_BL,
		dbo.fBusca_Tarefa(hou.num_proc_him,26)			EnvDocsFat,
		dbo.fBusca_Tarefa(hou.num_proc_him,42)			RedestCont,
		dbo.fBusca_Tarefa(hou.num_proc_him,70)			NF_Comp,
		Isnull(localidade,'STS')						Localidade
	
	from
		llp_imp_mar LLP
		Join House_Imp_Mar					HOU on LLP.num_proc_LIM=hou.num_proc_HIM
		left Join Job_Imp_Mar				JOB on JOB.num_proc_him=hou.num_proc_him
		left Join Armador					ARM on ARM.cd_armador=job.cd_armador
		left Join Pedido_Ship				PS on PS.num_proc=hou.num_proc_HIM
		Left Join Pedido_Det				PDET on PDET.cd_produto=PS.cd_produto and PDET.cd_pedido=PS.cd_pedido and pdet.lote=ps.lote and pdet.item=ps.item
		left Join Pedido					PD on PD.cd_pedido=PS.cd_pedido
		left Join Produto_cliente			PC on PC.cd_prod=ps.cd_produto
		left Join Localidade				Org on hou.cd_org_HIM=Org.cd_local
		left Join Localidade				Dst on cd_dst_HIM=DSt.cd_local
		Left Join Terminal					TERM on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Join PO_HIM					DI on DI.Num_Proc_Him=hou.num_proc_him and DI.id_dc=5
		Join Pessoa_LLP						PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIM --and PLL.Cd_Pes_Grupo=@Cd_Grupo
		Left Join Usuario_Cliente			UC on UC.cd_usuario=PD.PO_Responsible --and PD.Cd_Grupo=@Cd_Grupo
		Join Pessoa							CSN on CSN.cd_pes=HOU.Cd_Consig_HIM
		left Join Fatura_CHB				FCHB on HOU.Num_Proc_HIM = FCHB.Processo_PC or HOU.Num_Proc_MIM = FCHB.Processo_PC
		join Grupo							G on G.grupo= right(left(HOU.Num_Proc_HIM,5),3)
		LEFT jOIN CHB_Cliente_Localidade			chb ON chB.CD_PES_GRUPO=g.CD_PES_GRUPO
		join pessoa							PG on PG.cd_pes=G.cd_pes_grupo
--		left join Adiantamento_Cliente		AC on AC.Num_Proc = Hou.Num_proc_Him and AC.POC = (select min(poc) from adiantamento_cliente where num_proc = Hou.Num_proc_Him)
		left join Pessoa					SHP on SHP.cd_pes = HOU.cd_export_him
		Left Join PO_HIM					PO on PO.Num_Proc_Him=HOU.num_proc_him and PO.ID_DC='3'
		Left Join PO_HIM					CU on CU.Num_Proc_Him=HOU.num_proc_him and CU.ID_DC='9'
		left join Hist_Geral				HG on HG.HSGProcesso=HOU.Num_Proc_Him and HG.cd_tp_ocor = '28'
		left Join Tipo_Oper					TP on HOU.cd_tp_oper = TP.Cd_tp_oper
		left join campo_processo      		CP on LLP.num_proc_lim=cp.num_proc and cp.id_campo=36
		left join verdade					VD on cp.campo_dados = VD.id
		Join Tarefas_Processos				ST on ST.num_proc=num_proc_lim and St.id_Task=13  and (st.dt_conclusao is null or st.dt_conclusao >='01-01-2010')
	where
		
		(PO.Numero_PO_HIM not in ('CANCELLED JOB','PACKAGE RETURN','SAMPLE','FREIGHT FORWARDER') or PO.Numero_PO_HIM is null)
		and (CU.Numero_PO_HIM not in ('CANCELLED JOB','PACKAGE RETURN','SAMPLE','FREIGHT FORWARDER') or CU.Numero_PO_HIM is null)
		and HG.cd_tp_ocor is null 
		and (substring(hou.num_proc_him,3,3)='LYB' and CSN.Apelido ='LYONDELL' or substring(hou.num_proc_him,3,3)<>'LYB')
		and cd_dst_him not in('ITJ','NVT','SFS','ARB')
		


	group by
		UC.nome_usuario,
		HOU.Num_Proc_HIM,
		HOU.HAWB_HIM,HOU.MAWB_HIM,
		CSN.Apelido,
		CSN.Num_CPF_CNPJ,
		Org.Nome_Local,
		Dst.Nome_Local,
		Nome_Armador,
		Navio_HIM,
		TERM.Nome_Terminal,
		ETD_LIM,
		ATD_LIM,
		ETA_LIM,
		ATA_LIM,
		DI.Numero_PO_Him, 
		DI.Data_PO_Him,
		Canal_Lim,
		HOU.Obs_HIM,
		PG.Apelido,
--		AC.Dt_Solicitacao,
		SHP.Apelido,
		HOU.Num_Proc_Mim,
		PDET.UoM,
		TP.NOME_Tp_Oper,
		vd.descricao,
		Localidade
UNION
	select
		UC.nome_usuario									Nome_PO,
		'AIR'											Modal,
		HOU.Num_Proc_HIA								Ref_BDP,
		CSN.Apelido										Consignee,
		CSN.Num_CPF_CNPJ								CNPJ,
		HOU.MAWB_HIA									Master,
		HOU.HAWB_HIA									House,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIA,1)	PO,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIA,9)	CustomerPO,
		dbo.fBusca_GMID(HOU.Num_Proc_HIA)				Cod_Prod,
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIA)			Produto,
		Org.Nome_Local									Origem,
		Dst.Nome_Local									Destino,
		Nome_Cia_Aer									Carrier,
		Voo_HIA											Navio_Voo,
		isnull(dbo.fBusca_Containers_IM(HOU.Num_Proc_HIA),
		dbo.fBusca_Volumes(HOU.Num_Proc_HIA))			Containers,
		TERM.Nome_Terminal,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIA,23)	LI,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,20)			Def_LI,
		ETD_LIA											ETD,
		ATD_LIA											ATD,
		ETA_LIA											ETA,
		ATA_LIA											ATA,
		dbo.fBusca_Tarefa(hou.Num_Proc_HIA,16)			ChegadaDOCs,
		dbo.fBusca_Tarefa(HOU.Num_Proc_HIA,16)          Chegada_Docs,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,28)			Entrada_Terminal,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,15)			Presenca_Carga,
		DI.Numero_PO_HIA								DI, 
		DI.Data_PO_HIA									Data_DI,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,4)			Dt_Desemb,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIA,3)	DSM_Ref,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIA,2)	Num_Invoice,
		Canal_LIA										Canal,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,7)			Entr_Docs_Transp,
		dbo.fBusca_Tarefa(hou.num_proc_HIA,13)			Entrega_Planta,
		dbo.fBusca_HistoricoDescr(hou.num_proc_HIA,0,getdate()) Historico,
		max(FCHB.Data_PC)								Prest_Contas,
		dbo.fBusca_Tarefa(hou.num_proc_hia,29)			Desova,
		dbo.fBusca_Tarefa(hou.num_proc_hia,27)			Digitacao,
		dbo.fBusca_Containers(hou.num_proc_hia)			Containers,
--		dbo.Qty_Container(hou.num_proc_hia)				Qtde,
		dbo.fBusca_TEUS(hou.num_proc_hia)				TEUS,
		dbo.fBusca_Tarefa(hou.num_proc_hia,67)			NFE,
		HOU.Obs_HIA Notes,
		PG.Apelido										Nome_Grupo,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_Hia, 5)	N_LI,
		isnull(dbo.fBusca_Tarefa(hou.num_proc_hia,59),
		dbo.FBusca_Adto(hou.num_proc_hia))				Sol_Numerario,
		SHP.Apelido										Shipper,
		PDET.UoM										Unid,
		(case when HOU.Num_Proc_Mia = 'JOB' then null else HOU.Num_Proc_Mia end)	Ref_Consolidada,
		TP.NOME_Tp_Oper									Incoterm,
		vd.descricao									Urgente,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_hia,13)		Prev_Entrega,
		dbo.fbusca_campocliente(hou.num_proc_hia,43)	EnvDrafCom,
		dbo.fBusca_Tarefa(hou.num_proc_hia,60)		Abertura_Pasta,
		dbo.fBusca_Tarefa(hou.num_proc_hia,46)		Solict_LI,
		dbo.fBusca_Tarefa(hou.num_proc_hia,41)		Aprova_draft,
		dbo.fBusca_Tarefa(hou.num_proc_hia,21)			Lib_BL,
		dbo.fBusca_Tarefa(hou.num_proc_hia,26)			EnvDocsFat,
		dbo.fBusca_Tarefa(hou.num_proc_hia,42)			RedestCont,
		dbo.fBusca_Tarefa(hou.num_proc_hia,70)			NF_Comp,
		Isnull(localidade,'STS')						Localidade
		

	from
		llp_imp_Aer LLP
		Join House_Imp_Aer						HOU on LLP.num_proc_LIA=hou.num_proc_HIA
		left Join Job_Imp_Aer					JOB on JOB.num_proc_HIA=hou.num_proc_HIA
		left Join Cia_Aerea						CIA on CIA.Cd_Cia_Aer=JOB.Cd_Cia_Aer
		left Join Pedido_Ship					PS on PS.num_proc=hou.num_proc_HIA
		Left Join Pedido_Det					PDET on PDET.cd_produto=PS.cd_produto and PDET.cd_pedido=PS.cd_pedido and pdet.lote=ps.lote and pdet.item=ps.item
		left Join Pedido						PD on PD.cd_pedido=PS.cd_pedido
		left Join Produto_cliente				PC on PC.cd_prod=ps.cd_produto
		left Join Localidade					Org on hou.cd_org_HIA=Org.cd_local
		left Join Localidade					Dst on cd_dst_HIA=DSt.cd_local
		Left Join Terminal						TERM on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Join PO_HIA						DI on DI.Num_Proc_HIA=hou.num_proc_HIA and DI.id_dc=5
		Join Pessoa_LLP							PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIA-- and PLL.Cd_Pes_Grupo=@Cd_Grupo
		Left Join Usuario_Cliente				UC on UC.cd_usuario=PD.PO_Responsible-- and PD.Cd_Grupo=@Cd_Grupo
		Join Pessoa								CSN on CSN.cd_pes=HOU.Cd_Consig_HIA
		left Join Fatura_CHB					FCHB on HOU.Num_Proc_HIA = FCHB.Processo_PC or HOU.Num_Proc_MIA = FCHB.Processo_PC
		join Grupo								G on G.grupo= right(left(HOU.Num_Proc_HIA,5),3)
		Left jOIN CHB_Cliente_Localidade			chb ON chB.CD_PES_GRUPO=g.CD_PES_GRUPO
		join pessoa								PG on PG.cd_pes=G.cd_pes_grupo
--		left join Adiantamento_Cliente			AC on AC.Num_Proc = Hou.Num_proc_Hia and AC.POC = (select min(poc) from adiantamento_cliente where num_proc = Hou.Num_proc_Hia)
		left join Pessoa						SHP on SHP.cd_pes = HOU.cd_export_hia
		Left Join PO_HiA						PO on PO.Num_Proc_HiA=HOU.num_proc_hia and PO.ID_DC='3'
		Left Join PO_HiA						CU on CU.Num_Proc_HiA=HOU.num_proc_hia and CU.ID_DC='9'
		left join Hist_Geral					HG on HG.HSGProcesso=HOU.Num_Proc_HiA and HG.cd_tp_ocor = '28'
		left Join Tipo_Oper						TP on HOU.cd_tp_oper = TP.Cd_tp_oper
		left join campo_processo      			CP on LLP.num_proc_lia=cp.num_proc and cp.id_campo=36
		left join verdade						VD on cp.campo_dados = VD.id
		Join Tarefas_Processos				ST on ST.num_proc=num_proc_lia and St.id_Task=13 and (st.dt_conclusao is null or st.dt_conclusao >='01-01-2010')

	where
		(PO.Numero_PO_HiA not in ('CANCELLED JOB','PACKAGE RETURN','SAMPLE','FREIGHT FORWARDER') or PO.Numero_PO_HiA is null)
		and (CU.Numero_PO_HiA not in ('CANCELLED JOB','PACKAGE RETURN','SAMPLE','FREIGHT FORWARDER') or CU.Numero_PO_HiA is null)
		and HG.cd_tp_ocor is null
		and (substring(hou.num_proc_hia,3,3)='LYB' and CSN.Apelido ='LYONDELL' or substring(hou.num_proc_hia,3,3)<>'LYB')
		
	
	group by
		UC.nome_usuario,
		HOU.Num_Proc_HIA,
		HOU.HAWB_HIA,HOU.MAWB_HIA,
		CSN.Apelido,
		CSN.Num_CPF_CNPJ,
		Org.Nome_Local,
		Dst.Nome_Local,
		Nome_Cia_Aer,
		Voo_HIA,
		TERM.Nome_Terminal,
		ETD_LIA,
		ATD_LIA,
		ETA_LIA,
		ATA_LIA,
		DI.Numero_PO_HIA, 
		DI.Data_PO_HIA,
		Canal_LIA,
		HOU.Obs_HIA,
		PG.Apelido,
--		AC.Dt_Solicitacao,
		SHP.Apelido,
		HOU.Num_Proc_Mia,
		PDET.UoM,
		TP.NOME_Tp_Oper,
		vd.descricao,
		localidade
/*
UNION
	select
		UC.nome_usuario									Nome_PO,
		'Other'											Modal,
		HOU.Num_Proc_HIo								Ref_BDP,
		CSN.Apelido										Consignee,
		CSN.Num_CPF_CNPJ								CNPJ,
		HOU.MAWB_HIo									Master,
		HOU.HAWB_HIo									House,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIo,1)	PO,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIo,9)	CustomerPO,
		dbo.fBusca_GMID(HOU.Num_Proc_HIo)				Cod_Prod,
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIo)			Produto,
		Org.Nome_Local									Origem,
		Dst.Nome_Local									Destino,
		CIA.Apelido										Carrier,
		Voo_HIo											Navio_Voo,
		isnull(dbo.fBusca_Containers_IM(HOU.Num_Proc_HIo),
		dbo.fBusca_Volumes(HOU.Num_Proc_HIo))			Containers,
		TERM.Nome_Terminal,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIo,23)	LI,
		dbo.fBusca_Tarefa(hou.num_proc_HIo,20)			Def_LI,
		ETD_LIo											ETD,
		ATD_LIo											ATD,
		ETA_LIo											ETA,
		ATA_LIo											ATA,
		dbo.fBusca_Tarefa(hou.Num_Proc_HIO,16)			ChegadaDOCs,
		dbo.fBusca_Tarefa(HOU.Num_Proc_HIO,16)          Chegada_Docs,
		dbo.fBusca_Tarefa(hou.num_proc_HIO,28)			Entrada_Terminal,
		dbo.fBusca_Tarefa(hou.num_proc_HIO,15)			Presenca_Carga,
		DI.Numero_PO_HIo								DI, 
		DI.Data_PO_HIo									Data_DI,
		dbo.fBusca_Tarefa(hou.num_proc_HIO,4)			Dt_Desemb,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIO,3)	DSM_Ref,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIO,2)	Num_Invoice,
		Canal_LIo										Canal,
		dbo.fBusca_Tarefa(hou.num_proc_HIo,7)			Entr_Docs_Transp,
		dbo.fBusca_Tarefa(hou.num_proc_HIo,13)			Entrega_Planta,
		dbo.fBusca_HistoricoDescr(hou.num_proc_HIo,0,getdate()) Historico,
		max(FCHB.Data_PC)								Prest_Contas,
		dbo.fBusca_Tarefa(hou.num_proc_hio,29)			Desova,
		dbo.fBusca_Tarefa(hou.num_proc_hio,27)			Digitacao,
		dbo.fBusca_Containers(hou.num_proc_hio)			Containers,
--		dbo.Qty_Container(hou.num_proc_hio)				Qtde,
		dbo.fBusca_TEUS(hou.num_proc_hio)				TEUS,
		dbo.fBusca_Tarefa(hou.num_proc_hio,67)			NFE,
		HOU.Obs_HIo Notes,
		PG.Apelido										Nome_Grupo,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_Hio, 5)	N_LI,
		isnull(dbo.fBusca_Tarefa(hou.num_proc_hio,59),
		dbo.FBusca_Adto(hou.num_proc_hio))				Sol_Numerario,
		SHP.Apelido										Shipper,
		PDET.UoM										Unid,
		''	Ref_Consolidada,
		TP.NOME_Tp_Oper									Incoterm,
		vd.descricao									Urgente,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_hio,13)		Prev_Entrega,
		dbo.fbusca_campocliente(hou.num_proc_hio,43)	EnvDrafCom,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_hio,60)		Abertura_Pasta,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_hio,46)		Solict_LI,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_hio,41)		Aprova_draft,
		dbo.fBusca_Tarefa(hou.num_proc_hio,21)			Lib_BL,
		dbo.fBusca_Tarefa(hou.num_proc_hio,26)			EnvDocsFat,
		dbo.fBusca_Tarefa(hou.num_proc_hio,42)			RedestCont,
		dbo.fBusca_Tarefa(hou.num_proc_hio,70)			NF_Comp,
		Isnull(localidade,'STS')						Localidade

	from
		llp_imp_out LLP
		Join House_Imp_out					HOU on LLP.num_proc_LIo=hou.num_proc_HIo
--		left Join Job_Imp_out				JOB on JOB.num_proc_HIo=hou.num_proc_HIo
--		left Join Cia_Aerea					CIA on CIA.Cd_Cia_Out=JOB.Cd_Cia_Out
		left Join Pedido_Ship				PS on PS.num_proc=hou.num_proc_HIo
		Left Join Pedido_Det				PDET on PDET.cd_produto=PS.cd_produto and PDET.cd_pedido=PS.cd_pedido and pdet.lote=ps.lote and pdet.item=ps.item
		left Join Pedido					PD on PD.cd_pedido=PS.cd_pedido
		left Join Produto_cliente			PC on PC.cd_prod=ps.cd_produto
		left Join Localidade				Org on hou.cd_org_HIo=Org.cd_local
		left Join Localidade				Dst on cd_dst_HIo=DSt.cd_local
		Left Join Terminal					TERM on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Join PO_HIo					DI on DI.Num_Proc_HIo=hou.num_proc_HIo and DI.id_dc=5
		Join Pessoa_LLP						PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIo --and PLL.Cd_Pes_Grupo=@Cd_Grupo
		Left Join Usuario_Cliente			UC on UC.cd_usuario=PD.PO_Responsible --and PD.Cd_Grupo=@Cd_Grupo
		Join Pessoa							CSN on CSN.cd_pes=HOU.Cd_Consig_HIo
		left Join Fatura_CHB				FCHB on HOU.Num_Proc_HIo = FCHB.Processo_PC
		join Grupo							G on G.grupo= right(left(HOU.Num_Proc_HIo,5),3)
		Left jOIN CHB_Cliente_Localidade			chb ON chB.CD_PES_GRUPO=g.CD_PES_GRUPO
		join pessoa							PG on PG.cd_pes=G.cd_pes_grupo
		left Join pessoa					CIA on CIA.cd_pes=llp.cd_carrier
--		left join Adiantamento_Cliente		AC on AC.Num_Proc = Hou.Num_proc_Hio and AC.POC = (select min(poc) from adiantamento_cliente where num_proc = Hou.Num_proc_Hio)
		left join Pessoa					SHP on SHP.cd_pes = HOU.cd_export_hio
		Left Join PO_HIO					PO on PO.Num_Proc_Hio=HOU.num_proc_hio and PO.ID_DC='3'
		Left Join PO_HIO					CU on CU.Num_Proc_Hio=HOU.num_proc_hio and CU.ID_DC='9'
		left join Hist_Geral				HG on HG.HSGProcesso=HOU.Num_Proc_Hio and HG.cd_tp_ocor = '28'
		left Join Tipo_Oper					TP on HOU.cd_tp_oper = TP.Cd_tp_oper
		left join campo_processo      		CP on LLP.num_proc_lio=cp.num_proc and cp.id_campo=36
		left join verdade					VD on cp.campo_dados = VD.id
		Join Tarefas_Processos				ST on ST.num_proc=num_proc_lio and St.id_Task=13 

	where
		
		(PO.Numero_PO_Hio not in ('CANCELLED JOB','PACKAGE RETURN','SAMPLE','FREIGHT FORWARDER') or PO.Numero_PO_Hio is null)
		and (CU.Numero_PO_Hio not in ('CANCELLED JOB','PACKAGE RETURN','SAMPLE','FREIGHT FORWARDER') or CU.Numero_PO_Hio is null)
		and HG.cd_tp_ocor is null
		and (substring(hou.num_proc_hio,3,3)='LYB' and CSN.Apelido ='LYONDELL' or substring(hou.num_proc_hio,3,3)<>'LYB')
		and (st.dt_conclusao is null or st.dt_conclusao >='01-01-2010')

	group by
		UC.nome_usuario,
		HOU.Num_Proc_HIo,
		HOU.HAWB_HIo,HOU.MAWB_HIo,
		CSN.Apelido,
		CSN.Num_CPF_CNPJ,
		Org.Nome_Local,
		Dst.Nome_Local,
		CIA.Apelido,
		Voo_HIo,
		TERM.Nome_Terminal,
		ETD_LIo,
		ATD_LIo,
		ETA_LIo,
		ATA_LIo,
		DI.Numero_PO_HIo, 
		DI.Data_PO_HIo,
		Canal_LIo,
		HOU.Obs_HIo,
		PG.Apelido,
--		AC.Dt_Solicitacao,
		SHP.Apelido,
		PDET.UoM,
		TP.NOME_Tp_Oper,
		vd.descricao,
		localidade
	order by 
		3









*/


GO
