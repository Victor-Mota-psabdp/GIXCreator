SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




create  procedure [dbo].[spBanco_InsUpd]

	@Codigo varchar(3),
	@Nome varchar(30),
	@Rem varchar(5)
AS

Begin Transaction

	If  exists (select Cd_Banco from Banco where Cd_Banco=@Codigo)
	Begin
		Update
			Banco
		Set
			Cd_Banco = @Codigo,
			Nome_Banco = @Nome,
            Cod_Banco_Rem = @Rem
			
		Where
			Cd_Banco = @Codigo
	End
	Else
		Insert
		        Banco(
				Cd_Banco,
				Nome_Banco,
                Cod_Banco_Rem
				)
		Values
			(
			@Codigo,
			@Nome,
            @Rem
			)
	

Commit Transaction





GO
