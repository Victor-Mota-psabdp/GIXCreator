SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Log_Oper
CREATE PROCEDURE [dbo].[spATL_Tipo_Log_Oper_InsUpd]
(
	@Cd_Tp_Log_Oper			varchar(2),
	@Nome_Tp_Log_Oper		varchar(100),
	@Status				bit,
	@Cd_Usuario			VarChar(6),
	@Dt_Ins				DateTime
)

AS

Begin Transaction

	If  exists (select Cd_Tp_Log_Oper from Tipo_Log_Oper where Cd_Tp_Log_Oper=@Cd_Tp_Log_Oper)
		Begin
			Update
				Tipo_Log_Oper
			Set
				Nome_Tp_Log_Oper=@Nome_Tp_Log_Oper,
				Status = @Status,
				Cd_Usuario=@Cd_Usuario,
				dt_ins = GETDATE()				
			Where
				Cd_Tp_Log_Oper=@Cd_Tp_Log_Oper
		End
	Else
		Begin
			Insert Tipo_Log_Oper
				(Nome_Tp_Log_Oper,Status,Cd_Usuario,dt_ins)
			Values
				(@Nome_Tp_Log_Oper,@Status,@Cd_Usuario,GETDATE())
		End

Commit Transaction

GO
