SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_AjustePesoBL_EM_Sel]--'EMVIT201606015BR'
( 
	@Num_Proc as varchar(16)
)

as
Select 
	sum(Peso_Bruto_EM) Peso_Bruto_EM,
	sum(Peso_Liquido_EM) Peso_Liquido_EM,
	sum(VolumeM3) VolumeM3
from Container_Hou_Exp_Mar HOU  with(nolock)
	Join container_mas_exp_mar MAS with(nolock) on MAS.Num_Proc_MEM = HOU.Num_Proc_MEM and MAS.Item_Cont_EM = HOU.Item_Cont_EM   
where
	Hou.num_proc_hem=@Num_Proc
GO
