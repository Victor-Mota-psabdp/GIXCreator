SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fBusca_Pedido_Ship_Item]
(
@Processo	Varchar(16)
)
RETURNS Varchar(400)
AS  
BEGIN
	Declare @N_NUM	VarChar(400)
	Declare @NUM	varchar(400)

		Begin
			Declare Cur_NUM cursor for 
			Select distinct convert(varchar(25),convert(int,PS.Item)) from Pedido_Ship PS
			Join Pedido	P	on PS.Cd_Pedido = P.Cd_Pedido
			where PS.Num_Proc = @Processo
		End
----------------------------------------------------------------------------
		open Cur_NUM
			Fetch Next From Cur_NUM Into @NUM
			While @@FETCH_STATUS = 0
			Begin
				if @N_NUM='' or @N_NUM is Null
					Begin
						Set @N_NUM=@NUM
					end
				else
					begin
						set @N_NUM=@N_NUM + '-'  + @NUM
					end
				
				Fetch Next From Cur_NUM Into @NUM
			end
		close Cur_NUM
		deallocate Cur_NUM 
		
	return @N_NUM
	
END









GO
