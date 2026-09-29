SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spEmixBuscaRetorno_DDE_Teste_Sel]

AS

select 
	C.id_consulta_tipo,
	C.id_parametro_grupo,
	C.num_proc,
	XML_DOC2,
	E.ID ID_XML,
	C.id ID_Envio  
from E_MIX_XML E with(nolock)
	Join E_Mix_Consulta C on C.id=E.ID 
	left join vwALL_JOBs V on V.Num_Proc = C.num_proc
Where 
	 E.id_consulta_tipo = 20 
	 
	 and E.Retorno_Erro like '%A consulta para o parâmetro informado no XML não foi cadastrada no SiscomexNet.%'
	 and c.Num_Proc in ('EMRHO201803095BR','EMRHO201801105BR')
	 --and E.Retorno_Erro = 'Sua consulta não constou registros!'
	 --and E.envio_erro is NULL
	 
	--Dt_retorno is null and 
	--Dt_Envio is not null
	--and C.id_consulta_tipo in (20)
	--and E.num_proc in	
	--('EMOXT201704199BR')
	
	--E.Num_Proc in 
	--('EMOXT201708117BR')
	----'EMOXT201705161BR',
	----'EMOXT201705178BR',
	----'EMOXT201705182BR',
	----'EMOXT201704162BR',
	----'EMOXT201705189BR',
	----'EMRHO201705063BR',
	----'EMRHO201705030BR',
	----'EMOXT201703050BR',
	----'EMOXT201704137BR',
	----'EMOXT201705129BR',
	----'EAOXT201705007BR',
	----'EMOXT201705226BR')
	--and E.id_consulta_tipo = 20
	----and Dt_Retorno is null
	
	
	
order by 1,3
	
--OPTION(HASH JOIN)


GO
