SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spContainer_Imp_Mar_Sel]
(
	@Processo	varchar(16),
	@Tipo		char(1)
)

As

if @Tipo = 'A'  or @Tipo = 'B' 
	Begin
		Select
			HOU.Num_Proc_HIM	Num_Proc, 
			mas.ITEM_CONT_IM	Item_Cont_IM,
			Num_cont_IM			Num_Cont_IM,
			mas.Cd_Tp_Cont		Cd_Tp_Cont,
			TC.Nome_Tp_Cont		Nome_Tp_Cont,
			MAS.Num_lacre_IM,
			MAS.Lacre_02_IM,
			MAS.Lacre_03_IM,		
			MAS.Peso_Bruto_IM,
			MAS.VolumeM3,			
			MAS.Dt_Vcto_Devol_IM,
			MAS.Dt_Devol_IM,
			isnull(inspecao,'N') Inspecao
		from 
			container_mas_imp_mar MAS with(nolock)
			Left Outer Join Tipo_Container TC with(nolock) on TC.cd_tp_cont=MAS.cd_tp_cont
			Left Outer Join Container_Hou_Imp_Mar HOU with(nolock) on MAS.Num_Proc_MIM = HOU.Num_Proc_MIM and MAS.Item_Cont_IM = HOU.Item_Cont_IM   
		where
			Hou.num_proc_him=@Processo
	END
	
if @Tipo = 'C'  or @Tipo = 'D' 
	Begin
		Select
			HOU.Num_Proc_HIM	Num_Proc, 
			mas.ITEM_CONT_IM	Item_Cont_IM,
			Num_cont_IM			Num_Cont_IM,
			mas.Cd_Tp_Cont		Cd_Tp_Cont,
			TC.Nome_Tp_Cont		Nome_Tp_Cont,
			MAS.Num_lacre_IM,
			MAS.Lacre_02_IM,
			MAS.Lacre_03_IM,		
			MAS.Peso_Bruto_IM,
			MAS.VolumeM3,			
			MAS.Dt_Vcto_Devol_IM,
			MAS.Dt_Devol_IM,
			isnull(inspecao,'N') Inspecao
		from 
			container_mas_imp_mar MAS with(nolock)
			Left Outer Join Tipo_Container TC with(nolock) on TC.cd_tp_cont=MAS.cd_tp_cont
			Left Outer Join Container_Hou_Imp_Mar HOU with(nolock) on MAS.Num_Proc_MIM = HOU.Num_Proc_MIM and MAS.Item_Cont_IM = HOU.Item_Cont_IM   
		where
			Hou.num_proc_him=@Processo
	END

GO
