SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Usuario
CREATE procedure [dbo].[spATLDN_Usuario_Del](
	@Cd_Usuario VARCHAR(3)
)
as
	UPDATE 
		Usuario
	SET
		Ck_Ativo = 0
	 where 
		Cd_Usuario = Cd_Usuario
GO
