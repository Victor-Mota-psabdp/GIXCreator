SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spVolumesBDPSINT_Sel 'EMRHO201606030BR'
CREATE Procedure [dbo].[spVolumesBDPSINT_Sel]
	@Num_Proc Varchar(16)


AS

SET ANSI_WARNINGS OFF

Declare @Qtd float
Declare @Peso_Bruto_EM_VGM float

If left(@Num_PRoc,2)='EM' 
	Begin
		select @Qtd =sum(qtd_Vol_em)  from volume_exp_mar 
		Where num_proc_hem=@Num_Proc
	End
else
	Begin
		select @Qtd =sum(qtd_Vol_ea)  from volume_exp_aer 
		Where num_proc_hea=@Num_Proc
	END
	
select @Peso_Bruto_EM_VGM = sum(Peso_Bruto_EM_VGM) from Container_Additional_Info
Where num_proc=@Num_Proc and ativo = 1
		
select @Qtd Qtd, @Peso_Bruto_EM_VGM Peso_Bruto_EM_VGM


GO
