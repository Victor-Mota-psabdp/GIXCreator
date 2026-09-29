SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spSmartMaster_Sel]
		@Num_Proc_Master	Varchar(14)

AS

select 
	convert(datetime,dt_emis_mim,105) Data_Registro 
from 
	master_imp_mar with(nolock)
where 
	Num_Proc_Mim=@Num_Proc_Master

Union All

select 
	convert(datetime,dt_emis_mia,105) Data_Registro 
from 
	master_imp_aer with(nolock)
where 
	Num_Proc_Mia=@Num_Proc_Master


Union All

select 
	convert(datetime,dt_emis_mea,105) Data_Registro 
from 
	master_exp_aer with(nolock)
where 
	Num_Proc_Mea=@Num_Proc_Master

Union All

select 
	convert(datetime,dt_emis_mem,105) Data_Registro 
from 
	master_exp_mar with(nolock)
where 
	Num_Proc_Mem=@Num_Proc_Master

GO
