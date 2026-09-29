SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwCta_Ctb_Sel]
AS
select
	Cd_Cta_Ctb			[Code],			
	Nome_Cta_Ctb		[Account Name],
	Cd_Cta_Ctb_Red		[Short Code],
	Nome_Cta_Ctb_Red	[Short Account Name],
	Ref_Ctb,
	Ck_Lanc				[Entry],
	Ck_CM,
	Ck_Red,
	Ck_CC				[Cost Center],
	Ck_Conv,
	Ck_Conc,
	Ck_Ativo			[Enable],
	Ck_Plano_06,
	cd_FluxodeCaixa
from 
	Cta_Ctb with(nolock)

GO
