SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Tipo_Usuario_Retificacao
CREATE procedure [dbo].[spATL_Tipo_Usuario_Retificacao_InsUpd]
( 
	@ID_TP_USUARIO_RET BigInt,
    @Nome_TP_USUARIO_RET varchar(50),
    @Nome_Usuario varchar(30),
    @Ativo bit,
    @Dt_Ins datetime
 )
    
AS

	Declare @Cd_Usuario as varchar(6)	
	Set @Cd_Usuario = (select Cd_Usuario from usuario where Nome_Usuario = @Nome_Usuario)
	
	if not exists (select ID_TP_USUARIO_RET from Tipo_Usuario_Retificacao where ID_TP_USUARIO_RET = @ID_TP_USUARIO_RET)
		Begin			
			Insert into
				Tipo_Usuario_Retificacao
				(Nome_TP_USUARIO_RET, Dt_Ins, Cd_Usuario, Ativo
				 )
			values
				(@Nome_TP_USUARIO_RET,GETDATE(),@Cd_Usuario,@Ativo
				)
		End
	Else
	    Begin		
			Update
				Tipo_Usuario_Retificacao
			Set				        
		        Nome_TP_USUARIO_RET = @Nome_TP_USUARIO_RET,
				Dt_Ins = GETDATE(),
				Cd_Usuario = @Cd_Usuario,
				Ativo =@Ativo
			Where
				ID_TP_USUARIO_RET = @ID_TP_USUARIO_RET
				
		End

GO
