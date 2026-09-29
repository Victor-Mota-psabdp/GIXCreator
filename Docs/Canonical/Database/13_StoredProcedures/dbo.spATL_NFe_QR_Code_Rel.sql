SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select RPS_NFE,dt_Protocolo,* from Base_Nota_Fiscal where Ref_Acesso = 'I' AND EMISSAO> GETDATE() -260
--and RPS_NFE is null order by Nota_Fiscal
--[spATL_NFe_QR_Code_Rel]'77642','I'
CREATE procedure [dbo].[spATL_NFe_QR_Code_Rel]--''77642'
	@NF			varchar(10),
	@Ref_Acesso	varchar(1)
as

SET NOCOUNT ON

Declare @Nota Table
	(
		Numero						Varchar(10),	
		Serie						Varchar(1),	
		Tipo						Varchar(1),	
		DataEmissao					Varchar(25),						
		NaturezaOperacao			Varchar(1),	
		RegimeEspecialTributacao	Varchar(1),	
		OptanteSimplesNacional		Varchar(1),	
		IncentivadorCultural		Varchar(1),	
		[Status]					Varchar(1),		
		ValorServicos				decimal(10,2),
		ValorPis					decimal(10,2),	
		ValorCofins					decimal(10,2),	
		ValorInss					decimal(10,2),	
		ValorIr						decimal(10,2),
		ValorCsll					decimal(10,2),	
		IssRetido					int,					
		ValorIssRetido				decimal(10,2),	
		ValorIss					decimal(10,2),
		BaseCalculo					decimal(10,2),
		Aliquota					decimal(10,3),
		ValorLiquidoNfse				decimal(10,2),	
		ItemListaServico				Varchar(10),		
		CodigoCnae						Varchar(10),
		CodigoTributacaoMunicipio		Varchar(10),
		
		DescricaoServico				Varchar(500),
			
		CodigoMunicipio					Varchar(10),
		
		
		Discriminacao					Varchar(MAX),
		MunicipioPrestacaoServico		Varchar(10),	
		Cnpj							Varchar(25),
		InscricaoMunicipal				Varchar(25),	
		CpfCnpj							Varchar(25),	
		CpfInscricaoMunicipal			Varchar(25),	
		RazaoSocial						Varchar(60),
		Endereco						Varchar(100),	
		NumeroEnd						Varchar(25),
		Complemento						Varchar(25),	
		Bairro							Varchar(50),
		Cidade							Varchar(50),
		CodigoMunicipioE				Varchar(10),
		CodigoMunicipioEnd				Varchar(10),	
		Uf								Varchar(10),
		Estado							Varchar(50),
		Cep								Varchar(25),
		Telefone						Varchar(25),	
		Email							Varchar(50),
		Ref_Acesso						varchar(1),
		ValorCargaTributaria			decimal(10,2),
		Pais							varchar(100),
		
		--prestador
		PrefeituraPrestador				varchar(500),
		RazaoSocialPrestador			Varchar(60),
		EnderecoPrestador				Varchar(100),	
		NumeroEndPrestador				Varchar(25),
		ComplementoPrestador			Varchar(25),	
		BairroPrestador					Varchar(50),
		CidadePrestador					Varchar(50),
		CodigoMunicipioEPrestador		Varchar(10),
		CodigoMunicipioEndPrestador		Varchar(10),	
		UfPrestador						Varchar(10),
		EstadoPrestador					Varchar(50),
		CepPrestador					Varchar(25),
		TelefonePrestador				Varchar(25),	
		EmailPrestador					Varchar(50),	
		Ginfes							Varchar(50)
			
	)
	
IF @Ref_Acesso = 'I'
	BEGIN	
		insert into @Nota	
			select distinct
				--[IdentificacaoRps]					
					BNF.Nota_Fiscal [Numero], 
					'1' [Serie], 
					'1' [Tipo], 
				--[IdentificacaoRps]
			
				convert(varchar(10), BNF.Emissao,120)+ 'T00:00:00' [DataEmissao],
				'1' [NaturezaOperacao], 
				'1' [RegimeEspecialTributacao], --NO 
				'2' [OptanteSimplesNacional], --MO
				'2' [IncentivadorCultural],--NO
				
				(case when BNF.cd_status = 0 then
					1 else 
				BNF.cd_status end)[Status],
				
				--[Servico]
					--[Valores]				
						isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total)),'0.00') [ValorServicos],
						
						--[ValorPis],
						
						-- PIS -  Alíquotas  0,65% se o valor das notas emitidas no dia atingir R$ 215,17
							(case when BNF.Item_lei = '33.01' and BNF.Valor_Total > 215.17 
										--and TE.Cidade <> 'SANTOS' 
										and (T.num_cpf_cnpj is not null) then
								isnull(convert(varchar,convert(decimal(10,2),.0065*BNF.Valor_Total)),'0.00')
								else '0.00' end) [ValorPis],
					
						--[ValorCofins],
						-- COFINS - Alíquota 3% se o valor das notas emitidas no dia atingir R$ 215,17
							(case when BNF.Item_lei = '33.01'  and BNF.Valor_Total > 215.17 
									--and TE.Cidade <> 'SANTOS' 
									and (T.num_cpf_cnpj is not null) then
								isnull(convert(varchar,convert(decimal(10,2),.03* BNF.Valor_Total)),'0.00')
								else '0.00' end) [ValorCofins],
							
							--[ValorInss], 
							--- INSS -  não preenche											
							'0.00' [ValorInss], 
						
							--[ValorIr],				
							--- IR - 1,5% se o valor das notas emitidas no dia atingir R$ 666,67
							(case when BNF.Item_lei = '33.01'  and BNF.Valor_Total > 666.67 
										--and TE.Cidade <> 'SANTOS' 
										and (T.num_cpf_cnpj is not null) then 
								isnull(convert(varchar,convert(decimal(10,2),.015* BNF.Valor_Total)),'0.00')
							else (case when BNF.IRRF_Tx= 'S' then
								isnull(convert(varchar,convert(decimal(10,2),.015* BNF.Valor_Total)),'0.00')
								else '0.00' end)end) [ValorIr], 
							 
							 
							 --[ValorCsll],
							 --- CSLL - Alíquota 1% se se se o valor das notas emitidas no dia atingir R$ 215,17
							 (case when BNF.Item_lei = '33.01'  and BNF.Valor_Total > 215.17 
								--and TE.Cidade <> 'SANTOS' 
								and (T.num_cpf_cnpj is not null) then 
								isnull(convert(varchar,convert(decimal(10,2),.01* BNF.Valor_Total)),'0.00')
								else '0.00' end) [ValorCsll],
						
						(case when TE.Cidade = 'SANTOS' then 
						'1' else '2' end)[IssRetido],--1 SIM | 2 Não
						
						
						(case when TE.Cidade = 'SANTOS' then 
							isnull(convert(varchar,convert(decimal(10,2),.03* BNF.Valor_Total)),'0.00')
							else '0.00' end)[ValorIssRetido],
						
						--isnull(convert(varchar,convert(decimal(10,2),.03* BNF.Valor_Total)),'0.00') [ValorIssRetido],
						
						isnull(convert(varchar,convert(decimal(10,2),.03* BNF.Valor_Total)),'0.00') [ValorIss],
						
						isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total)),'0.00') [BaseCalculo],				
						'0.03' [Aliquota],
						
						(case when TE.Cidade = 'SANTOS' then 
							isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total) - convert(decimal(10,2),.03* BNF.Valor_Total)),'0.00')
							--isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total)),'0.00') - isnull(convert(varchar,convert(decimal(10,2),.03* BNF.Valor_Total)),'0.00')
						else
							isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total)),'0.00')
						end)	[ValorLiquidoNfse],
						--isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total)),'0.00') [ValorLiquidoNfse],
						--isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total - ((.0065+.03+.01+.05)*BNF.Valor_Total))),'0.00') [ValorLiquidoNfse],
					--[Valores]
					
					--replace(BNF.Item_lei,'.','')		[ItemListaServico], 
					--replace(BNF.CNAE,'.','')			[CodigoCnae], 
					--replace(BNF.cd_servico,'.','')		[CodigoTributacaoMunicipio],
					
					BNF.Item_lei		[ItemListaServico], 
					BNF.CNAE			[CodigoCnae], 
					BNF.cd_servico		[CodigoTributacaoMunicipio],
					
					TNF.Descricao		[DescricaoServico],
					
					'3548500'							[CodigoMunicipio],
				
					
					--qdo o endereco eh de fora, só deve ir o iss
					(case when T.num_cpf_cnpj = '' OR T.num_cpf_cnpj IS NULL then
						[dbo].[FRemoveAcentuacao]([dbo].[fBusca_spRPSSTS](BNF.Nota_Fiscal,BNF.Ref_Acesso)) +
						' | Conforme Lei 12.741/2012: ISS 3% R$ ' +  
						isnull(convert(varchar,convert(decimal(10,2),.03* BNF.Valor_Total)),'0.00') + 
						',  PIS 1,65% R$ ' + '0.00' +
						' e Confins 7,6% R$ ' + '0.00'
					else
						[dbo].[FRemoveAcentuacao]([dbo].[fBusca_spRPSSTS](BNF.Nota_Fiscal,BNF.Ref_Acesso)) +
						' | Conforme Lei 12.741/2012: ISS 3% R$ ' +  
						isnull(convert(varchar,convert(decimal(10,2),.03* BNF.Valor_Total)),'0.00') + 
						',  PIS 1,65% R$ ' + 
						isnull(convert(varchar,convert(decimal(10,2),.0165*BNF.Valor_Total)),'0.00') +
						' e Confins 7,6% R$ ' + 
						isnull(convert(varchar,convert(decimal(10,2),.076* BNF.Valor_Total)),'0.00')					
					end)[Discriminacao],
								
						'' [MunicipioPrestacaoServico], --NO				
					
				--[Servico]
				--[Prestador]
					'03706460000209'		[Cnpj],
					'1366280'				[InscricaoMunicipal],
				--[Prestador]
				--[Tomador]
					--[IdentificaçãoTomador]
						--[CpfCnpj]
							--(CASE WHEN T.num_cpf_cnpj = '' then '00000000000000' else T.num_cpf_cnpj end) [CpfCnpj],
							T.num_cpf_cnpj [CpfCnpj],
						--[CpfCnpj]
						(CASE WHEN NUM_Insc_Munic = '' OR NUM_Insc_Munic IS NULL THEN '' ELSE replace(NUM_Insc_Munic,'.','') END) [CpfInscricaoMunicipal],
					--[IdentificaçãoTomador]
					[dbo].[FRemoveAcentuacao](T.nome_raz_soc) [RazaoSocial], 
					--[Endereco]
						TE.Rua		[Endereco],
						(case when (TE.numero = '' or TE.numero is null) then 'S/N' else TE.numero end)  [Numero],
						--TE.numero	[Numero],
						TE.Compl_End	[Complemento],
						(case when TE.bairro = '' OR TE.bairro IS null then
							'Nao Informado' else
							TE.bairro
						End)	[Bairro],
						--TE.bairro	[Bairro],
						TE.Cidade	[Cidade],
						TE.Cod_IBGE [CodigoMunicipio],
						--CMN.STR_CODIGOMUN_IBGE [CodigoMunicipioEnd],
						I.UF + I.Cod_IBGE [CodigoMunicipioEnd],
						TE.UF		[Uf], 
						TE.UF		[Estado],
						right('00000000000' + replace(TE.CEP,'-',''),8)		[Cep],
					--[Endereco]
					--[Contato]
						--(CO.cd_area_fone + CO.Prefixo + CO.num_fone) [Telefone],
						right('00000000000' + replace(replace(isnull((CO.cd_area_fone + CO.Prefixo + CO.num_fone),'00000000'),'.',''),'-',''),11) [Telefone],
					--[Contato]	
					--[Email]
						co.Compl_Fone [Email],
					--[Contato]		
				 --[Tomador]
				 BNF.Ref_Acesso,			 			
				'0.00' ValorCargaTributaria,
				--isnull(TE.Pais,'')	Pais,
				isnull(P.Nome_Pais, TE.Pais)	Pais,
				
				
				--prestado
					'PREFEITURA MUNICIPAL DE SANTOS'	PrefeituraPrestador,
					'BDP SOUTH AMERICA LTDA'			RazaoSocialPrestador,
					'AVENIDA SENADOR FEIJÓ'				EnderecoPrestador,
					'26'							    NumeroEndPrestador,
					'0000'								ComplementoPrestador,	
					'CENTRO '							BairroPrestador,
					'SANTOS'							CidadePrestador,
					''									CodigoMunicipioEPrestador,
					''									CodigoMunicipioEndPrestador,	
					'SP'								UfPrestador,
					'São Paulo'							EstadoPrestador,
					'11015-500'							CepPrestador,
					'(11)5504-3400'						TelefonePrestador,
					'andreia.tiesi@bdpint.com'			EmailPrestador,
					'santos.ginfes.com.br'				ginfes
			from 
				base_nota_fiscal BNF with(nolock) 
				join pessoa T with(nolock)  on T.cd_pes = BNF.cd_pes 
				left join endereco TE with(nolock)  on TE.cd_pes = T.cd_pes and TE.cd_tp_end = 'COM'
				left join comunicacao CO with(nolock)  on CO.cd_pes = T.cd_pes and Co.cd_tp_com ='NF1'
				Left join Pais P with(nolock) on P.cd_pais = TE.CD_pais
				--left join IBGE_Municipios_BR I with(nolock)  on I.Nome_Município = TE.cidade and I.UF_Descr_Red = TE.UF
				left join vwATL_IBGE_Municipios_BR I with(nolock) on I.Nome_Município = TE.cidade and I.UF_Descr_Red = TE.UF
				--join atl_web.dbo.CAD_UF_NF CUN on CUN.str_SiglaUF   COLLATE Latin1_General_CI_AI = TE.UF
				--join atl_web.dbo.cad_mun_nf CMN on CMN.str_nomemun  COLLATE Latin1_General_CI_AI = TE.cidade and CUN.str_CodigoUF_IBGE = CMN.str_CodigoUF_IBGE		
				left join Tipo_NF_Doc_Register TNF with(nolock)  on TNF.Item_lei = BNF.Item_lei
							and  TNF.cd_servico = BNF.cd_servico
				
			where
				BNF.Ref_Acesso = 'I' 			
				and BNF.Cd_Status <> 2 
				--and BNF.RPS_Envio <> 1			
				--and ((emissao between @dtInicial and @dtFinal) OR 
				and BNF.Nota_Fiscal = @NF
		END
	
IF @Ref_Acesso = 'K'
	BEGIN   
		INSERT INTO @Nota   
			  SELECT DISTINCT  
				  -- [IdentificacaoRps]       
				  BNF.Nota_Fiscal           [Numero]   
				  ,'1'             [Serie]  
				  ,'1'             [Tipo]   
				  -- [IdentificacaoRps]  
				    
				  ,CONVERT(VARCHAR(10), BNF.Emissao,120)+ 'T00:00:00'  [DataEmissao]  
				  ,'1'             [NaturezaOperacao]   
				  ,'1'             [RegimeEspecialTributacao] --NO   
				  ,'2'             [OptanteSimplesNaciONal] --MO  
				  ,'2'             [IncentivadorCultural]--NO  
				     
				  ,(CASE WHEN BNF.cd_status = 0 THEN   
				   1   
				  ELSE   
				   BNF.cd_status   
				  END)             [Status]  
				     
				  -- [Servico]  
				  -- [Valores]      
				  ,ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),BNF.Valor_Total)),'0.00') [ValorServicos]  
				       
				  -- [ValorPis],     
				  -- PIS -  Alíquotas  0,65% se o valor das notas emitidas no dia atingir R$ 215,17  
				  ,(CASE WHEN BNF.Item_lei = '33.01' AND BNF.Valor_Total > 215.17  AND (T.num_cpf_cnpj IS NOT NULL) THEN   
				   ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.0065*BNF.Valor_Total)),'0.00')  
				  ELSE   
				   '0.00'   
				  END)             [ValorPis]  
				      
				  -- [ValorCofins],  
				  -- COFINS - Alíquota 3% se o valor das notas emitidas no dia atingir R$ 215,17  
				  ,(CASE WHEN BNF.Item_lei = '33.01' AND BNF.Valor_Total > 215.17 AND (T.num_cpf_cnpj IS NOT NULL) THEN   
				   ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.03* BNF.Valor_Total)),'0.00')  
				  ELSE   
				   '0.00'   
				  END)             [ValorCofins]  
				        
				  -- [ValorInss],   
				  -- INSS -  não preenche             
				  ,'0.00' [ValorInss]   
				       
				  -- [ValorIr],      
				  -- IR - 1,5% se o valor das notas emitidas no dia atingir R$ 666,67  
				  ,(CASE WHEN BNF.Item_lei in ('33.01','10.05') AND BNF.Valor_Total > 666.67 AND (T.num_cpf_cnpj IS NOT NULL) THEN   
				   ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.015* BNF.Valor_Total)),'0.00')  
				  ELSE   
				   (CASE WHEN BNF.IRRF_Tx= 'S' THEN   
					ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.015* BNF.Valor_Total)),'0.00')  
				   ELSE   
					'0.00'   
				   END)  
				  END)             [ValorIr]   
				         
				         
				  -- [ValorCsll],  
				  -- CSLL - Alíquota 1% se se se o valor das notas emitidas no dia atingir R$ 215,17  
				  ,(CASE WHEN BNF.Item_lei = '33.01'  AND BNF.Valor_Total > 215.17 AND (T.num_cpf_cnpj IS NOT NULL) THEN   
				   ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.01* BNF.Valor_Total)),'0.00')  
				  ELSE   
				   '0.00'   
				  END)             [ValorCsll]  
				     
				  --[IssRetido]  
				  ,(CASE WHEN TE.Cidade = 'São Caetano do Sul' THEN  
				   '1'   
				  ELSE   
				   '2'   
				  END)             [IssRetido]--1 SIM | 2 Não  
				      
				  ,(CASE WHEN TE.Cidade = 'São Caetano do Sul' THEN   
				   --ALESSANDRA 04/05/2020 - Conforme e-mail assunto "RES: RES: RES: RES: RES: RES: BDP Brazil legal rep authorization and duration" para a taxa item lei "10.05" considerar a taxa de ISS é 2,5%   
				   (CASE WHEN BNF.Item_lei = '10.05' THEN  
					ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.025* BNF.Valor_Total)),'0.00')  
				   ELSE  
					ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.02* BNF.Valor_Total)),'0.00')  
				   END)  
				  ELSE   
				   '0.00'   
				  END)                    [ValorIssRetido]  
				       
				  
				  --ALESSANDRA 04/05/2020 - Conforme e-mail assunto "RES: RES: RES: RES: RES: RES: BDP Brazil legal rep authorization and duration" para a taxa item lei "10.05" considerar a taxa de ISS é 2,5%   
				  ,(CASE WHEN BNF.Item_lei = '10.05' THEN  
				   ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.025* BNF.Valor_Total)),'0.00')  
				  ELSE  
				   ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.02* BNF.Valor_Total)),'0.00')   
				  END)                    [ValorIss]  
				       
				  ,ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),BNF.Valor_Total)),'0.00')    [BaseCalculo]     
				       
				  --ALESSANDRA 04/05/2020 - CONforme e-mail assunto "RES: RES: RES: RES: RES: RES: BDP Brazil legal rep authorizatiON AND duratiON" para a taxa item lei "10.05" cONsiderar a taxa de ISS é 2,5%   
				  ,CONVERT(VARCHAR,CONVERT(DECIMAL(5,3),(CASE WHEN BNF.Item_lei = '10.05' THEN  
				   '0.025'   
				  ELSE  
				   '0.02'   
				  END)))                    [Aliquota]  
				        
				  ,(CASE WHEN TE.Cidade = 'São Caetano do Sul' THEN   
				   --ALESSANDRA 04/05/2020 - Conforme e-mail assunto "RES: RES: RES: RES: RES: RES: BDP Brazil legal rep authorization and duration" para a taxa item lei "10.05" considerar a taxa de ISS é 2,5%   
				   (CASE WHEN BNF.Item_lei = '10.05' THEN  
					ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),BNF.Valor_Total) - CONVERT(DECIMAL(10,2),.025* BNF.Valor_Total)),'0.00')  
				   ELSE  
					ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),BNF.Valor_Total) - CONVERT(DECIMAL(10,2),.02* BNF.Valor_Total)),'0.00')  
				   END)  
				  ELSE  
				   ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),BNF.Valor_Total)),'0.00')  
				  END)                    [ValorLiquidoNfse]  
				  --[Valores]  
				  
				  --,replace(BNF.Item_lei,'.','')              [ItemListaServico]   
				  --,replace(BNF.CNAE,'.','')               [CodigoCnae]   
				  --,replace(BNF.cd_servico,'.','')              [CodigoTributacaoMunicipio]  
				  
				  ,BNF.Item_lei		[ItemListaServico], 
					BNF.CNAE			[CodigoCnae], 
					BNF.cd_servico		[CodigoTributacaoMunicipio],
						TNF.Descricao		[DescricaoServico],
					
				  '3548807'                   [CodigoMunicipio]  
				     
				  --qdo o Endereco eh de fora, só deve ir o iss  
				  ,(CASE WHEN T.num_cpf_cnpj = '' OR T.num_cpf_cnpj IS NULL THEN  
				   --ALESSANDRA 04/05/2020 - Conforme e-mail assunto "RES: RES: RES: RES: RES: RES: BDP Brazil legal rep authorization and duration" para a taxa item lei "10.05" considerar a taxa de ISS é 2,5%   
				   (CASE WHEN BNF.Item_lei = '10.05' THEN  
					[DBO].[FRemoveAcentuacao]([DBO].[fBusca_spRPSSCS](BNF.Nota_Fiscal,BNF.Ref_Acesso)) +  
					' | Conforme Lei 12.741/2012: ISS 2,5% R$ ' +    
					ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.025* BNF.Valor_Total)),'0.00') +   
					',  PIS 1,65% R$ ' + '0.00' +  
					' e Confins 7,6% R$ ' + '0.00'     
				   ELSE  
					[DBO].[FRemoveAcentuacao]([DBO].[fBusca_spRPSSCS](BNF.Nota_Fiscal,BNF.Ref_Acesso)) +  
					' | Conforme Lei 12.741/2012: ISS 2% R$ ' +    
					ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.02* BNF.Valor_Total)),'0.00') +   
					',  PIS 1,65% R$ ' + '0.00' +  
					' e Confins 7,6% R$ ' + '0.00'  
				   END)  
				  ELSE  
				   --ALESSANDRA 04/05/2020 - Conforme e-mail assunto "RES: RES: RES: RES: RES: RES: BDP Brazil legal rep authorization and duration" para a taxa item lei "10.05" considerar a taxa de ISS é 2,5%   
				   (CASE WHEN BNF.Item_lei = '10.05' THEN  
					[DBO].[FRemoveAcentuacao]([DBO].[fBusca_spRPSSCS](BNF.Nota_Fiscal,BNF.Ref_Acesso)) +  
					' | Conforme Lei 12.741/2012: ISS 2,5% R$ ' +    
					ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.025* BNF.Valor_Total)),'0.00') +   
					',  PIS 1,65% R$ ' +   
					ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.0165*BNF.Valor_Total)),'0.00') +  
					' e Confins 7,6% R$ ' +   
					ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.076* BNF.Valor_Total)),'0.00')  
				   ELSE  
					[DBO].[FRemoveAcentuacao]([DBO].[fBusca_spRPSSCS](BNF.Nota_Fiscal,BNF.Ref_Acesso)) +  
					' | Conforme Lei 12.741/2012: ISS 2% R$ ' +    
					ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.02* BNF.Valor_Total)),'0.00') +   
					',  PIS 1,65% R$ ' +   
					ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.0165*BNF.Valor_Total)),'0.00') +  
					' e Confins 7,6% R$ ' +   
					ISNULL(CONVERT(VARCHAR,CONVERT(DECIMAL(10,2),.076* BNF.Valor_Total)),'0.00')    
				   END)  
				  
				     
				  END)                    [Discriminacao]  
				         
				  ,
				  
				  ''   [MunicipioPrestacaoServico] --NO  
				  --[Servico]  
				  
				  --[Prestador]  
				  --,'03706460000985'                 [Cnpj]  
				  --,'112691'                   [InscricaoMunicipal]  
				  ,'03706460000128'                 [Cnpj]  
				  ,'113543'                   [InscricaoMunicipal]  


				  --[Prestador]  
				  
				  --[Tomador]  
				  --[IdentificaçãoTomador]  
				  --[CpfCnpj]    
				  ,T.num_cpf_cnpj [CpfCnpj]  
				  --[CpfCnpj]  
				  ,(CASE WHEN NUM_Insc_Munic = '' OR NUM_Insc_Munic IS NULL THEN   
				   ''   
				  ELSE   
				   replace(NUM_Insc_Munic,'.','')   
				  END)                    [CpfInscricaoMunicipal]  
				  --[IdentificaçãoTomador]  
				  ,[DBO].[FRemoveAcentuacao](T.nome_raz_soc)           [RazaoSocial]   
				  --[Endereco]  
				  ,TE.Rua                    [Endereco]  
				  ,(CASE WHEN (TE.numero = '' or TE.numero IS NULL) THEN 'S/N' ELSE TE.numero END) [Numero]  
				  ,TE.Compl_End                  [Complemento]  
				  ,(CASE WHEN TE.bairro = '' OR TE.bairro IS NULL THEN  
				   'Nao Informado'   
				  ELSE  
				   TE.bairro  
				  END)                    [Bairro]  
				  ,TE.Cidade                   [Cidade]  
				  ,TE.Cod_IBGE                  [CodigoMunicipio]  
				  ,I.UF + I.Cod_IBGE                 [CodigoMunicipioEnd]  
				  ,TE.UF                    [Uf]   
				  ,TE.UF                    [Estado]  
				  ,RIGHT('00000000000' + replace(TE.CEP,'-',''),8)         [Cep]  
				  --[Endereco]  
				  --[CONtato]  
				  --(CO.cd_area_fONe + CO.Prefixo + CO.num_fONe) [TelefONe],  
				  ,RIGHT('00000000000' + replace(replace(ISNULL((CO.cd_area_fone + CO.Prefixo + CO.num_fone),'00000000'),'.',''),'-',''),11) [Telefone]  
				  --[CONtato]   
				  --[Email]  
				  ,co.Compl_Fone                  [Email]  
				  --[CONtato]    
				  --[Tomador]  
				  ,BNF.Ref_Acesso                  Ref_Acesso        
				  ,'0.00'                    ValorCargaTributaria  
				  --,ISNULL(TE.Pais,'')                 Pais ,
				  ,isnull(P.Nome_Pais, TE.Pais)	Pais,
				  
				  --prestado
					'PREFEITURA MUNICIPAL DE SÃO CAETANO DO SUL'	PrefeituraPrestador,
					'BDP SOUTH AMERICA LTDA'			RazaoSocialPrestador,
					'RUA MANOEL COELHO'					EnderecoPrestador,
					'600'							    NumeroEndPrestador,
					'ESCR. 316 A'						ComplementoPrestador,	
					'CENTRO'							BairroPrestador,
					'SAO CAETANO DO SUL'				CidadePrestador,
					''									CodigoMunicipioEPrestador,
					''									CodigoMunicipioEndPrestador,	
					'SP'								UfPrestador,
					'São Paulo'							EstadoPrestador,
					'11015-500'							CepPrestador,
					'(11)5504-3413'						TelefonePrestador,
					'andreia.tiesi@bdpint.com'			EmailPrestador,
					 'saocaetano.ginfes.com.br'		ginfes
				 FROM   
				  base_nota_fiscal BNF  
				  INNER JOIN pessoa T (NOLOCK)  ON T.cd_pes = BNF.cd_pes   
				  LEFT JOIN Endereco TE (NOLOCK)   ON TE.cd_pes = T.cd_pes    AND TE.cd_tp_end = 'COM'  
				  LEFT JOIN comunicacao CO (NOLOCK)   ON CO.cd_pes = T.cd_pes    AND Co.cd_tp_com ='NF1' 
				  Left join Pais P with(nolock) on P.cd_pais = TE.CD_pais
				 -- LEFT JOIN IBGE_Municipios_BR I (NOLOCK)  ON I.Nome_Município = TE.cidade  AND I.UF_Descr_Red = TE.UF
				  left join vwATL_IBGE_Municipios_BR I with(nolock) on I.Nome_Município = TE.cidade and I.UF_Descr_Red = TE.UF
				   
				   left join Tipo_NF_Doc_Register TNF with(nolock)  on TNF.Item_lei = BNF.Item_lei and  TNF.cd_servico = BNF.cd_servico
				 WHERE  
				  BNF.Ref_Acesso = 'K'      
				  AND BNF.Cd_Status <> 2   
				  --AND BNF.RPS_Envio <> 1     
				  --AND ((emissao between @dtInicial AND @dtFinal) OR   
				  AND Nota_Fiscal = @NF  
	END  	
		
update 
	T  
set 
	[ValorLiquidoNfse] = [BaseCalculo] - [ValorCsll] - [ValorIr] - [ValorCofins]- [ValorPis] - [ValorIssRetido]
from 
	@Nota as T
--where
--	T.Cidade <> 'SANTOS'

--BEGIN	
--	 if not exists(select * from Base_Envio_LoteRps B with(nolock)
--		join @Nota N on N.Numero = B.Numero and N.Ref_Acesso = B.Ref_Acesso)		
--		insert into Base_Envio_LoteRps
--			select * from @Nota			
--END

select 
	N.Numero,N.Serie,N.Tipo,N.DataEmissao,N.NaturezaOperacao,N.RegimeEspecialTributacao,
	N.OptanteSimplesNacional,N.IncentivadorCultural,N.[Status],N.ValorServicos,N.ValorPis,
	N.ValorCofins,N.ValorInss,N.ValorIr,N.ValorCsll,N.IssRetido,N.ValorIssRetido,
	N.ValorIss,N.BaseCalculo,
	N.Aliquota * 100 Aliquota,
	N.ValorLiquidoNfse,N.ItemListaServico,
	N.CodigoCnae,N.CodigoTributacaoMunicipio,
	N.DescricaoServico,
	
	N.CodigoMunicipio,N.Discriminacao,
	N.MunicipioPrestacaoServico,N.Cnpj,N.InscricaoMunicipal,N.CpfCnpj,N.CpfInscricaoMunicipal,N.RazaoSocial,
	N.Endereco,N.NumeroEnd,N.Complemento,N.Bairro,N.Cidade,N.CodigoMunicipioE,
	N.CodigoMunicipioEnd,N.Uf,N.Estado,N.Cep,N.Telefone,N.Email,N.Ref_Acesso,N.ValorCargaTributaria,N.Pais,
	BNF.RPS_Data,BNF.RPS_NFE,BNF.RPS_NFE_Verif,
	B.Imagem,
	
	N.PrefeituraPrestador,
	N.RazaoSocialPrestador,
	N.EnderecoPrestador,
	N.NumeroEndPrestador,
	N.ComplementoPrestador,	
	N.BairroPrestador,
	N.CidadePrestador,
	N.CodigoMunicipioEPrestador,
	N.CodigoMunicipioEndPrestador,	
	N.UfPrestador,
	N.EstadoPrestador,
	N.CepPrestador,
	N.TelefonePrestador,
	N.EmailPrestador,N.Ginfes
	,BNF.RPS_ID
from @Nota N
	left join base_nota_fiscal BNF on N.Numero = BNF.Nota_Fiscal and N.Ref_Acesso = BNF.Ref_Acesso
	left join Base_Nota_Fiscal_QR_Code B on N.Numero = B.Nota_Fiscal and N.Ref_Acesso = B.Ref_Acesso
	
	



GO
