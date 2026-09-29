SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spE_MIX_XML_Upd]
	(		
		@retorno_erro		Varchar(400),	
		@ID					BigInt
		
	)
as
Begin

	Declare @QtdDias as Int
	Declare @id_consulta_tipo as Int
	
	set @id_consulta_tipo = (select id_consulta_tipo from E_MIX_XML where ID = @ID)
		
	if @retorno_erro = 'Sua consulta não constou registros!' 
		and @id_consulta_tipo = 20
		begin
			set @QtdDias = -30
		End
	else if @retorno_erro = 'Sua consulta não constou registros!' 
		and @id_consulta_tipo < 20
		begin
			set @QtdDias = -5
		end
	else if @retorno_erro = 'A consulta para o parâmetro informado no XML não foi cadastrada no SiscomexNet.' 
		and @id_consulta_tipo < 20
		begin
			set @QtdDias = -3
		end		
	else
		begin
			set @QtdDias = 0
		end
		
	--if @retorno_erro <> 'A consulta para o parâmetro informado no XML não foi cadadstrada no SiscomexNet.'
		begin
			Update 
				dbo.E_MIX_XML 
			set 
				dt_retorno=getdate(), 
				retorno_erro=@retorno_erro		
			where 
				id=@ID
				and dt_envio < getdate() + @QtdDias 
		end
End


GO
