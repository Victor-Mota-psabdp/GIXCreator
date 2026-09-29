SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Criado 29-05 - Claudio

--select dbo.fBusca_NotaFiscal_Emissao('IMCSR20080321401')

CREATE function [dbo].[fBusca_NotaFiscal_Emissao]
(
@Processo	Varchar(16)
)
RETURNS Datetime
AS  

BEGIN

	Declare @Resultado Datetime

	Begin
		Set @Resultado=(Select top 1 Emissao from Nota_Cliente with(nolock) where Num_Proc = @Processo)
	End

	Return @Resultado

END

GO
