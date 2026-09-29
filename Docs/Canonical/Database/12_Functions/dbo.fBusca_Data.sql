SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE function [dbo].[fBusca_Data](
				@Processo varchar(16),
				@Tipo varchar(5)

)
RETURNS Datetime

BEGIN
		Declare @Resultado Datetime

	IF @Tipo = 'ETA'
		Begin
			If left(@Processo,2)='IA'
				Begin
					SET @Resultado=(select ETA_LIA from LLP_Imp_Aer where num_proc_lia=@processo)
				End
			Else If left(@Processo,2)='IM'
				Begin
					SET @Resultado=(select ETA_LIM from LLP_Imp_Mar where num_proc_lim=@processo)
				End
			Else If left(@Processo,2)='IO'
				Begin
					SET @Resultado=(select ETA_LIO from LLP_Imp_Out where num_proc_lio=@processo)
				End
			Else If left(@Processo,2)='EA'
				Begin
					SET @Resultado=(select ETA_LEA from LLP_Exp_Aer where num_proc_lea=@processo)
				End
			Else If left(@Processo,2)='EM'
				Begin
					SET @Resultado=(select ETA_LEM from LLP_Exp_Mar where num_proc_lem=@processo)
				End
			Else If left(@Processo,2)='EO'
				Begin
					SET @Resultado=(select ETA_LEO from LLP_Exp_Out where num_proc_leo=@processo)
				End
		End
	ELSE IF @Tipo = 'ETD'
		Begin
			If left(@Processo,2)='EA'
				Begin
					SET @Resultado=(select ETD_LEA from LLP_Exp_Aer where num_proc_lea=@processo)
				End
			Else If left(@Processo,2)='EM'
				Begin
					SET @Resultado=(select ETD_LEM from LLP_Exp_Mar where num_proc_lem=@processo)
				End
			Else If left(@Processo,2)='EO'
				Begin
					SET @Resultado=(select ETD_LEO from LLP_Exp_Out where num_proc_leo=@processo)
				End
			If left(@Processo,2)='IA'
				Begin
					SET @Resultado=(select ETD_LIA from LLP_Imp_Aer where num_proc_lia=@processo)
				End
			Else If left(@Processo,2)='IM'
				Begin
					SET @Resultado=(select ETD_LIM from LLP_Imp_Mar where num_proc_lim=@processo)
				End
			Else If left(@Processo,2)='IO'
				Begin
					SET @Resultado=(select ETD_LIO from LLP_Imp_Out where num_proc_lio=@processo)
				End
		End
	ELSE IF @Tipo = 'ATD'
		Begin
			If left(@Processo,2)='EA'
				Begin
					SET @Resultado=(select ATD_LEA from LLP_Exp_Aer where num_proc_lea=@processo)
				End
			Else If left(@Processo,2)='EM'
				Begin
					SET @Resultado=(select ATD_LEM from LLP_Exp_Mar where num_proc_lem=@processo)
				End
			Else If left(@Processo,2)='EO'
				Begin
					SET @Resultado=(select ATD_LEO from LLP_Exp_Out where num_proc_leo=@processo)
				End
			If left(@Processo,2)='IA'
				Begin
					SET @Resultado=(select ATD_LIA from LLP_Imp_Aer where num_proc_lia=@processo)
				End
			Else If left(@Processo,2)='IM'
				Begin
					SET @Resultado=(select ATD_LIM from LLP_Imp_Mar where num_proc_lim=@processo)
				End
			Else If left(@Processo,2)='IO'
				Begin
					SET @Resultado=(select ATD_LIO from LLP_Imp_Out where num_proc_lio=@processo)
				End
		End
	ELSE IF @Tipo = 'ATA'
		Begin
			If left(@Processo,2)='EA'
				Begin
					SET @Resultado=(select ATA_LEA from LLP_Exp_Aer where num_proc_lea=@processo)
				End
			Else If left(@Processo,2)='EM'
				Begin
					SET @Resultado=(select ATA_LEM from LLP_Exp_Mar where num_proc_lem=@processo)
				End
			Else If left(@Processo,2)='EO'
				Begin
					SET @Resultado=(select ATA_LEO from LLP_Exp_Out where num_proc_leo=@processo)
				End
			If left(@Processo,2)='IA'
				Begin
					SET @Resultado=(select ATA_LIA from LLP_Imp_Aer where num_proc_lia=@processo)
				End
			Else If left(@Processo,2)='IM'
				Begin
					SET @Resultado=(select ATA_LIM from LLP_Imp_Mar where num_proc_lim=@processo)
				End
			Else If left(@Processo,2)='IO'
				Begin
					SET @Resultado=(select ATA_LIO from LLP_Imp_Out where num_proc_lio=@processo)
				End
		End
	ELSE IF @Tipo = 'BL'
		Begin
			If left(@Processo,2)='EM'
				Begin
					SET @Resultado=(select Dt_BL_Lem from LLP_Exp_Mar where num_proc_lem=@processo)
				End

			If left(@Processo,2)='IA'
				Begin
					SET @Resultado=(select PO_Req_Date from LLP_Imp_Aer where num_proc_LIA=@processo)
				End


		End

	RETURN @Resultado

END















GO
