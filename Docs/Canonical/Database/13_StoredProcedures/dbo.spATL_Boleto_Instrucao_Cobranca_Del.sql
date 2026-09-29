SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_help Boleto_Instrucao_Cobranca
CREATE procedure [dbo].[spATL_Boleto_Instrucao_Cobranca_Del]
(
	@Cd_Instrucao	varchar(2)
)
as
	if exists(select Cd_Instrucao from Boleto_Instrucao_Cobranca where Cd_Instrucao= @Cd_Instrucao)
	BEGIN
		UPDATE Boleto_Instrucao_Cobranca SET ATIVO= 0 where Cd_Instrucao= @Cd_Instrucao
	END

GO
