SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------ Container_Imp_Mar --------------
--SELECT * FROM Container_HOU_Imp_Mar
--sp_help Container_HOU_Imp_Mar
--SELECT * FROM Container_MAS_Imp_Mar
--sp_help Container_MAS_Imp_Mar

CREATE PROCEDURE [dbo].[spATL_Container_Imp_Mar_Sel]
(
	@Num_Proc	varchar(16),
	@Num_cont	varchar(15),
	@Tipo		char(1)
)
As

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		Select 
			HOU.Num_Proc_HIM		[JOB],
			MAS.ITEM_CONT_IM		[Item],
			Mas.Cd_Tp_Cont			[Container Type Code],
			TC.Nome_Tp_Cont			[Container Type Name],
			MAS.Num_cont_IM			[Container Number],
			MAS.Num_lacre_IM		[Seal Number],
			--MAS.Dt_Vcto_Devol_IM	[Exp. Del. Date],
			CASE
				  WHEN LTRIM(RTRIM(MAS.Dt_Vcto_Devol_IM)) = '' THEN NULL
				  ELSE LTRIM(RTRIM(MAS.Dt_Vcto_Devol_IM))
			END [Exp. Del. Date],
			MAS.Dt_Devol_IM			[Return Date],
			MAS.Lacre_02_IM			[Seal 2 Number],
			MAS.Lacre_03_IM			[Seal 3 Number],
			MAS.Lacre_04_IM			[Seal 4 Number],
			MAS.Peso_Bruto_IM		[Gross Weight],
			MAS.VolumeM3			[Volume],
			MAS.ID_ISO				[Id ISO],
			MAS.Tara_IM				[Tare],
			isnull(MAS.inspecao,'N')	[Inspection],
			MAS.DataDevCli_IM			[DataDevCli_IM],
			MAS.Dt_Ins					[Insert Date]
		from 
			Container_Mas_Imp_Mar MAS with(nolock)
			Left Outer Join Tipo_Container TC with(nolock) on TC.Cd_Tp_Cont=MAS.Cd_Tp_Cont
			Left Outer Join Container_Hou_Imp_Mar HOU with(nolock) on MAS.Num_Proc_MIM = HOU.Num_Proc_MIM and MAS.Item_Cont_IM = HOU.Item_Cont_IM   
		where
			Hou.Num_Proc_HIM=@Num_Proc
		
	End
	
if @Tipo = 'C' or @Tipo = 'D'
	Begin
		Select 
			HOU.Num_Proc_HIM		[JOB],
			MAS.ITEM_CONT_IM		[Item],
			Mas.Cd_Tp_Cont			[Container Type Code],
			TC.Nome_Tp_Cont			[Container Type Name],
			MAS.Num_cont_IM			[Container Number],
			MAS.Num_lacre_IM		[Seal Number],
			--MAS.Dt_Vcto_Devol_IM	[Exp. Del. Date],
			CASE
				  WHEN LTRIM(RTRIM(MAS.Dt_Vcto_Devol_IM)) = '' THEN NULL
				  ELSE LTRIM(RTRIM(MAS.Dt_Vcto_Devol_IM))
			END [Exp. Del. Date],
			MAS.Dt_Devol_IM			[Return Date],
			MAS.Lacre_02_IM			[Seal 2 Number],
			MAS.Lacre_03_IM			[Seal 3 Number],
			MAS.Lacre_04_IM			[Seal 4 Number],
			MAS.Peso_Bruto_IM		[Gross Weight],
			MAS.VolumeM3			[Volume],
			MAS.ID_ISO				[Id ISO],
			MAS.Tara_IM				[Tare],
			isnull(MAS.inspecao,'N')	[Inspection],
			MAS.DataDevCli_IM			[DataDevCli_IM],
			MAS.Dt_Ins					[Insert Date]
		from 
			Container_Mas_Imp_Mar MAS with(nolock)
			Left Outer Join Tipo_Container TC with(nolock) on TC.Cd_Tp_Cont=MAS.Cd_Tp_Cont
			Left Outer Join Container_Hou_Imp_Mar HOU with(nolock) on MAS.Num_Proc_MIM = HOU.Num_Proc_MIM and MAS.Item_Cont_IM = HOU.Item_Cont_IM   
		where
			Hou.Num_Proc_HIM=@Num_Proc and replace(MAS.Num_cont_IM,'-','') = replace(@Num_cont,'-','') 
		
	End

GO
