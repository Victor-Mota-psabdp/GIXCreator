SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spEmixBuscaRetorno_RE_TESTE_Sel]

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
	e.id_consulta_tipo = 18 
	--and e.Retorno_Erro = 'Sua consulta não constou registros!'
	and e.Retorno_Erro = 'A consulta para o parâmetro informado no XML não foi cadadstrada no SiscomexNet.'
	--and E.num_proc in
	--('EMARC201712004BR')
	

	
	
	--('EMOXT201707304BR') and E.id_consulta_tipo = 18
	
	--Retorno_Erro like 'sua consul%' 
	--and Dt_Retorno > GETDATE() -90 and E.id_consulta_tipo = 18

	--E.Retorno_Erro like 'finaliza%' and E.id_consulta_tipo = 18
	--and Dt_Retorno > getdate() - 90


--	E.Num_Proc in  
--	(
--	'EMCSR201705057BR',
--	'EMOXT201702109BR',
--	'EMOXT201703022BR',
--	'EMOXT201703218BR',
--	'EMOXT201704076BR',
--	'EMOXT201704154BR',
--	'EMOXT201704155BR',
--	'EMOXT201704157BR',
--	'EMOXT201704163BR',
--	'EMOXT201704203BR',
--	'EMOXT201704231BR',
--	'EMOXT201705024BR',
--	'EMOXT201705025BR',
--	'EMOXT201705045BR',
--	'EMOXT201705074BR',
--	'EMOXT201705081BR',
--	'EMOXT201705092BR'
--	)
--and E.id_consulta_tipo = 18
--and Retorno_Erro <> 'Finalizado - Vencido'









	--Retorno_Erro = 'Sua consulta não constou registros!' and E.id_consulta_tipo =18
	--C.Num_Proc = 'EMCSR201705041BR' and E.id_consulta_tipo =18
	
	--Dt_retorno is null and 
--	Dt_Envio is not null
--	and C.id_consulta_tipo in (18)	
--	and c.num_proc in (
--	'EMOXT201704014BR'
--)
order by 1,3
	
--OPTION(HASH JOIN)



GO
