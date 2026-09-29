SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
 --SELECT [dbo].[fBusca_UoM_ALL]('IMSWB201907001BR','UOM')   
CREATE function [dbo].[fBusca_Qty_ALL]  
(  
 @Processo varchar(16),  
 @Campo  varchar(15)  
)  
  
RETURNS Varchar(400)  
AS    
BEGIN  
  
 --Declare @DOC varchar(400)   
 --select @DOC = COALESCE(@DOC + ';','') +  PD.UOM from Pedido_Det PD  
 --  join Pedido_Ship PS on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto  
 --  where PS.num_proc = @Processo  
 --return @DOC  
   
 Declare @N_GMID VarChar(400)  
 Declare @GMID varchar(400)  
  
 Declare Cur_GMID cursor for   
	SELECT convert(numeric(25,10),PD.Qty)
	FROM Pedido_Det PD (NOLOCK)
	INNER JOIN Pedido_Ship PS (NOLOCK)
		on PS.Cd_Pedido = PD.Cd_Pedido 
		and PS.Cd_Produto = PD.Cd_Produto 
	WHERE PS.num_proc = @Processo  
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
      set @N_GMID=@N_GMID + ' - '  + @GMID  
     end  
      
    Fetch Next From Cur_GMID Into @GMID  
   end  
  close Cur_GMID  
  deallocate Cur_GMID   
    
 return @N_GMID  
   
END  
  
  
  
  
  
GO
