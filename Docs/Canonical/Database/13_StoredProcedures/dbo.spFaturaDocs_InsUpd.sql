SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[spFaturaDocs_InsUpd]

	@Fatura_PC	varchar(17),
	@Nome_DC	varchar(30),
	@Tipo		char(1)

As

BEGIN TRANSACTION

	Declare @ID_DC Int

	SEt @ID_DC=(select ID_DC from Tipo_Doc_Cliente where Nome_DC=@Nome_DC)

	If exists(select * from Fatura_Docs where Fatura_PC=@Fatura_PC and ID_DC=@ID_DC)
		Begin
			UPDATE
				Fatura_Docs
			SET
				Tipo=@Tipo
			WHERE
				Fatura_PC=@Fatura_PC and ID_DC=@ID_DC
		End
	Else
		Begin
			Insert
				Fatura_Docs(Fatura_PC,ID_DC,Tipo)
			Values
				(@Fatura_PC,@ID_DC,@Tipo)
		End


	IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -2
		END
COMMIT TRANSACTION



GO
