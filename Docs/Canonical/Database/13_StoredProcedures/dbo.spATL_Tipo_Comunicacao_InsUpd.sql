SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Comunicacao
CREATE PROCEDURE [dbo].[spATL_Tipo_Comunicacao_InsUpd]
(
	@Cd_Tp_Com		varchar(3),
	@Nome_Tp_Com	varchar(30)
)

AS

Begin Transaction

	If  exists (select Cd_Tp_Com from Tipo_Comunicacao where Cd_Tp_Com=@Cd_Tp_Com)
		Begin
			Update
				Tipo_Comunicacao
			Set
				Nome_Tp_Com=@Nome_Tp_Com
			Where
				Cd_Tp_Com=@Cd_Tp_Com
		End
	Else
		Begin
			Insert Tipo_Comunicacao
				(Cd_Tp_Com,Nome_Tp_Com)
			Values
				(@Cd_Tp_Com,@Nome_Tp_Com)
		End

Commit Transaction

GO
