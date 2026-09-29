SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Antonio 17-07-2024
-- pegar o numero da consolidada 

CREATE function [dbo].[fBusca_Campo_Consolidada](
	@Processo varchar(16),
	@Tipo varchar(20)
)
RETURNS varchar(50)

BEGIN

	Declare @Resultado varchar(50)

	IF @Tipo = 'BL'
		Begin
			If left(@Processo,2)='IA'
				Begin
					SET @Resultado=(select Num_Proc_MIA from House_Imp_Aer where num_proc_hia=@processo)
				End
			Else If left(@Processo,2)='IM'
				Begin
					SET @Resultado=(select num_proc_mim from House_Imp_Mar where num_proc_him=@processo)
				End
			Else If left(@Processo,2)='IO'
				Begin
					SET @Resultado=(select MAWB_HIO from House_Imp_Out where num_proc_hio=@processo)
				End
			Else If left(@Processo,2)='EA'
				Begin
					SET @Resultado=(select num_proc_mea from House_Exp_Aer where num_proc_hea=@processo)
				End
			Else If left(@Processo,2)='EM'
				Begin
					SET @Resultado=(select num_proc_mem from House_Exp_Mar where num_proc_hem=@processo)
				End
			Else If left(@Processo,2)='EO'
				Begin
					SET @Resultado=(select MAWB_HEO from House_Exp_Out where num_proc_heo=@processo)
				End
		End
		RETURN @Resultado
END

GO
