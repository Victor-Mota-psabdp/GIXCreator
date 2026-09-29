SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from E_MIX_XML where num_proc like 'E%'
----update  E_MIX_XML set dt_envio = getdate() where num_proc like 'E%'
--select * from E_Mix_Consulta where num_proc like 'E%'

CREATE Procedure [dbo].[spEmixBuscaRetorno_RE_Sel]

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
	left join vwALL_JOBs V  with(nolock) on V.Num_Proc = C.num_proc
Where 
	Dt_retorno is null 
	and Dt_Envio is not null
	and C.id_consulta_tipo in (18)	
	and C.num_proc not in ('EMOXT201702028BR')
	--and c.num_proc = 'EMOXT201709067BR'
order by 1,3
	


GO
