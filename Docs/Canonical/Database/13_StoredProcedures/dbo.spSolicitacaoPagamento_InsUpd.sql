SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spSolicitacaoPagamento_InsUpd]

	@numSol_Pgto				varchar(12),
	@cd_solicitante				varchar(10),
	@cd_departamento			varchar(3),
	@formaPgto					varchar(20),
	@moeda						varchar(5),
	@dt_vencimento				datetime,
	@valor						decimal(10,2),
	@cd_cliente					varchar(10),
	@referente					varchar(150),		
	@observacoes				varchar(200),
	@banco						varchar(30),
	@agencia					varchar(30),
	@contaCorrente				varchar(25),
	@cnpj						varchar(25),
	@cd_AutGerente				varchar(10),
	@dt_AutGerente				datetime,
	@numSol_PgtoN				varchar(13) output

AS
BEGIN
	Begin Transaction
		if not exists(select * from Solicitacao_Pagamento where numSol_Pgto=@numSol_Pgto)
			Begin
				Declare @novo  varchar(13)
				set @novo = (select cast(isnull(max(right(numSol_Pgto,4)),0) + 1 as varchar(5)) FROM Solicitacao_Pagamento where left(numSol_Pgto,8) = 'SD' + CAST(YEAR(GETDATE()) AS VARCHAR(4)) + RIGHT('0'+ CAST(MONTH(GETDATE()) AS VARCHAR(2)),2))
				set @novo = '00000' + @novo
				set @novo = 'SD' + convert(varchar,year(getdate()),4) + right('0' + convert(varchar,month(getdate()),2),2) + right(@novo,4)
			Insert Into 
				Solicitacao_Pagamento
				(numSol_Pgto, cd_solicitante, cd_departamento,formaPgto, moeda, dt_vencimento,valor, cd_cliente, referente, observacoes, 
				 banco, agencia, contaCorrente,cnpj,ck_ativo, cd_AutGerente,dt_AutGerente,autorizado,dt_solicitacao)
			Values 
				(@novo, @cd_solicitante, @cd_departamento,@formaPgto, @moeda, @dt_vencimento,@valor, @cd_cliente, @referente, @observacoes, 
				@banco, @agencia, @contaCorrente, @cnpj,1, @cd_AutGerente,@dt_AutGerente, 'E',getdate())		

		Set @numSol_PgtoN = @novo

			End
		else
			BEGIN
				Set @numSol_PgtoN = @numSol_Pgto

					UPDATE
						Solicitacao_Pagamento
					SET
						cd_solicitante=@cd_solicitante,
						cd_departamento=@cd_departamento,
						formaPgto = @formaPgto,
						moeda=@moeda,
						dt_vencimento=@dt_vencimento,
						valor = @valor,
						cd_cliente=@cd_cliente,
						referente=@referente,
						observacoes=@observacoes,
						banco=@banco,
						agencia=@agencia,
						contaCorrente=@contaCorrente,
						cnpj=@cnpj,
						ck_ativo=1,
						cd_AutGerente=@cd_AutGerente,
						dt_AutGerente=@dt_AutGerente,
						dt_solicitacao=getdate()
					WHERE
						numSol_Pgto=@numSol_Pgto					
			END

		If @@RowCount <> 1 
			Begin 
				RollBack Transaction 
				Return -1 
			End 	
	Commit Transaction
END





















GO
