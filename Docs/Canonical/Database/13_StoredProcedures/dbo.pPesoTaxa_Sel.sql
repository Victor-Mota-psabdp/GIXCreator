SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pPesoTaxa_Sel    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE pPesoTaxa_Sel 
(
@Peso 		Float
)
 AS
	Select 
		*
	From 
		Peso_taxa 
	Where 
		peso_tx_in <= @Peso and 
		peso_tx_fn > @Peso 



GO
