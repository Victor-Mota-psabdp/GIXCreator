SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View vwCtaCteNFValidas

AS

Select Num_Proc_HIA Num_Proc, DC_HIA DC, Cd_tp_TX, Nota_Fiscal, Emissao,Vlr_pgto_nf_hia Valor_ARP From vwcta_cte C
Join Base_Nota_Fiscal NF with(nolock) on NF.nota_fiscal=num_nf_hia and nf.ref_acesso=ref_acesso_nf_hia-- and cd_status <> '2'


GO
