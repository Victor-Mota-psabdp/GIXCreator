SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spATL_NavioxViagemXJob_Report_Exp_Sel]--777
(
	@ID		int
)
AS
	select 
		LLP.Num_Proc_Lem [JOB],
		convert(varchar(10),LLP.DL_Cargo_Lem,103) [Dead Line Draft],
		convert(varchar(10),LLP.DL_Draft_Lem,103) [Dead Line Cargo],
		convert(varchar(10),LLP.DL_VGM_Lem,103) [Dead Line VGM],
		Nr_Reserva [Booking] 
	From 
		LLP_Exp_Mar LLP 
		join Job_Exp_Mar JOB on JOB.Num_Proc_HEM = LLP.Num_Proc_Lem 
	where 
		LLP.ID_Viagem = @ID

			
	UNION
	
	select 
		LLP.Num_Proc_Master		JOB,
		convert(varchar(10),LEM.DL_Cargo_Lem,103) [Dead Line Draft],
		convert(varchar(10),LEM.DL_Draft_Lem,103) [Dead Line Cargo],
		convert(varchar(10),LEM.DL_VGM_Lem,103) [Dead Line VGM],
		Nr_Reserva [Booking] 	
	From  
		Master_Exp_Mar  HOU
		Left Outer Join LLP_Master		LLP			on HOU.Num_Proc_MEM	= LLP.Num_Proc_Master		
		Left Outer Join House_Exp_Mar	HEM			on HOU.Num_Proc_MEM = HEM.Num_Proc_MEM
		Left Outer Join LLP_Exp_Mar		LEM			on HEM.Num_Proc_HEM	= LEM.Num_Proc_Lem		
		Left Outer join Job_Exp_Mar		JOB			on JOB.Num_Proc_HEM = LEM.Num_Proc_Lem 
	 where 
		LLP.ID_Viagem = @ID



GO
