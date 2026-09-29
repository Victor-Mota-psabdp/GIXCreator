SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--29/09 - retirei os quejá estão fechados id_status < 5
--15/10/2015- Cadu  -JOB estava vindo com xml zuado - IMCSR201509531BR
--select * from E_Mix_Consulta_Tipo
--8	 Extrato DI
--10 Parametrização

--15/1814447-2

CREATE Procedure [dbo].[spEmixBuscaRetorno_Sel]

AS

select C.id_consulta_tipo,C.id_parametro_grupo,C.num_proc,XML_DOC2,E.ID ID_XML,C.id ID_Envio  from E_MIX_XML E with(nolock)
Join E_Mix_Consulta C with(nolock) on C.id=E.ID 
left join vwALL_JOBs V on V.Num_Proc = C.num_proc

Where 
Dt_retorno is null and Dt_Envio is not null
and isnull(V.ID_Status,0) < 5 
and C.num_proc not in ('IMCSR201509531BR')
and C.id_consulta_tipo not in (18,20)
order by 1
	
OPTION(HASH JOIN)

GO
