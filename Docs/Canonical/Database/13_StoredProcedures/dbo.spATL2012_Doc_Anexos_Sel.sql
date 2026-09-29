SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from Doc_Anexos_Div where id_tipo_Doc = '1'
--select * from doc_anexos

CREATE Procedure [dbo].[spATL2012_Doc_Anexos_Sel]--'IMATL201109009BR' 
	
	@cd_prod	int,
	@id_tipo_doc int

AS	
	Select
		right('000' + convert(varchar(3),Item_Doc),3) [Item],
		TD.Nome_DC [Type DOC],
		convert(varchar(12),Dt_Anexo,103) [Sent Date],
		Nome_Arquivo [File],
		'Saved'	[Status]		
 	from 
		Doc_Anexos_div DA  With(nolock)
		Join Tipo_Doc_Cliente TD with(nolock) on TD.Id_DC = DA.Id_DOC

	where 
		cd_prod = @cd_prod and id_tipo_doc = @id_tipo_doc

	order by 1




GO
