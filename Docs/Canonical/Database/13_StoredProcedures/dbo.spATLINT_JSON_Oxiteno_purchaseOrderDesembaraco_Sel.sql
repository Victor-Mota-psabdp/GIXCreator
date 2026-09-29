SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--[spATLINT_JSON_Oxiteno_purchaseOrderDesembaraco_Sel]NULL,NULL,NULL,'X'
CREATE PROCEDURE [dbo].[spATLINT_JSON_Oxiteno_purchaseOrderDesembaraco_Sel]
(
	@ID_purchaseOrderDesembaraco	bigint,
	@ref_oxiteno				varchar(200),	
	@num_Proc					varchar(200),
	@Tipo						char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
Z /// Verifica Nome X Codigo
*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 
			S.ID_purchaseOrderDesembaraco [Internal Code],
			S.ref_oxiteno,			
			S.etd,
			S.eta,
			S.ata,
			S.presenca_carga,
			S.data_madeira,
			S.desembaraco,
			S.canal,
			S.liberacao_transp,
			S.atd,
			S.ci,
			S.pagamento_icms,
			S.recebimento_docs,
			S.assinatura_laudo,
			S.Num_Proc				[JOB],			
			S.dt_ins			[Insert Date],
			S.Dt_Sent			[Sent Date]
			,S.Message
		from 
			ATL_INT.dbo.JSON_Oxiteno_purchaseOrderDesembaraco S with(nolock)	
			
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 
			S.ID_purchaseOrderDesembaraco [Internal Code],
			S.ref_oxiteno,			
			S.etd,
			S.eta,
			S.ata,
			S.presenca_carga,
			S.data_madeira,
			S.desembaraco,
			S.canal,
			S.liberacao_transp,
			S.atd,
			S.ci,
			S.pagamento_icms,
			S.recebimento_docs,
			S.assinatura_laudo,
			S.Num_Proc				[JOB],			
			S.dt_ins			[Insert Date],
			S.Dt_Sent			[Sent Date]	
			,S.Message
		from 
			ATL_INT.dbo.JSON_Oxiteno_purchaseOrderDesembaraco S with(nolock)
		where 
			ID_purchaseOrderDesembaraco = @ID_purchaseOrderDesembaraco
	End

if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 
			S.ID_purchaseOrderDesembaraco [Internal Code],
			S.ref_oxiteno,			
			S.etd,
			S.eta,
			S.ata,
			S.presenca_carga,
			S.data_madeira,
			S.desembaraco,
			S.canal,
			S.liberacao_transp,
			S.atd,
			S.ci,
			S.pagamento_icms,
			S.recebimento_docs,
			S.assinatura_laudo,
			S.Num_Proc				[JOB],			
			S.dt_ins			[Insert Date],
			S.Dt_Sent			[Sent Date]	
			,S.Message
		from 
			ATL_INT.dbo.JSON_Oxiteno_purchaseOrderDesembaraco S with(nolock)
		where 
			S.ref_oxiteno = @ref_oxiteno
	End

if @Tipo = 'P'
	Begin
		select 
			S.ID_purchaseOrderDesembaraco [Internal Code],
			S.ref_oxiteno,			
			S.etd,
			S.eta,
			S.ata,
			S.presenca_carga,
			S.data_madeira,
			S.desembaraco,
			S.canal,
			S.liberacao_transp,
			S.atd,
			S.ci,
			S.pagamento_icms,
			S.recebimento_docs,
			S.assinatura_laudo,
			S.Num_Proc				[JOB],			
			S.dt_ins			[Insert Date],
			S.Dt_Sent			[Sent Date]	
			,S.Message
		from 
			ATL_INT.dbo.JSON_Oxiteno_purchaseOrderDesembaraco S with(nolock)
		Where
			S.Dt_Sent is null		
	End
	
if @Tipo = 'X'
	Begin
		select distinct
			NULL [Internal Code],
			PO.Numero_PO + '/' + convert(varchar(4),year(PO.Data_PO))	ref_oxiteno,
			HOU.ETD				etd,
			HOU.ETA				eta,
			HOU.ATA				ata,
			TP15.Dt_Conclusao	presenca_carga,
			TP164.Dt_Conclusao	data_madeira,
			TP4.Dt_Conclusao	desembaraco,
			HOU.Canal			canal,
			TP7.Dt_Conclusao	liberacao_transp,
			HOU.Num_Proc		[JOB],	
			
			HOU.ATD				atd,
			TP4.Dt_Conclusao	ci,
			TP24.Dt_Conclusao	pagamento_icms,
			TP16.Dt_Conclusao	recebimento_docs,
			TP114.Dt_Conclusao	assinatura_laudo,

			NULL				[Insert Date],
			NULL				[Sent Date]
			,NULL				Message
		
		from vwHouse_Imp HOU with(nolock)
			join vwPO_Imp PO with(nolock) on PO.NUm_proc = HOU.Num_Proc
			--left join ATL_INT.dbo.JSON_Oxiteno_purchaseOrderDesembaraco USO with(nolock) on USO.NUm_proc = HOU.Num_Proc
			
			left join Tarefas_Processos TP15 with(nolock) on TP15.NUm_proc = HOU.Num_Proc and TP15.Id_Task = 15
			left join Tarefas_Processos TP164 with(nolock) on TP164.NUm_proc = HOU.Num_Proc and TP164.Id_Task = 164
			left join Tarefas_Processos TP4 with(nolock) on TP4.NUm_proc = HOU.Num_Proc and TP4.Id_Task = 4
			left join Tarefas_Processos TP7 with(nolock) on TP7.NUm_proc = HOU.Num_Proc and TP7.Id_Task =7
			left join Tarefas_Processos TP24 with(nolock) on TP24.NUm_proc = HOU.Num_Proc and TP24.Id_Task =24
			left join Tarefas_Processos TP16 with(nolock) on TP16.NUm_proc = HOU.Num_Proc and TP16.Id_Task =16
			left join Tarefas_Processos TP114 with(nolock) on TP114.NUm_proc = HOU.Num_Proc and TP114.Id_Task =114

			join Exchange EXC with(nolock) on HOU.NUm_proc COLLATE DATABASE_DEFAULT = EXC.ExcProcesso  COLLATE DATABASE_DEFAULT	
			join Pessoa_LLP LLP with(nolock) on LLP.cd_pes = HOU.cd_consig and cd_pes_grupo = 'P21128'

			--left join Tarefas_Processos TP27 with(nolock) on TP27.NUm_proc = HOU.Num_Proc and TP27.Id_Task = 27
			left join Tarefas_Processos TP63 with(nolock) on HOU.NUm_proc = TP63.Num_proc and TP63.ID_task = 63	
			left join Tarefas_Processos TP40 with(nolock) on TP40.NUm_proc = HOU.Num_Proc and TP40.Id_Task = 40
		Where
		--HOU.Num_Proc = 'IMOXT202209004BR'
			EXC.ExcDataAlt >= DateAdd(hour,-1,getdate())	
			and TP63.Dt_Conclusao is not null
			and TP40.Dt_Conclusao is null
			and PO.Data_PO is not null
			and PO.Numero_PO is not null
	End	
	

	/*
	1 - Inicio: Quando o task: Digitação da DI for preenchido.
	--alterado para 63	Documentos OK para Registro
	1.1 - Atualizações: Será enviado atualizações quando houver qualquer alteração no job
	2 - Fim: Quando o task: “Envio de Prestação de contas”  for preenchido.
	*/

if @Tipo = 'I'  --usada na tela do Integrated Received
	Begin
		select 
			S.ID_purchaseOrderDesembaraco [Internal Code],
			S.ref_oxiteno,			
			S.etd,
			S.eta,
			S.ata,
			S.presenca_carga,
			S.data_madeira,
			S.desembaraco,
			S.canal,
			S.liberacao_transp,
			S.atd,
			S.ci,
			S.pagamento_icms,
			S.recebimento_docs,
			S.assinatura_laudo,
			S.Num_Proc				[JOB],			
			S.dt_ins			[Insert Date],
			S.Dt_Sent			[Sent Date]	
			,S.Message
		from 
			ATL_INT.dbo.JSON_Oxiteno_purchaseOrderDesembaraco S with(nolock)
		where
			S.dt_ins > getdate() -1
			
	End



GO
