SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwSolPgtoCtaCteAprovadas]
AS
SELECT		I.ID, 
			I.Num_Proc, 
			I.Cd_Tp_Tx, 
			I.DC, 
			I.Cd_Tp_Moeda, 
			I.Vlr_Ref, 
			I.Vlr_Pgto_Rcto, 
			I.Par_Moeda, I.Num_proc_master
FROM        dbo.sol_pgto_cta_cte AS S INNER JOIN
                      dbo.sol_pgto_cta_cte_item AS I ON I.ID = S.ID
WHERE     (S.Status <> 0) 
		AND (Status_Aprovacao = 'A')



GO
