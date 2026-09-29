SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[fBusca_NotaFiscalVencidos_Num]
(
@Processo	Varchar(16)
)
RETURNS Varchar(500)
AS  
BEGIN
	Declare @N_TEMP	VarChar(400)
	Declare @TEMP	varchar(400)

	Declare Cur_TEMP cursor for

		Select num_nf_hia
		from vwcta_cte
		where Num_Proc_hia = @Processo and cd_tp_tx in ('srv','BRO')

----------------------------------------------------------------------------
		open Cur_TEMP
			Fetch Next From Cur_TEMP Into @TEMP
			While @@FETCH_STATUS = 0
			Begin
				if @N_TEMP='' or @N_TEMP is Null
					Begin
						Set @N_TEMP=@TEMP
					end
				else
					begin
						set @N_TEMP=@N_TEMP + '; '  + @TEMP
					end
				
				Fetch Next From Cur_TEMP Into @TEMP
			end
		close Cur_TEMP
		deallocate Cur_TEMP 
		
	return @N_TEMP
	
END
GO
