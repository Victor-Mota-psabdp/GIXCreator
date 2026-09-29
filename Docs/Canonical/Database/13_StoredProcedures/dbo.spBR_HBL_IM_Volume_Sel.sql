SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spBR_HBL_IM_Volume_Sel] 
	@Processo	varchar(16)			
AS

	Select distinct
		
		Qtd_Vol_IM,
		Nome_Tp_Embal,		
		NCM,						
		MAS.cd_tp_cont					tipoCC,
		NG.Descr					Packages_GOODS
	From
		Volume_Imp_Mar	HOU
		Join Tipo_Embalagem	TE on TE.cd_tp_embal = HOU.cd_tp_embal
		Join NCM N on N.Id_NCM = HOU.Id_NCM
		left join Nature_Goods NG on ng.num_proc = hou.num_proc_him
		Left Join Container_Hou_Imp_Mar CH on HOU.Num_Proc_HIM = CH.Num_Proc_HIM and HOU.Item_Cont_IM = CH.Item_Cont_IM   
		LEFT Join Container_Mas_Imp_Mar MAS on MAS.Num_Proc_MIM = CH.Num_Proc_MIM and MAS.Item_Cont_IM = CH.Item_Cont_IM   
	Where
		HOU.num_proc_HIM=@Processo
	

GO
