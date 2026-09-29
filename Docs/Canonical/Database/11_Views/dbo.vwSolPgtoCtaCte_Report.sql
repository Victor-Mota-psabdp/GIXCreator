SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwSolPgtoCtaCte_Report]
AS
SELECT		I.ID, 
			I.Num_Proc, 
			I.Cd_Tp_Tx, 
			I.DC, 
			I.Cd_Tp_Moeda, 
			I.Vlr_Ref, 
			I.Vlr_Pgto_Rcto, 
			I.Par_Moeda, I.Num_proc_master,
			U.Nome_Usuario			
FROM        dbo.sol_pgto_cta_cte AS S 
			INNER JOIN dbo.sol_pgto_cta_cte_item AS I ON I.ID = S.ID
			INNER JOIN dbo.Usuario AS U ON U.Cd_Usuario = S.Cd_Solicitante
                      
WHERE     (S.Status <> 0) 
		AND (Status_Aprovacao = 'A')




GO
