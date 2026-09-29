SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pTipoContainer_Del
(
@Cd_Tp_Cont		varchar(3)
)
AS
	Delete
		Tipo_Container
	Where
		Cd_Tp_Cont = @Cd_Tp_Cont



GO
