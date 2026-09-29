SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE	procedure spVolumeIA_Sel 

@Processo	varchar(16)			

AS

	Select
		Item_IA,
		Qtd_Vol_IA,
		Nome_Tp_Embal,
		Compr_IA,
		Largura_IA,
		Altura_IA,
		Peso_Bruto_IA,
		NCM,
		Marca_IA,
		Contra_Marca
	From
		Volume_Imp_Aer	HOU
	Join	Tipo_Embalagem	TE on TE.cd_tp_embal = HOU.cd_tp_embal
	Join	NCM		N  on N.Id_NCM = HOU.Id_NCM

	Where
		num_proc_HIA=@Processo
	order by
		Item_IA







GO
