SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwTipo_NF_Doc_Register_Sel]
AS
select
	A.Cd_Servico		[Service Code],
	A.Item_lei			[Item Lei],
	A.CNAE				[CNAE],
	A.Descricao			[Description],
	A.cd_usuario		[User Code],
	US.Nome_Usuario		[User Name],
	A.dt_ins			[Insert Date],
	A.Desativada		[Disabled],
	A.Cd_Site			[Site Code],
	S.Nome_Site			[Site Name]
from Tipo_NF_Doc_Register A with(nolock) 
	Join Site S with(nolock) on S.Cd_Site = A.Cd_Site	
	left join Usuario US with(nolock) on US.Cd_Usuario = A.Cd_Usuario	



GO
