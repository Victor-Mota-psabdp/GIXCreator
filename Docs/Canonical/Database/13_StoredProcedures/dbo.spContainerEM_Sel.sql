SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spContainerEM_Sel]--'EMOXT20101103801'
	@Processo	varchar(16)
as
	Select 
		Mas.Item_Cont_EM,
		Num_cont_EM,
		Nome_Tp_cont,
		Peso_Bruto_EM,
		Peso_Liquido_EM,
		Num_lacre_EM,
		VolumeM3,
		Tara_em,
		Lacre_02_EM,
		Lacre_03_EM,
		[Temperature],
		[Graus],
		[Battery_Time],
		[Vent_Status],		
		[Cd_Tp_Volt],
		Dt_Vcto_Devol_EM,
		Dt_Est_Devol_EM	
	from 
		container_mas_exp_mar MAS with(nolock)
		Left Join Tipo_Container TC with(nolock) on TC.cd_tp_cont=MAS.cd_tp_cont
		Left Join Container_Hou_Exp_Mar HOU with(nolock) on MAS.Num_Proc_MEM = HOU.Num_Proc_MEM and MAS.Item_Cont_EM = HOU.Item_Cont_EM   
	where
		Hou.num_proc_hem=@Processo
		
		

		


GO
