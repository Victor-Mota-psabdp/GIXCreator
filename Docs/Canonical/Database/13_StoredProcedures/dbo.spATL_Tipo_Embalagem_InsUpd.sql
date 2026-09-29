SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Embalagem
CREATE PROCEDURE [dbo].[spATL_Tipo_Embalagem_InsUpd]
(
	@Cd_Tp_Embal	varchar(3),
	@Nome_Tp_Embal	varchar(30),
	@Cd_Embal_Ofc	char(10),
	@ISO_CODE		varchar(3),
	@Ativo			char(1),
	@Data			datetime,
	@Cd_Usuario		varchar(6),
	@Cd_Smart		varchar(3)

)

AS

Begin Transaction

	If  exists (select Cd_Tp_Embal from Tipo_Embalagem where Cd_Tp_Embal=@Cd_Tp_Embal)
		Begin
			Update
				Tipo_Embalagem
			Set
				Nome_Tp_Embal=@Nome_Tp_Embal,
				Cd_Embal_Ofc=@Cd_Embal_Ofc,
				ISO_CODE=@ISO_CODE,
				Ativo=@Ativo,
				Data=GETDATE(),
				Cd_Usuario=@Cd_Usuario,
				Cd_Smart=@Cd_Smart			
			Where
				Cd_Tp_Embal=@Cd_Tp_Embal
		End
	Else
		Begin
			Insert Tipo_Embalagem
				(Cd_Tp_Embal,Nome_Tp_Embal,Cd_Embal_Ofc,ISO_CODE,Ativo,Data,Cd_Usuario,Cd_Smart)
			Values
				(@Cd_Tp_Embal,@Nome_Tp_Embal,@Cd_Embal_Ofc,@ISO_CODE,@Ativo,GETDATE(),@Cd_Usuario,@Cd_Smart)
		End

Commit Transaction





GO
