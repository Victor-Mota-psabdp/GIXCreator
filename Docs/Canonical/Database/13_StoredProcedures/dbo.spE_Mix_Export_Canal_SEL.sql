SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spE_Mix_Export_Canal_SEL]
			
AS

select 
		'102'								[id_cliente],
		'139'								[id_integracao],
		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],
		'1'									[id_servico],
		ID_Empresa.Campo_Dados				[id_empresa] ,
		ID_CNPJ.Campo_Dados					[id_cnpj],
		'10'								[id_consulta_tipo]	,
		'13'								[id_parametro_grupo],
		'13'								[id_parametro_tipo],
		P05.Numero_PO_HEM					[valor],
		P05.Num_Proc_HEM					[num_proc],
		P05.dt_ins
	from 
		PO_HEM P05 with(nolock)
		join House_Exp_Mar		HOU with(nolock) on HOU.Num_Proc_HEM = P05.Num_Proc_HEM
		left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Export_HEM = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Export_HEM = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		left join E_Mix_Consulta E_Mix with(nolock) on E_mix.num_proc = P05.Num_Proc_HEM and E_mix.id_consulta_tipo = '10'
		Left Join LLP_Exp_Mar LLP with(nolock) on LLP.Num_Proc_Lem = hou.Num_Proc_HEM 
	where 	
		P05.ID_DC = 5		
		and P05.dt_ins > '2015-04-13'
		and ID_Empresa.Cd_Pes is not null
		and ID_CNPJ.Cd_Pes is not null
		and E_mix.num_proc is null	
		and Canal_Lem is null 
		--And Cd_Dst_HIM='SSZ'

Union all



select 
		'102'								[id_cliente],
		'139'								[id_integracao],
		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],
		'1'									[id_servico],
		ID_Empresa.Campo_Dados				[id_empresa] ,
		ID_CNPJ.Campo_Dados					[id_cnpj],
		'10'									[id_consulta_tipo]	,
		'13'								[id_parametro_grupo],
		'13'								[id_parametro_tipo],
		P05.Numero_PO_HEA					[valor],
		P05.Num_Proc_HEA					[num_proc],
		P05.dt_ins
	from 
		PO_HEA P05 with(nolock)
		join House_Exp_Aer		HOU with(nolock) on HOU.Num_Proc_HEA = P05.Num_Proc_HEA
		left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Export_HEA = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Export_HEA = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		left join E_Mix_Consulta E_Mix with(nolock) on E_mix.num_proc = P05.Num_Proc_HEA and E_mix.id_consulta_tipo = '10'
		Left Join LLP_Exp_Aer LLP with(nolock) on LLP.Num_Proc_Lea = hou.Num_Proc_HEA 
	where 	
		P05.ID_DC = 5 
		and P05.dt_ins > '2015-04-13'
		and ID_Empresa.Cd_Pes is not null
		and ID_CNPJ.Cd_Pes is not null
		and E_mix.num_proc is null	
		and Canal_Lea is null 
		--And Cd_Dst_HIA in ('GRU','VCP')
		
Union all

select 
		'102'								[id_cliente],
		'139'								[id_integracao],
		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],
		'1'									[id_servico],
		ID_Empresa.Campo_Dados				[id_empresa] ,
		ID_CNPJ.Campo_Dados					[id_cnpj],
		'10'								[id_consulta_tipo]	,
		'13'								[id_parametro_grupo],
		'13'								[id_parametro_tipo],
		P05.Numero_PO_HEO					[valor],
		P05.Num_Proc_HEO					[num_proc],
		P05.dt_ins
	from 
		PO_HEO P05 with(nolock)
		join House_Exp_Out		HOU with(nolock) on HOU.Num_Proc_HEO = P05.Num_Proc_HEO
		left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Export_HEO= ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Export_HEO = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		left join E_Mix_Consulta E_Mix with(nolock) on E_mix.num_proc = P05.Num_Proc_HEO and E_mix.id_consulta_tipo = '10'
		Left Join LLP_Exp_Out LLP with(nolock) on LLP.Num_Proc_Leo = hou.Num_Proc_HEO 
	where 	
		P05.ID_DC = 5 
		and P05.dt_ins > '2015-04-13'
		and ID_Empresa.Cd_Pes is not null
		and ID_CNPJ.Cd_Pes is not null
		and E_mix.num_proc is null	
		and Canal_Leo is null 

OPTION(HASH JOIN)
GO
