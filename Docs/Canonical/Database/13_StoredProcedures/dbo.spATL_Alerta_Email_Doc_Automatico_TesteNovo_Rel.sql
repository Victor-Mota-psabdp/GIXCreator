SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Alerta_Email_Doc_Automatico_TesteNovo_Rel]

AS

select distinct 
		TP.Num_Proc						[JOB],
		A.Doc_Anexos					[Doc_Anexos],
		A.Doc_Anexos_Nao				[Doc_Anexos_Nao_Obrigatorios],
		[dbo].[fBusca_Alerta_Email_Doc_Automatico]('Assunto',TP.Num_Proc,A.ID,A.Cd_Pes_Grupo,A.cd_tp_carga,
									A.Cd_Org,A.Cd_Dst,A.cd_pes,A.modal,A.cd_tp_pedido,A.Cd_Transportadora, A.Cd_Terminal)  [Assunto],
		''								[Doc_Anexos_Master],
		A.CopyBDP						[CopyBDP],
		A.JuntaPDF						[JuntaPDF],
		Email_do_CompanyRegister		[Email_do_CompanyRegister],	
		(case when Email_do_CompanyRegister = 0 then '' 
		else
			[dbo].[fBusca_Emal_Comunicacao](LLp.cd_cliente,left(TP.Num_Proc,2) +'%') end)	[Company_Register],
		A.Emails						[Emails],		
		[dbo].[fBusca_Alerta_Email_Doc_Automatico]('Mensagem',TP.Num_Proc,A.ID,A.Cd_Pes_Grupo,A.cd_tp_carga,
								A.Cd_Org,A.Cd_Dst,A.cd_pes,A.modal,A.cd_tp_pedido,A.Cd_Transportadora, A.Cd_Terminal) + '||' [MSG],
		TP.Dt_Previsao					[Previsao],
		A.CD_Pes_Grupo					[CD_Pes_Grupo],
		A.Nome_Tp_Ocor					[Nome_Tp_Ocor],
		'N'								[Disponivel],
		A.ID							[ID],
		A.Nome_Task						[Nome_Task],
		A.ResponderPara					[ResponderPara],		
		null							[Mensagem_Referencia_cliente],				
		CS.Apelido						[Cliente],
		
		Email_do_Agente_Consolidado,
		(case when Email_do_Agente_Consolidado = 0 then '' 
		else
			[dbo].[fBusca_Emal_Comunicacao](LLp.cd_cliente_master,'AG%')
		end)[Company_Register_Master],		
		CLI.Apelido				[Cliente_Master],
		LLP.Master				[Master_JOB],		
		
		StandardForms,
		A.cd_tp_pedido
		,
		A.Cd_Pes_Grupo,
		A.cd_tp_carga,
		A.Cd_Org,
		A.Cd_Dst,
		A.cd_pes,
		A.modal,
		A.Cd_Transportadora,
		A.Cd_Terminal,
		--Para mensagem qdo nao enconta o cliente HOuse e do Master
		'Cliente: ' + CS.Apelido + ' sem emails cadastrados, JOB: ' + TP.Num_Proc [CorpoMSG],
		'Agente: ' + CLI.Apelido + ' sem emails cadastrados, JOB: ' + LLP.Master [CorpoMSGConsolidado],
		' - Não Enviado' [Assunto_CorpoMSG],		
		--Para mensagem qdo nao encontra os documentos
		'Arquivos não encontrados para serem anexados ao email, JOB: ' + TP.Num_Proc + 
			'|Favor verificar se existem os seguintes documentos estão no JOB: | ' 
			+ isnull([dbo].[fBusca_Alerta_Email_Doc_Automatico_Nome_Documento]
				(A.ID,A.Cd_Pes_Grupo,A.cd_tp_carga,A.Cd_Org,A.Cd_Dst,A.cd_pes,A.modal,A.cd_tp_pedido,A.Cd_Transportadora, A.Cd_Terminal),'')
			[CorpoMSG_Doc_Anexos],		
		' - Falha no envio - Sem arquivos anexados' [Assunto_CorpoMSG_Doc_Anexos]
		
		--,LLP.Cd_Transportadora [teste]
		,CopyEmail,Zip,A.Id_Alerta Id_Alerta
from Tarefas_Processos_Alerta	TP with(nolock)
	Join vwCliente_Alerta	LLP  with (nolock)on TP.Num_Proc = LLP.num_proc	
	join pessoa				CS  with(nolock) on CS.Cd_Pes = LLP.cd_cliente
	join Pessoa_LLP			PLL with(nolock) on PLL.Cd_Pes=LLP.cd_cliente	
	Join Usuario			US	with (nolock) on US.cd_usuario=LLP.cd_usuario	
	Join Localidade			Org	with (nolock) on Org.cd_local=LLP.Cd_Org
	Join Localidade			Dst	with (nolock) on DST.cd_local=LLP.Cd_Dst
	join Alerta_Email_Doc_Automatico A with(nolock) on A.ID_Task = TP.ID_Task and A.Modal = LEFT(TP.Num_Proc,2)
	left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on H.ID = A.ID and H.Num_Proc = Tp.Num_Proc
	--H.Id_Alerta = A.Id_Alerta and H.ID = A.ID and H.Num_Proc = Tp.Num_Proc
	
	left Join Pedido_Ship PS  with(nolock) on PS.num_proc=TP.Num_Proc
	left Join Pedido P with(nolock) on P.cd_pedido=PS.cd_pedido	
	left join Pessoa CLI with(nolock) on CLI.Cd_Pes = LLP.cd_cliente_master		
where	
	--tp.Num_Proc = 'IMOXT201604020BR' 
	--and (PLL.cd_pes_grupo = A.Cd_Pes_Grupo)-- or A.Cd_Pes_Grupo = '10017')
			
	--and 
	TP.dt_ins > (GETDATE() - A.Dias) 
	
	--and convert(date,tp.Dt_Ins,103) >= '2017-06-27'
	and	A.Ativo = 1	
	and TP.Dt_Conclusao is not null
	and H.Id_Alerta is null	

	and (
			(A.cd_tp_carga = 0 and LLp.Cd_Tp_Carga <> 0)
			or (A.cd_tp_carga = LLp.Cd_Tp_Carga)
		)
	
	and (
			(A.Cd_Org = LLP.cd_org and A.Cd_Dst = LLP.Cd_Dst)
			or		
			(A.Cd_Org = 'ALL'  and A.Cd_Dst= 'ALL')		
			or 
			(A.Cd_Org = 'ALL' and A.Cd_Dst = LLP.Cd_Dst)
			or
			(A.Cd_Dst= 'ALL' and  A.Cd_Org = LLP.cd_org)
		)
		
	and (
			(A.cd_tp_pedido = '1' and '0' not in ('2','3','4'))
			or 
			(A.cd_tp_pedido = isnull(P.Cd_tipo,'0'))
		)
	
	and (
			(A.cd_pes = 'ALL' and CS.Cd_Pes <> 'ALL')
			or 
			(A.cd_pes = CS.Cd_Pes)
		)
	
	And (
			(A.Email_do_Agente_Consolidado = 1 and LLP.Master <> 'JOB') 
			or
			(A.Email_do_Agente_Consolidado = 0 and LLP.Master is not null)
		)
	
	and (
			(A.Cd_Transportadora = 'ALL' and isnull(LLP.Cd_Transportadora,'') <> 'ALL')
			or 
			(A.Cd_Transportadora = LLP.Cd_Transportadora)
		)
	
	and (
			(A.cd_pes_grupo = 'ALL' and PLL.cd_pes_grupo <> 'ALL')
			or 
			(A.Cd_Pes_Grupo = PLL.cd_pes_grupo)
		)
		
	and (
			(A.Cd_Terminal = 'ALL' and isnull(LLP.Cd_Terminal,'') <> 'ALL')
			or 
			(A.Cd_Terminal = LLP.Cd_Terminal)
		)
	
UNION ALL
	
	select distinct 
		TP.Num_Proc						[JOB],
		A.Doc_Anexos					[Doc_Anexos],
		A.Doc_Anexos_Nao				[Doc_Anexos_Nao_Obrigatorios],
		[dbo].[fBusca_Alerta_Email_Doc_Automatico]('Assunto',TP.Num_Proc,A.ID,A.Cd_Pes_Grupo,A.cd_tp_carga,
									A.Cd_Org,A.Cd_Dst,A.cd_pes,A.modal,A.cd_tp_pedido,A.Cd_Transportadora, A.Cd_Terminal)  [Assunto],
		''								[Doc_Anexos_Master],
		A.CopyBDP						[CopyBDP],
		A.JuntaPDF						[JuntaPDF],
		Email_do_CompanyRegister		[Email_do_CompanyRegister],	
		(case when Email_do_CompanyRegister = 0 then '' 
		else			
			[dbo].[fBusca_Emal_Comunicacao](LLp.cd_cliente,'BO%')			
		end)						[Company_Register],
		A.Emails						[Emails],		
		[dbo].[fBusca_Alerta_Email_Doc_Automatico]('Mensagem',TP.Num_Proc,A.ID,A.Cd_Pes_Grupo,A.cd_tp_carga,
								A.Cd_Org,A.Cd_Dst,A.cd_pes,A.modal,A.cd_tp_pedido,A.Cd_Transportadora, A.Cd_Terminal) + '||' [MSG],
		TP.Dt_Previsao					[Previsao],
		A.CD_Pes_Grupo					[CD_Pes_Grupo],
		A.Nome_Tp_Ocor					[Nome_Tp_Ocor],
		'N'								[Disponivel],
		A.ID							[ID],
		A.Nome_Task						[Nome_Task],
		A.ResponderPara					[ResponderPara],		
		null							[Mensagem_Referencia_cliente],				
		CS.Apelido						[Cliente],
		
		Email_do_Agente_Consolidado,
		(case when Email_do_Agente_Consolidado = 0 then '' 
		else
			[dbo].[fBusca_Emal_Comunicacao](LLp.cd_cliente_master,'AG%')
		end)[Company_Register_Master],		
		--null [Company_Register_Master],	
		CLI.Apelido				[Cliente_Master],
		LLP.Master				[Master_JOB],		
		
		StandardForms,
		A.cd_tp_pedido
		,
		A.Cd_Pes_Grupo,
		A.cd_tp_carga,
		A.Cd_Org,
		A.Cd_Dst,
		A.cd_pes,
		A.modal,
		A.Cd_Transportadora,
		A.Cd_Terminal,
		--Para mensagem qdo nao enconta o cliente HOuse e do Master
		'Cliente: ' + CS.Apelido + ' sem emails cadastrados, JOB: ' + TP.Num_Proc [CorpoMSG],
		'Agente: ' + CLI.Apelido + ' sem emails cadastrados, JOB: ' + LLP.Master [CorpoMSGConsolidado],
		' - Não Enviado' [Assunto_CorpoMSG],		
		--Para mensagem qdo nao encontra os documentos
		'Arquivos não encontrados para serem anexados ao email, JOB: ' + TP.Num_Proc + 
			'|Favor verificar se existem os seguintes documentos estão no JOB: | ' 
			+ isnull([dbo].[fBusca_Alerta_Email_Doc_Automatico_Nome_Documento]
				(A.ID,A.Cd_Pes_Grupo,A.cd_tp_carga,A.Cd_Org,A.Cd_Dst,A.cd_pes,A.modal,A.cd_tp_pedido,A.Cd_Transportadora, A.Cd_Terminal),'')
			[CorpoMSG_Doc_Anexos],		
		' - Falha no envio - Sem arquivos anexados' [Assunto_CorpoMSG_Doc_Anexos]
		
		--,LLP.Cd_Transportadora [teste]
		,CopyEmail,Zip,A.Id_Alerta Id_Alerta
from Tarefas_Processos_Alerta	TP with(nolock)
	Join vwCliente_Alerta	LLP  with (nolock)on TP.Num_Proc = LLP.num_proc	
	join pessoa				CS  with(nolock) on CS.Cd_Pes = LLP.cd_cliente
	join Pessoa_LLP			PLL with(nolock) on PLL.Cd_Pes=LLP.cd_cliente	
	Join Usuario			US	with (nolock) on US.cd_usuario=LLP.cd_usuario

	join Alerta_Email_Doc_Automatico A with(nolock) on A.ID_Task = TP.ID_Task and A.Modal = LEFT(TP.Num_Proc,2)
	left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on H.ID = A.ID and H.Num_Proc = Tp.Num_Proc
	--H.Id_Alerta = A.Id_Alerta and H.ID = A.ID and H.Num_Proc = Tp.Num_Proc
	
	left Join Pedido_Ship PS  with(nolock) on PS.num_proc=TP.Num_Proc
	left Join Pedido P with(nolock) on P.cd_pedido=PS.cd_pedido	
	left join Pessoa CLI with(nolock) on CLI.Cd_Pes = LLP.cd_cliente_master		
where	
	--tp.Num_Proc = 'BOSLA201805001BR' and 			
	LEFT(TP.Num_Proc,2) = 'BO' AND 
	TP.dt_ins > (GETDATE() - A.Dias) 
	and	A.Ativo = 1	
	and TP.Dt_Conclusao is not null
	--and H.dt_envio is null
	and H.Id_Alerta is null	
	
	and (
			(A.cd_tp_carga = 0 and LLp.Cd_Tp_Carga <> 0)
			or (A.cd_tp_carga = LLp.Cd_Tp_Carga)
		)
	
	and (
			(A.Cd_Org = LLP.cd_org and A.Cd_Dst = LLP.Cd_Dst)
			or		
			(A.Cd_Org = 'ALL'  and A.Cd_Dst= 'ALL')		
			or 
			(A.Cd_Org = 'ALL' and A.Cd_Dst = LLP.Cd_Dst)
			or
			(A.Cd_Dst= 'ALL' and  A.Cd_Org = LLP.cd_org)
		)
		
	and (
			(A.cd_tp_pedido = '1' and '0' not in ('2','3','4'))
			or 
			(A.cd_tp_pedido = isnull(P.Cd_tipo,'0'))
		)
	
	and (
			(A.cd_pes = 'ALL' and CS.Cd_Pes <> 'ALL')
			or 
			(A.cd_pes = CS.Cd_Pes)
		)
	
	And (
			(A.Email_do_Agente_Consolidado = 1 and LLP.Master <> 'JOB') 
			or
			(A.Email_do_Agente_Consolidado = 0 and LLP.Master is not null)
		)
	
	and (
			(A.Cd_Transportadora = 'ALL' and isnull(LLP.Cd_Transportadora,'') <> 'ALL')
			or 
			(A.Cd_Transportadora = LLP.Cd_Transportadora)
		)
	
	and (
			(A.cd_pes_grupo = 'ALL' and PLL.cd_pes_grupo <> 'ALL')
			or 
			(A.Cd_Pes_Grupo = PLL.cd_pes_grupo)
		)
		
	and (
			(A.Cd_Terminal = 'ALL' and isnull(LLP.Cd_Terminal,'') <> 'ALL')
			or 
			(A.Cd_Terminal = LLP.Cd_Terminal)
		)
	
	
	option(hash join)
				
		
/*

		--Exportação Maritima
			select Distinct
				TP.Num_Proc						[JOB],
				A.Doc_Anexos					[Doc_Anexos],
				A.Doc_Anexos_Nao				[Doc_Anexos_Nao_Obrigatorios],
				[dbo].[fBusca_Alerta_Email_Doc_Automatico_Assunto](TP.Num_Proc,A.ID)  [Assunto],
				''								[Doc_Anexos_Master],
				A.CopyBDP						[CopyBDP],
				A.JuntaPDF						[JuntaPDF],
				Email_do_CompanyRegister		[Email_do_CompanyRegister],	
				(case when Email_do_CompanyRegister = 0 
					then '' 
				else
					[dbo].[fBusca_Emal_Comunicacao](HOU.Cd_Export_HEM,'EM%')
				end) [Company_Register],
				A.Emails						[Emails],
				--Mensagem + '||' 				[MSG],
				[dbo].[fBusca_Alerta_Email_Doc_Automatico_Corpo](TP.Num_Proc,A.ID) + '||' [MSG],
				TP.Dt_Previsao					[Previsao],
				A.CD_Pes_Grupo					[CD_Pes_Grupo],
				A.Nome_Tp_Ocor					[Nome_Tp_Ocor],
				'N'								[Disponivel],
				A.ID							[ID],
				A.Nome_Task						[Nome_Task],
				A.ResponderPara					[ResponderPara],
				--comeco pulando umas 5 linhas
				'********** References ****************' + '|' +
				'BDP Ref.:' + TP.Num_Proc + '|' +
				'CSR Responsible:' + ISNULL(Nome_Usuario,'') + '|' +
				'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,1),'') + '|' +
				'Sales Order:' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,3),'')  + '|' +
				'Origin: ' + isnull(Org.Nome_Local,'') + '|' +
				'Destination: '+ isnull(DST.Nome_Local,11) + '|' +
				'ATD: ' + isnull(convert(varchar(20),ATD_LEM,107),'') +'|' +
				'ATA: ' + isnull(convert(varchar(20),ATA_LEM,107),'') +'|' +
				'*************************************'  + '|' +
				'by BDP System' 	[Mensagem_Referencia_cliente],		
						
				CS.Apelido							[Cliente]		
		from Tarefas_Processos_Alerta		TP with(nolock)
			join Tipo_tarefas		TT with(nolock) on TT.ID_Task = Tp.Id_Task
			left join Alerta_Email_Doc_Automatico A with(nolock) on A.ID_Task = TP.ID_Task	and A.Modal = TT.Modal
			left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on H.ID = A.ID and H.Num_Proc = Tp.Num_Proc		
			Join LLP_Exp_Mar		LLP	with(nolock) on TP.Num_Proc=LLP.Num_Proc_Lem
			Join House_Exp_Mar		Hou	with(nolock) on hou.Num_Proc_HEM=Num_Proc_Lem
			left join pessoa		CS  with(nolock) on CS.cd_pes=HOU.Cd_Export_HEM
			left join Pessoa_LLP	PLL with(nolock) on PLL.Cd_Pes=HOU.Cd_Export_HEM	
			left join Grupo			G	with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
			left join pessoa		PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo	
			Join Job_Exp_Mar		JOb	with (nolock) on job.Num_Proc_HEM=Num_Proc_Lem
			Join Usuario			US	with (nolock) on US.cd_usuario=Job.cd_usuario	
			Join Localidade			Org	with (nolock) on Org.cd_local=Cd_Org_HEM
			Join Localidade			Dst	with (nolock) on DST.cd_local=Cd_Dst_HEM		
		where	
			(PLL.cd_pes_grupo = A.Cd_Pes_Grupo or A.Cd_Pes_Grupo = '10017')
			and TP.dt_ins > (GETDATE() - A.Dias) 
			and	A.Ativo = 1
			and left(TP.Num_Proc,2) = A.Modal
			and TP.Dt_Conclusao is not null
			and H.dt_envio is null
			
			and ((A.cd_tp_carga = 0 and LLp.Cd_Tp_Carga <> 0)
			or (A.cd_tp_carga = LLp.Cd_Tp_Carga))
			
		UNION ALL
		--Exportação Aerea
			select 
				TP.Num_Proc						[JOB],
				A.Doc_Anexos					[Doc_Anexos],
				A.Doc_Anexos_Nao				[Doc_Anexos_Nao_Obrigatorios],
				--A.Nome_Task + ':' + TP.Num_Proc	[Assunto],
				[dbo].[fBusca_Alerta_Email_Doc_Automatico_Assunto](TP.Num_Proc,A.ID)  [Assunto],
				''								[Doc_Anexos_Master],
				A.CopyBDP						[CopyBDP],
				A.JuntaPDF						[JuntaPDF],		
				Email_do_CompanyRegister		[Email_do_CompanyRegister],	
				(case when Email_do_CompanyRegister = 0 
					then '' 
				else		
				[dbo].[fBusca_Emal_Comunicacao](HOU.Cd_Export_HEA,'EA%')
				End) [Company_Register],
				A.Emails						[Emails],
				--A.Emails						[Emails],
				--(case when A.Email_do_CompanyRegister = '1' then
				--	[dbo].[fBusca_Emal_Comunicacao](HOU.Cd_Export_HEA,'EA%') + ';' + A.Emails
				--	else A.Emails	end)		[Emails],
				--Mensagem + '||' 				[MSG],
				[dbo].[fBusca_Alerta_Email_Doc_Automatico_Corpo](TP.Num_Proc,A.ID) + '||' [MSG],
				TP.Dt_Previsao					[Previsao],
				A.CD_Pes_Grupo					[CD_Pes_Grupo],
				A.Nome_Tp_Ocor					[Nome_Tp_Ocor],
				'N'								[Disponivel],
				A.ID							[ID],
				A.Nome_Task						[Nome_Task],
				A.ResponderPara					[ResponderPara],
				'********** References ****************' + '|' +
				'BDP Ref.:' + TP.Num_Proc + '|' +
				'CSR Responsible:' + ISNULL(Nome_Usuario,'') + '|' +
				'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,1),'') + '|' +
				'Sales Order:' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,3),'')  + '|' +
				'Origin: ' + isnull(Org.Nome_Local,'') + '|' +
				'Destination: '+ isnull(DST.Nome_Local,11) + '|' +
				'ATD: ' + isnull(convert(varchar(20),ATD_LEA,107),'') +'|' +
				'ATA: ' + isnull(convert(varchar(20),ATA_LEA,107),'') +'|' +
				'*************************************'  + '|' +
				'by BDP System' 	[Mensagem_Referencia_cliente],
				CS.Apelido							[Cliente]
		from Tarefas_Processos_Alerta		TP with(nolock)
			join Tipo_tarefas		TT with(nolock) on TT.ID_Task = Tp.Id_Task
			left join Alerta_Email_Doc_Automatico A with(nolock) on A.ID_Task = TP.ID_Task	and A.Modal = TT.Modal
			left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on H.ID = A.ID and H.Num_Proc = Tp.Num_Proc		
			Join LLP_Exp_Aer		LLP	with(nolock) on TP.Num_Proc=LLP.Num_Proc_Lea
			Join House_Exp_Aer		Hou	with(nolock) on hou.Num_Proc_HEA=Num_Proc_Lea
			left join pessoa		CS  with(nolock) on CS.cd_pes=HOU.Cd_Export_Hea
			left join Pessoa_LLP	PLL with(nolock) on PLL.Cd_Pes=HOU.Cd_Export_Hea	
			left join Grupo			G	with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
			left join pessoa		PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo	
			Join Job_Exp_Aer		JOb	with (nolock) on job.Num_Proc_Hea=Num_Proc_Lea
			Join Usuario			US	with (nolock) on US.cd_usuario=Job.cd_usuario	
			Join Localidade			Org	with (nolock) on Org.cd_local=Cd_Org_Hea
			Join Localidade			Dst	with (nolock) on DST.cd_local=Cd_Dst_Hea		
		where	
			(PLL.cd_pes_grupo = A.Cd_Pes_Grupo or A.Cd_Pes_Grupo = '10017')
			and TP.dt_ins > (GETDATE() - A.Dias) 
			and	A.Ativo = 1
			and left(TP.Num_Proc,2) = A.Modal
			and TP.Dt_Conclusao is not null
			and H.dt_envio is null
			
		UNION ALL
		--Exportação Outros
			select distinct
				TP.Num_Proc						[JOB],
				A.Doc_Anexos					[Doc_Anexos],
				A.Doc_Anexos_Nao				[Doc_Anexos_Nao_Obrigatorios],
				--A.Nome_Task + ':' + TP.Num_Proc	[Assunto],
				[dbo].[fBusca_Alerta_Email_Doc_Automatico_Assunto](TP.Num_Proc,A.ID)  [Assunto],
				''								[Doc_Anexos_Master],
				A.CopyBDP						[CopyBDP],
				A.JuntaPDF						[JuntaPDF],
				Email_do_CompanyRegister		[Email_do_CompanyRegister],
				(case when Email_do_CompanyRegister = 0 
					then '' 
				else			
				[dbo].[fBusca_Emal_Comunicacao](HOU.Cd_Export_HEO,'EO%')
				End) [Company_Register],
				A.Emails						[Emails],
				--Mensagem + '||' 				[MSG],
				[dbo].[fBusca_Alerta_Email_Doc_Automatico_Corpo](TP.Num_Proc,A.ID) + '||' [MSG],
				TP.Dt_Previsao					[Previsao],
				A.CD_Pes_Grupo					[CD_Pes_Grupo],
				A.Nome_Tp_Ocor					[Nome_Tp_Ocor],
				'N'								[Disponivel],
				A.ID							[ID],
				A.Nome_Task						[Nome_Task],
				A.ResponderPara					[ResponderPara],
				'********** References ****************' + '|' +
				'BDP Ref.:' + TP.Num_Proc + '|' +
				'CSR Responsible:' + ISNULL(Nome_Usuario,'') + '|' +
				'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,1),'') + '|' +
				'Sales Order:' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,3),'')  + '|' +
				'Origin: ' + isnull(Org.Nome_Local,'') + '|' +
				'Destination: '+ isnull(DST.Nome_Local,11) + '|' +
				'ATD: ' + isnull(convert(varchar(20),ATD_LEO,107),'') +'|' +
				'ATA: ' + isnull(convert(varchar(20),ATA_Leo,107),'') +'|' +
				'*************************************'  + '|' +
				'by BDP System' 	[Mensagem_Referencia_cliente],
				CS.Apelido							[Cliente]
		from Tarefas_Processos_Alerta		TP with(nolock)
			join Tipo_tarefas		TT with(nolock) on TT.ID_Task = Tp.Id_Task
			left join Alerta_Email_Doc_Automatico A with(nolock) on A.ID_Task = TP.ID_Task	and A.Modal = TT.Modal
			left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on H.ID = A.ID and H.Num_Proc = Tp.Num_Proc		
			Join LLP_Exp_Out		LLP	with(nolock) on TP.Num_Proc=LLP.Num_Proc_Leo
			Join House_Exp_Out		Hou	with(nolock) on hou.Num_Proc_HEo=Num_Proc_Leo
			left join pessoa		CS  with(nolock) on CS.cd_pes=HOU.Cd_Export_HEO
			left join Pessoa_LLP	PLL with(nolock) on PLL.Cd_Pes=HOU.Cd_Export_HEO	
			left join Grupo			G	with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
			left join pessoa		PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo	
			Join Usuario			US	with (nolock) on US.cd_usuario=LLP.cd_usuario		
			Join Localidade			Org	with (nolock) on Org.cd_local=Cd_Org_HEO
			Join Localidade			Dst	with (nolock) on DST.cd_local=Cd_Dst_HEO		
		where	
			(PLL.cd_pes_grupo = A.Cd_Pes_Grupo or A.Cd_Pes_Grupo = '10017')
			and TP.dt_ins > (GETDATE() - A.Dias) 
			and	A.Ativo = 1
			and left(TP.Num_Proc,2) = A.Modal
			and TP.Dt_Conclusao is not null
			and H.dt_envio is null
		UNION ALL	
			
		--Importação Maritima
			select distinct
				TP.Num_Proc						[JOB],
				A.Doc_Anexos					[Doc_Anexos],
				A.Doc_Anexos_Nao				[Doc_Anexos_Nao_Obrigatorios],
				--A.Nome_Task + ':' + TP.Num_Proc	[Assunto],
				[dbo].[fBusca_Alerta_Email_Doc_Automatico_Assunto](TP.Num_Proc,A.ID)  [Assunto],
				''								[Doc_Anexos_Master],
				A.CopyBDP						[CopyBDP],
				A.JuntaPDF						[JuntaPDF],
				Email_do_CompanyRegister		[Email_do_CompanyRegister],	
				(case when Email_do_CompanyRegister = 0 
					then '' 
				else		
					[dbo].[fBusca_Emal_Comunicacao](HOU.Cd_Consig_HIM,'IM%')
				End) [Company_Register],
				A.Emails						[Emails],
				--Mensagem + '||' 				[MSG],
				[dbo].[fBusca_Alerta_Email_Doc_Automatico_Corpo](TP.Num_Proc,A.ID) + '||' [MSG],
				TP.Dt_Previsao					[Previsao],
				A.CD_Pes_Grupo					[CD_Pes_Grupo],
				A.Nome_Tp_Ocor					[Nome_Tp_Ocor],
				'N'								[Disponivel],
				A.ID							[ID],
				A.Nome_Task						[Nome_Task],
				A.ResponderPara					[ResponderPara],
				'********** References ****************' + '|' +
				'BDP Ref.:' + TP.Num_Proc + '|' +
				'CSR Responsible:' + ISNULL(Nome_Usuario,'') + '|' +
				'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,1),'') + '|' +
				'Sales Order:' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,3),'')  + '|' +
				'Origin: ' + isnull(Org.Nome_Local,'') + '|' +
				'Destination: '+ isnull(DST.Nome_Local,'') + '|' +
				'ATD: ' + isnull(convert(varchar(20),ATD_LiM,107),'') +'|' +
				'ATA: ' + isnull(convert(varchar(20),ATA_LiM,107),'') +'|' +
				'*************************************'  + '|' +
				'by BDP System' 	[Mensagem_Referencia_cliente],
				CS.Apelido							[Cliente]
		from Tarefas_Processos_Alerta		TP with(nolock)
			join Tipo_tarefas		TT with(nolock) on TT.ID_Task = Tp.Id_Task
			left join Alerta_Email_Doc_Automatico A with(nolock) on A.ID_Task = TP.ID_Task	and A.Modal = TT.Modal
			left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on H.ID = A.ID and H.Num_Proc = Tp.Num_Proc		
			Join LLP_Imp_Mar		LLP	with(nolock) on TP.Num_Proc=LLP.Num_Proc_Lim
			Join House_Imp_Mar		Hou	with(nolock) on hou.Num_Proc_HiM=Num_Proc_Lim
			left join Pessoa_LLP	PLL with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HiM
			left join pessoa		CS  with(nolock) on CS.cd_pes=HOU.Cd_Consig_HIM
			left join Grupo			G	with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
			left join pessoa		PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo	
			Join Job_Imp_Mar		JOb	with (nolock) on job.Num_Proc_HiM=Num_Proc_Lim
			Join Usuario			US	with (nolock) on US.cd_usuario=Job.cd_usuario	
			Join Localidade			Org	with (nolock) on Org.cd_local=Cd_Org_him
			Join Localidade			Dst	with (nolock) on DST.cd_local=Cd_Dst_HiM		
		where	
			(PLL.cd_pes_grupo = A.Cd_Pes_Grupo or A.Cd_Pes_Grupo = '10017')
			and TP.dt_ins > (GETDATE() - A.Dias) 
			and	A.Ativo = 1
			and left(TP.Num_Proc,2) = A.Modal
			and TP.Dt_Conclusao is not null
			and H.dt_envio is null
				
			and ((A.cd_tp_carga = 0 and LLp.Cd_Tp_Carga <> 0)
			or (A.cd_tp_carga = LLp.Cd_Tp_Carga))
			
		UNION ALL
		--Importação Aerea
			select distinct
				TP.Num_Proc						[JOB],
				A.Doc_Anexos					[Doc_Anexos],
				A.Doc_Anexos_Nao				[Doc_Anexos_Nao_Obrigatorios],
				--A.Nome_Task + ':' + TP.Num_Proc	[Assunto],
				[dbo].[fBusca_Alerta_Email_Doc_Automatico_Assunto](TP.Num_Proc,A.ID)  [Assunto],
				''								[Doc_Anexos_Master],
				A.CopyBDP						[CopyBDP],
				A.JuntaPDF						[JuntaPDF],
				Email_do_CompanyRegister		[Email_do_CompanyRegister],	
				(case when Email_do_CompanyRegister = 0 
					then '' 
				else		
					[dbo].[fBusca_Emal_Comunicacao](HOU.Cd_Consig_HIA,'IA%')
				End) [Company_Register],
				A.Emails						[Emails],
				--Mensagem + '||' 				[MSG],
				[dbo].[fBusca_Alerta_Email_Doc_Automatico_Corpo](TP.Num_Proc,A.ID) + '||' [MSG],
				TP.Dt_Previsao					[Previsao],
				A.CD_Pes_Grupo					[CD_Pes_Grupo],
				A.Nome_Tp_Ocor					[Nome_Tp_Ocor],
				'N'								[Disponivel],
				A.ID							[ID],
				A.Nome_Task						[Nome_Task],
				A.ResponderPara					[ResponderPara],
				'********** References ****************' + '|' +
				'BDP Ref.:' + TP.Num_Proc + '|' +
				'CSR Responsible:' + ISNULL(Nome_Usuario,'') + '|' +
				'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,1),'') + '|' +
				'Sales Order:' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,3),'')  + '|' +
				'Origin: ' + isnull(Org.Nome_Local,'') + '|' +
				'Destination: '+ isnull(DST.Nome_Local,11) + '|' +
				'ATD: ' + isnull(convert(varchar(20),ATD_LIA,107),'') +'|' +
				'ATA: ' + isnull(convert(varchar(20),ATA_LIA,107),'') +'|' +
				'*************************************'  + '|' +
				'by BDP System' 	[Mensagem_Referencia_cliente],
				CS.Apelido							[Cliente]
		from Tarefas_Processos_Alerta		TP with(nolock)
			join Tipo_tarefas		TT with(nolock) on TT.ID_Task = Tp.Id_Task
			left join Alerta_Email_Doc_Automatico A with(nolock) on A.ID_Task = TP.ID_Task	and A.Modal = TT.Modal
			left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on H.ID = A.ID and H.Num_Proc = Tp.Num_Proc		
			Join LLP_Imp_Aer		LLP	with(nolock) on TP.Num_Proc=LLP.Num_Proc_Lia
			Join House_Imp_Aer		Hou	with(nolock) on hou.Num_Proc_HIA=Num_Proc_Lia
			left join pessoa		CS  with(nolock) on CS.cd_pes=HOU.Cd_Consig_HIa
			left join Pessoa_LLP	PLL with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_Hia	
			left join Grupo			G	with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
			left join pessoa		PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo	
			Join Job_Imp_Aer		JOb	with (nolock) on job.Num_Proc_Hia=Num_Proc_Lia
			Join Usuario			US	with (nolock) on US.cd_usuario=Job.cd_usuario	
			Join Localidade			Org	with (nolock) on Org.cd_local=Cd_Org_Hia
			Join Localidade			Dst	with (nolock) on DST.cd_local=Cd_Dst_Hia		
		where	
			(PLL.cd_pes_grupo = A.Cd_Pes_Grupo or A.Cd_Pes_Grupo = '10017')
			and TP.dt_ins > (GETDATE() - A.Dias) 
			and	A.Ativo = 1
			and left(TP.Num_Proc,2) = A.Modal
			and TP.Dt_Conclusao is not null
			and H.dt_envio is null
			
		UNION ALL
		--Importação Outros
			select 
				TP.Num_Proc						[JOB],
				A.Doc_Anexos					[Doc_Anexos],
				A.Doc_Anexos_Nao				[Doc_Anexos_Nao_Obrigatorios],
				--A.Nome_Task + ':' + TP.Num_Proc	[Assunto],
				[dbo].[fBusca_Alerta_Email_Doc_Automatico_Assunto](TP.Num_Proc,A.ID)  [Assunto],
				''								[Doc_Anexos_Master],
				A.CopyBDP						[CopyBDP],
				A.JuntaPDF						[JuntaPDF],
				Email_do_CompanyRegister		[Email_do_CompanyRegister],			
				(case when Email_do_CompanyRegister = 0 
					then '' 
				else
					[dbo].[fBusca_Emal_Comunicacao](HOU.Cd_Consig_HIO,'IO%')
				END) [Company_Register],
				A.Emails						[Emails],
				--Mensagem + '||' 				[MSG],
				[dbo].[fBusca_Alerta_Email_Doc_Automatico_Corpo](TP.Num_Proc,A.ID) + '||' [MSG],
				TP.Dt_Previsao					[Previsao],
				A.CD_Pes_Grupo					[CD_Pes_Grupo],
				A.Nome_Tp_Ocor					[Nome_Tp_Ocor],
				'N'								[Disponivel],
				A.ID							[ID],
				A.Nome_Task						[Nome_Task],
				A.ResponderPara					[ResponderPara],
				'********** References ****************' + '|' +
				'BDP Ref.:' + TP.Num_Proc + '|' +
				'CSR Responsible:' + ISNULL(Nome_Usuario,'') + '|' +
				'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,1),'') + '|' +
				'Sales Order:' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,3),'')  + '|' +
				'Origin: ' + isnull(Org.Nome_Local,'') + '|' +
				'Destination: '+ isnull(DST.Nome_Local,11) + '|' +
				'ATD: ' + isnull(convert(varchar(20),ATD_Lio,107),'') +'|' +
				'ATA: ' + isnull(convert(varchar(20),ATA_Lio,107),'') +'|' +
				'*************************************'  + '|' +
				'by BDP System' 	[Mensagem_Referencia_cliente],
				CS.Apelido							[Cliente]	
		from Tarefas_Processos_Alerta TP with(nolock)
			join Tipo_tarefas		TT with(nolock) on TT.ID_Task = Tp.Id_Task
			left join Alerta_Email_Doc_Automatico A with(nolock) on A.ID_Task = TP.ID_Task	and A.Modal = TT.Modal
			left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on H.ID = A.ID and H.Num_Proc = Tp.Num_Proc		
			Join LLP_Imp_Out		LLP	with(nolock) on TP.Num_Proc=LLP.Num_Proc_Lio
			Join House_Imp_Out		Hou	with(nolock) on hou.Num_Proc_Hio=Num_Proc_Lio
			left join pessoa		CS  with(nolock) on CS.cd_pes=HOU.Cd_Consig_HIO
			left join Pessoa_LLP	PLL with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIO	
			left join Grupo			G	with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
			left join pessoa		PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo	
			Join Usuario			US	with (nolock) on US.cd_usuario=LLP.cd_usuario		
			Join Localidade			Org	with (nolock) on Org.cd_local=Cd_Org_HiO
			Join Localidade			Dst	with (nolock) on DST.cd_local=Cd_Dst_HiO		
		where	
			(PLL.cd_pes_grupo = A.Cd_Pes_Grupo or A.Cd_Pes_Grupo = '10017')
			and TP.dt_ins > (GETDATE() - A.Dias) 
			and	A.Ativo = 1
			and left(TP.Num_Proc,2) = A.Modal
			and TP.Dt_Conclusao is not null
			and H.dt_envio is null
			
		*/
				
		--******************Nao foi necessario, pois fiz novatabela pra tarefas processos**********
		--alter table [dbo].[TAREFAS_PROCESSOS] add [dt_ins] datetime null
		--spTaskProc_Upd
		--spTaskProcImport_Upd
		--spTaskProc_LerXML_Upd
		--spTask_Upd

		--select * from Alerta_Email_Doc_Automatico
		--[dbo].[fBusca_Emal_Comunicacao](HOU.cd_consig_him,'IM%')
		--Email_do_CompanyRegister

		--select * from Tarefas_Processos where dt_ins > GETDATE() -1
		--*************************Stored antiga**********************************

		--Exportação Maritima
		--	select 
		--		TP.Num_Proc						[JOB],
		--		A.Doc_Anexos					[Doc_Anexos],
		--		Nome_Task + ':' + TP.Num_Proc	[Assunto],
		--		''								[Doc_Anexos_Master],
		--		A.CopyBDP						[CopyBDP],
		--		A.JuntaPDF						[JuntaPDF],
		--		(case when Email_do_CompanyRegister = '1' then
		--			[dbo].[fBusca_Emal_Comunicacao](HOU.Cd_Export_HEM,'EM%')
		--			else A.Emails	end)		[Emails],
		--		Mensagem + '||' 				[MSG],
		--		TP.Dt_Previsao					[Previsao],
		--		A.CD_Pes_Grupo					[CD_Pes_Grupo],
		--		A.Nome_Tp_Ocor					[Nome_Tp_Ocor],
		--		'N'								[Disponivel],
		--		A.ID							[ID],
		--		A.Nome_Task						[Nome_Task],
		--		A.ResponderPara					[ResponderPara],
		--		--comeco pulando umas 5 linhas
		--		'********** References ****************' + '|' +
		--		'BDP Ref.:' + TP.Num_Proc + '|' +
		--		'CSR Responsible:' + ISNULL(Nome_Usuario,'') + '|' +
		--		'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,1),'') + '|' +
		--		'Sales Order:' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,3),'')  + '|' +
		--		'Origin: ' + isnull(Org.Nome_Local,'') + '|' +
		--		'Destination: '+ isnull(DST.Nome_Local,11) + '|' +
		--		'ATD: ' + isnull(convert(varchar(20),ATD_LEM,107),'') +'|' +
		--		'ATA: ' + isnull(convert(varchar(20),ATA_LEM,107),'') +'|' +
		--		'*************************************'  + '|' +
		--		'by BDP System' 	[Mensagem_Referencia_cliente]	
				
		--	from Alerta_Email_Doc_Automatico A
		--		left join Tarefas_Processos TP with(nolock) on  TP.ID_Task = A.ID_Task
		--		left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on  H.ID = A.ID and H.Num_Proc = Tp.Num_Proc	
				
		--		Join LLP_Exp_Mar LLP	with(nolock) on TP.Num_Proc=LLP.Num_Proc_Lem
		--		Join House_Exp_Mar Hou	with(nolock) on hou.num_proc_hem=Num_Proc_Lem	
		--		Join Job_Exp_Mar JOb	with (nolock) on job.num_proc_hem=num_proc_lem
		--		Join Usuario US			with (nolock) on US.cd_usuario=Job.cd_usuario	
		--		Join Localidade Org		with (nolock) on Org.cd_local=cd_org_hem
		--		Join Localidade Dst		with (nolock) on DST.cd_local=cd_dst_hem	
				
		--	where
		--		TP.dt_ins > (GETDATE() - A.Dias) 
		--		and	
		--		A.Ativo = 1
		--		and left(TP.Num_Proc,2) = A.Modal
		--		and TP.Dt_Conclusao is not null
		--		and H.dt_envio is null	
		--UNION ALL
		----Exportação Aerea
		--	select 
		--		TP.Num_Proc						[JOB],
		--		A.Doc_Anexos					[Doc_Anexos],
		--		Nome_Task + ':' + TP.Num_Proc	[Assunto],
		--		''								[Doc_Anexos_Master],
		--		A.CopyBDP						[CopyBDP],
		--		A.JuntaPDF						[JuntaPDF],
		--		--A.Emails						[Emails],
		--		(case when Email_do_CompanyRegister = '1' then
		--			[dbo].[fBusca_Emal_Comunicacao](HOU.Cd_Export_HEA,'EA%')
		--			else A.Emails	end)		[Emails],
		--		Mensagem + '||' 				[MSG],
		--		TP.Dt_Previsao					[Previsao],
		--		A.CD_Pes_Grupo					[CD_Pes_Grupo],
		--		A.Nome_Tp_Ocor					[Nome_Tp_Ocor],
		--		'N'								[Disponivel],
		--		A.ID							[ID],
		--		A.Nome_Task						[Nome_Task],
		--		A.ResponderPara					[ResponderPara],
		--		'********** References ****************' + '|' +
		--		'BDP Ref.:' + TP.Num_Proc + '|' +
		--		'CSR Responsible:' + ISNULL(Nome_Usuario,'') + '|' +
		--		'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,1),'') + '|' +
		--		'Sales Order:' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,3),'')  + '|' +
		--		'Origin: ' + isnull(Org.Nome_Local,'') + '|' +
		--		'Destination: '+ isnull(DST.Nome_Local,11) + '|' +
		--		'ATD: ' + isnull(convert(varchar(20),ATD_LEA,107),'') +'|' +
		--		'ATA: ' + isnull(convert(varchar(20),ATA_LEA,107),'') +'|' +
		--		'*************************************'  + '|' +
		--		'by BDP System' 	[Mensagem_Referencia_cliente]	
				
		--	from Alerta_Email_Doc_Automatico A
		--		left join Tarefas_Processos TP with(nolock) on  TP.ID_Task = A.ID_Task
		--		left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on  H.ID = A.ID and H.Num_Proc = Tp.Num_Proc
				
		--		Join LLP_Exp_AER LLP	with(nolock) on TP.Num_Proc=LLP.Num_Proc_Lea
		--		Join House_Exp_AER Hou	with(nolock) on hou.num_proc_hea=Num_Proc_Lea	
		--		Join Job_Exp_AER JOb	with (nolock) on job.Num_Proc_HEA=num_proc_lea
		--		Join Usuario US			with (nolock) on US.cd_usuario=Job.cd_usuario	
		--		Join Localidade Org		with (nolock) on Org.cd_local=Cd_Org_HEA
		--		Join Localidade Dst		with (nolock) on DST.cd_local=Cd_Dst_HEA	
				
		--	where
		--		TP.dt_ins > (GETDATE() - A.Dias) 
		--		and	
		--		A.Ativo = 1
		--		and left(TP.Num_Proc,2) = A.Modal
		--		and TP.Dt_Conclusao is not null
		--		and H.dt_envio is null	
		--UNION ALL
		----Exportação Outros
		--	select 
		--		TP.Num_Proc						[JOB],
		--		A.Doc_Anexos					[Doc_Anexos],
		--		Nome_Task + ':' + TP.Num_Proc	[Assunto],
		--		''								[Doc_Anexos_Master],
		--		A.CopyBDP						[CopyBDP],
		--		A.JuntaPDF						[JuntaPDF],
		--		--A.Emails						[Emails],
		--		(case when Email_do_CompanyRegister = '1' then
		--			[dbo].[fBusca_Emal_Comunicacao](HOU.Cd_Export_HEO,'EO%')
		--			else A.Emails	end)		[Emails],
		--		Mensagem + '||' 				[MSG],
		--		TP.Dt_Previsao					[Previsao],
		--		A.CD_Pes_Grupo					[CD_Pes_Grupo],
		--		A.Nome_Tp_Ocor					[Nome_Tp_Ocor],
		--		'N'								[Disponivel],
		--		A.ID							[ID],
		--		A.Nome_Task						[Nome_Task],
		--		A.ResponderPara					[ResponderPara],
		--		'********** References ****************' + '|' +
		--		'BDP Ref.:' + TP.Num_Proc + '|' +
		--		'CSR Responsible:' + ISNULL(Nome_Usuario,'') + '|' +
		--		'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,1),'') + '|' +
		--		'Sales Order:' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,3),'')  + '|' +
		--		'Origin: ' + isnull(Org.Nome_Local,'') + '|' +
		--		'Destination: '+ isnull(DST.Nome_Local,11) + '|' +
		--		'ATD: ' + isnull(convert(varchar(20),ATD_LEO,107),'') +'|' +
		--		'ATA: ' + isnull(convert(varchar(20),ATA_Leo,107),'') +'|' +
		--		'*************************************'  + '|' +
		--		'by BDP System' 	[Mensagem_Referencia_cliente]	
				
		--	from Alerta_Email_Doc_Automatico A with(nolock) 
		--		left join Tarefas_Processos TP with(nolock) on  TP.ID_Task = A.ID_Task
		--		left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on  H.ID = A.ID and H.Num_Proc = Tp.Num_Proc	
				
		--		Join LLP_Exp_Out LLP	with(nolock) on TP.Num_Proc=LLP.Num_Proc_Leo
		--		Join House_Exp_Out Hou	with(nolock) on hou.num_proc_heo=Num_Proc_Leo	
		--		Join Usuario US			with (nolock) on US.cd_usuario=LLP.cd_usuario	
		--		Join Localidade Org		with (nolock) on Org.cd_local=cd_org_heo
		--		Join Localidade Dst		with (nolock) on DST.cd_local=cd_dst_heo	
				
		--	where
		--		TP.dt_ins > (GETDATE() - A.Dias) 
		--		and	
		--		A.Ativo = 1
		--		and left(TP.Num_Proc,2) = A.Modal
		--		and TP.Dt_Conclusao is not null
		--		and H.dt_envio is null
			
			
		--UNION ALL	
			
		----Importação Maritima
		--	select 
		--		TP.Num_Proc						[JOB],
		--		A.Doc_Anexos					[Doc_Anexos],
		--		Nome_Task + ':' + TP.Num_Proc	[Assunto],
		--		''								[Doc_Anexos_Master],
		--		A.CopyBDP						[CopyBDP],
		--		A.JuntaPDF						[JuntaPDF],
		--		--A.Emails						[Emails],
		--		(case when Email_do_CompanyRegister = '1' then
		--				[dbo].[fBusca_Emal_Comunicacao](HOU.Cd_Consig_HIM,'IM%')
		--			else A.Emails	end)		[Emails],
		--		Mensagem + '||' 				[MSG],
		--		TP.Dt_Previsao					[Previsao],
		--		A.CD_Pes_Grupo					[CD_Pes_Grupo],
		--		A.Nome_Tp_Ocor					[Nome_Tp_Ocor],
		--		'N'								[Disponivel],
		--		A.ID							[ID],
		--		A.Nome_Task						[Nome_Task],
		--		A.ResponderPara					[ResponderPara],
		--		'********** References ****************' + '|' +
		--		'BDP Ref.:' + TP.Num_Proc + '|' +
		--		'CSR Responsible:' + ISNULL(Nome_Usuario,'') + '|' +
		--		'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,1),'') + '|' +
		--		'Sales Order:' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,3),'')  + '|' +
		--		'Origin: ' + isnull(Org.Nome_Local,'') + '|' +
		--		'Destination: '+ isnull(DST.Nome_Local,'') + '|' +
		--		'ATD: ' + isnull(convert(varchar(20),ATD_LiM,107),'') +'|' +
		--		'ATA: ' + isnull(convert(varchar(20),ATA_LiM,107),'') +'|' +
		--		'*************************************'  + '|' +
		--		'by BDP System' 	[Mensagem_Referencia_cliente]	
				
		--	from Alerta_Email_Doc_Automatico A with(nolock)
		--		left join Tarefas_Processos TP with(nolock) on  TP.ID_Task = A.ID_Task
		--		left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on  H.ID = A.ID and H.Num_Proc = Tp.Num_Proc	
				
		--		Join LLP_Imp_Mar LLP	with(nolock) on TP.Num_Proc=LLP.Num_Proc_Lim
		--		Join House_Imp_Mar Hou	with(nolock) on hou.num_proc_him=Num_Proc_Lim	
		--		Join Job_Imp_Mar JOb	with (nolock) on job.num_proc_him=num_proc_lim
		--		Join Usuario US			with (nolock) on US.cd_usuario=Job.cd_usuario	
		--		Join Localidade Org		with (nolock) on Org.cd_local=cd_org_him
		--		Join Localidade Dst		with (nolock) on DST.cd_local=cd_dst_him	
				
		--	where
		--		TP.dt_ins > (GETDATE() - A.Dias) 
		--		and	
		--		A.Ativo = 1
		--		and left(TP.Num_Proc,2) = A.Modal
		--		and TP.Dt_Conclusao is not null
		--		and H.dt_envio is null
			
		--UNION ALL
		----Importação Aerea
		--	select 
		--		TP.Num_Proc						[JOB],
		--		A.Doc_Anexos					[Doc_Anexos],
		--		Nome_Task + ':' + TP.Num_Proc	[Assunto],
		--		''								[Doc_Anexos_Master],
		--		A.CopyBDP						[CopyBDP],
		--		A.JuntaPDF						[JuntaPDF],
		--		--A.Emails						[Emails],
		--		(case when Email_do_CompanyRegister = '1' then
		--				[dbo].[fBusca_Emal_Comunicacao](HOU.Cd_Consig_HIA,'IA%')
		--			else A.Emails	end)		[Emails],
		--		Mensagem + '||' 				[MSG],
		--		TP.Dt_Previsao					[Previsao],
		--		A.CD_Pes_Grupo					[CD_Pes_Grupo],
		--		A.Nome_Tp_Ocor					[Nome_Tp_Ocor],
		--		'N'								[Disponivel],
		--		A.ID							[ID],
		--		A.Nome_Task						[Nome_Task],
		--		A.ResponderPara					[ResponderPara],
		--		'********** References ****************' + '|' +
		--		'BDP Ref.:' + TP.Num_Proc + '|' +
		--		'CSR Responsible:' + ISNULL(Nome_Usuario,'') + '|' +
		--		'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,1),'') + '|' +
		--		'Sales Order:' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,3),'')  + '|' +
		--		'Origin: ' + isnull(Org.Nome_Local,'') + '|' +
		--		'Destination: '+ isnull(DST.Nome_Local,11) + '|' +
		--		'ATD: ' + isnull(convert(varchar(20),ATD_LIA,107),'') +'|' +
		--		'ATA: ' + isnull(convert(varchar(20),ATA_LIA,107),'') +'|' +
		--		'*************************************'  + '|' +
		--		'by BDP System' 	[Mensagem_Referencia_cliente]	
				
		--	from Alerta_Email_Doc_Automatico A with(nolock) 
		--		left join Tarefas_Processos TP with(nolock) on TP.ID_Task = A.ID_Task
		--		left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on H.ID = A.ID and H.Num_Proc = Tp.Num_Proc
				
		--		Join LLP_Imp_AER LLP	with(nolock) on TP.Num_Proc=LLP.Num_Proc_Lia
		--		Join House_Imp_Aer Hou	with(nolock) on hou.num_proc_hia=Num_Proc_Lia	
		--		Join Job_Imp_Aer JOb	with (nolock) on job.Num_Proc_HIA=Num_Proc_Lia
		--		Join Usuario US			with (nolock) on US.cd_usuario=Job.cd_usuario	
		--		Join Localidade Org		with (nolock) on Org.cd_local=Cd_Org_HIA
		--		Join Localidade Dst		with (nolock) on DST.cd_local=Cd_Dst_HIA	
				
		--	where
		--		TP.dt_ins > (GETDATE() - A.Dias) 
		--		and	
		--		A.Ativo = 1
		--		and left(TP.Num_Proc,2) = A.Modal
		--		and TP.Dt_Conclusao is not null
		--		and H.dt_envio is null
			
		--UNION ALL
		----Importação Outros
		--	select 
		--		TP.Num_Proc						[JOB],
		--		A.Doc_Anexos					[Doc_Anexos],
		--		Nome_Task + ':' + TP.Num_Proc	[Assunto],
		--		''								[Doc_Anexos_Master],
		--		A.CopyBDP						[CopyBDP],
		--		A.JuntaPDF						[JuntaPDF],
		--		--A.Emails						[Emails],
		--		(case when Email_do_CompanyRegister = '1' then
		--				[dbo].[fBusca_Emal_Comunicacao](HOU.Cd_Consig_HIO,'IO%')
		--			else A.Emails	end)		[Emails],
		--		Mensagem + '||' 				[MSG],
		--		TP.Dt_Previsao					[Previsao],
		--		A.CD_Pes_Grupo					[CD_Pes_Grupo],
		--		A.Nome_Tp_Ocor					[Nome_Tp_Ocor],
		--		'N'								[Disponivel],
		--		A.ID							[ID],
		--		A.Nome_Task						[Nome_Task],
		--		A.ResponderPara					[ResponderPara],
		--		'********** References ****************' + '|' +
		--		'BDP Ref.:' + TP.Num_Proc + '|' +
		--		'CSR Responsible:' + ISNULL(Nome_Usuario,'') + '|' +
		--		'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,1),'') + '|' +
		--		'Sales Order:' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,3),'')  + '|' +
		--		'Origin: ' + isnull(Org.Nome_Local,'') + '|' +
		--		'Destination: '+ isnull(DST.Nome_Local,11) + '|' +
		--		'ATD: ' + isnull(convert(varchar(20),ATD_Lio,107),'') +'|' +
		--		'ATA: ' + isnull(convert(varchar(20),ATA_Lio,107),'') +'|' +
		--		'*************************************'  + '|' +
		--		'by BDP System' 	[Mensagem_Referencia_cliente]	
				
		--	from Alerta_Email_Doc_Automatico A with(nolock)
		--		left join Tarefas_Processos TP with(nolock) on TP.ID_Task = A.ID_Task
		--		left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on H.ID = A.ID and H.Num_Proc = Tp.Num_Proc
				
		--		Join LLP_Imp_Out LLP	with(nolock) on TP.Num_Proc=LLP.Num_Proc_Lio
		--		Join House_Imp_Out Hou	with(nolock) on hou.num_proc_hio=Num_Proc_Lio	
		--		Join Usuario US with (nolock) on US.cd_usuario=LLP.cd_usuario	
		--		Join Localidade Org		with (nolock) on Org.cd_local=cd_org_hio
		--		Join Localidade Dst		with (nolock) on DST.cd_local=cd_dst_hio			
		--	where
		--		TP.dt_ins > (GETDATE() - A.Dias) 
		--		and	
		--		A.Ativo = 1
		--		and left(TP.Num_Proc,2) = A.Modal
		--		and TP.Dt_Conclusao is not null
		--		and H.dt_envio is null


----select * from vwCliente_Alerta where num_proc= 'IMOXT201604020BR'
----select * from 
----select * from Tarefas_Processos_Alerta where num_proc= 'IMOXT201604020BR' and id_task = 67
----select * from Alerta_Email_Doc_Automatico_Historico where num_proc = 'IMOXT201604020BR' and id = 4
----Cadu- 26/2/2016 - incluido salvar todos os campos no historico, pois qdo dava erro ao enviar varios do mesmo id, 
----nao enviava nunca mais
----11-8-2016 - incluido os campo do master - CADU
--/*
--Cliente: ' Nombre corto del cliente en ATL ' sin emails registrados, JOB:
-- - No enviado
--Archivos no encontrados para adjuntar al JOB: '' , Documentos:
-- - Falla en el envío -  Sin archivos adjuntos
--*/

--ALTER procedure [dbo].[spATL_Alerta_Email_Doc_Automatico_Rel]

--AS

--select distinct
--		TP.Num_Proc						[JOB],
--		A.Doc_Anexos					[Doc_Anexos],
--		A.Doc_Anexos_Nao				[Doc_Anexos_Nao_Obrigatorios],
--		[dbo].[fBusca_Alerta_Email_Doc_Automatico]('Assunto',TP.Num_Proc,A.ID,A.Cd_Pes_Grupo,A.cd_tp_carga,
--									A.Cd_Org,A.Cd_Dst,A.cd_pes,A.modal,A.cd_tp_pedido,A.Cd_Transportadora)  [Assunto],
--		''								[Doc_Anexos_Master],
--		A.CopyBDP						[CopyBDP],
--		A.JuntaPDF						[JuntaPDF],
--		Email_do_CompanyRegister		[Email_do_CompanyRegister],	
--		(case when Email_do_CompanyRegister = 0 then '' 
--		else
--			(case when left(TP.Num_Proc,2) = 'EM' then [dbo].[fBusca_Emal_Comunicacao](LLp.cd_cliente,'EM%')
--		else
--			(case when left(TP.Num_Proc,2) = 'EA' then [dbo].[fBusca_Emal_Comunicacao](LLp.cd_cliente,'EA%')
--		else
--			(case when left(TP.Num_Proc,2) = 'EO' then [dbo].[fBusca_Emal_Comunicacao](LLp.cd_cliente,'EO%')
--		else
--			(case when left(TP.Num_Proc,2) = 'IM' then [dbo].[fBusca_Emal_Comunicacao](LLp.cd_cliente,'IM%')
--		else
--			(case when left(TP.Num_Proc,2) = 'IA' then [dbo].[fBusca_Emal_Comunicacao](LLp.cd_cliente,'IA%')
--		else
--			(case when left(TP.Num_Proc,2) = 'IO' then [dbo].[fBusca_Emal_Comunicacao](LLp.cd_cliente,'IO%')			
--		end)end)end)end)end)end)end)	[Company_Register],
--		A.Emails						[Emails],		
--		[dbo].[fBusca_Alerta_Email_Doc_Automatico]('Mensagem',TP.Num_Proc,A.ID,A.Cd_Pes_Grupo,A.cd_tp_carga,
--								A.Cd_Org,A.Cd_Dst,A.cd_pes,A.modal,A.cd_tp_pedido,A.Cd_Transportadora) + '||' [MSG],
--		TP.Dt_Previsao					[Previsao],
--		A.CD_Pes_Grupo					[CD_Pes_Grupo],
--		A.Nome_Tp_Ocor					[Nome_Tp_Ocor],
--		'N'								[Disponivel],
--		A.ID							[ID],
--		A.Nome_Task						[Nome_Task],
--		A.ResponderPara					[ResponderPara],		
--		null							[Mensagem_Referencia_cliente],				
--		CS.Apelido						[Cliente],
		
--		Email_do_Agente_Consolidado,
--		(case when Email_do_Agente_Consolidado = 0 then '' 
--		else
--			[dbo].[fBusca_Emal_Comunicacao](LLp.cd_cliente_master,'AG%')
--		end)[Company_Register_Master],		
--		--null [Company_Register_Master],	
--		CLI.Apelido				[Cliente_Master],
--		LLP.Master				[Master_JOB],		
		
--		StandardForms,
--		A.cd_tp_pedido
--		,
--		A.Cd_Pes_Grupo,
--		A.cd_tp_carga,
--		A.Cd_Org,
--		A.Cd_Dst,
--		A.cd_pes,
--		A.modal,
--		A.Cd_Transportadora,		
--		--Para mensagem qdo nao enconta o cliente HOuse e do Master
--		'Cliente: ' + CS.Apelido + ' sem emails cadastrados, JOB: ' + TP.Num_Proc [CorpoMSG],
--		'Agente: ' + CLI.Apelido + ' sem emails cadastrados, JOB: ' + LLP.Master [CorpoMSGConsolidado],
--		' - Não Enviado' [Assunto_CorpoMSG],		
--		--Para mensagem qdo nao encontra os documentos
--		'Arquivos não encontrados para serem anexados ao email, JOB: ' + TP.Num_Proc + 
--			'|Favor verificar se existem os seguintes documentos estão no JOB: | ' 
--			+ isnull([dbo].[fBusca_Alerta_Email_Doc_Automatico_Nome_Documento]
--				(A.ID,A.Cd_Pes_Grupo,A.cd_tp_carga,A.Cd_Org,A.Cd_Dst,A.cd_pes,A.modal,A.cd_tp_pedido,A.Cd_Transportadora),'')
--			[CorpoMSG_Doc_Anexos],		
--		' - Falha no envio - Sem arquivos anexados' [Assunto_CorpoMSG_Doc_Anexos]
		
--		--,LLP.Cd_Transportadora [teste]
		
--from Tarefas_Processos_Alerta	TP with(nolock)
--	Join vwCliente_Alerta	LLP  with (nolock)on TP.Num_Proc = LLP.num_proc	
--	join pessoa				CS  with(nolock) on CS.Cd_Pes = LLP.cd_cliente
--	join Pessoa_LLP			PLL with(nolock) on PLL.Cd_Pes=LLP.cd_cliente	
--	Join Usuario			US	with (nolock) on US.cd_usuario=LLP.cd_usuario	
--	Join Localidade			Org	with (nolock) on Org.cd_local=LLP.Cd_Org
--	Join Localidade			Dst	with (nolock) on DST.cd_local=LLP.Cd_Dst
--	--join Tipo_tarefas		TT with(nolock) on TT.ID_Task = Tp.Id_Task
--	join Alerta_Email_Doc_Automatico A with(nolock) on A.ID_Task = TP.ID_Task and A.Modal = LEFT(TP.Num_Proc,2)
--	left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on H.ID = A.ID and H.Num_Proc = Tp.Num_Proc
	
--	--left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on H.ID = A.ID and H.Num_Proc = Tp.Num_Proc
--	--and H.cd_tp_pedido = A.cd_tp_pedido and H.Cd_Pes_Grupo = A.Cd_Pes_Grupo and
--	--	H.cd_tp_carga = A.cd_tp_carga and H.Cd_Org = A.Cd_Org and H.Cd_Dst = A.Cd_Dst and
--	--	H.cd_pes = A.cd_pes and H.modal = A.modal 
	
--	left Join Pedido_Ship PS  with(nolock) on PS.num_proc=TP.Num_Proc
--	left Join Pedido P with(nolock) on P.cd_pedido=PS.cd_pedido	
--	left join Pessoa CLI with(nolock) on CLI.Cd_Pes = LLP.cd_cliente_master		
--where	
--	--tp.Num_Proc = 'IMOXT201604020BR' and
--	(PLL.cd_pes_grupo = A.Cd_Pes_Grupo)-- or A.Cd_Pes_Grupo = '10017')
--	and TP.dt_ins >= (GETDATE() - A.Dias) 
--	--nao sei se posso alterar isso
--	--and (convert(date,TP.dt_ins)) >= convert(date,(GETDATE() - A.Dias)) 
	
--	and	A.Ativo = 1	
--	and TP.Dt_Conclusao is not null
--	and H.dt_envio is null
	
--	--and H.cd_tp_pedido is null
--	--and H.Cd_Pes_Grupo is null
--	--and H.cd_tp_carga is null
--	--and H.Cd_Org is null
--	--and H.Cd_Dst is null
--	--and H.cd_pes is null
--	--and H.modal is null
	
--	and ((A.cd_tp_carga = 0 and LLp.Cd_Tp_Carga <> 0)
--	or (A.cd_tp_carga = LLp.Cd_Tp_Carga))
	
--	and (
--		(A.Cd_Org = LLP.cd_org and A.Cd_Dst = LLP.Cd_Dst)
--		or		
--		(A.Cd_Org = 'ALL'  and A.Cd_Dst= 'ALL')		
--		or 
--		(A.Cd_Org = 'ALL' and A.Cd_Dst = LLP.Cd_Dst)
--		or
--		(A.Cd_Dst= 'ALL' and  A.Cd_Org = LLP.cd_org)
--		)
		
--	and ((A.cd_tp_pedido = '1' and '0' not in ('2','3','4'))
--	or (A.cd_tp_pedido = isnull(P.Cd_tipo,'0')))
	
--	and ((A.cd_pes = 'ALL' and CS.Cd_Pes <> 'ALL')
--	or (A.cd_pes = CS.Cd_Pes))
	
--	And ((A.Email_do_Agente_Consolidado = 1 and LLP.Master <> 'JOB') or
--		(A.Email_do_Agente_Consolidado = 0 and LLP.Master is not null))
	
--	and ((A.Cd_Transportadora = 'ALL' and isnull(LLP.Cd_Transportadora,'') <> 'ALL')
--	or (A.Cd_Transportadora = LLP.Cd_Transportadora))
	
--	option(hash join)
				
		
--/*

--		--Exportação Maritima
--			select Distinct
--				TP.Num_Proc						[JOB],
--				A.Doc_Anexos					[Doc_Anexos],
--				A.Doc_Anexos_Nao				[Doc_Anexos_Nao_Obrigatorios],
--				[dbo].[fBusca_Alerta_Email_Doc_Automatico_Assunto](TP.Num_Proc,A.ID)  [Assunto],
--				''								[Doc_Anexos_Master],
--				A.CopyBDP						[CopyBDP],
--				A.JuntaPDF						[JuntaPDF],
--				Email_do_CompanyRegister		[Email_do_CompanyRegister],	
--				(case when Email_do_CompanyRegister = 0 
--					then '' 
--				else
--					[dbo].[fBusca_Emal_Comunicacao](HOU.Cd_Export_HEM,'EM%')
--				end) [Company_Register],
--				A.Emails						[Emails],
--				--Mensagem + '||' 				[MSG],
--				[dbo].[fBusca_Alerta_Email_Doc_Automatico_Corpo](TP.Num_Proc,A.ID) + '||' [MSG],
--				TP.Dt_Previsao					[Previsao],
--				A.CD_Pes_Grupo					[CD_Pes_Grupo],
--				A.Nome_Tp_Ocor					[Nome_Tp_Ocor],
--				'N'								[Disponivel],
--				A.ID							[ID],
--				A.Nome_Task						[Nome_Task],
--				A.ResponderPara					[ResponderPara],
--				--comeco pulando umas 5 linhas
--				'********** References ****************' + '|' +
--				'BDP Ref.:' + TP.Num_Proc + '|' +
--				'CSR Responsible:' + ISNULL(Nome_Usuario,'') + '|' +
--				'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,1),'') + '|' +
--				'Sales Order:' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,3),'')  + '|' +
--				'Origin: ' + isnull(Org.Nome_Local,'') + '|' +
--				'Destination: '+ isnull(DST.Nome_Local,11) + '|' +
--				'ATD: ' + isnull(convert(varchar(20),ATD_LEM,107),'') +'|' +
--				'ATA: ' + isnull(convert(varchar(20),ATA_LEM,107),'') +'|' +
--				'*************************************'  + '|' +
--				'by BDP System' 	[Mensagem_Referencia_cliente],		
						
--				CS.Apelido							[Cliente]		
--		from Tarefas_Processos_Alerta		TP with(nolock)
--			join Tipo_tarefas		TT with(nolock) on TT.ID_Task = Tp.Id_Task
--			left join Alerta_Email_Doc_Automatico A with(nolock) on A.ID_Task = TP.ID_Task	and A.Modal = TT.Modal
--			left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on H.ID = A.ID and H.Num_Proc = Tp.Num_Proc		
--			Join LLP_Exp_Mar		LLP	with(nolock) on TP.Num_Proc=LLP.Num_Proc_Lem
--			Join House_Exp_Mar		Hou	with(nolock) on hou.Num_Proc_HEM=Num_Proc_Lem
--			left join pessoa		CS  with(nolock) on CS.cd_pes=HOU.Cd_Export_HEM
--			left join Pessoa_LLP	PLL with(nolock) on PLL.Cd_Pes=HOU.Cd_Export_HEM	
--			left join Grupo			G	with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
--			left join pessoa		PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo	
--			Join Job_Exp_Mar		JOb	with (nolock) on job.Num_Proc_HEM=Num_Proc_Lem
--			Join Usuario			US	with (nolock) on US.cd_usuario=Job.cd_usuario	
--			Join Localidade			Org	with (nolock) on Org.cd_local=Cd_Org_HEM
--			Join Localidade			Dst	with (nolock) on DST.cd_local=Cd_Dst_HEM		
--		where	
--			(PLL.cd_pes_grupo = A.Cd_Pes_Grupo or A.Cd_Pes_Grupo = '10017')
--			and TP.dt_ins > (GETDATE() - A.Dias) 
--			and	A.Ativo = 1
--			and left(TP.Num_Proc,2) = A.Modal
--			and TP.Dt_Conclusao is not null
--			and H.dt_envio is null
			
--			and ((A.cd_tp_carga = 0 and LLp.Cd_Tp_Carga <> 0)
--			or (A.cd_tp_carga = LLp.Cd_Tp_Carga))
			
--		UNION ALL
--		--Exportação Aerea
--			select 
--				TP.Num_Proc						[JOB],
--				A.Doc_Anexos					[Doc_Anexos],
--				A.Doc_Anexos_Nao				[Doc_Anexos_Nao_Obrigatorios],
--				--A.Nome_Task + ':' + TP.Num_Proc	[Assunto],
--				[dbo].[fBusca_Alerta_Email_Doc_Automatico_Assunto](TP.Num_Proc,A.ID)  [Assunto],
--				''								[Doc_Anexos_Master],
--				A.CopyBDP						[CopyBDP],
--				A.JuntaPDF						[JuntaPDF],		
--				Email_do_CompanyRegister		[Email_do_CompanyRegister],	
--				(case when Email_do_CompanyRegister = 0 
--					then '' 
--				else		
--				[dbo].[fBusca_Emal_Comunicacao](HOU.Cd_Export_HEA,'EA%')
--				End) [Company_Register],
--				A.Emails						[Emails],
--				--A.Emails						[Emails],
--				--(case when A.Email_do_CompanyRegister = '1' then
--				--	[dbo].[fBusca_Emal_Comunicacao](HOU.Cd_Export_HEA,'EA%') + ';' + A.Emails
--				--	else A.Emails	end)		[Emails],
--				--Mensagem + '||' 				[MSG],
--				[dbo].[fBusca_Alerta_Email_Doc_Automatico_Corpo](TP.Num_Proc,A.ID) + '||' [MSG],
--				TP.Dt_Previsao					[Previsao],
--				A.CD_Pes_Grupo					[CD_Pes_Grupo],
--				A.Nome_Tp_Ocor					[Nome_Tp_Ocor],
--				'N'								[Disponivel],
--				A.ID							[ID],
--				A.Nome_Task						[Nome_Task],
--				A.ResponderPara					[ResponderPara],
--				'********** References ****************' + '|' +
--				'BDP Ref.:' + TP.Num_Proc + '|' +
--				'CSR Responsible:' + ISNULL(Nome_Usuario,'') + '|' +
--				'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,1),'') + '|' +
--				'Sales Order:' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,3),'')  + '|' +
--				'Origin: ' + isnull(Org.Nome_Local,'') + '|' +
--				'Destination: '+ isnull(DST.Nome_Local,11) + '|' +
--				'ATD: ' + isnull(convert(varchar(20),ATD_LEA,107),'') +'|' +
--				'ATA: ' + isnull(convert(varchar(20),ATA_LEA,107),'') +'|' +
--				'*************************************'  + '|' +
--				'by BDP System' 	[Mensagem_Referencia_cliente],
--				CS.Apelido							[Cliente]
--		from Tarefas_Processos_Alerta		TP with(nolock)
--			join Tipo_tarefas		TT with(nolock) on TT.ID_Task = Tp.Id_Task
--			left join Alerta_Email_Doc_Automatico A with(nolock) on A.ID_Task = TP.ID_Task	and A.Modal = TT.Modal
--			left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on H.ID = A.ID and H.Num_Proc = Tp.Num_Proc		
--			Join LLP_Exp_Aer		LLP	with(nolock) on TP.Num_Proc=LLP.Num_Proc_Lea
--			Join House_Exp_Aer		Hou	with(nolock) on hou.Num_Proc_HEA=Num_Proc_Lea
--			left join pessoa		CS  with(nolock) on CS.cd_pes=HOU.Cd_Export_Hea
--			left join Pessoa_LLP	PLL with(nolock) on PLL.Cd_Pes=HOU.Cd_Export_Hea	
--			left join Grupo			G	with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
--			left join pessoa		PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo	
--			Join Job_Exp_Aer		JOb	with (nolock) on job.Num_Proc_Hea=Num_Proc_Lea
--			Join Usuario			US	with (nolock) on US.cd_usuario=Job.cd_usuario	
--			Join Localidade			Org	with (nolock) on Org.cd_local=Cd_Org_Hea
--			Join Localidade			Dst	with (nolock) on DST.cd_local=Cd_Dst_Hea		
--		where	
--			(PLL.cd_pes_grupo = A.Cd_Pes_Grupo or A.Cd_Pes_Grupo = '10017')
--			and TP.dt_ins > (GETDATE() - A.Dias) 
--			and	A.Ativo = 1
--			and left(TP.Num_Proc,2) = A.Modal
--			and TP.Dt_Conclusao is not null
--			and H.dt_envio is null
			
--		UNION ALL
--		--Exportação Outros
--			select distinct
--				TP.Num_Proc						[JOB],
--				A.Doc_Anexos					[Doc_Anexos],
--				A.Doc_Anexos_Nao				[Doc_Anexos_Nao_Obrigatorios],
--				--A.Nome_Task + ':' + TP.Num_Proc	[Assunto],
--				[dbo].[fBusca_Alerta_Email_Doc_Automatico_Assunto](TP.Num_Proc,A.ID)  [Assunto],
--				''								[Doc_Anexos_Master],
--				A.CopyBDP						[CopyBDP],
--				A.JuntaPDF						[JuntaPDF],
--				Email_do_CompanyRegister		[Email_do_CompanyRegister],
--				(case when Email_do_CompanyRegister = 0 
--					then '' 
--				else			
--				[dbo].[fBusca_Emal_Comunicacao](HOU.Cd_Export_HEO,'EO%')
--				End) [Company_Register],
--				A.Emails						[Emails],
--				--Mensagem + '||' 				[MSG],
--				[dbo].[fBusca_Alerta_Email_Doc_Automatico_Corpo](TP.Num_Proc,A.ID) + '||' [MSG],
--				TP.Dt_Previsao					[Previsao],
--				A.CD_Pes_Grupo					[CD_Pes_Grupo],
--				A.Nome_Tp_Ocor					[Nome_Tp_Ocor],
--				'N'								[Disponivel],
--				A.ID							[ID],
--				A.Nome_Task						[Nome_Task],
--				A.ResponderPara					[ResponderPara],
--				'********** References ****************' + '|' +
--				'BDP Ref.:' + TP.Num_Proc + '|' +
--				'CSR Responsible:' + ISNULL(Nome_Usuario,'') + '|' +
--				'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,1),'') + '|' +
--				'Sales Order:' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,3),'')  + '|' +
--				'Origin: ' + isnull(Org.Nome_Local,'') + '|' +
--				'Destination: '+ isnull(DST.Nome_Local,11) + '|' +
--				'ATD: ' + isnull(convert(varchar(20),ATD_LEO,107),'') +'|' +
--				'ATA: ' + isnull(convert(varchar(20),ATA_Leo,107),'') +'|' +
--				'*************************************'  + '|' +
--				'by BDP System' 	[Mensagem_Referencia_cliente],
--				CS.Apelido							[Cliente]
--		from Tarefas_Processos_Alerta		TP with(nolock)
--			join Tipo_tarefas		TT with(nolock) on TT.ID_Task = Tp.Id_Task
--			left join Alerta_Email_Doc_Automatico A with(nolock) on A.ID_Task = TP.ID_Task	and A.Modal = TT.Modal
--			left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on H.ID = A.ID and H.Num_Proc = Tp.Num_Proc		
--			Join LLP_Exp_Out		LLP	with(nolock) on TP.Num_Proc=LLP.Num_Proc_Leo
--			Join House_Exp_Out		Hou	with(nolock) on hou.Num_Proc_HEo=Num_Proc_Leo
--			left join pessoa		CS  with(nolock) on CS.cd_pes=HOU.Cd_Export_HEO
--			left join Pessoa_LLP	PLL with(nolock) on PLL.Cd_Pes=HOU.Cd_Export_HEO	
--			left join Grupo			G	with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
--			left join pessoa		PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo	
--			Join Usuario			US	with (nolock) on US.cd_usuario=LLP.cd_usuario		
--			Join Localidade			Org	with (nolock) on Org.cd_local=Cd_Org_HEO
--			Join Localidade			Dst	with (nolock) on DST.cd_local=Cd_Dst_HEO		
--		where	
--			(PLL.cd_pes_grupo = A.Cd_Pes_Grupo or A.Cd_Pes_Grupo = '10017')
--			and TP.dt_ins > (GETDATE() - A.Dias) 
--			and	A.Ativo = 1
--			and left(TP.Num_Proc,2) = A.Modal
--			and TP.Dt_Conclusao is not null
--			and H.dt_envio is null
--		UNION ALL	
			
--		--Importação Maritima
--			select distinct
--				TP.Num_Proc						[JOB],
--				A.Doc_Anexos					[Doc_Anexos],
--				A.Doc_Anexos_Nao				[Doc_Anexos_Nao_Obrigatorios],
--				--A.Nome_Task + ':' + TP.Num_Proc	[Assunto],
--				[dbo].[fBusca_Alerta_Email_Doc_Automatico_Assunto](TP.Num_Proc,A.ID)  [Assunto],
--				''								[Doc_Anexos_Master],
--				A.CopyBDP						[CopyBDP],
--				A.JuntaPDF						[JuntaPDF],
--				Email_do_CompanyRegister		[Email_do_CompanyRegister],	
--				(case when Email_do_CompanyRegister = 0 
--					then '' 
--				else		
--					[dbo].[fBusca_Emal_Comunicacao](HOU.Cd_Consig_HIM,'IM%')
--				End) [Company_Register],
--				A.Emails						[Emails],
--				--Mensagem + '||' 				[MSG],
--				[dbo].[fBusca_Alerta_Email_Doc_Automatico_Corpo](TP.Num_Proc,A.ID) + '||' [MSG],
--				TP.Dt_Previsao					[Previsao],
--				A.CD_Pes_Grupo					[CD_Pes_Grupo],
--				A.Nome_Tp_Ocor					[Nome_Tp_Ocor],
--				'N'								[Disponivel],
--				A.ID							[ID],
--				A.Nome_Task						[Nome_Task],
--				A.ResponderPara					[ResponderPara],
--				'********** References ****************' + '|' +
--				'BDP Ref.:' + TP.Num_Proc + '|' +
--				'CSR Responsible:' + ISNULL(Nome_Usuario,'') + '|' +
--				'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,1),'') + '|' +
--				'Sales Order:' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,3),'')  + '|' +
--				'Origin: ' + isnull(Org.Nome_Local,'') + '|' +
--				'Destination: '+ isnull(DST.Nome_Local,'') + '|' +
--				'ATD: ' + isnull(convert(varchar(20),ATD_LiM,107),'') +'|' +
--				'ATA: ' + isnull(convert(varchar(20),ATA_LiM,107),'') +'|' +
--				'*************************************'  + '|' +
--				'by BDP System' 	[Mensagem_Referencia_cliente],
--				CS.Apelido							[Cliente]
--		from Tarefas_Processos_Alerta		TP with(nolock)
--			join Tipo_tarefas		TT with(nolock) on TT.ID_Task = Tp.Id_Task
--			left join Alerta_Email_Doc_Automatico A with(nolock) on A.ID_Task = TP.ID_Task	and A.Modal = TT.Modal
--			left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on H.ID = A.ID and H.Num_Proc = Tp.Num_Proc		
--			Join LLP_Imp_Mar		LLP	with(nolock) on TP.Num_Proc=LLP.Num_Proc_Lim
--			Join House_Imp_Mar		Hou	with(nolock) on hou.Num_Proc_HiM=Num_Proc_Lim
--			left join Pessoa_LLP	PLL with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HiM
--			left join pessoa		CS  with(nolock) on CS.cd_pes=HOU.Cd_Consig_HIM
--			left join Grupo			G	with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
--			left join pessoa		PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo	
--			Join Job_Imp_Mar		JOb	with (nolock) on job.Num_Proc_HiM=Num_Proc_Lim
--			Join Usuario			US	with (nolock) on US.cd_usuario=Job.cd_usuario	
--			Join Localidade			Org	with (nolock) on Org.cd_local=Cd_Org_him
--			Join Localidade			Dst	with (nolock) on DST.cd_local=Cd_Dst_HiM		
--		where	
--			(PLL.cd_pes_grupo = A.Cd_Pes_Grupo or A.Cd_Pes_Grupo = '10017')
--			and TP.dt_ins > (GETDATE() - A.Dias) 
--			and	A.Ativo = 1
--			and left(TP.Num_Proc,2) = A.Modal
--			and TP.Dt_Conclusao is not null
--			and H.dt_envio is null
				
--			and ((A.cd_tp_carga = 0 and LLp.Cd_Tp_Carga <> 0)
--			or (A.cd_tp_carga = LLp.Cd_Tp_Carga))
			
--		UNION ALL
--		--Importação Aerea
--			select distinct
--				TP.Num_Proc						[JOB],
--				A.Doc_Anexos					[Doc_Anexos],
--				A.Doc_Anexos_Nao				[Doc_Anexos_Nao_Obrigatorios],
--				--A.Nome_Task + ':' + TP.Num_Proc	[Assunto],
--				[dbo].[fBusca_Alerta_Email_Doc_Automatico_Assunto](TP.Num_Proc,A.ID)  [Assunto],
--				''								[Doc_Anexos_Master],
--				A.CopyBDP						[CopyBDP],
--				A.JuntaPDF						[JuntaPDF],
--				Email_do_CompanyRegister		[Email_do_CompanyRegister],	
--				(case when Email_do_CompanyRegister = 0 
--					then '' 
--				else		
--					[dbo].[fBusca_Emal_Comunicacao](HOU.Cd_Consig_HIA,'IA%')
--				End) [Company_Register],
--				A.Emails						[Emails],
--				--Mensagem + '||' 				[MSG],
--				[dbo].[fBusca_Alerta_Email_Doc_Automatico_Corpo](TP.Num_Proc,A.ID) + '||' [MSG],
--				TP.Dt_Previsao					[Previsao],
--				A.CD_Pes_Grupo					[CD_Pes_Grupo],
--				A.Nome_Tp_Ocor					[Nome_Tp_Ocor],
--				'N'								[Disponivel],
--				A.ID							[ID],
--				A.Nome_Task						[Nome_Task],
--				A.ResponderPara					[ResponderPara],
--				'********** References ****************' + '|' +
--				'BDP Ref.:' + TP.Num_Proc + '|' +
--				'CSR Responsible:' + ISNULL(Nome_Usuario,'') + '|' +
--				'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,1),'') + '|' +
--				'Sales Order:' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,3),'')  + '|' +
--				'Origin: ' + isnull(Org.Nome_Local,'') + '|' +
--				'Destination: '+ isnull(DST.Nome_Local,11) + '|' +
--				'ATD: ' + isnull(convert(varchar(20),ATD_LIA,107),'') +'|' +
--				'ATA: ' + isnull(convert(varchar(20),ATA_LIA,107),'') +'|' +
--				'*************************************'  + '|' +
--				'by BDP System' 	[Mensagem_Referencia_cliente],
--				CS.Apelido							[Cliente]
--		from Tarefas_Processos_Alerta		TP with(nolock)
--			join Tipo_tarefas		TT with(nolock) on TT.ID_Task = Tp.Id_Task
--			left join Alerta_Email_Doc_Automatico A with(nolock) on A.ID_Task = TP.ID_Task	and A.Modal = TT.Modal
--			left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on H.ID = A.ID and H.Num_Proc = Tp.Num_Proc		
--			Join LLP_Imp_Aer		LLP	with(nolock) on TP.Num_Proc=LLP.Num_Proc_Lia
--			Join House_Imp_Aer		Hou	with(nolock) on hou.Num_Proc_HIA=Num_Proc_Lia
--			left join pessoa		CS  with(nolock) on CS.cd_pes=HOU.Cd_Consig_HIa
--			left join Pessoa_LLP	PLL with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_Hia	
--			left join Grupo			G	with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
--			left join pessoa		PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo	
--			Join Job_Imp_Aer		JOb	with (nolock) on job.Num_Proc_Hia=Num_Proc_Lia
--			Join Usuario			US	with (nolock) on US.cd_usuario=Job.cd_usuario	
--			Join Localidade			Org	with (nolock) on Org.cd_local=Cd_Org_Hia
--			Join Localidade			Dst	with (nolock) on DST.cd_local=Cd_Dst_Hia		
--		where	
--			(PLL.cd_pes_grupo = A.Cd_Pes_Grupo or A.Cd_Pes_Grupo = '10017')
--			and TP.dt_ins > (GETDATE() - A.Dias) 
--			and	A.Ativo = 1
--			and left(TP.Num_Proc,2) = A.Modal
--			and TP.Dt_Conclusao is not null
--			and H.dt_envio is null
			
--		UNION ALL
--		--Importação Outros
--			select 
--				TP.Num_Proc						[JOB],
--				A.Doc_Anexos					[Doc_Anexos],
--				A.Doc_Anexos_Nao				[Doc_Anexos_Nao_Obrigatorios],
--				--A.Nome_Task + ':' + TP.Num_Proc	[Assunto],
--				[dbo].[fBusca_Alerta_Email_Doc_Automatico_Assunto](TP.Num_Proc,A.ID)  [Assunto],
--				''								[Doc_Anexos_Master],
--				A.CopyBDP						[CopyBDP],
--				A.JuntaPDF						[JuntaPDF],
--				Email_do_CompanyRegister		[Email_do_CompanyRegister],			
--				(case when Email_do_CompanyRegister = 0 
--					then '' 
--				else
--					[dbo].[fBusca_Emal_Comunicacao](HOU.Cd_Consig_HIO,'IO%')
--				END) [Company_Register],
--				A.Emails						[Emails],
--				--Mensagem + '||' 				[MSG],
--				[dbo].[fBusca_Alerta_Email_Doc_Automatico_Corpo](TP.Num_Proc,A.ID) + '||' [MSG],
--				TP.Dt_Previsao					[Previsao],
--				A.CD_Pes_Grupo					[CD_Pes_Grupo],
--				A.Nome_Tp_Ocor					[Nome_Tp_Ocor],
--				'N'								[Disponivel],
--				A.ID							[ID],
--				A.Nome_Task						[Nome_Task],
--				A.ResponderPara					[ResponderPara],
--				'********** References ****************' + '|' +
--				'BDP Ref.:' + TP.Num_Proc + '|' +
--				'CSR Responsible:' + ISNULL(Nome_Usuario,'') + '|' +
--				'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,1),'') + '|' +
--				'Sales Order:' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,3),'')  + '|' +
--				'Origin: ' + isnull(Org.Nome_Local,'') + '|' +
--				'Destination: '+ isnull(DST.Nome_Local,11) + '|' +
--				'ATD: ' + isnull(convert(varchar(20),ATD_Lio,107),'') +'|' +
--				'ATA: ' + isnull(convert(varchar(20),ATA_Lio,107),'') +'|' +
--				'*************************************'  + '|' +
--				'by BDP System' 	[Mensagem_Referencia_cliente],
--				CS.Apelido							[Cliente]	
--		from Tarefas_Processos_Alerta TP with(nolock)
--			join Tipo_tarefas		TT with(nolock) on TT.ID_Task = Tp.Id_Task
--			left join Alerta_Email_Doc_Automatico A with(nolock) on A.ID_Task = TP.ID_Task	and A.Modal = TT.Modal
--			left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on H.ID = A.ID and H.Num_Proc = Tp.Num_Proc		
--			Join LLP_Imp_Out		LLP	with(nolock) on TP.Num_Proc=LLP.Num_Proc_Lio
--			Join House_Imp_Out		Hou	with(nolock) on hou.Num_Proc_Hio=Num_Proc_Lio
--			left join pessoa		CS  with(nolock) on CS.cd_pes=HOU.Cd_Consig_HIO
--			left join Pessoa_LLP	PLL with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIO	
--			left join Grupo			G	with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
--			left join pessoa		PG  with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo	
--			Join Usuario			US	with (nolock) on US.cd_usuario=LLP.cd_usuario		
--			Join Localidade			Org	with (nolock) on Org.cd_local=Cd_Org_HiO
--			Join Localidade			Dst	with (nolock) on DST.cd_local=Cd_Dst_HiO		
--		where	
--			(PLL.cd_pes_grupo = A.Cd_Pes_Grupo or A.Cd_Pes_Grupo = '10017')
--			and TP.dt_ins > (GETDATE() - A.Dias) 
--			and	A.Ativo = 1
--			and left(TP.Num_Proc,2) = A.Modal
--			and TP.Dt_Conclusao is not null
--			and H.dt_envio is null
			
--		*/
				
--		--******************Nao foi necessario, pois fiz novatabela pra tarefas processos**********
--		--alter table [dbo].[TAREFAS_PROCESSOS] add [dt_ins] datetime null
--		--spTaskProc_Upd
--		--spTaskProcImport_Upd
--		--spTaskProc_LerXML_Upd
--		--spTask_Upd

--		--select * from Alerta_Email_Doc_Automatico
--		--[dbo].[fBusca_Emal_Comunicacao](HOU.cd_consig_him,'IM%')
--		--Email_do_CompanyRegister

--		--select * from Tarefas_Processos where dt_ins > GETDATE() -1
--		--*************************Stored antiga**********************************

--		--Exportação Maritima
--		--	select 
--		--		TP.Num_Proc						[JOB],
--		--		A.Doc_Anexos					[Doc_Anexos],
--		--		Nome_Task + ':' + TP.Num_Proc	[Assunto],
--		--		''								[Doc_Anexos_Master],
--		--		A.CopyBDP						[CopyBDP],
--		--		A.JuntaPDF						[JuntaPDF],
--		--		(case when Email_do_CompanyRegister = '1' then
--		--			[dbo].[fBusca_Emal_Comunicacao](HOU.Cd_Export_HEM,'EM%')
--		--			else A.Emails	end)		[Emails],
--		--		Mensagem + '||' 				[MSG],
--		--		TP.Dt_Previsao					[Previsao],
--		--		A.CD_Pes_Grupo					[CD_Pes_Grupo],
--		--		A.Nome_Tp_Ocor					[Nome_Tp_Ocor],
--		--		'N'								[Disponivel],
--		--		A.ID							[ID],
--		--		A.Nome_Task						[Nome_Task],
--		--		A.ResponderPara					[ResponderPara],
--		--		--comeco pulando umas 5 linhas
--		--		'********** References ****************' + '|' +
--		--		'BDP Ref.:' + TP.Num_Proc + '|' +
--		--		'CSR Responsible:' + ISNULL(Nome_Usuario,'') + '|' +
--		--		'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,1),'') + '|' +
--		--		'Sales Order:' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,3),'')  + '|' +
--		--		'Origin: ' + isnull(Org.Nome_Local,'') + '|' +
--		--		'Destination: '+ isnull(DST.Nome_Local,11) + '|' +
--		--		'ATD: ' + isnull(convert(varchar(20),ATD_LEM,107),'') +'|' +
--		--		'ATA: ' + isnull(convert(varchar(20),ATA_LEM,107),'') +'|' +
--		--		'*************************************'  + '|' +
--		--		'by BDP System' 	[Mensagem_Referencia_cliente]	
				
--		--	from Alerta_Email_Doc_Automatico A
--		--		left join Tarefas_Processos TP with(nolock) on  TP.ID_Task = A.ID_Task
--		--		left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on  H.ID = A.ID and H.Num_Proc = Tp.Num_Proc	
				
--		--		Join LLP_Exp_Mar LLP	with(nolock) on TP.Num_Proc=LLP.Num_Proc_Lem
--		--		Join House_Exp_Mar Hou	with(nolock) on hou.num_proc_hem=Num_Proc_Lem	
--		--		Join Job_Exp_Mar JOb	with (nolock) on job.num_proc_hem=num_proc_lem
--		--		Join Usuario US			with (nolock) on US.cd_usuario=Job.cd_usuario	
--		--		Join Localidade Org		with (nolock) on Org.cd_local=cd_org_hem
--		--		Join Localidade Dst		with (nolock) on DST.cd_local=cd_dst_hem	
				
--		--	where
--		--		TP.dt_ins > (GETDATE() - A.Dias) 
--		--		and	
--		--		A.Ativo = 1
--		--		and left(TP.Num_Proc,2) = A.Modal
--		--		and TP.Dt_Conclusao is not null
--		--		and H.dt_envio is null	
--		--UNION ALL
--		----Exportação Aerea
--		--	select 
--		--		TP.Num_Proc						[JOB],
--		--		A.Doc_Anexos					[Doc_Anexos],
--		--		Nome_Task + ':' + TP.Num_Proc	[Assunto],
--		--		''								[Doc_Anexos_Master],
--		--		A.CopyBDP						[CopyBDP],
--		--		A.JuntaPDF						[JuntaPDF],
--		--		--A.Emails						[Emails],
--		--		(case when Email_do_CompanyRegister = '1' then
--		--			[dbo].[fBusca_Emal_Comunicacao](HOU.Cd_Export_HEA,'EA%')
--		--			else A.Emails	end)		[Emails],
--		--		Mensagem + '||' 				[MSG],
--		--		TP.Dt_Previsao					[Previsao],
--		--		A.CD_Pes_Grupo					[CD_Pes_Grupo],
--		--		A.Nome_Tp_Ocor					[Nome_Tp_Ocor],
--		--		'N'								[Disponivel],
--		--		A.ID							[ID],
--		--		A.Nome_Task						[Nome_Task],
--		--		A.ResponderPara					[ResponderPara],
--		--		'********** References ****************' + '|' +
--		--		'BDP Ref.:' + TP.Num_Proc + '|' +
--		--		'CSR Responsible:' + ISNULL(Nome_Usuario,'') + '|' +
--		--		'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,1),'') + '|' +
--		--		'Sales Order:' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,3),'')  + '|' +
--		--		'Origin: ' + isnull(Org.Nome_Local,'') + '|' +
--		--		'Destination: '+ isnull(DST.Nome_Local,11) + '|' +
--		--		'ATD: ' + isnull(convert(varchar(20),ATD_LEA,107),'') +'|' +
--		--		'ATA: ' + isnull(convert(varchar(20),ATA_LEA,107),'') +'|' +
--		--		'*************************************'  + '|' +
--		--		'by BDP System' 	[Mensagem_Referencia_cliente]	
				
--		--	from Alerta_Email_Doc_Automatico A
--		--		left join Tarefas_Processos TP with(nolock) on  TP.ID_Task = A.ID_Task
--		--		left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on  H.ID = A.ID and H.Num_Proc = Tp.Num_Proc
				
--		--		Join LLP_Exp_AER LLP	with(nolock) on TP.Num_Proc=LLP.Num_Proc_Lea
--		--		Join House_Exp_AER Hou	with(nolock) on hou.num_proc_hea=Num_Proc_Lea	
--		--		Join Job_Exp_AER JOb	with (nolock) on job.Num_Proc_HEA=num_proc_lea
--		--		Join Usuario US			with (nolock) on US.cd_usuario=Job.cd_usuario	
--		--		Join Localidade Org		with (nolock) on Org.cd_local=Cd_Org_HEA
--		--		Join Localidade Dst		with (nolock) on DST.cd_local=Cd_Dst_HEA	
				
--		--	where
--		--		TP.dt_ins > (GETDATE() - A.Dias) 
--		--		and	
--		--		A.Ativo = 1
--		--		and left(TP.Num_Proc,2) = A.Modal
--		--		and TP.Dt_Conclusao is not null
--		--		and H.dt_envio is null	
--		--UNION ALL
--		----Exportação Outros
--		--	select 
--		--		TP.Num_Proc						[JOB],
--		--		A.Doc_Anexos					[Doc_Anexos],
--		--		Nome_Task + ':' + TP.Num_Proc	[Assunto],
--		--		''								[Doc_Anexos_Master],
--		--		A.CopyBDP						[CopyBDP],
--		--		A.JuntaPDF						[JuntaPDF],
--		--		--A.Emails						[Emails],
--		--		(case when Email_do_CompanyRegister = '1' then
--		--			[dbo].[fBusca_Emal_Comunicacao](HOU.Cd_Export_HEO,'EO%')
--		--			else A.Emails	end)		[Emails],
--		--		Mensagem + '||' 				[MSG],
--		--		TP.Dt_Previsao					[Previsao],
--		--		A.CD_Pes_Grupo					[CD_Pes_Grupo],
--		--		A.Nome_Tp_Ocor					[Nome_Tp_Ocor],
--		--		'N'								[Disponivel],
--		--		A.ID							[ID],
--		--		A.Nome_Task						[Nome_Task],
--		--		A.ResponderPara					[ResponderPara],
--		--		'********** References ****************' + '|' +
--		--		'BDP Ref.:' + TP.Num_Proc + '|' +
--		--		'CSR Responsible:' + ISNULL(Nome_Usuario,'') + '|' +
--		--		'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,1),'') + '|' +
--		--		'Sales Order:' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,3),'')  + '|' +
--		--		'Origin: ' + isnull(Org.Nome_Local,'') + '|' +
--		--		'Destination: '+ isnull(DST.Nome_Local,11) + '|' +
--		--		'ATD: ' + isnull(convert(varchar(20),ATD_LEO,107),'') +'|' +
--		--		'ATA: ' + isnull(convert(varchar(20),ATA_Leo,107),'') +'|' +
--		--		'*************************************'  + '|' +
--		--		'by BDP System' 	[Mensagem_Referencia_cliente]	
				
--		--	from Alerta_Email_Doc_Automatico A with(nolock) 
--		--		left join Tarefas_Processos TP with(nolock) on  TP.ID_Task = A.ID_Task
--		--		left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on  H.ID = A.ID and H.Num_Proc = Tp.Num_Proc	
				
--		--		Join LLP_Exp_Out LLP	with(nolock) on TP.Num_Proc=LLP.Num_Proc_Leo
--		--		Join House_Exp_Out Hou	with(nolock) on hou.num_proc_heo=Num_Proc_Leo	
--		--		Join Usuario US			with (nolock) on US.cd_usuario=LLP.cd_usuario	
--		--		Join Localidade Org		with (nolock) on Org.cd_local=cd_org_heo
--		--		Join Localidade Dst		with (nolock) on DST.cd_local=cd_dst_heo	
				
--		--	where
--		--		TP.dt_ins > (GETDATE() - A.Dias) 
--		--		and	
--		--		A.Ativo = 1
--		--		and left(TP.Num_Proc,2) = A.Modal
--		--		and TP.Dt_Conclusao is not null
--		--		and H.dt_envio is null
			
			
--		--UNION ALL	
			
--		----Importação Maritima
--		--	select 
--		--		TP.Num_Proc						[JOB],
--		--		A.Doc_Anexos					[Doc_Anexos],
--		--		Nome_Task + ':' + TP.Num_Proc	[Assunto],
--		--		''								[Doc_Anexos_Master],
--		--		A.CopyBDP						[CopyBDP],
--		--		A.JuntaPDF						[JuntaPDF],
--		--		--A.Emails						[Emails],
--		--		(case when Email_do_CompanyRegister = '1' then
--		--				[dbo].[fBusca_Emal_Comunicacao](HOU.Cd_Consig_HIM,'IM%')
--		--			else A.Emails	end)		[Emails],
--		--		Mensagem + '||' 				[MSG],
--		--		TP.Dt_Previsao					[Previsao],
--		--		A.CD_Pes_Grupo					[CD_Pes_Grupo],
--		--		A.Nome_Tp_Ocor					[Nome_Tp_Ocor],
--		--		'N'								[Disponivel],
--		--		A.ID							[ID],
--		--		A.Nome_Task						[Nome_Task],
--		--		A.ResponderPara					[ResponderPara],
--		--		'********** References ****************' + '|' +
--		--		'BDP Ref.:' + TP.Num_Proc + '|' +
--		--		'CSR Responsible:' + ISNULL(Nome_Usuario,'') + '|' +
--		--		'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,1),'') + '|' +
--		--		'Sales Order:' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,3),'')  + '|' +
--		--		'Origin: ' + isnull(Org.Nome_Local,'') + '|' +
--		--		'Destination: '+ isnull(DST.Nome_Local,'') + '|' +
--		--		'ATD: ' + isnull(convert(varchar(20),ATD_LiM,107),'') +'|' +
--		--		'ATA: ' + isnull(convert(varchar(20),ATA_LiM,107),'') +'|' +
--		--		'*************************************'  + '|' +
--		--		'by BDP System' 	[Mensagem_Referencia_cliente]	
				
--		--	from Alerta_Email_Doc_Automatico A with(nolock)
--		--		left join Tarefas_Processos TP with(nolock) on  TP.ID_Task = A.ID_Task
--		--		left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on  H.ID = A.ID and H.Num_Proc = Tp.Num_Proc	
				
--		--		Join LLP_Imp_Mar LLP	with(nolock) on TP.Num_Proc=LLP.Num_Proc_Lim
--		--		Join House_Imp_Mar Hou	with(nolock) on hou.num_proc_him=Num_Proc_Lim	
--		--		Join Job_Imp_Mar JOb	with (nolock) on job.num_proc_him=num_proc_lim
--		--		Join Usuario US			with (nolock) on US.cd_usuario=Job.cd_usuario	
--		--		Join Localidade Org		with (nolock) on Org.cd_local=cd_org_him
--		--		Join Localidade Dst		with (nolock) on DST.cd_local=cd_dst_him	
				
--		--	where
--		--		TP.dt_ins > (GETDATE() - A.Dias) 
--		--		and	
--		--		A.Ativo = 1
--		--		and left(TP.Num_Proc,2) = A.Modal
--		--		and TP.Dt_Conclusao is not null
--		--		and H.dt_envio is null
			
--		--UNION ALL
--		----Importação Aerea
--		--	select 
--		--		TP.Num_Proc						[JOB],
--		--		A.Doc_Anexos					[Doc_Anexos],
--		--		Nome_Task + ':' + TP.Num_Proc	[Assunto],
--		--		''								[Doc_Anexos_Master],
--		--		A.CopyBDP						[CopyBDP],
--		--		A.JuntaPDF						[JuntaPDF],
--		--		--A.Emails						[Emails],
--		--		(case when Email_do_CompanyRegister = '1' then
--		--				[dbo].[fBusca_Emal_Comunicacao](HOU.Cd_Consig_HIA,'IA%')
--		--			else A.Emails	end)		[Emails],
--		--		Mensagem + '||' 				[MSG],
--		--		TP.Dt_Previsao					[Previsao],
--		--		A.CD_Pes_Grupo					[CD_Pes_Grupo],
--		--		A.Nome_Tp_Ocor					[Nome_Tp_Ocor],
--		--		'N'								[Disponivel],
--		--		A.ID							[ID],
--		--		A.Nome_Task						[Nome_Task],
--		--		A.ResponderPara					[ResponderPara],
--		--		'********** References ****************' + '|' +
--		--		'BDP Ref.:' + TP.Num_Proc + '|' +
--		--		'CSR Responsible:' + ISNULL(Nome_Usuario,'') + '|' +
--		--		'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,1),'') + '|' +
--		--		'Sales Order:' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,3),'')  + '|' +
--		--		'Origin: ' + isnull(Org.Nome_Local,'') + '|' +
--		--		'Destination: '+ isnull(DST.Nome_Local,11) + '|' +
--		--		'ATD: ' + isnull(convert(varchar(20),ATD_LIA,107),'') +'|' +
--		--		'ATA: ' + isnull(convert(varchar(20),ATA_LIA,107),'') +'|' +
--		--		'*************************************'  + '|' +
--		--		'by BDP System' 	[Mensagem_Referencia_cliente]	
				
--		--	from Alerta_Email_Doc_Automatico A with(nolock) 
--		--		left join Tarefas_Processos TP with(nolock) on TP.ID_Task = A.ID_Task
--		--		left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on H.ID = A.ID and H.Num_Proc = Tp.Num_Proc
				
--		--		Join LLP_Imp_AER LLP	with(nolock) on TP.Num_Proc=LLP.Num_Proc_Lia
--		--		Join House_Imp_Aer Hou	with(nolock) on hou.num_proc_hia=Num_Proc_Lia	
--		--		Join Job_Imp_Aer JOb	with (nolock) on job.Num_Proc_HIA=Num_Proc_Lia
--		--		Join Usuario US			with (nolock) on US.cd_usuario=Job.cd_usuario	
--		--		Join Localidade Org		with (nolock) on Org.cd_local=Cd_Org_HIA
--		--		Join Localidade Dst		with (nolock) on DST.cd_local=Cd_Dst_HIA	
				
--		--	where
--		--		TP.dt_ins > (GETDATE() - A.Dias) 
--		--		and	
--		--		A.Ativo = 1
--		--		and left(TP.Num_Proc,2) = A.Modal
--		--		and TP.Dt_Conclusao is not null
--		--		and H.dt_envio is null
			
--		--UNION ALL
--		----Importação Outros
--		--	select 
--		--		TP.Num_Proc						[JOB],
--		--		A.Doc_Anexos					[Doc_Anexos],
--		--		Nome_Task + ':' + TP.Num_Proc	[Assunto],
--		--		''								[Doc_Anexos_Master],
--		--		A.CopyBDP						[CopyBDP],
--		--		A.JuntaPDF						[JuntaPDF],
--		--		--A.Emails						[Emails],
--		--		(case when Email_do_CompanyRegister = '1' then
--		--				[dbo].[fBusca_Emal_Comunicacao](HOU.Cd_Consig_HIO,'IO%')
--		--			else A.Emails	end)		[Emails],
--		--		Mensagem + '||' 				[MSG],
--		--		TP.Dt_Previsao					[Previsao],
--		--		A.CD_Pes_Grupo					[CD_Pes_Grupo],
--		--		A.Nome_Tp_Ocor					[Nome_Tp_Ocor],
--		--		'N'								[Disponivel],
--		--		A.ID							[ID],
--		--		A.Nome_Task						[Nome_Task],
--		--		A.ResponderPara					[ResponderPara],
--		--		'********** References ****************' + '|' +
--		--		'BDP Ref.:' + TP.Num_Proc + '|' +
--		--		'CSR Responsible:' + ISNULL(Nome_Usuario,'') + '|' +
--		--		'PO Ref.: ' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,1),'') + '|' +
--		--		'Sales Order:' + isnull(dbo.fBusca_TipoDocCliente('N',TP.Num_Proc,3),'')  + '|' +
--		--		'Origin: ' + isnull(Org.Nome_Local,'') + '|' +
--		--		'Destination: '+ isnull(DST.Nome_Local,11) + '|' +
--		--		'ATD: ' + isnull(convert(varchar(20),ATD_Lio,107),'') +'|' +
--		--		'ATA: ' + isnull(convert(varchar(20),ATA_Lio,107),'') +'|' +
--		--		'*************************************'  + '|' +
--		--		'by BDP System' 	[Mensagem_Referencia_cliente]	
				
--		--	from Alerta_Email_Doc_Automatico A with(nolock)
--		--		left join Tarefas_Processos TP with(nolock) on TP.ID_Task = A.ID_Task
--		--		left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on H.ID = A.ID and H.Num_Proc = Tp.Num_Proc
				
--		--		Join LLP_Imp_Out LLP	with(nolock) on TP.Num_Proc=LLP.Num_Proc_Lio
--		--		Join House_Imp_Out Hou	with(nolock) on hou.num_proc_hio=Num_Proc_Lio	
--		--		Join Usuario US with (nolock) on US.cd_usuario=LLP.cd_usuario	
--		--		Join Localidade Org		with (nolock) on Org.cd_local=cd_org_hio
--		--		Join Localidade Dst		with (nolock) on DST.cd_local=cd_dst_hio			
--		--	where
--		--		TP.dt_ins > (GETDATE() - A.Dias) 
--		--		and	
--		--		A.Ativo = 1
--		--		and left(TP.Num_Proc,2) = A.Modal
--		--		and TP.Dt_Conclusao is not null
--		--		and H.dt_envio is null
GO
