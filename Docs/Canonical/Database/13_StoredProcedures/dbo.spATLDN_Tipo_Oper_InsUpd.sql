SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Oper
CREATE PROCEDURE [dbo].[spATLDN_Tipo_Oper_InsUpd]
(
	@Cd_Tp_Oper		VARchar(3),
	@Nome_Tp_Oper	varchar(30),
	@Cd_Tp_Frete	VARCHAR(1)
)

AS

Begin Transaction

	If  exists (select Cd_Tp_Oper from Tipo_Oper where Cd_Tp_Oper=@Cd_Tp_Oper)
		Begin
			Update
				Tipo_Oper
			Set
				Nome_Tp_Oper=@Nome_Tp_Oper,
				Cd_Tp_Frete = @Cd_Tp_Frete
			Where
				Cd_Tp_Oper=@Cd_Tp_Oper
		End
	Else
		Insert
			Tipo_Oper(Cd_Tp_Oper,Nome_Tp_Oper,Cd_Tp_Frete)
		Values
			(@Cd_Tp_Oper,@Nome_Tp_Oper,@Cd_Tp_Frete)
	

Commit Transaction

GO
