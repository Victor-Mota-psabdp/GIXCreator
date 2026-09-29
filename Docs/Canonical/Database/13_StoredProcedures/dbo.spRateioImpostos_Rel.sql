SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*

spRateioImpostos_Rel 'IMSUN201108071BR'

select * from DI_item_br where num_proc = 'IMSUN201108071BR'
*/

CREATE procedure [dbo].[spRateioImpostos_Rel]
	@JOB varchar(16)
as
IF exists(select * from nota_cliente where num_proc=@JOB)
	Begin
		select
			PROD.cd_proc_cliente Prod,
			dbo.fBusca_Custo(@JOB,NFDet.CD_Pedido, NFDet.Cd_Produto,'%Imp%Imp%') vlr_II,
			isnull(NFDet.Aliq_II,0) / 100 Aliq_II,
			dbo.fBusca_Custo(@JOB,NFDet.CD_Pedido, NFDet.Cd_Produto,'IPI - CHB%') vlr_IPI,
			isnull(NFDet.Aliq_IPI,0) / 100 Aliq_IPI,
			dbo.fBusca_Custo(@JOB,NFDet.CD_Pedido, NFDet.Cd_Produto,'IPI Compl%') Dif_IPI,
			(case when dbo.FBusca_ADTOTX(@JOB,'%ICMS%',getdate()-365, getdate(),'B') = 0 then dbo.fBusca_Custo(@JOB,NFDet.CD_Pedido, NFDet.Cd_Produto,'ICMS - CHB%') else 0 end) vlr_ICMS,
			dbo.fBusca_Custo(@JOB,NFDet.CD_Pedido, NFDet.Cd_Produto,'%SISCOMEX%') vlr_Siscomex,
			dbo.fBusca_Custo(@JOB,NFDet.CD_Pedido, NFDet.Cd_Produto,'PIS - CHB%') vlr_PIS,
			dbo.fBusca_Custo(@JOB,NFDet.CD_Pedido, NFDet.Cd_Produto,'COFINS - CHB%') vlr_Cofins,
			dbo.FBusca_ADTOTX(@JOB,'%Imp%Imp%',getdate()-365, getdate(),'%') Adiant_II,
			dbo.FBusca_ADTOTX(@JOB,'IPI - CHB%',getdate()-365, getdate(),'%') Adiant_IPI,
			dbo.FBusca_ADTOTX(@JOB,'IPI Compl%',getdate()-365, getdate(),'%') Adiant_Dif_IPI,
			dbo.FBusca_ADTOTX(@JOB,'ICMS%',getdate()-365, getdate(),'C') Adiant_ICMS_C,
			dbo.FBusca_ADTOTX(@JOB,'%SISCOMEX%',getdate()-365, getdate(),'%') Adiant_SISCOMEX,
			dbo.FBusca_ADTOTX(@JOB,'PIS%',getdate()-365, getdate(),'%') Adiant_PIS,
			dbo.FBusca_ADTOTX(@JOB,'Cofins%',getdate()-365, getdate(),'%') Adiant_COFINS
		from
			nota_cliente NF with(nolock)
			left join nota_fiscal_cliente_det NFDet with(nolock) on NFDet.id_nf = NF.id_nf and NFDet.cd_cliente = NF.cd_cliente
			left join produto_cliente PROD with(nolock) on PROD.cd_prod = NFDet.cd_produto
		where
			 NF.num_proc = @JOB
		group by
			PROD.cd_proc_cliente,
			NFDet.Aliq_II,
			NFDet.Aliq_IPI,
			NFDet.cd_pedido,
			NFDet.cd_produto
	end
ELSE
	select
		PROD.cd_proc_cliente Prod,
		sum(isnull(DII.II_Reais,0)) vlr_II,
		isnull(DII.Aliq_II,0) / 100 Aliq_II,
		sum(isnull(DII.IPI_Reais,0)) vlr_IPI,
		isnull(DII.Aliq_IPI,0) / 100 Aliq_IPI,
		0 Dif_IPI,
		0 vlr_ICMS,
		0 vlr_Siscomex,
		0 vlr_PIS,
		0 vlr_Cofins,
		dbo.FBusca_ADTOTX(@JOB,'%Imp%Imp%',getdate()-365, getdate(),'%') Adiant_II,
		dbo.FBusca_ADTOTX(@JOB,'IPI - CHB%',getdate()-365, getdate(),'%') Adiant_IPI,
		dbo.FBusca_ADTOTX(@JOB,'IPI Compl%',getdate()-365, getdate(),'%') Adiant_Dif_IPI,
		dbo.FBusca_ADTOTX(@JOB,'ICMS%',getdate()-365, getdate(),'C') Adiant_ICMS_C,
		dbo.FBusca_ADTOTX(@JOB,'%SISCOMEX%',getdate()-365, getdate(),'%') Adiant_SISCOMEX,
		dbo.FBusca_ADTOTX(@JOB,'PIS%',getdate()-365, getdate(),'%') Adiant_PIS,
		dbo.FBusca_ADTOTX(@JOB,'Cofins%',getdate()-365, getdate(),'%') Adiant_COFINS
	from
		DI_Item_BR DII with(nolock) 
		left join produto_cliente PROD with(nolock) on PROD.cd_prod = DII.cd_produto
	where
		 DII.num_proc = @JOB
	group by
		PROD.Produto_Descr,
		PROD.cd_proc_cliente,
		DII.Aliq_II, 
		DII.Aliq_IPI
GO
