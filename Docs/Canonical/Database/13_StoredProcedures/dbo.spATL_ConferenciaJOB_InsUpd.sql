SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_ConferenciaJOB_InsUpd]
(
	@ID	bigint,
	@Num_Proc	varchar(16),
	@Vr_Cambio	bit,
	@Proft	bit,
	@Justificativa	varchar(MAX),
	@Cd_Usuario	varchar(6),
	@Status varchar(50),
	
	@SaldoRepasse float,
	@SaldoResultado float,
	@Prestacao	bit
)
as

Declare @Tp_Oper char(1)

if not exists( select ID from Confer_Job where Num_Proc = @Num_Proc)
	Begin
		insert Confer_Job 
			(
				Num_Proc,
				Vr_Cambio,
				Proft,
				Justificativa,
				Dt_Ins,
				Cd_Usuario,
				Status,
				SaldoRepasse,
				SaldoResultado,
				Prestacao
			)
		values
			(
				@Num_Proc,
				@Vr_Cambio,
				@Proft,
				@Justificativa,
				GETDATE(),
				@Cd_Usuario,
				@Status,
				@SaldoRepasse,
				@SaldoResultado,
				@Prestacao
			)
			
		Set @Tp_Oper = 'I'
	End
else
	Begin
		update 
			Confer_Job
		Set
			Vr_Cambio = @Vr_Cambio,
			Proft = @Proft,
			Justificativa = @Justificativa,
			--Dt_Ins = GETDATE(),
			--Cd_Usuario = @Cd_Usuario,
			Status =@Status,
			SaldoRepasse = @SaldoRepasse,
			SaldoResultado = @SaldoResultado,
			Prestacao = @Prestacao
		where 
			Num_Proc = @Num_Proc
			
		Set @Tp_Oper = 'A'	
	End
	
	
	insert Log_Confer_Job 
			(Dt_Alter,Tp_Oper,Num_Proc,Vr_Cambio,Proft,Justificativa,Dt_Ins,Cd_Usuario,
				Status,SaldoRepasse,SaldoResultado,Prestacao
			)
		values
			(GETDATE(),@Tp_Oper,@Num_Proc,@Vr_Cambio,@Proft,@Justificativa,	GETDATE(),@Cd_Usuario,
				@Status,@SaldoRepasse,@SaldoResultado,@Prestacao
			)
GO
