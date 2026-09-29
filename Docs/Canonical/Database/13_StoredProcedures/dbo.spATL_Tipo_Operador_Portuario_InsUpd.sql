SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Operador_Portuario
CREATE procedure [dbo].[spATL_Tipo_Operador_Portuario_InsUpd] 
(
	@ID_OP			Int,
	@Descricao_OP	varchar(100),
    @Cd_Usuario		varchar(6),
    @Dt_Criacao		datetime,
    @Ativo		bit
 )
    
AS
	
	if not exists (select ID_OP from Tipo_Operador_Portuario where ID_OP = @ID_OP)
		Begin
			Set @ID_OP =(Select Isnull(max(ID_OP),0) + 1 from Tipo_Operador_Portuario)
			Insert into	Tipo_Operador_Portuario
				(ID_OP,Descricao_OP,Dt_Criacao, Cd_Usuario,Ativo)
			values
				(@ID_OP,@Descricao_OP,GETDATE(),@Cd_Usuario,@Ativo)
		End
	Else
	    Begin		
			Update
				Tipo_Operador_Portuario
			Set
		        ID_OP = @ID_OP,
		        Descricao_OP = @Descricao_OP,
				--Dt_Criacao = GETDATE(),
				Cd_Usuario = @Cd_Usuario,
				Ativo = @Ativo
			Where
				ID_OP = @ID_OP
				
		End
		

GO
