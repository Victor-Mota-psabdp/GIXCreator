SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Taxas_Rel]
(
@Desat varchar(10)
)

as

select 
Cd_Tp_Tx [Code],
Nome_Tp_Tx [Name (PTG)], 
Nome_Tp_Tx_Ing [Name (ENG)],
Cd_AX_Repasse [Code Passthrough], 
CD_AX_Resultado [Code P&L],
BP.Nome_BDP_Produto [Type Product], 
(case when TT.Desat_Tx = 'S' then 'Yes'else'No' End) [Disabled]  
from Tipo_Taxa TT with(nolock)
left join BDP_Produto BP with(nolock) on TT.Tipo_Prod_Code = BP.ID_PD 


GO
