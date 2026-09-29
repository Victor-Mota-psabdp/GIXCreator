SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spATL_Container_Infineum_Rel] 'IMIFB202601049BR'
CREATE	PROCEDURE [dbo].[spATL_Container_Infineum_Rel]
	@Processo	varchar(16)
As

Select 
		MAS.Num_cont_IM			[CONTAINER],
		TC.Nome_Tp_Cont			[TIPO CONTAINER],
		MAS.Num_lacre_IM		[LACRE],
		MAS.Lacre_02_IM			[LACRE 2],
		MAS.Lacre_03_IM			[LACRE 3],
		''						[NET WEIGHT],
		MAS.Peso_Bruto_IM		[GROSS WEIGHT],
		VIM.Qtd_Vol_IM			[QUANTIDADE],
		TE.Nome_Tp_Embal		[TIPO]
		
		
 
	from 
		container_mas_imp_mar MAS with(nolock)
		Left Outer Join Tipo_Container TC with(nolock) on TC.cd_tp_cont=MAS.cd_tp_cont
		Left Outer Join Container_Hou_Imp_Mar HOU with(nolock) on MAS.Num_Proc_MIM = HOU.Num_Proc_MIM and MAS.Item_Cont_IM = HOU.Item_Cont_IM   
		Left Outer Join	Volume_Imp_Mar VIM with(nolock) on VIM.Num_Proc_HIM = HOU.Num_Proc_HIM
		Left Join Tipo_Embalagem TE with(nolock) on TE.Cd_Tp_Embal = VIM.Cd_Tp_Embal  
	where
	Hou.num_proc_him=@Processo
		--Hou.num_proc_him='IMIFB202601049BR'
GO
