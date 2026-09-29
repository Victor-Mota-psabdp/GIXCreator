SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE	procedure [dbo].[spVolumeEM_Sel]
	@Processo	varchar(16)			
AS

	Select
		Item_EM,
		Qtd_Vol_EM,
		Nome_Tp_Embal,
		Compr_EM,
		Largura_EM,
		Altura_EM,
		HOU.Peso_Bruto_EM,
		NCM,
		Marca_EM,
		Contra_Marca,
		MAS.Num_Cont_EM Container
	From
		Volume_Exp_Mar	HOU with(nolock)
		Join	Tipo_Embalagem	TE with(nolock) on TE.cd_tp_embal = HOU.cd_tp_embal
		Join	NCM		N  with(nolock) on N.Id_NCM = HOU.Id_NCM
		Left Join Container_Hou_Exp_Mar CH with(nolock) on HOU.Num_Proc_HEM = CH.Num_Proc_HEM and HOU.Item_Cont_EM = CH.Item_Cont_EM   
		Left Join Container_Mas_Exp_Mar MAS with(nolock) on MAS.Num_Proc_MEM = CH.Num_Proc_MEM and MAS.Item_Cont_EM = CH.Item_Cont_EM   
	Where
		HOU.num_proc_HEM=@Processo
	order by
		Item_EM

GO
