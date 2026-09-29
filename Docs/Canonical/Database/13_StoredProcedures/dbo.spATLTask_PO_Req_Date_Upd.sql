SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATLTask_PO_Req_Date_Upd]
(
	@Num_Proc		Varchar(16),
	@PO_Req_Date	Datetime
)
as

BEGIN TRANSACTION	

	if left(@Num_Proc,2) = 'IM'
		BEGIN
			if exists(select num_proc_lim from LLP_IMP_MAR where num_proc_lim = @Num_Proc)
				BEGIN
					update LLP_IMP_MAR 
						set PO_Req_Date = @PO_Req_Date
					where 
						num_proc_lim = @Num_Proc 
				END
		END

	if left(@Num_Proc,2) = 'IA'
		BEGIN
			if exists(select num_proc_lia from LLP_Imp_Aer where num_proc_lia = @Num_Proc)
				BEGIN
					update LLP_Imp_Aer 
						set PO_Req_Date = @PO_Req_Date
					where 
						num_proc_lia = @Num_Proc 
				END
		END

	if left(@Num_Proc,2) = 'IO'
		BEGIN
			if exists(select num_proc_lio from LLP_Imp_Out where num_proc_lio = @Num_Proc)
				BEGIN
					update LLP_Imp_Out 
						set PO_Req_Date = @PO_Req_Date
					where 
						num_proc_lio = @Num_Proc 
				END
		END

	if left(@Num_Proc,2) = 'EM'
		BEGIN
			if exists(select num_proc_lem from LLP_Exp_Mar where num_proc_lem = @Num_Proc)
				BEGIN
					update LLP_Exp_Mar 
						set PO_Req_Date = @PO_Req_Date
					where 
						num_proc_lem = @Num_Proc 
				END
		END

	if left(@Num_Proc,2) = 'EA'
		BEGIN
			if exists(select num_proc_lea from LLP_Exp_Aer where num_proc_lea = @Num_Proc)
				BEGIN
					update LLP_Exp_Aer 
						set PO_Req_Date = @PO_Req_Date
					where 
						num_proc_lea = @Num_Proc 
				END
		END

	if left(@Num_Proc,2) = 'EO'
		BEGIN
			if exists(select num_proc_leo from LLP_Exp_Out where num_proc_leo = @Num_Proc)
				BEGIN
					update LLP_Exp_Out 
						set PO_Req_Date = @PO_Req_Date
					where 
						num_proc_leo = @Num_Proc 
				END
		END

	IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END

COMMIT TRANSACTION	
GO
