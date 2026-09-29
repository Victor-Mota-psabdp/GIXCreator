SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_NFe_BuscaRPS_Sel]--'2015-10-05','2015-10-05','I'
	@dtInicial datetime,
	@dtFinal datetime,
	@Site	char(1)
as
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
		and (emissao between @dtInicial and @dtFinal) 
		and BNF.Protocolo is not null
		and BNF.Nota_Fiscal > '3786'




GO
