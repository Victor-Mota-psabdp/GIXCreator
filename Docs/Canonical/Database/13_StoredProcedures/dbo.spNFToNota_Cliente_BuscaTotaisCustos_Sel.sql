SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spNFToNota_Cliente_BuscaTotaisCustos_Sel]--'IMGVD201708021BR'

	@Num_Proc Varchar(16)

AS
	
select 
	sum(FOB) Fob, sum(fretecollect) Frete,sum(acrescimos) THC,sum(vl_icms) ICMS,
	sum(vl_imposto_cofins) Cofins, sum(vl_imposto_pis) PIS, sum(vl_ipi) IPI, sum(vl_ii) II,
	sum(vlr_siscomex) Siscomex, sum(vlr_seguro) Seguro, num_proc,cd_produto,sum(vlr_frete) FreteDI
from notA_cliente NC with(nolock)
	Join Nota_Fiscal_Cliente_Det NDD with(nolock) on ndd.id_nf=NC.id_nf and ndd.cd_cliente=nc.cd_cliente
Where
	Num_Proc=@Num_Proc
	and quantidade <> 0 --and acrescimos <> 0	
Group by Num_Proc, cd_produto


/*
tive um ticket 100-149624, onde o vlr do siscomex nao estava batendo, pois somamos e incluimos o valor total 
no nota fiscal cliente det
nao consegui resolver, pq o usuario excluiu a nf do atl
spNFToNota_Cliente_BuscaTotaisCustos_Sel
spNFToNota_Cliente_PorcentagemPedido_Sel
select 
	sum(FOB) Fob, sum(fretecollect) Frete,sum(acrescimos) THC,sum(vl_icms) ICMS,
	sum(vl_imposto_cofins) Cofins, sum(vl_imposto_pis) PIS, sum(vl_ipi) IPI, sum(vl_ii) II,
	dbo.fBuscaPorcentagem_CdProduto(left(Num_Proc,15)+ 'R',NDD.Cd_Produto) * vlr_siscomex Siscomex, 
	--sum(vlr_siscomex) Siscomex, 
	--Num_Proc,NDD.Cd_Produto,
	sum(vlr_seguro) Seguro, num_proc,cd_produto,sum(vlr_frete) FreteDI
from notA_cliente NC with(nolock)
	Join Nota_Fiscal_Cliente_Det NDD with(nolock) on ndd.id_nf=NC.id_nf and ndd.cd_cliente=nc.cd_cliente
Where
	Num_Proc like 'IAGVD201809005B%'
	and quantidade <> 0 --and acrescimos <> 0	
	and nc.ID_NF =6517
Group by Num_Proc, cd_produto,vlr_siscomex
*/






GO
