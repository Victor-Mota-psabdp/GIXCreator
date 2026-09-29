SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from Solicitacao_Pagamento

CREATE PROCEDURE [dbo].[spSolicitacaoPagamentoStatus_Rel]--'2012-12-01','2012-12-06','A'

(
	@Dt_Inicial	datetime,
	@Dt_Final	datetime,
	@status		varchar(1)
)
AS

if @status = 'A'  
	BEGIN
		Select  
			numSol_Pgto Referencia,
			SOL.Nome_usuario solicitante,
			referente,
			valor,
			dt_vencimento,
			Cliente.apelido cliente, 
			sp.autorizado,
			(case when dt_autDiretoria is null then
				''
			else
				Aut.Nome_usuario end) Diretor
			
		From  
			Solicitacao_Pagamento SP
			Left Outer Join Usuario			Sol			on SP.cd_solicitante = SOL.Cd_Usuario		
			Left Outer Join Pessoa			Cliente		on SP.cd_cliente 	= Cliente.Cd_Pes
			Left Outer Join Usuario			Aut			on SP.cd_autGerente = AUT.Cd_Usuario		
		Where
			dt_solicitacao between @Dt_Inicial and @Dt_Final
			and SP.ck_ativo = 1
	END
ELSE
	BEGIN
		Select  
			numSol_Pgto Referencia,
			SOL.Nome_usuario solicitante,
			referente,
			valor,
			dt_vencimento,
			Cliente.apelido cliente, 
			sp.autorizado,
			(case when dt_autDiretoria is null then
				''
			else
				Aut.Nome_usuario end) Diretor		
		From  
			Solicitacao_Pagamento SP
			Left Outer Join Usuario			Sol			on SP.cd_solicitante = SOL.Cd_Usuario		
			Left Outer Join Pessoa			Cliente		on SP.cd_cliente 	= Cliente.Cd_Pes
			Left Outer Join Usuario			Aut			on SP.cd_autGerente = AUT.Cd_Usuario		
		Where
			dt_solicitacao between @Dt_Inicial and @Dt_Final
			and autorizado = @status and SP.ck_ativo = 1

	END






























GO
