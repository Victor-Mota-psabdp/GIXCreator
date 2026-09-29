SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE      Procedure spCtaLogRES_Rel 

		@DataInicial char(10),
		@DataFinal Char(10)

as


Select 
	left(num_proc_cc,2) Modal, dc_cc, cast(sum(isnull(Par_MOEDA,1)*dbo.valor(vlr_org,dc_cc)*-1) AS deCIMAL(10,2)) Valor 
from 
	log_ctA_cte LL
	Left Join Paridade PAR on LL.cd_Tp_MOEDA=PAR.cd_tp_moeda and convert(datetime,dt_ins,105)=convert(datetime,dt_par,105) and cd_tp_par='OFC'
Where 
	dbo.hoje(data_cc) between  @DataInicial and @DataFinal and tp_oper_cc='E'
	and convert(Datetime,dt_ins,105) < @DataInicial
	and (Vlr_contab > 0 and Vlr_contab is not Null)
Group by
	left(num_proc_cc,2),dc_cc







GO
