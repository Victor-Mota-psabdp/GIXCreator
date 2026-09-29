SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pTipoContainer_Upd 
(
@Cd_Tp_Cont		varchar(3),
@Nome_Tp_Cont	varchar(30),
@Cd_CC_Ofc		char(2)
)
AS
	Update
		Tipo_Container
	Set 
		Nome_Tp_Cont = @Nome_Tp_Cont, 
		Cd_CC_Ofc = @Cd_CC_Ofc	
	Where
		Cd_Tp_Cont = @Cd_Tp_Cont



GO
