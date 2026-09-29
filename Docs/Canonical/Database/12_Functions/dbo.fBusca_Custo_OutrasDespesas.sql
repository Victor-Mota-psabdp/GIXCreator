SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  function [dbo].[fBusca_Custo_OutrasDespesas](
@Processo	varchar(16),	
@Cd_Pedido	int,
@Cd_Produto	int
)
RETURNS Float

BEGIN
	Declare @Resultado Float
	

	SET @Resultado=Isnull((select Sum(Vlr_Item_Custo) Custo from custo_cliente With(nolock) where Num_Proc = @Processo and Cd_Pedido= @Cd_Pedido and Cd_Produto=@Cd_Produto and Cd_tp_tx in ('EEL','X2K','XAF','XAI','XDC','XDQ','XDV','XEW','XFR','XGD','XHD','XIP','XLO','XN3','XNJ','XNT','XR6','XSI','XTG','XTM','XWR','146')),0)

	RETURN @Resultado

END

GO
