SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from controle_fatura where cd_tipo like '%' order by 1

CREATE Procedure [dbo].[spATL_ControleFatura]--'2012-01-01','2012-07-30',''

	@dt_inicial		Datetime,
	@dt_final		Datetime,
	@nome_dc		varchar(50)
	
as 	
	Declare @id_dc varchar

	if @nome_dc = ''
		set @id_dc = '%'
	else
		set @id_dc = (select id_dc from tipo_cobranca_controle_fatura where nome_doc = @nome_dc)
		
		
	select  distinct
		CF.cd_controlefatura						[Register Number],
		CONVERT(VARCHAR(12),dt_rcto_fatura,103)		[Order Create],
		CF.num_proc									[BDP Ref.],
		num_fatura									[# Invoice],
		P.apelido									[Carrier],
		periodo_inicial								[Billing Start – Date],
		periodo_final								[Billing End – Date],
		(case When CF.cd_tp_moeda = 'USD' then valor end)	[USD-Value],
		(case When CF.cd_tp_moeda = 'REL' then valor end) 	[R$ - Value],
		--valor_brl									[R$ - Value],
		CONVERT(VARCHAR(12),dt_vcto_fatura,103)		[Due – Date],		
		CONVERT(VARCHAR(12),dt_envio_cliente,103)	[Invoice Sent to ITO - Date],
		CF.contato_cliente							[Responsable],
		LLP.ATA_LIM									[ATA],
		P1.numero_po_him							[PO],
		P3.numero_po_him							[SALES ORDER],
		CON.Apelido									[CONSIGNEE],
		PLC.Apelido									[BUSINESS NAME],
		PLC.Apelido									[BUSINESS GROUP],
		--T42.dt_conclusao							[Container Yard Request - Date],
		dbo.fBusca_Containers_IM(CF.num_proc)		[Container's],
		T28.dt_conclusao							[Terminal Entry -Date],		
		T15.dt_conclusao							[Port Entry - Date],
		P5.numero_po_him							[Customs Transmission - Date],
		llp.canal_lim								[Channel],
		T105.dt_conclusao							[Inspection MAPA],
		T7.dt_conclusao								[Transport. Doc Delivery - Date],
		T13.dt_conclusao							[Good Receipt Date - Atual],
		CF.cd_protocolo								[Protocol],
		CF.Analise									[Notes]	
	from controle_fatura CF	With(nolock)	
		join pessoa P With(nolock) on P.cd_pes = CF.cd_fornecedor	
		left join controle_fatura_protocolo CFP With(nolock) on cfp.cd_protocolo = CF.cd_protocolo
--		left join usuario U on U.cd_usuario = CFP.cd_usuario		
		join House_imp_mar HOU With(nolock) on HOU.num_proc_him = CF.num_proc
		join LLP_Imp_Mar LLP With(nolock) on LLP.num_proc_lim = CF.num_proc
		left join PO_HIM  P1 With(nolock) on P1.num_proc_him = cf.num_proc and P1.id_dc = 1
		left join PO_HIM  P3 With(nolock) on P3.num_proc_him = cf.num_proc and P3.id_dc = 3
		left join Pessoa CON With(nolock) on CON.cd_pes = HOU.cd_consig_him
		join Pessoa_LLP PL With(nolock) on PL.cd_pes = HOU.cd_consig_him
		join Pessoa PLC With(nolock) on	PLC.cd_pes = PL.cd_pes_grupo
		left join PO_HIM  P5 With(nolock) on P5.num_proc_him = cf.num_proc and P5.id_dc = 5
		left join tarefas_processos T28 With(nolock) on t28.num_proc = CF.num_proc and T28.id_task = 28
		left join tarefas_processos T15 With(nolock) on t15.num_proc = CF.num_proc and T15.id_task = 15	
		left join tarefas_processos T105 With(nolock) on t105.num_proc = CF.num_proc and T105.id_task = 105
		left join tarefas_processos T7 With(nolock) on t7.num_proc = CF.num_proc and T7.id_task = 7	
		left join tarefas_processos T13 With(nolock) on t13.num_proc = CF.num_proc and T13.id_task = 13
		--left join tarefas_processos T42 With(nolock) on t42.num_proc = CF.num_proc and T42.id_task = 42
	where
		dt_rcto_fatura between @dt_inicial and @dt_final
		and cd_tipo like @id_dc


--select * from controle_fatura
GO
