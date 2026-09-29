SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from Grupo
--sp_help Grupo
CREATE Procedure [dbo].[spATLDN_Grupo_InsUpd]

	@Apelido		varchar(20),
	@Grupo			varchar(3),
	@Smart_EXP		varchar(30),
	@Smart_IMP		varchar(30),
	@Admin			varchar(50),
	@Unit			varchar(3),
	@AX_GRUPO		varchar(30),
	@Nome_Usuario	varchar(30)

AS

Begin Transaction

	Declare @Cd_Pes_Grupo varchar(10)
	set @Cd_Pes_Grupo = (select Cd_Pes from Pessoa where Apelido = @Apelido)

	Declare @Responsavel varchar(6)
	set @Responsavel = (select cd_usuario from Usuario where Nome_Usuario = @Nome_Usuario)

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
				Responsavel =  @Responsavel
			Where
				Cd_Pes_Grupo = @Cd_Pes_Grupo
		end
	Else
		begin
			Insert into
					Grupo
					(cd_pes_Grupo,Grupo,Smart_EXP, Smart_IMP,Admin,Unit,AX_GRUPO,Responsavel)
				values
					(@Cd_Pes_Grupo,@Grupo,@Smart_EXP,@Smart_IMP,@Admin,@Unit,@AX_GRUPO,@Responsavel)
		end

		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction

GO
