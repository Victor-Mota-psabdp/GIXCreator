SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Criado 29-05 - Claudio

--select dbo.fBusca_NotaFiscal_num('EMCSR20090300101')

CREATE function [dbo].[fBusca_NotaFiscal_Num]
(
@Processo	Varchar(16)
)
RETURNS Varchar(500)
AS  
BEGIN
	Declare @N_TEMP	VarChar(400)
	Declare @TEMP	varchar(400)

	Declare Cur_TEMP cursor for

		Select Nota_Fiscal
		from Nota_Cliente with(nolock)
		where Num_Proc = @Processo

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
