SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwATL_Tipo_Ocorrencia_Sel]
AS
select 
			Cd_Tp_Ocor				[Code],
			Nome_Tp_Ocor			[Occurrence Type Name],
			Previsao_Obrigatoria	[Mandatory Forecast Date],
			Permite_Dias_Anteriores [Allows Previous Days]
		from 
			Tipo_Ocorrencia with(nolock)

GO
