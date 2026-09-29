SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Terminal

create Procedure [dbo].[spATL_Terminal_Sel] --'0',''
	@Cd_Terminal varchar(3),
	@Nome_Terminal varchar(30)
as

IF @Nome_Terminal is not NULL and @Nome_Terminal <> ''
	Begin
		SELECT Nome_Terminal FROM Terminal with(nolock) where Nome_Terminal = @Nome_Terminal and Cd_Terminal <> '0'
	End
Else
	Begin
		SELECT Nome_Terminal FROM Terminal with(nolock) where Cd_Terminal = @Cd_Terminal and Cd_Terminal <> '0'	
	End






GO
