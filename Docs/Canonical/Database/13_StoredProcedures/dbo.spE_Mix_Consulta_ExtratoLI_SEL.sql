SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--10/10/2016 - a parte da Autorização de embarque estava incorreta, pois estava pegando a Dt_Deferimento - cadu
--alterei para dt_auto_embarque
--allterado p pegar todos os casos de 2020
CREATE  Procedure [dbo].[spE_Mix_Consulta_ExtratoLI_SEL]
			
AS

--Doc Anexado > dt_li
	select 
		'102'								[id_cliente],
		'139'								[id_integracao],
		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],
		'1'									[id_servico],
		ID_Empresa.Campo_Dados				[id_empresa] ,
		ID_CNPJ.Campo_Dados					[id_cnpj],
		'12'								[id_consulta_tipo]	,
		'12'								[id_parametro_grupo],
		'12'								[id_parametro_tipo],
		replace(SLI.Num_LI,' ','')  						[valor],
		SLI.Num_Proc  						[num_proc],
		SLI.Dt_LI 
	from 	
		Solicitacao_LI SLI with(nolock)
		join House_Imp_Mar	HOU  with(nolock)on HOU.Num_Proc_HIM =SLI.Num_Proc 
		left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Consig_HIM = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Consig_HIM = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		--left join E_Mix_Consulta E_Mix on E_mix.num_proc = SLI.Num_Proc  and E_mix.id_consulta_tipo = '12'
		left join E_Mix_Consulta E_Mix with(nolock) on E_mix.valor = SLI.Num_LI  and E_mix.id_consulta_tipo = '12'
		Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=SLI.Num_Solicitacao and DOC.ID_DC=23 and DOC.Anexado_Em > Dt_LI 
	where 	
		--sli.num_proc = 'IMUPL201506078BR' and
		--Num_Solicitacao = 'SLI2015070011' and 
		SLI.ID_Status not in (9,11,12)
		--and SLI.Dt_LI  > GETDATE()-30
		and SLI.Dt_LI  > '2020-01-01'
		and ID_Empresa.Cd_Pes is not null
		and ID_CNPJ.Cd_Pes is not null
		and E_mix.num_proc is null	
		and Doc.Anexado_Em is null 	
		and SLI.Num_LI is not null
		and SLI.Num_LI like '%-%'

Union All

	select 
		'102'								[id_cliente],
		'139'								[id_integracao],
		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],

		'1'									[id_servico],
		ID_Empresa.Campo_Dados				[id_empresa] ,
		ID_CNPJ.Campo_Dados					[id_cnpj],
		'12'									[id_consulta_tipo]	,
		'12'								[id_parametro_grupo],
		'12'								[id_parametro_tipo],
		replace(SLI.Num_LI,' ','')    					[valor],
		SLI.Num_Proc  					[num_proc],
		SLI.Dt_LI 
	from 
	
		Solicitacao_LI SLI
		join House_Imp_Aer		HOU with(nolock) on HOU.Num_Proc_HIA =SLI.Num_Proc 
		left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Consig_HIA = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Consig_HIA = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		--left join E_Mix_Consulta E_Mix on E_mix.num_proc = SLI.Num_Proc  and E_mix.id_consulta_tipo = '12'
		left join E_Mix_Consulta E_Mix with(nolock) on E_mix.valor = SLI.Num_LI  and E_mix.id_consulta_tipo = '12'
		Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=SLI.Num_Solicitacao and DOC.ID_DC=23 and DOC.Anexado_Em > Dt_LI 
	where 	
		SLI.ID_Status not in (9,11,12)
		--and SLI.Dt_LI  > GETDATE()-30
		and SLI.Dt_LI  > '2020-01-01'
		and ID_Empresa.Cd_Pes is not null
		and ID_CNPJ.Cd_Pes is not null
		and E_mix.num_proc is null	
		and Doc.Anexado_Em is null 	
		and SLI.Num_LI is not null
		and SLI.Num_LI like '%-%'

Union All

	select 
		'102'								[id_cliente],
		'139'								[id_integracao],
		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],

		'1'									[id_servico],
		ID_Empresa.Campo_Dados				[id_empresa] ,
		ID_CNPJ.Campo_Dados					[id_cnpj],
		'12'									[id_consulta_tipo]	,
		'12'								[id_parametro_grupo],
		'12'								[id_parametro_tipo],
		replace(SLI.Num_LI,' ','')   					[valor],
		SLI.Num_Proc  					[num_proc],
		SLI.Dt_LI 
	from 
	
		Solicitacao_LI SLI
		join House_Imp_Out		HOU with(nolock) on HOU.Num_Proc_HIO =SLI.Num_Proc 
		left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Consig_HIO = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Consig_HIO = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		--left join E_Mix_Consulta E_Mix on E_mix.num_proc = SLI.Num_Proc  and E_mix.id_consulta_tipo = '12'
		left join E_Mix_Consulta E_Mix with(nolock) on E_mix.valor = SLI.Num_LI  and E_mix.id_consulta_tipo = '12'
		Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=SLI.Num_Solicitacao and DOC.ID_DC=23 and DOC.Anexado_Em > Dt_LI 
	where 	
		SLI.ID_Status not in (9,11,12)
		--and SLI.Dt_LI  > GETDATE()-30
		and SLI.Dt_LI  > '2020-01-01'
		and ID_Empresa.Cd_Pes is not null
		and ID_CNPJ.Cd_Pes is not null
		and E_mix.num_proc is null	
		and Doc.Anexado_Em is null 	
		and SLI.Num_LI is not null

UNION ALL

--Doc Anexado > Dt_Deferimento
	select 
		'102'								[id_cliente],
		'139'								[id_integracao],
		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],

		'1'									[id_servico],
		ID_Empresa.Campo_Dados				[id_empresa] ,
		ID_CNPJ.Campo_Dados					[id_cnpj],
		'12'									[id_consulta_tipo]	,
		'12'								[id_parametro_grupo],
		'12'								[id_parametro_tipo],
		replace(SLI.Num_LI,' ','')   					[valor],
		SLI.Num_Proc  					[num_proc],
		SLI.Dt_LI 
	from 
	
		Solicitacao_LI SLI
		join House_Imp_Mar		HOU with(nolock) on HOU.Num_Proc_HIM =SLI.Num_Proc 
		left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Consig_HIM = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Consig_HIM = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		--left join E_Mix_Consulta E_Mix on E_mix.num_proc = SLI.Num_Proc  and E_mix.id_consulta_tipo = '12'
		left join E_Mix_Consulta E_Mix with(nolock) on E_mix.valor = SLI.Num_LI  and E_mix.id_consulta_tipo = '12'
		Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=SLI.Num_Solicitacao and DOC.ID_DC=23 and DOC.Anexado_Em > Dt_Deferimento 
	where 	
		SLI.ID_Status not in (9,11,12)
		--and SLI.Dt_Deferimento  > GETDATE()-30
		and SLI.Dt_Deferimento  > '2020-01-01'	
		and ID_Empresa.Cd_Pes is not null
		and ID_CNPJ.Cd_Pes is not null
		and E_mix.num_proc is null	
		and Doc.Anexado_Em is null 	
		and SLI.Num_LI is not null
		and SLI.Num_LI like '%-%'

Union All

	select 
				'102'								[id_cliente],
		'139'								[id_integracao],
		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],

		'1'									[id_servico],
		ID_Empresa.Campo_Dados				[id_empresa] ,
		ID_CNPJ.Campo_Dados					[id_cnpj],
		'12'									[id_consulta_tipo]	,
		'12'								[id_parametro_grupo],
		'12'								[id_parametro_tipo],
		replace(SLI.Num_LI,' ','')   					[valor],
		SLI.Num_Proc  					[num_proc],
		SLI.Dt_LI 
	from 
	
		Solicitacao_LI SLI
		join House_Imp_Aer		HOU with(nolock) on HOU.Num_Proc_HIA =SLI.Num_Proc 
		left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Consig_HIA = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Consig_HIA = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		--left join E_Mix_Consulta E_Mix on E_mix.num_proc = SLI.Num_Proc  and E_mix.id_consulta_tipo = '12'
		left join E_Mix_Consulta E_Mix with(nolock) on E_mix.valor = SLI.Num_LI  and E_mix.id_consulta_tipo = '12'
		Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=SLI.Num_Solicitacao and DOC.ID_DC=23 and DOC.Anexado_Em > Dt_Deferimento  
	where 	
		SLI.ID_Status not in (9,11,12)
		--and SLI.Dt_Deferimento  > GETDATE()-30
		and SLI.Dt_Deferimento  > '2020-01-01'
		and ID_Empresa.Cd_Pes is not null
		and ID_CNPJ.Cd_Pes is not null
		and E_mix.num_proc is null	
		and Doc.Anexado_Em is null 	
		and SLI.Num_LI is not null
		and SLI.Num_LI like '%-%'

UNION ALL

	Select
		'102'								[id_cliente],
		'139'								[id_integracao],
		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],

		'1'									[id_servico],
		ID_Empresa.Campo_Dados				[id_empresa] ,
		ID_CNPJ.Campo_Dados					[id_cnpj],
		'12'									[id_consulta_tipo]	,
		'12'								[id_parametro_grupo],
		'12'								[id_parametro_tipo],
		replace(SLI.Num_LI,' ','')    					[valor],
		SLI.Num_Proc  					[num_proc],
		SLI.Dt_LI 
	from 
	
		Solicitacao_LI SLI
		join House_Imp_Out		HOU with(nolock) on HOU.Num_Proc_HIo =SLI.Num_Proc 
		left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Consig_HIO = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Consig_HIO = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		--left join E_Mix_Consulta E_Mix on E_mix.num_proc = SLI.Num_Proc  and E_mix.id_consulta_tipo = '12'
		left join E_Mix_Consulta E_Mix with(nolock) on E_mix.valor = SLI.Num_LI  and E_mix.id_consulta_tipo = '12'
		Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=SLI.Num_Solicitacao and DOC.ID_DC=23 and DOC.Anexado_Em > Dt_Deferimento 
	where 	
		SLI.ID_Status not in (9,11,12)
		--and SLI.Dt_Deferimento  > GETDATE()-30
		and SLI.Dt_Deferimento  > '2020-01-01'
		and ID_Empresa.Cd_Pes is not null
		and ID_CNPJ.Cd_Pes is not null
		and E_mix.num_proc is null	
		and Doc.Anexado_Em is null 	
		and SLI.Num_LI is not null
		and SLI.Num_LI like '%-%'

Union All
	
--Doc Anexado > Dt_Aut_Embarque
	select 
		'102'								[id_cliente],
		'139'								[id_integracao],
		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],

		'1'									[id_servico],
		ID_Empresa.Campo_Dados				[id_empresa] ,
		ID_CNPJ.Campo_Dados					[id_cnpj],
		'12'									[id_consulta_tipo]	,
		'12'								[id_parametro_grupo],
		'12'								[id_parametro_tipo],
		replace(SLI.Num_LI,' ','')   					[valor],
		SLI.Num_Proc  					[num_proc],
		SLI.Dt_LI 
	from 
	
		Solicitacao_LI SLI
		join House_Imp_Mar		HOU with(nolock) on HOU.Num_Proc_HIM =SLI.Num_Proc 
		left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Consig_HIM = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Consig_HIM = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		--left join E_Mix_Consulta E_Mix on E_mix.num_proc = SLI.Num_Proc  and E_mix.id_consulta_tipo = '12'
		left join E_Mix_Consulta E_Mix with(nolock) on E_mix.valor = SLI.Num_LI  and E_mix.id_consulta_tipo = '12'
		Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=SLI.Num_Solicitacao and DOC.ID_DC=23 and DOC.Anexado_Em > Dt_Aut_Embarque 
	where 	
		SLI.ID_Status not in (11,12)
		--and SLI.Dt_Aut_Embarque  > GETDATE()-120
		and SLI.Dt_Aut_Embarque  > '2020-01-01'
		and ID_Empresa.Cd_Pes is not null
		and ID_CNPJ.Cd_Pes is not null
		and E_mix.num_proc is null	
		and Doc.Anexado_Em is null 	
		and SLI.Num_LI is not null
		and SLI.Num_LI like '%-%'

Union All

	select 
		'102'								[id_cliente],
		'139'								[id_integracao],
		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],

		'1'									[id_servico],
		ID_Empresa.Campo_Dados				[id_empresa] ,
		ID_CNPJ.Campo_Dados					[id_cnpj],
		'12'									[id_consulta_tipo]	,
		'12'								[id_parametro_grupo],
		'12'								[id_parametro_tipo],
		replace(SLI.Num_LI,' ','')    					[valor],
		SLI.Num_Proc  					[num_proc],
		SLI.Dt_LI 
	from 
	
		Solicitacao_LI SLI
		join House_Imp_Aer		HOU with(nolock) on HOU.Num_Proc_HIA =SLI.Num_Proc 
		left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Consig_HIA = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Consig_HIA = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		--left join E_Mix_Consulta E_Mix on E_mix.num_proc = SLI.Num_Proc  and E_mix.id_consulta_tipo = '12'
		left join E_Mix_Consulta E_Mix with(nolock) on E_mix.valor = SLI.Num_LI  and E_mix.id_consulta_tipo = '12'
		Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=SLI.Num_Solicitacao and DOC.ID_DC=23 and DOC.Anexado_Em > Dt_Aut_Embarque  
	where 	
		SLI.ID_Status not in (11,12)
			--and SLI.Dt_Aut_Embarque  > GETDATE()-120
		and SLI.Dt_Aut_Embarque  > '2020-01-01'
		and ID_Empresa.Cd_Pes is not null
		and ID_CNPJ.Cd_Pes is not null
		and E_mix.num_proc is null	
		and Doc.Anexado_Em is null 	
		and SLI.Num_LI is not null
		and SLI.Num_LI like '%-%'

UNION ALL

	Select
		'102'								[id_cliente],
		'139'								[id_integracao],
		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],

		'1'									[id_servico],
		ID_Empresa.Campo_Dados				[id_empresa] ,
		ID_CNPJ.Campo_Dados					[id_cnpj],
		'12'								[id_consulta_tipo]	,
		'12'								[id_parametro_grupo],
		'12'								[id_parametro_tipo],
		replace(SLI.Num_LI,' ','')    						[valor],
		SLI.Num_Proc  						[num_proc],
		SLI.Dt_LI 
	from 
	
		Solicitacao_LI SLI
		join House_Imp_Out		HOU with(nolock) on HOU.Num_Proc_HIo =SLI.Num_Proc 
		left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Consig_HIO = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Consig_HIO = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		--left join E_Mix_Consulta E_Mix on E_mix.num_proc = SLI.Num_Proc  and E_mix.id_consulta_tipo = '12'
		left join E_Mix_Consulta E_Mix with(nolock) on E_mix.valor = SLI.Num_LI and E_mix.id_consulta_tipo = '12'
		Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=SLI.Num_Solicitacao and DOC.ID_DC=23 and DOC.Anexado_Em > Dt_Aut_Embarque 
	where 	
		SLI.ID_Status not in (11,12)
			--and SLI.Dt_Aut_Embarque  > GETDATE()-120
		and SLI.Dt_Aut_Embarque  > '2020-01-01'
		and ID_Empresa.Cd_Pes is not null
		and ID_CNPJ.Cd_Pes is not null
		and E_mix.num_proc is null	
		and Doc.Anexado_Em is null 	
		and SLI.Num_LI is not null
		and SLI.Num_LI like '%-%'

OPTION(HASH JOIN)
GO
