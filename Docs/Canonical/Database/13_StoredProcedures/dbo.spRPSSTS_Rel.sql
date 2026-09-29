SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spRPSSTS_Rel]
	@NF varchar(10),
	@dtInicial datetime,
	@dtFinal datetime
as

	select 
	--[IDE]
		'[IDE]' Rotulo,
		BNF.Nota_Fiscal [NUMERO], '1' [SERIE], '1' [TIPO], convert(varchar(10), BNF.Emissao,120)+ 'T00:00:00' [DATAEMISSAO],'1' [NATUREZAOPERACAO], 
		'' [REGIMEESPECIALTRIBUTACAO], '2' [OPTANTESIMPLESNACIONAL], '2' [INCENTIVADORCULTURAL],-- NULL [ADICIONARESP],
	--[PREST]
		'[PREST]' Rotulo,
		'03706460000209' [CNPJ], '1366280' [INSCRICAOMUNICIPAL], 'BDP SOUTH AMERICA LTDA' [RAZAOSOCIAL], 'BDP SOUTH AMERICA LTDA' [NOMEFANTASIA], 
		'Av. Senador Feijó' [ENDERECO], '26' [NUMERO], '' [COMPLEMENTO], 'CENTRO' [BAIRRO], '3548500' [CODIGOMUNICIPIO], 
		'sp' [UF], '11015500' [CEP], '1332021630' [TELEFONE], 'sbezerra@bdp.com.br' [EMAIL],
	--[TOMA]
		'[TOMA]' Rotulo,
		T.num_cpf_cnpj [CNPJ],(CASE WHEN NUM_Insc_Munic = '' OR NUM_Insc_Munic IS NULL THEN 'ISENTO' ELSE NUM_Insc_Munic END) [INSCRICAOMUNICIPAL], T.nome_raz_soc [RAZAOSOCIAL], TE.Rua [ENDERECO], TE.numero [NUMERO], 
		TE.compl_end [COMPLEMENTO], TE.bairro [BAIRRO], CMN.STR_CODIGOMUN_IBGE [CODIGOMUNICIPIO], TE.UF [UF], TE.CEP [CEP], (CO.cd_int + CO.cd_area_fone + CO.Prefixo + CO.num_fone) [TELEFONE], CO.compl_fone [EMAIL],
	--[SERVICO]
		'[SERVICO]' Rotulo,
--		'10.06' [ITEMLISTASERVICO], '5250801' [CODIGOCNAE], '100600188' [CODIGOTRIBUTACAOMUNICIPIO], [dbo].[FRemoveAcentuacao](@NovoConteudo) DISCRIMINACAO, 
		'20.03' [ITEMLISTASERVICO], '200300188' [CODIGOTRIBUTACAOMUNICIPIO], [dbo].[FRemoveAcentuacao]([dbo].[fBusca_spRPSBH](BNF.Nota_Fiscal)) DISCRIMINACAO, 
		'3548500' [CODIGOMUNICIPIO],
	--[TOTAIS]
		'[TOTAIS]' Rotulo,
		isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total)),'0.00') [VALORSERVICOS], 
		'0.00' [VALORDEDUCOES], 
--		isnull(convert(varchar,convert(decimal(10,2),.0065*BNF.Valor_Total)),'0.00') [VALORPIS], 
		'0.00' [VALORPIS], 
--		isnull(convert(varchar,convert(decimal(10,2),.03* BNF.Valor_Total)),'0.00') [VALORCOFINS],
		'0.00' [VALORCOFINS], 
		'0.00' [VALORINSS], 
		'0.00' [VALORIR], 
--		isnull(convert(varchar,convert(decimal(10,2),.01*BNF.Valor_Total)),'0.00') [VALORCSLL],
		'0.00' [VALORCSLL],  
		'2' [ISSRETIDO],
--		'5' [ISSRETIDO],
		isnull(convert(varchar,convert(decimal(10,2),.05* BNF.Valor_Total)),'0.00') [VALORISS], 
		'0.00' [OUTRASRETENCOES], 
		isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total)),'0.00') [BASECALCULO], 
		'5' [ALIQUOTA], 
--		isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total - ((.0065+.03+.01+.05)*BNF.Valor_Total))),'0.00') [VALORLIQUIDONFSE],
		isnull(convert(varchar,convert(decimal(10,2),BNF.Valor_Total)),'0.00') [VALORLIQUIDONFSE],
		'0.00' [VALORISSRETIDO], 
		'0.00' [DESCONTOCONDICIONADO], 
		'0.00' [DESCONTOINCONDICIONADO]
	from 
		base_nota_fiscal BNF
		join pessoa T on T.cd_pes = BNF.cd_pes 
		left join endereco TE on TE.cd_pes = T.cd_pes and TE.cd_tp_end = 'COM'
		left join comunicacao CO on CO.cd_pes = T.cd_pes and Co.cd_tp_com ='TC1'
		join atl_web.dbo.CAD_UF_NF CUN on CUN.str_SiglaUF   COLLATE Latin1_General_CI_AI = TE.UF
		join atl_web.dbo.cad_mun_nf CMN on CMN.str_nomemun  COLLATE Latin1_General_CI_AI = TE.cidade and CUN.str_CodigoUF_IBGE = CMN.str_CodigoUF_IBGE
	where
		Ref_Acesso = 'B'  and cd_status <> 2 and rps_envio <> 1
		and ( (emissao between @dtInicial and @dtFinal) OR Nota_Fiscal = @NF)

--select * from atl_web.dbo.cad_mun_nf where str_nomemun = 'LAGOA SANTA'
--select * from atl_web.dbo.CAD_UF_NF
--
--select * from endereco
--
--LAGOA SANTA


--4256
--4257
--4258
--4259

--spRPSBH_Rel '','2012-09-01','2012-09-03'

--
----spRPSBH_Rel '4266',NULL,NULL
--select * from Fatura_ARG where numero = '4262'
--
----Obs
--
--update base_nota_fiscal set rps_data  = null,rps_envio = 0 
--select * from base_nota_fiscal where ref_acesso = 'D' and rps_envio = 1
--
--and right('000000000000000' + nota_fiscal,15) = '000000000004222'
--
--"000000000004222"
--"spRPSBH_Rel '','2012-07-16','2012-12-31'"



--	Declare @NovoConteudo varchar(1000)
--	Declare @Conteudo varchar(1000)
--	Declare @Obs varchar(100)
--
--	set @OBS = (select obs from Fatura_ARG where numero = @NF)
--
--	Declare cTemp cursor for 
--		select nome_tp_tx + ' ' + convert(varchar,Valor_ARP) from Fatura_ARG F
--		join Fatura_ARG_Det D on D.id_fat = F.id_fat
--		join tipo_taxa T on T.cd_tp_tx = D.cd_tp_tx
--		where codigo = 'D' and numero = @NF
--	open cTemp
--		Fetch Next From cTemp Into @Conteudo
--		While @@FETCH_STATUS = 0
--			Begin
--				if @NovoConteudo='' or @NovoConteudo is Null
--					Begin
--						Set @NovoConteudo=@Conteudo
--					end
--				else
--					begin
--						set @NovoConteudo=@NovoConteudo + '     ' + @Conteudo
--					end
--				
--				Fetch Next From cTemp Into @Conteudo
--			end
--	close cTemp
--
--	deallocate cTemp

--select * from pessoa where apelido like 'bdp%santos%'
--select * from endereco where cd_pes = '10018'
--
--select * from atl_web.dbo.cad_mun_nf where str_NomeMun like 'Santos%'
--
--03706460000209

		


--select * from base_nota_fiscal where cd_status = 0 
--select * from pessoa where cd_pes = 'P18773'

--SELECT * FROM fatura_arg where codigo = 'D' and numero like '%4070%'
--SELECT * FROM dbo.Fatura_ARG_Det where codigo = 'D' and numero like '%4070%'


--spRPSBH_Rel '4070',NULL,NULL

--4322
--select * from base_nota_fiscal  where nota_fiscal = '4322' and Ref_Acesso = 'D'
--	Ref_Acesso = 'D' and rps_envio <> 1 
--	
--274.99
--304.36
--
--spRPSBH_Rel '4322',NULL,NULL
--update	base_nota_fiscal   
--set RPS_envio = 0
--where nota_fiscal = '4322' and Ref_Acesso = 'D'
--
--
--
--		where
--		Ref_Acesso = 'D'  and cd_status <> 2 
--
--		and emissao > '2012-08-01' 00:00:00.000





GO
