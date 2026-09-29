SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spBoleto_Instrucao_Cobranca_Sel]--'90000002'--'IMMCO201306001BRB'
	
	@cd_instrucao		varchar(2)

as

	select 
		cd_instrucao,
		cd_instrucao + ' - ' + nome_instrucao Instrucao,
		nome_instrucao 
	from 
		boleto_instrucao_cobranca
	where 
		cd_instrucao = @cd_instrucao
	
				
GO
