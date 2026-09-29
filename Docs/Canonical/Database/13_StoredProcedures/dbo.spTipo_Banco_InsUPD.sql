SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spTipo_Banco_InsUPD] 
	@id_tp_banco BigInt,
    @nome_tp_banco varchar(50),
    @Nome_full_banco varchar(200),
    @Nome_Usuario varchar(30),
    @Status bit
    
AS

	Declare @Cd_Usuario as varchar(6)	
	Set @Cd_Usuario = (select Cd_Usuario from usuario where Nome_Usuario = @Nome_Usuario)
	
	if not exists (select id_tp_banco from Tipo_Banco where id_tp_banco = @id_tp_banco)
		Begin			
			Insert into
				Tipo_Banco
				(nome_tp_banco,Nome_full_banco,Cd_Usuario,dt_ins)
			values
				(@nome_tp_banco,@Nome_full_banco,@Cd_Usuario,GETDATE())
		End
	Else
	    Begin		
			Update
				Tipo_Banco
			Set				        
		        nome_tp_banco = @nome_tp_banco,
		        Nome_full_banco = @Nome_full_banco,
				Dt_Ins = GETDATE(),
				Cd_Usuario = @Cd_Usuario,
				Ativo = @Status
			Where
				id_tp_banco = @id_tp_banco
				
		End
		

GO
