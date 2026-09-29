SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Os casos IO não aparecem pq o despacho é feito pela Pibernat
-- retirado a clausula de não trazer os casos da lyondell - debora 14/5/12, 
--o usuario foi instruido a incluir o nao no despacho do add fields


CREATE       Procedure [dbo].[spMAC_Tracking_IMP_Rel] 

As
	select 
		'N/A'											Nome_PO,
		--UC.nome_usuario								Nome_PO,
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
		DEFLI.dt_conclusao								Def_LI,
		ETD_LIM											ETD,
		ATD_LIM											ATD,
		ETA_LIM											ETA,
		ATA_LIM											ATA,
		ChegDocs.dt_conclusao					        Chegada_Docs,
		ENTTErm.dt_conclusao							Entrada_Terminal,
		PRESENCA.Dt_Conclusao							Presenca_Carga,
		DI.Numero_PO_Him								DI, 
		DI.Data_PO_Him									Data_DI,
		DESEMB.Dt_Conclusao								Dt_Desemb,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,3)	DSM_Ref,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,2)	Num_Invoice,
		Canal_Lim										Canal,
		DOCT.Dt_Conclusao								Entr_Docs_Transp,
		GR.DT_Conclusao									Entrega_Planta,
		dbo.fBusca_HistoricoDescr(hou.num_proc_him,0,getdate()) Historico,
		isnull(dbo.fBusca_Tarefa(hou.num_proc_him,14),dbo.fBusca_Tarefa(hou.num_proc_him,40))Prest_Contas,
		DESOVA.DT_Conclusao								Desova,
		DIG.Dt_Conclusao								Digitacao,
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
		'N/A'											Unid,
--		PDET.UoM										Unid,		
		(case when HOU.Num_Proc_Mim = 'JOB' then null else HOU.Num_Proc_Mim end)	Ref_Consolidada,
		TP.NOME_Tp_Oper									Incoterm,
		vd.descricao									Urgente,
		GR.DT_Previsao									Prev_Entrega,
		EnvDraft.Dt_Conclusao							EnvDrafCom,
		AbePasta.Dt_Conclusao							Abertura_Pasta,
		SOLLI.Dt_Conclusao								Solict_LI,
		Adraft.Dt_Conclusao								Aprova_draft,
		LIBBL.Dt_Conclusao								Lib_BL,
		dbo.fBusca_Tarefa(hou.num_proc_him,62)			EnvDocsFat,
		RedCont.Dt_Conclusao							RedestCont,
		dbo.fBusca_Tarefa(hou.num_proc_him,70)			NF_Comp,
		Isnull(localidade,'STS')						Localidade,
		AVERB.DT_Conclusao								Dt_Averbacao,
		dbo.fBusca_Tarefa(hou.num_proc_him,25)			AFRMM,
		Saldo_Final										Sal_Proc,
		dbo.fBusca_Caixa_Data(hou.num_proc_him,'armazenag%','D')	Pgto_Armazenagem,
		EnvDFAT.Dt_Conclusao										EnvFatSP,
		dbo.fBusca_Tarefa(hou.num_proc_him,35)						RecebFat,
		dbo.fBusca_Caixa_Data(hou.num_proc_him,'SDA%','D')			Pgto_SDA

	from
		llp_imp_mar LLP with (nolock)
		Left Join Tarefas_Processos DEFLI		with (nolock) on num_proc_lim=DEFLI.num_proc and DEFLI.id_task=20
		Left Join Tarefas_Processos ChegDocs	with (nolock) on num_proc_lim=ChegDocs.num_proc and ChegDocs.id_task=16
		Left Join Tarefas_Processos ENTTErm		with (nolock) on num_proc_lim=ENTTErm.num_proc and ENTTErm.id_task=28
		Left Join Tarefas_Processos PRESENCA	with (nolock) on num_proc_lim=PRESENCA.num_proc and PRESENCA.id_task=15
		Left Join Tarefas_Processos DESEMB		with (nolock) on num_proc_lim=DESEMB.num_proc and DESEMB.id_task=4
		Left Join Tarefas_Processos DOCT		with (nolock) on num_proc_lim=DOCT.num_proc and DOCT.id_task=7
		Left Join Tarefas_Processos GR			with (nolock) on num_proc_lim=GR.num_proc and GR.id_task=13
		Left Join Tarefas_Processos DESOVA		with (nolock) on num_proc_lim=DESOVA.num_proc and DESOVA.id_task=29
		Left Join Tarefas_Processos DIG			with (nolock) on num_proc_lim=DIG.num_proc and DIG.id_task=27
		Left Join Tarefas_Processos EnvDFAT		with (nolock) on num_proc_lim=EnvDFAT.num_proc and EnvDFAT.id_task=26
		Left Join Tarefas_Processos RedCont		with (nolock) on num_proc_lim=RedCont.num_proc and RedCont.id_task=42
		Left Join Tarefas_Processos EnvDraft	with (nolock) on num_proc_lim=EnvDraft.num_proc and EnvDraft.id_task=48
		Left Join Tarefas_Processos AbePasta	with (nolock) on num_proc_lim=AbePasta.num_proc and AbePasta.id_task=60
		Left Join Tarefas_Processos SOLLI		with (nolock) on num_proc_lim=SOLLI.num_proc and SOLLI.id_task=46
		Left Join Tarefas_Processos Adraft		with (nolock) on num_proc_lim=Adraft.num_proc and Adraft.id_task=41
		Left Join Tarefas_Processos LIBBL		with (nolock) on num_proc_lim=LIBBL.num_proc and LIBBL.id_task=21
		Left Join Tarefas_Processos AVERB		with (nolock) on num_proc_lim=AVERB.num_proc and AVERB.id_task=68

		Join House_Imp_Mar					HOU with (nolock) on LLP.num_proc_LIM=hou.num_proc_HIM
		left Join Job_Imp_Mar				JOB  with (nolock) on JOB.num_proc_him=hou.num_proc_him
		left Join Armador					ARM with (nolock) on ARM.cd_armador=job.cd_armador
		left Join Localidade				Org on hou.cd_org_HIM=Org.cd_local
		left Join Localidade				Dst on cd_dst_HIM=DSt.cd_local
		Left Join Terminal					TERM on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Join PO_HIM					DI on DI.Num_Proc_Him=hou.num_proc_him and DI.id_dc=5
		Join Pessoa_LLP						PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIM 
		Join Pessoa							CSN on CSN.cd_pes=HOU.Cd_Consig_HIM
		join Grupo							G on G.grupo= right(left(HOU.Num_Proc_HIM,5),3)
		LEFT jOIN CHB_Cliente_Localidade	chb ON chB.CD_PES_GRUPO=g.CD_PES_GRUPO
		join pessoa							PG with(nolock) on PG.cd_pes=G.cd_pes_grupo
		left join Pessoa					SHP on SHP.cd_pes = HOU.cd_export_him
		Left Join PO_HIM					PO on PO.Num_Proc_Him=HOU.num_proc_him and PO.ID_DC='3'
		Left Join PO_HIM					CU on CU.Num_Proc_Him=HOU.num_proc_him and CU.ID_DC='9'
		left join Hist_Geral				HG with(nolock) on HG.HSGProcesso=HOU.Num_Proc_Him and HG.cd_tp_ocor = '28'
		left Join Tipo_Oper					TP with(nolock) on HOU.cd_tp_oper = TP.Cd_tp_oper
		left join campo_processo      		CP with(nolock) on LLP.num_proc_lim=cp.num_proc and cp.id_campo=36
		left join verdade					VD with(nolock) on cp.campo_dados = VD.id
		Join Tarefas_Processos				ST with(nolock) on ST.num_proc=num_proc_lim and St.id_Task=13 and st.dt_conclusao is null
		Left Join saldo_adiantamento_temp	SA ON LLP.NUM_PROC_LIM=SA.NUM_PROC
		Left Join Campo_Processo			CPD on num_proc_lim=CPD.num_proc and CPD.id_Campo=32 --and CPD.Campo_Dados=2
		
	where
		ETD_LIM >=getdate()-365 and 
		(PO.Numero_PO_HIM not in ('CANCELLED JOB','PACKAGE RETURN','SAMPLE','FREIGHT FORWARDER') or PO.Numero_PO_HIM is null)
		and (CU.Numero_PO_HIM not in ('CANCELLED JOB','PACKAGE RETURN','SAMPLE','FREIGHT FORWARDER') or CU.Numero_PO_HIM is null)
		and HG.cd_tp_ocor is null and (LLP.ID_Status <> '9' or LLP.ID_Status is null)
		--and (substring(hou.num_proc_him,3,3)='LYB' and CSN.Apelido ='LYONDELL' or substring(hou.num_proc_him,3,3)<>'LYB')
		and ((CPD.Campo_Dados is null)or(CPD.Campo_Dados = '1'))
		and (DOCT.DT_Conclusao is null or DOCT.DT_Conclusao >=getdate()-30)

	group by
		AVERB.DT_Conclusao,
		LIBBL.Dt_Conclusao,
		Adraft.Dt_Conclusao,
		SOLLI.Dt_Conclusao,
		AbePasta.Dt_Conclusao,
		EnvDraft.Dt_Conclusao,
		RedCont.Dt_Conclusao,
		EnvDFAT.Dt_Conclusao,
		GR.DT_Previsao,
		DIG.DT_Conclusao,	
		DESOVa.DT_conclusao,
		GR.Dt_Conclusao,
		DOCT.Dt_Conclusao,
		DESEMB.Dt_Conclusao,
		PRESENCA.dt_conclusao,
		ENTTErm.dt_conclusao,
		saldo_final,
--		UC.nome_usuario,
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
		TP.NOME_Tp_Oper,
		vd.descricao,
		Localidade,
		DEFLI.dt_conclusao,
		ChegDocs.dt_conclusao


UNION ALL
	select 
				'N/A'											Nome_PO,
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
		isnull(dbo.fBusca_Tarefa(hou.num_proc_hia,14),dbo.fBusca_Tarefa(hou.num_proc_hia,40)) Prest_Contas,
		dbo.fBusca_Tarefa(hou.num_proc_hia,29)			Desova,
		dbo.fBusca_Tarefa(hou.num_proc_hia,27)			Digitacao,
		Null										Containers,
--		dbo.Qty_Container(hou.num_proc_hia)				Qtde,
		dbo.fBusca_TEUS(hou.num_proc_hia)				TEUS,
		dbo.fBusca_Tarefa(hou.num_proc_hia,67)			NFE,
		HOU.Obs_HIA Notes,
		PG.Apelido										Nome_Grupo,
		dbo.fBusca_CampoCliente(HOU.Num_Proc_Hia, 5)	N_LI,
		isnull(dbo.fBusca_Tarefa(hou.num_proc_hia,59),
		dbo.FBusca_Adto(hou.num_proc_hia))				Sol_Numerario,
		SHP.Apelido										Shipper,
		'N/A'											Unid,
		(case when HOU.Num_Proc_Mia = 'JOB' then null else HOU.Num_Proc_Mia end)	Ref_Consolidada,
		TP.NOME_Tp_Oper									Incoterm,
		vd.descricao									Urgente,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_hia,13)		Prev_Entrega,
		dbo.fbusca_campocliente(hou.num_proc_hia,43)	EnvDrafCom,
		dbo.fBusca_Tarefa(hou.num_proc_hia,60)		Abertura_Pasta,
		dbo.fBusca_Tarefa(hou.num_proc_hia,46)		Solict_LI,
		dbo.fBusca_Tarefa(hou.num_proc_hia,41)		Aprova_draft,
		dbo.fBusca_Tarefa(hou.num_proc_hia,21)			Lib_BL,
		dbo.fBusca_Tarefa(hou.num_proc_hia,62)			EnvDocsFat,
		dbo.fBusca_Tarefa(hou.num_proc_hia,42)			RedestCont,
		dbo.fBusca_Tarefa(hou.num_proc_hia,70)			NF_Comp,
		Isnull(localidade,'STS')						Localidade,
		dbo.fBusca_Tarefa(hou.num_proc_hia,68)			Dt_Averbacao,
		dbo.fBusca_Tarefa(hou.num_proc_hia,25)			AFRMM,
		Saldo_Final										Sal_Proc,
		dbo.fBusca_Caixa_Data(hou.num_proc_hia,'armazenag%','D') Pgto_Armazenagem,
		dbo.fBusca_Tarefa(hou.num_proc_hia,26)			EnvFatSP,
		dbo.fBusca_Tarefa(hou.num_proc_hia,35)			RecebFat,
		dbo.fBusca_Caixa_Data(hou.num_proc_hia,'SDA%','D') Pgto_SDA
	from
		llp_imp_Aer LLP
		Join House_Imp_Aer						HOU on LLP.num_proc_LIA=hou.num_proc_HIA
		left Join Job_Imp_Aer					JOB on JOB.num_proc_HIA=hou.num_proc_HIA
		left Join Cia_Aerea						CIA on CIA.Cd_Cia_Aer=JOB.Cd_Cia_Aer
		--left Join Pedido_Ship					PS on PS.num_proc=hou.num_proc_HIA
		--Left Join Pedido_Det					PDET on PDET.cd_produto=PS.cd_produto and PDET.cd_pedido=PS.cd_pedido and pdet.lote=ps.lote and pdet.item=ps.item
		--left Join Pedido						PD on PD.cd_pedido=PS.cd_pedido
		--left Join Produto_cliente				PC on PC.cd_prod=ps.cd_produto
		left Join Localidade					Org on hou.cd_org_HIA=Org.cd_local
		left Join Localidade					Dst on cd_dst_HIA=DSt.cd_local
		Left Join Terminal						TERM on LLP.Cd_Terminal = TERM.Cd_Terminal
		Left Join PO_HIA						DI on DI.Num_Proc_HIA=hou.num_proc_HIA and DI.id_dc=5
		Join Pessoa_LLP							PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIA-- and PLL.Cd_Pes_Grupo=@Cd_Grupo
		--Left Join Usuario_Cliente				UC on UC.cd_usuario=PD.PO_Responsible-- and PD.Cd_Grupo=@Cd_Grupo
		Join Pessoa								CSN on CSN.cd_pes=HOU.Cd_Consig_HIA
--		left Join Fatura_CHB					FCHB on HOU.Num_Proc_HIA = FCHB.Processo_PC or HOU.Num_Proc_MIA = FCHB.Processo_PC
		join Grupo								G on G.grupo= right(left(HOU.Num_Proc_HIA,5),3)
		Left jOIN CHB_Cliente_Localidade		chb ON chB.CD_PES_GRUPO=g.CD_PES_GRUPO
		join pessoa								PG on PG.cd_pes=G.cd_pes_grupo
--		left join Adiantamento_Cliente			AC on AC.Num_Proc = Hou.Num_proc_Hia and AC.POC = (select min(poc) from adiantamento_cliente where num_proc = Hou.Num_proc_Hia)
		left join Pessoa						SHP on SHP.cd_pes = HOU.cd_export_hia
		Left Join PO_HiA						PO on PO.Num_Proc_HiA=HOU.num_proc_hia and PO.ID_DC='3'
		Left Join PO_HiA						CU on CU.Num_Proc_HiA=HOU.num_proc_hia and CU.ID_DC='9'
		left join Hist_Geral					HG on HG.HSGProcesso=HOU.Num_Proc_HiA and HG.cd_tp_ocor = '28'
		left Join Tipo_Oper						TP on HOU.cd_tp_oper = TP.Cd_tp_oper
		left join campo_processo      			CP on LLP.num_proc_lia=cp.num_proc and cp.id_campo=36
		left join verdade						VD on cp.campo_dados = VD.id
		Join Tarefas_Processos					ST on ST.num_proc=num_proc_lia and St.id_Task=13 and st.dt_conclusao is null
		Left Join saldo_adiantamento_temp		SA ON LLP.NUM_PROC_LIa=SA.NUM_PROC
		Left Join Campo_Processo				CPD on num_proc_lia=CPD.num_proc and CPD.id_Campo=32 --and CPD.Campo_Dados=2

	where
		ETD_LIa >=getdate()-365 and 
		(PO.Numero_PO_HiA not in ('CANCELLED JOB','PACKAGE RETURN','SAMPLE','FREIGHT FORWARDER') or PO.Numero_PO_HiA is null)
		and (CU.Numero_PO_HiA not in ('CANCELLED JOB','PACKAGE RETURN','SAMPLE','FREIGHT FORWARDER') or CU.Numero_PO_HiA is null)
		and HG.cd_tp_ocor is null and (LLP.ID_Status <> '9' or LLP.ID_Status is null)
		-- and (substring(hou.num_proc_hia,3,3)='LYB' and CSN.Apelido ='LYONDELL' or substring(hou.num_proc_hia,3,3)<>'LYB')
		and (CPD.Campo_Dados is null) or (CPD.Campo_Dados = '1')
		and ( dbo.fBusca_Tarefa(hou.num_proc_hia,7) is null or dbo.fBusca_Tarefa(hou.num_proc_hia,7) >=getdate()-90)
		and ( dbo.fBusca_Tarefa(hou.num_proc_hia,7) is null or dbo.fBusca_Tarefa(hou.num_proc_hia,7) >=getdate()-90)

	group by
		Saldo_Final,
		--UC.nome_usuario,
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
		--PDET.UoM,
		TP.NOME_Tp_Oper,
		vd.descricao,
		localidade
order by 
		3,
		ETA

--UNION
--	select 
--		UC.nome_usuario									Nome_PO,
--		'Other'											Modal,
--		HOU.Num_Proc_HIo								Ref_BDP,
--		CSN.Apelido										Consignee,
--		CSN.Num_CPF_CNPJ								CNPJ,
--		HOU.MAWB_HIo									Master,
--		HOU.HAWB_HIo									House,
--		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIo,1)	PO,
--		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIo,9)	CustomerPO,
--		dbo.fBusca_GMID(HOU.Num_Proc_HIo)				Cod_Prod,
--		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIo)			Produto,
--		Org.Nome_Local									Origem,
--		Dst.Nome_Local									Destino,
--		CIA.Apelido										Carrier,
--		Voo_HIo											Navio_Voo,
--		isnull(dbo.fBusca_Containers_IM(HOU.Num_Proc_HIo),
--		dbo.fBusca_Volumes(HOU.Num_Proc_HIo))			Containers,
--		TERM.Nome_Terminal,
--		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIo,23)	LI,
--		dbo.fBusca_Tarefa(hou.num_proc_HIo,20)			Def_LI,
--		ETD_LIo											ETD,
--		ATD_LIo											ATD,
--		ETA_LIo											ETA,
--		ATA_LIo											ATA,
--		dbo.fBusca_Tarefa(hou.Num_Proc_HIO,16)			ChegadaDOCs,
--		dbo.fBusca_Tarefa(HOU.Num_Proc_HIO,16)          Chegada_Docs,
--		dbo.fBusca_Tarefa(hou.num_proc_HIO,28)			Entrada_Terminal,
--		dbo.fBusca_Tarefa(hou.num_proc_HIO,15)			Presenca_Carga,
--		DI.Numero_PO_HIo								DI, 
--		DI.Data_PO_HIo									Data_DI,
--		dbo.fBusca_Tarefa(hou.num_proc_HIO,4)			Dt_Desemb,
--		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIO,3)	DSM_Ref,
--		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIO,2)	Num_Invoice,
--		Canal_LIo										Canal,
--		dbo.fBusca_Tarefa(hou.num_proc_HIo,7)			Entr_Docs_Transp,
--		dbo.fBusca_Tarefa(hou.num_proc_HIo,13)			Entrega_Planta,
--		dbo.fBusca_HistoricoDescr(hou.num_proc_HIo,0,getdate()) Historico,
--		max(FCHB.Data_PC)								Prest_Contas,
--		dbo.fBusca_Tarefa(hou.num_proc_hio,29)			Desova,
--		dbo.fBusca_Tarefa(hou.num_proc_hio,27)			Digitacao,
--		dbo.fBusca_Containers(hou.num_proc_hio)			Containers,
----		dbo.Qty_Container(hou.num_proc_hio)				Qtde,
--		dbo.fBusca_TEUS(hou.num_proc_hio)				TEUS,
--		dbo.fBusca_Tarefa(hou.num_proc_hio,67)			NFE,
--		HOU.Obs_HIo Notes,
--		PG.Apelido										Nome_Grupo,
--		dbo.fBusca_CampoCliente(HOU.Num_Proc_Hio, 5)	N_LI,
--		isnull(dbo.fBusca_Tarefa(hou.num_proc_hio,59),
--		dbo.FBusca_Adto(hou.num_proc_hio))				Sol_Numerario,
--		SHP.Apelido										Shipper,
--		PDET.UoM										Unid,
--		''	Ref_Consolidada,
--		TP.NOME_Tp_Oper									Incoterm,
--		vd.descricao									Urgente,
--		dbo.fBusca_Tarefa_Prev(hou.num_proc_hio,13)		Prev_Entrega,
--		dbo.fbusca_campocliente(hou.num_proc_hio,43)	EnvDrafCom,
--		dbo.fBusca_Tarefa(hou.num_proc_hio,60)			Abertura_Pasta,
--		dbo.fBusca_Tarefa(hou.num_proc_hio,46)			Solict_LI,
--		dbo.fBusca_Tarefa(hou.num_proc_hio,41)			Aprova_draft,
--		dbo.fBusca_Tarefa(hou.num_proc_hio,21)			Lib_BL,
--		dbo.fBusca_Tarefa(hou.num_proc_hio,62)			EnvDocsFat,
--		dbo.fBusca_Tarefa(hou.num_proc_hio,42)			RedestCont,
--		dbo.fBusca_Tarefa(hou.num_proc_hio,70)			NF_Comp,
--		Isnull(localidade,'STS')						Localidade,
--		dbo.fBusca_Tarefa(hou.num_proc_hio,68)			Dt_Averbacao,
--		dbo.fBusca_Tarefa(hou.num_proc_hio,25)			AFRMM,
--		Saldo_Final										Sal_Proc,
--		dbo.fBusca_Caixa_Data(hou.num_proc_hio,'armazenag%','D') Pgto_Armazenagem,
--		dbo.fBusca_Tarefa(hou.num_proc_hio,26)			EnvFatSP,
--		dbo.fBusca_Tarefa(hou.num_proc_hio,35)			RecebFat,
--		dbo.fBusca_Caixa_Data(hou.num_proc_hio,'SDA%','D') Pgto_SDA
--	from
--		llp_imp_out LLP
--		Join House_Imp_out					HOU on LLP.num_proc_LIo=hou.num_proc_HIo
----		left Join Job_Imp_out				JOB on JOB.num_proc_HIo=hou.num_proc_HIo
----		left Join Cia_Aerea					CIA on CIA.Cd_Cia_Out=JOB.Cd_Cia_Out
--		left Join Pedido_Ship				PS on PS.num_proc=hou.num_proc_HIo
--		Left Join Pedido_Det				PDET on PDET.cd_produto=PS.cd_produto and PDET.cd_pedido=PS.cd_pedido and pdet.lote=ps.lote and pdet.item=ps.item
--		left Join Pedido					PD on PD.cd_pedido=PS.cd_pedido
--		left Join Produto_cliente			PC on PC.cd_prod=ps.cd_produto
--		left Join Localidade				Org on hou.cd_org_HIo=Org.cd_local
--		left Join Localidade				Dst on cd_dst_HIo=DSt.cd_local
--		Left Join Terminal					TERM on LLP.Cd_Terminal = TERM.Cd_Terminal
--		Left Join PO_HIo					DI on DI.Num_Proc_HIo=hou.num_proc_HIo and DI.id_dc=5
--		Join Pessoa_LLP						PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIo --and PLL.Cd_Pes_Grupo=@Cd_Grupo
--		Left Join Usuario_Cliente			UC on UC.cd_usuario=PD.PO_Responsible --and PD.Cd_Grupo=@Cd_Grupo
--		Join Pessoa							CSN on CSN.cd_pes=HOU.Cd_Consig_HIo
--		left Join Fatura_CHB				FCHB on HOU.Num_Proc_HIo = FCHB.Processo_PC
--		join Grupo							G on G.grupo= right(left(HOU.Num_Proc_HIo,5),3)
--		Left jOIN CHB_Cliente_Localidade			chb ON chB.CD_PES_GRUPO=g.CD_PES_GRUPO
--		join pessoa							PG on PG.cd_pes=G.cd_pes_grupo
--		left Join pessoa					CIA on CIA.cd_pes=llp.cd_carrier
----		left join Adiantamento_Cliente		AC on AC.Num_Proc = Hou.Num_proc_Hio and AC.POC = (select min(poc) from adiantamento_cliente where num_proc = Hou.Num_proc_Hio)
--		left join Pessoa					SHP on SHP.cd_pes = HOU.cd_export_hio
--		Left Join PO_HIO					PO on PO.Num_Proc_Hio=HOU.num_proc_hio and PO.ID_DC='3'
--		Left Join PO_HIO					CU on CU.Num_Proc_Hio=HOU.num_proc_hio and CU.ID_DC='9'
--		left join Hist_Geral				HG on HG.HSGProcesso=HOU.Num_Proc_Hio and HG.cd_tp_ocor = '28'
--		left Join Tipo_Oper					TP on HOU.cd_tp_oper = TP.Cd_tp_oper
--		left join campo_processo      		CP on LLP.num_proc_lio=cp.num_proc and cp.id_campo=36
--		left join verdade					VD on cp.campo_dados = VD.id
--		Join Tarefas_Processos				ST on ST.num_proc=num_proc_lio and St.id_Task=13 and st.dt_conclusao is null
--		Left Join saldo_adiantamento_temp		SA ON LLP.NUM_PROC_LIo=SA.NUM_PROC
--
--	where
--		
--		(PO.Numero_PO_Hio not in ('CANCELLED JOB','PACKAGE RETURN','SAMPLE','FREIGHT FORWARDER') or PO.Numero_PO_Hio is null)
--		and (CU.Numero_PO_Hio not in ('CANCELLED JOB','PACKAGE RETURN','SAMPLE','FREIGHT FORWARDER') or CU.Numero_PO_Hio is null)
--		and HG.cd_tp_ocor is null
--		and (substring(hou.num_proc_hio,3,3)='LYB' and CSN.Apelido ='LYONDELL' or substring(hou.num_proc_hio,3,3)<>'LYB')
--		and (dbo.fBusca_CampoCliente(HOU.Num_Proc_Hio, 32) = '1' or dbo.fBusca_CampoCliente(HOU.Num_Proc_Hio, 32) is null)
--	group by
--		saldo_final,
--		UC.nome_usuario,
--		HOU.Num_Proc_HIo,
--		HOU.HAWB_HIo,HOU.MAWB_HIo,
--		CSN.Apelido,
--		CSN.Num_CPF_CNPJ,
--		Org.Nome_Local,
--		Dst.Nome_Local,
--		CIA.Apelido,
--		Voo_HIo,
--		TERM.Nome_Terminal,
--		ETD_LIo,
--		ATD_LIo,
--		ETA_LIo,
--		ATA_LIo,
--		DI.Numero_PO_HIo, 
--		DI.Data_PO_HIo,
--		Canal_LIo,
--		HOU.Obs_HIo,
--		PG.Apelido,
----		AC.Dt_Solicitacao,
--		SHP.Apelido,
--		PDET.UoM,
--		TP.NOME_Tp_Oper,
--		vd.descricao,
--		localidade
	

































GO
