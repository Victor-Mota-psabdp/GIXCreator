SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Criado 29-05 - Claudio

--select dbo.fBusca_NotaFiscal_CNPJ('IMCSR20080321401')

CREATE function [dbo].[fBusca_NotaFiscal_CNPJ]
(
@Processo	Varchar(16)
)
RETURNS Varchar(20)
AS  

BEGIN

	Declare @Resultado Varchar(20)

	Begin
		Set @Resultado=(Select top 1 CNPJ from Nota_Cliente with(nolock) where Num_Proc = @Processo)
	End

	Return @Resultado

END


GO
