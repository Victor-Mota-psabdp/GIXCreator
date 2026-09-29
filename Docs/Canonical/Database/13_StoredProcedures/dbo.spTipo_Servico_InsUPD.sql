SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spTipo_Servico_InsUPD] 
	@Id_TP_Servico BigInt,
    @Nome_TP_Servico varchar(30),
    @Nome_Usuario varchar(30),
    @Status char(1)
    
AS

Begin Transaction

	Declare @Cd_Usuario as varchar(6)	
	Set @Cd_Usuario = (select Cd_Usuario from usuario where Nome_Usuario = @Nome_Usuario)
	
	if not exists (select Id_TP_Servico from Tipo_Servico where Id_TP_Servico = @Id_TP_Servico)
		Begin			
			Insert into
				Tipo_Servico
				(
				 Nome_TP_Servico,
				 Dt_Ins,
				 Cd_Usuario,
				 Ativo,
				 JOB
				 )
			values
				(				
				@Nome_TP_Servico,			
				GETDATE(),
				@Cd_Usuario,
				@Status,
				'N'
				)
		End
	Else
	    Begin		
			Update
				Tipo_Servico
			Set				        
		        Nome_TP_Servico = @Nome_TP_Servico,
				Dt_Ins = GETDATE(),
				Cd_Usuario = @Cd_Usuario,
				Ativo = @Status
			Where
				Id_TP_Servico = @Id_TP_Servico
				
		End

if @@error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -2
	END

COMMIT TRANSACTION
		

GO
