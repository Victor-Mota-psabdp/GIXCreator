SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Function [dbo].[fBusca_Carrier](
				@Processo varchar(16),
				@Tipo varchar(10)

)
RETURNS varchar(200)

BEGIN
	Declare @Resultado varchar(200)
			
	IF @Tipo = 'CARRIER'
		Begin
			If left(@Processo,2)='IM'
				Begin
					SET @Resultado=(select ARM.Nome_Armador from Job_imp_Mar JOB with(nolock)
									left Join Armador ARM with(nolock) on ARM.cd_armador = JOB.cd_armador
									where JOB.num_proc_him = @processo)
				End
			Else If left(@Processo,2)='IA'
				Begin
					SET @Resultado=(select	CIA.Nome_cia_aer from Job_imp_aer JOB with(nolock)
									left Join cia_Aerea	CIA with(nolock) on CIA.Cd_Cia_Aer=JOB.Cd_Cia_Aer
									where JOB.num_proc_hia = @processo)
				End
			Else If left(@Processo,2)='IO'
				Begin
					SET @Resultado=(select ARM.Nome_raz_soc from LLp_Imp_out LLP with(nolock)
									left Join pessoa ARM with(nolock) on ARM.cd_pes = LLP.cd_carrier
									where LLP.num_proc_lio= @processo)
				End
			Else If left(@Processo,2)='EA'
				Begin
					SET @Resultado=(select ARM.Nome_cia_aer from LLP_Exp_Aer LLP with(nolock)
									left Join Cia_Aerea ARM with(nolock) on ARM.cd_cia_aer=LLP.cd_ciaaerea_lea
									where LLP.Num_Proc_Lea = @processo)
				End
			Else If left(@Processo,2)='EM'
				Begin
					SET @Resultado=(select ARM.Nome_Armador from LLp_Exp_mar LLP with(nolock) 
									left Join Armador ARM with(nolock) on ARM.cd_armador=llp.cd_armador_lem
									where LLP.num_proc_lem = @processo)
				End
			Else If left(@Processo,2)='EO'
				Begin
					SET @Resultado=(Select ARM.Apelido from LLp_Exp_out LLP with(nolock)
									left Join pessoa ARM with(nolock) on ARM.cd_pes=llp.cd_carrier
									where LLP.num_proc_leo = @processo)
				End
		End

	RETURN @Resultado

END















GO
