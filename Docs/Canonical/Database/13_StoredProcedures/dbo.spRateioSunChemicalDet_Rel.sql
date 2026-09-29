SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*

spRateioSunChemical_Rel 'IMSUN201108003BR'
spRateioSunChemicalDet_Rel 'IMSUN201108003BR'

select * from pedido_ship where num_proc='IASUN201110001BR'
select * from pedido_det where cd_pedido='70357'
select * from nota_cliente where num_proc='IMSUN201108003BR'
select * from nota_fiscal_cliente_det where  id_nf=576 and cd_cliente = 'P000004794'
select * from DI_Item_BR where num_proc = 'IMSUN201108022BR'
select * from ATL_Capa_Valores where num_proc = 'IMSUN201108072BR'
*/

CREATE procedure [dbo].[spRateioSunChemicalDet_Rel]
	@JOB varchar(16)
as

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

		declare @Incoterm varchar(3)
		set @Incoterm  = (select top 1 incoterm from pedido where cd_pedido = (select top 1 cd_pedido from pedido_ship where num_proc = @JOB) )

		select
			PROD.Produto_Descr,
			PROD.cd_proc_cliente Cod_Produto,
			'MP' Cod_Estoque,
			sum(isnull(NFDet.Peso_Liquido,isnull(DII.PesoLiquido,0))) Quantidade,
--			(isnull(sum(isnull(NFDet.FOB,0)) / sum(isnull(NFDet.quantidade,1)),isnull(sum(DII.FOB_Reais) / sum(DII.PesoLiquido) , DII.vlr_item))) Vlr_Unitario,
			(case when @Incoterm in ('FOB','FCA') then sum(isnull(NFDet.FOB,isnull(DII.FOB_Reais,0)))
				else sum(isnull(NFDet.FOB - NFDet.Vlr_Frete ,isnull(DII.FOB_Reais - DII.Frete_Reais,0))) end)Vlr_FOB,
			sum(isnull(NFDet.vlr_frete,isnull(DII.Frete_Reais,0))) Vlr_Frete,
			sum(isnull(NFDet.vlr_seguro,isnull(DII.Seguro_Reais,0))) Vlr_Seguro,
			sum(isnull(NFDet.acrescimos,isnull(DII.Acrescimos_Reais,0))) Vlr_Handling,
			sum(isnull(NFDet.CIF, (isnull(DII.FOB_Reais,0) + isnull(DII.Frete_Reais,0) + isnull(DII.Seguro_Reais,0)))) Vlr_CIF,
			sum(isnull(NFDet.vl_II,isnull(DII.II_Reais,0))) vlr_II,
			isnull(NFDet.Aliq_II,isnull(DII.Aliq_II,0)) Aliq_II,
			sum(isnull(NFDet.vl_IPI,isnull(DII.IPI_Reais,0))) vlr_IPI,
			isnull(NFDet.Aliq_IPI,isnull(DII.Aliq_IPI,0)) Aliq_IPI,
			0 Dif_IPI,
			(case when dbo.FBusca_ADTOTX(@JOB,'%ICMS%',getdate()-365, getdate(),'B') = 0 then sum(isnull(NFDet.vl_ICMS,0)) else 0 end) vlr_ICMS,
			sum(isnull(NFDet.vlr_Siscomex,0)) vlr_Siscomex,
			sum(isnull(NFDet.vl_imposto_PIS,0)) vlr_PIS,
			sum(isnull(NFDet.vl_imposto_COFINS,0)) vlr_Cofins,
			dbo.fBusca_Custo(@JOB,NFDet.cd_pedido, NFDet.cd_produto,'Serv%Desp%') + 
			dbo.fBusca_Custo(@JOB,NFDet.cd_pedido, NFDet.cd_produto,'Gestão%') Serv_Desp,
			dbo.fBusca_Custo(@JOB,NFDet.cd_pedido, NFDet.cd_produto,'%Remo%') Remocao,
			dbo.fBusca_Custo(@JOB,NFDet.cd_pedido, NFDet.cd_produto,'SDA%') SDA,
			dbo.fBusca_Custo(@JOB,NFDet.cd_pedido, NFDet.cd_produto,'%Armazenagem%') Armazenagem,
			dbo.fBusca_Custo(@JOB,NFDet.cd_pedido, NFDet.cd_produto,'Lib%BL%') Liberacao_BL,
			dbo.fBusca_Custo(@JOB,NFDet.cd_pedido, NFDet.cd_produto,'LI %') +
			dbo.fBusca_Custo(@JOB,NFDet.cd_pedido, NFDet.cd_produto,'%licen%') Pgto_LI,
			dbo.fBusca_Custo(@JOB,NFDet.cd_pedido, NFDet.cd_produto,'THC%') +
			dbo.fBusca_Custo(@JOB,NFDet.cd_pedido, NFDet.cd_produto,'Capatazia%') Capatazia,
			dbo.fBusca_Custo(@JOB,NFDet.cd_pedido, NFDet.cd_produto,'Desconso%') Desconsolidacao,
			dbo.fBusca_Custo(@JOB,NFDet.cd_pedido, NFDet.cd_produto,'%AFRMM%') AFRMM,
			dbo.fBusca_Custo(@JOB,NFDet.cd_pedido, NFDet.cd_produto,'%Demurrage%') + dbo.fBusca_Custo(@JOB,NFDet.cd_pedido, NFDet.cd_produto,'%Depos%Cont%') Demurrage,
			dbo.fBusca_Custo(@JOB,NFDet.cd_pedido, NFDet.cd_produto,'%Desov%') Desova,
			dbo.fBusca_Custo(@JOB,NFDet.cd_pedido, NFDet.cd_produto,'%Fumiga%') Fumigacao,
			0 CPMF,
			dbo.fBusca_Custo(@JOB,NFDet.cd_pedido, NFDet.cd_produto,'Frete') +
			dbo.fBusca_Custo(@JOB,NFDet.cd_pedido, NFDet.cd_produto,'FRETE - CHB') +
			dbo.fBusca_Custo(@JOB,NFDet.cd_pedido, NFDet.cd_produto,'Fretes - CHB') Frete,
			(case when dbo.FBusca_ADTOTX(@JOB,'%ICMS%',getdate()-365, getdate(),'C') = 0 then dbo.fBusca_Custo(@JOB,NFDet.cd_pedido, NFDet.cd_produto,'%ICMS%') else 0 end) ICMS,
			0 Outros,
			dbo.fBusca_Custo(@JOB,NFDet.cd_pedido, NFDet.cd_produto,'Frete Int%') +
			dbo.fBusca_Custo(@JOB,NFDet.cd_pedido, NFDet.cd_produto,'Transp%') Transporte,
			dbo.fBusca_Custo(@JOB,NFDet.cd_pedido, NFDet.cd_produto,'IRRF%') *-1 IRRF_Serv,
			dbo.fBusca_Custo(@JOB,NFDet.cd_pedido, NFDet.cd_produto,'CSLL (01) (1,00%)')*-1 CSLL_Serv,
			dbo.fBusca_Custo(@JOB,NFDet.cd_pedido, NFDet.cd_produto,'PIS(01) (0,65%) ')*-1 PIS_Serv,
			dbo.fBusca_Custo(@JOB,NFDet.cd_pedido, NFDet.cd_produto,'Cofins (01) (3,00%)')*-1 COFINS_Serv,
			dbo.fBusca_Custo(@JOB,NFDet.cd_pedido, NFDet.cd_produto,'ICMS s/ Transp.') *-1 ICMS_S_Transp,
	---------Adiantamento
			isnull(ADT.FOB_REAIS,0) Adiant_FOB_Capa,
			isnull(ADT.FRETE_REAIS,0) Adiant_Frete_Capa,
			isnull(ADT.SEGURO_REAIS,0) Adiant_Seguro_Capa,
			isnull(ADT.ACRESCIMOS_REAIS,0) Adiant_Acrescimos_Capa,
			dbo.FBusca_ADTOTX(@JOB,'Serv%Desp%',getdate()-365, getdate(),'B') + 
			dbo.FBusca_ADTOTX(@JOB,'Gestão%',getdate()-365, getdate(),'B') Adiant_Serv_Desp,
			dbo.FBusca_ADTOTX(@JOB,'%Remo%',getdate()-365, getdate(),'B') Adiant_Remocao,
			dbo.FBusca_ADTOTX(@JOB,'SDA%',getdate()-365, getdate(),'B') Adiant_SDA,
			dbo.FBusca_ADTOTX(@JOB,'%Armazenagem%',getdate()-365, getdate(),'B') Adiant_Armazenagem,
			dbo.FBusca_ADTOTX(@JOB,'Lib%BL%',getdate()-365, getdate(),'B') Adiant_Liberacao_BL,
			dbo.FBusca_ADTOTX(@JOB,'LI %',getdate()-365, getdate(),'B') +
			dbo.FBusca_ADTOTX(@JOB,'%licen%',getdate()-365, getdate(),'B') Adiant_Pgto_LI,
			dbo.FBusca_ADTOTX(@JOB,'THC%',getdate()-365, getdate(),'B') +
			dbo.FBusca_ADTOTX(@JOB,'Capatazia%',getdate()-365, getdate(),'B') Adiant_Capatazia,
			dbo.FBusca_ADTOTX(@JOB,'Desconso%',getdate()-365, getdate(),'B') Adiant_Desconsolidacao,
			dbo.FBusca_ADTOTX(@JOB,'%AFRMM%',getdate()-365, getdate(),'B') Adiant_AFRMM,
			dbo.FBusca_ADTOTX(@JOB,'%Demurrage%',getdate()-365, getdate(),'B') Adiant_Demurrage,
			dbo.FBusca_ADTOTX(@JOB,'%Desov%',getdate()-365, getdate(),'B') Adiant_Desova,
			dbo.FBusca_ADTOTX(@JOB,'%Fumiga%',getdate()-365, getdate(),'B') Adiant_Fumigacao,
			0 Adiant_CPMF,
			dbo.FBusca_ADTOTX(@JOB,'Frete',getdate()-365, getdate(),'B') +
			dbo.FBusca_ADTOTX(@JOB,'FRETE - CHB',getdate()-365, getdate(),'B') +
			dbo.FBusca_ADTOTX(@JOB,'Fretes - CHB',getdate()-365, getdate(),'B') Adiant_Frete,
			dbo.FBusca_ADTOTX(@JOB,'%ICMS%',getdate()-365, getdate(),'B') Adiant_ICMS_B,
			0 Adiant_Outros,
			dbo.FBusca_ADTOTX(@JOB,'Frete Int%',getdate()-365, getdate(),'B') +
			dbo.FBusca_ADTOTX(@JOB,'Transport%',getdate()-365, getdate(),'B') Adiant_Transporte,

			dbo.FBusca_ADTOTX(@JOB,'%Imp%Imp%',getdate()-365, getdate(),'%') Adiant_II,
			dbo.FBusca_ADTOTX(@JOB,'IPI - CHB%',getdate()-365, getdate(),'%') Adiant_IPI,
			dbo.FBusca_ADTOTX(@JOB,'IPI Compl%',getdate()-365, getdate(),'%') Adiant_Dif_IPI,
			dbo.FBusca_ADTOTX(@JOB,'ICMS%',getdate()-365, getdate(),'C') Adiant_ICMS_C,
			dbo.FBusca_ADTOTX(@JOB,'%SISCOMEX%',getdate()-365, getdate(),'%') Adiant_SISCOMEX,
			dbo.FBusca_ADTOTX(@JOB,'PIS%',getdate()-365, getdate(),'%') Adiant_PIS,
			dbo.FBusca_ADTOTX(@JOB,'Cofins%',getdate()-365, getdate(),'%') Adiant_COFINS,
			dbo.FBusca_ADTOTX(@JOB,'%',getdate()-365, getdate(),'B') Adiant_TOTAL
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
			NFDet.Aliq_II,
			NFDet.Aliq_IPI,
			NFDet.cd_pedido,
			NFDet.cd_produto,
			NFDet.Vlr_Item,
			ADT.FOB_REAIS,
			ADT.FRETE_REAIS,
			ADT.SEGURO_REAIS,
			ADT.ACRESCIMOS_REAIS,
			DII.Aliq_II, 
			DII.Aliq_IPI,
			DII.Vlr_Item
	End
ELSE
	Begin
		select
			PROD.Produto_Descr,
			PROD.cd_proc_cliente Cod_Produto,
			'MP' Cod_Estoque,
			sum(isnull(DII.PesoLiquido,isnull(PD.qty,0))) Quantidade,
--			null Vlr_Unitario,
			(case when P.Incoterm in ('FOB','FCA') then sum(isnull(DII.FOB_Reais,0))
				else sum(isnull(DII.FOB_Reais - DII.Frete_Reais,0)) end)Vlr_FOB,
			sum(isnull(DII.Frete_Reais,0)) Vlr_Frete,
			sum(isnull(DII.Seguro_Reais,0)) Vlr_Seguro,
			sum(isnull(DII.Acrescimos_Reais,0)) Vlr_Handling,
			sum((isnull(DII.FOB_Reais,0) + isnull(DII.Frete_Reais,0) + isnull(DII.Seguro_Reais,0))) Vlr_CIF,
			sum(isnull(DII.II_Reais,0)) vlr_II,
			isnull(DII.Aliq_II,0) Aliq_II,
			sum(isnull(DII.IPI_Reais,0)) vlr_IPI,
			isnull(DII.Aliq_IPI,0) Aliq_IPI,
			0 Dif_IPI,
			(case when dbo.FBusca_ADTOTX(@JOB,'%ICMS%',getdate()-365, getdate(),'B') = 0 then 0 else 0 end) vlr_ICMS,
			0 vlr_Siscomex,
			0 vlr_PIS,
			0 vlr_Cofins,
			dbo.fBusca_Custo(@JOB,PD.cd_pedido, PD.cd_produto,'Serv%Desp%') + 
			dbo.fBusca_Custo(@JOB,PD.cd_pedido, PD.cd_produto,'Gestão%') Serv_Desp,
			dbo.fBusca_Custo(@JOB,PD.cd_pedido, PD.cd_produto,'%Remo%') Remocao,
			dbo.fBusca_Custo(@JOB,PD.cd_pedido, PD.cd_produto,'SDA%') SDA,
			dbo.fBusca_Custo(@JOB,PD.cd_pedido, PD.cd_produto,'%Armazenagem%') Armazenagem,
			dbo.fBusca_Custo(@JOB,PD.cd_pedido, PD.cd_produto,'Lib%BL%') Liberacao_BL,
			dbo.fBusca_Custo(@JOB,PD.cd_pedido, PD.cd_produto,'LI %') +
			dbo.fBusca_Custo(@JOB,PD.cd_pedido, PD.cd_produto,'%licen%') Pgto_LI,
			dbo.fBusca_Custo(@JOB,PD.cd_pedido, PD.cd_produto,'THC%') +
			dbo.fBusca_Custo(@JOB,PD.cd_pedido, PD.cd_produto,'Capatazia%') Capatazia,
			dbo.fBusca_Custo(@JOB,PD.cd_pedido, PD.cd_produto,'Desconso%') Desconsolidacao,
			dbo.fBusca_Custo(@JOB,PD.cd_pedido, PD.cd_produto,'%AFRMM%') AFRMM,
			dbo.fBusca_Custo(@JOB,PD.cd_pedido, PD.cd_produto,'%Demurrage%') Demurrage,
			dbo.fBusca_Custo(@JOB,PD.cd_pedido, PD.cd_produto,'%Desov%') Desova,
			dbo.fBusca_Custo(@JOB,PD.cd_pedido, PD.cd_produto,'%Fumiga%') Fumigacao,
			0 CPMF,
			dbo.fBusca_Custo(@JOB,PD.cd_pedido, PD.cd_produto,'Frete') +
			dbo.fBusca_Custo(@JOB,PD.cd_pedido, PD.cd_produto,'FRETE - CHB') +
			dbo.fBusca_Custo(@JOB,PD.cd_pedido, PD.cd_produto,'Fretes - CHB') Frete,
			(case when dbo.FBusca_ADTOTX(@JOB,'%ICMS%',getdate()-365, getdate(),'C') = 0 then dbo.fBusca_Custo(@JOB,PD.cd_pedido, PD.cd_produto,'%ICMS%') else 0 end) ICMS,
			0 Outros,
			dbo.fBusca_Custo(@JOB,PD.cd_pedido, PD.cd_produto,'Frete Int%') +
			dbo.fBusca_Custo(@JOB,PD.cd_pedido, PD.cd_produto,'Transp%') Transporte,
			dbo.fBusca_Custo(@JOB,PD.cd_pedido, PD.cd_produto,'IRRF%') *-1 IRRF_Serv,
			dbo.fBusca_Custo(@JOB,PD.cd_pedido, PD.cd_produto,'CSLL (01) (1,00%)')*-1 CSLL_Serv,
			dbo.fBusca_Custo(@JOB,PD.cd_pedido, PD.cd_produto,'PIS(01) (0,65%) ')*-1 PIS_Serv,
			dbo.fBusca_Custo(@JOB,PD.cd_pedido, PD.cd_produto,'Cofins (01) (3,00%)')*-1 COFINS_Serv,
			dbo.fBusca_Custo(@JOB,PD.cd_pedido, PD.cd_produto,'ICMS s/ Transp.') ICMS_S_Transp,
	---------Adiantamento
			isnull(ADT.FOB_REAIS,0) Adiant_FOB_Capa,
			isnull(ADT.FRETE_REAIS,0) Adiant_Frete_Capa,
			isnull(ADT.SEGURO_REAIS,0) Adiant_Seguro_Capa,
			isnull(ADT.ACRESCIMOS_REAIS,0) Adiant_Acrescimos_Capa,
			dbo.FBusca_ADTOTX(@JOB,'Serv%Desp%',getdate()-365, getdate(),'B') + 
			dbo.FBusca_ADTOTX(@JOB,'Gestão%',getdate()-365, getdate(),'B') Adiant_Serv_Desp,
			dbo.FBusca_ADTOTX(@JOB,'%Remo%',getdate()-365, getdate(),'B') Adiant_Remocao,
			dbo.FBusca_ADTOTX(@JOB,'SDA%',getdate()-365, getdate(),'B') Adiant_SDA,
			dbo.FBusca_ADTOTX(@JOB,'%Armazenagem%',getdate()-365, getdate(),'B') Adiant_Armazenagem,
			dbo.FBusca_ADTOTX(@JOB,'Lib%BL%',getdate()-365, getdate(),'B') Adiant_Liberacao_BL,
			dbo.FBusca_ADTOTX(@JOB,'LI %',getdate()-365, getdate(),'B') +
			dbo.FBusca_ADTOTX(@JOB,'%licen%',getdate()-365, getdate(),'B') Adiant_Pgto_LI,
			dbo.FBusca_ADTOTX(@JOB,'THC%',getdate()-365, getdate(),'B') +
			dbo.FBusca_ADTOTX(@JOB,'Capatazia%',getdate()-365, getdate(),'B') Adiant_Capatazia,
			dbo.FBusca_ADTOTX(@JOB,'Desconso%',getdate()-365, getdate(),'B') Adiant_Desconsolidacao,
			dbo.FBusca_ADTOTX(@JOB,'%AFRMM%',getdate()-365, getdate(),'B') Adiant_AFRMM,
			dbo.FBusca_ADTOTX(@JOB,'%Demurrage%',getdate()-365, getdate(),'B') Adiant_Demurrage,
			dbo.FBusca_ADTOTX(@JOB,'%Desov%',getdate()-365, getdate(),'B') Adiant_Desova,
			dbo.FBusca_ADTOTX(@JOB,'%Fumiga%',getdate()-365, getdate(),'B') Adiant_Fumigacao,
			0 Adiant_CPMF,
			dbo.FBusca_ADTOTX(@JOB,'Frete',getdate()-365, getdate(),'B') +
			dbo.FBusca_ADTOTX(@JOB,'FRETE - CHB',getdate()-365, getdate(),'B') +
			dbo.FBusca_ADTOTX(@JOB,'Fretes - CHB',getdate()-365, getdate(),'B') Adiant_Frete,
			dbo.FBusca_ADTOTX(@JOB,'%ICMS%',getdate()-365, getdate(),'B') Adiant_ICMS_B,
			0 Adiant_Outros,
			dbo.FBusca_ADTOTX(@JOB,'Frete Int%',getdate()-365, getdate(),'B') +
			dbo.FBusca_ADTOTX(@JOB,'Transport%',getdate()-365, getdate(),'B') Adiant_Transporte,

			dbo.FBusca_ADTOTX(@JOB,'%Imp%Imp%',getdate()-365, getdate(),'%') Adiant_II,
			dbo.FBusca_ADTOTX(@JOB,'IPI - CHB%',getdate()-365, getdate(),'%') Adiant_IPI,
			dbo.FBusca_ADTOTX(@JOB,'IPI Compl%',getdate()-365, getdate(),'%') Adiant_Dif_IPI,
			dbo.FBusca_ADTOTX(@JOB,'ICMS%',getdate()-365, getdate(),'C') Adiant_ICMS_C,
			dbo.FBusca_ADTOTX(@JOB,'%SISCOMEX%',getdate()-365, getdate(),'%') Adiant_SISCOMEX,
			dbo.FBusca_ADTOTX(@JOB,'PIS%',getdate()-365, getdate(),'%') Adiant_PIS,
			dbo.FBusca_ADTOTX(@JOB,'Cofins%',getdate()-365, getdate(),'%') Adiant_COFINS,
			dbo.FBusca_ADTOTX(@JOB,'%',getdate()-365, getdate(),'B') Adiant_TOTAL
		from
			pedido_ship PS with(nolock)
			join pedido P with(nolock) on P.cd_pedido = PS.cd_pedido
			join pedido_det PD with(nolock) on PD.cd_pedido = PS.cd_pedido and PD.item = PS.item and PD.cd_produto = PS.cd_produto
			left join produto_cliente PROD with(nolock) on PROD.cd_prod = PD.cd_produto
			left join ATL_Capa_Valores ADT with(nolock) on ADT.num_proc=@JOB
			left join DI_Item_BR DII with(nolock) on DII.num_proc = @JOB and DII.cd_produto = PD.cd_produto
		where
			PS.num_proc=@JOB
		group by
			PROD.Produto_Descr,
			PROD.cd_proc_cliente,
			PD.cd_pedido,
			PD.cd_produto,
			PD.Vlr_Item,
			ADT.FOB_REAIS,
			ADT.FRETE_REAIS,
			ADT.SEGURO_REAIS,
			ADT.ACRESCIMOS_REAIS,
			DII.Aliq_II, 
			DII.Aliq_IPI,
			DII.Vlr_Item,
			P.incoterm
	End

GO
