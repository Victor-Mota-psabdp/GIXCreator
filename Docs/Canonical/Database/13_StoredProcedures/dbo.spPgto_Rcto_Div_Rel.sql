SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








create         Procedure [dbo].[spPgto_Rcto_Div_Rel] 
		
	@Num_Lcto	VarChar(16)


AS
SELECT  PR.Num_Lcto_div, 
		PR.cd_BANCO + ' - ' + BC.Nome_Banco BANCO, 
		PR.Cd_Agencia + ' - ' + AG.Nome_Agencia AGENCIA, 
		PR.Num_Cta_Cte, 
		PR.DC_div, 
		PR.Dt_Pgto_Rcto_div, 
		PR.Num_Doc_div, 
		PR.Vlr_Doc_div, 
		P.Apelido, 
		PR.Dt_Vcto_div, 
		PR.Concil_div, 
		PR.Cta_Cte_Cliente_Div, 
		PR.Ck_Doctos,
		PRD.cd_cta_ctb + ' - ' + CtCb.Nome_Cta_Ctb CTA_CTB,
		PRD.cd_centro_custo + ' - ' + CC.Nome_Centro_Custo CENTRO_CUSTO,
		PRD.Dc_Item,
		PRD.Vlr_item,
		HP.Nome_hist_Pdr,
		Compl_Hist,
		Num_NF,
		Dt_Emissao

		FROM Pgto_Rcto_div PR
		
		join Pessoa P on PR.Cd_Pes = P.Cd_Pes
		left outer join Pgto_rcto_div_det PRD on PR.Num_lcto_Div = PRD.Num_lcto_div
		left outer join Banco BC on PR.cd_Banco = BC.cd_banco
		left outer join Agencia AG on PR.cd_agencia = PR.cd_agencia 
		left outer join Cta_Ctb CtCb on PRD.cd_cta_ctb = CtCb.cd_cta_ctb
		left outer join Centro_Custo CC on PRD.cd_centro_custo = CC.Cd_centro_custo
		left outer join Historico_Padrao HP on PRD.cd_hist_pdr = HP.cd_hist_pdr
		where PR.Num_Lcto_Div = @Num_Lcto
GO
