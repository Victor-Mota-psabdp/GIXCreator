SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spDadosNotaFiscalBR_Sel '146986','A'
CREATE PROCEDURE [dbo].[spDadosNotaFiscalBR_Sel]--'A','55377'

	@Numero		varchar(8),
	@Tipo		char(1)
AS
/* -------------------------------------------------------------------------------------------------------------------------
HISTORY CHANGE
. Date:			10/03/2020
. Business:		Tiago Tadeu (Tiago.Alves@bdpint.com)
. Dept:			Faturamento
. Developer:	Alessandra Suzuki Mariano
. Ticket:		100-202788	
. Request:		Automatic Nota Fiscal integration at ATL system
-------------------------------------------------------------------------------------------------------------------------
EXECUTION 
exec spDadosNotaFiscalBR_Sel '146986','A'
-------------------------------------------------------------------------------------------------------------------------
*/  

	SELECT     
		NUM_PROC,
		RPS_NFE
	FROM		dbo.Fatura_ARG			F	(NOLOCK)
	INNER JOIN	dbo.Fatura_ARG_Det		FD  (NOLOCK) 
		ON F.ID_Fat = FD.ID_Fat 
	INNER JOIN	dbo.Base_Nota_Fiscal	B  (NOLOCK)
		ON F.Numero = B.Nota_Fiscal 
		AND F.Codigo = B.Ref_Acesso  
	WHERE 
		Nota_Fiscal = @Numero 
		AND Ref_Acesso= @Tipo
	  


GO
