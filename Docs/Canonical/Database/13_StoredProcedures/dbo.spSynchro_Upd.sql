SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure spSynchro_Upd

	@Num_Proc		varchar(16),
	@ID_NF			int,
	@Nota_Fiscal	varchar(6),
	@Mensagem_Erro	Varchar(200),
	@Emissao		datetime
	
as
	begin transaction

		update
			Nota_cliente
		set
			Nota_fiscal = @Nota_Fiscal,
			Emissao = @Emissao,
			Mensagem_Erro = @Mensagem_Erro
		where
			num_proc = @Num_Proc and id_NF = @ID_NF
		

		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END

Commit Transaction


GO
