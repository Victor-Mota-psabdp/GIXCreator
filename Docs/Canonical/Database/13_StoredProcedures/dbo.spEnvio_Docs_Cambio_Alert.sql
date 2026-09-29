SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from dbo.alerta_Email_Historico where Id_Alerta_Email = 66
	--select * from msdb.dbo.Alerta_Email where Id = 66

CREATE procedure [dbo].[spEnvio_Docs_Cambio_Alert]

AS

--	declare @ResponderPara varchar(50)
--	declare @DocAnexos varchar(100)
--	declare @Destinatarios varchar(500)
--
--	set @ResponderPara = 'carlos.eduardo@bdp.com.br'
----	set @DocAnexos = '2;11;13;16;20;22;21;103;65;27'
--	set @Destinatarios = 'carlos.eduardo@bdp.com.br;rafael.matjas@bdp.com.br'

	select distinct top 5
		GR.Nome_Raz_Soc				Grupo,
		P.num_pedido				[PO],
		DI.Numero_PO_HIM			[DI], 
		HOU.Num_Proc_HIM			[JOB],		
		AE.ResponderPara			ResponderPara,
		(case when CP.Campo_dados in (1264,5,20) then
				'2;20'
			else
				'2;5;20' end) DocAnexos,
--		@DocAnexos					DocAnexos,		 
		66							ID, 
		AE.Destinatarios			Email,
		PL.Cd_Pes_Grupo				CD_Grupo,
		T23.dt_previsao				Previsao
	from
		House_Imp_Mar HOU		with(nolock)	
		join LLP_Imp_Mar LLP	with(nolock)	on LLP.Num_Proc_LIM = HOU.Num_Proc_HIM
		join pedido_ship PS		with(nolock)	on PS.num_proc = HOU.Num_Proc_HIM
		join pedido P			with(nolock)	on PS.cd_pedido = P.cd_pedido
		join PO_HIM DI			with(nolock)	on DI.Num_Proc_HIM = HOU.Num_Proc_HIM and DI.ID_DC=5		
		join Campo_Processo CP	with(nolock)	on Cp.num_proc = HOU.Num_Proc_HIM and id_campo = 87
		join Pessoa_LLP PL		with(nolock)	on PL.cd_pes = HOU.cd_consig_him
		Join Pessoa GR			with(nolock)	 on GR.Cd_Pes = PL.Cd_Pes_Grupo
		--join msdb.dbo.Alerta_Email AE with(nolock) on AE.id=66
		join dbo.Alerta_Email AE with(nolock) on AE.id=66
		left join tarefas_processos T23	with(nolock)	on T23.num_proc = HOU.Num_Proc_HIM and id_task = 23
		left join Alerta_Email_Historico AEH with(nolock) on AEH.Id_Alerta_Email = 66 and AEH.Num_Proc = HOU.Num_Proc_HIM
	where
		substring(num_proc_lim,3,3) in ('SUN','SPG') 
		and t23.dt_conclusao is null
		and AEH.Num_Proc IS NULL 

UNION ALL
		
	select distinct top 5
		GR.Nome_Raz_Soc				Grupo,
		P.num_pedido				[PO],
		DI.Numero_PO_HIA			[DI], 
		HOU.Num_Proc_HIA			[JOB],		
		AE.ResponderPara			ResponderPara,
		(case when CP.Campo_dados in (1264,5,20) then
				'2;20'
			else
				'2;5;20' end) DocAnexos,
--		@DocAnexos					DocAnexos,		 
		66							ID, 
		AE.Destinatarios			Email,
		PL.Cd_Pes_Grupo				CD_Grupo,
		T23.dt_previsao				Previsao
	from
		House_Imp_Aer HOU		with(nolock)	
		join LLP_Imp_Aer LLP	with(nolock)	on LLP.Num_Proc_LIA = HOU.Num_Proc_HIA
		join pedido_ship PS		with(nolock)	on PS.num_proc = HOU.Num_Proc_HIA
		join pedido P			with(nolock)	on PS.cd_pedido = P.cd_pedido
		join PO_HIA DI			with(nolock)	on DI.Num_Proc_HIA = HOU.Num_Proc_HIA and DI.ID_DC=5		
		join Campo_Processo CP	with(nolock)	on Cp.num_proc = HOU.Num_Proc_HIA and id_campo = 87
		join Pessoa_LLP PL		with(nolock)	on PL.cd_pes = HOU.cd_consig_hia
		Join Pessoa GR			with(nolock)	 on GR.Cd_Pes = PL.Cd_Pes_Grupo
		--join msdb.dbo.Alerta_Email AE with(nolock) on AE.id=66
		join dbo.Alerta_Email AE with(nolock) on AE.id=66
		left join tarefas_processos T23	with(nolock)	on T23.num_proc = HOU.Num_Proc_HIA and id_task = 23
		left join Alerta_Email_Historico AEH with(nolock) on AEH.Id_Alerta_Email = 66 and AEH.Num_Proc = HOU.Num_Proc_HIA
	where
		substring(num_proc_lia,3,3) in ('SUN','SPG') 
		and t23.dt_conclusao is null
		and AEH.Num_Proc IS NULL 

UNION ALL
		
	select distinct top 5
		GR.Nome_Raz_Soc				Grupo,
		P.num_pedido				[PO],
		DI.Numero_PO_HIO			[DI], 
		HOU.Num_Proc_HIO			[JOB],		
		AE.ResponderPara			ResponderPara,
		(case when CP.Campo_dados in (1264,5,20) then
				'2;20'
			else
				'2;5;20' end) DocAnexos,
--		@DocAnexos					DocAnexos,		 
		66							ID, 
		AE.Destinatarios			Email,
		PL.Cd_Pes_Grupo				CD_Grupo,
		T23.dt_previsao				Previsao
	from
		House_Imp_Out HOU		with(nolock)	
		join LLP_Imp_Out LLP	with(nolock)	on LLP.Num_Proc_LIO = HOU.Num_Proc_HIO
		join pedido_ship PS		with(nolock)	on PS.num_proc = HOU.Num_Proc_HIO
		join pedido P			with(nolock)	on PS.cd_pedido = P.cd_pedido
		join PO_HIO DI			with(nolock)	on DI.Num_Proc_HIO = HOU.Num_Proc_HIO and DI.ID_DC=5		
		join Campo_Processo CP	with(nolock)	on Cp.num_proc = HOU.Num_Proc_HIO and id_campo = 87
		join Pessoa_LLP PL		with(nolock)	on PL.cd_pes = HOU.cd_consig_hio
		Join Pessoa GR			with(nolock)	 on GR.Cd_Pes = PL.Cd_Pes_Grupo
		--join msdb.dbo.Alerta_Email AE with(nolock) on AE.id=66
		join dbo.Alerta_Email AE with(nolock) on AE.id=66
		left join tarefas_processos T23	with(nolock)	on T23.num_proc = HOU.Num_Proc_HIO and id_task = 23
		left join Alerta_Email_Historico AEH with(nolock) on AEH.Id_Alerta_Email = 66 and AEH.Num_Proc = HOU.Num_Proc_HIO
	where
		substring(num_proc_lio,3,3) in ('SUN','SPG') 
		and t23.dt_conclusao is null
		and AEH.Num_Proc IS NULL 
GO
