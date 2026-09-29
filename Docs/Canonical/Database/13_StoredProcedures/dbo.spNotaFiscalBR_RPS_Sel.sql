SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spNotaFiscalBR_RPS_Sel]--'A','110092'
	@Tipo		char(1),
	@Numero		varchar(8)
as

select
	B.Rps_Nfe Numero,
	L.Serie,L.Tipo,L.DataEmissao,L.NaturezaOperacao,L.RegimeEspecialTributacao,L.OptanteSimplesNacional,L.IncentivadorCultural,
	L.Status,L.ValorServicos,L.ValorPis,L.ValorCofins,L.ValorInss,L.ValorIr,L.ValorCsll,L.IssRetido,L.ValorIssRetido,L.ValorIss,
	L.BaseCalculo,L.Aliquota,L.ValorLiquidoNfse,L.ItemListaServico,L.CodigoCnae,L.CodigoTributacaoMunicipio,L.CodigoMunicipio,
	L.Discriminacao,L.MunicipioPrestacaoServico,L.Cnpj,L.InscricaoMunicipal,L.CpfCnpj,L.CpfInscricaoMunicipal,L.RazaoSocial,
	L.Endereco,L.NumeroEnd,L.Complemento,L.Bairro,L.Cidade,L.CodigoMunicipioE,L.CodigoMunicipioEnd,L.Uf,L.Estado,L.Cep,
	L.Telefone,L.Email,L.Ref_Acesso, B.RPS_NFE,B.RPS_NFE_Verif,B.protocolo,B.dt_Protocolo,
	B.dt_Cancel_Prefeitura
from Base_Envio_LoteRps L
	left join Base_Nota_Fiscal B on right('000000000000' + B.Nota_Fiscal,12) = right('000000000000' + L.Numero,12) and B.Ref_Acesso = L.Ref_Acesso
where
	L.ref_acesso = @Tipo and right('000000000000' + L.Numero,12) = right('000000000000' + @Numero,12)


GO
