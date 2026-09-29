SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--isnull(dbo.fBusca_Tarefa(hou.num_proc_him,14),dbo.fBusca_Tarefa(hou.num_proc_him,40))Prest_Contas,
--spATL_Tracking_IMP_CHB_Rel 'GRUPO ALL','2012-07-16','2013-07-16'
--22/8 - incluido o and isnull(P1.Numero_PO_HIA,'') pq não acha qdo nao tem po lançado - Tracking Import - CHB SP
--1572
--16/07/2013 - retirada a regra do historico cancelado
--09/03/2016 - Incluido os seguintes campos (Document Delivery - Value, PDF - BL, PDF - CE Mercante,Exoneração de ICMS Value, Devolução de CNTR Value) - Ticket 100-44272

CREATE Procedure [dbo].[spATL_Tracking_IMP_CHB_Rel]--spATL_Tracking_IMP_CHB_Rel 'GRUPO ALL','2011-01-05','2012-08-07'
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
As

	if @Grupo = 'GRUPO ALL'
		set @Grupo = '%'	
	
	--Declare @Grupo varchar(20)
	--Declare @DtInicial datetime
	--Declare @DtFinal datetime
	--	set @DtInicial = getdate() - 365
	--	set @DtFinal  = getdate()
	--	set @Grupo = '%'	
--	Declare @Temp Table
--		(
--			Num_proc_hist varchar(16)
--			
--		)
--	Begin
--		Insert 	@Temp
--		select left(hsgprocesso,16) from hist_geral with(nolock)where cd_tp_ocor = 28
--	End	
	select
		'AIR'																		[Modal],
		Nome_BDP_Produto															[BDP Product],
		LLP.Num_Proc_LIA															[BDP Ref.],
		(case when HOU.Num_Proc_Mia = 'JOB' then null else HOU.Num_Proc_Mia end)	[Consol. Ref.],
		''																			[Dispatch Type],
		PG.Apelido																	[Group],
		CSN.Apelido [Consignee],
		CSN.Num_CPF_CNPJ [CNPJ],
		HOU.MAWB_HIA [Master],
		HOU.HAWB_HIA [House],
--		P1.numero_po_hia [P.O.],
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIA,1)	[P.O.],
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIA) [Product],
		ORG.Nome_Local [Origin],
		DST.Nome_Local [Destination],
		ARM.Nome_cia_aer [Carrier],
		HOU.voo_hia [Vessel / Flight #],
		dbo.fBusca_Volumes(HOU.Num_Proc_HIA) [Containers / Volumes],
		(case when CP5.campo_dados ='1' then 'Sim' when CP5.campo_dados ='2' then 'Não' else Null end) [Necessidade LI?],
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIA,13) [Certificado de Origem],
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIA,24) [Drawback - Ato Concess.],
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIA,23) [L.I.],
		T46.dt_conclusao [Data Solic. L.I.],
		T20.dt_conclusao [Data Def. L.I.],
		TP180.Dt_Conclusao [Conferência de LI],
		TP181.Dt_Conclusao [Conferência de LI Sub],
		T20.dt_conclusao + 120 [Data Vcto.],
		T175.dt_conclusao [Deferimento de LI Pós],
		T153.dt_conclusao [AUTORIZAÇÃO DE EMBARQUE],
		LLP.ETD_LIA [ETD Date],
		LLP.ATD_LIA	[ATD Date],
		T154.dt_conclusao [AUDITORIA DATA MANAGEMENT],
		T41.dt_conclusao [Data Aprov. Draft],
		T174.dt_conclusao [RECEB. DOCS. ORIGINAIS CSR],
		T155.dt_conclusao [RECEB. DOCS. ORIGINAIS CHB],
		T60.dt_conclusao [Data Abertura Pasta],
		T27.dt_conclusao [Data Digitação],
		T16.dt_conclusao [Data Cheg. Docs.],
		isnull(T59.dt_conclusao,dbo.FBusca_Adto(hou.num_proc_hia)) [Data Sol. Numerario],
		T42.dt_conclusao [Data Redest. Container],
		LLP.ETA_LIA [ETA Date],
		SA.Saldo_Final [Saldo Processo Valor],
		LLP.ATA_LIA [ATA Date],
		T25.dt_conclusao [Data Pgto. AFRMM],
		TRM.nome_terminal [Terminal],
		T28.dt_conclusao [Data Entr. Terminal],
		T163.dt_conclusao [SELECIONADA P/ INSP. MADEIRA],
		T105.dt_conclusao [INSP. MADEIRA CONCLUÍDA],		
		T164.dt_conclusao [MADEIRA LIBERADA],
		T29.dt_conclusao [Data Desova],
		T15.dt_conclusao [Data Presença Carga],
		T156.dt_conclusao [PRESENÇA DE CARGA P/ DI],
		T21.dt_conclusao [Data Liberação BL],
		case
				when P5.numero_po_hia='' Then Null
				else P5.numero_po_hia
		End
			 [D.I.],
		P5.data_po_hia   [Data D.I.],
		T4.dt_conclusao  [Data Desembaraço],
		dbo.fBusca_Caixa_Data(hou.num_proc_hia,'armazenag%','D') [Data Pgto Armazenagem],
		dbo.fBusca_Caixa_Data(hou.num_proc_hia,'SDA%','D') [Data Pgto SDA],
		T68.dt_conclusao [Data Averbação],
		LLP.canal_lia [Channel],
		T67.dt_conclusao [Data Env Draft NFe],
		T108.dt_conclusao [RECEBIMENTO DE DANFE],
		T7.dt_conclusao  [DOCS DISPONÍVEIS P/ TRANSP], --[Data Entr Docs Transp],.
		T165.dt_conclusao [DOCS RETIRADOS PELA TRANSP.],
		T70.dt_conclusao [Data Env Draft NF Compl],
		T62.dt_conclusao [Data Env Docs Faturamento],
		T26.dt_conclusao [Data Env. Faturamento SP],
		T35.dt_conclusao [Data Receb. Faturamento],
		T13.dt_previsao  [Data Prev Entrega],
		T13.dt_conclusao [Data Entrega Planta],
		dbo.fBusca_HistoricoDescr(hou.num_proc_hia,0,getdate()) [Histórico],
		HOU.obs_hia [Notes (OBS)],
		(case when CP36.campo_dados ='1' then 'SIM' else 'Não' end) [Urgente],
		Isnull(CCL.localidade,'STS') [Localidade],
		CP146.campo_dados [Delivery Address],
		[dbo].[fBusca_Custo_Processo](hou.Num_Proc_hia,'Certificado de Origem%') [Document Delivery - Value],
		Case when DC20.Id_DC='20' then 'YES' else 'NO' End	[PDF - BL],
		Case when DC29.Id_DC='29' then 'YES' else 'NO' End	[PDF - CE Mercante],
		[dbo].[fBusca_Custo_Processo](hou.num_proc_hia,'Exoneração de ICMS%') [Exoneração de ICMS Value],
		[dbo].[fBusca_Custo_Processo](hou.num_proc_hia,'Devolução de CNTR%')[Devolução de CNTR Value]
		
		
	from
		llp_imp_aer LLP with(nolock)
		INNER HASH JOIN House_Imp_aer HOU	with(nolock) on LLP.num_proc_LIA=HOU.num_proc_HIA
		INNER HASH JOIN Pessoa_LLP PLL		with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIA --and PLL.Cd_Pes_Grupo=G.Cd_Pes_Grupo
		INNER HASH JOIN Grupo G				with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
		INNER HASH JOIN pessoa	PG			with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
		left HASH JOIN CHB_Cliente_Localidade CCL with(nolock) on CCL.cd_pes_grupo=G.cd_pes_grupo
		INNER HASH JOIN Pessoa CSN			with(nolock) on CSN.cd_pes=HOU.Cd_Consig_HIA
		left HASH JOIN Job_Imp_aer JOB		with(nolock) on JOB.num_proc_hia=HOU.num_proc_hia
		left HASH JOIN Cia_Aerea ARM		with(nolock) on ARM.cd_cia_aer=job.cd_cia_aer
		left HASH JOIN Terminal TRM			with(nolock) on TRM.Cd_Terminal=LLP.Cd_Terminal
		left HASH JOIN Localidade ORG		with(nolock) on HOU.cd_org_HIA=ORG.cd_local
		left HASH JOIN Localidade DST		with(nolock) on HOU.cd_dst_HIA=DST.cd_local
		Left HASH JOIN saldo_adiantamento_temp SA with(nolock) on LLP.num_proc_lia=SA.num_proc
		Left HASH JOIN PO_HIA P1			with(nolock) on P1.Num_Proc_Hia=HOU.num_proc_hia and P1.ID_DC=1
		Left HASH JOIN PO_HIA P5			with(nolock) on P5.Num_Proc_Hia=HOU.num_proc_hia and P5.ID_DC=5
		Left HASH JOIN Tarefas_Processos T46	with(nolock) on LLP.num_proc_lia=T46.num_proc and T46.id_task=46
		Left HASH JOIN Tarefas_Processos T20	with(nolock) on LLP.num_proc_lia=T20.num_proc and T20.id_task=20
		Left HASH JOIN Tarefas_Processos T41	with(nolock) on LLP.num_proc_lia=T41.num_proc and T41.id_task=41
		Left HASH JOIN Tarefas_Processos T60	with(nolock) on LLP.num_proc_lia=T60.num_proc and T60.id_task=60
		Left HASH JOIN Tarefas_Processos T27	with(nolock) on LLP.num_proc_lia=T27.num_proc and T27.id_task=27
		Left HASH JOIN Tarefas_Processos T16	with(nolock) on LLP.num_proc_lia=T16.num_proc and T16.id_task=16
		Left HASH JOIN Tarefas_Processos T59	with(nolock) on LLP.num_proc_lia=T59.num_proc and T59.id_task=59
		Left HASH JOIN Tarefas_Processos T42	with(nolock) on LLP.num_proc_lia=T42.num_proc and T42.id_task=42
		Left HASH JOIN Tarefas_Processos T25	with(nolock) on LLP.num_proc_lia=T25.num_proc and T25.id_task=25
		Left HASH JOIN Tarefas_Processos T28	with(nolock) on LLP.num_proc_lia=T28.num_proc and T28.id_task=28
		Left HASH JOIN Tarefas_Processos T29	with(nolock) on LLP.num_proc_lia=T29.num_proc and T29.id_task=29
		Left HASH JOIN Tarefas_Processos T15	with(nolock) on LLP.num_proc_lia=T15.num_proc and T15.id_task=15
		Left HASH JOIN Tarefas_Processos T21	with(nolock) on LLP.num_proc_lia=T21.num_proc and T21.id_task=21
		Left HASH JOIN Tarefas_Processos T4		with(nolock) on LLP.num_proc_lia= T4.num_proc and  T4.id_task=4
		Left HASH JOIN Tarefas_Processos T68	with(nolock) on LLP.num_proc_lia=T68.num_proc and T68.id_task=68
		Left HASH JOIN Tarefas_Processos T67	with(nolock) on LLP.num_proc_lia=T67.num_proc and T67.id_task=67
		Left HASH JOIN Tarefas_Processos T7		with(nolock) on LLP.num_proc_lia= T7.num_proc and  T7.id_task=7
		Left HASH JOIN Tarefas_Processos T70	with(nolock) on LLP.num_proc_lia=T70.num_proc and T70.id_task=70
		Left HASH JOIN Tarefas_Processos T62	with(nolock) on LLP.num_proc_lia=T62.num_proc and T62.id_task=62
		INNER HASH JOIN  Tarefas_Processos T13	with(nolock) on LLP.num_proc_lia=T13.num_proc and T13.id_task=13 and T13.dt_conclusao is null
		Left HASH JOIN Tarefas_Processos T26	with(nolock) on LLP.num_proc_lia=T26.num_proc and T26.id_task=26
		Left HASH JOIN Tarefas_Processos T35	with(nolock) on LLP.num_proc_lia=T35.num_proc and T35.id_task=35
		left HASH JOIN campo_processo CP5		with(nolock) on CP5.num_proc=LLP.num_proc_lia and CP5.id_campo=5
		left HASH JOIN campo_processo CP36		with(nolock) on CP36.num_proc=LLP.num_proc_lia and CP36.id_campo=36
		left HASH JOIN campo_processo CP146		with(nolock) on CP146.num_proc=LLP.num_proc_lia and CP146.id_campo=146
		left HASH JOIN campo_processo CP32		with(nolock) on CP32.num_proc=LLP.num_proc_lia and CP32.id_campo=32 and CP32.Campo_Dados='2'
		left HASH JOIN Campo_Processo CP143		with(nolock) on CP143.Num_Proc=LLP.Num_Proc_Lia and CP143.Id_Campo = '143'
		left HASH JOIN BDP_Produto PRO			with(nolock) on CP143.Campo_Dados = PRO.ID_PD
--		left HASH JOIN Hist_Geral CANC with(nolock) on CANC.HSGProcesso=HOU.Num_Proc_Hia and CANC.cd_tp_ocor = 28
--		Left HASH JOIN @Temp CANC on num_proc_hist=hou.num_proc_hia
		INNER HASH JOIN  Tarefas_Processos T40	with(nolock) on LLP.num_proc_lia=T40.num_proc and T40.id_task=40 and T40.dt_conclusao is null
		INNER HASH JOIN  Tarefas_Processos T14	with(nolock) on LLP.num_proc_lia=T14.num_proc and T14.id_task=14 and T14.dt_conclusao is null
		
		Left HASH JOIN Tarefas_Processos T153	with(nolock) on LLP.num_proc_lia= T153.num_proc and  T153.id_task=153
		Left HASH JOIN Tarefas_Processos T154	with(nolock) on LLP.num_proc_lia= T154.num_proc and  T154.id_task=154
		Left HASH JOIN Tarefas_Processos T156	with(nolock) on LLP.num_proc_lia= T156.num_proc and  T156.id_task=156
		Left HASH JOIN Tarefas_Processos T105	with(nolock) on LLP.num_proc_lia= T105.num_proc and  T105.id_task=105
		Left HASH JOIN Tarefas_Processos T163	with(nolock) on LLP.num_proc_lia= T163.num_proc and  T163.id_task=163
		Left HASH JOIN Tarefas_Processos T164	with(nolock) on LLP.num_proc_lia= T164.num_proc and  T164.id_task=164
		Left HASH JOIN Tarefas_Processos T108	with(nolock) on LLP.num_proc_lia= T108.num_proc and  T108.id_task=108
		Left HASH JOIN Tarefas_Processos T165	with(nolock) on LLP.num_proc_lia= T165.num_proc and  T165.id_task=165
		Left HASH JOIN Tarefas_Processos T175	with(nolock) on LLP.num_proc_lia= T175.num_proc and  T175.id_task=165
		Left HASH JOIN Tarefas_Processos T174	with(nolock) on LLP.num_proc_lia= T174.num_proc and  T174.id_task=174
		Left HASH JOIN Tarefas_Processos T155	with(nolock) on LLP.num_proc_lia= T155.num_proc and  T155.id_task=155
		Left HASH Join Tarefas_Processos TP180	with (nolock)on LLP.Num_Proc_Lia = TP180.Num_Proc and TP180.ID_Task = '180' 
		Left HASH Join Tarefas_Processos TP181	with (nolock)on LLP.Num_Proc_Lia = TP181.Num_Proc and TP181.ID_Task = '181'
		Left HASH Join Doc_Anexos DC20 with(nolock) on LLP.Num_Proc_Lia = DC20.Num_Proc and DC20.Id_DC = '20'
		Left HASH Join Doc_Anexos DC29 with(nolock) on LLP.Num_Proc_Lia = DC29.Num_Proc and DC29.Id_DC = '29'
	where
		LLP.ETD_LIA >= @DtInicial --and @DtFinal 
		and isnull(P1.Numero_PO_HIA,'') not in ('CANCELLED JOB','PACKAGE RETURN','SAMPLE','FREIGHT FORWARDER') 
--		and num_proc_hist is null
		and (Isnull(LLP.ID_Status,1) not in (9,5))
	--	and isnull(CP32.Campo_Dados,'1')= '1'
		and CP32.Campo_Dados is null
		and (isnull(T7.DT_Conclusao,getdate())>=getdate()-60)
		and (PG.Apelido like @Grupo or @Grupo ='CHB')


	UNION ALL

	select
		'OCEAN'																			[Modal],
		Nome_BDP_Produto																[BDP Product],
		LLP.Num_Proc_LIM																[BDP Ref.],
		(case when HOU.Num_Proc_Mim = 'JOB' then null else HOU.Num_Proc_Mim end)		[Consol. Ref.],
		TC.Nome_Tp_Carga																[Dispatch Type],
		PG.Apelido																		[Group],
		CSN.Apelido																		[Consignee],
		CSN.Num_CPF_CNPJ																[CNPJ],
		HOU.MAWB_HIM																	[Master],
		HOU.HAWB_HIM																	[House],
--		P1.numero_po_him																[P.O.],
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,1)									[P.O.],
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIM)											[Product],
		ORG.Nome_Local																	[Origin],
		DST.Nome_Local																	[Destination],
		ARM.Nome_Armador																[Carrier],
		HOU.Navio_HIM																	[Vessel / Flight #],
		isnull(dbo.fBusca_Containers_IM(HOU.Num_Proc_HIM),dbo.fBusca_Volumes(HOU.Num_Proc_HIM)) [Containers],
		(case when CP5.campo_dados ='1' then 'Sim' when CP5.campo_dados ='2' then 'Não' else Null end) [Necessidade LI?],
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,13)									[Certificado de Origem],
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,24)									[Drawback - Ato Concess.],
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,23)									[L.I.],
		T46.dt_conclusao																[Data Solic. L.I.],
		T20.dt_conclusao																[Data Def. L.I.],
		TP180.Dt_Conclusao																[Conferência de LI],
		TP181.Dt_Conclusao																[Conferência de LI Sub],
		T20.dt_conclusao + 120															[Data Vcto.],
		T175.dt_conclusao [Deferimento de LI Pós],
		T153.dt_conclusao [AUTORIZAÇÃO DE EMBARQUE],
		LLP.ETD_LIM																		[ETD Date],
		LLP.ATD_LIM																		[ATD Date],
		T154.dt_conclusao [AUDITORIA DATA MANAGEMENT],
		T41.dt_conclusao																[Data Aprov. Draft],		
		T174.dt_conclusao [RECEB. DOCS. ORIGINAIS CSR],
		T155.dt_conclusao [RECEB. DOCS. ORIGINAIS CHB],
		T60.dt_conclusao																[Data Abertura Pasta],
		T27.dt_conclusao																[Data Digitação],
		T16.dt_conclusao																[Data Cheg. Docs.],
		isnull(T59.dt_conclusao,dbo.FBusca_Adto(hou.num_proc_him))						[Data Sol. Numerario],
		T42.dt_conclusao																[Data Redest. Container],
		LLP.ETA_LIM																		[ETA Date],
		SA.Saldo_Final																	[Saldo Processo Valor],
		LLP.ATA_LIM																		[ATA Date],
		T25.dt_conclusao																[Data Pgto. AFRMM],
		TRM.nome_terminal																[Terminal],
		T28.dt_conclusao																[Data Entr. Terminal],
		T163.dt_conclusao [SELECIONADA P/ INSP. MADEIRA],
		T105.dt_conclusao [INSP. MADEIRA CONCLUÍDA],		
		T164.dt_conclusao [MADEIRA LIBERADA],
		T29.dt_conclusao																[Data Desova],
		T15.dt_conclusao																[Data Presença Carga],
		T156.dt_conclusao [PRESENÇA DE CARGA P/ DI],
		T21.dt_conclusao																[Data Liberação BL],
		case
				when P5.numero_po_him='' Then Null
				else P5.numero_po_him
		End
			 [D.I.],
		P5.data_po_him																	[Data D.I.],
		T4.dt_conclusao																	[Data Desembaraço],
		dbo.fBusca_Caixa_Data(hou.num_proc_him,'armazenag%','D')						[Data Pgto Armazenagem],
		dbo.fBusca_Caixa_Data(hou.num_proc_him,'SDA%','D')								[Data Pgto SDA],
		T68.dt_conclusao																[Data Averbação],
		LLP.canal_lim																	[Channel],
		T67.dt_conclusao																[Data Env Draft NFe],
		T108.dt_conclusao [RECEBIMENTO DE DANFE],
		T7.dt_conclusao																	[Data Entr Docs Transp],
		T165.dt_conclusao [DOCS RETIRADOS PELA TRANSP.],
		T70.dt_conclusao																[Data Env Draft NF Compl],
		T62.dt_conclusao																[Data Env Docs Faturamento],
		T26.dt_conclusao																[Data Env. Faturamento SP],
		T35.dt_conclusao																[Data Receb. Faturamento],
		T13.dt_previsao																	[Data Prev Entrega],
		T13.dt_conclusao																[Data Entrega Planta],
		dbo.fBusca_HistoricoDescr(hou.num_proc_him,0,getdate())							[Histórico],
		HOU.obs_him																		[Notes (OBS)],
		(case when CP36.campo_dados ='1' then 'SIM' else 'Não' end)						[Urgente],
		Isnull(CCL.localidade,'STS'),
		CP146.campo_dados [Delivery Address],
		[dbo].[fBusca_Custo_Processo](hou.num_proc_him,'Certificado de Origem%') [Document Delivery - Value],
		Case when DC20.Id_DC='20' then 'YES' else 'NO' End	[PDF - BL],
		Case when DC29.Id_DC='29' then 'YES' else 'NO' End	[PDF - CE Mercante],
		[dbo].[fBusca_Custo_Processo](hou.num_proc_him,'Exoneração de ICMS%') [Exoneração de ICMS Value],
		[dbo].[fBusca_Custo_Processo](hou.num_proc_him,'Devolução de CNTR%')[Devolução de CNTR Value]
	from
		llp_imp_mar LLP with(nolock)
		INNER HASH JOIN House_Imp_Mar HOU with(nolock) on LLP.num_proc_LIM=HOU.num_proc_HIM
		INNER HASH JOIN Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIM --and PLL.Cd_Pes_Grupo=G.Cd_Pes_Grupo		
		INNER HASH JOIN Grupo G			with(nolock) on G.cd_pes_grupo= PLL.cd_pes_grupo
		INNER HASH JOIN pessoa	PG		with(nolock) on PG.cd_pes=G.Cd_Pes_Grupo
		left HASH JOIN CHB_Cliente_Localidade CCL with(nolock) on CCL.cd_pes_grupo=G.cd_pes_grupo
		INNER HASH JOIN Pessoa CSN		with(nolock) on CSN.cd_pes=HOU.Cd_Consig_HIM
		left HASH JOIN Job_Imp_Mar JOB	with(nolock) on JOB.num_proc_him=HOU.num_proc_him
		left HASH JOIN Armador ARM		with(nolock) on ARM.cd_armador=job.cd_armador
		left HASH JOIN Terminal TRM		with(nolock) on TRM.Cd_Terminal=LLP.Cd_Terminal
		left HASH JOIN Localidade ORG	with(nolock) on HOU.cd_org_HIM=ORG.cd_local
		left HASH JOIN Localidade DST	with(nolock) on HOU.cd_dst_HIM=DST.cd_local
		Left HASH JOIN saldo_adiantamento_temp SA with(nolock) on LLP.num_proc_lim=SA.num_proc
		Left HASH JOIN PO_HIM P1		with(nolock) on P1.Num_Proc_Him=HOU.num_proc_him and P1.ID_DC=1
		Left HASH JOIN PO_HIM P5		with(nolock) on P5.Num_Proc_Him=HOU.num_proc_him and P5.ID_DC=5
		Left HASH JOIN Tipo_Carga TC	with(nolock) on  LLP.Cd_Tp_Carga = TC.Cd_Tp_Carga 
		Left HASH JOIN Tarefas_Processos T46	with(nolock) on LLP.num_proc_lim=T46.num_proc and T46.id_task=46
		Left HASH JOIN Tarefas_Processos T20	with(nolock) on LLP.num_proc_lim=T20.num_proc and T20.id_task=20
		Left HASH JOIN Tarefas_Processos T41	with(nolock) on LLP.num_proc_lim=T41.num_proc and T41.id_task=41
		Left HASH JOIN Tarefas_Processos T60	with(nolock) on LLP.num_proc_lim=T60.num_proc and T60.id_task=60
		Left HASH JOIN Tarefas_Processos T27	with(nolock) on LLP.num_proc_lim=T27.num_proc and T27.id_task=27
		Left HASH JOIN Tarefas_Processos T16	with(nolock) on LLP.num_proc_lim=T16.num_proc and T16.id_task=16
		Left HASH JOIN Tarefas_Processos T59	with(nolock) on LLP.num_proc_lim=T59.num_proc and T59.id_task=59
		Left HASH JOIN Tarefas_Processos T42	with(nolock) on LLP.num_proc_lim=T42.num_proc and T42.id_task=42
		Left HASH JOIN Tarefas_Processos T25	with(nolock) on LLP.num_proc_lim=T25.num_proc and T25.id_task=25
		Left HASH JOIN Tarefas_Processos T28	with(nolock) on LLP.num_proc_lim=T28.num_proc and T28.id_task=28
		Left HASH JOIN Tarefas_Processos T29	with(nolock) on LLP.num_proc_lim=T29.num_proc and T29.id_task=29
		Left HASH JOIN Tarefas_Processos T15	with(nolock) on LLP.num_proc_lim=T15.num_proc and T15.id_task=15
		Left HASH JOIN Tarefas_Processos T21	with(nolock) on LLP.num_proc_lim=T21.num_proc and T21.id_task=21
		Left HASH JOIN Tarefas_Processos T4		with(nolock) on LLP.num_proc_lim= T4.num_proc and  T4.id_task=4
		Left HASH JOIN Tarefas_Processos T68	with(nolock) on LLP.num_proc_lim=T68.num_proc and T68.id_task=68
		Left HASH JOIN Tarefas_Processos T67	with(nolock) on LLP.num_proc_lim=T67.num_proc and T67.id_task=67
		Left HASH JOIN Tarefas_Processos T7		with(nolock) on LLP.num_proc_lim= T7.num_proc and  T7.id_task=7
		Left HASH JOIN Tarefas_Processos T70	with(nolock) on LLP.num_proc_lim=T70.num_proc and T70.id_task=70
		Left HASH JOIN Tarefas_Processos T62	with(nolock) on LLP.num_proc_lim=T62.num_proc and T62.id_task=62
		INNER HASH JOIN Tarefas_Processos T13	with(nolock) on LLP.num_proc_lim=T13.num_proc and T13.id_task=13 and T13.dt_conclusao is null
		Left HASH JOIN Tarefas_Processos T26	with(nolock) on LLP.num_proc_lim=T26.num_proc and T26.id_task=26
		Left HASH JOIN Tarefas_Processos T35	with(nolock) on LLP.num_proc_lim=T35.num_proc and T35.id_task=35
		left HASH JOIN campo_processo CP5		with(nolock) on CP5.num_proc=LLP.num_proc_lim and CP5.id_campo=5
		left HASH JOIN campo_processo CP36		with(nolock) on CP36.num_proc=LLP.num_proc_lim and CP36.id_campo=36
		left HASH JOIN campo_processo CP146		with(nolock) on CP146.num_proc=LLP.num_proc_lim and CP146.id_campo=146
		left HASH JOIN campo_processo CP32		with(nolock) on CP32.num_proc=LLP.num_proc_lim and CP32.id_campo=32 and CP32.Campo_Dados='2'
		left HASH JOIN Campo_Processo CP143		with(nolock) on CP143.Num_Proc=LLP.Num_Proc_Lim and CP143.Id_Campo = '143'
		left HASH JOIN BDP_Produto PRO			with(nolock) on CP143.Campo_Dados = PRO.ID_PD
--		left HASH JOIN Hist_Geral CANC with(nolock) on CANC.HSGProcesso=HOU.Num_Proc_Him and CANC.cd_tp_ocor = 28
--		Left HASH JOIN @Temp CANC on num_proc_hist=hou.num_proc_him

		INNER HASH JOIN Tarefas_Processos T40 with(nolock) on LLP.num_proc_lim=T40.num_proc and T40.id_task=40 and T40.dt_conclusao is null
		INNER HASH JOIN Tarefas_Processos T14 with(nolock) on LLP.num_proc_lim=T14.num_proc and T14.id_task=14 and T14.dt_conclusao is null
		
		Left HASH JOIN Tarefas_Processos T153  with(nolock) on LLP.Num_Proc_Lim= T153.num_proc and  T153.id_task=153
		Left HASH JOIN Tarefas_Processos T154  with(nolock) on LLP.Num_Proc_Lim= T154.num_proc and  T154.id_task=154
		Left HASH JOIN Tarefas_Processos T156  with(nolock) on LLP.Num_Proc_Lim= T156.num_proc and  T156.id_task=156
		Left HASH JOIN Tarefas_Processos T105  with(nolock) on LLP.Num_Proc_Lim= T105.num_proc and  T105.id_task=105
		Left HASH JOIN Tarefas_Processos T163  with(nolock) on LLP.Num_Proc_Lim= T163.num_proc and  T163.id_task=163
		Left HASH JOIN Tarefas_Processos T164  with(nolock) on LLP.Num_Proc_Lim= T164.num_proc and  T164.id_task=164
		Left HASH JOIN Tarefas_Processos T108  with(nolock) on LLP.Num_Proc_Lim= T108.num_proc and  T108.id_task=108
		Left HASH JOIN Tarefas_Processos T165  with(nolock) on LLP.Num_Proc_Lim= T165.num_proc and  T165.id_task=165
		Left HASH JOIN Tarefas_Processos T175  with(nolock) on LLP.Num_Proc_Lim= T175.num_proc and  T175.id_task=165
		Left HASH JOIN Tarefas_Processos T174  with(nolock) on LLP.Num_Proc_Lim= T174.num_proc and  T174.id_task=174
		Left HASH JOIN Tarefas_Processos T155  with(nolock) on LLP.Num_Proc_Lim= T155.num_proc and  T155.id_task=155
		Left HASH Join Tarefas_Processos TP180 with (nolock)on LLP.Num_Proc_Lim = TP180.Num_Proc and TP180.ID_Task =180
		Left HASH Join Tarefas_Processos TP181 with (nolock)on LLP.Num_Proc_Lim = TP181.Num_Proc and TP181.ID_Task =181
		Left HASH Join Doc_Anexos DC20 with(nolock) on LLP.Num_Proc_Lim = DC20.Num_Proc and DC20.Id_DC = '20'
		Left HASH Join Doc_Anexos DC29 with(nolock) on LLP.Num_Proc_Lim = DC29.Num_Proc and DC29.Id_DC = '29'
	where
		LLP.ETD_LIM >= @DtInicial-- and @DtFinal 
		and isnull(P1.Numero_PO_HIM,'') not in ('CANCELLED JOB','PACKAGE RETURN','SAMPLE','FREIGHT FORWARDER') 
--		and CANC.cd_tp_ocor is null
--		and num_proc_hist is null
		and (Isnull(LLP.ID_Status,1) not in (9,5))
--		and isnull(CP32.Campo_Dados,'1')= '1'
		and CP32.Campo_Dados is null
		and (isnull(T7.DT_Conclusao,getdate())>=getdate()-60)
		and (hawb_him  <> 'CANCELLED JOB' or hawb_him is null)
		and (PG.Apelido like @Grupo or @Grupo ='CHB')


OPTION(HASH JOIN)
/*Solicitado pela Raquel - 02/07/2015
IM, IA	ENTREGA DE DOCS P/ TRANSPORTE	DOCS DISPONÍVEIS P/ TRANSP.	ALTERAR DESCRIÇÃO 7
IA		AUTORIZAÇÃO DE EMBARQUE	INCLUIR 153
IM, IA	AUDITORIA DATA MANEGMENT	INCLUIR 154
IM, IA	PRESENÇA DE CARGA P/ DI	INCLUIR 156
IM		INSPEÇÃO MAPA	INSP. MADEIRA CONCLUÍDA	ALTERAR DESCRIÇÃO 105
IM		SELECIONADA P/ INSP. MADEIRA	INCLUIR 163
IM		MADEIRA LIBERADA	INCLUIR 164
IM, IA	DANFE RECEIPT DATE	RECEBIMENTO DE DANFE	ALTERAR DESCRIÇÃO 108
IM, IA	DOCS RETIRADOS PELA TRANSP.	INCLUIR 165
IA, IM	Deferimento LI	Deferimento de LI Pós	INCLUIR 175
IM, IA	RECEB. DOCS. ORIGINAIS CSR	INCLUIR 174
IM		RECEB. DOCS. ORIGINAIS CHB	INCLUIR 155
*/
GO
