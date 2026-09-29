SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE	procedure spVolumeEO_Sel 

@Processo	varchar(16)			

AS

	Select
		Item_EO,
		Qtd_Vol_EO,
		Nome_Tp_Embal,
		Compr_EO,
		Largura_EO,
		Altura_EO,
		Peso_Bruto_EO,
		NCM,
		Marca_EO,
		Contra_Marca
	From
		Volume_Exp_OUT	HOU
	Left Outer Join	Tipo_Embalagem	TE on TE.cd_tp_embal = HOU.cd_tp_embal
	Left Outer Join	NCM		N  on N.Id_NCM = HOU.Id_NCM

	Where
		num_proc_HEO=@Processo
	order by
		Item_EO










GO
