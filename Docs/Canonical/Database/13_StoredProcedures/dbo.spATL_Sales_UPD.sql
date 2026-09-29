SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----select * from 
--update Job_Exp_Aer set Cd_Usuario = 'rfs' where Num_Proc_HEA = 'EAAMZ201705001BR'
--select * from Usuario where cd_vendedor = 'rrfsso'
--select  * from Hist_Geral_Sistema where HSGProcesso = 'EAAMZ201705001BR' order by HSGData

CREATE Procedure [dbo].[spATL_Sales_UPD]
(
	@Num_Proc		Varchar(16)
)

AS
Begin Transaction

	if left(@num_proc,2)='IA'
		IF EXISTS(SELECT JOB.Cd_Vendedor Cd_Vendedor FROM Job_Imp_Aer JOB where job.Num_Proc_HIA = @num_proc)
			Begin
				update
					Job_Imp_Aer
				set
					Cd_Vendedor = NULL
				Where
					num_proc_hia=@num_proc 
			End
	
	
	if left(@num_proc,2)='IM' 
		IF EXISTS(SELECT JOB.cd_vendedor cd_vendedor FROM Job_Imp_Mar JOB where job.Num_Proc_HIM = @num_proc)
			Begin
				update
					Job_Imp_Mar
				set
					Cd_Vendedor = NULL
				Where
					Num_Proc_HIM=@num_proc 
			End
		
	if left(@num_proc,2)='IO'
		IF EXISTS(SELECT LLP.cd_vendedor cd_vendedor FROM LLP_imp_out LLP where llp.num_proc_lio = @num_proc)
			Begin
				update
					LLP_imp_out
				set
					Cd_Vendedor = NULL
				Where
					Num_Proc_Lio=@num_proc 
			End
		
	if left(@num_proc,2)='EA'
		IF EXISTS(SELECT JOB.cd_vendedor cd_vendedor FROM Job_Exp_Aer JOB where job.Num_Proc_HEA = @num_proc)
			Begin
				update
					Job_Exp_Aer
				set
					Cd_Vendedor = NULL
				Where
					Num_Proc_HEA=@num_proc 
			End
	
	if left(@num_proc,2)='EO' 
		IF EXISTS(SELECT  LLP.cd_vendedor cd_vendedor FROM LLP_Exp_out LLP where llp.num_proc_leo = @num_proc)
			Begin
				update
					LLP_Exp_out
				set
					Cd_Vendedor = NULL
				Where
					Num_Proc_Leo=@num_proc 
			End

	if left(@num_proc,2)='EM'
		IF EXISTS(SELECT  JOB.cd_vendedor cd_vendedor FROM  Job_Exp_Mar JOB where job.Num_Proc_HEM=@num_proc)
			Begin
				update
					Job_Exp_Mar
				set
					Cd_Vendedor = NULL
				Where
					Num_Proc_HEM=@num_proc 
			End
		
		
IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END
	
Commit transaction
	

GO
