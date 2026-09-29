SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spATL_NFe_BuscaRPS_NF_Sel '106977','A'

CREATE procedure [dbo].[spATL_NFe_BuscaRPS_NF_Sel]--,'I'
	@Nota_Fiscal varchar(10),
	@Site	char(1)
as

if @Site = 'I'
	select					
		BNF.Nota_Fiscal [Nota Fiscal],
		--[Prestador]
			'03706460000209'		[Cnpj],
			'1366280'				[InscricaoMunicipal],
		--[Prestador]
		--[Protocolo]
			BNF.Protocolo			[Protocolo]	
		 --[Protocolo]
	from 
		base_nota_fiscal BNF		
	where
		BNF.Ref_Acesso = @Site  
		and BNF.Cd_Status <> 2 
		and BNF.RPS_Envio <> 1
		and BNF.Nota_Fiscal = @Nota_Fiscal
		--and (emissao between @dtInicial and @dtFinal) 
		and BNF.Protocolo is not null
		--and BNF.Nota_Fiscal > '3786'
		and convert(int,BNF.Nota_Fiscal) > 3786
		
else if @Site = 'H'
	select					
		BNF.Nota_Fiscal [Nota Fiscal],
		--[Prestador]
			'03706460000713'		[Cnpj],
			'1217852'				[InscricaoMunicipal],
		--[Prestador]
		--[Protocolo]
			BNF.Protocolo			[Protocolo]	
		 --[Protocolo]
	from 
		base_nota_fiscal BNF		
	where
		BNF.Ref_Acesso = @Site  
		and BNF.Cd_Status <> 2 
		and BNF.RPS_Envio <> 1
		and BNF.Nota_Fiscal = @Nota_Fiscal
		and BNF.Protocolo is not null
		
if @site ='A'
	select 
		BNF.Nota_Fiscal			[IdRps],
		BNF.Nota_Fiscal			[NumeroLote],
		'03706460000128'		[Cnpj],
		'28921712'				[InscricaoMunicipal],
		1						[QuantidadeRps],		
		BNF.Nota_Fiscal			[Nota Fiscal],
		BNF.Protocolo			[Protocolo]	,
		'1'						[Serie]		
	from 
		base_nota_fiscal BNF				
	where
		BNF.Ref_Acesso = @Site
		and BNF.Cd_Status <> 2 
		and BNF.RPS_Envio <> 1
		and BNF.Nota_Fiscal = @Nota_Fiscal		
		and BNF.Protocolo is not null

--Alessandra 28/04/2020 - 100-215446 - NF Sao Caetano
if @site ='J'
	select 
		BNF.Nota_Fiscal			[IdRps],
		BNF.Nota_Fiscal			[NumeroLote],
		'03706460000985'		[Cnpj],
		'112691'				[InscricaoMunicipal],
		1						[QuantidadeRps],		
		BNF.Nota_Fiscal			[Nota Fiscal],
		BNF.Protocolo			[Protocolo]	,
		'1'						[Serie]		
	from 
		base_nota_fiscal BNF				
	where
		BNF.Ref_Acesso = @Site
		and BNF.Cd_Status <> 2 
		and BNF.RPS_Envio <> 1
		and BNF.Nota_Fiscal = @Nota_Fiscal		
		and BNF.Protocolo is not null

--Alessandra 10/07/2020 - 100-215446 - NF Sao Caetano
if @site ='K'
	select 
		BNF.Nota_Fiscal			[IdRps],
		BNF.Nota_Fiscal			[NumeroLote],
		'03706460000128'		[Cnpj],
		'113543'				[InscricaoMunicipal],
		1						[QuantidadeRps],		
		BNF.Nota_Fiscal			[Nota Fiscal],
		BNF.Protocolo			[Protocolo]	,
		'1'						[Serie]		
	from 
		base_nota_fiscal BNF				
	where
		BNF.Ref_Acesso = @Site
		and BNF.Cd_Status <> 2 
		and BNF.RPS_Envio <> 1
		and BNF.Nota_Fiscal = @Nota_Fiscal		
		and BNF.Protocolo is not null

GO
