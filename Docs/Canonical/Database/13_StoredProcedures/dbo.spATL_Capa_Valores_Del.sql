SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[spATL_Capa_Valores_Del]
		@Num_Proc				Varchar(16)
as
Begin Transaction

	Begin
		Delete
			atl_capa_valores
		Where
			Num_Proc=@num_proc
	End
	
	if @@error <> 0 
		Begin
			Rollback transaction
			return -1
		end
commit transaction

GO
