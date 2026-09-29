SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spAX_Servicos_Sel]

	@cd_grupo varchar(20),
	@cd_tp_tx varchar(6)
as	
	Select
		G.Apelido,
		TT.Nome_tp_tx

	From AX_Servicos AX	with(nolock) 			
		Left join Pessoa G with(nolock) on G.cd_pes=AX.cd_grupo
		Left join Tipo_taxa TT with(nolock)  on TT.cd_tp_tx=AX.cd_tp_tx
	Where
		AX.cd_grupo like @cd_grupo and AX.cd_tp_tx like @cd_tp_tx



GO
