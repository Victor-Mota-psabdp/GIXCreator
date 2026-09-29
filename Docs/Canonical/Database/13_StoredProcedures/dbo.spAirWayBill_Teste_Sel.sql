SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAirWayBill_Teste_Sel]--'EAVCP201909003'
(
	@Num_Proc_Mea varchar(16)
)
	
AS

select
	HOU.Num_Proc_HEA,
	HOU.HAWB_HEA
from
	Exchange_E_AirFreight e
	left Join house_exp_Aer HOU on E.Num_Proc_Hea = HOU.Num_Proc_HEA
	left Join Master_Exp_Aer MEA on E.Num_Proc_Mea = MEA.Num_Proc_MEA
where 	
	hou.Num_Proc_Mea = @Num_Proc_Mea and
	hou.Num_Proc_MEA <> 'JOB'
	----and hou.Num_Proc_MEA  = 'EAGRU201606018'--'EAGRU201606019'--EAGRU201606018
	----and hou.Num_Proc_MEA  = 'EAVCP201606003'--'EAGRU201606009'--EAVCP201606003	
	--and E.Num_Proc_MEA_DT_Envio is null 
	--and	E.Num_Proc_HEA_DT_Envio is null 
	--and Num_Proc_Hea_Dt_Ins is not null
	--and Num_Proc_Mea_Dt_Ins is not null 

	
	


GO
