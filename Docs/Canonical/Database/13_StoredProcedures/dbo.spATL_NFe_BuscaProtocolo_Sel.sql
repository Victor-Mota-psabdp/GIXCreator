SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_NFe_BuscaProtocolo_Sel]--'2015-01-01','2015-12-31','I'
	@dtInicial datetime,
	@dtFinal datetime,
	@Site	char(1)
as
	select			
		
		--[IdentificacaoRps]					
			BNF.Nota_Fiscal [Nota Fiscal], 
			'1' [Serie], 
			'1' [Tipo], 
		--[IdentificacaoRps]
		
		--[Prestador]
			'03706460000209'		[Cnpj],
			'1366280'				[InscricaoMunicipal]
		--[Prestador]
		
	from 
		base_nota_fiscal BNF		
	where
		BNF.Ref_Acesso = @Site  
		and BNF.Cd_Status <> 2 
		and BNF.RPS_Envio <> 1
		and (emissao between @dtInicial and @dtFinal) 
		and BNF.Protocolo is not null
		--AND BNF.Nota_Fiscal ='1'




GO
