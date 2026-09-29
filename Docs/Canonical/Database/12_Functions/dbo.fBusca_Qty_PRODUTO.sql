SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select atlantis.dbo.fBusca_PRODUTO('EMSUR20090500401')

CREATE FUNCTION [dbo].[fBusca_Qty_PRODUTO] 
(
	@Processo	Varchar(16)
)
RETURNS Varchar(400)
AS  
BEGIN
	Declare @N_GMID	VarChar(400)
	Declare @GMID	varchar(400)

	Declare Cur_GMID cursor for 
		Select convert(varchar(50),SUM(PS.Qty)) from Pedido_Ship PS with(nolock)		
		where PS.Num_Proc = @Processo
		OPTION (HASH JOIN)
----------------------------------------------------------------------------
		open Cur_GMID
			Fetch Next From Cur_GMID Into @GMID
			While @@FETCH_STATUS = 0
			Begin
				if @N_GMID='' or @N_GMID is Null
					Begin
						Set @N_GMID=@GMID
					end
				else
					begin
						set @N_GMID=@N_GMID + '; '  + @GMID
					end
				
				Fetch Next From Cur_GMID Into @GMID
			end
		close Cur_GMID
		deallocate Cur_GMID 
		
	return @N_GMID 
	
END












GO
