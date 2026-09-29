SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Cadu 27/12/23 - alterado p ver se o doc ja existe
--select * from E_MIX_XML where Num_Proc = 'IMCSR201611076BR'
--[spEmixBuscaRetorno_Sel]
--[spEmixAtualizarStatusCanal_ComDataDesembaraco_Aut]

CREATE Procedure [dbo].[spEmixBuscaRetorno_DI_Sel]

AS
--005 - id_consulta_tipo in 8	Extrato DI
select 
	C.id_consulta_tipo,
	C.id_parametro_grupo,
	C.num_proc,
	convert(xml,replace(convert(varchar(max),XML_DOC2),'<idParametroTipo>8</idParametroTipo>','<idParametroTipo>13</idParametroTipo>'))	XML_DOC2,
	E.ID ID_XML,C.id ID_Envio,E.Retorno_Erro  
from E_MIX_XML E with(nolock)
Join E_Mix_Consulta C with(nolock) on C.id=E.ID 
join vwALL_JOBs V with(nolock) on V.Num_Proc = C.num_proc
left join Doc_Anexos P on P.num_proc = E.num_proc and Id_dc =5
Where 
(
(E.Dt_retorno is null and E.Dt_Envio is not null)
or 
(E.Dt_retorno is not null and E.Dt_Envio > DATEADD (month , -12 , getdate()) and E.Retorno_Erro like 'Sua consulta foi criada%')
or 
(E.Dt_retorno is not null and E.Dt_Envio > DATEADD (month , -12 , getdate()) and E.Retorno_Erro like 'Sua consulta não constou registros!')
or 
(E.Dt_retorno is not null and E.Dt_Envio > DATEADD (month , -12 , getdate()) and E.Retorno_Erro like 'Desculpe, ocorreu um erro no sistema!%')
or 
(E.Dt_retorno is not null and E.Dt_Envio > DATEADD (month , -12 , getdate()) and E.Retorno_Erro like '%Sua consulta já foi retornada dentro do%')
)
and C.id_consulta_tipo in (8)
and P.Nome_Arquivo is null

union all

--10	Parametrização
select 
	C.id_consulta_tipo,
	C.id_parametro_grupo,
	C.num_proc,
	convert(xml,replace(convert(varchar(max),XML_DOC2),'<idParametroTipo>8</idParametroTipo>','<idParametroTipo>13</idParametroTipo>'))	XML_DOC2,
	E.ID ID_XML,C.id ID_Envio,E.Retorno_Erro  
--	,V.Canal,P.Dt_Conclusao,V.Dt_Emis
from E_MIX_XML E with(nolock)
Join E_Mix_Consulta C with(nolock) on C.id=E.ID 
join vwHouse_Imp V with(nolock) on V.Num_Proc = C.num_proc
left join Tarefas_Processos P on P.num_proc = E.num_proc and P.ID_task =4
Where 
(
(E.Dt_retorno is null and E.Dt_Envio is not null)
or 
(E.Dt_retorno is not null and E.Dt_Envio > DATEADD (month , -24 , getdate()) and E.Retorno_Erro like 'Sua consulta foi criada%')
or 
(E.Dt_retorno is not null and E.Dt_Envio > DATEADD (month , -24 , getdate()) and E.Retorno_Erro like 'Sua consulta não constou registros!')
or 
(E.Dt_retorno is not null and E.Dt_Envio > DATEADD (month , -24 , getdate()) and E.Retorno_Erro like 'Desculpe, ocorreu um erro no sistema!%')
or 
(E.Dt_retorno is not null and E.Dt_Envio > DATEADD (month , -24 , getdate()) and E.Retorno_Erro like '%Sua consulta já foi retornada dentro do%')
)
and C.id_consulta_tipo in (10)
and
 (V.Canal is null or P.Dt_Conclusao is null)

union all

--006 - 9	Extrato CI
select 
	C.id_consulta_tipo,
	C.id_parametro_grupo,
	C.num_proc,
	convert(xml,replace(convert(varchar(max),XML_DOC2),'<idParametroTipo>9</idParametroTipo>','<idParametroTipo>13</idParametroTipo>'))	XML_DOC2,
	E.ID ID_XML,C.id ID_Envio ,E.Retorno_Erro from E_MIX_XML E with(nolock)
Join E_Mix_Consulta C with(nolock) on C.id=E.ID 
join vwALL_JOBs V with(nolock) on V.Num_Proc = C.num_proc
left join Doc_Anexos P on P.num_proc = E.num_proc and Id_dc =6
Where 
(
(E.Dt_retorno is null and E.Dt_Envio is not null)
or 
(E.Dt_retorno is not null and E.Dt_Envio > DATEADD (month , -6 , getdate()) and E.Retorno_Erro like 'Sua consulta foi criada%')
or 
(E.Dt_retorno is not null and E.Dt_Envio > DATEADD (month , -6 , getdate()) and E.Retorno_Erro like 'Sua consulta não constou registros!')
or 
(E.Dt_retorno is not null and E.Dt_Envio > DATEADD (month , -6 , getdate()) and E.Retorno_Erro like 'Desculpe, ocorreu um erro no sistema!%')
or 
(E.Dt_retorno is not null and E.Dt_Envio > DATEADD (month , -6 , getdate()) and E.Retorno_Erro like '%Sua consulta já foi retornada dentro do%')
)
and C.id_consulta_tipo in (9)
and P.Nome_Arquivo is null

order by 1
	
OPTION(HASH JOIN)




/*Old q nao verificava se o doc 005 ou 006 ja estava no job
ALTER Procedure [dbo].[spEmixBuscaRetorno_DI_Sel]

AS

--select C.id_consulta_tipo,C.id_parametro_grupo,C.num_proc,XML_DOC2,E.ID ID_XML,C.id ID_Envio  from E_MIX_XML E with(nolock)
--Join E_Mix_Consulta C on C.id=E.ID 
--left join vwALL_JOBs V on V.Num_Proc = C.num_proc
--Where 
--Dt_retorno is null and Dt_Envio is not null
----and isnull(V.ID_Status,0) < 5 

--and C.id_consulta_tipo in (8,9,10)
--order by 1

select 
	C.id_consulta_tipo,
	C.id_parametro_grupo,
	C.num_proc,
	convert(xml,replace(convert(varchar(max),XML_DOC2),'<idParametroTipo>8</idParametroTipo>','<idParametroTipo>13</idParametroTipo>'))	XML_DOC2,
	E.ID ID_XML,C.id ID_Envio,E.Retorno_Erro  from E_MIX_XML E with(nolock)
Join E_Mix_Consulta C with(nolock) on C.id=E.ID 
left join vwALL_JOBs V with(nolock) on V.Num_Proc = C.num_proc
Where 
(
(Dt_retorno is null and Dt_Envio is not null)
or 
(Dt_retorno is not null and Dt_Envio > DATEADD (month , -6 , getdate()) and Retorno_Erro like 'Sua consulta foi criada%')
or 
(Dt_retorno is not null and Dt_Envio > DATEADD (month , -6 , getdate()) and Retorno_Erro like 'Sua consulta não constou registros!')
or 
(Dt_retorno is not null and Dt_Envio > DATEADD (month , -6 , getdate()) and Retorno_Erro like 'Desculpe, ocorreu um erro no sistema!%')
or 
(Dt_retorno is not null and Dt_Envio > DATEADD (month , -6 , getdate()) and Retorno_Erro like '%Sua consulta já foi retornada dentro do%')
)


--and isnull(V.ID_Status,0) < 5 
--and C.Num_Proc not like 'IMAMZ%' 

and C.id_consulta_tipo in (8,10)

union all

select 
	C.id_consulta_tipo,
	C.id_parametro_grupo,
	C.num_proc,
	convert(xml,replace(convert(varchar(max),XML_DOC2),'<idParametroTipo>9</idParametroTipo>','<idParametroTipo>13</idParametroTipo>'))	XML_DOC2,
	E.ID ID_XML,C.id ID_Envio ,E.Retorno_Erro from E_MIX_XML E with(nolock)
Join E_Mix_Consulta C with(nolock) on C.id=E.ID 
left join vwALL_JOBs V with(nolock) on V.Num_Proc = C.num_proc
Where 
(
(Dt_retorno is null and Dt_Envio is not null)
or 
(Dt_retorno is not null and Dt_Envio > DATEADD (month , -6 , getdate()) and Retorno_Erro like 'Sua consulta foi criada%')
or 
(Dt_retorno is not null and Dt_Envio > DATEADD (month , -6 , getdate()) and Retorno_Erro like 'Sua consulta não constou registros!')
or 
(Dt_retorno is not null and Dt_Envio > DATEADD (month , -6 , getdate()) and Retorno_Erro like 'Desculpe, ocorreu um erro no sistema!%')
or 
(Dt_retorno is not null and Dt_Envio > DATEADD (month , -6 , getdate()) and Retorno_Erro like '%Sua consulta já foi retornada dentro do%')
)
--2019-06-01
--and isnull(V.ID_Status,0) < 5 
--and C.Num_Proc not like 'IMAMZ%' 

and C.id_consulta_tipo in (9)


order by 1
	
OPTION(HASH JOIN)


-- 8 jobs nao vieram a parametrização, apenas uma informação de: 
--NECESSIDADE DE REGISTRO DA DECLARACAO DO ICMS NO SISCOMEX
--and C.num_proc not in (
--'IMCSR201509531BR',
--'IAGVD201603054BR',
--'IAGVD201601035BR',
--'IAOXT201602006BR',
--'IACSR201510041BR',
--'IACSR201511039BR',
--'IAGVD201603048BR',
--'IMHEX201603013BR',
--'IOCBT201512001BR')

--select
--	C.num_proc,	
--	C.valor ,
--	T.Dt_Conclusao
--from E_MIX_XML E with(nolock)
--	Join E_Mix_Consulta C on C.id=E.ID 
--	left join vwALL_JOBs V on V.Num_Proc = C.num_proc
--	left join Tarefas_processos T on T.num_proc = V.num_proc and ID_task = 4
--Where 
--	Dt_retorno is null 
--	and Dt_Envio is not null
--	and C.id_consulta_tipo in (10)
--	and T.Dt_Conclusao is not null

*/
GO
