SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Type_Doc_Received_By_Email_Rules_Del]
( 
	@Cd_Tipo varchar(1)
)

AS

if exists (select Cd_Tipo from ATL_INT.[dbo].Type_Doc_Received_By_Email_Rules where Cd_Tipo = @Cd_Tipo)
	Begin			
		Update
			ATL_INT.[dbo].Type_Doc_Received_By_Email_Rules
		Set
			Ativo =0			
		Where
			Cd_Tipo = @Cd_Tipo
	End

GO
