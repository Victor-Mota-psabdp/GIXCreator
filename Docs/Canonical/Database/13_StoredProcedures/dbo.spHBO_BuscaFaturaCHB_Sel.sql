SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spHBO_BuscaFaturaCHB_Sel]
(
	@Fatura varchar(17)
)
As
 select cd_tp_tx,abs(Vlr_PC) from Fatura_CHB_Item where Fatura_CC = @Fatura 
GO
