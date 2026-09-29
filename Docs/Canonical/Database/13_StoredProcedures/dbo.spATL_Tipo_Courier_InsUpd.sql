SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_help Tipo_Courier
CREATE PROCEDURE [dbo].[spATL_Tipo_Courier_InsUpd]
(
	@ID_Tp_Courier		Int,
	@Nome_Tp_Courier	varchar(50),
	@Status				bit
			
)
AS

Begin Transaction
	
	If  exists (select ID_Tp_Courier from Tipo_Courier where ID_Tp_Courier=ID_Tp_Courier)
	Begin
		Update
			Tipo_Courier
		Set
			Nome_Tp_Courier=@Nome_Tp_Courier,
			Status = @Status
		Where
			ID_Tp_Courier=@ID_Tp_Courier
	End
		Else
	Begin
		Set @ID_Tp_Courier = (Select isnull(max(ID),0) +1 from Courier_Processo)
		Insert
			Tipo_Courier(ID_Tp_Courier,Nome_Tp_Courier,Status)
		Values
			(@ID_Tp_Courier,@Nome_Tp_Courier,@Status)
	End

Commit Transaction

GO
