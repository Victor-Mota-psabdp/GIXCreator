SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Select * from house_imp_mar where num_proc_him = 'IMGCP20110100101'


CREATE Procedure [dbo].[spGCP_CCode180]--'IMGCP20110100101'
	@Processo VarChar(16)
as	

SELECT distinct
	[dbo].[fBusca_Custo_Processo](@Processo,'Imposto de Importação - CHB%') Imposto,
	[dbo].[fBusca_Custo_Processo](@Processo,'Taxas Siscomex - CHB%') Siscomex,
	[dbo].[fBusca_Custo_Processo](@Processo,'IPI - CHB%') IPI,
	[dbo].[fBusca_Custo_Processo](@Processo,'PIS - CHB%') PIS,
	[dbo].[fBusca_Custo_Processo](@Processo,'Cofins - CHB%') Cofins,
	[dbo].[fBusca_Custo_Processo](@Processo,'ICMS - CHB%') ICMS,
	[dbo].[fBusca_Custo_Processo](@Processo,'Serviços de Despacho%') Despacho,
	[dbo].[fBusca_Custo_Processo](@Processo,'Transporte Mercadoria - CHB%') Transporte,	
	[dbo].[fBusca_Custo_Processo](@Processo,'Capatazias - CHB%') Capatazia,
	PO.numero_PO_HIM PO,
	DI.numero_PO_HIM DI,
	HOU.peso_bruto_him Peso,
	HOU.vlr_frete_efet_him frete
FROM 
	Custo_Cliente CC
	left Join Po_Him DI on CC.num_proc=DI.Num_Proc_hIm and DI.id_dc=5
	left join Po_HIm PO on CC.num_proc=PO.Num_Proc_hIm and PO.id_dc=1	
	left join house_imp_mar HOU on CC.num_proc = HOU.num_proc_him
where 
	CC.Num_Proc=@Processo














GO
