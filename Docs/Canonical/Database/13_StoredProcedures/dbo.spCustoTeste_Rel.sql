SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spCustoTeste_Rel]--'IMGCP20110100101'
	@Processo VarChar(16)
as	

SELECT distinct
	[dbo].[fBusca_Custo_Processo](@Processo,'Imposto de Importação - CHB%') Imposto,
	[dbo].[fBusca_Custo_Processo](@Processo,'Taxas Siscomex - CHB%') Siscomex,
	[dbo].[fBusca_Custo_Processo](@Processo,'IPI - CHB%') IPI,
	[dbo].[fBusca_Custo_Processo](@Processo,'PIS - CHB%') PIS,
	[dbo].[fBusca_Custo_Processo](@Processo,'Cofins - CHB%') Cofins,
	[dbo].[fBusca_Custo_Processo](@Processo,'ICMS - CHB%') ICMS,
	PO.numero_PO_HIM PO,
	DI.numero_PO_HIM DI		
FROM 
	Custo_Cliente CC
	left Join Po_Him DI on CC.num_proc=DI.Num_Proc_hIm and DI.id_dc=5
	left join Po_HIm PO on CC.num_proc=PO.Num_Proc_hIm and PO.id_dc=1	
where 
	CC.Num_Proc=@Processo












GO
