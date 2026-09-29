SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
[spATL_Boleto_GeraBoleto_Sel]  'Remessa Itaú - 400 Posições'
GO
[spATL_Boleto_GeraBoleto_Sel] 'Remessa Santander - 400 Posições'
Payer, JOB, ID Boleto, Valor
[spATL_Boleto_GeraBoleto_Sel] ''
*/

CREATE PROCEDURE [dbo].[spATL_Boleto_GeraBoleto_Sel]
(
	@Cd_usuario			VARCHAR(6),
	@Tipo char(1)
)
	
AS

if @Tipo = 'A' or  @Tipo = 'B'
	Begin
		SELECT Distinct
			id_remessa										AS [ID_REMESSA]

			,SUBSTRING(remessa_detail_line,235,40)			AS [Payer Complete Name]
			,P.Apelido										AS [Payer Short Name]
			,(Case when left(B.FatCod,1) = '9' then [JOB] else left(B.FatCod,16)  end) AS [JOB]			
			,SUBSTRING(remessa_detail_line,63,7)			AS [Nosso número]				-- Nosso número
			,SUBSTRING(remessa_detail_line,70,1)			AS [Digito]						-- Digito
			,B.Dt_Boleto									AS [Register Date]
			,ISNULL(F.FatDtVenc,NF.[Due Date])				AS [Due Date]					-- Due Date
			,valor			AS [Value]			-- Value


			--ASSIGNOR DETAILS (DADOS DO CEDENTE)
			,SUBSTRING(remessa_detail_line,4,14)			AS [Assignor CNPJ]
			,PCED.Nome_Raz_Soc								AS [Assignor Complete Name]
			,SUBSTRING(remessa_detail_line,140,3)			AS [Bank Code]			
			,SUBSTRING(remessa_detail_line,18,4)			AS [Agency]				
			,'13000382'										AS [Account]		
			,'9'											AS [Account Digit]
			,SUBSTRING(remessa_detail_line,22,8)			AS [Assignor Code]				
			,'101'											AS [Billing Code]

			--Payer (SACADO)
			--,SUBSTRING(remessa_detail_line,235,40)			AS [Payer Complete Name]
			--,P.Apelido										AS [Payer Short Name]
			,SUBSTRING(remessa_detail_line,221,14)			AS [Payer CNPJ]
			,P.NUM_RG_IE									AS [Payer IE]
			,ISNULL(E.Rua,'')								AS [Payer Address]
			,ISNULL(E.numero,'')							AS [Payer Number] 
			,ISNULL(E.Bairro,'')							AS [Payer Neighbourhood]
			,ISNULL(E.Cidade,'')							AS [Payer City]
			,ISNULL(E.UF,'')								AS [Payer ST]  
			,ISNULL(REPLACE(E.CEP,'-',''),'')				AS [Payer ZIP Code] 
			,ISNULL(compl_end,'')							AS [Payer Complement]

			--,SUBSTRING(remessa_detail_line,275,40)			AS [Pagador Endereço]
			----,SUBSTRING(remessa_detail_line,315,14)												AS [Pagador Número]
			--,SUBSTRING(remessa_detail_line,315,12)			AS [Pagador Bairro]
			--,SUBSTRING(remessa_detail_line,335,15)			AS [Pagador Cidade]
			--,SUBSTRING(remessa_detail_line,350,2)			AS [Pagador UF]
			--,SUBSTRING(remessa_detail_line,327,8)			AS [Pagador Cep]

			-- DADOS DO BOLETO
			,SUBSTRING(remessa_detail_line,148,2)			AS [Currency Type]
			,'01'											AS [Quantity]
			,SUBSTRING(remessa_detail_line,108,1)			AS [Billing Code]				-- Billing Code
			--,SUBSTRING(remessa_detail_line,63,7)			AS [Nosso número]				-- Nosso número
			--,SUBSTRING(remessa_detail_line,70,1)			AS [Digito]						-- Digito
			,SUBSTRING(remessa_detail_line,111,10)			AS [Número do Documento]		
			----,SUBSTRING(remessa_detail_line,121,6)			AS [Due Date]					-- Due Date
			--,ISNULL(F.FatDtVenc,NF.[Due Date])			AS [Due Date]					-- Due Date
			----,dt_Boleto
			----,SUBSTRING(remessa_detail_line,127,13)			AS [Value]			-- Value
			--,valor			AS [Value]			-- Value

			,SUBSTRING(remessa_detail_line,157,2)			AS [Instruction Code 01]
			,BIC01.nome_instrucao							AS [Instruction Description 01]

			,SUBSTRING(remessa_detail_line,159,2)			AS [Instruction Code 02]
			,BIC02.nome_instrucao							AS [Instruction Description 02]
			--,remessa_detail_line

			--,(Case when left(B.FatCod,1) = '9' then [JOB] else left(B.FatCod,16)  end) AS [JOB],
			--,left(B.FatCod,16) AS [JOB],
			--,B.Dt_Boleto [Register Date]
			,RB.cd_boleto [ID Boleto]
		FROM remessa_boleto RB (NOLOCK)
			INNER JOIN boleto B (NOLOCK) ON RB.cd_boleto = B.cd_boleto 
			INNER JOIN pessoa P (NOLOCK) ON b.cd_pes = P.cd_pes 
			LEFT OUTER JOIN PESSOA PCED  ON PCED.CD_PES = '10017'
			LEFT JOIN endereco E  (NOLOCK)	ON E.cd_pes = P.cd_pes 	AND E.cd_tp_end = 'COM'
			LEFT JOIN fatura F (NOLOCK)		ON F.fatcod = B.fatcod			
			--LEFT JOIN NF_Fatura NF (NOLOCK) ON NF.Numero_Fat = B.fatcod
			LEFT JOIN vwNF_Fatura_Sel NF (NOLOCK) ON NF.[Invoice Number] = B.fatcod			
			LEFT JOIN Boleto_Instrucao_Cobranca BIC01 (NOLOCK)	ON BIC01.cd_instrucao = B.cd_instrucao_01 AND BIC01.cd_banco  = B.cd_banco
			LEFT JOIN Boleto_Instrucao_Cobranca BIC02 (NOLOCK)	ON BIC02.cd_instrucao = B.cd_instrucao_02 AND BIC02.cd_banco  = B.cd_banco
		ORDER BY 
			id_remessa desc
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		SELECT Distinct
			id_remessa										AS [ID_REMESSA]

			,SUBSTRING(remessa_detail_line,235,40)			AS [Payer Complete Name]
			,P.Apelido										AS [Payer Short Name]
			,(Case when left(B.FatCod,1) = '9' then [JOB] else left(B.FatCod,16)  end) AS [JOB]			
			,SUBSTRING(remessa_detail_line,63,7)			AS [Nosso número]				-- Nosso número
			,SUBSTRING(remessa_detail_line,70,1)			AS [Digito]						-- Digito
			,B.Dt_Boleto									AS [Register Date]
			,ISNULL(F.FatDtVenc,NF.[Due Date])				AS [Due Date]					-- Due Date
			,valor			AS [Value]			-- Value


			--ASSIGNOR DETAILS (DADOS DO CEDENTE)
			,SUBSTRING(remessa_detail_line,4,14)			AS [Assignor CNPJ]
			,PCED.Nome_Raz_Soc								AS [Assignor Complete Name]
			,SUBSTRING(remessa_detail_line,140,3)			AS [Bank Code]			
			,SUBSTRING(remessa_detail_line,18,4)			AS [Agency]				
			,'13000382'										AS [Account]		
			,'9'											AS [Account Digit]
			,SUBSTRING(remessa_detail_line,22,8)			AS [Assignor Code]				
			,'101'											AS [Billing Code]

			--Payer (SACADO)
			--,SUBSTRING(remessa_detail_line,235,40)			AS [Payer Complete Name]
			--,P.Apelido										AS [Payer Short Name]
			,SUBSTRING(remessa_detail_line,221,14)			AS [Payer CNPJ]
			,P.NUM_RG_IE									AS [Payer IE]
			,ISNULL(E.Rua,'')								AS [Payer Address]
			,ISNULL(E.numero,'')							AS [Payer Number] 
			,ISNULL(E.Bairro,'')							AS [Payer Neighbourhood]
			,ISNULL(E.Cidade,'')							AS [Payer City]
			,ISNULL(E.UF,'')								AS [Payer ST]  
			,ISNULL(REPLACE(E.CEP,'-',''),'')				AS [Payer ZIP Code] 
			,ISNULL(compl_end,'')							AS [Payer Complement]

			--,SUBSTRING(remessa_detail_line,275,40)			AS [Pagador Endereço]
			----,SUBSTRING(remessa_detail_line,315,14)												AS [Pagador Número]
			--,SUBSTRING(remessa_detail_line,315,12)			AS [Pagador Bairro]
			--,SUBSTRING(remessa_detail_line,335,15)			AS [Pagador Cidade]
			--,SUBSTRING(remessa_detail_line,350,2)			AS [Pagador UF]
			--,SUBSTRING(remessa_detail_line,327,8)			AS [Pagador Cep]

			-- DADOS DO BOLETO
			,SUBSTRING(remessa_detail_line,148,2)			AS [Currency Type]
			,'01'											AS [Quantity]
			,SUBSTRING(remessa_detail_line,108,1)			AS [Billing Code]				-- Billing Code
			--,SUBSTRING(remessa_detail_line,63,7)			AS [Nosso número]				-- Nosso número
			--,SUBSTRING(remessa_detail_line,70,1)			AS [Digito]						-- Digito
			,SUBSTRING(remessa_detail_line,111,10)			AS [Número do Documento]		
			----,SUBSTRING(remessa_detail_line,121,6)			AS [Due Date]					-- Due Date
			--,ISNULL(F.FatDtVenc,NF.[Due Date])			AS [Due Date]					-- Due Date
			----,dt_Boleto
			----,SUBSTRING(remessa_detail_line,127,13)			AS [Value]			-- Value
			--,valor			AS [Value]			-- Value

			,SUBSTRING(remessa_detail_line,157,2)			AS [Instruction Code 01]
			,BIC01.nome_instrucao							AS [Instruction Description 01]

			,SUBSTRING(remessa_detail_line,159,2)			AS [Instruction Code 02]
			,BIC02.nome_instrucao							AS [Instruction Description 02]
			--,remessa_detail_line

			--,(Case when left(B.FatCod,1) = '9' then [JOB] else left(B.FatCod,16)  end) AS [JOB],
			--,left(B.FatCod,16) AS [JOB],
			--,B.Dt_Boleto [Register Date]
			,RB.cd_boleto [ID Boleto]
		FROM remessa_boleto RB (NOLOCK)
			INNER JOIN boleto B (NOLOCK) ON RB.cd_boleto = B.cd_boleto 
			INNER JOIN pessoa P (NOLOCK) ON b.cd_pes = P.cd_pes 
			LEFT OUTER JOIN PESSOA PCED  ON PCED.CD_PES = '10017'
			LEFT JOIN endereco E  (NOLOCK)	ON E.cd_pes = P.cd_pes 	AND E.cd_tp_end = 'COM'
			LEFT JOIN fatura F (NOLOCK)		ON F.fatcod = B.fatcod			
			--LEFT JOIN NF_Fatura NF (NOLOCK) ON NF.Numero_Fat = B.fatcod
			LEFT JOIN vwNF_Fatura_Sel NF (NOLOCK) ON NF.[Invoice Number] = B.fatcod			
			LEFT JOIN Boleto_Instrucao_Cobranca BIC01 (NOLOCK)	ON BIC01.cd_instrucao = B.cd_instrucao_01 AND BIC01.cd_banco  = B.cd_banco
			LEFT JOIN Boleto_Instrucao_Cobranca BIC02 (NOLOCK)	ON BIC02.cd_instrucao = B.cd_instrucao_02 AND BIC02.cd_banco  = B.cd_banco
		Where
			B.Cd_usuario = @Cd_usuario
		ORDER BY 
			id_remessa desc
	End

		

GO
