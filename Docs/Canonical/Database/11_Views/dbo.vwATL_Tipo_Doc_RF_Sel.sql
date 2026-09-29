SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwATL_Tipo_Doc_RF_Sel]
AS
select 
	Cd_Tipo_Doc_RF		[Code],
	Descricao_Tp_Doc	[Doc Type],
	Ativo				[Enabled],
	Debito				[Debit],
	Credito				[Credit]
from 
	Tipo_Doc_RF with(nolock)



GO
