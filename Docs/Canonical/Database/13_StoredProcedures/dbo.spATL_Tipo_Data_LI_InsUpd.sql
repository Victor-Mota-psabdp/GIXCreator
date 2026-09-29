SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Data_LI
CREATE PROCEDURE [dbo].[spATL_Tipo_Data_LI_InsUpd]
(
	@ID_Tp_Data		BIGINT,
	@Nome_Tp_Data	varchar(100)
)

AS

Begin Transaction

	If  exists (select ID_Tp_Data from Tipo_Data_LI where ID_Tp_Data=@ID_Tp_Data)
		Begin
			Update
				Tipo_Data_LI
			Set
				Nome_Tp_Data=@Nome_Tp_Data
			Where
				ID_Tp_Data=@ID_Tp_Data
		End
	Else
		Begin
			Insert Tipo_Data_LI
				(ID_Tp_Data,Nome_Tp_Data)
			Values
				(@ID_Tp_Data,@Nome_Tp_Data)
		End

Commit Transaction

GO
