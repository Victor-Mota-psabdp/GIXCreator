SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create  function [dbo].[fBusca_Item_Fatura](
@Fatura	varchar(16),
@CdTipoTaxaSis	varchar(3)
)
RETURNS Float

BEGIN
	Declare @Resultado Float

	SET @Resultado=Isnull((
			Select SUM(Vlr_PC) from  Fatura_CHB_Item FI with(nolock) 
			join tipo_taxa TT with(nolock) on TT.cd_tp_tx=FI.cd_tp_tx
			 where FI.Fatura_CC = @Fatura and  TT.Cd_tp_tx_Sis = @CdTipoTaxaSis),0)
	RETURN @Resultado
END

GO
