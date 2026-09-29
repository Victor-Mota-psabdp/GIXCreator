SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select top 50 * from LLP_Imp_Mar
--where Num_Proc_Lim  like '%UPL%'
--select * from Tarefas_Processos
--where Num_Proc = 'IMUPL201207002BR' and ID_Task = '13'
--select * from Tipo_Taxa
--where Nome_Tp_Tx like 'Frete interno%'
--select * from Tipo_Tarefas
--where ID_Task = '13'
--select  * from Nota_Cliente
--where Num_Proc like '%IMUPL%'

--select * from Fatura_CHB_item
--where Fatura_CC like 'IMUPL201207002BRA'

--select * from Fatura_CHB
--where Processo_PC like 'IMUPL201207002BR%'

	--spATL_DDGipxEazyTXT_Sel 'IMUPL201207047BR','DE'

CREATE procedure [dbo].[spATL_DDGipxEazyTXT_Sel] 
	@JOB varchar(16),
	@Tipo varchar(2)
as
if @Tipo = 'DD'
Begin
	declare @TAB_DD Table
		(
			[Tipo de Registro] varchar(2),
			[Número House / Master] varchar(18),
			[Dt. De Chegada] varchar(10),
			[Dt. Recebimento Documentos] varchar(10),
			[Código do Despachante] varchar(30),
			[Código do Agente] varchar(3),
			[Dt. Pagamento Impostos] varchar(10),
			[Número Registro DI] varchar(20),
			[Tx. Mercadoria] varchar(15),
			[Dt. Desembaraço]varchar(10),
			[Moeda do Frete] varchar(3),
			[Valor do Frete na Moeda] varchar(15),
			[Tx, do Frete] varchar(15),
			[Valor do Seguro na Moeda] varchar(15),
			[Moeda do Seguro] varchar(3),
			[Tx. do Seguro] varchar(15),
			[Tx. do Dolar da D.I.] varchar(15),
			[Ref. Do Despachante] varchar(15),
			[Número do Master] varchar(18),
			[Tipo de Declaração] varchar(2),
			[URF Despacho] varchar(7),
			[URF Entrada] varchar(7),
			[Recinto Alfandegado] varchar(7),
			[Modalidade despacho] varchar(1),
			[Tipo de Manifesto] varchar(2),
			[Tipo do Documento de Carga] varchar(2),
			[Utilização] char(1),
			[Número de Manifesto] varchar(50),
			[Peso Bruto] varchar(15),
			[Valor FOB na Moeda] varchar(15),
			[Número da Fatura de Serviço] varchar(6),
			[Número Nota Fiscal Entrada] varchar(20),
			[Dt. Nota Fiscal Entrada] varchar(10),
			[Vlr Total Nota Fiscal Entrada] varchar(15),
			[Dt. Entrega Mercadoria] varchar(10),
			[Dt. Registro da DI] varchar(10),
			[Valor Frete Collect] varchar(15),
			[Valor Frete Territ. Nacional] varchar(15),
			[Informações Complementares] varchar(250),
			[Canal] varchar(50)
			--TP_Frete_Him char(1)
		)
		
	insert into @TAB_DD (
	[Tipo de Registro],
	[Número House / Master],
	[Dt. De Chegada],
	[Dt. Recebimento Documentos],
	[Código do Despachante],
	[Código do Agente],
	[Dt. Pagamento Impostos],
	[Número Registro DI],
	[Tx. Mercadoria],
	[Dt. Desembaraço],
	[Moeda do Frete],
	[Valor do Frete na Moeda],
	[Tx, do Frete],
	[Valor do Seguro na Moeda],
	[Moeda do Seguro],
	[Tx. do Seguro],
	[Tx. do Dolar da D.I.],
	[Ref. Do Despachante],
	[Número do Master],
	[Tipo de Declaração],
	[URF Despacho],
	[URF Entrada],
	[Recinto Alfandegado],
	[Modalidade despacho],
	[Tipo de Manifesto],
	[Tipo do Documento de Carga],
	[Utilização],
	[Número de Manifesto],
	[Peso Bruto],
	[Valor FOB na Moeda],
	[Número da Fatura de Serviço],
	[Número Nota Fiscal Entrada],
	[Dt. Nota Fiscal Entrada],
	[Vlr Total Nota Fiscal Entrada],
	[Dt. Entrega Mercadoria],
	[Dt. Registro da DI],
	[Valor Frete Collect],
	[Valor Frete Territ. Nacional],
	[Informações Complementares],
	[Canal]
	--TP_Frete_Him
	)
	select 
		'DD' [Tipo do Registro], 
		HOU.HAWB_HIM [Número House / Master],--HOU.HAWB_HIM + ' /' + HOU.MAWB_HIM [Número House / Master], 
		convert(varchar(10),LLP.ATA_Lim,105) [Dt. De Chegada],
		convert(varchar(10),GETDATE(),105)[Dt. Recebimento Documentos],
		'004' [Código do Despachante],
		'123' [Código do Agente],
		convert(varchar(10),PO5.Data_PO_HIM,105) [Dt. Pagamento Impostos],
		PO5.Numero_PO_HIM [Número Registro DI],
		CP31.Campo_Dados [Tx. Mercadoria],
		convert(varchar(10),TP4.Dt_Conclusao,105) [Dt. Desembaraço],
		'102' [Moeda do Frete],
		 dbo.fBusca_Item_Fatura(FAT.Fatura_PC,'102') [Valor do Frete na Moeda],
		1[Tx, do Frete],
		dbo.fBusca_Item_Fatura(FAT.Fatura_PC,'103') [Valor do Seguro na Moeda],
		'103'[Moeda do Seguro],
		'1'[Tx. do Seguro],
		CP31.Campo_Dados [Tx. do Dolar da D.I.],
		left(FAT.Fatura_PC,15) [Ref. Do Despachante],
		HOU.MAWB_HIM [Número do Master],
	''[Tipo de Declaração],
	''[URF Despacho],
	''[URF Entrada],
	TM.Cd_Repart [Recinto Alfandegado],
	''[Modalidade despacho],
	''[Tipo de Manifesto],
	''[Tipo do Documento de Carga],
	''[Utilização],
		PO29.Numero_PO_HIM [Número de Manifesto],
		HOU.Peso_Bruto_HIM [Peso Bruto],
		dbo.fBusca_Item_Fatura(FAT.Fatura_PC,'101') [Valor FOB na Moeda],
		SRV.Num_NF_HIM [Número da Fatura de Serviço],
		NC.Nota_Fiscal [Número Nota Fiscal Entrada],
		convert(varchar(10),NC.Dt_Envio_RM,105) [Dt. Nota Fiscal Entrada],
		NC.Vlr_NF [Vlr Total Nota Fiscal Entrada],
		convert(varchar(10),TP13.Dt_Conclusao,105) [Dt. Entrega Mercadoria],
		convert(varchar(10),PO5.Data_PO_HIM,105) [Dt. Registro da DI],
		dbo.fBusca_Item_Fatura(FAT.Fatura_PC,'102') [Valor Frete Collect],
		dbo.fBusca_Item_Fatura(FAT.Fatura_PC,'406') [Valor Frete Territ. Nacional],
		''[Informações Complementares],
	LLP.Canal_Lim [Canal] 
	from 
	LLP_Imp_mar LLP with(nolock)
		join House_Imp_Mar		HOU		with(nolock) on HOU.Num_Proc_HIM = LLP.Num_proc_Lim
		join Fatura_CHB			FAT		with(nolock) on LLP.Num_proc_Lim = FAT.Processo_PC and FAT.Cd_Tipo = 'P' and FAT.Status_PC <> 'C'
		left outer join PO_HIM PO5 with(nolock) on LLP.Num_Proc_Lim = PO5.Num_Proc_HIM and PO5.ID_DC = 5
		left outer join Campo_Processo CP31 with(nolock) on LLP.Num_Proc_Lim = CP31.Num_Proc and CP31.Id_Campo = 31
		left outer join Tarefas_Processos TP4 with(nolock) on LLP.Num_Proc_Lim = TP4.Num_Proc and TP4.ID_Task = 4
		left outer join Tarefas_Processos TP13 with(nolock) on LLP.Num_Proc_Lim = TP13.Num_Proc and TP4.ID_Task = 13
		left outer join PO_HIM PO29 with(nolock) on LLP.Num_Proc_Lim = PO29.Num_Proc_HIM and PO29.ID_DC = 29
		left outer join Cta_Cte_Hou_Imp_Mar SRV with(nolock) on LLP.Num_Proc_Lim = SRV.Num_Proc_HIM and SRV.Cd_Tp_Tx ='srv' and SRV.DC_HIM = 'C'
		left outer join Nota_Cliente NC with(nolock) on NC.Num_Proc = @JOB and CFOP like '3%'
		left outer join Terminal TM		with(nolock) on LLP.Cd_Terminal = TM.Cd_Terminal
		--left outer join Caixa_Hou_Imp_Mar CX with(nolock) on LLP.Num_Proc_Lim = CX.Num_Proc_HIM and (Cd_Tp_Tx = 'XFR' or Cd_Tp_Tx = 'FRT')  and  DC_HIM = 'D'
	where
		LLP.Num_Proc_Lim = @JOB

	select
			[Tipo de Registro],
			dbo.PreencheString([Número House / Master],18,' ')[Número House / Master],
			replace(isnull([Dt. De Chegada],''),'-','')[Dt. De Chegada],
			replace(isnull([Dt. Recebimento Documentos],''),'-','') [Dt. Recebimento Documentos],
			[Código do Despachante],
			replace(isnull([Código do Agente],''),'-','') [Código do Agente],
			replace(isnull([Dt. Pagamento Impostos],''),'-','') [Dt. Pagamento Impostos],
			dbo.FRemoveCaracteresEspeciais([Número Registro DI]) [Número Registro DI],
			replace(str([Tx. Mercadoria],15,8),' ',0) [Tx. Mercadoria],
			replace(isnull([Dt. Desembaraço],''),'-','') [Dt. Desembaraço],
			[Moeda do Frete],
			replace(str([Valor do Frete na Moeda],15,2),' ',0) [Valor do Frete na Moeda],
			replace(str([Tx, do Frete],15,8),' ',0)[Tx, do Frete],
			replace(str([Valor do Seguro na Moeda],15,2),' ',0) [Valor do Seguro na Moeda],
			[Moeda do Seguro],
			replace(str([Tx. do Seguro],15,8),' ',0) [Tx. do Seguro],
			replace(str([Tx. do Dolar da D.I.],15,8),' ',0) [Tx. do Dolar da D.I.],
			[Ref. Do Despachante],
			dbo.PreencheString([Número do Master],18,' ')[Número do Master],
			space(2)[Tipo de Declaração],
			space(7)[URF Despacho],
			space(7)[URF Entrada],
			[Recinto Alfandegado],
			' '[Modalidade despacho],
			space(2)[Tipo de Manifesto],
			space(2)[Tipo do Documento de Carga],
			' '[Utilização],
			dbo.PreencheString([Número de Manifesto],15,' ') [Número de Manifesto],
			replace(str([Peso Bruto],15,4),' ',0) [Peso Bruto],
			replace(str([Valor FOB na Moeda],15,2),' ',0) [Valor FOB na Moeda],
			replace(str([Número da Fatura de Serviço],6),' ',0) [Número da Fatura de Serviço],
			replace(str([Número Nota Fiscal Entrada],20),' ',0) [Número Nota Fiscal Entrada],
			replace(isnull([Dt. Nota Fiscal Entrada],''),'-','') [Dt. Nota Fiscal Entrada],
			replace(str([Vlr Total Nota Fiscal Entrada],15,2),' ',0) [Vlr Total Nota Fiscal Entrada],
			replace(isnull([Dt. Entrega Mercadoria],space(8)),'-','') [Dt. Entrega Mercadoria],
			replace(isnull([Dt. Registro da DI],''),'-','') [Dt. Registro da DI],
			replace(str([Valor Frete Collect],15,2),' ',0) [Valor Frete Collect],
			replace(str([Valor Frete Territ. Nacional] ,15,2),' ',0) [Valor Frete Territ. Nacional],
			dbo.PreencheString([Informações Complementares],250,' ')[Informações Complementares],
			(Case [Canal]
				When 'Red' then '1'
				When 'Yellow' then '2'
				When 'Green' then '3'
				When 'Gray' then '4'
			else ' '
			End) [Canal]
	from 
			@TAB_DD
End
Else  If @Tipo = 'DE'
Begin
		declare @TAB_DE Table
		(
		[Tipo do Registro] varchar(2),
		[Número do House / Master] varchar(18),
		[Dt. Do Pagamento] varchar(10),
		[Código da Despesa] varchar(3),
		[Valor Despesa] varchar(17),
		[Flag Previsto / Efetivo] varchar(1),
		[Flag Importador / Despachante] varchar(1),
		[Filler] varchar(277)
		)
	insert into @TAB_DE(
		[Tipo do Registro],
		[Número do House / Master],
		[Dt. Do Pagamento],
		[Código da Despesa],
		[Valor Despesa],
		[Flag Previsto / Efetivo],
		[Flag Importador / Despachante],
		[Filler]
		)
		Select 
		'DE' [Tipo do Registro],
		HOU.HAWB_HIM [Número do House / Master],
		convert(varchar(10),getdate(),105) [Dt Do Pagamento],
		Isnull(TT.Cd_tp_tx_sis,411) [Código da Despesa],
		FCI.Vlr_PC [Valor Despesa],
		'2'[Flag Previsto / Efetivo],
		'1'[Flag Importador / Despachante],
		''[Filler]
		from
			House_imp_MAr HOU with(nolock)
		join Fatura_CHB			FAT		with(nolock) on HOU.Num_proc_him = FAT.Processo_PC and FAT.Cd_Tipo = 'P' and FAT.Status_PC <> 'C'
		join Fatura_CHB_Item	FCI		with(nolock) on FAT.Fatura_PC = FCI.Fatura_CC
		join Tipo_Taxa			TT		with(nolock) on FCI.Cd_tp_tx = TT.Cd_Tp_Tx
		where HOU.Num_Proc_HIM = @JOB
		select 
				[Tipo do Registro],
				dbo.PreencheString([Número do House / Master],18,' ')[Número do House / Master],
				replace([Dt. Do Pagamento],'-','') [Dt. Do Pagamento],
				[Código da Despesa],
				replace(str([Valor Despesa],17,2),' ',0) [Valor Despesa],
				[Flag Previsto / Efetivo],
				[Flag Importador / Despachante],
				dbo.PreencheString([Filler],277,' ')[Filler]
		from 
			@TAB_DE
End
--spATL_DDGipxEazyTXT_Sel 'IMUPL201207002BR','DE'

--alter function PreencheString (@Valor varchar, @QTD int,@string varchar )
--returns varchar(10)
--as
--begin
--return select ( replicate(' ',(18 - len(cast('HLCUATL120550064' as varchar)))) + cast('HLCUATL120550064' as Varchar))
--end

GO
