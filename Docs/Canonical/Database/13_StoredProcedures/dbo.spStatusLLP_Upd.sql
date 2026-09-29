SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--INCLUIDO O bo - CADU20-12-2018
CREATE Procedure [dbo].[spStatusLLP_Upd]

		@Num_Proc	Varchar(16),
		@id_status	int

AS

	if left(@Num_proc,2)='EM'
		Begin
			update llp_exp_mar set id_status=@id_status where num_proc_lem=@Num_proc
		End

	if left(@Num_proc,2)='EA'
		Begin
			update llp_exp_aer set id_status=@id_status where num_proc_lea=@Num_proc
		End

	if left(@Num_proc,2)='EO'
		Begin
			update llp_exp_out set id_status=@id_status where num_proc_leo=@Num_proc
		End
	if left(@Num_proc,2)='IM'
		Begin
			update llp_imp_mar set id_status=@id_status where num_proc_lim=@Num_proc
		End
	if left(@Num_proc,2)='IA'
		Begin
			update llp_imp_aer set id_status=@id_status where num_proc_lia=@Num_proc
		End
	if left(@Num_proc,2)='IO'
		Begin
			update llp_imp_out set id_status=@id_status where num_proc_lio=@Num_proc
		End
	if left(@Num_proc,2)='BO'
		Begin
			update LLP_BDP_OUT set id_status=@id_status where Num_Proc_LBO=@Num_proc
		End

GO
