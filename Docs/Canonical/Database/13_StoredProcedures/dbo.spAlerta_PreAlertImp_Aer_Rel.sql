SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spAlerta_PreAlertImp_Aer_Rel]

AS	

SET LANGUAGE Brazilian
 
  
select distinct 
	HOU.num_proc_hia							[JOB],
	Null										[JOB_Master],	
	(case when D2.dt_creacao is null and D11.dt_creacao is null then
		'20'
	else
		(case when D2.dt_creacao is not null and D11.dt_creacao is null then		
			'20;2'
		else
			(case when D2.dt_creacao is  null and D11.dt_creacao is not null then		
				'20;11'
			else
				'20;11;2'end)
								end)
										end)		[Doc_Anexos],	
	Null										[Doc_Anexos_Master],
	'Pre Aviso de Importação: ' + CS.Nome_Raz_Soc + ' - HAWB:' + isnull(HOU.HAWB_HIA,'') + ' - Job: ' + HOU.Num_Proc_HIA [Assunto],
		
		'BDP INTERNATIONAL ' + '||' +
		DST.nome_local + ', ' + DATENAME(day, HSGDATA) + ' de ' + DATENAME(month, HSGDATA)   + ' de ' + DATENAME(year, HSGDATA) + '||' +
		'*** FAVOR CONFIRMAR O RECEBIMENTO ***' + '||' +  
		'TO: ' + CS.Nome_Raz_Soc + '||'  +
		'Prezados(as) Senhores(as),' + '||' +
		'Obrigado por escolher a BDP International. Em caso de dúvidas, por favor responder para br.sao.airoperations@bdpint.com.' + '||' +
		'ATENÇÃO: Documentação do embarque anexa, em caso de correções por favor responder no prazo de 2 horas após recebimento desta notificação. ' + '||' +	
		'Especial atenção para os itens abaixo:'+ '||' +  
		'Consignatário (CNPJ e endereço), peso bruto, quantidade de volumes, Incoterm, descrição e NCM (se aplicável), valores de frete, Refrigeração (se necessário, informar temperatura), remoção (se aplicável TC4).'+ '||' +  
		'Lembramos que todas as informações do AWB serão manifestadas no SISCOMEX / MANTRA e que em caso de alteração/correção, estão sujeitos a custos adicionais e longos prazos de correção dos orgãos competentes, alheios a ação/intervenção do Agente de Cargas.'+ '||' +
		'Ref. BDP: ' + HOU.num_proc_hia + '|' + 
		'PO Number: ' + isnull(dbo.fbusca_docs_po_modal(HOU.num_proc_hia,1),'') + '|' +
		'Companhia Aérea: ' + isnull(CIA.Nome_Cia_Aer,'') + '|' +
		'Peso Liquido: ' + isnull(convert(varchar,convert(decimal(18,2),HOU.Peso_Real_HIA )),'') + ' Kgs' +'|' +
		'Peso Bruto: ' + isnull(convert(varchar,convert(decimal(12,3),HOU.Peso_bruto_hia)),'') + ' Kgs' +'|' +
		'Peso Taxado: ' + isnull(convert(varchar,convert(decimal(18,2),LLP.Peso_Cubado_LIA )),'') + ' M³' +'|' +
		'Cubagem: ' + isnull(convert(varchar,convert(decimal(12,2),vol_tot_hia)),'') + ' M³' +'|' +
		'ETD: ' + isnull(convert(varchar,LLP.ETD_LIA,103),'') + '|' +
		'ETA: ' + isnull(convert(varchar,LLP.ETA_LIA,103),'') + '|' +
		'H B/L Nº.:' + isnull(HOU.HAWB_HIA,'') + '|' +
		'M B/L Nº.:' + isnull(HOU.MAWB_HIA,'') + '|' +
		'Incoterm:'+ isnull(TR.Nome_Tp_Oper,'') + '|' +
		'Data H B/L: ' + isnull(convert(varchar,LLP.ETD_LIA,103),'') + '|' +
		'Shipper: ' + SHP.nome_raz_soc + '|' +
		'Origem: ' + ORG.nome_local + '|' +
		'Consignee: ' + CS.nome_raz_soc + '|' +
		'Notify: ' + NTY.Nome_Raz_Soc+ '|' +	
		'Destino: ' + DST.nome_local + '|' +
		'Final Destination: ' + FIM.nome_local + '|' + 
		'Mercadoria: ' + isnull([dbo].[FRemoveCaracteresEspeciais](NG.Descr),'') + '|' +
		'Valor Frete: ' + isnull(convert(varchar,convert(decimal(12,2),HOU.Vlr_Frete_Efet_HIA)),'') + '|' +
		'Codigo Moeda: ' + isnull(HOU.Cd_Tp_Moeda,'') + '|' +
		'Tipo de Frete: ' + HOU.Tp_Frete_HIA + '|' +
		'ATENCIOSAMENTE ' + '||' + US.Nome_Usuario + '|' + '|' + US.Email+ '|'+ '|' + US.Fone + '|'
		[MSG],
	
	NULL														[Previsao],
	[dbo].[fBusca_Emal_Comunicacao](HOU.cd_consig_hia,'IA%')	[Emails],
	CS.Apelido													[Cliente],
	''															[ResponderPara],
		
	(case when D2.dt_creacao is null and D11.dt_creacao is null then
		'| 020 - Doc. Embarque'
	else
		(case when D2.dt_creacao is not null and D11.dt_creacao is null then		
		'| 020 - Doc. Embarque| 002 - INVOICE'
	else
		(case when D2.dt_creacao is  null and D11.dt_creacao is not null then		
		'| 020 - Doc. Embarque| 011 - Packing List'
	else
		'| 020 - Doc. Embarque| 011 - Packing List| 002 - INVOICE' 
	end)end)end)												[Nome_Doc_Anexos],
	Null														[Nome_Doc_Anexos_Master]
										
	from 
		House_Imp_Aer		HOU with(nolock)
		Join LLP_Imp_Aer   LLP		with(nolock) on HOU.Num_Proc_HIA	=	LLP.Num_Proc_LIA
		join Job_Imp_Aer	JOB		with(nolock) on JOB.Num_Proc_HIA	=	HOU.Num_Proc_HIA
		join Usuario		US		with(nolock) on US.cd_usuario		=	JOB.cd_usuario
		left join Nature_Goods NG	with(nolock) on NG.num_proc			=	HOU.Num_Proc_HIA
		left Join Tipo_Oper TR      with(nolock) on hou.cd_tp_oper		=   TR.cd_Tp_Oper
		Join Pessoa			CS		with(nolock) on HOU.cd_consig_hia	=	CS.cd_pes
		Join Pessoa			NTY		With(Nolock) on HOU.Cd_Import_HIA	=	NTY.Cd_Pes
		join pessoa			SHP		with(nolock) on SHP.cd_pes			=	HOU.cd_export_hia
		join Localidade		ORG		with(nolock) on ORG.cd_local		=	HOU.cd_org_HIA
		join Localidade		DST		with(nolock) on DST.cd_local		=	HOU.cd_dst_HIA
		join Localidade		FIM		with(nolock) on FIM.cd_local		=	LLP.cd_dstFinal_LIA
		Left Join Cia_Aerea CIA		with(nolock) on JOB.Cd_Cia_Aer		=	CIA.Cd_Cia_Aer
		join doc_anexos		D20		with(nolock) on D20.num_proc = HOU.num_proc_hia and D20.id_dc = 20
		left join doc_anexos D2		with(nolock) on D2.num_proc = HOU.num_proc_hia and D2.id_dc = 2
		left join doc_anexos D11	with(nolock) on D11.num_proc = HOU.num_proc_hia and D11.id_dc = 11
		left join Alerta_Email_Doc_Historico AEH with(nolock) on AEH.Id_Alerta_Email = 7 and AEH.Num_Proc = HOU.Num_Proc_HIA
		Left Join Hist_Geral HST with(nolock) on HST.hsgprocesso=HOU.Num_proc_hia and cd_tp_ocor=44 and HSDDescricao like 'Pre-Alert Sending%'		
	where
		--hou.Num_Proc_HIA = 'IAATL201405001BR'		
		HSGDATA >= GETDATE()- 5	 
		and AEH.Num_Proc IS NULL
		and (HOU.num_proc_mia <> 'JOB' and substring(HOU.num_proc_mia,1,5) <> 'IACLI')
GO
