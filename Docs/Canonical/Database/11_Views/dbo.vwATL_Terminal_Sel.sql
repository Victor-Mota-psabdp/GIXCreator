SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alter table Terminal add [Ativo] [bit] NULL
--update Terminal set [Ativo] = 1

--sp_help Terminal
CREATE VIEW [dbo].[vwATL_Terminal_Sel]
AS
	select 
		Cd_Terminal AS Code,Nome_Terminal AS [Terminal Name],t.Cd_Repart [Division],
		t.Cd_Term_Ofc [Official Code],t.Email [Email],t.Email_CC [Copy],
		t.cd_usuario [User Code],U.Nome_Usuario [User Name],
		T.ativo [Enabled]
	from Terminal T with(nolock)
	left join Usuario U on U.Cd_Usuario = T.cd_usuario
	where Cd_Terminal <> '0'


GO
