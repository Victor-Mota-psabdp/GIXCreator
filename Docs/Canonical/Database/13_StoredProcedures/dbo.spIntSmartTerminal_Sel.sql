SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


	CREATE Procedure [dbo].[spIntSmartTerminal_Sel]
			@Num_Proc Varchar(16)

	as

	select 
		isnull(Nome_Terminal,'')  Nome_Terminal
	from 
		vwHouse_Imp L with(nolock)
		Join Terminal T with(nolock) on T.cd_terminal=L.cd_terminal
	Where 
		num_proc=@num_proc
union all

select 
		isnull(Nome_Terminal,'')  Nome_Terminal
	from 
		vwHouse_Exp L with(nolock)
		Join Terminal T with(nolock) on T.cd_terminal=L.cd_terminal
	Where 
		num_proc=@num_proc

GO
