SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE   Procedure spCtaLogDet_Rel --'12-01-2006','12-31-2006'

		@DataInicial char(10),
		@DataFinal Char(10)

as

Select 
	left(num_proc_cc,2) Modal,Num_proc_cc Processo, Nome_tp_tx, dc_cc, (ISNULL(PAR_MOEDA,1)*vlr_org) Valor 
from 
	log_ctA_cte LogC
	Join Tipo_Taxa TT on Logc.cd_tp_tx=TT.cd_Tp_tx
	Left Join Paridade PAR on LOGC.cd_Tp_MOEDA=PAR.cd_tp_moeda and convert(datetime,dt_ins,105)=convert(datetime,dt_par,105) and cd_tp_par='OFC'
Where 
	data_cc between  @DataInicial and @DataFinal and tp_oper_cc='E'
	and convert(Datetime,dt_ins,105) < @DataInicial
	and (Vlr_contab > 0 and Vlr_contab is not Null)





GO
