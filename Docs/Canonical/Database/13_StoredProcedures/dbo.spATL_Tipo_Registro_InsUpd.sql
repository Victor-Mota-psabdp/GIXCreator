SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Registro
CREATE PROCEDURE [dbo].[spATL_Tipo_Registro_InsUpd]
(
		@ID_Registro			int,
		@Descr_Registro		varchar(15)
)
				

AS

Begin Transaction

	If  exists (select ID_Registro from Tipo_Registro where ID_Registro=@ID_Registro)
		Begin
			Update
				Tipo_Registro
			Set
				Descr_Registro=@Descr_Registro
			Where
				ID_Registro=@ID_Registro
		End
	Else
		Begin
			Insert Tipo_Registro
				(ID_Registro,Descr_Registro)
			Values
				(@ID_Registro,@Descr_Registro)
		End

Commit Transaction

GO
