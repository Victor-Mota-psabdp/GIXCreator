SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pTipoEmbalagem_Del 
(
@Cd_Tp_Embal			varchar(3)
)
AS
	Delete
		Tipo_Embalagem 
	Where
		Cd_Tp_Embal = @Cd_Tp_Embal



GO
