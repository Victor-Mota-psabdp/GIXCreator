SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE	PROCEDURE [dbo].[spLanctoContabilDet_Sel]

	@NumLanc varchar(12)

AS

SELECT
	CTB.Nome_CTA_CTB, CTB.CD_Cta_Ctb, ( CC.cd_Centro_Custo + ' - ' +  CC.nome_Centro_Custo) AS Centro, DC_Item, Vlr_Item, HP.Nome_Hist_Pdr, Compl_Hist, Num_NF, Dt_Emissao, (Porcentagem_IVA * 100) Porcentagem_IVA , Vlr_IVA, Retencao
FROM
	Lancto_Contabil_Det PRDD
	left Join Cta_Ctb CTB on PRDD.Cd_Cta_Ctb = CTB.Cd_Cta_Ctb
	left join Centro_Custo CC on PRDD.Cd_Centro_Custo = CC.Cd_Centro_Custo
	left join Historico_Padrao HP on PRDD.Cd_Hist_Pdr = HP.Cd_Hist_Pdr
WHERE 
	Num_Lcto = @NumLanc


GO
