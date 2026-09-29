SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spCampoImpostos_NF_Fatura_Ins]
(
@NotaFiscal varchar(8),
@CdSite char(1),
@IDImposto int,
@Valor decimal(18,2),
@Base decimal(18,2),
@CdUsuario varchar(6)
)

as

Begin Transaction
Declare @ID int


If  not exists  (Select Id_Imposto from Campo_Impostos_NF_Fatura where Nota_Fiscal = @NotaFiscal and Cd_Site =@CdSite and ID_Imposto = @IDImposto)
Begin
	Insert INTO
		Campo_Impostos_NF_Fatura
		(
			Nota_Fiscal,
			Cd_Site,
			Id_Imposto,
			Valor,
			Base,
			Cd_Usuario
		)
		Values
		(
			@NotaFiscal,
			@CdSite,
			@IdImposto,
			@Valor,
			@Base,
			@CdUsuario
		)	
End
Else
Begin
		Update
			Campo_Impostos_NF_Fatura
		Set
			Valor = @Valor,
			Base = @Base,
			Cd_Usuario = @CdUsuario
		where 
			Nota_Fiscal = @NotaFiscal and Cd_Site =@CdSite and ID_Imposto = @IDImposto
End

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END


COMMIT TRANSACTION






GO
