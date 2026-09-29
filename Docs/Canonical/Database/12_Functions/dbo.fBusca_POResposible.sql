SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE	FUNCTION [dbo].[fBusca_POResposible]
(
@Processo	Varchar(16)
)
RETURNS Varchar(20)
AS
BEGIN
		declare @Resultado as varchar(20)

		set @Resultado = (select PO_Responsible from Pedido where cd_Pedido=(select top 1 cd_pedido from Pedido_Ship where num_proc=@Processo))

		RETURN @Resultado
END



GO
