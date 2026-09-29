SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spEmixXMLParaCadastro_Export_Sel]

	AS


select 
	ID ID_XML,XML_DOC 
From E_MIX_XML with(nolock)
Where 
	Dt_Envio is null --and isnull(Envio_Erro,'') <> ''
	and Left(Num_Proc,1)= 'E'



GO
