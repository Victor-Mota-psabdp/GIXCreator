SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spEmixBuscaRetorno_Teste_Sel]

AS

select C.id_consulta_tipo,C.id_parametro_grupo,C.num_proc,XML_DOC2,E.ID ID_XML,C.id ID_Envio  from E_MIX_XML E with(nolock)
Join E_Mix_Consulta C on C.id=E.ID 

Where 
E.num_proc in ('IMGVA201506004BR') 
--and Dt_retorno is null 
--and Dt_Envio is not null 
and E.id_consulta_tipo = 8
order by 1


--<requisicao><retorno>Sua consulta não constou registros!</retorno></requisicao>


GO
