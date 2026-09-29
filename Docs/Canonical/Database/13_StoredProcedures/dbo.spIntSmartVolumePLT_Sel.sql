SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[spIntSmartVolumePLT_Sel]
		@num_proc varchar(16),
		@Num_Cont	varchar(50)
AS

if left(@Num_Proc,2)='IM'
	Begin
		select isnull(sum(Qtd_Vol_IM),0) QTD from dbo.Volume_Imp_Mar VL with(nolock)
			Left Join Container_Hou_Imp_MAR CH with(nolock) on CH.num_proc_him=VL.num_proc_him
			LEft Join Container_Mas_Imp_mar CM with(nolock) on ch.num_proc_mim=cm.num_proc_mim and CH.item_Cont_im=ch.item_Cont_im
		Where
			(num_cont_im=@Num_Cont or vl.item_Cont_im is null)
			and VL.num_proc_him=@Num_Proc
			and cd_tp_embal='4'

	END

if left(@Num_Proc,2)='EM'
	Begin
		select sum(Qtd_Vol_EM) QTD from dbo.Volume_Exp_Mar VL with(nolock)
			Left Join Container_Hou_exp_MAR CH with(nolock) on CH.num_proc_hem=VL.num_proc_hem
			LEft Join Container_Mas_exp_mar CM with(nolock) on ch.num_proc_mem=cm.num_proc_mem and CH.item_Cont_em=CM.item_Cont_em
		Where
			(num_cont_em=@Num_Cont or vl.item_Cont_em is null)
			and VL.num_proc_hem=@Num_Proc
			and cd_tp_embal='4'
	END





GO
