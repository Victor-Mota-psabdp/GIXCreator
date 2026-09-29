SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Procedure [dbo].[spCtaCtbTx_Sel]
	@Cd_Cta_Ctb Varchar(50)
as

select nome_tp_Tx  from cta_Ctb_Tx TX
Join cta_ctb CTA on cta.cd_cta_ctb=TX.cd_cta_Ctb
Join Tipo_Taxa TT on TT.cd_tp_Tx=tx.cd_tp_tx
where
	cd_cta_ctb_Red=@Cd_cta_Ctb
GO
