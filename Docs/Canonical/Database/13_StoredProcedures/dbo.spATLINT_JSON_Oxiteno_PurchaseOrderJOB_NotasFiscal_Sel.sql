SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATLINT_JSON_Oxiteno_PurchaseOrderJOB_NotasFiscal_Sel]
(
	@ID_PurchaseOrderJOB	bigint,
	@ID_NotasFiscal			bigint,
	@Tipo					char(1)
)
as

--sp_help ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_NotasFiscal

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 		
			J.ID_purchaseOrderJOB [Internal Code],			
			J.ID_NotasFiscal,
			J.numero,
			J.serie,
			J.tipo,
			J.data_emissao,
			J.cfop,
			J.peso_liquido,
			J.vlr_frete,
			J.vlr_seguro,
			J.vlr_acrescimos,
			J.vlr_outras_despesas,
			J.vlr_afrmm,
			J.vlr_antidumping,
			J.vlr_ii,
			J.vlr_ipi,
			J.vlr_pis,
			J.vlr_cofins,
			J.vlr_fecp,
			J.vlr_icms,
			J.vlr_total
		from 
			ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_NotasFiscal J with(nolock)
			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB JOB with(nolock) on JOB.ID_purchaseOrderJOB = J.ID_purchaseOrderJOB
			
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 		
			J.ID_purchaseOrderJOB [Internal Code],			
			J.ID_NotasFiscal,
			J.numero,
			J.serie,
			J.tipo,
			J.data_emissao,
			J.cfop,
			J.peso_liquido,
			J.vlr_frete,
			J.vlr_seguro,
			J.vlr_acrescimos,
			J.vlr_outras_despesas,
			J.vlr_afrmm,
			J.vlr_antidumping,
			J.vlr_ii,
			J.vlr_ipi,
			J.vlr_pis,
			J.vlr_cofins,
			J.vlr_fecp,
			J.vlr_icms,
			J.vlr_total
		from 
			ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_NotasFiscal J with(nolock)
			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB JOB with(nolock) on JOB.ID_purchaseOrderJOB = J.ID_purchaseOrderJOB
		where 
			J.ID_purchaseOrderJOB = @ID_PurchaseOrderJOB
			and J.tipo = 'NFE'
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 		
			J.ID_purchaseOrderJOB [Internal Code],			
			J.ID_NotasFiscal,
			J.numero,
			J.serie,
			J.tipo,
			J.data_emissao,
			J.cfop,
			J.peso_liquido,
			J.vlr_frete,
			J.vlr_seguro,
			J.vlr_acrescimos,
			J.vlr_outras_despesas,
			J.vlr_afrmm,
			J.vlr_antidumping,
			J.vlr_ii,
			J.vlr_ipi,
			J.vlr_pis,
			J.vlr_cofins,
			J.vlr_fecp,
			J.vlr_icms,
			J.vlr_total
		from 
			ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_NotasFiscal J with(nolock)
			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB JOB with(nolock) on JOB.ID_purchaseOrderJOB = J.ID_purchaseOrderJOB
		where 
			J.ID_purchaseOrderJOB = @ID_PurchaseOrderJOB and J.ID_NotasFiscal = @ID_NotasFiscal
	End






GO
