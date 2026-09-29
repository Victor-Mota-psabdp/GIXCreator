SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwAlerta_Ocorrencia_Sel]
AS

	select
		A.cd_Tp_Ocor		[Type Of Occurrence Code],
		T.Nome_Tp_Ocor		[Type Of Occurrence Name],
		A.Cd_Pes_Grupo		[Group Code],
		G.Apelido			[Group Name],
		A.Modal				[Modal Type Code],
		TM.Nome_TP_MODAL	[Modal Type Name],
		A.Emails			[Emails],
		A.ResponderPara		[Reply To],
		A.Assunto			[Subject],
		A.cd_usuario		[User Code],
		US.Nome_Usuario		[User Name],
		A.dt_ins			[Insert Date],
		A.Ativo				[Enabled]
	from Alerta_Ocorrencia A with(nolock) 
		Join tipo_ocorrencia T with(nolock) on T.Cd_Tp_Ocor = A.Cd_Tp_Ocor
		join Pessoa G with(nolock) on  G.cd_pes = A.Cd_Pes_Grupo
		join Usuario US with(nolock) on US.Cd_Usuario = A.Cd_Usuario
		join Tipo_Modal_Imp_Exp TM with(nolock) on TM.CD_TP_MODAL = A.Modal		

GO
