SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



Create Procedure spBuscaProcessoPOModal_Sel

		@Numero_Po	Varchar(50),
		@id_dc		int

AS

Begin
	SELECT 
			NUM_PROC_HIM JOB
	FROM
			PO_HIM
	WHERE
			Numero_po_him =@numero_po and id_dc=@id_dc

union

	SELECT 
			NUM_PROC_HIA JOB
	FROM
			PO_HIA
	WHERE
			Numero_po_hiA =@numero_po and id_dc=@id_dc

UNION


	SELECT 
			NUM_PROC_HIO JOB
	FROM
			PO_HIO
	WHERE
			Numero_po_hiO =@numero_po and id_dc=@id_dc

END
GO
