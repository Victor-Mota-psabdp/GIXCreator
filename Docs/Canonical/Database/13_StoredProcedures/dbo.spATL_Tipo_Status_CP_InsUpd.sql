SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Status_CP
CREATE PROCEDURE [dbo].[spATL_Tipo_Status_CP_InsUpd]
(
	@ID_Status_CP			varchar(1),
	@Descr_Status			varchar(40),
	@Ativo					varchar(1)	
)
				

AS

Begin Transaction

	If  exists (select ID_Status_CP from Tipo_Status_CP where ID_Status_CP=@ID_Status_CP)
		Begin
			Update
				Tipo_Status_CP
			Set
				Descr_Status=@Descr_Status,
				Ativo = @Ativo
			Where
				ID_Status_CP=@ID_Status_CP
		End
	Else
		Begin
			Insert Tipo_Status_CP
				(ID_Status_CP,Descr_Status,Ativo)
			Values
				(@ID_Status_CP,@Descr_Status,@Ativo)
		End

Commit Transaction

GO
