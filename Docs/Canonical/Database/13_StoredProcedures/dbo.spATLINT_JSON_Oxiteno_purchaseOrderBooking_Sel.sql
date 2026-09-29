SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--[spATLINT_JSON_Oxiteno_purchaseOrderBooking_Sel] NULL,NULL,NULL,'X'
CREATE PROCEDURE [dbo].[spATLINT_JSON_Oxiteno_purchaseOrderBooking_Sel]
(
	@ID_purchaseOrderBooking	bigint,
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
sp_help Tipo_Modal
*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 
			S.ID_purchaseOrderBooking [Internal Code],
			S.ref_oxiteno,
			S.numero_viagem,
			S.navio,
			S.etd,
			S.eta,
			S.atd,
			S.confirmacao_docs,
			S.Num_Proc				[JOB],			
			S.dt_ins			[Insert Date],
			S.Dt_Sent			[Sent Date]
			,S.Message	
		from 
			ATL_INT.dbo.JSON_Oxiteno_purchaseOrderBooking S with(nolock)	
			
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 
			S.ID_purchaseOrderBooking [Internal Code],
			S.ref_oxiteno,
			S.numero_viagem,
			S.navio,
			S.etd,
			S.eta,
			S.atd,
			S.confirmacao_docs,
			S.Num_Proc				[JOB],			
			S.dt_ins			[Insert Date],
			S.Dt_Sent			[Sent Date]	
			,S.Message	
		from 
			ATL_INT.dbo.JSON_Oxiteno_purchaseOrderBooking S with(nolock)	
		where 
			ID_purchaseOrderBooking = @ID_purchaseOrderBooking
	End

if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 
			S.ID_purchaseOrderBooking [Internal Code],
			S.ref_oxiteno,
			S.numero_viagem,
			S.navio,
			S.etd,
			S.eta,
			S.atd,
			S.confirmacao_docs,
			S.Num_Proc				[JOB],			
			S.dt_ins			[Insert Date],
			S.Dt_Sent			[Sent Date]	
			,S.Message	
		from 
			ATL_INT.dbo.JSON_Oxiteno_purchaseOrderBooking S with(nolock)
		where 
			S.ref_oxiteno = @ref_oxiteno
	End

if @Tipo = 'P'
	Begin
		select 
			S.ID_purchaseOrderBooking [Internal Code],
			S.ref_oxiteno,
			S.numero_viagem,
			S.navio,
			S.etd,
			S.eta,
			S.atd,
			S.confirmacao_docs,
			S.Num_Proc				[JOB],			
			S.dt_ins			[Insert Date],
			S.Dt_Sent			[Sent Date]	
			,S.Message	
		from 
			ATL_INT.dbo.JSON_Oxiteno_purchaseOrderBooking S with(nolock)
		Where
			S.Dt_Sent is null		
	End

if @Tipo = 'X'
	Begin
		select distinct
			NULL [Internal Code],
			PO.Numero_PO + '/' + convert(varchar(4),year(PO.Data_PO))	ref_oxiteno,
			HOU.VIAGEM			numero_viagem,
			HOU.VESSEL			navio,
			HOU.ETD				etd,
			HOU.ETA				eta,
			HOU.ATD				atd,
			TP41.Dt_Conclusao	confirmacao_docs,
			HOU.Num_Proc		[JOB],			
			NULL				[Insert Date],
			NULL				[Sent Date],
			HOU.Booking_Number,
			substring(HOU.Num_Proc,2,1),
			TP5.Dt_conclusao,
			TP1.Dt_conclusao
			,NULL Message	
		from vwHouse_Imp HOU with(nolock)
			join Pessoa_LLP LLP with(nolock) on LLP.cd_pes = HOU.cd_consig and cd_pes_grupo = 'P21128'
			join vwPO_Imp PO with(nolock) on PO.NUm_proc = HOU.Num_Proc
			--left join ATL_INT.dbo.JSON_Oxiteno_purchaseOrderBooking USO with(nolock) on USO.NUm_proc = HOU.Num_Proc			
			join Exchange EXC with(nolock) on HOU.NUm_proc COLLATE DATABASE_DEFAULT = EXC.ExcProcesso  COLLATE DATABASE_DEFAULT	
			left join Tarefas_Processos TP5 with(nolock) on HOU.NUm_proc = TP5.Num_proc and TP5.ID_task = 5	
			left join Tarefas_Processos TP1 with(nolock) on HOU.NUm_proc = TP1.Num_proc and TP1.ID_task = 1	
			--left join Tarefas_Processos TP27 with(nolock) on HOU.NUm_proc = TP27.Num_proc and TP27.ID_task = 27	
			left join Tarefas_Processos TP63 with(nolock) on HOU.NUm_proc = TP63.Num_proc and TP63.ID_task = 63	
			left join Tarefas_Processos TP41 with(nolock) on TP41.NUm_proc = HOU.Num_Proc and TP41.Id_Task =41
			
		Where
			--HOU.num_proc in ('IMOXT202209001BR','IMOXT202209002BR') and 
			EXC.ExcDataAlt >= DateAdd(hour,-1,getdate()) and
			(
				(substring(HOU.Num_Proc,2,1) = 'M' and TP5.Dt_conclusao is not null)
				or 
				TP1.Dt_conclusao is not null
			)
			and PO.Numero_PO is not null
			and PO.Data_PO is not null
			--and USO.Dt_Sent is null
			and TP63.Dt_conclusao is null
	End	

if @Tipo = 'I' --usada na tela do Integrated Received
	Begin
		select 
			S.ID_purchaseOrderBooking [Internal Code],
			S.ref_oxiteno,
			S.numero_viagem,
			S.navio,
			S.etd,
			S.eta,
			S.atd,
			S.confirmacao_docs,
			S.Num_Proc				[JOB],			
			S.dt_ins			[Insert Date],
			S.Dt_Sent			[Sent Date]	
			,S.Message	
		from 
			ATL_INT.dbo.JSON_Oxiteno_purchaseOrderBooking S with(nolock)
		where
			S.dt_ins > getdate() -1
			
	End



--select Getdate(), getdate()-0.041666667 ,DateAdd(hour,-1,getdate())
--select * from vwPO_Imp where num_proc in ('IMOXT202209001BR','IMOXT202209002BR') 
--select * from Pedido where NUm_pedido = '522048'
--select * from Pedido_Ship where cd_pedido = '347169'
--select * from Pedido_Ship where cd_pedido = '347169'
--select * from custo_cliente where num_proc ='IMOXT202207039BR' order by cd_tp_tx
--select * from tipo_tarefas where nome_task like '%registro%'
--select * from Tarefas_Processos where num_proc in ('IAOXT202209001BR','IOOXT220900001BR') and ID_task = 27

--3 - Function: purchaseOrderBooking - Type: Post
--1 - Inicio: Quando o task: “Recebimento de Booking” for preenchido
--1.1 - Atualizações: Será enviado atualizações quando houver qualquer alteração no job.
--2 - Fim: Quando o task: Digitação da DI for preenchido.
--alterado para 63	Documentos OK para Registro

--"ref_oxiteno": "S001/2022",
--"numero_viagem": "232S",
--"navio": "SAN AUGUSTIN",
--"etd": "2022-09-12 00:00:00.000",
--"eta": "2022-09-30 00:00:00.000"

--select * from ATL_INT.dbo.JSON_Oxiteno_purchaseOrderBooking S with(nolock)	



GO
