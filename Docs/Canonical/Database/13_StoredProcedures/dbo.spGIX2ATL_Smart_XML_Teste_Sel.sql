SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spGIX2ATL_Smart_XML_Sel]'11'
CREATE procedure [dbo].[spGIX2ATL_Smart_XML_Teste_Sel]--'11'
(
	 @SystemCode BIGINT
)
as
if @SystemCode = '11'
	BEGIN
		select 
			Smart_XML.ID_Smart		[ID_Smart],
			Smart_XML.Num_Proc		[Num_Proc],
			Smart_XML.XML_DOC		[XML_DOC],
			Smart_XML.Nome_Arquivo	[Nome_Arquivo],
			Smart_XML.Dt_Ins		[Dt_Ins],	
			NULL					[Dt_Envio],
			'' Nome_Local,
			'' Nome_Pais
			from atl_int.dbo.gix_xml Smart_XML with(nolock) where 
			id_req in 
			(select distinct id_req from Pedido_Det_Complementar_Temp_New with(nolock) where Name_Produto is null
			and Dt_Ins > GETDATE() -90)				
			order by 1
	END


GO
