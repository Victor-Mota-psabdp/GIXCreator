SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spGIX_XMLto_BuscaTotaisCustos_Sel]--'IMOXT201703001BR'

	@Num_Proc Varchar(16)

AS
	
select 
	sum(FOB) Fob, 
	sum(fretecollect) Frete,
	--sum(acrescimos) THC,
	sum(acrescimos) Acrescimos,
	sum(vl_icms) ICMS,
	sum(vl_imposto_cofins) Cofins, 
	sum(vl_imposto_pis) PIS, 
	sum(vl_ipi) IPI, 
	sum(vl_ii) II,
	sum(vlr_siscomex) Siscomex, 
	sum(vlr_seguro) Seguro, 
	SUM(vlr_desconto) AFRMM,
	num_proc,
	cd_produto
	,sum(vlr_frete) FreteDI
from notA_cliente NC with(nolock)
	Join Nota_Fiscal_Cliente_Det NDD with(nolock) on ndd.id_nf=NC.id_nf and ndd.cd_cliente=nc.cd_cliente
Where
	Num_Proc=@Num_Proc
	and quantidade <> 0 --and acrescimos <> 0	
Group by Num_Proc, cd_produto
GO
