SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[spCusteioJOBv2_Rel]
(
	@Tipo int,
	@JOB varchar(16)
)
as

IF @Tipo = 1 --Cabeçalho
	Begin
		select dbo.fBusca_Docs_PO_Modal(@JOB,1) [Ref. Cliente], dbo.fBusca_Docs_PO_Modal(@JOB,5) [Nº D.I.], @JOB [Ref. BDP]
	End

ELSE IF @Tipo = 2 --Contas Contabeis

	Begin

		declare @CtaCtb table(Item int, Filial int, Conta varchar(50), CCusto varchar(10), [Debito Valor] float, [Credito Valor] float)

		insert @CtaCtb
		select 1,	1,	'Valor da Mercadoria','','','' union all
		select 2,	1,	'10432 - ICMS a Recuperar','','','' union all
		select 3,	1,	'12510 - ITAU SP - 124530 Santander','','','' union all
		select 4,	1,	'10431 - IPI a Recuperar','','','' union all
		select 5,	1,	'10439 - PIS a Recuperar','','','' union all
		select 6,	1,	'10442 - Cofins a Recuperar','','','' union all
		select 7,	1,	'10335 ou 12510 - Conta Variavel','','','' union all
		select 8,	1,	'Fornecedor Estrangeiro','','','' union all
		select 9,	1,	'10335 - Siscomex ITAU','','','' union all
		select 10,	1,	'20200 - Seguros Imports','','','' union all
		select 11,	1,	'BDP - Despachante','','','' union all
		select 12,	1,	'10335 - ITAU siscomex','','',''

		-- Valor FOB
		declare @vlrFOB float
		set @vlrFOB = (select isnull(FOB_REAIS,0) from ATL_Capa_Valores where num_proc = @JOB)

		-- Valor II
		declare @vlrII float
		set @vlrII = (select isnull(sum(vlr_pc),0) from fatura_chb_item FCI
			join fatura_chb FC on FC.fatura_pc = FCI.fatura_cc
			join tipo_taxa TT on TT.cd_tp_tx = FCI.cd_tp_tx
			where processo_pc = @JOB and tp_pgto = 'C' and status_pc = 'E' and TT.nome_tp_tx like 'Imp%Imp%')

		-- Despesas BDP da Prestação de Contas
		declare @vlrDespachante float
		set @vlrDespachante = (select isnull(sum(vlr_pc),0) from fatura_chb_item FCI
			join fatura_chb FC on FC.fatura_pc = FCI.fatura_cc
			join tipo_taxa TT on TT.cd_tp_tx = FCI.cd_tp_tx and TT.nome_tp_tx NOT like 'Adiant%'
			where processo_pc = @JOB and tp_pgto = 'B' and status_pc = 'E')
		Begin
			Update @CtaCtb
			set [Credito Valor] = @vlrDespachante
			where item = 11
		End

		-- Valor FRETE - Caso NÃO tenha na Prest_Contas pegar na ATL_Capa_Valores
		declare @vlrFrete float
		set @vlrFrete = (select isnull(sum(vlr_pc),0) from fatura_chb_item FCI
			join fatura_chb FC on FC.fatura_pc = FCI.fatura_cc
			join tipo_taxa TT on TT.cd_tp_tx = FCI.cd_tp_tx
			where processo_pc = @JOB and tp_pgto = 'B' and status_pc = 'E' and TT.nome_tp_tx like 'Frete%')
		IF @vlrFrete > 0
			Begin
				set @vlrFrete = 0 -- pq já estará na Prestação
			End
		Else
			Begin
				set @vlrFrete = (select isnull(FRETE_REAIS,0) from ATL_Capa_Valores where num_proc = @JOB)
			End
	
		-- 10432 - ICMS a Recuperar
		declare @vlrICMS float
		set @vlrICMS = (select isnull(sum(vlr_pc),0) from fatura_chb_item FCI
			join fatura_chb FC on FC.fatura_pc = FCI.fatura_cc
			join tipo_taxa TT on TT.cd_tp_tx = FCI.cd_tp_tx
			where processo_pc = @JOB and tp_pgto = 'C' and status_pc = 'E' and TT.nome_tp_tx like 'ICMS - CHB')
		Begin
			Update @CtaCtb
			set [Debito Valor] = @vlrICMS
			where item = 2
		End

		--12510 - ITAU SP - 124530 Santander
		Begin
			Update @CtaCtb
			set [Credito Valor] = @vlrICMS
			where item = 3
		End

		--10431 - IPI a Recuperar
		declare @vlrIPI float
		set @vlrIPI = (select isnull(sum(vlr_pc),0) from fatura_chb_item FCI
			join fatura_chb FC on FC.fatura_pc = FCI.fatura_cc
			join tipo_taxa TT on TT.cd_tp_tx = FCI.cd_tp_tx
			where processo_pc = @JOB and tp_pgto = 'C' and status_pc = 'E' and TT.nome_tp_tx like 'IPI%')
		Begin
			Update @CtaCtb
			set [Debito Valor] = @vlrIPI
			where item = 4
		End

		--10439 - PIS a Recuperar
		declare @vlrPIS float
		set @vlrPIS = (select isnull(sum(vlr_pc),0) from fatura_chb_item FCI
			join fatura_chb FC on FC.fatura_pc = FCI.fatura_cc
			join tipo_taxa TT on TT.cd_tp_tx = FCI.cd_tp_tx
			where processo_pc = @JOB and tp_pgto = 'C' and status_pc = 'E' and TT.nome_tp_tx like 'PIS%')
		Begin
			Update @CtaCtb
			set [Debito Valor] = @vlrPIS
			where item = 5
		End

		--10442 - Cofins a Recuperar
		declare @vlrCOFINS float
		set @vlrCOFINS = (select isnull(sum(vlr_pc),0) from fatura_chb_item FCI
			join fatura_chb FC on FC.fatura_pc = FCI.fatura_cc
			join tipo_taxa TT on TT.cd_tp_tx = FCI.cd_tp_tx
			where processo_pc = @JOB and tp_pgto = 'C' and status_pc = 'E' and TT.nome_tp_tx like 'COFINS - CHB')
		set @vlrCOFINS = 1249.17
		Begin
			Update @CtaCtb
			set [Debito Valor] = @vlrCOFINS
			where item = 6
		End

		--10335 ou 12510 - Conta Variavel
		declare @vlrSISCOMEX float
		set @vlrSISCOMEX = (select isnull(sum(vlr_pc),0) from fatura_chb_item FCI
			join fatura_chb FC on FC.fatura_pc = FCI.fatura_cc
			join tipo_taxa TT on TT.cd_tp_tx = FCI.cd_tp_tx
			where processo_pc = @JOB and status_pc = 'E' and tp_pgto = 'C' and TT.nome_tp_tx like '%SISCOMEX%')
		Begin
			Update @CtaCtb
			set [Credito Valor] =  @vlrII + @vlrIPI + @vlrPIS + @vlrCOFINS + @vlrSISCOMEX
			where item = 7
		End

		--Fornecedor Estrangeiro
		declare @vlrINVOICE float
		set @vlrINVOICE =(select isnull(sum(vlr_item_custo),0) from custo_cliente where num_proc = @JOB and cd_tp_tx = 'FOB')
		Begin
			Update @CtaCtb
			set [Credito Valor] =  @vlrFOB
			where item = 8
		End

		--10335 - Siscomex ITAU
		Begin
			Update @CtaCtb
			set [Credito Valor] =  @vlrII + @vlrSISCOMEX
			where item = 9
		End

		--20200 - Seguros Imports
		declare @vlrSEGURO float
		set @vlrSEGURO = (select isnull(sum(vlr_pc),0) from fatura_chb_item FCI
			join fatura_chb FC on FC.fatura_pc = FCI.fatura_cc
			join tipo_taxa TT on TT.cd_tp_tx = FCI.cd_tp_tx
			where processo_pc = @JOB and status_pc = 'E' and TT.nome_tp_tx like '%Seguro%')
		Begin
			Update @CtaCtb
			set [Credito Valor] =  @vlrSEGURO
			where item = 10
		End
		--Valor da Mercadoria
		Begin
			Update @CtaCtb
			set [Debito Valor] = @vlrFOB + @vlrII + @vlrDespachante + @vlrFrete + @vlrSiscomex + @vlrSeguro
			where item = 1
		End

		--BDP - Despachante
		Begin
			Update @CtaCtb
			set [Credito Valor] = @vlrDespachante
			where item = 11
		End

		--10335 - ITAU siscomex
		Begin
			Update @CtaCtb
			set [Debito Valor] =  @vlrII + @vlrSISCOMEX
			where item = 12
		End


		select * from @CtaCtb
		union all
		select null, null, null, 'TOTAL', sum([Debito Valor]), sum([Credito Valor]) from @CtaCtb

		select @vlrFOB FOB, @vlrII II, @vlrDespachante Despachante, @vlrFrete Frete, @vlrICMS ICMS, @vlrPIS PIS, @vlrIPI IPI, @vlrCOFINS Cofins, @vlrSISCOMEX Siscomex, @vlrSEGURO Seguro

	End

/*
spCusteioJOBv2_Rel 2, 'IMSUN201108070BR'

select * from fatura_chb_item FCI
join fatura_chb FC on FC.fatura_pc = FCI.fatura_cc
join tipo_taxa TT on TT.cd_tp_tx = FCI.cd_tp_tx
where processo_pc = 'IMSUN201108070BR' and status_pc = 'E' and TT.nome_tp_tx like '%seguro%'
*/



GO
