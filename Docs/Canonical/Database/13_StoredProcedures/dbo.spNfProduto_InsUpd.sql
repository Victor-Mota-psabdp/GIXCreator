SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from mensagem_erro
--
--select * from nota_fiscal_produto

CREATE Procedure spNfProduto_InsUpd

	@ID_NF		Int,
	@CNPJ		Varchar(14),
	@Cliente	Varchar(50),
	@Fornecedor	Varchar(50),
	@Num_NF		Varchar(50),
	@Dt_NF		Datetime,
	@IDN		int output
	

As

BEGIN TRANSACTION

	Declare @ID				Int
	Declare	@cd_Cliente		Varchar(50)
	Declare @cd_Fornecedor	Varchar(50)

	Set @Cd_Cliente = (Select cd_pes from pessoa where apelido = @Cliente)
	Set @Cd_Fornecedor = (Select cd_pes from pessoa where apelido = @Fornecedor)

	if @ID_NF is not null
		BEGIN
			UPDATE
				Nota_fiscal_Produto
			SET
				CNPJ = @CNPJ,
				Cd_Cliente = @Cd_Cliente,
				Cd_Fornecedor = @Cd_Fornecedor,
				Num_NF = @Num_NF,
				Dt_NF = @Dt_NF
			WHERE
				ID_NF = @ID_NF
		END
	ELSE
		BEGIN
			SET @ID=(select Isnull(max(Id_NF),0)+1 from Nota_Fiscal_Produto)
			INSERT INTO
				Nota_Fiscal_Produto
				(
				ID_NF,
				CNPJ,
				Cd_Cliente,
				Cd_Fornecedor,
				Num_NF,
				Dt_NF
				)
			VALUES
				(
					@ID,
					@CNPJ,
					@Cd_Cliente,
					@Cd_Fornecedor,
					@Num_NF,
					@Dt_NF
				)
	
	Set @IDN = @ID
		END

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END


COMMIT TRANSACTION

GO
