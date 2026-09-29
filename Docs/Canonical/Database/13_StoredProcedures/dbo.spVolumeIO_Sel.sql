SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE	procedure spVolumeIO_Sel 

@Processo	varchar(16)			

AS

	Select
		Item_IO,
		Qtd_Vol_IO,
		Nome_Tp_Embal,
		Compr_IO,
		Largura_IO,
		Altura_IO,
		Peso_Bruto_IO,
		NCM,
		Marca_IO,
		Contra_Marca
	From
		Volume_Imp_OUT	HOU
	Join	Tipo_Embalagem	TE on TE.cd_tp_embal = HOU.cd_tp_embal
	Join	NCM		N  on N.Id_NCM = HOU.Id_NCM

	Where
		num_proc_HIO=@Processo
	order by
		Item_IO








GO
