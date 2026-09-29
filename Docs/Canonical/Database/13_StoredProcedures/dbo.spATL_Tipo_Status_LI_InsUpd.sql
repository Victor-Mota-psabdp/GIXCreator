SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Status_LI
create PROCEDURE [dbo].[spATL_Tipo_Status_LI_InsUpd]
(
	@ID_Status_LI			int,
	@Status_LI_Descricao	varchar(50)
)

AS

Begin Transaction

	If  exists (select ID_Status_LI from Tipo_Status_LI where ID_Status_LI=@ID_Status_LI)
		Begin
			Update
				Tipo_Status_LI
			Set
				Status_LI_Descricao=@Status_LI_Descricao
			Where
				ID_Status_LI=@ID_Status_LI
		End
	Else
		Begin
			Insert Tipo_Status_LI
				(ID_Status_LI,Status_LI_Descricao)
			Values
				(@ID_Status_LI,@Status_LI_Descricao)
		End

Commit Transaction

GO
