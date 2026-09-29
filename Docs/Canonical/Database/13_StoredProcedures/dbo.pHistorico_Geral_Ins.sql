SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pHistorico_Geral_Ins
(
@Cd_Pes			varchar(10),
@Dt_Hist			datetime,
@Refer_Hist			varchar(16),
@Cd_Usuario			varchar(6),
@Cd_Tp_Ocor			int,
@Descr_Hist			varchar(4000),
@Dt_Follow_Up			DateTime=Null
)
AS
	Declare @Processo 	VarChar(16)
	Begin Transaction 
	If Left(@Refer_Hist, 2) = 'IM'
		Set @Processo = (Select Num_Proc_HIM From House_Imp_Mar Where JOB_HIM = @Refer_Hist)
	If Left(@Refer_Hist, 2) = 'IA'
		Set @Processo = (Select Num_Proc_HIA From House_Imp_Aer Where JOB_HIA = @Refer_Hist)
	If Left(@Refer_Hist, 2) = 'EM'
		Set @Processo = (Select Num_Proc_HEM From House_Exp_Mar Where JOB_HEM = @Refer_Hist)
	If Left(@Refer_Hist, 2) = 'EA'
		Set @Processo = (Select Num_Proc_HEA From House_Exp_Aer Where JOB_HEA = @Refer_Hist)

	Insert Into 
		Historico_Geral
	Values 
		(@Cd_Pes, @Dt_Hist, @Processo, @Cd_Usuario, @Cd_Tp_Ocor, @Descr_Hist, @Dt_Follow_Up)

	If @@Error = 0 
		Begin 
			Commit Transaction 
			Return 1 
		End 

	Return @@RowCount

GO
