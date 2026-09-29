SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Tipo_Servico_InsUpd]
(
	@Id_TP_Servico		BigInt,
    @Nome_TP_Servico	varchar(30),
    @Cd_Usuario			varchar(10),
    @ativo				char(1),
    @JOB				char(1)
)
    
AS

Begin Transaction
	
	if not exists (select Id_TP_Servico from Tipo_Servico where Id_TP_Servico = @Id_TP_Servico)
		Begin			
			Insert into
				Tipo_Servico
				(
					Nome_TP_Servico,Dt_Ins,Cd_Usuario,Ativo,JOB
				)
				values
				(				
					@Nome_TP_Servico,GETDATE(),@Cd_Usuario,@ativo,'N'
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
				Ativo = @ativo
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
