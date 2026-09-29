SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create	PROCEDURE [dbo].[spPgtoRcto_Sel]

			@NumLanc varchar(12)

AS

SELECT
	CTB.Nome_CTA_CTB, CTB.CD_Cta_Ctb, ( CC.Cd_Centro_Custo + ' - ' +  CC.Nome_Centro_Custo) AS Centro, DC_Item, Vlr_Item, HP.Nome_Hist_Pdr, Compl_Hist, Num_NF, Dt_Emissao
FROM
	Pgto_Rcto_Div_Det PRDD
	left Join Cta_Ctb CTB on PRDD.Cd_Cta_Ctb = CTB.Cd_Cta_Ctb
	left join Centro_Custo CC on PRDD.Cd_Centro_Custo = CC.Cd_Centro_Custo
	left join Historico_Padrao HP on PRDD.Cd_Hist_Pdr = HP.Cd_Hist_Pdr
WHERE 
	Num_Lcto_Div = @NumLanc






GO
