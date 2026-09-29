SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spRateioDetalhe_Rel] --'IMSUN201204002BR'
	@JOB varchar(16)
as

declare @Incoterm varchar(3)
set @Incoterm  = (select top 1 incoterm from pedido where cd_pedido = (select top 1 cd_pedido from pedido_ship where num_proc = @JOB) )

IF exists(select * from nota_cliente where num_proc = @JOB)
	Begin
		-- ATUALIZAR cd_pedido da tab nota_fiscal_cliente_det
		Begin
			--select NDet.cd_pedido, NDet.cd_produto, NFDet.cd_pedido 
			UPDATE NDet
			set NDet.cd_pedido = PS.cd_pedido
			from nota_cliente NC
			join nota_fiscal_cliente_det NDet on NDet.id_nf = NC.id_nf and NDet.cd_cliente = NC.cd_cliente
			join pedido_ship PS on PS.num_proc=NC.num_proc and PS.cd_produto=NDet.cd_produto
			where 
				NC.num_proc = @JOB
		End

		select
			PROD.Produto_Descr,
			PROD.cd_proc_cliente Cod_Produto,
			'MP' Cod_Estoque,
			sum(isnull(NFDet.Peso_Liquido,isnull(DII.PesoLiquido,0))) Quantidade,
/* OCOMON 19476*/
			(case when @Incoterm in ('FOB','FCA','CFR','EXW') then sum(isnull(NFDet.FOB,isnull(DII.FOB_Reais,0)))
				else sum(isnull(NFDet.FOB - NFDet.Vlr_Frete ,isnull(DII.FOB_Reais - DII.Frete_Reais,0))) end)Vlr_FOB,
			(case when @Incoterm in ('CFR') then 0 else	sum(isnull(NFDet.vlr_frete,isnull(DII.Frete_Reais,0))) end) Vlr_Frete,
			sum(isnull(NFDet.vlr_seguro,isnull(DII.Seguro_Reais,0))) Vlr_Seguro,
			sum(isnull(NFDet.acrescimos,isnull(DII.Acrescimos_Reais,0))) Vlr_Handling,
			(case when @Incoterm in ('CFR') then 0 else	sum(isnull(NFDet.vlr_frete,isnull(DII.Frete_Reais,0))) end) + sum(isnull(NFDet.CIF, (isnull(DII.FOB_Reais,0) + isnull(DII.Seguro_Reais,0)))) + sum(isnull(NFDet.acrescimos,isnull(DII.Acrescimos_Reais,0))) Vlr_CIF,
	---------Adiantamento
			isnull(ADT.FOB_REAIS,0) Adiant_FOB_Capa,
			(case when @Incoterm in ('CFR') then 0 else isnull(ADT.FRETE_REAIS,0) end) Adiant_Frete_Capa,
			isnull(ADT.SEGURO_REAIS,0) Adiant_Seguro_Capa,
			isnull(ADT.ACRESCIMOS_REAIS,0) Adiant_Acrescimos_Capa
		from
			nota_cliente NF with(nolock)
			left join nota_fiscal_cliente_det NFDet with(nolock) on NFDet.id_nf = NF.id_nf and NFDet.cd_cliente = NF.cd_cliente and NFDet.cd_produto = NFDet.cd_produto
			left join produto_cliente PROD with(nolock) on PROD.cd_prod = NFDet.cd_produto
			left join ATL_Capa_Valores ADT with(nolock) on ADT.num_proc=@JOB
			left join DI_Item_BR DII with(nolock) on DII.num_proc = @JOB and DII.cd_produto = NFDet.cd_produto and DII.item = NFDet.id_item
		where
			NF.num_proc=@JOB
		group by
			PROD.Produto_Descr,
			PROD.cd_proc_cliente,
			NFDet.cd_pedido,
			NFDet.cd_produto,
			ADT.FOB_REAIS,
			ADT.FRETE_REAIS,
			ADT.SEGURO_REAIS,
			ADT.ACRESCIMOS_REAIS

	End
ELSE
	Begin
		select
			PROD.Produto_Descr,
			PROD.cd_proc_cliente Cod_Produto,
			'MP' Cod_Estoque,
			(case when sum(DII.PesoLiquido) = 0 then sum(PD.qty) else sum(isnull(DII.PesoLiquido,isnull(PD.qty,1))) end) Quantidade,
--			sum(isnull(DII.PesoLiquido,isnull(PD.qty,1))) Quantidade,
			(case when @Incoterm in ('FOB','FCA','CFR','EXW') then sum(isnull(DII.FOB_Reais,0))
				else sum(isnull(DII.FOB_Reais - DII.Frete_Reais,0)) end)Vlr_FOB,
			(case when @Incoterm in ('CFR') then 0 else	sum(isnull(DII.Frete_Reais,0)) end) Vlr_Frete,
--			sum(isnull(DII.Frete_Reais,0)) Vlr_Frete, OCOMON 19476 
			sum(isnull(DII.Seguro_Reais,0)) Vlr_Seguro,
			sum(isnull(DII.Acrescimos_Reais,0)) Vlr_Handling,
			--OCOMON 19894
			(case when @Incoterm in ('CFR') then 0 else	sum(isnull(DII.Frete_Reais,0)) end) + sum((isnull(DII.FOB_Reais,0) + isnull(DII.Seguro_Reais,0))) + sum(isnull(DII.Acrescimos_Reais,0)) Vlr_CIF,
	---------Adiantamento
			isnull(ADT.FOB_REAIS,0) Adiant_FOB_Capa,
			(case when @Incoterm in ('CFR') then 0 else isnull(ADT.FRETE_REAIS,0) end) Adiant_Frete_Capa,
			isnull(ADT.SEGURO_REAIS,0) Adiant_Seguro_Capa,
			isnull(ADT.ACRESCIMOS_REAIS,0) Adiant_Acrescimos_Capa
		from
			pedido_ship PS with(nolock)
			join pedido P with(nolock) on P.cd_pedido = PS.cd_pedido
			join pedido_det PD with(nolock) on PD.cd_pedido = PS.cd_pedido and PD.item = PS.item and PD.cd_produto = PS.cd_produto and PS.lote = PD.lote
			left join produto_cliente PROD with(nolock) on PROD.cd_prod = PD.cd_produto
			left join ATL_Capa_Valores ADT with(nolock) on ADT.num_proc=@JOB
			left join DI_Item_BR DII with(nolock) on DII.num_proc = @JOB and DII.cd_produto = PD.cd_produto --and PD.item = DII.item
		where
			PS.num_proc=@JOB
		group by
			PROD.Produto_Descr,
			PROD.cd_proc_cliente,
			PD.cd_pedido,
			PD.cd_produto,
			ADT.FOB_REAIS,
			ADT.FRETE_REAIS,
			ADT.SEGURO_REAIS,
			ADT.ACRESCIMOS_REAIS,
			P.incoterm
	End

/*
spRateioDetalhe_Rel 'IMSUN201201003BR'
select * from DI_Item_BR where num_proc = 'IMSUN201201003BR'


select (78353.22+1496.3+94.81)/1.92822 -- CIF

select (78353.22)/1.92822 --FOB
select (1496.3)/1.92822 -- frete
select (94.81)/1.92822 -- seguro




bom dia
IMSUN201201003BR - as somas não conferem
Total CIF - USD somas não conferem - correto USD 40684,17 # 433,20
40635,00 + 49,17 = 40684,17 consta na planilha 41117,37



Total CIF - R$ somas não conferem - correto R$ 79109,03 # 835,30
78353,22 + 94,81 + 661 = 79109,03 consta na planilha 79944,33

Não conseguimos identificar de onde sai essa diferença #
*/


GO
