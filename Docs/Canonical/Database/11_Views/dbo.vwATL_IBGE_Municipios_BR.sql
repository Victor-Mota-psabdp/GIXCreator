SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwATL_IBGE_Municipios_BR]
AS
		SELECT
            Nome_Município,
			UF_Descr_Red,
			UF,
			Cod_IBGE
		FROM 
			IBGE_Municipios_BR with(nolock)
			GROUP BY Nome_Município, UF_Descr_Red,UF,Cod_IBGE

GO
