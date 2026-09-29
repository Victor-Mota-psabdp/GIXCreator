SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE   procedure [dbo].[spAgencia_InsUpd]

	@CodigoBco varchar(3),
	@CodigoAgen varchar(5),
        @NomeAgen varchar(30)
AS

Begin Transaction

	If  exists (select Cd_Banco, Cd_Agencia, Nome_Agencia
                    from Agencia 
                    where Cd_Banco=@CodigoBco And
                          Cd_Agencia = @CodigoAgen)
	Begin
		Update
			Agencia
		Set
			Cd_Banco = @CodigoBco,
			Cd_Agencia = @CodigoAgen,
                        Nome_Agencia = @NomeAgen 
                        
			
		Where
			Cd_Banco = @CodigoBco And
                        Cd_Agencia = @CodigoAgen
                        
	End
	Else
		Begin	
		Insert
		          Agencia(
			           Cd_Banco,
				   Cd_Agencia,
                                   Nome_Agencia
				 )
		Values
			(
			@CodigoBco,
			@CodigoAgen,
                        @NomeAgen
			)
		End

Commit Transaction




GO
