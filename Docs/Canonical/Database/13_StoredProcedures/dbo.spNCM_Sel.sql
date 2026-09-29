SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spNCM_Sel] 
(
	@NCM VarChar(8)
)
AS
 
    Select NCM, Descricao_NCM, Alterado,Vencimento,Excecao from NCM where NCM = @NCM



GO
