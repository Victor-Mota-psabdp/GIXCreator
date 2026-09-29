SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pTipoEmbalagem_Upd
(
@Cd_Tp_Embal			varchar(3),
@Nome_Tp_Embal		varchar(30),
@Cd_Embal_Ofc		char(10)
)
AS
	Update
		Tipo_Embalagem 
	Set 
		Nome_Tp_Embal = @Nome_Tp_Embal, 
		Cd_Embal_Ofc = @Cd_Embal_Ofc
	Where
		Cd_Tp_Embal = @Cd_Tp_Embal



GO
