SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spEmixBuscaRetorno_DUE_Sel]

AS

select 
	C.id_consulta_tipo,
	C.id_parametro_grupo,
	C.num_proc,
	XML_DOC2,
	E.ID ID_XML,
	C.id ID_Envio  
from E_MIX_XML E with(nolock)
	Join E_Mix_Consulta C with(nolock) on C.id=E.ID 
	left join vwALL_JOBs V with(nolock) on V.Num_Proc = C.num_proc
Where 
	Dt_retorno is null 
	and Dt_Envio is not null
	and C.id_consulta_tipo in (31)
	and E.num_proc in ('EMOXT202010001BR','EMOXT202010002BR')
order by 1,3
	
OPTION(HASH JOIN)


GO
