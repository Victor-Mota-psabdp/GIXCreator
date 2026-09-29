SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Report Conferencia de Importação
--select * from nota_cliente where num_proc like '%ovc%'

--select * from nota_fiscal_cliente_det where id_nf = 8 and cd_cliente = 'P000007590'
--select * from nota_cliente where num_proc = 'IAOWE201205002BR'
--select * from DI_Item_BR where num_proc = 'IAOWE201205002BR'

CREATE procedure [dbo].[spConferenciaImportDET_Rel]--'IMOCV201208007BR'
	@JOB varchar(16)
as
	select distinct
		@JOB [JOB],
		Nota_fiscal NF,
		PROD.cd_proc_cliente [Codigo],
		dbo.fBusca_Docs_PO_Modal(@JOB,1) PO,
		sum(isnull(NFDet.CIF, (isnull(DII.FOB_Reais,0) + isnull(DII.Frete_Reais,0) + isnull(DII.Seguro_Reais,0)))) Vlr_CIF,
		sum(isnull(NFDet.VL_Aliq_PIS,0)) PIS,
		sum(isnull(NFDet.VL_Aliq_Cofins,0)) Cofins,
		sum(isnull(NFDet.VLr_Siscomex,0)) [Outra],
		isnull(NFDet.Aliq_II,isnull(DII.Aliq_II,0))  Aliq_II,
		isnull(NFDet.Aliq_IPI,isnull(DII.Aliq_IPI,0)) Aliq_IPI,
		isnull(NFDet.VL_Aliq_PIS,0) Aliq_PIS,
		isnull(NFDet.VL_Aliq_Cofins,0) Aliq_Cofins,
		isnull(NFDet.Aliq_ICMS,0)  Aliq_ICMS,

		sum(isnull(NFDet.VLr_Frete,0)) Frete,
	
		NF.Vlr_NF vlr_nf,
		[dbo].[fBusca_Vlr_NF_Det_Processo](@JOB,'IPI_SOMA') ipi,
		[dbo].[fBusca_Vlr_NF_Det_Processo](@JOB,'ICMS') icms,
		isnull(replace([dbo].[fBusca_CampoCliente](@JOB,31),'.',','),1) Paridade		
					
	from
		nota_cliente NF with(nolock)
		join nota_fiscal_cliente_det NFDet with(nolock) on NFDet.id_nf = NF.id_nf and NFDet.cd_cliente = NF.cd_cliente and NFDet.cd_produto = NFDet.cd_produto
		join produto_cliente PROD with(nolock) on PROD.cd_prod = NFDet.cd_produto
		left join DI_Item_BR DII with(nolock) on DII.num_proc = @JOB and DII.cd_produto = NFDet.cd_produto and DII.item = NFDet.id_item
	where
		NF.num_proc=@JOB
	group by
		Nota_fiscal,
		PROD.cd_proc_cliente,
		NFDet.CIF,DII.FOB_Reais,DII.Frete_Reais,DII.Seguro_Reais,
		NFDet.VL_Aliq_PIS,
		NFDet.vl_imposto_PIS,
		NFDet.VL_Aliq_Cofins,
		NFDet.vl_imposto_COFINS,
		NFDet.vl_IPI,DII.IPI_Reais,
		NFDet.Aliq_II,DII.Aliq_II,
		NFDet.Aliq_IPI,DII.Aliq_IPI,
		NFDet.VL_Aliq_PIS,
		NFDet.VL_Aliq_Cofins,
		NFDet.Aliq_ICMS,
		NFDet.vl_II,DII.II_Reais,
		
		NF.Vlr_NF,
		NFDet.vl_icms,
		NFDet.vl_ipi



GO
