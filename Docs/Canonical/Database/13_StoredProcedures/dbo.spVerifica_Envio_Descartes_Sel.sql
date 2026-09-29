SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spVerifica_Envio_Descartes_Sel]--'EACSR20101200501'
(
	@JOB as Varchar(16)
	
)
	
AS

select 
	E.Num_Proc_Hea_Dt_Ins,
	E.Num_Proc_Mea_Dt_Ins,
	E.Num_Proc_HEA,
	E.Num_Proc_MEA,
	E.Num_Proc_Hea_Dt_Envio,
	E.Num_Proc_Mea_Dt_Envio
	
	----(case when hou.Num_Proc_MEA = 'JOB' 
	----	then GETDATE() 
	----else Num_Proc_Hea_Dt_Envio 
	----end)Num_Proc_Hea_Dt_Envio,
	--Num_Proc_Hea_Dt_Envio,
	
	--(case when hou.Num_Proc_MEA = 'JOB' and Num_Proc_Hea_Dt_Envio IS not null  
	--	then GETDATE() 
	--else Num_Proc_Mea_Dt_Envio 
	--end) Num_Proc_Mea_Dt_Envio	 
from
	Exchange_E_AirFreight e
	left Join house_exp_Aer HOU on E.Num_Proc_Hea = HOU.Num_Proc_HEA
where 
	E.Num_Proc_Hea = @JOB-- 'EACSR20101200501'
	

GO
