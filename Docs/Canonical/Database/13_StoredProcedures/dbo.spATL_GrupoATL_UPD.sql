SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SELECT apelido, Nome_Usuario,* FROM Grupo g
--	join Pessoa p on p.Cd_Pes = g.Cd_Pes_Grupo
--	left JOIN Usuario U ON U.Cd_Usuario = g.Responsavel
--order by 1
	
--select * from Usuario where Cd_Usuario = 'rfs'
--select Cd_Pes from Pessoa where Apelido = 'GRUPO ADI'
--select * from Grupo where Cd_Pes_Grupo = 'P000025801'
CREATE Procedure [dbo].[spATL_GrupoATL_UPD]

	@Apelido		varchar(20),
	@Cd_Responsavel	varchar(6)

AS

Begin Transaction

Declare @Cd_Pes_Grupo varchar(10)
set @Cd_Pes_Grupo = (select Cd_Pes from Pessoa where Apelido = @Apelido)

	if exists (select Grupo from grupo where Cd_Pes_Grupo = @Cd_Pes_Grupo)
		BEGIN
			Update
				Grupo	
			set				
				Responsavel =  @Cd_Responsavel
			Where
				Cd_Pes_Grupo = @Cd_Pes_Grupo
		END
	
		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction

GO
