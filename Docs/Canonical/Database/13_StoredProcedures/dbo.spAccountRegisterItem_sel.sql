SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spAccountRegisterItem_sel]
	@MEs char(2),
	@Ano char(4),
	@Num_Registro char(6)

as

select ID_Item,Valor Valor, Cd_Cta_ctb_Red, RFI.Num_Proc,TT.Nome_Tp_Tx, RFI.DC,Isnull(Valor_IVA,0) Valor_IVA, 
	Isnull(Valor_Total,0) Valor_Total,AX.id_Ax 
from Registro_Financeiro_Item RFI 
left join tipo_taxa TT on TT.cd_tp_tx = RFI.cd_tp_tx  
LEFT Join cta_Ctb cta on cta.cd_Cta_ctb=rfi.cd_Cta_ctb
left join vwAXDOCs AX on RFI.Num_Proc = AX.Num_proc and RFI.Cd_Tp_Tx = AX.Cd_Tp_Tx_ATL and RFI.dc = AX.dc
where
	Mes = @MEs 
	and Ano = @Ano 
	and Num_Registro= @Num_Registro 
	and isnull(RFI.Num_Proc,'') <> 'C'
GO
