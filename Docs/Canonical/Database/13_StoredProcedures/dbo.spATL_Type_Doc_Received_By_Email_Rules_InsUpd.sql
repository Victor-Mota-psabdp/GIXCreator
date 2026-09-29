SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Type_Doc_Received_By_Email_Rules_InsUpd]
( 
	@Cd_Tipo varchar(1),
    @Nome_Tipo varchar(200),
    @Cd_Usuario as varchar(6),
    @Ativo bit,
    @Dt_Ins datetime
 )
  
  --select * from Tipo_Docs_Recebidos_Select
AS

if not exists (select Cd_Tipo from ATL_INT.[dbo].Type_Doc_Received_By_Email_Rules where Cd_Tipo = @Cd_Tipo)
	Begin			
			Insert into
				ATL_INT.[dbo].Type_Doc_Received_By_Email_Rules
				(Cd_Tipo,Nome_Tipo, Cd_Usuario, Ativo, Dt_ins
				 )
			values
				(@Cd_Tipo,@Nome_Tipo,@Cd_Usuario,@Ativo,GETDATE()
				)
		End
		Else
	    Begin		
			Update
				ATL_INT.[dbo].Type_Doc_Received_By_Email_Rules
			Set				        
		        Nome_Tipo = @Nome_Tipo,
				Cd_Usuario = @Cd_Usuario,
				Ativo =@Ativo,
				Dt_Ins = GETDATE()
			Where
				Cd_Tipo = @Cd_Tipo
				End

GO
