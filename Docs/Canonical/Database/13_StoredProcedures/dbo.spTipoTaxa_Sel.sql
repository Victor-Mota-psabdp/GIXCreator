SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTipoTaxa_Sel]
(	
	@Taxa VarChar(50) 	
)
 AS

select 
	Cd_Tp_Tx, Nome_Tp_Tx, Nome_tp_tx_Ing, CPMF_Tx, Rateio_Tx, Pft_Aer, Desat_Tx, 
	Cd_Tp_Tx_Ofc, ND_tx Tipo_Taxa,NF, Tipo_DC, cd_cta_ctb_atv, cd_cta_ctb_pas, 
	Rentabilidade, TT.cd_ax_resultado, 
	TTS.descricao_ingles descricao_ingles_Resultado,
	TT.cd_ax_repasse, 
	TTP.descricao_ingles descricao_ingles_Repasse,TT.Repasse_TX, 
	convert(varchar(1),ID_PD) + ' - ' + Nome_BDP_Produto Nome_BDP_Produto , IRRF_Tx
from Tipo_Taxa TT
	left join tipo_taxa_ax TTS on TT.cd_ax_Resultado= TTS.cd_charge_ax
	left join tipo_taxa_ax TTP on TT.cd_ax_Repasse= TTP.cd_charge_ax
    left join BDP_Produto BP on BP.ID_PD= TT.Tipo_Prod_Code    
where 
	nome_tp_tx = @Taxa or cd_tp_tx = @Taxa



GO
