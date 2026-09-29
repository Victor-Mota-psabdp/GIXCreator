SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spBoleto_GeraTXT_Sel]--'IACSR201301009BRB'
	
as
	select
		B.FatCod + ' TX: ' + isnull(convert(varchar,[dbo].[fBusca_CampoCliente](left(B.FatCod,16),31)),'') Fatura,
		dt_boleto,
		nome_usuario solicitante,
		P.nome_raz_soc cliente,
		cd_boleto referente ,
		valor,
		FatDtVenc Vencimento,
		inscricao_numero,
		agencia_cedente,
		conta_cedente,
		cd_instrucao_01,
		cd_instrucao_02,
		P.num_cpf_cnpj,
		isnull(Rua,'') + ',' + isnull(numero,'') + isnull(compl_end,'') rua,
		isnull(Bairro,'') Bairro,
		isnull(replace(CEP,'-',''),'') CEP,
		isnull(Cidade,'') Cidade,
		isnull(UF,'') UF			
	from boleto B
		join usuario U on U.cd_usuario = B.cd_usuario
		join pessoa P on P.cd_pes = B.cd_pes
		left join endereco E on E.cd_pes = B.cd_pes and cd_tp_end = 'COM'
		join fatura F on F.fatcod = B.fatcod
	where 
--		cd_boleto = 07260002
		dt_emissao_txt is null

	
	UNION ALL
	
	select
		B.FatCod + ' TX: ' + isnull(convert(varchar,[dbo].[fBusca_CampoCliente](left(B.FatCod,16),31)),'') Fatura,
		dt_boleto,
		nome_usuario solicitante,
		P.nome_raz_soc cliente,
		cd_boleto referente ,
		valor,
		Vencimento Vencimento,
		inscricao_numero,
		agencia_cedente,
		conta_cedente,
		cd_instrucao_01,
		cd_instrucao_02,
		P.num_cpf_cnpj,		
		isnull(NF.Endereco,'') + ',' + isnull(NF.Numero,'') + isnull(E.Compl_End,'') rua,
		isnull(NF.Bairro,'') Bairro,
		isnull(replace(NF.CEP,'-',''),'') CEP,
		isnull(NF.Cidade,'') Cidade,
		isnull(NF.UF,'') UF			
	from boleto B
		join usuario U on U.cd_usuario = B.cd_usuario
		join pessoa P on P.cd_pes = B.cd_pes
		left join endereco E on E.cd_pes = B.cd_pes and cd_tp_end = 'COM'
		join NF_Fatura NF on NF.Numero_Fat = B.fatcod
	where 
		dt_emissao_txt is null
	order by 5
		

GO
