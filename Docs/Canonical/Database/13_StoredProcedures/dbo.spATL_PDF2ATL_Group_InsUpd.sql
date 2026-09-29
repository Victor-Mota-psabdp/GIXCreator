SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help PDF2ATL_Group
CREATE procedure [dbo].[spATL_PDF2ATL_Group_InsUpd]
(
	@Cd_Pes_Grupo	varchar(10),
	@Id_Dc			int,
	@CD_TP_MODAL	char(2),	
	@Origin			varchar(MAX),
	@cd_usuario		varchar(10),
	@Ativo			Bit
)
as
	
	
	Begin Transaction
	
	If exists(select * from PDF2ATL_Group where	CD_TP_MODAL = @CD_TP_MODAL and ID_DC = @ID_DC and Cd_Pes_Grupo = @cd_pes_grupo)
		Begin
			Update
				PDF2ATL_Group
			Set
				origin=@Origin,
				cd_usuario=@cd_usuario,			
				Ativo= @Ativo
			Where
				CD_TP_MODAL = @CD_TP_MODAL and ID_DC = @ID_DC and Cd_Pes_Grupo = @cd_pes_grupo
		End
	Else
		Begin
			Insert into PDF2ATL_Group
				(ID_DC, Cd_Pes_Grupo, CD_TP_MODAL,Origin, cd_usuario, dt_ins,Ativo)
			Values
				(@ID_DC, @cd_pes_grupo, @CD_TP_MODAL,@Origin, @cd_usuario, getdate(),@Ativo)
			
		End


	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

Commit Transaction

GO
