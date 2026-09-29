SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--spLerXML2BuscaTotaisCustosProduto_Sel 'IACLI200912001','15057','4564' 


--spLerXML2BuscaTotaisCustosProduto_Sel 'IMCLI201003006','15273','2580' 


--spLerXML2BuscaTotaisCustosProduto_Sel 'IACLI200912001','15057','10925' 


CREATE Procedure [dbo].[spLerXML2BuscaTotaisCustosProduto_Sel]

	@Num_Proc Varchar(16),
	@Cd_Produto int,
	@id_nf int

AS
--Rotina utilizada para puxar os totais de impostos e ajustes valores no Custo_Cliente
--Anderson
select 
	sum(CIF) CIF,SUM(FOB) FOB,
	sum(Vlr_Item) VL_ITEM, max(ncm) NCM,sum(FOB) Fob, sum(fretecollect) Frete,sum(acrescimos) THC,sum(vl_icms) ICMS,
	sum(vl_imposto_cofins) Cofins, sum(vl_imposto_pis) PIS, sum(vl_ipi) IPI, sum(vl_ii) II,
	sum(vlr_siscomex) Sicomex, sum(vlr_seguro) Seguro, num_proc,cd_produto,sum(vlr_frete) FreteDI,max(aliq_II) A_II,
	max(aliq_IPI) A_IPI,sum(VL_Base_IPI) Base_IPI,MAX(VL_ALIQ_PIS) A_PIS,sum(vl_base_pis) base_pis, MAX(VL_ALIQ_Cofins) A_Cofins,sum(vl_base_cofins) Base_Cofins,max(aliq_icms) A_ICMS,sum(vl_base_icms) base_Icms
from notA_cliente NC with(nolock)
	Join Nota_Fiscal_Cliente_Det NDD with(nolock) on ndd.id_nf=NC.id_nf and ndd.cd_cliente=nc.cd_cliente
Where
	Num_Proc=@Num_proc 
	--and quantidade <> 0  
	--and left(replace(cfop,'.',''),2)='31'
	AND CD_PRODUTO=@CD_PRODUTO 
and nc.id_nf=@id_nf
Group by Num_Proc,CD_PRODUTO







GO
