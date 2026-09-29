SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spIncotermErros_REL

	as


--Relatorio demonstra os jobs que o incoterm nao condiz com o Tipo de Frete (PP ou CC)
-- Anderson



select num_proc_him Num_Proc,cd_Tp_frete Tipo_Frete  from house_imp_mar HOU
Left Join Tipo_Oper INC on INC.cd_tp_oper=hou.cd_tp_oper
Where
	HOU.tp_frete_him <> INC.cd_Tp_frete
	and hou.tp_frete_him <> 'BDP'
union

select num_proc_hia Num_Proc,cd_Tp_frete Tipo_Frete  from house_imp_aer HOU
Left Join Tipo_Oper INC on INC.cd_tp_oper=hou.cd_tp_oper
Where
	HOU.tp_frete_hia <> INC.cd_Tp_frete
	and hou.tp_frete_hia <> 'BDP'

UNION

select num_proc_hiO Num_Proc,cd_Tp_frete Tipo_Frete  from house_imp_OUT HOU
Left Join Tipo_Oper INC on INC.cd_tp_oper=hou.cd_tp_oper
Where
	HOU.tp_frete_hiO <> INC.cd_Tp_frete
	and hou.tp_frete_hiO <> 'BDP'


UNION


select num_proc_hEO Num_Proc,cd_Tp_frete Tipo_Frete  from house_EXp_OUT HOU
Left Join Tipo_Oper INC on INC.cd_tp_oper=hou.cd_tp_oper
Where
	HOU.tp_frete_hEO <> INC.cd_Tp_frete
	and hou.tp_frete_hEO <> 'BDP'


UNION



select num_proc_hEM Num_Proc,cd_Tp_frete Tipo_Frete  from house_EXp_MAR HOU
Left Join Tipo_Oper INC on INC.cd_tp_oper=hou.cd_tp_oper
Where
	HOU.tp_frete_hEM <> INC.cd_Tp_frete
	and hou.tp_frete_hEM <> 'BDP'


UNION


select num_proc_hEA Num_Proc,cd_Tp_frete Tipo_Frete  from house_EXp_AER HOU
Left Join Tipo_Oper INC on INC.cd_tp_oper=hou.cd_tp_oper
Where
	HOU.tp_frete_hEA <> INC.cd_Tp_frete
	and hou.tp_frete_hEA <> 'BDP'

GO
