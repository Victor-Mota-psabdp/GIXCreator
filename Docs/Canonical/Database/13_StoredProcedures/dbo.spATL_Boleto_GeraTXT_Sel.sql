SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
[spATL_Boleto_GeraTXT_Sel]  'Remessa Itaú - 400 Posições'
GO
[spATL_Boleto_GeraTXT_Sel] 'Remessa Santander - 400 Posições'

*/

CREATE PROCEDURE [dbo].[spATL_Boleto_GeraTXT_Sel]
(
	@Layout			VARCHAR(100)
)
	
AS

IF @Layout = 'Remessa Itaú - 400 Posições'
	BEGIN
		SELECT
			B.FatCod + ' TX: ' + ISNULL(CONVERT(VARCHAR,[dbo].[fBusca_CampoCliente](LEFT(B.FatCod,16),31)),'') Fatura,
			dt_boleto,
			nome_usuario solicitante,
			P.nome_raz_soc cliente,
			cd_boleto referente ,
			valor,
			FatDtVenc Vencimento,
			inscricao_numero,
			REPLICATE('0', 4 - LEN(agencia_cedente)) + RTRIM(agencia_cedente)  as agencia_cedente,
			conta_cedente,
			cd_instrucao_01,
			cd_instrucao_02,
			P.num_cpf_cnpj,
			ISNULL(Rua,'') + ',' + ISNULL(numero,'') + ISNULL(compl_end,'') rua,
			ISNULL(Bairro,'') Bairro,
			ISNULL(REPLACE(CEP,'-',''),'') CEP,
			ISNULL(Cidade,'') Cidade,
			ISNULL(UF,'') UF			
		FROM boleto B (NOLOCK)
			INNER JOIN usuario U (NOLOCK) ON U.cd_usuario = B.cd_usuario
			INNER JOIN pessoa P (NOLOCK)  ON P.cd_pes = B.cd_pes
			LEFT JOIN endereco E (NOLOCK) ON E.cd_pes = B.cd_pes AND cd_tp_end = 'COM'
			INNER JOIN fatura F (NOLOCK)  ON F.fatcod = B.fatcod
		WHERE 
	--		cd_boleto = 07260002
			dt_emissao_txt IS NULL
			and B.cd_banco = '341'

	
		UNION ALL
	
		SELECT
			B.FatCod + ' TX: ' + ISNULL(CONVERT(VARCHAR,[dbo].[fBusca_CampoCliente](LEFT(B.FatCod,16),31)),'') Fatura,
			dt_boleto,
			nome_usuario solicitante,
			P.nome_raz_soc cliente,
			cd_boleto referente ,
			valor,
			Vencimento Vencimento,
			inscricao_numero,
			REPLICATE('0', 4 - LEN(agencia_cedente)) + RTRIM(agencia_cedente)  as agencia_cedente,
			conta_cedente,
			cd_instrucao_01,
			cd_instrucao_02,
			P.num_cpf_cnpj,		
			ISNULL(NF.Endereco,'') + ',' + ISNULL(NF.Numero,'') + ISNULL(E.Compl_End,'') rua,
			ISNULL(NF.Bairro,'') Bairro,
			ISNULL(REPLACE(NF.CEP,'-',''),'') CEP,
			ISNULL(NF.Cidade,'') Cidade,
			ISNULL(NF.UF,'') UF			
		FROM boleto B (NOLOCK)
			INNER JOIN usuario U (NOLOCK) ON U.cd_usuario = B.cd_usuario
			INNER JOIN  pessoa P (NOLOCK) ON P.cd_pes = B.cd_pes
			LEFT JOIN endereco E (NOLOCK) ON E.cd_pes = B.cd_pes AND cd_tp_end = 'COM'
			INNER JOIN  NF_Fatura NF (NOLOCK) ON NF.Numero_Fat = B.fatcod
		where 
			dt_emissao_txt IS NULL
			and B.cd_banco = '341'
		ORDER BY 5



	END

ELSE IF @Layout = 'Remessa Santander - 400 Posições'
	BEGIN
		SELECT  
		--B.FatCod + ' TX ' + ISNULL(CONVERT(VARCHAR,[dbo].[fBusca_CampoCliente](LEFT(B.FatCod,16),31)),'') Fatura, 
		B.FatCod  Fatura,  
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
		DBO.FRemoveCaracteresEspeciais(ISNULL(Rua,'') + ',' + ISNULL(numero,'') + ISNULL(compl_end,'')) rua,  
		DBO.FRemoveCaracteresEspeciais(ISNULL(Bairro,'')) Bairro,  
		DBO.FRemoveCaracteresEspeciais(ISNULL(REPLACE(CEP,'-',''),'')) CEP,  
		DBO.FRemoveCaracteresEspeciais(ISNULL(Cidade,'')) Cidade,  
		DBO.FRemoveCaracteresEspeciais(ISNULL(UF,'')) UF     
		FROM boleto B (NOLOCK)
			INNER JOIN usuario U ON U.cd_usuario = B.cd_usuario
			INNER JOIN pessoa P  (NOLOCK) ON P.cd_pes = B.cd_pes  
			LEFT JOIN endereco E (NOLOCK) ON E.cd_pes = B.cd_pes AND cd_tp_end = 'COM'  
			INNER JOIN  fatura F  (NOLOCK) ON F.fatcod = B.fatcod  
		WHERE   
			--  cd_boleto = 07260002  
			dt_emissao_txt IS NULL  
			--OR dt_emissao_txt >= GETDATE()-5
			and B.cd_banco = '033'
  
   
		UNION ALL  
   
		SELECT  
		--B.FatCod + ' TX ' + ISNULL(CONVERT(VARCHAR,[dbo].[fBusca_CampoCliente](LEFT(B.FatCod,16),31)),'') Fatura, 
		B.FatCod  Fatura,  
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
		--ALessandra 22/03/2022 - verificar com o Anderson e cadu se posso pegar direto da tabela endereço ou se pego da tabela de fatura
		DBO.FRemoveCaracteresEspeciais(ISNULL(E.Rua,'') + ',' + ISNULL(E.Numero,'') + ISNULL(E.Compl_End,'')) rua,  
		DBO.FRemoveCaracteresEspeciais(ISNULL(E.Bairro,'')) Bairro,  
		DBO.FRemoveCaracteresEspeciais(ISNULL(REPLACE(E.CEP,'-',''),'')) CEP,  
		DBO.FRemoveCaracteresEspeciais(ISNULL(E.Cidade,'')) Cidade,  
		DBO.FRemoveCaracteresEspeciais(ISNULL(E.UF,'')) UF     
		FROM boleto B  (NOLOCK)
			INNER JOIN  usuario U (NOLOCK) ON U.cd_usuario = B.cd_usuario  
			INNER JOIN  pessoa P (NOLOCK) ON P.cd_pes = B.cd_pes  
			LEFT JOIN endereco E (NOLOCK) ON E.cd_pes = B.cd_pes AND cd_tp_end = 'COM'  
			INNER JOIN  NF_Fatura NF (NOLOCK) ON NF.Numero_Fat = B.fatcod  
		where   
			dt_emissao_txt IS NULL   
			--OR dt_emissao_txt >= GETDATE()-5
			and B.cd_banco = '033'
		order by 5  

	END



		

GO
