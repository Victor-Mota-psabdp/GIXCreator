SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[fBusca_CampoLLP](
	@Processo varchar(16),
	@Tipo varchar(20)
)
RETURNS varchar(50)

BEGIN

	Declare @Resultado varchar(50)

	IF @Tipo = 'Courier_Number'
		Begin
			If left(@Processo,2)='IA'
				Begin
					SET @Resultado=(select Courier_Number_Lia from LLP_Imp_Aer where num_proc_lia=@processo)
				End
			Else If left(@Processo,2)='IM'
				Begin
					SET @Resultado=(select Courier_Number_Lim from LLP_Imp_Mar where num_proc_lim=@processo)
				End
			Else If left(@Processo,2)='IO'
				Begin
					SET @Resultado=(select Courier_Number_Lio from LLP_Imp_Out where num_proc_lio=@processo)
				End
			Else If left(@Processo,2)='EA'
				Begin
					SET @Resultado=(select Courier_Number_Lea from LLP_Exp_Aer where num_proc_lea=@processo)
				End
			Else If left(@Processo,2)='EM'
				Begin
					SET @Resultado=(select Courier_Number_Lem from LLP_Exp_Mar where num_proc_lem=@processo)
				End
			Else If left(@Processo,2)='EO'
				Begin
					SET @Resultado=(select Courier_Number_Leo from LLP_Exp_Out where num_proc_leo=@processo)
				End
		End

	IF @Tipo = 'BL'
		Begin
			If left(@Processo,2)='IA'
				Begin
					SET @Resultado=(select isnull(HAWB_HIA,MAWB_HIA) from House_Imp_Aer where num_proc_hia=@processo)
				End
			Else If left(@Processo,2)='IM'
				Begin
					SET @Resultado=(select HAWB_HIM from House_Imp_Mar where num_proc_him=@processo)
				End
			Else If left(@Processo,2)='IO'
				Begin
					SET @Resultado=(select HAWB_HIO from House_Imp_Out where num_proc_hio=@processo)
				End
			Else If left(@Processo,2)='EA'
				Begin
					SET @Resultado=(select HAWB_HEA from House_Exp_Aer where num_proc_hea=@processo)
				End
			Else If left(@Processo,2)='EM'
				Begin
					SET @Resultado=(select HAWB_HEM from House_Exp_Mar where num_proc_hem=@processo)
				End
			Else If left(@Processo,2)='EO'
				Begin
					SET @Resultado=(select HAWB_HEO from House_Exp_Out where num_proc_heo=@processo)
				End
		End
		
		IF @Tipo = 'Cd_Moeda_Invoice'
			Begin
				If left(@Processo,2)='IA'
					Begin
						SET @Resultado=(select ISNULL(Cd_Moeda_Invoice,'') from LLP_Imp_Aer where num_proc_lia=@processo)
					End
				Else If left(@Processo,2)='IM'
					Begin
						SET @Resultado=(select ISNULL(Cd_Moeda_Invoice,'')from LLP_Imp_Mar where num_proc_lim=@processo)
					End
				Else If left(@Processo,2)='IO'
					Begin
						SET @Resultado=(select ISNULL(Cd_Moeda_Invoice,'') from LLP_Imp_Out where num_proc_lio=@processo)
					End
				Else If left(@Processo,2)='EA'
					Begin
						SET @Resultado=(select ISNULL(Cd_Moeda_Invoice,'') from LLP_Exp_Aer where num_proc_lea=@processo)
					End
				Else If left(@Processo,2)='EM'
					Begin
						SET @Resultado=(select ISNULL(Cd_Moeda_Invoice,'') from LLP_Exp_Mar where num_proc_lem=@processo)
					End
				Else If left(@Processo,2)='EO'
					Begin
						SET @Resultado=(select ISNULL(Cd_Moeda_Invoice,'') from LLP_Exp_Out where num_proc_leo=@processo)
					End
			End


		RETURN @Resultado

END















GO
