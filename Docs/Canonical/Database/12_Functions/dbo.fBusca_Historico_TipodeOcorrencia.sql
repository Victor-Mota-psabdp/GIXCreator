SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fBusca_Historico_TipodeOcorrencia]
(
	@Processo varchar(16),	
	@Tipo	int
)

RETURNS Varchar(1000)
AS  
BEGIN 
	Declare @N_CONT	VarChar(400)
	Declare @CONT	varchar(400) 

	Declare Cur_CONT cursor for 
     	select 'Mensagem: ' + HSDDescricao + ' Data: ' + convert(varchar(10),hsgData,103) from hist_geral with(nolock)
		where hsgprocesso=@Processo and cd_tp_ocor=@Tipo AND DISP_CLIENTE='N' order by hsgseq desc
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
