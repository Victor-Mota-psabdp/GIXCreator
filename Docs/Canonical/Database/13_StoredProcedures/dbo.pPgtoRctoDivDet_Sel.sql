SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



/****** Object:  Stored Procedure dbo.pPgtoRctoDivDet_Sel    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE pPgtoRctoDivDet_Sel 
(
@Num_Lcto_Div 		VarChar(12)
)
 AS

	Select 
		Pgt.* , HIS.Nome_Hist_Pdr, Pgt.Num_Lcto_Div + '-' + Pgt.Cd_Cta_Ctb + '-' + Pgt.Cd_Centro_Custo  + '-'  + DC_Item as Seq,  CC.Nome_Cta_Ctb, Ctr.Nome_Centro_Custo
	From 
		Pgto_Rcto_Div_Det as Pgt Join cta_ctb as CC on (Pgt.Cd_Cta_Ctb = CC.Cd_Cta_Ctb) 
		Join Centro_Custo as Ctr on (Pgt.Cd_Centro_Custo = Ctr.Cd_Centro_Custo)  
		Left Outer Join Historico_Padrao as HIS on (Pgt.Cd_Hist_Pdr = HIS.Cd_Hist_Pdr )
	Where
		Num_Lcto_Div = @Num_Lcto_Div

GO
