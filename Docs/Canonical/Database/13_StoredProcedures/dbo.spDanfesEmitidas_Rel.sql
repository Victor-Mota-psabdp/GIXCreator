SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spDanfesEmitidas_Rel] --'grupo fmc','2011-08-01','2011-08-30', ''
(
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
)
AS

set @Grupo = ( select top 1 grupo from grupo G join pessoa P with(nolock) on P.cd_pes = G.cd_pes_grupo where apelido = @Grupo)

BEGIN
	select 
		STR_CNPJ [CNPJ], str_CodigoProcesso [Processo], str_ReferenciaImportador [PO Number], str_NF [Nº NF], dt_Emissao [Data Emissão], '' [Status], '' [Lançamento] 
	from 
		ATL_WEB.dbo.capa_NF NF with(nolock)
		left join ATL_WEB.dbo.Cadastros_NF EMI with(nolock) on EMI.STR_CODIGOTIPOCADASTRO='EMI' and EMI.STR_CODIGOCADASTRO=NF.STR_CODIGOEMITENTE 
	where 
		str_codigoprocesso like '%' + @grupo +'%' and dt_Emissao between @DtInicial and @DtFinal 
	order by
		dt_Emissao, str_NF
END

GO
