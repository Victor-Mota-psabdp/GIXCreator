SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
--020 – Doc. Embarque
--044 – BL - Original
--029 – CE Mercante
--149 – BL - Draft
--Quando tiver agente manda para o agente e para o terminal
--Quando não tiver só para o terminal

--Declare @cd_pes_grupo as Varchar(6)
--Declare	@dia as int
--Declare	@diafim as int

--set @cd_pes_grupo = '10017'
--set @dia = 0
--set @diafim = 20

CREATE Procedure [dbo].[spAlerta_Email_Redestinacao_IM_Rel]
(
	@cd_pes_grupo as Varchar(6),
	@dia as int,
	@diafim as int
)

AS

	select 
		HOU.Num_Proc_HIM					[JOB],
		(case when D29.dt_creacao is not null and D44.dt_creacao is null and D149.dt_creacao is null and D20.dt_creacao is null then
			'29'
			else
		(case when D44.dt_creacao is not null and D20.dt_creacao is null and D149.dt_creacao is null and D29.dt_creacao is null then	
			'44'
			else
		(case when D149.dt_creacao is not null and D44.dt_creacao is null and D20.dt_creacao is null and D29.dt_creacao is null then		
			'149'
			else
		(case when D20.dt_creacao is not null and D44.dt_creacao is null and D149.dt_creacao is null and D29.dt_creacao is null then		
			'20'
			else
			'20;44;29;149'
			end)end)end)end)				[Doc_Anexos],	
		NULL								[Doc_Anexos_Nao_Obrigatorios],		
		--Redestinação MONTE OLIVIA 075S ETA 20/05 IMCSR201704139BR
		'SOLICITAÇÃO DE REDESTINAÇÃO DE CONTÊINER -  BL:' + isnull(HOU.HAWB_HIM,'') + ' JOB: ' +  HOU.Num_Proc_HIM [Assunto],
		NULL													[Doc_Anexos_Master],
		NULL													[CopyBDP],
		NULL													[JuntaPDF],
		--convert(bit,0)											[Email_do_CompanyRegister],
		
		--ficou valendo para os 2 tipos q tem agent e terminal
		--(Case when JOB.Cd_Agente IS not NULL and isnull(HOU.HAWB_HIM,'') <> isnull(HOU.MAWB_HIM,'')
		--	then convert(bit,1) 
		--ELSE 
		--	convert(bit,1)
		convert(bit,1) 		[Email_do_CompanyRegister],
		
		(Case when JOB.Cd_Agente IS not NULL and isnull(HOU.HAWB_HIM,'') <> isnull(HOU.MAWB_HIM,'') then		
			[dbo].[fBusca_Emal_Comunicacao](JOB.Cd_Agente,'RD%')
		ELSE 
			T.Email + ';' + T.Email_CC
		END)												[Company_Register],		
		 																
		
		'Prezado ,  ' + T .Nome_Terminal + '||' + 
		'Solicitamos a redestinação do(s) contêiner(s), conforme informações abaixo:  ' + '||' + 
		'Número do BL:  ' + isnull(HOU.HAWB_HIM,'') + '|' + 
		'Importador:  ' + Con.Nome_Raz_Soc + '|' + 
		'JOB:  ' +  HOU.Num_Proc_HIM + '||' + 		
		'Notar documentos em anexo: BL e/ou CE-Mercante  ' + '||' +   
		'Favor confirmar o cadastro da redestinação para o seu terminal.'  + '||' +   
		'Qualquer duvida, favor nos contatar urgentemente'  + '|||' +  
		'Atenciosamente.'  + '||' + 
		'BDP South America Ltda.'  + '||' + 
		U.Nome_Usuario													[MSG],		
		
		T42.Dt_Previsao													[Previsao],	
		PLL.cd_pes_grupo												[CD_Pes_Grupo],
		'Envio de E-mail'												[Nome_Tp_Ocor],
		NULL															[ID],
		'Redestinação de Container'										[Nome_task],
		T.Email + ';' + T.Email_CC										[Emails],	--são os emails do terminal														
			
		
		NULL															[Mensagem_Referencia_cliente],
		
		(Case when JOB.Cd_Agente IS not NULL and isnull(HOU.HAWB_HIM,'') <> isnull(HOU.MAWB_HIM,'') then
			'Cliente: ' + Agente.Apelido	
		ELSE 
			'Terminal: ' + T.Nome_Terminal
		END)							[Cliente],
		
		--utilizei este campo p validar o terminal
		convert(bit,1)					Email_do_Agente_Consolidado,
		(case when T.Email IS null then '' else
			T.Email + ';' + T.Email_CC	end)	[Company_Register_Master],

		NULL							[Cliente_Master],
		NULL							[Master_JOB],
		NULL							StandardForms,
		--Para mensagem qdo nao enconta o cliente HOuse e do Master
		(Case when JOB.Cd_Agente IS not NULL and isnull(HOU.HAWB_HIM,'') <> isnull(HOU.MAWB_HIM,'') then
			'Agente: ' + Agente.Apelido	+ ' sem emails cadastrados, JOB: ' + HOU.Num_Proc_HIM
		ELSE 
			'Terminal: ' + T.Nome_Terminal	+ ' sem emails cadastrados, JOB: ' + HOU.Num_Proc_HIM
		END)									[CorpoMSG], 
		--'Cliente: ' + Agente.Apelido + ' sem emails cadastrados, JOB: ' + HOU.Num_Proc_HIM	[CorpoMSG],
		'Terminal: ' + T.Nome_Terminal	+ ' sem emails cadastrados, JOB: ' + HOU.Num_Proc_HIM	[CorpoMSGConsolidado],
		'Não Enviado - '							[Assunto_CorpoMSG],	
		--Para mensagem qdo nao encontra os documentos
		'Arquivos não encontrados para serem anexados ao email, JOB: ' + HOU.Num_Proc_HIM + 
			'|Favor verificar se existem os seguintes documentos estão no JOB: | ' 	+
		(case when D29.dt_creacao is not null and D44.dt_creacao is null and D149.dt_creacao is null and D20.dt_creacao is null then
			'|29 - CE Mercante'
			else
		(case when D44.dt_creacao is not null and D20.dt_creacao is null and D149.dt_creacao is null and D29.dt_creacao is null then	
			'|44 - BL - Original'
			else
		(case when D149.dt_creacao is not null and D44.dt_creacao is null and D20.dt_creacao is null and D29.dt_creacao is null then		
			'149 - BL - Draft'
			else
		(case when D20.dt_creacao is not null and D44.dt_creacao is null and D149.dt_creacao is null and D29.dt_creacao is null then		
			'|20 - Doc. Embarque'			
			else
			'| 20 - Doc. Embarque | 44 - BL - Original | 29 - CE Mercante | 149 - BL - Draft'
			end)end)end)end)			[CorpoMSG_Doc_Anexos],		
		'Falha no envio - Sem arquivos anexados - '		[Assunto_CorpoMSG_Doc_Anexos],
		
		U.Nome_Usuario									[Usuario],
		U.Email											[ResponderPara],	
		(case when D29.dt_creacao is not null and D44.dt_creacao is null and D149.dt_creacao is null and D20.dt_creacao is null then
			'|29 - CE Mercante'
			else
		(case when D44.dt_creacao is not null and D20.dt_creacao is null and D149.dt_creacao is null and D29.dt_creacao is null then	
			'|44 - BL - Original'
			else
		(case when D149.dt_creacao is not null and D44.dt_creacao is null and D20.dt_creacao is null and D29.dt_creacao is null then		
			'149 - BL - Draft'
			else
		(case when D20.dt_creacao is not null and D44.dt_creacao is null and D149.dt_creacao is null and D29.dt_creacao is null then		
			'|20 - Doc. Embarque'			
			else
			'| 20 - Doc. Embarque | 44 - BL - Original | 29 - CE Mercante | 149 - BL - Draft'
			end)end)end)end)										[Nome_Doc_Anexos],
		''															[Nome_Doc_Anexos_Master],
		
		'N'															[Disponivel],
		
		convert(date,GETDATE()) DATA_HOJE,
		convert(date,LLP.ETA_Lim) DATA_ETA,
		convert(date,(GETDATE() + @Dia)) DATA_Inicio,
		convert(date,(GETDATE() + @diafim)) DATA_fim,
		LOA.Pais_Local
	from House_Imp_Mar HOU with(nolock)
		join LLP_Imp_Mar LLP with(nolock) on LLP.Num_Proc_LIM = HOU.Num_Proc_HIM
		join Job_Imp_Mar JOB with(nolock) on JOB.Num_Proc_HIM = HOU.Num_Proc_HIM
		join Usuario U on U.Cd_Usuario = JOB.cd_usuario
		join pessoa CON	with(nolock) on CON.cd_pes = HOU.Cd_Consig_HIM
		
		JOIN Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig_HIM
		JOIN Grupo G with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
		
		join Localidade LOA	with(nolock) on LOA.cd_local = HOU.cd_org_HIM
		join Localidade DIS	with(nolock) on DIS.cd_local = HOU.cd_dst_HIM
		join Armador ARM with(nolock) on JOB.Cd_Armador = ARM.cd_armador		
		join Campo_Processo c on c.Num_Proc = HOU.Num_Proc_HIM and Id_Campo = 143 
		left join Doc_Anexos D20 on D20.num_proc = HOU.Num_Proc_HIM and D20.Id_DC = 20
		left join Doc_Anexos D44 on D44.num_proc = HOU.Num_Proc_HIM and D44.Id_DC = 44
		left join Doc_Anexos D29 on D29.num_proc = HOU.Num_Proc_HIM and D29.Id_DC = 29
		left join Doc_Anexos D149 on D149.num_proc = HOU.Num_Proc_HIM and D149.Id_DC = 149
		left join Tarefas_Processos T42 on T42.num_proc = HOU.Num_Proc_HIM and T42.ID_Task = 42			
		join Terminal T on T.Cd_Terminal = LLP.Cd_Terminal
		left join Pessoa Agente on Agente.Cd_Pes = JOB.Cd_Agente				
	where
		--llp.Num_Proc_Lim = 'IMCSR201802002BR' and
		LLP.cd_tp_carga = '1'
		and c.Campo_Dados in ('1','3')
		and (PLL.cd_pes_grupo = @cd_pes_grupo or @cd_pes_grupo = '10017')
		and ATD_lim is not null
		and T42.Dt_Conclusao is null
 		and HOU.Cd_Dst_HIM = 'SSZ'
 		and 	
			convert(date,LLP.ETA_LIM)  between convert(date,GETDATE()+ @dia)  and convert(date,GETDATE()+ (@diafim))
 			
 	--	and 
		--(
		--	(LOA.Pais_Local = 'Argentina' and convert(date,ETA_Lim) between convert(date,GETDATE() - 3) and GETDATE())
		--		or 
		--	(LOA.Pais_Local <> 'Argentina' and convert(date,ETA_Lim) between convert(date,GETDATE() - 6) and GETDATE())
		--)







GO
