SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spEmixXMLParaCadastro_Export_Teste_Sel]

	AS
	
	 
select X.ID ID_XML,X.XML_DOC from E_MIX_XML x
	join E_Mix_Consulta e on E.ID = x.ID
	--join Doc_Anexos d on d.Num_Proc = x.Num_Proc and Id_DC =4
where 
	x.id_consulta_tipo IN (18)  and  x.Dt_Retorno > '2017-11-21'
	and Retorno_Erro = 'A consulta para o parâmetro informado no XML não foi cadadstrada no SiscomexNet.'




GO
