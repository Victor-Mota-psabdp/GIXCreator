SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE	FUNCTION [dbo].[fBusca_GMID_BO]
(
@Pedido	Varchar(16)
)
RETURNS Varchar(400)
AS  
BEGIN
	Declare @N_GMID	VarChar(400)
	Declare @GMID	varchar(400)

	Declare Cur_GMID cursor for 
		Select distinct DPP.GMID from Pedido P
		Join Pedido_Det PD  on P.Cd_Pedido = PD.Cd_Pedido
		Join De_Para_Produto DPP on PD.Cd_Produto = DPP.GMID
		where P.Cd_Pedido = @Pedido
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
