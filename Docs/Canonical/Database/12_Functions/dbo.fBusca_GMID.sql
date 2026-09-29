SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE	FUNCTION [dbo].[fBusca_GMID]
(
@Processo	Varchar(16)
)
RETURNS Varchar(400)
AS  
BEGIN
	Declare @N_GMID	VarChar(400)
	Declare @GMID	varchar(400)

	Declare Cur_GMID cursor for 
		Select distinct isnull(cd_proc_cliente,DPP.GMID) from Pedido_Ship PS with(nolock)
		Join Produto_Cliente PC with(nolock) on PS.Cd_Produto = PC.Cd_Prod
		Left Join De_Para_Produto DPP with(nolock) on PC.Cd_Proc_Cliente = DPP.GMID and DPP.cd_cliente=PC.cd_cliente
		where PS.Num_Proc = @Processo
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
