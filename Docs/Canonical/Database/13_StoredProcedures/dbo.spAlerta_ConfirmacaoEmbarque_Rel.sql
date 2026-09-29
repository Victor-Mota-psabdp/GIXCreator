SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spAlerta_ConfirmacaoEmbarque_Rel]

AS

SET LANGUAGE Brazilian

	select 
		HOU.num_proc_hem		[JOB],
		--qdo eh exw só precisa q envie o hbl	
		(case when isnull(HOU.cd_tp_oper,'') = 'EXW' then
			'20'
		else
			'20;66' end)		[Doc_Anexos],
		--'20;66'				[Doc_Anexos],		
		''						[JOB_Master],
		''						[Doc_Anexos_Master],
		'BDP - Confirmação de Embarque - ' + isnull(JOB.nr_reserva,'') [Assunto],
		(case when isnull(HOU.cd_tp_oper,'') <> 'EXW' then 
			'BDP International' + '|' +
--			'Santos, '   + DATENAME(day, LLP.atd_lem) + ' de ' + DATENAME(month, LLP.atd_lem)   + ' de ' + DATENAME(year, LLP.atd_lem) + '||' +
			'Santos, '   + DATENAME(day, HSGDATA) + ' de ' + DATENAME(month, HSGDATA)   + ' de ' + DATENAME(year, HSGDATA) + '||' +
			'*** FAVOR CONFIRMAR O RECEBIMENTO ***' + '||' +  
			'Confirmação de Embarque: ' + '||' + 
			'Booking Nr.: ' + isnull(JOB.nr_reserva,'') + '|' + 
			'Bill of Lading: ' + isnull(HOU.HAWB_HEM,'') + '|' + 
			'Cliente: ' + SHP.nome_raz_soc + '|' +
			'Consignee: ' + CON.nome_raz_soc + '|' +
			'Navio: ' + isnull(HOU.Navio_hem,'') + '|' +
			'Viagem: ' + isnull(HOU.Viagem_hem,'') + '|' +
			'Destino: ' + DES.nome_local + '|' +		
			'Transit-time: ' + (case when HOU.TTime_D is null then '' else convert(varchar,HOU.TTime_D) + ' days' end) + '|' +
			'Saída: ' + isnull(convert(varchar,LLP.ATD_LEM,103),'') + '|' +
			'Quantidade: ' + isnull(convert(varchar,convert(int,qtd_tot_vol_hem)),'') + ' KG' + '|' +
			'Peso: ' + isnull(convert(varchar,HOU.Peso_bruto_hem),'') + ' CBM' +'|' +
			'Cubagem: ' + isnull(convert(varchar,convert(decimal(12,2),vol_tot_hem)),'') + '|' + 
			isnull([dbo].[fBusca_Containers_Lacre_Tara](HOU.Num_Proc_HEM),'') + '||' +
			'Valores a serem pagos na fatura em anexo' + '||' +
	--		'Informar os valores a serem pagos conforme o cadastro dos mesmos no c/c do job	' + '||' +
			'Pagamento no Balcão: das 10:00 hs às 11:30 hs e das 14:00 hs às 15:30 hs ' + '||' +
			'Pagamento poderá ser efetuado através de depósito em conta, e mediante apresentação de comprovante para retirada de B/L até às 15:30 hs. ' + '||' +
			'EMAIL PARA ENVIO DO COMPROVANTE: thatiane.araujo@bdpint.com;valmirene.benegas@bdpint.com;israel.gois@bdpint.com' + '||' +
			'Taxa do dólar, favor consultar a taxa do dia para pagamento. ' + '||' +
			'**** INFORMAÇÃO IMPORTANTE **** ' + '||' +
			'Notem que para destinos com transit times curtos, é de extrema importância que o pagamento do frete e/ou taxas de origem sejam quitados logo após a saída do navio para evitar demoras e penalidades no destino devido a não apresentação dos documentos originais na Aduana local, tanto de master b/l do armador como house.' + '||' +
			'Para embarques FCL, vale lembrar que a demora no pagamento do house b/l gera o não pagamento do master, consequentemente qualquer problema e custos pela não apresentação dos documentos originais no destino, serão de responsabilidade do exportador.' + '||' +
			'ACEITAMOS PAGAMENTO APÓS ATRACAÇÃO DO NAVIO somente através de DOC ou DEPÓSITO EM CONTA CORRENTE.' + '||' + 
			'Favorecido: BDP SOUTH AMERICA LTDA' + '|' +
			'Banco: Itaú - Agência: 2000 - Berrini - C/C: 32499-2' + '|' +
			'cnpj: 03.706.460/0001-28' + '|' 
		Else
			'BDP International' + '|' +
			'Santos, '   + DATENAME(day, LLP.atd_lem) + ' de ' + DATENAME(month, LLP.atd_lem)   + ' de ' + DATENAME(year, LLP.atd_lem) + '||' +
			'*** FAVOR CONFIRMAR O RECEBIMENTO ***' + '||' +  
			'Confirmação de Embarque: ' + '||' + 
			'Booking Nr.: ' + isnull(JOB.nr_reserva,'') + '|' + 
			'Bill of Lading: ' + isnull(HOU.HAWB_HEM,'') + '|' + 
			'Cliente: ' + SHP.nome_raz_soc + '|' +
			'Consignee: ' + CON.nome_raz_soc + '|' +
			'Navio: ' + isnull(HOU.Navio_hem,'') + '|' +
			'Viagem: ' + isnull(HOU.Viagem_hem,'') + '|' +
			'Destino: ' + DES.nome_local + '|' +		
			'Transit-time: ' + (case when HOU.TTime_D is null then '' else convert(varchar,HOU.TTime_D) + ' days' end) + '|' +
			'Saída: ' + isnull(convert(varchar,LLP.ATD_LEM,103),'') + '|' +
			'Quantidade: ' + isnull(convert(varchar,convert(int,qtd_tot_vol_hem)),'') + '|' +
			'Peso: ' + isnull(convert(varchar,HOU.Peso_bruto_hem),'') + '|' +
			'Cubagem: ' + isnull(convert(varchar,convert(decimal(12,2),vol_tot_hem)),'') + '|' + 
			isnull([dbo].[fBusca_Containers_Lacre_Tara](HOU.Num_Proc_HEM),'') + '||' end) [MSG],
		isnull(T134.dt_previsao	,getdate())										[Previsao],
		[dbo].[fBusca_Emal_Comunicacao](HOU.cd_export_hem,'EM%')	[Emails],
		SHP.Apelido											[Cliente],
		''													[ResponderPara],
		(case when HOU.cd_tp_oper = 'EXW' then
			'| 020 - Doc. Embarque'
		else
			'| 020 - Doc. Embarque | 066 - BDP Invoice' 
		end)												[Nome_Doc_Anexos],
		''													[Nome_Doc_Anexos_Master]
	from house_exp_mar HOU with(nolock)
		join LLP_Exp_MAR LLP with(nolock) on LLP.Num_Proc_LEM = HOU.Num_Proc_HEM
		join JOB_Exp_MAR JOB with(nolock) on JOB.Num_Proc_HEM = HOU.Num_Proc_HEM
		join pessoa SHP	with(nolock) on SHP.cd_pes = HOU.cd_export_hem
		join pessoa CON	with(nolock) on CON.cd_pes = HOU.cd_consig_hem
		join Localidade Des	with(nolock) on DES.cd_local = HOU.cd_dst_HEM	
		join doc_anexos D20 with(nolock) on D20.num_proc = HOU.num_proc_hem and D20.id_dc = 20
		left join doc_anexos D66 with(nolock) on D66.num_proc = HOU.num_proc_hem and D66.id_dc = 66
		left join Alerta_Email_Doc_Historico AEH with(nolock) on AEH.Id_Alerta_Email = 3 and AEH.Num_Proc = HOU.Num_Proc_HEM	
		left join tarefas_processos T134	with(nolock)	on T134.num_proc = HOU.Num_Proc_HEM and T134.id_task = 134
		Left Join Hist_Geral HST with(nolock) on HST.hsgprocesso=num_proc_lem and cd_tp_ocor=-2
	where
		--hou.num_proc_hem in ('EMGAT201701001BR ') and		
		HSGDATA >=GETDATE()-10
		and	LLP.ATD_Lem is not null  
		and AEH.Num_Proc IS NULL
		and (HOU.num_proc_mem <> 'JOB' and substring(HOU.num_proc_mem,1,5) <> 'EMCLI')
		and T134.Dt_Conclusao is not null

GO
