SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spTeminal_InsUPD]
 
	@cd_terminal			varchar(3),
	@nome_Terminal			varChar(30),
	@cd_repart				Char(7),
	@cd_term_ofc			varchar(7)
	
AS


Begin Transaction
	
	if not exists(select cd_terminal from terminal where cd_terminal=@cd_terminal)
		Begin
			Insert into
				Terminal
					(
						cd_terminal,
						nome_Terminal,
						cd_repart,
						cd_term_ofc
					)
				values
					(
						@cd_terminal,
						@nome_Terminal,
						@cd_repart,
						@cd_term_ofc
					)
		end
	Else
		Begin
			Update
				Terminal
				Set				
					nome_Terminal = @nome_Terminal,
					cd_repart = @cd_repart,
					cd_term_ofc = @cd_term_ofc
			Where
				cd_terminal = @cd_terminal
		End
	


	if @@error <> 0
		Begin
			Rollback transaction
			return -1
		End

Commit Transaction


GO
