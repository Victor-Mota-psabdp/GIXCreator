SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[spSolicitacaoPagamento_Sel] 

(
@numSol_Pgto	VarChar(12)
)
AS
	Select  
		numSol_Pgto,SOL.Nome_usuario solicitante,
		Nome_area departamento,formaPgto,moeda,dt_vencimento,valor, 
		Cliente.apelido cliente,cliente.nome_raz_soc cliente2, referente,	observacoes,
		banco,agencia,contaCorrente,cnpj,
		Gerente.nome_usuario Gerente,dt_AutGerente,SP.autorizado autorizacao
		
	From  
		Solicitacao_Pagamento SP
		Left Outer Join Usuario			Sol			on SP.cd_solicitante = SOL.Cd_Usuario		
		Left Outer Join Area			Dep			on SP.cd_departamento = Dep.Cd_area
		Left Outer Join Pessoa			Cliente		on SP.cd_cliente 	= Cliente.Cd_Pes 
		Left Outer Join Usuario			Gerente		on Sp.cd_AutGerente = Gerente.Cd_Usuario		
		
	Where
		SP.numSol_Pgto = @numSol_Pgto and SP.ck_ativo = 1






























GO
