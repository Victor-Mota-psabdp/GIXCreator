SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[spTerminal_Sel]

as
	select 'ALL TERMINALS' nome_terminal
	union all
	select nome_terminal 
		from [dbo].[Terminal]
	where Cd_Terminal <> '0'
	order by nome_terminal
	
GO
