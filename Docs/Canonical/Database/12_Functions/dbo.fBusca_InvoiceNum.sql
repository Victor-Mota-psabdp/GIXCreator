SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--select * from
--update invoice_cliente
--set status='Created'
--where num_proc='EMCSR20080214101'


--select dbo.fBusca_InvoiceNum ('EMCSR20080200101')

CREATE		FUNCTION [dbo].[fBusca_InvoiceNum]
(
@Processo	Varchar(16)
)
RETURNS Varchar(400) 
AS  
BEGIN 
		Declare @N_INV	VarChar(400)
		Declare @INV	varchar(400) 


		Declare Cur_INV cursor for 
			select 
				Num_Invoice
			from
				INVOICE_CLIENTE with(nolock)
			Where
				Num_Proc=@Processo
			group by
				Num_Invoice
----------------------------------------------------------------------------
		open Cur_INV
			Fetch Next From Cur_INV Into @INV
			While @@FETCH_STATUS = 0
			Begin
				if @N_INV='' or @N_INV is Null
					Begin
						Set @N_INV=@INV
					end
				else
					begin
						set @N_INV=@N_INV + '; '  + @INV
					end
				
				Fetch Next From Cur_INV Into @INV
			end
		close Cur_INV
		deallocate Cur_INV 
		
	return @N_INV
	
END






GO
