SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create FUNCTION [dbo].[fBusca_ListUsuario]
(
@Cd_Usuario	Varchar(6)
)
RETURNS Varchar(300)
as
BEGIN
Declare @N_CONT	VarChar(300)
	Declare @CONT	varchar(300) 
set @N_CONT=''
Declare Cur_CONT cursor for 
	select distinct  [Nome_Usuario] from Usuario with(nolock) where Ck_Ativo = 1 and Cd_Usuario=@Cd_Usuario
	open Cur_CONT
			
				Fetch Next From Cur_CONT Into @CONT
			While @@FETCH_STATUS = 0
			Begin
				if @N_CONT='' or @N_CONT is Null
					Begin
						Set @N_CONT=@CONT
					end
				else
					begin
						set @N_CONT=@N_CONT + '; '  + @CONT
					end
				
				Fetch Next From Cur_CONT Into @CONT
			end
		close Cur_CONT
		deallocate Cur_CONT 
		
	return @N_CONT
END
GO
