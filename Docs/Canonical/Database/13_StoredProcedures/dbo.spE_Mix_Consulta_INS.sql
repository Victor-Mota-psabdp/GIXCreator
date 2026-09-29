SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spE_Mix_Consulta_INS]
	@id_servico [int],
	@id_empresa [int],
	@id_cnpj [int],
	@id_consulta_tipo [int],
	@id_parametro_grupo [int] ,
	@Id_parametro_tipo [int] ,
	@valor [varchar](50) ,
	@num_proc [varchar](16)
		
AS

	Begin		
		Insert
			E_Mix_Consulta	
				([id_servico],[id_empresa],[id_cnpj],[id_consulta_tipo],[id_parametro_grupo],[Id_parametro_tipo],[valor],[num_proc],[dt_ins])
				Values
				(@id_servico,@id_empresa,@id_cnpj,@id_consulta_tipo,@id_parametro_grupo,@Id_parametro_tipo,@valor,@num_proc,GETDATE())
				
	End

GO
