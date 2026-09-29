SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--29/09 - retirei os quejá estão fechados id_status < 5      
--15/10/2015- Cadu  -JOB estava vindo com xml zuado - IMCSR201509531BR      
--select * from E_Mix_Consulta_Tipo      
--8  Extrato DI      
--10 Parametrização      
      
--15/1814447-2      
      
--cadu 09/03/2016 - incluido pra so ver os status      
--cadu 09/08/16 - email do viola - 180 dias      
CREATE Procedure [dbo].[spEmixBuscaRetorno_LI_Sel]      
      
AS      
      
select C.id_consulta_tipo,C.id_parametro_grupo,C.num_proc,XML_DOC2,E.ID ID_XML,C.id ID_Envio, E.Retorno_Erro  from E_MIX_XML E with(nolock)      
Join E_Mix_Consulta C with(nolock) on C.id=E.ID       
--left join vwALL_JOBs V on V.Num_Proc = C.num_proc      
      
Where     
(    
(Dt_retorno is null and Dt_Envio is not null)    
or     
(Dt_retorno is not null and Dt_Envio is not null and Retorno_Erro like 'Sua consulta foi criada%')    
or     
(Dt_retorno is not null and Dt_Envio is not null and Retorno_Erro like 'Sua consulta não constou registros!')    
or     
(Dt_retorno is not null and Dt_Envio is not null and Retorno_Erro like 'Desculpe, ocorreu um erro no sistema!%')   
or 
(Dt_retorno is not null and Dt_Envio is not null and Retorno_Erro like '%Sua consulta já foi retornada dentro do%')
)    
    
--and Retorno_Erro like 'Desculpe, ocorreu um erro no sistema!%'    
--and isnull(V.ID_Status,0) < 5       
and C.num_proc not in ('IMCSR201509531BR')      
--and C.id_consulta_tipo not in (8,9,10)      
--and C.id_consulta_tipo not in (8,9,10,12)      
and C.id_consulta_tipo in (11)      
  
--Deixar rodar um dia desde a data que a proc foi cagada (2019-11-25 16:28:39.890)  
and Dt_Envio > GETDATE() -180      
--and Dt_Envio >  '2019-11-25 16:28:39.890'  
  
order by 1      
       
OPTION(HASH JOIN) 
GO
