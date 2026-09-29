SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Move
CREATE PROCEDURE [dbo].[spATL_Tipo_Move_InsUpd]
(
	@Cd_Tp_Move			varchar(2),
	@Nome_Tp_Move		varchar(100),
	@Status				bit,
	@Cd_Usuario			VarChar(6),
	@Dt_Ins				DateTime
)

AS

Begin Transaction

	If  exists (select Cd_Tp_Move from Tipo_Move where Cd_Tp_Move=@Cd_Tp_Move)
		Begin
			Update
				Tipo_Move
			Set
				Nome_Tp_Move=@Nome_Tp_Move,
				Status = @Status,
				Cd_Usuario=@Cd_Usuario,
				dt_ins = GETDATE()				
			Where
				Cd_Tp_Move=@Cd_Tp_Move
		End
	Else
		Begin
			Insert Tipo_Move
				(Nome_Tp_Move,Status,Cd_Usuario,dt_ins)
			Values
				(@Nome_Tp_Move,@Status,@Cd_Usuario,GETDATE())
		End

Commit Transaction

GO
