SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vwAx_Doc_Pessoa]

As

select 
cem.Num_Proc_HEM, 
cem.Cd_Tp_Tx, 
cem.DC_HEM, 
cem.Cd_Cred_Dev_HEM,
AD.ID_AX

from Cta_Cte_Hou_Exp_Mar CEM with(nolock)
join AX_Doc_Item AD with(nolock) on CEM.Num_Proc_HEM = AD.Num_Proc and CEM.Cd_Tp_Tx = AD.cd_tp_Tx_ATL and CEM.DC_HEM = AD.DC
join AX_Doc AXD with(nolock) on AD.ID_AX = AXD.ID_AX
Where AXD.dt_canc_ax is null

union ALL

select 
cem.Num_Proc_HIM, 
cem.Cd_Tp_Tx, 
cem.DC_HIM, 
cem.Cd_Cred_Dev_HIM,
AD.ID_AX

from Cta_Cte_Hou_Imp_Mar CEM with(nolock)
join AX_Doc_Item AD with(nolock) on CEM.Num_Proc_HIM = AD.Num_Proc and CEM.Cd_Tp_Tx = AD.cd_tp_Tx_ATL and CEM.DC_HIM = AD.DC
join AX_Doc AXD with(nolock) on AD.ID_AX = AXD.ID_AX
Where AXD.dt_canc_ax is null

union ALL

select 
cem.Num_Proc_HEA, 
cem.Cd_Tp_Tx, 
cem.DC_HEA, 
cem.Cd_Cred_Dev_HEA,
AD.ID_AX

from Cta_Cte_Hou_Exp_Aer CEM with(nolock)
join AX_Doc_Item AD with(nolock) on CEM.Num_Proc_HEA = AD.Num_Proc and CEM.Cd_Tp_Tx = AD.cd_tp_Tx_ATL and CEM.DC_HEA = AD.DC
join AX_Doc AXD with(nolock) on AD.ID_AX = AXD.ID_AX
Where AXD.dt_canc_ax is null

union ALL

select 
cem.Num_Proc_HIA, 
cem.Cd_Tp_Tx, 
cem.DC_HIA, 
cem.Cd_Cred_Dev_Hia,
AD.ID_AX

from Cta_Cte_Hou_Imp_Aer CEM with(nolock)
join AX_Doc_Item AD with(nolock) on CEM.Num_Proc_HIA = AD.Num_Proc and CEM.Cd_Tp_Tx = AD.cd_tp_Tx_ATL and CEM.DC_HIA = AD.DC
join AX_Doc AXD with(nolock) on AD.ID_AX = AXD.ID_AX
Where AXD.dt_canc_ax is null

union ALL

select 
cem.Num_Proc_HEO, 
cem.Cd_Tp_Tx, 
cem.DC_HEO, 
cem.Cd_Cred_Dev_HEO,
AD.ID_AX

from Cta_Cte_Hou_Exp_Out CEM with(nolock)
join AX_Doc_Item AD with(nolock) on CEM.Num_Proc_HEO = AD.Num_Proc and CEM.Cd_Tp_Tx = AD.cd_tp_Tx_ATL and CEM.DC_HEO = AD.DC
join AX_Doc AXD with(nolock) on AD.ID_AX = AXD.ID_AX
Where AXD.dt_canc_ax is null

union ALL

select 
cem.Num_Proc_HIO, 
cem.Cd_Tp_Tx, 
cem.DC_HIO, 
cem.Cd_Cred_Dev_HIO,
AD.ID_AX

from Cta_Cte_Hou_Imp_Out CEM with(nolock)
join AX_Doc_Item AD with(nolock) on CEM.Num_Proc_HIO = AD.Num_Proc and CEM.Cd_Tp_Tx = AD.cd_tp_Tx_ATL and CEM.DC_HIO = AD.DC
join AX_Doc AXD with(nolock) on AD.ID_AX = AXD.ID_AX
Where AXD.dt_canc_ax is null

union ALL

select 
cem.Num_Proc_HBO, 
cem.Cd_Tp_Tx, 
cem.DC_HBO, 
cem.Cd_Cred_Dev_HBO,
AD.ID_AX

from Cta_Cte_HOU_BDP_OUT CEM with(nolock)
join AX_Doc_Item AD with(nolock) on CEM.Num_Proc_HBO = AD.Num_Proc and CEM.Cd_Tp_Tx = AD.cd_tp_Tx_ATL and CEM.DC_HBO = AD.DC
join AX_Doc AXD with(nolock) on AD.ID_AX = AXD.ID_AX
Where AXD.dt_canc_ax is null



GO
