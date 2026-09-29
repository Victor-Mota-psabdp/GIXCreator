SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE	procedure [dbo].[spVolumeIM_Sel] --'IMEXC20100801801'

@Processo	varchar(16)			

AS

	Select distinct
		Item_IM,
		Qtd_Vol_IM,
		Nome_Tp_Embal,
		Compr_IM,
		Largura_IM,
		Altura_IM,
		HOU.Peso_Bruto_IM,
		NCM,
		Marca_IM,
		Contra_Marca,
		dbo.fNCM(@Processo) NCM_RPT,
		MAS.Num_Cont_IM Container
	From
		Volume_Imp_Mar	HOU
		Join Tipo_Embalagem	TE on TE.cd_tp_embal = HOU.cd_tp_embal
		Join NCM N on N.Id_NCM = HOU.Id_NCM
		Left Outer Join Container_Hou_Imp_Mar CH on HOU.Num_Proc_HIM = CH.Num_Proc_HIM and HOU.Item_Cont_IM = CH.Item_Cont_IM   
		LEFT Join Container_Mas_Imp_Mar MAS on MAS.Num_Proc_MIM = CH.Num_Proc_MIM and MAS.Item_Cont_IM = CH.Item_Cont_IM   
	Where
		HOU.num_proc_HIM=@Processo
	order by
		Item_IM


GO
