SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from [dbo].[vwNota_cliente] where Num_Proc = 'IMSOL201911017BR'


--select * from [dbo].[vwNota_cliente] where Num_Proc = 'IMSOL201911017BR'
CREATE view [dbo].[vwNota_cliente]

as

select
	vlr_nf,
	sum(CIF - vlr_frete - vlr_seguro - isnull(acrescimos,0)) totFOB,
	sum(quantidade)  quantidade,
	sum(CIF) CIF,
	SUM(FOB) FOB,
	max(CFOP) CFOP,
	sum(Vlr_Item) Vlr_Item, 
	max(ncm) NCM,
	sum(Vlr_Total_ITem) Vlr_Total_ITem,
	sum(fretecollect) fretecollect,
	sum(acrescimos) acrescimos,
	sum(vl_icms) vl_icms,
	sum(vl_imposto_cofins) vl_imposto_cofins, 
	sum(vl_imposto_pis) vl_imposto_pis, 
	sum(vl_ipi) vl_ipi, 
	sum(vl_ii) vl_ii,
	sum(vlr_siscomex) vlr_siscomex, 
	sum(vlr_seguro) vlr_seguro,
	NC.num_proc
	,NDD.cd_produto,
	sum(vlr_frete) vlr_frete,
	max(aliq_II) aliq_II,
	max(aliq_IPI) aliq_IPI,
	sum(VL_Base_IPI) VL_Base_IPI,
	MAX(VL_ALIQ_PIS) VL_ALIQ_PIS,
	sum(vl_base_pis) vl_base_pis, 
	MAX(VL_ALIQ_Cofins) VL_ALIQ_Cofins,sum(vl_base_cofins) vl_base_cofins,
	max(aliq_icms) aliq_icms,
	sum(vl_base_icms) vl_base_icms,
	ndd.CD_PEDIDO
from notA_cliente NC with(nolock)
	Join Nota_Fiscal_Cliente_Det NDD with(nolock) on ndd.id_nf=NC.id_nf and ndd.cd_cliente=nc.cd_cliente
	--join Pedido_Ship PS with(nolock) on NC.Num_Proc = PS.Num_Proc and PS.cd_produto = NDD.Cd_Produto and PS.cd_pedido = NDD.cd_pedido 
Where
	NC.Emissao > getdate() - 720
Group by
	NC.num_proc,NDD.cd_produto,ndd.CD_PEDIDO,vlr_nf







GO
