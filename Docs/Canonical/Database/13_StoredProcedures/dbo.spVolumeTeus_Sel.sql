SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spVolumeTeus_Sel
	

AS

Declare		@DataInicial	Datetime
Declare		@DataFinal		Datetime


select 
	apelido,[dbo].[fBusca_TEUS] (hou.num_proc_him) Qty_Teus 
from 
	House_imp_mar HOU
	Join Master_Imp_MAR MAS on mas.num_proc_mim=hou.num_proc_mim and hou.num_proc_mim <> 'JOB'
	Join LLP_Master LLP on LLP.num_proc_master=mas.num_proc_mim
	Join Pessoa PP on pp.cd_pes=cd_export_him
where
	ETA_Master between @DataInicial and @DataFinal
GO
