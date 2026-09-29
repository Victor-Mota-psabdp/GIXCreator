SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fBusca_ListNC]
(
@Num_Proc	Varchar(16)
)
RETURNS Varchar(300)
as
BEGIN
Declare @N_CONT	VarChar(300)
	Declare @CONT	varchar(300) 
set @N_CONT=''
Declare Cur_CONT cursor for 
	select distinct  [ID_NC] from hist_Geral with(nolock) where id_nc is not null and disp_cliente='S' and hsgprocesso=@Num_Proc
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
