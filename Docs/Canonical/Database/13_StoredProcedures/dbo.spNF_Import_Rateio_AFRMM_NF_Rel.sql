SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spNF_Import_Rateio_AFRMM_NF_Rel] --[spNF_Import_Rateio_AFRMM_NF_Rel]'IMSWB202110094BR'
	@Num_Proc varchar(16)
as
--Cabeçalho
DECLARE @Nota_Fiscal TABLE 
(
  [JOB]       varchar(16),
  [PO]        varchar(20),
  [CFOP]      varchar(50),
  [DI]        varchar(50),
  [PARIDADE VALOR]   varchar(50),
  [DATA DE DESEMBARACO] datetime,
  [LOCAL DESEMBARACO] varchar(50),
  [CNPJ]              varchar(20),
  [NOME DO NAVIO]     varchar(100)
  )

  insert into @nota_fiscal
  (
  [JOB],
  [PO],
  [CFOP],
  [DI],
  [PARIDADE VALOR],
  [DATA DE DESEMBARACO],
  [LOCAL DESEMBARACO],
  [CNPJ],
  [NOME DO NAVIO]
  )
	   select 
			hou.Num_Proc 								[JOB],
			dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'1')  [PO],	
			nf.CFOP										[CFOP],
			dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'5')  [DI],
		--	CONVERT(varchar(30),CAST(nf.Paridade as Decimal(18,4)))	[PARIDADE VALOR],
			format(nf.paridade,'n4','pt-br')         	[PARIDADE VALOR],
			nf.Emissao                                  [DATA DE DESEMBARACO],
			[dbo].[fBusca_Terminal] (HOU.Num_Proc)      [LOCAL DESEMBARACO],
			nf.CNPJ								        [CNPJ],	
			HOU.Vessel								    [NOME DO NAVIO]
		from vwhouse_imp HOU					with(nolock)
		Left join Nota_Cliente NF	            with(nolock) on nf.Num_Proc   = hou.Num_Proc
		Left join localidade LO					with(nolock) on HOU.Cd_Org = LO.Cd_Local
		Left join localidade LD					with(nolock) on HOU.Cd_Dst = LD.Cd_Local
		Left join Campo_Processo CP				with(nolock) on HOU.Num_Proc = CP.Num_Proc and CP.Id_Campo = '25'
		Left join Localidade LCP				with(nolock) on CP.Campo_Dados = LCP.Cd_Local
		where	
			HOU.Num_Proc = @Num_Proc


select * from @Nota_Fiscal
GO
