SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spOperadorPortuario_Del]
		@ID_OP int,
		@Descricao as varchar(100)
		
AS			
			Update Tipo_Operador_Portuario set Ativo = 0
			where ID_OP = @ID_OP and Ativo = 1
GO
