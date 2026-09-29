SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from Grupo
--sp_help Grupo
CREATE Procedure [dbo].[spATLGrupo_InsUpd]
(
	@Cd_Pes_Grupo	varchar(10),
	@Grupo			varchar(3),
	@Smart_EXP		varchar(30),
	@Smart_IMP		varchar(30),
	@Admin			varchar(50),
	@Unit			varchar(3),
	@AX_GRUPO		varchar(30),
	@Cd_Usuario		varchar(6)
)

AS

Begin Transaction
	
	if exists (select Grupo from Grupo where Cd_Pes_Grupo = @Cd_Pes_Grupo)
		Begin
			Update
				Grupo	
			set
				Smart_EXP = @Smart_EXP,
				Smart_IMP = @Smart_IMP,
				Admin = @Admin,
				Unit = @Unit,
				AX_GRUPO = @AX_GRUPO,
				Responsavel =  @Cd_Usuario
			Where
				Cd_Pes_Grupo = @Cd_Pes_Grupo
		end
	Else
		begin
			Insert into
					Grupo
					(cd_pes_Grupo,Grupo,Smart_EXP, Smart_IMP,Admin,Unit,AX_GRUPO,Responsavel)
				values
					(@Cd_Pes_Grupo,@Grupo,@Smart_EXP,@Smart_IMP,@Admin,@Unit,@AX_GRUPO,@Cd_Usuario)
		end

		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction

GO
