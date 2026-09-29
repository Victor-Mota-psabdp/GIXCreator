SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Modal
CREATE PROCEDURE [dbo].[spATL_Tipo_Modal_InsUpd]
(
	@Id	varChar(1),
	@Modal	varChar(50)
)
	
AS

Begin Transaction

	If  exists (select @Id from Tipo_Modal where @Id=@Id)
		Begin
			Update
				Tipo_Modal
			Set
				Modal=@Modal
			Where
				@Id=@Id
		End
	Else
		Insert
			Tipo_Modal(Id,Modal)
		Values
			(@Id,@Modal)
	

Commit Transaction

GO
