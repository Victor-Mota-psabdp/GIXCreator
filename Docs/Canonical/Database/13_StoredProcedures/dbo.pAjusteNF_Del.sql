SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pAjusteNF_Del
(
@Cd_Tipo_Ajuste	Int 
)
AS
	Delete
		Ajuste_NF 
	Where
		Cd_Tipo_Ajuste = @Cd_Tipo_Ajuste



GO
