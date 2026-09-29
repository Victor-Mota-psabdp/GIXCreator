SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Metodo_VGM
CREATE PROCEDURE [dbo].[spATL_Tipo_Metodo_VGM_InsUpd]
(
	@ID_Metodo_VGM 	INT,
	@Nome_Metodo_VGM varchar(100)
)

AS

Begin Transaction

	If  exists (select ID_Metodo_VGM from Tipo_Metodo_VGM where ID_Metodo_VGM=@ID_Metodo_VGM)
		Begin
			Update
				Tipo_Metodo_VGM
			Set
				Nome_Metodo_VGM=@Nome_Metodo_VGM
			Where
				ID_Metodo_VGM=@ID_Metodo_VGM
		End
	Else
		Begin
			Insert Tipo_Metodo_VGM
				(ID_Metodo_VGM,Nome_Metodo_VGM)
			Values
				(@ID_Metodo_VGM,@Nome_Metodo_VGM)
		End

Commit Transaction

GO
