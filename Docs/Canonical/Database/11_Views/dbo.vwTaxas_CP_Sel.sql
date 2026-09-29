SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[vwTaxas_CP_Sel]

AS
		select 
			TCP.cd_tp_tx		[Charge Type Code],
			TT.Nome_Tp_tx		[Charge Type Name],	
			tcp.Modal			[Modal Type Code], 
			tmie.Nome_TP_MODAL	[Modal Type Name],
			TCP.Cd_Tp_Carga		[Cargo Type Code],
			TC.Nome_Tp_Carga	[Cargo Type Name],
			Vlr_Taxa			[Value],
			TCP.Moeda			[Currency Type Code],
			tm.nome_Tp_moeda	[Currency Type Name],
			TCP.IVA				[IVA]
		from 
			Taxas_CP TCP
			left join tipo_taxa TT	on TT.cd_tp_tx = TCP.CD_Tp_Tx collate Latin1_General_CI_AI
			left join tipo_moeda TM	on TM.Cd_Tp_Moeda = TCP.Moeda collate Latin1_General_CI_AI
			left join Tipo_Modal_Imp_Exp TMIE	on TMIE.CD_TP_MODAL = TCP.Modal collate Latin1_General_CI_AI
			left join Tipo_Carga TC	on TC.Cd_Tp_Carga = TCP.Cd_Tp_Carga collate Latin1_General_CI_AI

GO
