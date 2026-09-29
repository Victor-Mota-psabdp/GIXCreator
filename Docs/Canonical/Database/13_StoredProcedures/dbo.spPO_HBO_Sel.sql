SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spPO_HBO_Sel]--'BOOXT201602001BR'

	@Processo 	varchar(16)

AS

Select 
	'Saved',
	right('000' + Convert(varchar(3),ID_PO_HBO),3) Item, 
	Numero_PO_HBO, 
	convert(varchar(10),Data_PO_HBO,103), 
	right('000' + convert(varchar(3),T.Id_DC),3),
	--right('000' + convert(varchar(3),T.Id_DC),3) + '-' + T.nome_DC NomeDoc,
	T.nome_DC NomeDoc
From 
	PO_HBO PO
	join Tipo_Doc_Cliente T on T.ID_DC =PO.ID_DC
WHERE 
	PO.Num_Proc_HBO =  @Processo
ORDER BY
	1
	


GO
