SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwPDF2ATL_Group_Sel]
AS
	select
		A.Cd_Pes_Grupo		[Group Code],
		G.Apelido			[Group Name],
		A.Id_Dc				[Client Doc Type Code],
		T.Nome_DC			[Client Doc Type Name],			
		A.CD_TP_MODAL		[Modal Type Code],
		TM.Nome_TP_MODAL	[Modal Type Name],
		A.Origin			[Origin],
		A.cd_usuario		[User Code],
		US.Nome_Usuario		[User Name],
		A.dt_ins			[Insert Date],
		A.Ativo				[Enabled]
	from PDF2ATL_Group A with(nolock) 
		Join Tipo_Doc_Cliente T with(nolock) on T.ID_DC = A.ID_DC
		join Pessoa G with(nolock) on  G.cd_pes = A.Cd_Pes_Grupo
		join Usuario US with(nolock) on US.Cd_Usuario = A.Cd_Usuario
		join Tipo_Modal_Imp_Exp TM with(nolock) on TM.CD_TP_MODAL = A.CD_TP_MODAL

GO
