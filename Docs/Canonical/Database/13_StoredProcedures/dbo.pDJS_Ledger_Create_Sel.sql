SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pDJS_Ledger_Create_Sel]
-- Stored responsible to list the transactions to be processed


AS
	SELECT distinct top 1
		AX.ID_AX	ah_pk,
		AX.Tipo AH_Ledger
	FROM Ax_DOC AX
	JOIN AX_Doc_Item Item on ITem.ID_AX = AX.ID_AX
	Where
		AX.Dt_Ins > getdate() -1



GO
