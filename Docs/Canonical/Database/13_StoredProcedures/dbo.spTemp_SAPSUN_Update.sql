SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE procedure [dbo].[spTemp_SAPSUN_Update]

as

Begin Transaction
	
	BEGIN
		--Incluir o numero correto do job, pegando o pedido e o item
		Begin
			update Temp_SapSUN set BROKER_REFERENCE=num_proc from Temp_SapSUN TS
				Join Pedido PD with(nolock) on  TS.Purchasing_Document_Number=PD.num_pedido
				Join Pedido_Ship PS with(nolock) on TS.Item_Number=ps.item and Ps.cd_pedido=PD.cd_pedido
				where (num_proc like 'I%SUN%' or num_proc like 'I%SPG%')
		End
		--Incluir o numero correto do job, pegando o pedido e o item

		Begin
			update Temp_SapSUN set BROKER_REFERENCE=num_proc from Temp_SapSUN TS
				Join Pedido PD with(nolock) on  TS.Purchasing_Document_Number=PD.num_pedido
				Join Pedido_Ship PS with(nolock) on Ps.cd_pedido=PD.cd_pedido --TS.Item_Number=ps.item and 
				where (num_proc like 'I%SUN%' or num_proc like 'I%SPG%') and len(BROKER_REFERENCE)<>16

		End
		
		--Incluir o numero correto do job, pegando o PO MODAL = TRACKING NUMBER
		Begin
			update Temp_SapSUN set BROKER_REFERENCE=num_proc_him from Temp_SapSUN TS
				Join PO_HIM HIM with(nolock) on  HIM.numero_po_him = 'SI '+TS.tracking_number
			where (num_proc_him like 'I%SUN%' or num_proc_him like 'I%SPG%') 
		End

		Begin
			update Temp_SapSUN set BROKER_REFERENCE=num_proc_hia from Temp_SapSUN TS
				Join PO_HIA HIA with(nolock) on  HIA.numero_po_hia = 'SI '+TS.tracking_number
			where (num_proc_hia like 'I%SUN%' or  num_proc_hia like 'I%SPG%')
		End

		Begin
			update Temp_SapSUN set BROKER_REFERENCE=num_proc_hio from Temp_SapSUN TS
				Join PO_HIO HIO with(nolock) on  HIO.numero_po_hio = 'SI '+TS.tracking_number
			where (num_proc_hio like 'I%SUN%' or num_proc_hio like 'I%SPG%')
		End
		Begin

			Update Temp_SapSUN set BROKER_REFERENCE=null
			Where
				Purchasing_Document_Number in
					(
					select num_pedido from pedido PD 
					join pedido_Ship PS on ps.cd_pedido=PD.cd_pedido
					Where
						num_proc like 'I%SUN%' or num_proc like 'I%SPG%' 
					group by num_pedido
					having 
							count(distinct num_proc) >1

					)
		End

		Begin
			update Temp_SapSUN
				set
					INCOTERM				=		HOU.cd_tp_oper,
					Data_embarque			=		convert(varchar(10), LIM.atd_lim,103),
					NOME_EMBARCACAO			=		HOU.Navio_HIM,
					NUMERO_CONHECIMENTO		=		HOU.HAWB_HIM,
					MOEDA_FRETE				=		HOU.cd_tp_moeda,
					VALOR_FRETE_DECLARADO_CONHECIMENTO = hou.Vlr_frete_efet_him,
					NUMERO_CONTAINER		=		left(upper(dbo.fBusca_Containers_IM_NUMERO(BROKER_REFERENCE)),50),
					NOME_ARMADOR			=		ARM.nome_armador,
					NOME_AGENTE_CARGAS		=		Agente.Apelido, 
					FREE_TIME_CONTAINER		=		(case when ARM.freetime is null then '10' else ARM.freetime end),
					DATA_CHEGADA			=		convert(varchar(10), LIM.ata_lim,103),
					DATA_INVOICE			=		convert(varchar(10), Invoice.Data_po_him,103),
					NUMERO_INVOICE			=		Invoice.Numero_po_him,
					MOEDA					=		LIM.cd_moeda_invoice,
					VALOR_TOTAL_INVOICE		=		LIM.vlr_invoice,
					DATA_VENCIMENTO			=		convert(varchar(10),Venc.Campo_dados,103),
					DATA_PAGAMENTO			=		convert(varchar(10),Pag.Data_po_him,103),
					NUMERO_CONTRATO_CAMBIO	=		Pag.Numero_po_him,
					NOME_TERMINAL_NAVIO_ATRACOU =	Tent.nome_terminal,
					NOME_TERMINAL_CARGA_LIBERADA =	Lib.nome_terminal,
					LIBERACAO_CONTAINER = '',
					DATA_DEVOLUCAO_CONTAINER	= left([dbo].[fBusca_Containers_Data_Devolucao](BROKER_REFERENCE),50),
					DIAS_DEMURRAGE_PAGAR		= datediff(day,(convert(datetime,[dbo].[fBusca_Containers_Data_Devolucao](BROKER_REFERENCE),105)),Lim.ATA_LIM),
					DATA_SOLICITACAO_NUMERARIO	= convert(varchar(10),SolNum.dt_conclusao,103),
					VALOR_DEPOSITADO_CONTA_DESPACHANTE = [dbo].[fBusca_CaixaTaxaVlr](BROKER_REFERENCE,'Adiantamento Cliente% - CHB%','C'),
					VALOR_ICMS_PREVISTO			= [dbo].[FBusca_ADTOTX1](BROKER_REFERENCE,'ICMS% - CHB%','C'),
					VALOR_DEBITO_CONTA_PREVISTO = '',--(select sum(Valor*Paridade) from adiantamento_cliente_det where id in (select id from adiantamento_cliente where num_proc = BROKER_REFERENCE) and conta = 'C'  - [dbo].[FBusca_ADTOTX1](BROKER_REFERENCE,'ICMS% - CHB%','C')),
					DATA_APROVACAO_NUMERARIO	= '',
					DATA_PAGAMENTO_VALOR_DESPACHANTE = '',
					DATA_AUTORIZACAO_REGISTRO_DI = '',
					DATA_DI						=	convert(varchar(10),DI.Data_po_him,103),
					NUMERO_DI					=	DI.Numero_po_him,
					DATA_LIBERACAO_DI			=	convert(varchar(10),DIL.dt_conclusao,103),
					DATA_ENVIO_DRAFT_NF			=	convert(varchar(10),DNF.dt_conclusao,103),
					DATA_ENVIO_NF_DESPACHANTE	=	convert(varchar(10),NF.Data_po_him,103),
					NUMERO_NF					=	NF.Numero_po_him,
					DATA_ENTREGA_DOCS_TRANSPORTADORA_CARREGAR = convert(varchar(10),DOC.dt_conclusao,103),
					DATA_CARREGAMENTO			=	'',
					DATA_ENTREGA_FABRICA		=	convert(varchar(10),Planta.dt_conclusao,103),
					ICMS_CONHECIMENTO_TRANSPORTE = 0,--'Soma (Custo Cliente = ICMS s/ Transp.)',
					DATA_ENTRADA_PROCESSO_SISTEMA = '',
					DATA_ENVIO_PRESTACAO_CONTAS =	convert(varchar(10),Prest.dt_conclusao,103),
					VALOR_ACERTAR				=	[dbo].[fBusca_CtaCteTaxaVlr](BROKER_REFERENCE,'Prest%','C'),
					DATA_PAGAMENTO_SALDO		=	convert(varchar(10),[dbo].[fBusca_Caixa_Data](BROKER_REFERENCE,'Presta%','C'),103),
					ICMS_REALIZADO				=	[dbo].[fBusca_Custo_Processo](BROKER_REFERENCE,'ICMS% - CHB%'),--'ICMS - Custo Processo',
					DEBITO_EM_CONTA_REALIZADO	=	[dbo].[fBusca_Custo_Processo](BROKER_REFERENCE,'%CHB%'),--'Soma de Taxa Siscomex, II, IPI, ICMS, PIS, Cofins',
					CRONOLOGIA					=	''

				from Temp_SapSUN TS
					join House_imp_mar		HOU					with(nolock) on HOU.num_proc_him = BROKER_REFERENCE
					join LLP_imp_mar		LIM					with(nolock) on LIM.num_proc_Lim = BROKER_REFERENCE
					join JOB_Imp_Mar		JOB					with(nolock) on JOB.num_proc_him = BROKER_REFERENCE
					left join Armador			ARM				with(nolock) on JOB.cd_armador = ARM.cd_armador
					left join Pessoa			Agente			with(nolock) on Agente.cd_pes = JOB.cd_agente
					left join po_him			Invoice			with(nolock) on Invoice.num_proc_him = BROKER_REFERENCE and Invoice.id_dc = 2 
					left join campo_processo	Venc			with(nolock) on Venc.num_proc = BROKER_REFERENCE and Venc.id_campo = 29
					left join po_him			Pag				with(nolock) on Pag.num_proc_him = BROKER_REFERENCE and PAg.id_dc = 15 
					left join campo_processo	Ent				with(nolock) on Ent.num_proc = BROKER_REFERENCE and Ent.id_campo = 2
					left join terminal			TEnt			with(nolock) on Tent.cd_terminal = Ent.campo_dados
					left join terminal			Lib				with(nolock) on	Lib.cd_terminal = LIM.cd_terminal
					left join tarefas_processos	SolNum			with(nolock) on SolNum.num_proc = BROKER_REFERENCE and SolNum.id_task = 59
					left join po_him			DI				with(nolock) on DI.num_proc_him = BROKER_REFERENCE and DI.id_dc = 5 
					left join tarefas_processos	DIL				with(nolock) on DIL.num_proc = BROKER_REFERENCE and DIL.id_task = 4
					left join tarefas_processos	DNF				with(nolock) on DNF.num_proc = BROKER_REFERENCE and DNF.id_task = 67
					left join po_him			NF				with(nolock) on NF.num_proc_him = BROKER_REFERENCE and NF.id_dc = 10
					left join tarefas_processos	DOC				with(nolock) on DOC.num_proc = BROKER_REFERENCE and DOC.id_task = 7
					left join tarefas_processos	Planta			with(nolock) on Planta.num_proc = BROKER_REFERENCE and Planta.id_task = 13
					left join tarefas_processos	Prest			with(nolock) on Prest.num_proc = BROKER_REFERENCE and Prest.id_task = 40
					
		End

--IMPORTAÇÃO OUTROS
		Begin
			update Temp_SapSUN
				set
					INCOTERM				=		HOU.cd_tp_oper,
					Data_embarque			=		convert(varchar(10), LIM.atd_lio,103),
					NOME_EMBARCACAO			=		'',
					NUMERO_CONHECIMENTO		=		HOU.HAWB_hio,
					MOEDA_FRETE				=		HOU.cd_tp_moeda,
					VALOR_FRETE_DECLARADO_CONHECIMENTO = hou.Vlr_frete_efet_hio,
					NUMERO_CONTAINER		=		left(upper(dbo.fBusca_Containers_IM_NUMERO(BROKER_REFERENCE)),50),
					NOME_ARMADOR			=		ARM.Apelido,
					NOME_AGENTE_CARGAS		=		'', 
					FREE_TIME_CONTAINER		=		'',
					DATA_CHEGADA			=		convert(varchar(10), LIM.ata_lio,103),
					DATA_INVOICE			=		convert(varchar(10), Invoice.Data_po_hio,103),
					NUMERO_INVOICE			=		Invoice.Numero_po_hio,
					MOEDA					=		LIM.cd_moeda_invoice,
					VALOR_TOTAL_INVOICE		=		LIM.vlr_invoice,
					DATA_VENCIMENTO			=		convert(varchar(10),Venc.Campo_dados,103),
					DATA_PAGAMENTO			=		convert(varchar(10),Pag.Data_po_hio,103),
					NUMERO_CONTRATO_CAMBIO	=		Pag.Numero_po_hio,
					NOME_TERMINAL_NAVIO_ATRACOU =	Tent.nome_terminal,
					NOME_TERMINAL_CARGA_LIBERADA =	Lib.nome_terminal,
					LIBERACAO_CONTAINER = '',
					DATA_DEVOLUCAO_CONTAINER	= left([dbo].[fBusca_Containers_Data_Devolucao](BROKER_REFERENCE),50),
					DIAS_DEMURRAGE_PAGAR		= datediff(day,(convert(datetime,[dbo].[fBusca_Containers_Data_Devolucao](BROKER_REFERENCE),105)),Lim.ATA_lio),
					DATA_SOLICITACAO_NUMERARIO	= convert(varchar(10),SolNum.dt_conclusao,103),
					VALOR_DEPOSITADO_CONTA_DESPACHANTE = [dbo].[fBusca_CaixaTaxaVlr](BROKER_REFERENCE,'Adiantamento Cliente% - CHB%','C'),
					VALOR_ICMS_PREVISTO			= [dbo].[FBusca_ADTOTX1](BROKER_REFERENCE,'ICMS% - CHB%','C'),
					VALOR_DEBITO_CONTA_PREVISTO = '',--(select sum(Valor*Paridade) from adiantamento_cliente_det where id in (select id from adiantamento_cliente where num_proc = BROKER_REFERENCE) and conta = 'C'  - [dbo].[FBusca_ADTOTX1](BROKER_REFERENCE,'ICMS% - CHB%','C')),
					DATA_APROVACAO_NUMERARIO	= '',
					DATA_PAGAMENTO_VALOR_DESPACHANTE = '',
					DATA_AUTORIZACAO_REGISTRO_DI = '',
					DATA_DI						=	convert(varchar(10),DI.Data_po_hio,103),
					NUMERO_DI					=	DI.Numero_po_hio,
					DATA_LIBERACAO_DI			=	convert(varchar(10),DIL.dt_conclusao,103),
					DATA_ENVIO_DRAFT_NF			=	convert(varchar(10),DNF.dt_conclusao,103),
					DATA_ENVIO_NF_DESPACHANTE	=	convert(varchar(10),NF.Data_po_hio,103),
					NUMERO_NF					=	NF.Numero_po_hio,
					DATA_ENTREGA_DOCS_TRANSPORTADORA_CARREGAR = convert(varchar(10),DOC.dt_conclusao,103),
					DATA_CARREGAMENTO			=	'',
					DATA_ENTREGA_FABRICA		=	convert(varchar(10),Planta.dt_conclusao,103),
					ICMS_CONHECIMENTO_TRANSPORTE = 0,--'Soma (Custo Cliente = ICMS s/ Transp.)',
					DATA_ENTRADA_PROCESSO_SISTEMA = '',
					DATA_ENVIO_PRESTACAO_CONTAS =	convert(varchar(10),Prest.dt_conclusao,103),
					VALOR_ACERTAR				=	[dbo].[fBusca_CtaCteTaxaVlr](BROKER_REFERENCE,'Prest%','C'),
					DATA_PAGAMENTO_SALDO		=	convert(varchar(10),[dbo].[fBusca_Caixa_Data](BROKER_REFERENCE,'Presta%','C'),103),
					ICMS_REALIZADO				=	[dbo].[fBusca_Custo_Processo](BROKER_REFERENCE,'ICMS% - CHB%'),--'ICMS - Custo Processo',
					DEBITO_EM_CONTA_REALIZADO	=	[dbo].[fBusca_Custo_Processo](BROKER_REFERENCE,'%CHB%'),--'Soma de Taxa Siscomex, II, IPI, ICMS, PIS, Cofins',
					CRONOLOGIA					=	''

				from Temp_SapSUN TS
					join House_imp_out		HOU					with(nolock) on HOU.num_proc_hio = BROKER_REFERENCE
					join LLP_imp_out		LIM					with(nolock) on LIM.num_proc_lio = BROKER_REFERENCE
					left join Pessoa			ARM				with(nolock) on cd_carrier=ARM.cd_pes
					left join po_hio			Invoice			with(nolock) on Invoice.num_proc_hio = BROKER_REFERENCE and Invoice.id_dc = 2 
					left join campo_processo	Venc			with(nolock) on Venc.num_proc = BROKER_REFERENCE and Venc.id_campo = 29
					left join po_hio			Pag				with(nolock) on Pag.num_proc_hio = BROKER_REFERENCE and PAg.id_dc = 15 
					left join campo_processo	Ent				with(nolock) on Ent.num_proc = BROKER_REFERENCE and Ent.id_campo = 2
					left join terminal			TEnt			with(nolock) on Tent.cd_terminal = Ent.campo_dados
					left join terminal			Lib				with(nolock) on	Lib.cd_terminal = LIM.cd_terminal
					left join tarefas_processos	SolNum			with(nolock) on SolNum.num_proc = BROKER_REFERENCE and SolNum.id_task = 59
					left join po_hio			DI				with(nolock) on DI.num_proc_hio = BROKER_REFERENCE and DI.id_dc = 5 
					left join tarefas_processos	DIL				with(nolock) on DIL.num_proc = BROKER_REFERENCE and DIL.id_task = 4
					left join tarefas_processos	DNF				with(nolock) on DNF.num_proc = BROKER_REFERENCE and DNF.id_task = 67
					left join po_hio			NF				with(nolock) on NF.num_proc_hio = BROKER_REFERENCE and NF.id_dc = 10
					left join tarefas_processos	DOC				with(nolock) on DOC.num_proc = BROKER_REFERENCE and DOC.id_task = 7
					left join tarefas_processos	Planta			with(nolock) on Planta.num_proc = BROKER_REFERENCE and Planta.id_task = 13
					left join tarefas_processos	Prest			with(nolock) on Prest.num_proc = BROKER_REFERENCE and Prest.id_task = 40
					
		End




		Begin
			update Temp_SapSUN
				set
					INCOTERM				=		HOU.cd_tp_oper,
					Data_embarque			=		convert(varchar(10), LIM.atd_LIA,103),
					NOME_EMBARCACAO			=		'',
					NUMERO_CONHECIMENTO		=		HOU.HAWB_HIA,
					MOEDA_FRETE				=		HOU.cd_tp_moeda,
					VALOR_FRETE_DECLARADO_CONHECIMENTO = hou.Vlr_frete_efet_HIA,
					NUMERO_CONTAINER		=		left(upper(dbo.fBusca_Containers_IM_NUMERO(BROKER_REFERENCE)),50),
					NOME_ARMADOR			=		ARM.Nome_Cia_Aer,
					NOME_AGENTE_CARGAS		=		'', 
					FREE_TIME_CONTAINER		=		'',
					DATA_CHEGADA			=		convert(varchar(10), LIM.ata_LIA,103),
					DATA_INVOICE			=		convert(varchar(10), Invoice.Data_po_HIA,103),
					NUMERO_INVOICE			=		Invoice.Numero_po_HIA,
					MOEDA					=		LIM.cd_moeda_invoice,
					VALOR_TOTAL_INVOICE		=		LIM.vlr_invoice,
					DATA_VENCIMENTO			=		convert(varchar(10),Venc.Campo_dados,103),
					DATA_PAGAMENTO			=		convert(varchar(10),Pag.Data_po_HIA,103),
					NUMERO_CONTRATO_CAMBIO	=		Pag.Numero_po_HIA,
					NOME_TERMINAL_NAVIO_ATRACOU =	Tent.nome_terminal,
					NOME_TERMINAL_CARGA_LIBERADA =	Lib.nome_terminal,
					LIBERACAO_CONTAINER = '',
					DATA_DEVOLUCAO_CONTAINER	= left([dbo].[fBusca_Containers_Data_Devolucao](BROKER_REFERENCE),50),
					DIAS_DEMURRAGE_PAGAR		= datediff(day,(convert(datetime,[dbo].[fBusca_Containers_Data_Devolucao](BROKER_REFERENCE),105)),Lim.ATA_LIA),
					DATA_SOLICITACAO_NUMERARIO	= convert(varchar(10),SolNum.dt_conclusao,103),
					VALOR_DEPOSITADO_CONTA_DESPACHANTE = [dbo].[fBusca_CaixaTaxaVlr](BROKER_REFERENCE,'Adiantamento Cliente% - CHB%','C'),
					VALOR_ICMS_PREVISTO			= [dbo].[FBusca_ADTOTX1](BROKER_REFERENCE,'ICMS% - CHB%','C'),
					VALOR_DEBITO_CONTA_PREVISTO = '',--(select sum(Valor*Paridade) from adiantamento_cliente_det where id in (select id from adiantamento_cliente where num_proc = BROKER_REFERENCE) and conta = 'C'  - [dbo].[FBusca_ADTOTX1](BROKER_REFERENCE,'ICMS% - CHB%','C')),
					DATA_APROVACAO_NUMERARIO	= '',
					DATA_PAGAMENTO_VALOR_DESPACHANTE = '',
					DATA_AUTORIZACAO_REGISTRO_DI = '',
					DATA_DI						=	convert(varchar(10),DI.Data_po_HIA,103),
					NUMERO_DI					=	DI.Numero_po_HIA,
					DATA_LIBERACAO_DI			=	convert(varchar(10),DIL.dt_conclusao,103),
					DATA_ENVIO_DRAFT_NF			=	convert(varchar(10),DNF.dt_conclusao,103),
					DATA_ENVIO_NF_DESPACHANTE	=	convert(varchar(10),NF.Data_po_HIA,103),
					NUMERO_NF					=	NF.Numero_po_HIA,
					DATA_ENTREGA_DOCS_TRANSPORTADORA_CARREGAR = convert(varchar(10),DOC.dt_conclusao,103),
					DATA_CARREGAMENTO			=	'',
					DATA_ENTREGA_FABRICA		=	convert(varchar(10),Planta.dt_conclusao,103),
					ICMS_CONHECIMENTO_TRANSPORTE = 0,--'Soma (Custo Cliente = ICMS s/ Transp.)',
					DATA_ENTRADA_PROCESSO_SISTEMA = '',
					DATA_ENVIO_PRESTACAO_CONTAS =	convert(varchar(10),Prest.dt_conclusao,103),
					VALOR_ACERTAR				=	[dbo].[fBusca_CtaCteTaxaVlr](BROKER_REFERENCE,'Prest%','C'),
					DATA_PAGAMENTO_SALDO		=	convert(varchar(10),[dbo].[fBusca_Caixa_Data](BROKER_REFERENCE,'Presta%','C'),103),
					ICMS_REALIZADO				=	[dbo].[fBusca_Custo_Processo](BROKER_REFERENCE,'ICMS% - CHB%'),--'ICMS - Custo Processo',
					DEBITO_EM_CONTA_REALIZADO	=	[dbo].[fBusca_Custo_Processo](BROKER_REFERENCE,'%CHB%'),--'Soma de Taxa Siscomex, II, IPI, ICMS, PIS, Cofins',
					CRONOLOGIA					=	''

				from Temp_SapSUN TS
		
					join House_imp_Aer		HOU					with(nolock) on HOU.num_proc_HIA = BROKER_REFERENCE
					Join job_imp_aer		Job					with(nolock) on Hou.num_proc_hia=BROKER_REFERENCE
					join LLP_imp_Aer		LIM					with(nolock) on LIM.num_proc_LIA = BROKER_REFERENCE
					left join cia_Aerea		ARM					with(nolock) on ARM.cd_cia_Aer=JOB.cd_cia_Aer
					left join po_HIA			Invoice			with(nolock) on Invoice.num_proc_HIA = BROKER_REFERENCE and Invoice.id_dc = 2 
					left join campo_processo	Venc			with(nolock) on Venc.num_proc = BROKER_REFERENCE and Venc.id_campo = 29
					left join po_HIA			Pag				with(nolock) on Pag.num_proc_HIA = BROKER_REFERENCE and PAg.id_dc = 15 
					left join campo_processo	Ent				with(nolock) on Ent.num_proc = BROKER_REFERENCE and Ent.id_campo = 2
					left join terminal			TEnt			with(nolock) on Tent.cd_terminal = Ent.campo_dados
					left join terminal			Lib				with(nolock) on	Lib.cd_terminal = LIM.cd_terminal
					left join tarefas_processos	SolNum			with(nolock) on SolNum.num_proc = BROKER_REFERENCE and SolNum.id_task = 59
					left join po_HIA			DI				with(nolock) on DI.num_proc_HIA = BROKER_REFERENCE and DI.id_dc = 5 
					left join tarefas_processos	DIL				with(nolock) on DIL.num_proc = BROKER_REFERENCE and DIL.id_task = 4
					left join tarefas_processos	DNF				with(nolock) on DNF.num_proc = BROKER_REFERENCE and DNF.id_task = 67
					left join po_HIA			NF				with(nolock) on NF.num_proc_HIA = BROKER_REFERENCE and NF.id_dc = 10
					left join tarefas_processos	DOC				with(nolock) on DOC.num_proc = BROKER_REFERENCE and DOC.id_task = 7
					left join tarefas_processos	Planta			with(nolock) on Planta.num_proc = BROKER_REFERENCE and Planta.id_task = 13
					left join tarefas_processos	Prest			with(nolock) on Prest.num_proc = BROKER_REFERENCE and Prest.id_task = 40
					
		End

		Begin
			update Temp_SapSUN
				SEt 
					[quantidade]=PS.qty,
					[material]=Produto_Descr
			From 
				Temp_SapSUN TS
				Join Pedido_Ship PS on pS.num_proc=BROKER_REFERENCE
				Join Produto_Cliente PC on cd_produto=cd_prod and cd_Proc_Cliente=[Material_Number]

		End
	END			
--
--	IF @@ERROR<>0 
--		BEGIN
--			ROLLBACK TRANSACTION
--			RETURN -1
--		END
COMMIT TRANSACTION




GO
