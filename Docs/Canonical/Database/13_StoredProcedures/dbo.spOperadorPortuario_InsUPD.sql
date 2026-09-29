SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spOperadorPortuario_InsUPD] 
	@ID_OP int,
    @Descricao varchar(100),
    @Nome_Usuario varchar(30),
    @Status bit,
    @ID_OUT  int OUTPUT
    
AS

	Declare @Cd_Usuario as varchar(6)
	
	Set @Cd_Usuario = (select Cd_Usuario from usuario where Nome_Usuario = @Nome_Usuario)

	
	if not exists (select ID_OP from Tipo_Operador_Portuario where ID_OP = @ID_OP)
		Begin
			Set @ID_OP =(Select Isnull(max(ID_OP),0) + 1 from Tipo_Operador_Portuario)
			Insert into
				Tipo_Operador_Portuario
				(ID_OP,
				 Descricao_OP,
				 Dt_Criacao,
				 Cd_Usuario,
				 Ativo
				 )
			values
				(
				@ID_OP,
				@Descricao,			
				GETDATE(),
				@Cd_Usuario,
				@Status
				)
		End
	Else
	    Begin		
			Update
				Tipo_Operador_Portuario
				Set
				        ID_OP = @ID_OP,
				        Descricao_OP = @Descricao,
						Dt_Criacao = GETDATE(),
						Cd_Usuario = @Cd_Usuario,
						Ativo = @Status
			Where
				ID_OP = @ID_OP
				
		End
		
Set @ID_OUT = @ID_OP
GO
