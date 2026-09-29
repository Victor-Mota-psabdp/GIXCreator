SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Procedure [dbo].[spSmartCancelado_Sel]

AS

Select 
	Num_Proc_LIM Processo 
from 
	LLP_Imp_Mar 
	Left Join Hist_Geral HSG on HSG.hsgprocesso=num_proc_lim
where 
	id_status=9 and hsgdata >=getdaTE()-30

Union 

Select 
	Num_Proc_LIA Job 
from 
	LLP_Imp_Aer 
	Left Join Hist_Geral HSG on HSG.hsgprocesso=num_proc_lia
where 
	id_status=9 and hsgdata >=getdaTE()-30

Union 

Select 
	Num_Proc_LIO Job 
from 
	LLP_Imp_Out 
	Left Join Hist_Geral HSG on HSG.hsgprocesso=num_proc_lio
where 
	id_status=9 and hsgdata >=getdaTE()-30

Union 


Select 
	Num_Proc_LEO Job 
from 
	LLP_Exp_Out 
	Left Join Hist_Geral HSG on HSG.hsgprocesso=num_proc_leo
where 
	id_status=9 and hsgdata >=getdaTE()-30


Union

Select 
	Num_Proc_LEM Job 
from 
	LLP_Exp_Mar 
	Left Join Hist_Geral HSG on HSG.hsgprocesso=num_proc_lem
where 
	id_status=9 and hsgdata >=getdaTE()-30


Union 


Select 
	Num_Proc_LEA Job 
from 
	LLP_Exp_Aer 
	Left Join Hist_Geral HSG on HSG.hsgprocesso=num_proc_lea
where 
	id_status=9 and hsgdata >=getdaTE()-30

GO
