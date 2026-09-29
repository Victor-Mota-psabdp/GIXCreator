SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help E_MIX_XML_ERRO

CREATE Procedure [dbo].[spE_MIX_XML_ERRO_InsUpd]
	(
		@Num_Proc			Varchar(16),	
		@id_consulta_tipo	int,		
		@Mensagem_Erro		Varchar(400)
	)
	as
Begin

	if not exists(Select Num_Proc from E_MIX_XML_Erro where Num_Proc = @Num_Proc
		 and id_consulta_tipo = @id_consulta_tipo)
		BEGIN
			Insert E_MIX_XML_ERRO 
				(Num_Proc,id_consulta_tipo,Dt_Envio,Mensagem_Erro)
			Values
				(@Num_Proc,@id_consulta_tipo,GETDATE(),@Mensagem_Erro)
		END
	ELSE
		BEGIN
			UPDATE 
				E_MIX_XML_ERRO
			SET
				Dt_Envio = GETDATE(),
				Mensagem_Erro=@Mensagem_Erro
			WHERE 
				Num_Proc = @Num_Proc and id_consulta_tipo = @id_consulta_tipo				
		
		END
End



GO
