SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fBusca_Volume_Mar]
(
	@Num_Proc	Varchar(16),
	@Num_Cont	varchar(50)
)
RETURNS Varchar(400)
AS  
BEGIN 
	Declare @N_VOL	VarChar(400) 


	if left(@Num_Proc,2)='IM'
		set @N_VOL = (select convert(varchar(30),isnull(sum(Qtd_Vol_IM),0)) QTD from dbo.Volume_Imp_Mar VL with(nolock)
				Left Join Container_Hou_Imp_MAR CH with(nolock) on CH.num_proc_him=VL.num_proc_him and VL.item_Cont_im=CH.item_cont_im
				LEft Join Container_Mas_Imp_mar CM with(nolock) on ch.num_proc_mim=cm.num_proc_mim and CH.item_Cont_im=ch.item_Cont_im
			Where
				(num_cont_im=@Num_Cont or vl.item_Cont_im is null)
				and VL.num_proc_him=@Num_Proc)

		

	if left(@Num_Proc,2)='EM'		
			set @N_VOL = (select convert(varchar(30),sum(Qtd_Vol_EM)) QTD from dbo.Volume_Exp_Mar VL with(nolock)
				Left Join Container_Hou_exp_MAR CH with(nolock) on CH.num_proc_hem=VL.num_proc_hem
				LEft Join Container_Mas_exp_mar CM with(nolock) on ch.num_proc_mem=cm.num_proc_mem and CH.item_Cont_em=CM.item_Cont_em
			Where
				(num_cont_em=@Num_Cont or vl.item_Cont_em is null)
				and VL.num_proc_hem=@Num_Proc)
		

		
return @N_VOL

END
GO
