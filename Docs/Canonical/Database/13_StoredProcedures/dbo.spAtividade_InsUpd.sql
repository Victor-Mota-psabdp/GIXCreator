SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create PROCEDURE [dbo].[spAtividade_InsUpd]

			@Cd_Tp_Ativ char(3),
			@Nome_Tp_Ativ varchar(60)

AS


Begin Transaction

	If  exists (select Cd_Tp_Ativ from Tipo_Atividade where Cd_Tp_Ativ=@Cd_Tp_Ativ)
	Begin
		Update
			Tipo_Atividade
		Set
			Nome_Tp_Ativ=@Nome_Tp_Ativ
		Where
			Cd_Tp_Ativ=@Cd_Tp_Ativ
	End
	Else
		Insert
			Tipo_Atividade(
				Cd_Tp_Ativ,
				Nome_Tp_Ativ
				)
		Values
			(
			@Cd_Tp_Ativ,	
			@Nome_Tp_Ativ
		)
	

Commit Transaction





GO
