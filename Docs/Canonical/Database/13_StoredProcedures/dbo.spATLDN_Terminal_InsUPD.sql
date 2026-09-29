SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alter table Terminal add [Ativo] [bit] NULL
--sp_help Terminal
CREATE Procedure [dbo].[spATLDN_Terminal_InsUPD]
 
	@cd_terminal			varchar(3),
	@nome_Terminal			varChar(30),
	@cd_repart				Char(7),
	@cd_term_ofc			varchar(7),
	@Emails					varchar(MAX),
	@Email_CC				varchar(MAX),
	@Ativo					bit,
	@Cd_Usuario				varchar(6)
	
	
AS
--sp_help Terminal

Begin Transaction

Declare @Tp_Oper_Terminal char(1)

	if not exists(select cd_terminal from terminal where cd_terminal=@cd_terminal)
		Begin											 
			Insert into
				Terminal
					(cd_terminal,nome_Terminal,cd_repart,cd_term_ofc,Email,Email_CC,Cd_Usuario,Dt_Ins,Ativo)
				values
					(@cd_terminal,@nome_Terminal,@cd_repart,@cd_term_ofc,@Emails,@Email_CC,@Cd_Usuario,GETDATE(),@Ativo)					
					Set @Tp_Oper_Terminal = 'I'
		END
	Else
		BEGIN
			Update
				Terminal
				Set				
					nome_Terminal = @nome_Terminal,
					cd_repart = @cd_repart,
					cd_term_ofc = @cd_term_ofc,
					Email = @Emails,
					Email_CC = @Email_CC,
					Cd_Usuario =@Cd_Usuario ,
					Dt_Ins = GETDATE(),
					Ativo = @Ativo
			Where
				cd_terminal = @cd_terminal
				
			Set @Tp_Oper_Terminal = 'A'
		END
	

	insert into Log_Terminal
		(Dt_Ins_Terminal,Cd_Usuario_Terminal,Tp_Oper_Terminal,Cd_Terminal,Nome_Terminal,Cd_Repart,Cd_Term_Ofc,Email,Email_CC,Cd_Usuario,Dt_Ins)
	Values
		(GETDATE(),@cd_usuario,@Tp_Oper_Terminal,@cd_terminal,@nome_Terminal,@cd_repart,@cd_term_ofc,@Emails,@Email_CC,@Cd_Usuario,GETDATE())

	if @@error <> 0
		Begin
			Rollback transaction
			return -1
		End

Commit Transaction

GO
