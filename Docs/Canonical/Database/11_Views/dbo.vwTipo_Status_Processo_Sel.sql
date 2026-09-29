SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTipo_Status_Processo_Sel]
AS
	select 
		ID_Status			[Code], 
		Status_Descricao	[Status Description],
		Ativo				[Enabled],
		CtaCte_IUD			[CtaCte_IUD],
		Financeiro_IUD		[Financeiro_IUD],
		Faturamento_IUD		[Faturamento_IUD],
		Job_IUD				[Job_IUD],
		Historico_IUD		[Historico_IUD],
		Status_Descricao_Ingles	[Status Description EN],
		Ordem				[Sequence]
	from 
		Tipo_Status_Processo with(nolock)

GO
