SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE       procedure [dbo].[spParidadeParametro_InsUpd]

	@Codigo varchar(3),
	@TipoParidade varchar(30),
	@Parametro float

AS

Begin Transaction

	IF exists(SELECT * FROM TIPO_PARIDADE WHERE Cd_Tp_Par=@Codigo)
		BEGIN
			UPDATE
				TIPO_PARIDADE
			SET
				Nome_Tp_Par = @TipoParidade, Parametro = @Parametro
            WHERE
                  Cd_Tp_Par=@Codigo
		END
	ELSE
		Begin
			INSERT Tipo_PARIDADE
				(Cd_Tp_Par, Nome_Tp_Par, Parametro)
			Values
				(@Codigo, @TipoParidade,@Parametro)
		End

	if @@error <> 0
		BEGIN
			Rollback Transaction
			return -1
		end

Commit Transaction


GO
