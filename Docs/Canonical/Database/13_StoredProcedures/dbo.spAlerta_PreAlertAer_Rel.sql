SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spAlerta_PreAlertAer_Rel]

AS	

SET LANGUAGE Brazilian
 
  
select distinct 
	HOU.num_proc_hia							[JOB],
	Null										[JOB_Master],	
	(case when D2.dt_creacao is null and D11.dt_creacao is null then
		'20;101;66;151'
	else
		(case when D2.dt_creacao is not null and D11.dt_creacao is null then		
			'20;101;66;151;2'
		else
			(case when D2.dt_creacao is  null and D11.dt_creacao is not null then		
				'20;101;66;151;11'
			else
					'20;11;2;101;66;151'
										end)
											end)
												end)	[Doc_Anexos],	
	Null												[Doc_Anexos_Master],
	'Aviso de chegada + Valores: ' + CS.Nome_Raz_Soc + ' - HAWB:' + isnull(HOU.HAWB_HIA,'') + ' - Job: ' + HOU.Num_Proc_HIA [Assunto],
		
		'BDP INTERNATIONAL ' + '||' +
		'H B/L Nº.:' + isnull(HOU.HAWB_HIA,'') + '|' +
		'M B/L Nº.:' + isnull(HOU.MAWB_HIA,'') + '||' +
		DST.nome_local + ', ' + DATENAME(day, HSGDATA) + ' de ' + DATENAME(month, HSGDATA)   + ' de ' + DATENAME(year, HSGDATA) + '||' +		
		'*** FAVOR CONFIRMAR O RECEBIMENTO ***' + '||' +  
		'TO: ' + CS.Nome_Raz_Soc + '||'  +
		'Prezados(as) Senhores(as),' + '||' +
		'Gostaríamos de notificar a chegada de vossa carga coberta pelo conhecimento aéreo (HAWB) em referência. ' + '||' +
		'Gentileza notar anexo:' + '||' +	
		'- Documentação do embarque;'+ '|' +
		'- Tela do mantra;'+ '|' +
		'- Nota de débito com valores para liberação do HAWB;'+ '|' + 
		'- Boleto para pagamento'+ '||' +    
		'Pedimos que o comprovante de pagamento seja encaminhado assim que a Nota de Débito for liquidada para devida baixa e envio posterior do recibo, bem como liberação da documentação original disponível no aeroporto. '+ '||' +  
		'Segue abaixo contato para retirada no aeroporto:'+ '||' +	
		
		(Case when DST.Nome_Local = 'Guarulhos' then
			'Luciana Fessori (011) 99871-9903'+'|'+
			'Denílson Fessori (011) 95045-5657'+'|'+
			'TECA - 4º andar - sala 4.18'+'|'
			
			--Segue abaixo contato para retirada no aeroporto:

			--Luciana Fessori - Nextel 1*15217 / (11) 7807-9247
			--Denilson Fessori – Nextel 1*13740 / (11) 7830-7697
			--Local de retirada dos documentos: ESPAÇO DOS DESPACHANTES - ARMAZÉM DE EXPORTAÇÃO
			
			--100-151944
			--Deve ser:
			--Luciana Fessori (011) 99871-9903
			--Denílson Fessori (011) 95045-5657
			--TECA - 4º andar - sala 4.18
			
		else					
			(case when DST.Nome_Local = 'Manaus' then
				'AMAZONCARGO' +'|'+
				'Rua Franco de Sá, nº 270 – térreo – Sala 01 e 02' +'|'+  
				'Ed. Amazon Trade Center, Bairro São Francisco' +'|'+ 
				'CEP 69079-210 – Manaus – Amazonas – Brasil'  +'|'+
				'E-mail: import.air@amazoncargo.com.br'  +'|'+
				'Telefone: (92) 3612-0178'+'|'
			else			
				(case when DST.Nome_Local = 'Viracopos' then
				   --'Maria Auxiliadora Alves / Simone Braz'+'|'+
				   --'BDP INTERNATIONAL - BRASIL'+'|'+
				   --'Rod. Santos Dumont, KM 66 - Jardim Itatinga'+'|'+
				   --'Centro Empresarial Viracopos Bloco C 3º andar Sala 330 '+'|'+
				   --'CEP.: 13052-901 Campinas -SP.' +'|'+
				   --'E-mail: maria.auxiliadora@bdpint.com' +'|'+
				   --'E-mail: simone.braz@bdpint.com' +'|'+
				   --'Telefone: + 55 (19) 3725 6352' +'|'+
				   --'Nextel 1*17984 ' +'|'
					'ALV Serviços - Centro Empresarial Viracopos - Bloco C, 3° Andar, Sala 354.'+'|'+
					'Rod. Santos Dumont, KM 66 - Jardim Itatinga – Cep. 13052-901 - Campinas - SP – Brasil'+'||'+
					'Abner Armando'+'|'+
					'Celular: (19) 97423 6237'+'|'+
					'E-mail: abnerandradea@yahoo.com.br'+'||'+
					'Lucimara A. Armando'+'|'+
					'Celular: (19) 99343 1066'+'|'+
					'E-mail: lucimaraandradea@yahoo.com.br' +'|'
				else					
					(case when DST.Nome_Local = 'Recife' then
						--'Karen Schuepp' +'|'+
						--'BDP INTERNATIONAL – Brasil' +'|'+
						--'Rua Ernesto de Paula Santos, nº 960 - 3º andar, sala 301'+'|'+
						--'Boa Viagem, Recife/ PE - CEP: 51021-330' +'|'+
						--'Email: karen.schuepp@bdpint.com' +'|'+
						--'Ph: +55 81 3036-2912 / 2919'+'|'						
						'Ozéas Júnior'+'|'+
						'Elo Comércio Exterior Ltda'+'|'+
						'Empresarial Green Tower'+'|'+
						'Rua Demócrito de Souza Filho, 335 – Sl. 105-106'+'|'+
						'Madalena – Recife/PE - CEP: 50.610-120'+'|'+
						'Fone: (81) 3125-4005'+'|'
					else								
						--(case when DST.Nome_Local = 'Rio de Janeiro' then
						--	'Robson Gomes / Ronaldo Figueiredo / Gualberto Milward' +'||'+
						--	'SKY LOGISTICA' +'|'+
						--	'Rua Visconde de Inhaúma, 58 -  Sala 401' +'|'+
						--	'Cep: 20.091-007 – Centro - Rio de Janeiro - Brasil' +'|'+
						--	'Telefone: (21) 3147-8800 / 8802 / 8816' +'|'+
						--	'E-mail: robson@skylog.com.br' +'|'+
						--	'E-mail: ronaldo@skylog.com.br' +'|'+
						--	'E-mail: gmc@skylog.com.br' +'|'
						(case when DST.Nome_Local = 'Rio de Janeiro' then
							'Patricia Mentzingen' +'||'+
							'SKY LOGISTICA' +'|'+
							'Rua Visconde de Inhaúma, 58 -  Sala 712' +'|'+
							'Cep: 20.091-007 – Centro - Rio de Janeiro - Brasil' +'|'+
							'Telefone: (21) 3553-1310 / 1319' +'|'+
							'E-mail: patricia@skylog.com.br' +'|'							
						else
							(case when DST.Nome_Local = 'Salvador' then
								--'Enayde Santos / Andresa Sá / Vanessa Barreto / Tatiana Aschenberger' +'|'+
								--'Ability Serviços de Comércio Exterior Ltda' +'|'+
								--'Telefone:  (71) 2104-0425 / 0440' +'|'+
								--'E-mail: enayde@abilitycom.com.br' +'|'+
								--'E-mail: andresa@abilitycom.com.br' +'|'+
								--'E-mail: vanessa@abilitycom.com.br' +'|'+
								--'E-mail: tatiana@abilitycom.com.br' +'|'								
								'OMEGA' +'||'+
								'Telefone: (71) 2101-1072/2101-1068' +'|'+
								'E-mail: valeria.requiao@omegaservicos.com.br' +'|'+
								'E-mail: elesson.bastos@omegaservicos.com.br' +'||'+
								'Av. Estados Unidos 137 – 9º andar – Ed Cidade de Ilhéus' +'|'
								--OMEGA

								--Telefone: (71) 2101-1072/2101-1068
								--E-mail: valeria.requiao@omegaservicos.com.br
								--E-mail: elesson.bastos@omegaservicos.com.br

								--Av. Estados Unidos 137 – 9º andar – Ed Cidade de Ilhéus
								
							else
								(case when DST.Nome_Local = 'Belo Horizonte' or DST.Nome_Local = 'Confins' then
									'Divina Sousa' +'|'+
									'Mega Express Logística Aduaneira'  +'|'+
									'Aeroporto Internacional Tancredo Neves' +'|'+
									'Rodovia LMG-800 KM-9  Terminal de cargas Sala 24' +'|'+
									'CEP-33.500.000' +'|'+
									'Nextel: 55*925*8519' +'|'+
									'Tel.:	(31) 9710-7540 (VIVO)' +'|'+
									'		(31) 9465-0111 (TIM)' +'|'+
									'E-mail: mdivinabs@gmail.com'+'|'
							else																																
								--(case when DST.Nome_Local = 'Navegantes' or DST.Nome_Local = 'Curitiba' or DSt.Nome_Local = 'Porto Alegre' or DST.Nome_Local = 'Itajaí' then
								--	'Eduarda Sacramento / Aline Bonetti' +'|'+ 
								--	'BDP INTERNATIONAL' +'|'+
								--	'Av. Carlos Gomes 75 - Sala 303 - Bairro Auxiliadora' +'|'+
								--	'Porto Alegre, RS, Brasil, Cep 90480-000' +'|'+
								--	'email: eduarda.sacramento@bdpint.com' +'|'+
								--	'email: aline.bonetti@bdpint.com '+'|'+
								--	'Telefone: + 55 51 3026-0104'+'|'	
								--else
								
								(case when DST.Nome_Local = 'Navegantes' or DST.Nome_Local = 'Itajaí' then
									--'Comissária Pibernat' +'|'+ 
									--'Rua: Gil Stein Ferreira 357- sala 207' +'|'+
									--'Centro de Itajaí / SC ' +'|'+
									--'Cep: 88301-210' +'|'+
									--'Contato: Flaviane Maciel' +'|'+
									--'Telefone: 55 (47) 3248 8115'+'|'										
									--100-153474
									'COMISSÁRIA PIBERNAT LTDA - UNIDADE ITAJAÍ/SC - BRASIL' +'|'+ 
									'RUA: MANOEL VIEIRA GARÇÃO Nº 120 9º ANDAR - SALA 901 - EDIFÍCIO - ZEN TOWER - CEP 88301-425 - CENTRO - ITAJAÍ/SC'+'|'+ 
									'A/C ( Flaviane Maciel  / Alessandro Oliveira  )'+'|'+ 
									'TEL: 55 (47) 3248-8115'+'|'
									
								else																																	
									(case when DST.Nome_Local = 'Curitiba' then
										'Av. Rocha Pombo - Águas Belas, nº 3605' +'|'+ 
										'São José dos Pinhais - PR, 83010-900' +'|'+
										'Telefone: 55 (41) 3283-7637'+'|'											
									else																																	
										(case when DST.Nome_Local = 'Porto Alegre' then
											'Comissária Pibernat Ltda' +'|'+ 
											'Rua Domingos Martins, 121/1005' +'|'+
											'Centro - Canoas' +'|'+
											'Telefone: 55 (51) 3302-3322'+'|'
																										
													end)end)end)end)end)end)end)end)end)end) + '|'														
	[MSG],	
	NULL														[Previsao],
	[dbo].[fBusca_Emal_Comunicacao](HOU.cd_consig_hia,'IA%')	[Emails],
	CS.Apelido													[Cliente],
	''															[ResponderPara],	
	
	(case when D2.dt_creacao is null and D11.dt_creacao is null then
		'| 020 - Doc. Embarque| 101 - TELA MANTRA| 066 - BDP Invoice|151 - Boleto'
	else
		(case when D2.dt_creacao is not null and D11.dt_creacao is null then		
			'| 020 - Doc. Embarque| 101 - TELA MANTRA| 066 - BDP Invoice|151 - Boleto| 002 - INVOICE'
	else
		(case when D2.dt_creacao is  null and D11.dt_creacao is not null then		
			'| 020 - Doc. Embarque| 101 - TELA MANTRA| 066 - BDP Invoice|151 - Boleto| 011 - Packing List'
	else
			'| 020 - Doc. Embarque| 011 - Packing List| 002 - INVOICE| 101 - TELA MANTRA| 066 - BDP Invoice|151 - Boleto'
	end)end)end)												[Nome_Doc_Anexos],
	Null														[Nome_Doc_Anexos_Master]
											
	from 
		 House_Imp_Aer			HOU		with(nolock)
		Join LLP_Imp_Aer		LLP		with(nolock) on HOU.Num_Proc_HIA	=	LLP.Num_Proc_LIA
		join Job_Imp_Aer		JOB		with(nolock) on JOB.Num_Proc_HIA	=	HOU.Num_Proc_HIA
		join Usuario			US		with(nolock) on US.cd_usuario		=	JOB.cd_usuario
		Join Pessoa				CS		with(nolock) on HOU.cd_consig_hia	=	CS.cd_pes
		Join Pessoa				NTY		With(Nolock) on HOU.Cd_Import_HIA	=	NTY.Cd_Pes
		join pessoa				SHP		with(nolock) on SHP.cd_pes			=	HOU.cd_export_hia
		join Localidade			ORG		with(nolock) on ORG.cd_local		=	HOU.cd_org_HIA
		join Localidade			DST		with(nolock) on DST.cd_local		=	HOU.cd_dst_HIA
		join Localidade			FIM		with(nolock) on FIM.cd_local		=	LLP.cd_dstFinal_LIA
		join doc_anexos			D20		with(nolock) on D20.num_proc		=	HOU.num_proc_hia and D20.id_dc = 20
		left join doc_anexos	D2		with(nolock) on D2.num_proc			=	HOU.num_proc_hia and D2.id_dc = 2
		left join doc_anexos	D11		with(nolock) on D11.num_proc		=	HOU.num_proc_hia and D11.id_dc = 11
		join Doc_Anexos			D101	with(nolock) on D101.Num_Proc		=	HOU.Num_Proc_hia and D101.Id_DC = 101
		join Doc_Anexos			D66		with(nolock) on D66.Num_Proc		=	HOU.Num_Proc_HIA and D66.Id_DC = 66
		join Doc_Anexos			D151	with(nolock) on D151.Num_Proc		=	Hou.Num_Proc_HIA and D151.Id_DC = 151
		left join Alerta_Email_Doc_Historico AEH with(nolock) on AEH.Id_Alerta_Email = 8 and AEH.Num_Proc = HOU.Num_Proc_HIA
		Left Join Hist_Geral HST with(nolock) on HST.hsgprocesso=HOU.Num_proc_hia and cd_tp_ocor=-4 --and HSDDescricao like 'Pre-Alert Sending%'		
	where
		--hou.Num_Proc_HIA = 'IASTE201603003BR'		
		HSGDATA >= GETDATE() -10
		and AEH.Num_Proc IS NULL
		and (HOU.num_proc_mia <> 'JOB' and substring(HOU.num_proc_mia,1,5) <> 'IACLI')
		
		--select * from Hist_Geral
		--where HSGProcesso = 'IASTE201603003BR'
		
		--select * from Alerta_Email_Doc_Historico
		--where Num_Proc = 'IASTE201603003BR'
		
		--update Alerta_Email_Doc_Historico set  dt_envio = NULL
		--where id_alerta_email in(8) and Num_Proc = 'IASTE201603003BR'
GO
