SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Documento
CREATE PROCEDURE [dbo].[spATL_Tipo_Documento_InsUpd]
(
	@Cd_Tp_Doc		varchar(3),
	@Nome_Tp_Doc	varchar(30),
	@Status			bit
			
)
AS

Begin Transaction

	If  exists (select Cd_Tp_Doc from Tipo_Documento where Cd_Tp_Doc=@Cd_Tp_Doc)
	Begin
		Update
			Tipo_Documento
		Set
			Nome_Tp_Doc=@Nome_Tp_Doc,
			Status = @Status
		Where
			Cd_Tp_Doc=@Cd_Tp_Doc
	End
	Else
		Insert
			Tipo_Documento(Cd_Tp_Doc,Nome_Tp_Doc,Status)
		Values
			(@Cd_Tp_Doc,@Nome_Tp_Doc,@Status)
	

Commit Transaction

GO
