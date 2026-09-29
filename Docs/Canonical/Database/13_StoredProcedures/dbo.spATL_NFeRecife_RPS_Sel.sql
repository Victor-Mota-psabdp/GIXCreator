SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_NFe_Header_Sel] '2015-01-01','2015-12-31','C'

CREATE procedure [dbo].[spATL_NFeRecife_RPS_Sel]--'9016'
	@NF varchar(10)
	--@dtInicial datetime,
	--@dtFinal datetime
as
	select 
		--[IdentificacaoRps]					
			BNF.Nota_Fiscal [Numero], 
			'1' [Serie], 
			'1' [Tipo], 
		--[IdentificacaoRps]
	
		convert(varchar(10), BNF.Emissao,120)+ 'T00:00:00' [DataEmissao],
		'1' [NaturezaOperacao], 
		'' [RegimeEspecialTributacao], --NO 
		'0' [OptanteSimplesNacional], --MO
		'0' [IncentivadorCultural],--NO
		
		(case when BNF.cd_status = 0 then
			1 else 
		BNF.cd_status end)[Status],
		
		--[Servico]
			--[Valores]				
				isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total)),'0.00') [ValorServicos],
				'0.00' [ValorPis],
				--isnull(convert(varchar,convert(decimal(10,2),.0065*BNF.Valor_Total)),'0.00') [ValorPis], 
				'0.00' [ValorCofins],
				--isnull(convert(varchar,convert(decimal(10,2),.03* BNF.Valor_Total)),'0.00') [VALORCOFINS],				
				'0.00' [ValorInss], 
				'0.00' [ValorIr], 				
				'0.00' [ValorCsll],
				--isnull(convert(varchar,convert(decimal(10,2),.01*BNF.Valor_Total)),'0.00') [ValorCsll]], 
				'2' [IssRetido],
				isnull(convert(varchar,convert(decimal(10,2),.05* BNF.Valor_Total)),'0.00') [ValorIss],
				isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total)),'0.00') [BaseCalculo],				
				'0.05' [Aliquota],
				isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total)),'0.00') [ValorLiquidoNfse],
				--isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total - ((.0065+.03+.01+.05)*BNF.Valor_Total))),'0.00') [ValorLiquidoNfse],
			--[Valores]
				
			replace(BNF.Item_lei,'.','')		[ItemListaServico], 
			replace(BNF.CNAE,'.','')			[CodigoCnae], 
			replace(BNF.cd_servico,'.','')		[CodigoTributacaoMunicipio],
			'2611606'							[CodigoMunicipio], 
			
			[dbo].[FRemoveAcentuacao]([dbo].[fBusca_spRPSSTS](BNF.Nota_Fiscal,BNF.Ref_Acesso)) [Discriminacao],			
			''	[MunicipioPrestacaoServico], --NO
		--[Servico]
		--[Prestador]
			'03706460000390'		[Cnpj],
			'3362027'				[InscricaoMunicipal],
		--[Prestador]
		--[Tomador]
			--[IdentificaçãoTomador]
				--[CpfCnpj]
					T.num_cpf_cnpj [CpfCnpj],
				--[CpfCnpj]
				(CASE WHEN NUM_Insc_Munic = '' OR NUM_Insc_Munic IS NULL THEN 'ISENTO' ELSE NUM_Insc_Munic END) [CpfInscricaoMunicipal],
			--[IdentificaçãoTomador]
			T.nome_raz_soc [RazaoSocial], 
			--[Endereco]
				TE.Rua		[Endereco], 
				TE.numero	[Numero],
				TE.Compl_End	[Complemento],
				TE.bairro	[Bairro],
				--TE.Cidade	[Cidade],
				--TE.Cod_IBGE [CodigoMunicipio],
				CMN.STR_CODIGOMUN_IBGE [CodigoMunicipioEnd],
				TE.UF		[Uf], 
				TE.CEP		[Cep],
			--[Endereco]
			--[Contato]
				(CO.cd_int + CO.cd_area_fone + CO.Prefixo + CO.num_fone) [Telefone]
			--[Contato]		
		 --[Tomador]
	from 
		base_nota_fiscal BNF
		join pessoa T on T.cd_pes = BNF.cd_pes 
		left join endereco TE on TE.cd_pes = T.cd_pes and TE.cd_tp_end = 'COM'
		left join comunicacao CO on CO.cd_pes = T.cd_pes and Co.cd_tp_com ='TC1'
		join atl_web.dbo.CAD_UF_NF CUN on CUN.str_SiglaUF   COLLATE Latin1_General_CI_AI = TE.UF
		join atl_web.dbo.cad_mun_nf CMN on CMN.str_nomemun  COLLATE Latin1_General_CI_AI = TE.cidade and CUN.str_CodigoUF_IBGE = CMN.str_CodigoUF_IBGE		
	where
		BNF.Ref_Acesso = 'C'  and BNF.Cd_Status <> 2 and BNF.RPS_Envio <> 1
		--and ((emissao between @dtInicial and @dtFinal) OR 
		and Nota_Fiscal = @NF
		
		
		







GO
