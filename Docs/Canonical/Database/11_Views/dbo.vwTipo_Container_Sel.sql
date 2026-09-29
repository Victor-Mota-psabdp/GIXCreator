SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Container
CREATE VIEW [dbo].[vwTipo_Container_Sel]
AS
	select Cd_Tp_Cont AS Code,Nome_Tp_Cont AS [Container Name],Cd_CC_Ofc [SCAC],
		CD_Smart [Code Smart],Capacidade_M3 [M3],Carrier_Code [Carrier Code], qtd_teus [TEUs Qty]
		from Tipo_Container with(nolock)

GO
