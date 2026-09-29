SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--CREATE table [dbo].[Aux_Embalagem] add Cd_Smart [varchar](3) NULL
--sp_help Aux_Embalagem
CREATE PROCEDURE [dbo].[spATL_Aux_Embalagem_InsUpd]
(
	@Cd_Embal_Ofc		VarChar(10), 
	@Nome_Embalagem		VarChar(60)
)

AS

Begin Transaction

	If  exists (select Cd_Embal_Ofc from Aux_Embalagem where Cd_Embal_Ofc=@Cd_Embal_Ofc)
		Begin
			Update
				Aux_Embalagem
			Set
				Nome_Embalagem=@Nome_Embalagem				
			Where
				Cd_Embal_Ofc=@Cd_Embal_Ofc
		End
	Else
		Begin
			Insert Aux_Embalagem
				(Cd_Embal_Ofc,Nome_Embalagem)
			Values
				(@Cd_Embal_Ofc,@Nome_Embalagem)
		End

Commit Transaction

GO
