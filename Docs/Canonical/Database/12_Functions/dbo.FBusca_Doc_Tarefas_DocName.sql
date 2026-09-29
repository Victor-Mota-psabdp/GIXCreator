SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[FBusca_Doc_Tarefas_DocName]
(
	@ID int
)
RETURNS Varchar(MAX)
AS  
BEGIN 
	Declare @N_CONT	VarChar(MAX)
	Declare @CONT	varchar(MAX) 

	declare @Tab2 table (item varchar(1000))
	declare @Parametros varchar(max)
	set @Parametros = (select ID_DC from Doc_Tarefas where ID = @ID)
	begin
		insert @Tab2
		select replace(item,'''','') from dbo.fSplit(@Parametros,',')	
	end

	Declare Cur_CONT cursor for 
		select right('000'+cast(TD.ID_DC as varchar),3) + ' - ' + TD.Nome_DC from Tipo_Doc_Cliente TD with(nolock) 
			join @Tab2 T on T.item = TD.ID_DC
----------------------------------------------------------------------------
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
