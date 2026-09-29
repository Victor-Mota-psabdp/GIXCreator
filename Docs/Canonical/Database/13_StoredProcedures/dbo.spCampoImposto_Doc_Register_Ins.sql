SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spCampoImposto_Doc_Register_Ins]
(
@ID Int,
@CdSite char(1),
@IDImposto int,
@Valor decimal(18,2),
@Base decimal(18,2),
@CdUsuario varchar(6)
)

as

Begin Transaction
--Declare @ID int


If  not exists  (Select Id_Imposto from Campo_Impostos_Doc_Register where ID = @ID and Cd_Site =@CdSite and ID_Imposto = @IDImposto)
	Begin
		Insert INTO
			Campo_Impostos_Doc_Register
			(
				ID,
				Cd_Site,
				Id_Imposto,
				Valor,
				Base,
				Cd_Usuario
			)
			Values
			(
				@ID,
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
				Campo_Impostos_Doc_Register
			Set
				Valor = @Valor,
				Base = @Base,
				Cd_Usuario = @CdUsuario
			where 
				ID = @ID and Cd_Site =@CdSite and ID_Imposto = @IDImposto
	End

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END


COMMIT TRANSACTION






GO
