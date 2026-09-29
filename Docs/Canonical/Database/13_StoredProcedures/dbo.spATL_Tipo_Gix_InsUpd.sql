SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Gix
CREATE PROCEDURE [dbo].[spATL_Tipo_Gix_InsUpd]
(
	@Cd_Tp_Gix		VARCHAR(2),
	@Nome_Tp_Gix	varchar(50),
	@Regra			varchar(50)
)		

AS

Begin Transaction

	If  Exists(select Cd_Tp_Gix from Tipo_Gix where Cd_Tp_Gix=@Cd_Tp_Gix)
		Begin
			Update
				Tipo_Gix
			Set
				Nome_Tp_Gix=@Nome_Tp_Gix,
				Regra = @Regra
			Where
				Cd_Tp_Gix=@Cd_Tp_Gix
		End
	Else
		Begin
			Insert Tipo_Gix
				(Cd_Tp_Gix,Nome_Tp_Gix,Regra)
			Values
				(@Cd_Tp_Gix,@Nome_Tp_Gix,@Regra)
		End

Commit Transaction

GO
