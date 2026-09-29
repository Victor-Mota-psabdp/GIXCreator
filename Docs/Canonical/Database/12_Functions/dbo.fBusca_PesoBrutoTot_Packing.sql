SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--select dbo.fBusca_PesoBrutoTOT_Packing('2381')

CREATE	FUNCTION [dbo].[fBusca_PesoBrutoTot_Packing] 
(
@ID_INV	int
)
RETURNS char(50)
AS  
BEGIN
	Declare @N_ID	VarChar(400)
	Declare @ID	varchar(400)

	Declare Cur_ID cursor for 
		select 
			sum(peso_bruto) Peso_bruto
		from 
			invoice_det 
		where 
			id_inv = @ID_INV


----------------------------------------------------------------------------
		open Cur_ID
			Fetch Next From Cur_ID Into @ID
			While @@FETCH_STATUS = 0
			Begin
				if @N_ID='' or @N_ID is Null
					Begin
						Set @N_ID=@ID
					end
				else
					begin
						set @N_ID=@N_ID + @ID
					end
				
				Fetch Next From Cur_ID Into @ID
			end
		close Cur_ID
		deallocate Cur_ID 
		
	return replace(@N_ID, '.', ',')
	
END



















GO
