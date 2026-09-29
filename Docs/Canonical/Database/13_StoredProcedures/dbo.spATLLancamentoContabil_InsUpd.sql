SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure spATLLancamentoContabil_InsUpd
		

		@lctData Datetime,
		@lctNumero Int,
		@Nome_Usuario Varchar(40),
		@Status		Char(1),
		@Mes		int,
		@Ano		Int

AS
	Declare @Cd_usuario as varchar(20)
	Begin Transaction
		Set @Cd_Usuario=(select cd_usuario from usuario where nome_usuario=@Nome_Usuario)
		if @lctNumero is null
		   BEGIN
				Set @lctNumero=ISNULL((select max(lctnumero) from ATL_Lancamento_Contabil where mes=@mes and ano=@ano),1)
				Set @lctNumero=@lctNumero + 1
				Insert into
					ATL_Lancamento_Contabil
						(
							lctData,
							lctNumero,
							Cd_Usuario,
							Status,
							Mes,
							Ano
						)
				Values
						(
							@lctData,
							@lctNumero,
							@Cd_Usuario,
							@Status,
							@Mes,
							@Ano
						)
			END
	ELSE
			BEGIN
					UPDATE 
						ATL_Lancamento_Contabil
							SET
								lctData=@lctData,
								Cd_Usuario=@Cd_Usuario,
								Status=@Status
					WHERE
						lctNumero=@lctnumero and mes=@mes and ano=@Ano
			END

	IF @@ERROR <> 0
		BEGIN
			RETURN -1
		END
COMMIT TRANSACTION
GO
