SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--20 - Siscomex - Acompanhamento Exportação - Extrato DDE
--select * from PO_HEM where ID_DC = 12
--12	DDE
CREATE Procedure [dbo].[spE_Mix_Consulta_ExtratoDDE_SEL]
			
AS

select 
		'102'								[id_cliente],
		'139'								[id_integracao],
		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],
		'1'									[id_servico],
		ID_Empresa.Campo_Dados				[id_empresa] ,
		ID_CNPJ.Campo_Dados					[id_cnpj],
		'20'									[id_consulta_tipo]	,
		'20'								[id_parametro_grupo],
		'23'								[id_parametro_tipo],
		replace(replace(P12.Numero_PO_HEM,'/',''),'-','')		[valor],
		P12.Num_Proc_HEM					[num_proc],
		P12.dt_ins
	from 
		PO_HEM P12
		join House_Exp_Mar		HOU with(nolock) on HOU.Num_Proc_HEM = P12.Num_Proc_HEM
		left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Export_HEM = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Export_HEM = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		left join E_Mix_Consulta E_Mix with(nolock) on E_mix.num_proc = P12.Num_Proc_HEM and E_mix.id_consulta_tipo = '20'
		Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=Hou.Num_Proc_HEM and DOC.ID_DC=12 
	where 	
		P12.ID_DC = 12
		--and P12.dt_ins > GETDATE() -1
		and  P12.dt_ins > GETDATE() -120
		and ID_Empresa.Cd_Pes is not null
		and ID_CNPJ.Cd_Pes is not null
		and E_mix.num_proc is null	
		and Doc.Anexado_Em is null 	
		and LEN(P12.Numero_PO_HEM) between 11 and 12
		and left(P12.Numero_PO_HEM,4) != '2170'
		


Union all


select 
		'102'								[id_cliente],
		'139'								[id_integracao],
		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],
		'1'									[id_servico],
		ID_Empresa.Campo_Dados				[id_empresa] ,
		ID_CNPJ.Campo_Dados					[id_cnpj],
		'20'									[id_consulta_tipo]	,
		'20'								[id_parametro_grupo],
		'23'								[id_parametro_tipo],
		replace(replace(P12.Numero_PO_HEA,'/',''),'-','')[valor],
		P12.Num_Proc_HEA					[num_proc],
		P12.dt_ins
	from 
		PO_HEA P12
		join House_Exp_Aer		HOU with(nolock) on HOU.Num_Proc_HEA = P12.Num_Proc_HEA
		left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Export_HEA = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Export_HEA = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		left join E_Mix_Consulta E_Mix with(nolock) on E_mix.num_proc = P12.Num_Proc_HEA and E_mix.id_consulta_tipo = '20'
		Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=Hou.Num_Proc_HEA and DOC.ID_DC=12 
	where 	
		P12.ID_DC = 12
		and  P12.dt_ins > GETDATE() -60
		and ID_Empresa.Cd_Pes is not null
		and ID_CNPJ.Cd_Pes is not null
		and E_mix.num_proc is null	
		and Doc.Anexado_Em is null 	
		and LEN(P12.Numero_PO_HEA) between 11 and 12
		and left(P12.Numero_PO_HEA,4) != '2170'

Union all


select
		'102'								[id_cliente],
		'139'								[id_integracao],
		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],
		'1'									[id_servico],
		ID_Empresa.Campo_Dados				[id_empresa] ,
		ID_CNPJ.Campo_Dados					[id_cnpj],
		'20'									[id_consulta_tipo]	,
		'20'								[id_parametro_grupo],
		'23'								[id_parametro_tipo],
		replace(replace(P12.Numero_PO_HEO,'/',''),'-','')					[valor],
		P12.Num_Proc_HEO					[num_proc],
		P12.dt_ins
	from 
		PO_HEO P12
		join House_Exp_Out		HOU with(nolock) on HOU.Num_Proc_HEO = P12.Num_Proc_HEO
		left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Export_HEO = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Export_HEO = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		left join E_Mix_Consulta E_Mix with(nolock) on E_mix.num_proc = P12.Num_Proc_HEO and E_mix.id_consulta_tipo = '20'
		Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=Hou.Num_Proc_HEO and DOC.ID_DC=12 
	where 	
		P12.ID_DC = 12
		and  P12.dt_ins > GETDATE() -60
		and ID_Empresa.Cd_Pes is not null
		and ID_CNPJ.Cd_Pes is not null
		and E_mix.num_proc is null	
		and Doc.Anexado_Em is null 	

		and LEN(P12.Numero_PO_HEO) between 11 and 12		
		and left(P12.Numero_PO_HEO,4) != '2170'

OPTION(HASH JOIN)
GO
