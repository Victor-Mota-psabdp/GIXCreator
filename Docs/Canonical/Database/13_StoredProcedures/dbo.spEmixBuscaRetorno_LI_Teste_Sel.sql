SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spEmixBuscaRetorno_LI_Teste_Sel]  
  
AS  
  
select C.id_consulta_tipo,C.id_parametro_grupo,C.num_proc,XML_DOC2,E.ID ID_XML,C.id ID_Envio  from E_MIX_XML E with(nolock)  
Join E_Mix_Consulta C with(nolock) on C.id=E.ID   
--left join vwALL_JOBs V on V.Num_Proc = C.num_proc  
  
Where 
(
(Dt_retorno is null and Dt_Envio is not null)
or 
(Dt_retorno is not null and Dt_Envio is not null and Retorno_Erro like 'Sua consulta foi criada%')
or 
(Dt_retorno is not null and Dt_Envio is not null and Retorno_Erro like 'Sua consulta não constou registros!%')
or 
(Dt_retorno is not null and Dt_Envio is not null and Retorno_Erro like 'Desculpe, ocorreu um erro no sistema!%')
)

--and Retorno_Erro like 'Desculpe, ocorreu um erro no sistema!%'
and c.num_proc = 'IMIFB202412042BR'
and C.id_consulta_tipo in (11)  
--and Dt_Envio > GETDATE() -180  
order by 1  
   
OPTION(HASH JOIN)  
  
GO
