SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spE_MIX_XML_Ins]
	(
		@ID					bigint,
		@Num_Proc			Varchar(16),	
		@id_consulta_tipo	int,	
		@XML_DOC			XML,
		@XML_DOC2			XML,
		@Nome_Arquivo		Varchar(75)
	)
	as
Begin
	Insert E_MIX_XML 
		(ID,Num_Proc,id_consulta_tipo,Dt_Envio,XML_DOC,XML_DOC2,Nome_Arquivo)
	Values
		(@ID,@Num_Proc,@id_consulta_tipo,Null,@XML_DOC,@XML_DOC2,@Nome_Arquivo)
End



GO
