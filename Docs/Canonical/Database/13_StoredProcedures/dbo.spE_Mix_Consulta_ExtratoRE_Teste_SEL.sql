SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--18 - Siscomex - Acompanhamento Exportação - RE
--select * from PO_HEM where ID_DC = 4
CREATE Procedure [dbo].[spE_Mix_Consulta_ExtratoRE_Teste_SEL]
			
AS

select 
		'102'								[id_cliente],
		'139'								[id_integracao],
		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],
		'1'									[id_servico],
		ID_Empresa.Campo_Dados				[id_empresa] ,
		ID_CNPJ.Campo_Dados					[id_cnpj],
		'18'								[id_consulta_tipo]	,
		'18'								[id_parametro_grupo],
		'18'								[id_parametro_tipo],
		replace(replace(P04.Numero_PO_HEM,'/',''),'-','') [valor],
		P04.Num_Proc_HEM					[num_proc],
		P04.dt_ins
	from 
		PO_HEM P04
		join House_Exp_Mar		HOU with(nolock) on HOU.Num_Proc_HEM = P04.Num_Proc_HEM
		left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Export_HEM = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Export_HEM = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		left join E_Mix_Consulta E_Mix with(nolock) on E_mix.num_proc = P04.Num_Proc_HEM and E_mix.id_consulta_tipo = '18'
		Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=Hou.Num_Proc_HEM and DOC.ID_DC=4 
	where 	
		P04.ID_DC = 4
		and P04.Num_Proc_HEM = 'EMOXT201211159BR'
		--and P04.dt_ins > '2017-01-01'
		--and P04.dt_ins > GETDATE() -60
		and ID_Empresa.Cd_Pes is not null
		and ID_CNPJ.Cd_Pes is not null
		and E_mix.num_proc is null	
		--and Doc.Anexado_Em is null
		and LEN(Numero_PO_HEM) between 12 and 14
		

		
		
		

Union all


select
		'102'								[id_cliente],
		'139'								[id_integracao],
		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],
		'1'									[id_servico],
		ID_Empresa.Campo_Dados				[id_empresa] ,
		ID_CNPJ.Campo_Dados					[id_cnpj],
		'18'									[id_consulta_tipo]	,
		'18'								[id_parametro_grupo],
		'18'								[id_parametro_tipo],
		replace(replace(P04.Numero_PO_HEA,'/',''),'-','')					[valor],
		P04.Num_Proc_HEA					[num_proc],
		P04.dt_ins
	from 
		PO_HEA P04
		join House_Exp_Aer		HOU with(nolock) on HOU.Num_Proc_HEA = P04.Num_Proc_HEA
		left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Export_HEA = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Export_HEA = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		left join E_Mix_Consulta E_Mix with(nolock) on E_mix.num_proc = P04.Num_Proc_HEA and E_mix.id_consulta_tipo = '18'
		Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=Hou.Num_Proc_HEA and DOC.ID_DC=4 
	where 	
		P04.ID_DC = 4
		and P04.Num_Proc_HEA in (
		'EAOXT201301003BR',
		'EAOXT201301004BR')		
		--and P04.dt_ins > '2017-01-01'
		--and P04.dt_ins > GETDATE() -60
		and ID_Empresa.Cd_Pes is not null
		and ID_CNPJ.Cd_Pes is not null
		and E_mix.num_proc is null	
		--and Doc.Anexado_Em is null 			
		and LEN(Numero_PO_HEA) between 12 and 14

--Union all


--select 
--		'102'								[id_cliente],
--		'139'								[id_integracao],
--		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],
--		'1'									[id_servico],
--		ID_Empresa.Campo_Dados				[id_empresa] ,
--		ID_CNPJ.Campo_Dados					[id_cnpj],
--		'18'									[id_consulta_tipo]	,
--		'18'								[id_parametro_grupo],
--		'18'								[id_parametro_tipo],
--		replace(replace(P04.Numero_PO_HEO,'/',''),'-','')					[valor],
--		P04.Num_Proc_HEO					[num_proc],
--		P04.dt_ins
--	from 
--		PO_HEO P04
--		join House_Exp_Out		HOU with(nolock) on HOU.Num_Proc_HEO = P04.Num_Proc_HEO
--		left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Export_HEO = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
--		left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Export_HEO = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
--		left join E_Mix_Consulta E_Mix with(nolock) on E_mix.num_proc = P04.Num_Proc_HEO and E_mix.id_consulta_tipo = '18'
--		Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=Hou.Num_Proc_HEO and DOC.ID_DC=4
--	where 	
--		P04.ID_DC = 4 
--		--and P04.dt_ins > '2017-01-01'
--		and P04.dt_ins > GETDATE()-60
--		and ID_Empresa.Cd_Pes is not null
--		and ID_CNPJ.Cd_Pes is not null
--		and E_mix.num_proc is null	
--		and Doc.Anexado_Em is null 	
--		and LEN(Numero_PO_HEO) between 12 and 14
--OPTION(HASH JOIN)
GO
