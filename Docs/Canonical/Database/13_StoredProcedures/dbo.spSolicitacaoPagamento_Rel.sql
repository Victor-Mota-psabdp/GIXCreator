SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spSolicitacaoPagamento_Rel] 
	
as
	Select 
		numSol_Pgto,dt_solicitacao,SOL.Nome_usuario solicitante,moeda,dt_vencimento,valor,cliente.nome_raz_soc cliente,
		referente, observacoes,autorizado From Solicitacao_Pagamento SP
	Left Outer Join Usuario Sol on SP.cd_solicitante = SOL.Cd_Usuario 
	Left Outer Join Pessoa Cliente  on SP.cd_cliente = Cliente.Cd_Pes
		Where SP.ck_ativo = 1



GO
