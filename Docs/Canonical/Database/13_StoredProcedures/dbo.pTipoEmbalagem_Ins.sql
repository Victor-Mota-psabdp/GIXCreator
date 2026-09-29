SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pTipoEmbalagem_Ins
(
@Cd_Tp_Embal			varchar(3),
@Nome_Tp_Embal		varchar(30),
@Cd_Embal_Ofc		char(10)
)
AS
	Insert Into 
		Tipo_Embalagem 
		(Cd_Tp_Embal, Nome_Tp_Embal, Cd_Embal_Ofc)
	Values 
		(@Cd_Tp_Embal, @Nome_Tp_Embal, @Cd_Embal_Ofc)



GO
