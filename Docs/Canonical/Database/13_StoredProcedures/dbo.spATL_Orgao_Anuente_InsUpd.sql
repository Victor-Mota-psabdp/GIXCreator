SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Orgao_Anuente
CREATE PROCEDURE [dbo].[spATL_Orgao_Anuente_InsUpd]
(
	@ID_Orgao	int,
	@Nome_Orgao_Anuente varchar(60)
)

AS


Begin Transaction

	If  exists (select ID_Orgao from Orgao_Anuente where ID_Orgao=@ID_Orgao)
	Begin
		Update
			Orgao_Anuente
		Set
			Nome_Orgao_Anuente=@Nome_Orgao_Anuente
		Where
			ID_Orgao=@ID_Orgao
	End
	Else
		Insert
			Orgao_Anuente(
				ID_Orgao,
				Nome_Orgao_Anuente
				)
		Values
			(
			@ID_Orgao,	
			@Nome_Orgao_Anuente
		)
	

Commit Transaction

GO
