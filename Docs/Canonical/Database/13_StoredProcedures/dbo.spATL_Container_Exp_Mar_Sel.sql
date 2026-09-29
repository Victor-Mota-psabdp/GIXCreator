SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SELECT * FROM Container_HOU_Exp_Mar
--sp_help Container_HOU_Exp_Mar
--SELECT * FROM Container_MAS_Exp_Mar
--sp_help Container_MAS_EXp_Mar

CREATE PROCEDURE [dbo].[spATL_Container_Exp_Mar_Sel]
(
	@Num_Proc	varchar(16),
	@Num_cont	varchar(15),
	@Tipo		char(1)
)
As

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		Select 
			HOU.Num_Proc_HEM		[JOB],
			MAS.Item_Cont_EM		[Item],
			Mas.Cd_Tp_Cont			[Container Type Code],
			TC.Nome_Tp_Cont			[Container Type Name],
			MAS.Num_cont_EM			[Container Number],
			MAS.Num_lacre_EM		[Seal Number],
			MAS.Dt_Vcto_Devol_EM	[Exp. Del. Date],
			MAS.Dt_Est_Devol_EM		[Return Date],
			MAS.Lacre_02_EM			[Seal 2 Number],
			MAS.Lacre_03_EM			[Seal 3 Number],
			MAS.Lacre_04_EM			[Seal 4 Number],
			MAS.Peso_Bruto_EM		[Gross Weight],
			MAS.VolumeM3			[Volume],
			MAS.ID_ISO				[Id ISO],
			MAS.Tara_EM				[Tare],	
			Peso_Liquido_EM			[Net Weight],			
			Temperature				[Temperature],
			Graus					[Graus],
			Battery_Time			[Battery Time],
			Vent_Status				[Vent Status],		
			Cd_Tp_Volt				[Cd_Tp_Volt]				
	from 
		container_mas_exp_mar MAS with(nolock)
		Left Join Tipo_Container TC with(nolock) on TC.cd_tp_cont=MAS.cd_tp_cont
		Left Join Container_Hou_Exp_Mar HOU with(nolock) on MAS.Num_Proc_MEM = HOU.Num_Proc_MEM and MAS.Item_Cont_EM = HOU.Item_Cont_EM    
		where
			Hou.Num_Proc_HeM=@Num_Proc		
	End
	
if @Tipo = 'C' or @Tipo = 'D'
	Begin
		Select 
			HOU.Num_Proc_HEM		[JOB],
			MAS.Item_Cont_EM		[Item],
			Mas.Cd_Tp_Cont			[Container Type Code],
			TC.Nome_Tp_Cont			[Container Type Name],
			MAS.Num_cont_EM			[Container Number],
			MAS.Num_lacre_EM		[Seal Number],
			MAS.Dt_Vcto_Devol_EM	[Exp. Del. Date],
			MAS.Dt_Est_Devol_EM		[Return Date],
			MAS.Lacre_02_EM			[Seal 2 Number],
			MAS.Lacre_03_EM			[Seal 3 Number],
			MAS.Lacre_04_EM			[Seal 4 Number],
			MAS.Peso_Bruto_EM		[Gross Weight],
			MAS.VolumeM3			[Volume],
			MAS.ID_ISO				[Id ISO],
			MAS.Tara_EM				[Tare],	
			Peso_Liquido_EM			[Net Weight],			
			Temperature				[Temperature],
			Graus					[Graus],
			Battery_Time			[Battery Time],
			Vent_Status				[Vent Status],		
			Cd_Tp_Volt				[Cd_Tp_Volt]				
	from 
		container_mas_exp_mar MAS with(nolock)
		Left Join Tipo_Container TC with(nolock) on TC.cd_tp_cont=MAS.cd_tp_cont
		Left Join Container_Hou_Exp_Mar HOU with(nolock) on MAS.Num_Proc_MEM = HOU.Num_Proc_MEM and MAS.Item_Cont_EM = HOU.Item_Cont_EM    
		where
			Hou.Num_Proc_HeM=@Num_Proc and replace(MAS.Num_cont_EM,'-','') = replace(@Num_cont,'-','')		
	End

if @Tipo = 'N' --Add em 09/05/2026 - Leandro - Draft BL
	Begin
		Select 
			HOU.Num_Proc_HEM		[JOB],
			MAS.Item_Cont_EM		[Item],
			Mas.Cd_Tp_Cont			[Container Type Code],
			TC.Nome_Tp_Cont			[Container Type Name],
			MAS.Num_cont_EM			[Container Number],
			MAS.Num_lacre_EM		[Seal Number],
			MAS.Dt_Vcto_Devol_EM	[Exp. Del. Date],
			MAS.Dt_Est_Devol_EM		[Return Date],
			MAS.Lacre_02_EM			[Seal 2 Number],
			MAS.Lacre_03_EM			[Seal 3 Number],
			MAS.Lacre_04_EM			[Seal 4 Number],
			MAS.Peso_Bruto_EM		[Gross Weight],
			MAS.VolumeM3			[Volume],
			MAS.ID_ISO				[Id ISO],
			MAS.Tara_EM				[Tare],
	
			Peso_Liquido_EM			[Net Weight],			
			Temperature				[Temperature],
			Graus					[Graus],
			Battery_Time			[Battery Time],
			Vent_Status				[Vent Status],		
			Cd_Tp_Volt				[Cd_Tp_Volt]
				
	from 
		container_mas_exp_mar MAS with(nolock)
		Left Join Tipo_Container TC with(nolock) on TC.cd_tp_cont=MAS.cd_tp_cont
		Left Join Container_Hou_Exp_Mar HOU with(nolock) on MAS.Num_Proc_MEM = HOU.Num_Proc_MEM and MAS.Item_Cont_EM = HOU.Item_Cont_EM   
	where
		Hou.num_proc_hem=@Num_Proc
		
	End
GO
