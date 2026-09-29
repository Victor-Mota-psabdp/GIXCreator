SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  View DemurrageR

as

Select month(convert(Datetime,dt_ins_him,105))Mes, DC_HIM,vlr_org_him*isnull(Par_moeda,1) Valor from cta_Cte_hou_imp_MAr CTA
Left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and convert(Datetime,par.dt_par,105)=convert(Datetime,dt_ins_him,105) and PAR.cd_tp_par='IMM'
Where desp_org_him='N'
and cd_tp_Tx in (
'DEM',
'DE2',
'DE3',
'DE4',
'DE5',
'dc3',
'DCT',
'DC2',
'DC3',
'DC4',
'DC5'
)
and dt_ins_him like '%%/%%/2006'




GO
