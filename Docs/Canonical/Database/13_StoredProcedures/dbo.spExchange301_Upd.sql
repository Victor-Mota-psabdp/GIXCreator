SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Procedure [dbo].[spExchange301_Upd]
		@Num_Proc	Varchar(16),
		@Tipo		Char(1)
AS
/*

	Tios
		L = Levis		

*/
Begin Transaction
	
		
	if @Tipo='L'
		Begin
			update EDI301 set dt_envio=getdate() where num_proc=@Num_PRoc 
			and dt_envio is null
		End

	if @@error <> 0
		Begin

			RollBack Transaction
			return 0
		End

Commit Transaction
GO
