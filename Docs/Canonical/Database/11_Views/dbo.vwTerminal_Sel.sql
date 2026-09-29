SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Terminal
CREATE VIEW [dbo].[vwTerminal_Sel]
AS
select Cd_Terminal AS Code,Nome_Terminal AS [Terminal Name], 
		Cd_Repart [Division],	Cd_Term_Ofc [Official Code],Email [Email],Email_CC [Copy]
		from Terminal with(nolock)
		where Cd_Terminal <> '0'
GO
