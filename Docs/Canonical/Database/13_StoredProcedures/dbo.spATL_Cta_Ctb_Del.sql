SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Cta_Ctb
CREATE procedure [dbo].[spATL_Cta_Ctb_Del]
(
	@Cd_Cta_Ctb		varchar(13)
)
as
	update Cta_Ctb set Ck_Ativo = 'N' where Cd_Cta_Ctb= @Cd_Cta_Ctb

GO
