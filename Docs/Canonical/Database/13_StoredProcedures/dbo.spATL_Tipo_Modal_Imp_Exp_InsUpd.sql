SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Modal_Imp_Exp
CREATE PROCEDURE [dbo].[spATL_Tipo_Modal_Imp_Exp_InsUpd]
(
	@CD_TP_MODAL		varchar(2),
	@Nome_TP_MODAL		varchar(100),
	@Status				bit,
	@Cd_Usuario			VarChar(6),
	@Dt_Ins				DateTime
)

AS

Begin Transaction

	If  exists (select CD_TP_MODAL from Tipo_Modal_Imp_Exp where CD_TP_MODAL=@CD_TP_MODAL)
		Begin
			Update
				Tipo_Modal_Imp_Exp
			Set
				Nome_TP_MODAL=@Nome_TP_MODAL,
				Status = @Status,
				Cd_Usuario=@Cd_Usuario,
				dt_ins = GETDATE()				
			Where
				CD_TP_MODAL=@CD_TP_MODAL
		End
	Else
		Begin
			Insert Tipo_Modal_Imp_Exp
				(Nome_TP_MODAL,Status,Cd_Usuario,dt_ins)
			Values
				(@Nome_TP_MODAL,@Status,@Cd_Usuario,GETDATE())
		End

Commit Transaction

GO
