SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spTipoComunicacao_InsUpd]

			@Cd_Tp_COM char(3),
			@Nome_Tp_Com varchar(60)

AS


Begin Transaction

	If  exists (select Cd_Tp_COM from Tipo_Comunicacao where Cd_Tp_COM=@Cd_Tp_COM)
	Begin
		Update
			Tipo_Comunicacao
		Set
			Nome_Tp_Com=@Nome_Tp_Com
		Where
			Cd_Tp_COM=@Cd_Tp_COM
	End
	Else
		Insert
			Tipo_Comunicacao(
				Cd_Tp_COM,
				Nome_Tp_Com
				)
		Values
			(
			@Cd_Tp_COM,	
			@Nome_Tp_Com
		)
	

Commit Transaction





GO
