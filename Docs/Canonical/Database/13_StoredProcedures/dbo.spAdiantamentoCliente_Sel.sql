SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE	PROCEDURE [dbo].[spAdiantamentoCliente_Sel] --'EAFMC20080900101',612
	@Processo 	varchar(16),
	@ID			int
AS
	SELECT
		AC.ID, POC, dbo.fBusca_Docs_PO_Modal(@Processo,3) SalesOrder, dbo.fBusca_Docs_PO_Modal(@Processo,1) PO, AC.Dt_Solicitacao, sum(ACD.Valor * isnull(Paridade,1)) Total
--		Preco_unit, quantidade
	FROM
		Adiantamento_Cliente AC
		Left Join Adiantamento_Cliente_Det ACD on ACD.ID = AC.ID and ACD.Conta='B'
	WHERE 
		AC.Num_Proc = @Processo and AC.ID=@ID 
	GROUP BY
		AC.ID, AC.Dt_Solicitacao, POC




GO
