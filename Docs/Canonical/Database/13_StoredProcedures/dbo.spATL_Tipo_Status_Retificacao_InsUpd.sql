SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Tipo_Status_Retificacao
CREATE procedure [dbo].[spATL_Tipo_Status_Retificacao_InsUpd]
( 
	@ID_Status BigInt,
    @Status_Descricao varchar(50),
    @Nome_Usuario varchar(30),
    @Ativo bit,
    @Dt_Ins datetime
 )
    
AS

	Declare @Cd_Usuario as varchar(6)	
	Set @Cd_Usuario = (select Cd_Usuario from usuario where Nome_Usuario = @Nome_Usuario)
	
	if not exists (select ID_Status from Tipo_Status_Retificacao where ID_Status = @ID_Status)
		Begin			
			Insert into
				Tipo_Status_Retificacao
				(Status_Descricao, Dt_Ins, Cd_Usuario, Ativo
				 )
			values
				(@Status_Descricao,GETDATE(),@Cd_Usuario,@Ativo
				)
		End
	Else
	    Begin		
			Update
				Tipo_Status_Retificacao
			Set				        
		        Status_Descricao = @Status_Descricao,
				Dt_Ins = GETDATE(),
				Cd_Usuario = @Cd_Usuario,
				Ativo =@Ativo
			Where
				ID_Status = @ID_Status
				
		End

GO
