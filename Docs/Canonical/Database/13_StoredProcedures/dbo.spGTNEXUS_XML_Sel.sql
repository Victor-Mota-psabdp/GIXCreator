SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spGTNEXUS_XML_Sel]
(
	@Type VARCHAR(2)
)
AS

	select 
		id_smart,num_proc, xml_doc, nome_arquivo 
	from 
		GTNEXUS_XML S
	where 
		dt_envio is null 
		AND s.Type = @Type
GO
