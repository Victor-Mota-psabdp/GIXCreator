SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwBoleto_Instrucao_Cobranca_Sel]
AS

	select 
		T.Cd_Instrucao		[Code],
		T.Nome_Instrucao	[Instruction Name],
		T.Cd_Banco			[Bank Code],
		B.Nome_Banco		[Bank Name],
		T.Ativo				[Enabled],
		T.Cd_Usuario		[User Code],
		U.Nome_Usuario		[User Name],
		T.dt_ins				[Insert Date]
	from Boleto_Instrucao_Cobranca T with(nolock)
		join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		join Banco B with(nolock) on B.Cd_Banco=T.Cd_Banco	

GO
