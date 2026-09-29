SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select Cd_Status,item_lei, * from Base_Nota_Fiscal where Nota_Fiscal > 1894 and Ref_Acesso ='H'  order by 3
--[spATL_NFe_Header_Sel] '2016-02-02','2016-02-12','H'
--spATL_NFeVitoria_RPS_Sel '1912'
--spATL_NFe_BuscaRPS_NF_Sel '1911','H'
--1899 cancelada
--2	10.05	1908
--2	10.05	1909
--2	10.05	1910
--2	10.05	1913
--[spATL_NFe_Header_Sel] '2016-03-06','2016-03-16','H'
--[spATL_NFe_Header_Sel] '2017-05-13','2017-05-24','A'

--exec [spATL_NFe_Header_Sel] '2025-02-25','2025-12-31','I'
CREATE procedure [dbo].[spATL_NFe_Header_Sel]--'2015-01-01','2015-12-31','I'
	@dtInicial datetime,
	@dtFinal datetime,
	@site	char(1)
as

if @site ='I'
	select 
		BNF.Nota_Fiscal			[IdRps],
		BNF.Nota_Fiscal						[NumeroLote],
		'03706460000209'		[Cnpj],
		'1366280'				[InscricaoMunicipal],
		1					[QuantidadeRps],		
		BNF.Nota_Fiscal			[Nota Fiscal]		
	from base_nota_fiscal BNF
	--join Pessoa P on P.Cd_Pes = BNF.Cd_Pes
	--join Endereco E on P.Cd_Pes = E.Cd_Pes and E.Cd_Tp_End = 'COM'
	--Left join Pais PA on PA.cd_pais = E.cd_pais
	where
		BNF.Ref_Acesso = @site 
		and BNF.Cd_Status <> 2 
		and BNF.RPS_Envio <> 1
		and emissao between @dtInicial and @dtFinal
		and emissao >='2024-11-22'
		--and BNF.Nota_Fiscal in (  '188083' ) --trazer apenas a que vai rodar
		--and BNF.Nota_Fiscal not in ('188083') --not in para tirar a nota com erro da fila obs: lembrar de cobrar o usuario
		and convert(int,BNF.Nota_Fiscal) > 3786
		and BNF.dt_Protocolo is null

	order by 1
	--Group by BNF.Nota_Fiscal
		
else if @site ='C'
	select top 1
		--@IdRPS					[IdRps],
		BNF.Nota_Fiscal			[IdRps],
		BNF.Nota_Fiscal			[NumeroLote],		
		'03706460000390'		[Cnpj],
		'3362027'				[InscricaoMunicipal],
		1						[QuantidadeRps],
		BNF.Nota_Fiscal			[Nota Fiscal]		
	from base_nota_fiscal BNF		
	where
		BNF.Ref_Acesso = @site  
		and BNF.Cd_Status <> 2 
		and BNF.RPS_Envio <> 1
		and (emissao between @dtInicial and @dtFinal)


	Group by BNF.Nota_Fiscal
	
else if @site ='H'
	select 	
		BNF.Nota_Fiscal			[IdRps],
		BNF.Nota_Fiscal			[NumeroLote],		
		'03706460000713'		[Cnpj],
		'1217852'				[InscricaoMunicipal],
		1						[QuantidadeRps],
		BNF.Nota_Fiscal			[Nota Fiscal]		
from 
		base_nota_fiscal BNF		
	where
		BNF.Ref_Acesso = 'H'
		--and BNF.Nota_Fiscal in (1914,1915,1916,1917,1918,1919,1920,1921,1922)
		and BNF.Cd_Status <> 2 
		and BNF.RPS_Envio <> 1
		and (emissao between @dtInicial and @dtFinal)
		and BNF.Nota_Fiscal > 1894
		
if @site ='A'
	select 
		BNF.Nota_Fiscal			[IdRps],
		BNF.Nota_Fiscal			[NumeroLote],
		'03706460000128'		[Cnpj],
		'28921712'				[InscricaoMunicipal],
		1						[QuantidadeRps],		
		BNF.Nota_Fiscal			[Nota Fiscal]		
	from base_nota_fiscal BNF				
	where
		BNF.Ref_Acesso = @site 
		and BNF.Cd_Status <> 2 
		and BNF.RPS_Envio <> 1
		and emissao between @dtInicial and @dtFinal
		and emissao >='2017-06-15'
		and BNF.dt_Protocolo is null
		
	Group by BNF.Nota_Fiscal
	order by 1
	
--Alessandra 16/03/2020 - 100-215446 - NF Sao Caetano
if @site ='J'
	select 
		BNF.Nota_Fiscal			[IdRps],
		BNF.Nota_Fiscal			[NumeroLote],
		'03706460000985'		[Cnpj],
		'112691'				[InscricaoMunicipal],
		1						[QuantidadeRps],		
		BNF.Nota_Fiscal			[Nota Fiscal]		
	from base_nota_fiscal BNF				
	where
		BNF.Ref_Acesso = @site 
		and BNF.Cd_Status <> 2 
		and BNF.RPS_Envio <> 1
		and emissao between @dtInicial and @dtFinal
		and emissao >='2020-03-16'
		--and BNF.Nota_Fiscal = '69135'
		--and BNF.Nota_Fiscal not in ('825494','82595')
		--and convert(int,BNF.Nota_Fiscal) > 3786
		--and convert(int,BNF.Nota_Fiscal) > 10
		and BNF.dt_Protocolo is null
	order by 1
	--Group by BNF.Nota_Fiscal

--Alessandra 10/07/2020 - 100-215446 - NF Sao Caetano
if @site ='K'
	select 
		BNF.Nota_Fiscal			[IdRps],
		BNF.Nota_Fiscal			[NumeroLote],
		'03706460000128'		[Cnpj],
		'113543'				[InscricaoMunicipal],
		1						[QuantidadeRps],		
		BNF.Nota_Fiscal			[Nota Fiscal]		
	from base_nota_fiscal BNF				
	where
		BNF.Ref_Acesso = @site 
		and BNF.Cd_Status <> 2 
		and BNF.RPS_Envio <> 1
		and emissao between @dtInicial and @dtFinal
		--and BNF.Nota_Fiscal in ('35238')
		--and BNF.Nota_Fiscal not in ( '34555', '34356' )
		and BNF.dt_Protocolo is null
	order by 1
	--Group by BNF.Nota_Fiscal

	
	







GO
