SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spTipo_RetificacaoDI_InsUPD] 
	@ID_TP_RET BigInt,
    @NOME_TP_RET varchar(MAX),
    @Nome_Usuario varchar(30),
    @Status bit
    
AS

	Declare @Cd_Usuario as varchar(6)	
	Set @Cd_Usuario = (select Cd_Usuario from usuario where Nome_Usuario = @Nome_Usuario)
	
	if not exists (select ID_TP_RET from Tipo_RetificacaoDI where ID_TP_RET = @ID_TP_RET)
		Begin			
			Insert into
				Tipo_RetificacaoDI
				(
				 NOME_TP_RET,
				 Dt_Ins,
				 Cd_Usuario,
				 Ativo
				 )
			values
				(				
				@NOME_TP_RET,			
				GETDATE(),
				@Cd_Usuario,
				1
				)
		End
	Else
	    Begin		
			Update
				Tipo_RetificacaoDI
			Set				        
		        NOME_TP_RET = @NOME_TP_RET,
				Dt_Ins = GETDATE(),
				Cd_Usuario = @Cd_Usuario,
				Ativo = @Status
			Where
				ID_TP_RET = @ID_TP_RET
				
		End
		

GO
