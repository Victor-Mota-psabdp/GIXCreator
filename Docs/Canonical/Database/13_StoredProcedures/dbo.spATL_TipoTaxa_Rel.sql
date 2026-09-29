SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_TipoTaxa_Rel ''
CREATE procedure [dbo].[spATL_TipoTaxa_Rel]

(
	@Nome_Tp_Tx varchar(50)
)

as

if @Nome_Tp_Tx = null
set @Nome_Tp_Tx = ''

select 
TT.Cd_Tp_Tx [Codigo],
TT.Nome_Tp_Tx [Nome da taxa],
(Case when TT.Tipo_DC  = 'B' then 'B - Both' else
Case when TT.Tipo_DC  = 'C' then 'C - Credit' else
Case when TT.Tipo_DC  = 'D' then 'D - Debit' else
TT.Tipo_DC end end end) [DC Type],
TT.Cd_cta_ctb_atv [Cost Of Services],
TT.Ref_Ctb_Tx [Oficial],
TT.Nome_Tp_Tx_Ing [Nome Inglês],
(case when TT.ND_Tx = 'A' then 'A - Air' else
case when TT.ND_Tx = 'M' then 'M - Ocean' else
case when TT.ND_Tx = 'O' then 'O - Others' else
case when TT.ND_Tx = 'T' then 'T - All Modals' else ND_Tx end end end end)
[Modal],
TT.Cd_cta_ctb_pas [Revenue Account],
TT.Cd_AX_Resultado [CD Resultado ],
TRS.Descricao_Ingles [Nome Taxa Resultado],
TT.Cd_AX_Repasse [CD Repasse ],
TRP.Descricao_Ingles [Nome Taxa Repasse],
(Case when TT.Repasse_Tx = 'S' then 'Yes' else Case when TT.Repasse_Tx = 'N' then 'No' else TT.Repasse_Tx end end)  [Repasse],
(Case when TT.Rateio_Tx = 'H' then 'House Qty' else Case when TT.Rateio_Tx = 'K' then 'Weight' else TT.Rateio_Tx end end) [Relação],
(Case when TT.CPMF_Tx = 'S' then 'Yes' else Case when TT.CPMF_Tx = 'N' then 'No' else TT.CPMF_Tx end end)   [Opções - IVA],
(Case when TT.Pft_Aer = 'S' then 'Yes' else Case when TT.Pft_Aer = 'N' then 'No' else TT.Pft_Aer end end)   [Opções - Profit],
(Case when TT.NF = 'S' then 'Yes' else Case when TT.NF = 'N' then 'No' else TT.NF end end) [Nota Fiscal],
(Case when TT.Rentabilidade = 'S' then 'Yes' else Case when TT.Rentabilidade = 'N' then 'No' else TT.Rentabilidade end end) [Profitability],
(Case when TT.Desat_Tx = 'S' then 'Yes' else Case when TT.Desat_Tx = 'N' then 'No' else TT.Desat_Tx end end) [Disable],
TTR.cd_site + ' - ' + S.Nome_Site [Site],
TTR.cd_servico [Código de Serviço],
Item_lei [Item Lei],
CNAE [CNAE],
TTR.Descricao	[Descrição]
from Tipo_Taxa TT with(nolock)
left join Tipo_Taxa_AX TRS with(nolock) on TT.CD_AX_Resultado = TRS.Cd_Charge_AX
left join Tipo_Taxa_AX TRP with(nolock) on TT.CD_AX_Resultado = TRP.Cd_Charge_AX
left join Tipo_taxaXTipo_NF_Doc_Register TTR with (nolock) on TT.Cd_Tp_Tx = TTR.Cd_Tp_Tx
left join Site S with (nolock) on TTR.cd_site = S.Cd_Site
where(@Nome_Tp_Tx = '' and TT.Nome_Tp_Tx like '%') or TT.Nome_Tp_Tx = @Nome_Tp_Tx

option(hash join)

GO
