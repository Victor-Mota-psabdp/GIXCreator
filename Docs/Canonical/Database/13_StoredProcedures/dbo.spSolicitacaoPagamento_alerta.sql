SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Carlos Eduardo
-- Create date: 12/02/2011
-- Description: Select para Envio de Exccel: Solicitação de Pagamentos em Analise

-- =============================================
CREATE PROCEDURE [dbo].[spSolicitacaoPagamento_alerta]
AS
BEGIN
	Select 
		Sp.numSol_Pgto					Referencia,
		SOL.Nome_usuario				Solicitante,
		Sp.referente					Referente,
		Sp.valor						Valor,
		Sp.dt_Vencimento				Vencimento,
		Cliente.nome_raz_soc			Cliente
	From  
		Solicitacao_Pagamento SP
		Left Outer Join Usuario Sol	on SP.cd_solicitante = SOL.Cd_Usuario		
		Left Outer Join Pessoa Cliente on SP.cd_cliente = Cliente.Cd_Pes
	Where
		Sp.autorizado = 'E' and SP.ck_ativo = '1'
END



GO
