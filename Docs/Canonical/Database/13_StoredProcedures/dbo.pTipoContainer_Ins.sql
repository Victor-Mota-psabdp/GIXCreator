SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pTipoContainer_Ins
(
@Cd_Tp_Cont		varchar(3),
@Nome_Tp_Cont	varchar(30),
@Cd_CC_Ofc		char(2)
)
AS
	Insert Into 
		Tipo_Container
		(Cd_Tp_Cont, Nome_Tp_Cont, Cd_CC_Ofc)
	Values 
		(@Cd_Tp_Cont, @Nome_Tp_Cont, @Cd_CC_Ofc)



GO
