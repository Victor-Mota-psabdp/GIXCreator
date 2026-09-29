SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create function [dbo].[fBusca_CampoLLP_Data](
	@Processo varchar(16),
	@Tipo varchar(20)
)
RETURNS varchar(50)

BEGIN

	Declare @Resultado varchar(50)

	IF @Tipo = 'ETA'
		Begin
			If left(@Processo,2)='IA'
				Begin
					SET @Resultado=(select ETA_LIA from LLP_Imp_Aer where num_proc_lia=@processo)
				End
			Else If left(@Processo,2)='IM'
				Begin
					SET @Resultado=(select ETA_Lim from LLP_Imp_Mar where num_proc_lim=@processo)
				End
			Else If left(@Processo,2)='IO'
				Begin
					SET @Resultado=(select ETA_Lio from LLP_Imp_Out where num_proc_lio=@processo)
				End
			Else If left(@Processo,2)='EA'
				Begin
					SET @Resultado=(select ETA_Lea from LLP_Exp_Aer where num_proc_lea=@processo)
				End
			Else If left(@Processo,2)='EM'
				Begin
					SET @Resultado=(select ETA_Lem from LLP_Exp_Mar where num_proc_lem=@processo)
				End
			Else If left(@Processo,2)='EO'
				Begin
					SET @Resultado=(select ETA_Leo from LLP_Exp_Out where num_proc_leo=@processo)
				End
		End

	IF @Tipo = 'ETD'
		Begin
			If left(@Processo,2)='IA'
				Begin
					SET @Resultado=(select ETD_LIA from LLP_Imp_Aer where num_proc_lia=@processo)
				End
			Else If left(@Processo,2)='IM'
				Begin
					SET @Resultado=(select ETD_Lim from LLP_Imp_Mar where num_proc_lim=@processo)
				End
			Else If left(@Processo,2)='IO'
				Begin
					SET @Resultado=(select ETD_Lio from LLP_Imp_Out where num_proc_lio=@processo)
				End
			Else If left(@Processo,2)='EA'
				Begin
					SET @Resultado=(select ETD_Lea from LLP_Exp_Aer where num_proc_lea=@processo)
				End
			Else If left(@Processo,2)='EM'
				Begin
					SET @Resultado=(select ETD_Lem from LLP_Exp_Mar where num_proc_lem=@processo)
				End
			Else If left(@Processo,2)='EO'
				Begin
					SET @Resultado=(select ETD_Leo from LLP_Exp_Out where num_proc_leo=@processo)
				End
		End


		RETURN @Resultado

END


GO
