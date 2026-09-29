SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vwSolPagamento_Sel] 

AS
	Select DISTINCT
		numSol_Pgto			[01_Referencia],
		SOL.Nome_usuario	[02_Solicitante],
		Nome_area			[03_Departamento],
		formaPgto			[04_Forma de Pagamento],
		moeda				[05_Moeda],
		valor				[06_Valor],
		dt_vencimento		[07_Data de Vencimento],		 
--		Cliente.apelido cliente,
		cliente.nome_raz_soc [08_Pague-se:],
		referente			[09_Referente],	
		observacoes			[10_Observações],
		banco				[11_Banco],
		agencia				[12_Agencia],
		contaCorrente		[13_Conta Corrente],
		cnpj				[14_CNPJ/CPF]		
	From  
		Solicitacao_Pagamento SP
		Left Outer Join Usuario			Sol			on SP.cd_solicitante = SOL.Cd_Usuario		
		Left Outer Join Area			Dep			on SP.cd_departamento = Dep.Cd_area
		Left Outer Join Pessoa			Cliente		on SP.cd_cliente 	= Cliente.Cd_Pes 			
	Where
		SP.ck_ativo = 1
		






















GO
