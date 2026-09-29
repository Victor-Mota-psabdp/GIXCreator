SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spContainerIM_Sel] 'IMSCH202006001BR'
CREATE	PROCEDURE [dbo].[spContainerIM_Sel]
	@Processo	varchar(16)
As

	Select 
		mas.ITEM_CONT_IM,
		Num_cont_IM,
		Nome_Tp_cont,
		Peso_Bruto_IM,
		Num_lacre_IM,
		Dt_Vcto_Devol_IM,
		Dt_Devol_IM,
		VolumeM3,
		Lacre_02_IM,
		Lacre_03_IM,
		isnull(inspecao,'N') inspecao
	from 
		container_mas_imp_mar MAS with(nolock)
		Left Outer Join Tipo_Container TC with(nolock) on TC.cd_tp_cont=MAS.cd_tp_cont
		Left Outer Join Container_Hou_Imp_Mar HOU with(nolock) on MAS.Num_Proc_MIM = HOU.Num_Proc_MIM and MAS.Item_Cont_IM = HOU.Item_Cont_IM   
	where
		Hou.num_proc_him=@Processo
GO
