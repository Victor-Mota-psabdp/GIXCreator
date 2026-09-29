SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spAlertaPadrao_Docs_Sel] --'IMFMC201102021BR'
(
	@JOB varchar(16)
)
AS
	select 
		right('000' + convert(varchar(3),D.ID_DC),3) + ' - ' + Nome_DC 
	from 
		doc_anexos D
		join tipo_doc_cliente T on T.id_dc = D.id_dc
	where
		num_proc = @JOB
	order by
		1

GO
