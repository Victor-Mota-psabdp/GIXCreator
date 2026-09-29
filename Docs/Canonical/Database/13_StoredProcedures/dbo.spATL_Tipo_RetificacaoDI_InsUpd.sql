SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Tipo_RetificacaoDI
CREATE PROCEDURE [dbo].[spATL_Tipo_RetificacaoDI_InsUpd] 
	@ID_TP_RET		BigInt,
    @NOME_TP_RET	varchar(MAX),
    @Cd_Usuario		varchar(6),
    @Ativo			bit,
    @Dt_Ins			datetime
    
AS
	
Begin Transaction
	if not exists (select ID_TP_RET from Tipo_RetificacaoDI where ID_TP_RET = @ID_TP_RET)
		Begin			
			Insert into
				Tipo_RetificacaoDI
				(NOME_TP_RET,Ativo,Cd_Usuario,Dt_Ins)
			values
				(@NOME_TP_RET,@Ativo,@Cd_Usuario,GETDATE())
		End
	Else
	    Begin		
			Update
				Tipo_RetificacaoDI
			Set				        
		        NOME_TP_RET = @NOME_TP_RET,
				Dt_Ins = GETDATE(),
				Cd_Usuario = @Cd_Usuario,
				Ativo = @Ativo
			Where
				ID_TP_RET = @ID_TP_RET
				
		End
		
Commit Transaction

GO
