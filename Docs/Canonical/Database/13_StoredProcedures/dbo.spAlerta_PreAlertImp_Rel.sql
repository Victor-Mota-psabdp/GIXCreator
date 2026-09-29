SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spAlerta_EnvioReciboAereo_Rel
--spAlerta_ConfirmacaoEmbarque_Rel
--spAlerta_PreAlertExp_Rel
--spAlerta_PreAlertImp_Rel
--spAlerta_EnvioDocs_Cambio_Oxiteno

--select * from alerta_email_doc_historico where id_alerta_email = 4

CREATE Procedure [dbo].[spAlerta_PreAlertImp_Rel]

AS	

SET LANGUAGE Brazilian
 
select distinct 
	HOU.num_proc_him							[JOB],
	Null										[JOB_Master],
	(case when D177.dt_creacao is null then
		'20'
	else
		(case when D177.dt_creacao is not null then		
			'20;177'
			end)
				end)										[Doc_Anexos],	
	--'20'										[Doc_Anexos],	
	Null										[Doc_Anexos_Master],
	'Pre Aviso de Importação: ' + CS.Nome_Raz_Soc + ' - HBL:' + HOU.HAWB_HIM + ' - Navio ' + HOU.Navio_HIM + ' - ' + TC.Nome_Tp_Carga [Assunto],
	(case when TC.Nome_Tp_Carga = 'FCL' then
		
		'BDP INTERNATIONAL ' + '||' +
		DST.nome_local + ', ' + DATENAME(day, HSGDATA) + ' de ' + DATENAME(month, HSGDATA)   + ' de ' + DATENAME(year, HSGDATA) + '||' +
		'*** FAVOR CONFIRMAR O RECEBIMENTO ***' + '||' +  
		'TO: ' + CS.Nome_Raz_Soc + '||'  +
		'Prezados Senhores,' + '||' +
		'Agradecemos a contratação, e por meio desta informamos que o navio abaixo está trazendo carga consignada a sua empresa' + '||' +	
		--'ATENÇÃO: Em anexo HBL para fins de redestinação ' + '|' +	
		--'Para os casos de redestinação sob nossa responsabilidade, a BDP deve ser informada 72 horas úteis antes da chegada do navio através do email oceanoperations@bdp.com.br acerca do terminal utilizado para entrega dos documentos necessários para geração da presença de carga.' + '|' +	
		'ATENÇÃO: ' + '|' +	 
		'Anexos MBL + HBL para fins de redestinação ' + '|' +	
		'Gentileza redestinar para o vosso terminal e nos copiar (br.sao.oceanoperations@bdpint.com). A BDP deve ser informada 72 horas úteis antes da chegada do navio, caso não seja redestinado no prazo, os CNTR’s deste embarque ficarão no terminal parceiro BDP. Qualquer dúvida, favor contatar-nos.' + '|' +	
		'Ref. BDP: ' + HOU.num_proc_him + '|' + 
		'PO Number: ' + isnull(dbo.fbusca_docs_po_modal(HOU.num_proc_him,1),'') + '|' +
		'Navio: ' + isnull(HOU.Navio_him,'') + ' VG: ' + isnull(HOU.Viagem_him,'') + '|' +
		'Peso: ' + isnull(convert(varchar,convert(decimal(12,3),HOU.Peso_bruto_him)),'') + ' Kgs' +'|' +
		'Cubagem: ' + isnull(convert(varchar,convert(decimal(12,2),vol_tot_him)),'') + ' M3' +'|' +
		'ETA: ' + isnull(convert(varchar,LLP.ETA_LIM,103),'') + '|' +
		'Quantidade: ' + convert(varchar(10),dbo.qty_container(HOU.num_proc_him)) + ' Container(s) ' + '|' +
		'H B/L Nº.:' + isnull(HOU.HAWB_HIM,'') + '|' +
		'Data H B/L: ' + isnull(convert(varchar,LLP.ETD_LIM,103),'') + '|' +
		'Shipper: ' + SHP.nome_raz_soc + '|' +
		'Origem: ' + ORG.nome_local + '|' +
		'Consignee: ' + CS.nome_raz_soc + '|' +
		'Destino: ' + DST.nome_local + '|' +
		'Final Destination: ' + FIM.nome_local + '|' + 
		'Terminal: ' + isnull(TT.Nome_terminal,'') + '|' + 
		'Mercadoria: ' + isnull([dbo].[FRemoveCaracteresEspeciais](NG.Descr),'') + '|' +
		isnull(dbo.fBusca_Containers_Lacre_Tara (HOU.num_proc_him), 'Container:') + '|' +
		'Free Time Demurrage: ' + isnull([dbo].[fBusca_CampoCliente](HOU.num_proc_him,138),'') + ' dias' + '||' +
		'AVISO AOS IMPORTADORES E EXPORTADORES' + '||' +
		'Consulte o link abaixo para acesso ao nosso Termo de Demurrage: ' + '|' +
		'https://sites.google.com/a/bdpint.com/transportation_antaq/' + '||' +
		'Comunicamos que conforme Lei nº 12.546, de 14 de dezembro de 2011, em seus artigos 25 a 27, institui a obrigação de prestar ao MDIC, para fins econômico-comerciais, informações relativas às transações entre ' + 
		'residentes ou domiciliados no País e residentes ou domiciliados no exterior que compreendem serviços, intangíveis e outras operações que produzam variações no patrimônio das pessoas físicas, das pessoas ' + 
		'jurídicas ou dos entes despersonalizados; O SISCOSERV, assim denominado pelo MDIC, entra em vigor a partir do próximo dia 1º de abril de 2013 para os serviços de TRANSPORTE DE CARGA,sendo que, a' + 
		'obrigação do registro é de exclusiva responsabilidade dos Srs. IMPORTADORES E EXPORTADORES, conforme já é feito no Siscomex ' + '|||' +
		'Se houver necessidade de qualquer alteração no B/L, a solicitação deverá ser feita em até 24 horas do recebimento desta mensagem. Caso não tenhamos retorno dentro deste prazo, o documento será considerado aprovado. Ressaltamos que qualquer alteração está sujeita a repasse de eventuais taxas e multas do armador e Alfândega, além de atrasos na liberação da mercadoria.Para os casos de BL aprovado antes do embarque (draft), seguem-se os prazos informados no e-mail de envio de draft para aprovação.' + '||' +
		'ATENCIOSAMENTE ' + '||' + US.Nome_Usuario + '|'
	else		
		'BDP INTERNATIONAL ' + '||' +
		DST.nome_local + ', ' + DATENAME(day, HSGDATA) + ' de ' + DATENAME(month, HSGDATA)   + ' de ' + DATENAME(year, HSGDATA) + '||' +
		'*** FAVOR CONFIRMAR O RECEBIMENTO ***' + '||' +  
		'TO: ' + CS.Nome_Raz_Soc + '||'  +
		'Prezados Senhores,' + '||' +
		'Agradecemos a contratação, e por meio desta informamos que o navio abaixo está trazendo carga consolidada consignada a sua empresa' + '||' +			
		'Ref. BDP: ' + HOU.num_proc_him + '|' + 
		'PO Number: ' + isnull(dbo.fbusca_docs_po_modal(HOU.num_proc_him,1),'') + '|' +
		'Navio: ' + isnull(HOU.Navio_him,'') + ' VG: ' + isnull(HOU.Viagem_him,'') + '|' +
		'Peso: ' + isnull(convert(varchar,convert(decimal(12,3),HOU.Peso_bruto_him)),'') + ' Kgs' +'|' +
		'Cubagem: ' + isnull(convert(varchar,convert(decimal(12,2),vol_tot_him)),'') + ' M3' +'|' +
		'ETA: ' + isnull(convert(varchar,LLP.ETA_LIM,103),'') + '|' +
		'Quantidade: ' + isnull([dbo].[fBusca_Volumes_QtdTipo](HOU.num_proc_him),'') + '|' +
		'H B/L Nº.:' + isnull(HOU.HAWB_HIM,'') + '|' +
		'Data H B/L: ' + isnull(convert(varchar,LLP.ETD_LIM,103),'') + '|' +
		'Shipper: ' + SHP.nome_raz_soc + '|' +
		'Origem: ' + ORG.nome_local + '|' +
		'Consignee: ' + CS.nome_raz_soc + '|' +
		'Destino: ' + DST.nome_local + '|' +
		'Final Destination: ' + FIM.nome_local + '|' + 
		'Terminal: ' + isnull(TT.Nome_terminal,'') + '|' + 
		'Mercadoria: ' + isnull([dbo].[FRemoveCaracteresEspeciais](NG.Descr),'') + '|' +
		isnull(dbo.fBusca_Containers_Lacre_Tara (HOU.num_proc_him), 'Container:') + '||' +
		'AVISO AOS IMPORTADORES E EXPORTADORES' + '||' +
		'Consulte o link abaixo para acesso ao nosso Termo de Demurrage: ' + '|' +
		'https://sites.google.com/a/bdpint.com/transportation_antaq/' + '||' +
		'Comunicamos que conforme Lei nº 12.546, de 14 de dezembro de 2011, em seus artigos 25 a 27, institui a obrigação de prestar ao MDIC, para fins econômico-comerciais, informações relativas às transações entre ' + 
		'residentes ou domiciliados no País e residentes ou domiciliados no exterior que compreendem serviços, intangíveis e outras operações que produzam variações no patrimônio das pessoas físicas, das pessoas ' + 
		'jurídicas ou dos entes despersonalizados; O SISCOSERV, assim denominado pelo MDIC, entra em vigor a partir do próximo dia 1º de abril de 2013 para os serviços de TRANSPORTE DE CARGA,sendo que, a' + 
		'obrigação do registro é de exclusiva responsabilidade dos Srs. IMPORTADORES E EXPORTADORES, conforme já é feito no Siscomex ' + '|||' +		
		'Se houver necessidade de qualquer alteração no B/L, a solicitação deverá ser feita em até 24 horas do recebimento desta mensagem. Caso não tenhamos retorno dentro deste prazo, o documento será considerado aprovado. Ressaltamos que qualquer alteração está sujeita a repasse de eventuais taxas e multas do armador e Alfândega, além de atrasos na liberação da mercadoria.Para os casos de BL aprovado antes do embarque (draft), seguem-se os prazos informados no e-mail de envio de draft para aprovação.' + '||' +
		'ATENCIOSAMENTE ' + '||' + US.Nome_Usuario + '|'
		end) [MSG],
	
	NULL														[Previsao],
	[dbo].[fBusca_Emal_Comunicacao](HOU.cd_consig_him,'IM%')	[Emails],
	CS.Apelido													[Cliente],
	''															[ResponderPara],
	(case when D177.dt_creacao is null then
		'| 020 - Doc. Embarque'
	else
		(case when D177.dt_creacao is not null then		
		'| 020 - Doc. Embarque| 177 - MBL/MAWB sem frete'
		end)
			end)												[Nome_Doc_Anexos],
	--'|20 - Doc. Embarque'										[Nome_Doc_Anexos],
	Null														[Nome_Doc_Anexos_Master]													
from 
	House_Imp_Mar		HOU with(nolock)
	Join LLP_Imp_Mar    LLP		with(nolock) on HOU.Num_Proc_HIM	=	LLP.Num_Proc_LIM
	join JOB_IMP_MAR	JOB		with(nolock) on JOB.Num_Proc_HIM	=	HOU.Num_Proc_HIM
	join Usuario		US		with(nolock) on US.cd_usuario		=	JOB.cd_usuario
	left join Nature_Goods NG	with(nolock) on NG.num_proc			=	HOU.Num_Proc_HIM
	Join Pessoa			CS		with(nolock) on HOU.cd_consig_him	=	CS.cd_pes
	join pessoa			SHP		with(nolock) on SHP.cd_pes			=	HOU.cd_export_him
	Join Tipo_Carga		TC		with(nolock) on LLP.Cd_Tp_Carga		=	TC.Cd_Tp_Carga
	left Join Terminal	TT		with(nolock) on LLP.Cd_Terminal		=	TT.Cd_Terminal
	join Localidade		ORG		with(nolock) on ORG.cd_local		=	HOU.cd_org_HIM
	join Localidade		DST		with(nolock) on DST.cd_local		=	HOU.cd_dst_HIM
	join Localidade		FIM		with(nolock) on FIM.cd_local		=	LLP.cd_dstFinal_LIM
	join doc_anexos		D20 with(nolock) on D20.num_proc = HOU.num_proc_him and D20.id_dc = 20
	Left join doc_anexos D177		with(nolock) on D177.num_proc = HOU.num_proc_him and D177.id_dc = 177
	left join Alerta_Email_Doc_Historico AEH with(nolock) on AEH.Id_Alerta_Email = 5 and AEH.Num_Proc = HOU.Num_Proc_HIM
	Left Join Hist_Geral HST with(nolock) on HST.hsgprocesso=HOU.Num_proc_him and cd_tp_ocor=44 and HSDDescricao like 'Pre-Alert Sending%'		
where
	HSGDATA >= GETDATE()- 10	 
	and AEH.Num_Proc IS NULL
	and (HOU.num_proc_mim <> 'JOB' and substring(HOU.num_proc_mim,1,5) <> 'IMCLI')
			
			
			
		
GO
