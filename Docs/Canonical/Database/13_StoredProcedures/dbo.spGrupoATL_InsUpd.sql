SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spGrupoATL_InsUpd]

	@Grupo			varchar(3),
	@Cd_Pes_Grupo	varchar(10),
	@Smart_EXP		varchar(30),
	@Smart_IMP		varchar(30),
	@Admin			varchar(50),
	@Unit			varchar(3),
	@AX_GRUPO		varchar(30),
	@Responsavel	varchar(30)

AS

Begin Transaction

Declare @Cd_Responsavel varchar(6)

set @Cd_Responsavel = (select cd_usuario from Usuario where Nome_Usuario = @Responsavel)

	if exists (select * from grupo where Cd_Pes_Grupo = @Cd_Pes_Grupo)
		Begin
			Update
				Grupo	
			set
				Smart_EXP = @Smart_EXP,
				Smart_IMP = @Smart_IMP,
				Admin = @Admin,
				Unit = @Unit,
				AX_GRUPO = @AX_GRUPO,
				Responsavel =  @Cd_Responsavel
			Where
				Cd_Pes_Grupo = @Cd_Pes_Grupo
		end
	Else
		begin
			Insert into
					Grupo
					(
					 cd_pes_Grupo,
					 Grupo,
					 Smart_EXP,
					 Smart_IMP,
					 Admin,
					 Unit,
					 AX_GRUPO,
					Responsavel
					)
				values
					(
					 @Cd_Pes_Grupo, 
					 @Grupo, 
					 @Smart_EXP, 
					 @Smart_IMP,
					 @Admin,
					 @Unit,
					 @AX_GRUPO,
					 @Cd_Responsavel
					)
		end

		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction

GO
