SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Tipo_Endereco
CREATE VIEW [dbo].[vwTipo_Endereco_Sel]
AS
select 
	Cd_Tp_End [Code], Nome_Tp_End [Adress Type Name]
from 
	Tipo_Endereco T with(nolock)

GO
