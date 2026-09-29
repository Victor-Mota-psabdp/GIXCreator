SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[fBusca_PRODUTO_Produto_Descr]-- 'SLI2016100004'
(
	@Num_Proc	Varchar(16)
)
RETURNS Varchar(5000)
AS  
BEGIN

	Declare @N_Produto	VarChar(5000)
	Declare @Produto	varchar(5000)

	Declare Cur_GMID cursor for 
		--Select PC.cd_Proc_Cliente + ' - '  + PC.Produto_Descr from Pedido_Ship PS with(nolock)
		Select PC.Produto_Descr from Pedido_Ship PS with(nolock)
		Join Produto_Cliente PC with(nolock) on PS.Cd_Produto = PC.Cd_Prod		
		where PS.Num_Proc = @Num_Proc
		--OPTION (HASH JOIN)
----------------------------------------------------------------------------
		open Cur_GMID
			Fetch Next From Cur_GMID Into @Produto
			While @@FETCH_STATUS = 0
			Begin
				if @N_Produto='' or @N_Produto is Null
					Begin
						Set @N_Produto=@Produto
					end
				else
					begin
						set @N_Produto=@N_Produto + '|'  + @Produto
					end
				
				Fetch Next From Cur_GMID Into @Produto
			end
		close Cur_GMID
		deallocate Cur_GMID 
		
	Return @N_Produto 
	
END












GO
