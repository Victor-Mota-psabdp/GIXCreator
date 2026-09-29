SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  Procedure [dbo].[spMoeda_Sel]
		
AS

SELECT
	cd_tp_moeda,Nome_Tp_Moeda

FROM
	Tipo_Moeda
where ativo  = 1
	
Order by
	Nome_tp_moeda




GO
