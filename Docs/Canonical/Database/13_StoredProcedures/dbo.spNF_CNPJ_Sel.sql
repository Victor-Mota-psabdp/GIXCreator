SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spNF_CNPJ_Sel]
	@CNPJ varchar(16),
	@NF int
AS
	select str_NF,dt_Emissao from ATL_WEB.dbo.capa_nf NF
    join ATL_WEB.dbo.cadastros_nf CAD on CAD.str_codigocadastro = NF.str_codigoemitente
    where str_CNPJ = @CNPJ and convert(int,str_NF) = @NF and str_Protocolo is NOT null



GO
