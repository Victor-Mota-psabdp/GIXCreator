SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure intSmartContainerM3
		@Num_Proc varchar(16),
		@Container varchar(30)

		as

select 
	VolumeM3 
from  
	container_mas_imp_mar M with(nolock)
	Join Container_Hou_Imp_Mar H WITH(nolock) on H.Num_Proc_MIM=M.Num_Proc_MIM and H.Item_Cont_IM = M.Item_Cont_IM
where
	Num_Proc_HIM = @num_proc and 
	Num_Cont_IM=@Container and 
	VolumeM3 is not null 

UNION ALL

select 
	VolumeM3 
from  
	container_mas_exp_mar M with(nolock)
	Join Container_Hou_exp_Mar H on H.Num_Proc_MEM=M.Num_Proc_MEM and H.Item_Cont_EM = M.Item_Cont_EM
where
	Num_Proc_HEM = @num_proc and 
	Num_Cont_EM=@Container and 
	VolumeM3 is not null 

GO
