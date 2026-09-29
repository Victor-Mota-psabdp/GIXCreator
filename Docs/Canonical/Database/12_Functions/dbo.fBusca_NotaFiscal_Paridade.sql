SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fBusca_NotaFiscal_Paridade]
(
@Processo	Varchar(16)
)
RETURNS Float
AS  

BEGIN

	Declare @Resultado Float

	Begin
		Set @Resultado=(Select top 1 Paridade from Nota_Cliente with(nolock) where Num_Proc = @Processo and Paridade > 0 )
	End

	Return @Resultado

END

GO
