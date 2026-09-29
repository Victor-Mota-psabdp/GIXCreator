SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Endereco
create PROCEDURE [dbo].[spATL_Tipo_Endereco_InsUpd]
(
	@Cd_Tp_End		varchar(3),
	@Nome_Tp_End	varchar(30)
)
				

AS

Begin Transaction

	If  exists (select Cd_Tp_End from Tipo_Endereco where Cd_Tp_End=@Cd_Tp_End)
		Begin
			Update
				Tipo_Endereco
			Set
				Nome_Tp_End=@Nome_Tp_End
			Where
				Cd_Tp_End=@Cd_Tp_End
		End
	Else
		Begin
			Insert Tipo_Endereco
				(Cd_Tp_End,Nome_Tp_End)
			Values
				(@Cd_Tp_End,@Nome_Tp_End)
		End

Commit Transaction

GO
