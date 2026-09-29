SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_help Tipo_Instrucao
CREATE PROCEDURE [dbo].[spATL_Tipo_Instrucao_InsUpd]
(
	@Cd_Tp_Instrucao			varchar(1),
	@Nome_Tp_Instrucao		varchar(100),
	@Status				bit,
	@Cd_Usuario			VarChar(6),
	@Dt_Ins				DateTime
)

AS

Begin Transaction

	If  exists (select Cd_Tp_Instrucao from Tipo_Instrucao where Cd_Tp_Instrucao=@Cd_Tp_Instrucao)
		Begin
			Update
				Tipo_Instrucao
			Set
				Nome_Tp_Instrucao=@Nome_Tp_Instrucao,
				Status = @Status,
				Cd_Usuario=@Cd_Usuario,
				dt_ins = GETDATE()				
			Where
				Cd_Tp_Instrucao=@Cd_Tp_Instrucao
		End
	Else
		Begin
			Insert Tipo_Instrucao
				(Nome_Tp_Instrucao,Status,Cd_Usuario,dt_ins)
			Values
				(@Nome_Tp_Instrucao,@Status,@Cd_Usuario,GETDATE())
		End

Commit Transaction

GO
