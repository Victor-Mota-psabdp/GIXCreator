SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spVolumeSmart_Sel
		@Num_Proc	Varchar(16)

AS

if left(@Num_Proc,2)='EA'
	Begin
		select Qtd_Vol_EA VOL,Nome_tp_Embal,cd_smart from volume_exp_Aer V
		Join Tipo_Embalagem TE on TE.cd_tp_embal=V.cd_tp_embal
		where num_proc_hea=@Num_Proc
	End
else
	Begin
		select Qtd_Vol_IA VOL,Nome_tp_Embal,cd_smart from volume_imp_Aer V
		Join Tipo_Embalagem TE on TE.cd_tp_embal=V.cd_tp_embal
		where num_proc_hia=@Num_Proc
	End



GO
