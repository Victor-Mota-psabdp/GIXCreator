SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Moeda
CREATE VIEW [dbo].[vwTipo_Moeda_Sel]
AS
select 
	Cd_Tp_Moeda [Code],
	Nome_Tp_Moeda [Type of Currency],
	Nome_Tp_Moeda [Currency Type Name],
	Cod_Nac_Moeda [National Code],
	Cod_Int_Moeda [International Code],
	Cd_Moeda_Ofc [Official Code], 
	Cd_Loc_Ofc [Cd_Loc_Ofc],
	ativo [Enabled]
from 
	Tipo_Moeda with(nolock)
where
	Cd_Tp_Moeda <> '0'


GO
