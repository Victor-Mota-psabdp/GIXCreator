SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spPgto_Rcto_BANCO_Rel] --'LA2010090001'
		
	@Num_Lcto	VarChar(16)

AS

	select 
		BANCO.campo_dados				Nomedobanco,
		CDBANCO.campo_dados				NumerodoBanco,	
		CDCTACTE.campo_dados			Agencia,
		CONTA .campo_Dados				ContaCorrente,
		num_cpf_cnpj					CPF,
		nome_raz_soc					RAZAO_SOCIAL
	from pgto_rcto PR
		left join pessoa P on pr.cd_pes = p.cd_pes
		left join campo_pessoa BANCO on PR.cd_pes = BANCO.cd_pes and BANCO.id_campo = '3'
		left join campo_pessoa CDBANCO on PR.cd_pes = CDBANCO.cd_pes and CDBANCO.id_campo ='4'
		left join campo_pessoa CDCTACTE on PR.cd_pes = CDCTACTE.cd_pes and CDCTACTE.id_campo = '5'
		left join campo_pessoa CONTA on PR.cd_pes = CONTA.cd_pes and CONTA.id_campo = '7'
	where
		Num_Lcto = @Num_Lcto



GO
