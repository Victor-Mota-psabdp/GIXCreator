SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE	PROCEDURE [dbo].[spBR_HBL_IM_Container_Sel]
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
		TCC.Nome_Tp_Carga,
		NG.Descr					Packages_GOODS,
		HOU.Obs_HIM					Marks_Numbers,
		HOU.Peso_Bruto_HIM			Gross_Weight,
		HOU.Peso_Liquido_HIM		Net_Weight,
		convert(varchar(10),LLP.Dt_Impres_LIM,103) Dated_At,
		[dbo].[Qty_Container](@processo) qtde
	from 
		container_mas_imp_mar MAS
		Left Outer Join Tipo_Container TC on TC.cd_tp_cont=MAS.cd_tp_cont
		Left Outer Join Container_Hou_Imp_Mar CHOU on MAS.Num_Proc_MIM = CHOU.Num_Proc_MIM and MAS.Item_Cont_IM = CHOU.Item_Cont_IM   
		left outer join house_imp_mar HOU on HOU.num_proc_HIM = CHOU.Num_Proc_HIM
		Left Outer Join LLP_imp_mar LLP on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
		Left Outer Join Tipo_Carga TCC on LLP.Cd_Tp_Carga = TCC.Cd_Tp_Carga and TCC.Ativo_TP = 'S'
		Left Outer Join Nature_Goods NG on HOU.num_proc_HIM = NG.Num_proc  
	where
		CHou.num_proc_him=@Processo







GO
