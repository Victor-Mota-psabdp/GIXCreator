SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spEmixXMLParaCadastro_Teste_Sel]  
  
 AS   
   
select   
 e.ID ID_XML,e.XML_DOC,Retorno_Erro,e.Num_Proc,e.Dt_Retorno,E.id_consulta_tipo 
 ,E.dt_envio,e.Num_Proc,c.valor
 from E_MIX_XML E with(nolock)  
Join E_Mix_Consulta C with(nolock) on C.id=E.ID   
left join vwALL_JOBs V with(nolock) on V.Num_Proc = C.num_proc  
where 
	(
	(Dt_retorno is not null and Dt_Envio is not null and Retorno_Erro like 'Sua consulta foi criada%')    
	or     
	(Dt_retorno is not null and Dt_Envio is not null and Retorno_Erro like 'Sua consulta não constou registros!%')    
	or     
	(Dt_retorno is not null and Dt_Envio is not null and Retorno_Erro like 'Desculpe, ocorreu um erro no sistema!%')  
	)


--Retorno_Erro = 'Sua consulta não constou registros!'  
--and v.num_proc in('IMSLA201912013BR','IMSWB201911038BR')
--and E.dt_envio >= '2020-01-01'
AND DT_RETORNO > '2021-03-22'
order by e.Dt_Retorno  
  
  
GO
