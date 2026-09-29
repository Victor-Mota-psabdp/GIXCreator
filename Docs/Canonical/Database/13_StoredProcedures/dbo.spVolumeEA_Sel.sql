SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE	procedure [dbo].[spVolumeEA_Sel]--'EAROB20110100701'

@Processo	varchar(16)			

AS

	Select
		Item_EA,
		Qtd_Vol_EA,
		Nome_Tp_Embal,
		Compr_EA,
		Largura_EA,
		Altura_EA,
		Peso_Bruto_EA,
		NCM,
		Marca_EA,
		Contra_Marca
	From
		Volume_Exp_Aer	HOU
	Join	Tipo_Embalagem	TE on TE.cd_tp_embal = HOU.cd_tp_embal
	Join	NCM		N  on N.Id_NCM = HOU.Id_NCM

	Where
		num_proc_HEA=@Processo
	order by
		Item_EA








GO
