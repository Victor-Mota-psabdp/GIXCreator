SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Alerta_Email_Doc_Automatico_Rel_Debug]

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
		/*
		(case when Email_do_CompanyRegister = 0 then '' 
		else
			(case when left(TP.Num_Proc,2) = 'EM' then [dbo].[fBusca_Emal_Comunicacao](LLp.cd_cliente,'EM%')
		else
			(case when left(TP.Num_Proc,2) = 'EA' then [dbo].[fBusca_Emal_Comunicacao](LLp.cd_cliente,'EA%')
		else
			(case when left(TP.Num_Proc,2) = 'EO' then [dbo].[fBusca_Emal_Comunicacao](LLp.cd_cliente,'EO%')
		else
			(case when left(TP.Num_Proc,2) = 'IM' then [dbo].[fBusca_Emal_Comunicacao](LLp.cd_cliente,'IM%')
		else
			(case when left(TP.Num_Proc,2) = 'IA' then [dbo].[fBusca_Emal_Comunicacao](LLp.cd_cliente,'IA%')
		else
			(case when left(TP.Num_Proc,2) = 'IO' then [dbo].[fBusca_Emal_Comunicacao](LLp.cd_cliente,'IO%')			
		end)end)end)end)end)end)end)	[Company_Register],
		*/
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
		,CopyEmail,Zip
from Tarefas_Processos_Alerta	TP with(nolock)
	Join vwCliente_Alerta	LLP  with (nolock)on TP.Num_Proc = LLP.num_proc	
	join pessoa				CS  with(nolock) on CS.Cd_Pes = LLP.cd_cliente
	join Pessoa_LLP			PLL with(nolock) on PLL.Cd_Pes=LLP.cd_cliente	
	Join Usuario			US	with (nolock) on US.cd_usuario=LLP.cd_usuario	
	Join Localidade			Org	with (nolock) on Org.cd_local=LLP.Cd_Org
	Join Localidade			Dst	with (nolock) on DST.cd_local=LLP.Cd_Dst
	--join Tipo_tarefas		TT with(nolock) on TT.ID_Task = Tp.Id_Task
	join Alerta_Email_Doc_Automatico A with(nolock) on A.ID_Task = TP.ID_Task and A.Modal = LEFT(TP.Num_Proc,2)
	left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on H.ID = A.ID and H.Num_Proc = Tp.Num_Proc
	
	--left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on H.ID = A.ID and H.Num_Proc = Tp.Num_Proc
	--and H.cd_tp_pedido = A.cd_tp_pedido and H.Cd_Pes_Grupo = A.Cd_Pes_Grupo and
	--	H.cd_tp_carga = A.cd_tp_carga and H.Cd_Org = A.Cd_Org and H.Cd_Dst = A.Cd_Dst and
	--	H.cd_pes = A.cd_pes and H.modal = A.modal 
	
	left Join Pedido_Ship PS  with(nolock) on PS.num_proc=TP.Num_Proc
	left Join Pedido P with(nolock) on P.cd_pedido=PS.cd_pedido	
	left join Pessoa CLI with(nolock) on CLI.Cd_Pes = LLP.cd_cliente_master		
where	
	tp.Num_Proc = 'IMOXT202002048BR'
	and TP.ID_Task  in (7)-- and
	--and (PLL.cd_pes_grupo = A.Cd_Pes_Grupo)-- or A.Cd_Pes_Grupo = '10017')
			
	--and 
	--TP.dt_ins > (GETDATE() - A.Dias) 
	
	
	--and TP.ID_Task  in (7) 
	--and TP.ID_Task  not in (1,4) 
	
	--and A.Cd_Pes in ('P000030864','P000030864')
	
	

	--and convert(date,tp.Dt_Ins,103) >= '2017-06-27'
	and	A.Ativo = 1	
	and TP.Dt_Conclusao is not null
	and H.dt_envio is null
	
	--and H.cd_tp_pedido is null
	--and H.Cd_Pes_Grupo is null
	--and H.cd_tp_carga is null
	--and H.Cd_Org is null
	--and H.Cd_Dst is null
	--and H.cd_pes is null
	--and H.modal is null
	
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
		,CopyEmail,Zip
from Tarefas_Processos_Alerta	TP with(nolock)
	Join vwCliente_Alerta	LLP  with (nolock)on TP.Num_Proc = LLP.num_proc	
	join pessoa				CS  with(nolock) on CS.Cd_Pes = LLP.cd_cliente
	join Pessoa_LLP			PLL with(nolock) on PLL.Cd_Pes=LLP.cd_cliente	
	Join Usuario			US	with (nolock) on US.cd_usuario=LLP.cd_usuario

	join Alerta_Email_Doc_Automatico A with(nolock) on A.ID_Task = TP.ID_Task and A.Modal = LEFT(TP.Num_Proc,2)
	left join Alerta_Email_Doc_Automatico_Historico H with(nolock) on H.ID = A.ID and H.Num_Proc = Tp.Num_Proc	
	left Join Pedido_Ship PS  with(nolock) on PS.num_proc=TP.Num_Proc
	left Join Pedido P with(nolock) on P.cd_pedido=PS.cd_pedido	
	left join Pessoa CLI with(nolock) on CLI.Cd_Pes = LLP.cd_cliente_master		
where	
	tp.Num_Proc = 'IAOCV202003007BR' and		
	LEFT(TP.Num_Proc,2) = 'BO' AND 
	TP.dt_ins > (GETDATE() - A.Dias) 
	and	A.Ativo = 1	
	and TP.Dt_Conclusao is not null
	and H.dt_envio is null
	
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
	
GO
