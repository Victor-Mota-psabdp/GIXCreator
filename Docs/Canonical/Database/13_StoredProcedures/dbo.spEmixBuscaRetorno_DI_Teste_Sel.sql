SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spEmixBuscaRetorno_DI_Teste_Sel]  
  
AS
  
select   
 C.id_consulta_tipo,  
 C.id_parametro_grupo,  
 C.num_proc,  
 convert(xml,replace(convert(varchar(max),XML_DOC2),'<idParametroTipo>8</idParametroTipo>','<idParametroTipo>13</idParametroTipo>')) XML_DOC2,  
 E.ID ID_XML,C.id ID_Envio,  
 Retorno_Erro  from E_MIX_XML E with(nolock)  
Join E_Mix_Consulta C with(nolock) on C.id=E.ID   
left join vwALL_JOBs V with(nolock) on V.Num_Proc = C.num_proc  
Where  
	c.num_proc in 
	('IMCSR202103240BR')
	--(select Num_Proc from ATL_INT.dbo.Emix_Retorno E with(nolock) 
	--	join ATL_INT.dbo.Emix_Retorno_Item I with(nolock) on I.ID = E.ID 
	--where E.Tipo_Consulta = 8 and Campo = 'ZIP-DI' and I.Dt_SendToPDF2ATL is null 
	--and insert_dt > GETDATE() -120)

and C.id_consulta_tipo in (10) 

--union all

--select 
--	C.id_consulta_tipo,
--	C.id_parametro_grupo,
--	C.num_proc,
--	convert(xml,replace(convert(varchar(max),XML_DOC2),'<idParametroTipo>9</idParametroTipo>','<idParametroTipo>13</idParametroTipo>'))	XML_DOC2,
--	E.ID ID_XML,C.id ID_Envio,  
--	 Retorno_Erro  from E_MIX_XML E with(nolock)
--Join E_Mix_Consulta C with(nolock) on C.id=E.ID 
--left join vwALL_JOBs V with(nolock) on V.Num_Proc = C.num_proc
--Where 
--(
--	c.num_proc in ('IMCSR202103240BR')
--	--(select Num_Proc from ATL_INT.dbo.Emix_Retorno E with(nolock) 
--	--	join ATL_INT.dbo.Emix_Retorno_Item I with(nolock) on I.ID = E.ID 
--	--where E.Tipo_Consulta = 9 and Campo = 'ZIP-CI' and I.Dt_SendToPDF2ATL is null 
--	--and insert_dt > GETDATE() -120)

--	and C.id_consulta_tipo in (9)

 --)

--Retorno_Erro like 'Desculpe, ocorreu um erro no sistema!%'
--and v.num_proc = 'IACSR201908105BR'
----Dt_retorno is null and   
--Dt_Envio is not null  
--and C.id_consulta_tipo in (9)  
--and Retorno_Erro like 'Finalizado%'  
----and Dt_Envio > GETDATE() -90  
----and Dt_Retorno > GETDATE() - 90  
--and c.num_proc in   
--('IMCSR201808178BR',  
--'IMCSR201808186BR',  
--'IAGVD201808027BR',  
--'IMATN201807014BR',  
--'IMATN201808004BR',  
--'IMATN201808005BR',  
--'IMCBT201801027BR',  
--'IMCBT201805022BR',  
--'IMCBT201806004BR',  
--'IMCBT201806015BR',  
--'IMCBT201806016BR',  
--'IMCBT201807018BR',  
--'IMCSR201808188BR',  
--'IMCSR201808196BR',  
--'IMCSR201808207BR',  
--'IMCSR201808209BR',  
--'IMFMC201807027BR',  
--'IMMAU201806006BR',  
--'IMMAU201807005BR',  
--'IMSOL201804011BR',  
--'IMSOL201805013BR',  
--'IMSOL201805021BR',  
--'IMSOL201806019BR',  
--'IMSOL201806036BR',  
--'IMSOL201806037BR',  
--'IMSOL201806050BR',  
--'IMSOL201807010BR',  
--'IMSOL201807023BR',  
--'IOCBT201808004BR')  
  
----union all  
  
----select   
---- C.id_consulta_tipo,  
---- C.id_parametro_grupo,  
---- C.num_proc,  
---- convert(xml,replace(convert(varchar(max),XML_DOC2),'<idParametroTipo>9</idParametroTipo>','<idParametroTipo>13</idParametroTipo>')) XML_DOC2,  
---- E.ID ID_XML,C.id ID_Envio  from E_MIX_XML E with(nolock)  
----Join E_Mix_Consulta C with(nolock) on C.id=E.ID   
----left join vwALL_JOBs V with(nolock) on V.Num_Proc = C.num_proc  
----Where   
------Dt_retorno is null and   
----Dt_Envio is not null  
----and C.id_consulta_tipo in (9)  
----and Retorno_Erro like 'sua consulta%'  
------and Dt_Envio > GETDATE() -90  
----and Dt_Retorno > GETDATE() - 90  
  
  
----select   
---- C.id_consulta_tipo,  
---- C.id_parametro_grupo,  
---- C.num_proc,  
---- convert(xml,replace(convert(varchar(max),XML_DOC2),'<idParametroTipo>8</idParametroTipo>','<idParametroTipo>13</idParametroTipo>')) XML_DOC2,  
---- E.ID ID_XML,C.id ID_Envio  from E_MIX_XML E with(nolock)  
----Join E_Mix_Consulta C on C.id=E.ID   
----left join vwALL_JOBs V on V.Num_Proc = C.num_proc  
----Where   
---- E.id_consulta_tipo = 8 and   
---- Retorno_Erro like 'sua consulta%'  
---- and Dt_Envio > GETDATE() -90  
  
  
  
---- --Dt_retorno is null and   
---- --Dt_Envio is not null  
------and isnull(V.ID_Status,0) < 5   
------and C.Num_Proc like 'IMGVD201612017BR%'   
------ C.Num_Proc in (  
--------'IMCSR201703120BR',  
------'IMEAS201705013BR',  
------'IACSR201706007BR',  
------'IMCPE201705001BR')  
------'IAOXT201606009BR',  
------'IMOXT201608072BR',  
------'IMCSR201611455BR',  
------'IMGVD201611037BR',  
------'IMGVD201612063BR',  
------'IAOCV201612008BR',  
------'IMGVD201611056BR',  
------'IMGVA201611011BR',  
------'IMPET201611002BR',  
------'IAOCV201612008BR',  
------'IMHEX201612013BR'  
------)  
  
------and C.id_consulta_tipo in (8,10)  
----and C.id_consulta_tipo in (8)  
  
------union all  
  
------select   
------ C.id_consulta_tipo,  
------ C.id_parametro_grupo,  
------ C.num_proc,  
------ convert(xml,replace(convert(varchar(max),XML_DOC2),'<idParametroTipo>9</idParametroTipo>','<idParametroTipo>13</idParametroTipo>')) XML_DOC2,  
------ E.ID ID_XML,C.id ID_Envio  from E_MIX_XML E with(nolock)  
------Join E_Mix_Consulta C on C.id=E.ID   
------left join vwALL_JOBs V on V.Num_Proc = C.num_proc  
------Where   
------Dt_retorno is null and Dt_Envio is not null  
--------and isnull(V.ID_Status,0) < 5   
------and C.Num_Proc like 'IMAMZ%'   
  
------and C.id_consulta_tipo in (9)  
  
  
----order by 1  
   
----OPTION(HASH JOIN)  
  
  
  
----select   
---- C.id_consulta_tipo,  
---- C.id_parametro_grupo,  
---- C.num_proc,  
---- convert(xml,replace(convert(varchar(max),XML_DOC2),  
---- '<idParametroTipo>8</idParametroTipo>','<idParametroTipo>13</idParametroTipo>')) XML_DOC2,  
---- E.ID ID_XML,C.id ID_Envio  from E_MIX_XML E with(nolock)  
----Join E_Mix_Consulta C on C.id=E.ID   
----left join vwALL_JOBs V on V.Num_Proc = C.num_proc  
----Where   
----Dt_retorno is null and Dt_Envio is not null  
------and isnull(V.ID_Status,0) < 5   
----and C.num_proc in (  
----'IMAMZ201608015BR')  
  
  
  
----and C.id_consulta_tipo in (8,10)  
  
----union all  
  
----select   
---- C.id_consulta_tipo,  
---- C.id_parametro_grupo,  
---- C.num_proc,  
---- convert(xml,replace(convert(varchar(max),XML_DOC2),'<idParametroTipo>9</idParametroTipo>','<idParametroTipo>13</idParametroTipo>')) XML_DOC2,  
---- E.ID ID_XML,C.id ID_Envio  from E_MIX_XML E with(nolock)  
----Join E_Mix_Consulta C on C.id=E.ID   
----left join vwALL_JOBs V on V.Num_Proc = C.num_proc  
----Where   
----Dt_retorno is null and Dt_Envio is not null  
------and isnull(V.ID_Status,0) < 5   
----and C.num_proc = 'IMAMZ201608015BR'  
----and C.id_consulta_tipo in (9)  
  
  
----order by 1  
   
----OPTION(HASH JOIN)  


GO
