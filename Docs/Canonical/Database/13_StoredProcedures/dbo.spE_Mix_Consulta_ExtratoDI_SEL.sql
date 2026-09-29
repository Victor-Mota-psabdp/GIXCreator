SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Included SopSend 17/01 - 15:38 - Cadu
CREATE Procedure [dbo].[spE_Mix_Consulta_ExtratoDI_SEL]
			
AS

select 
		'102'								[id_cliente],
		'139'								[id_integracao],
		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],
		'1'									[id_servico],
		ID_Empresa.Campo_Dados				[id_empresa] ,
		ID_CNPJ.Campo_Dados					[id_cnpj],
		'8'									[id_consulta_tipo]	,
		'13'								[id_parametro_grupo],
		'13'								[id_parametro_tipo],
		replace(P05.Numero_PO_HIM,' ','')					[valor],
		P05.Num_Proc_HIM					[num_proc],
		P05.dt_ins,
		StopSend.Cd_Pes,
		StopSend.Campo_Dados
	from 
		PO_HIM P05
		join House_Imp_Mar		HOU with(nolock) on HOU.Num_Proc_HIM = P05.Num_Proc_HIM
		left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Consig_HIM = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Consig_HIM = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		left join Campo_Pessoa	StopSend with(nolock) on HOU.Cd_Consig_HIM = StopSend.Cd_Pes and StopSend.Id_Campo = 26
		left join E_Mix_Consulta E_Mix with(nolock) on E_mix.num_proc = P05.Num_Proc_HIM and E_mix.id_consulta_tipo = '8'
		Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=Hou.Num_Proc_HIM and DOC.ID_DC=5 
	where 	
		P05.ID_DC = 5 
		--and P05.dt_ins > GETDATE() - 90
		and P05.dt_ins > '2015-06-01'
		and ID_Empresa.Cd_Pes is not null
		and ID_CNPJ.Cd_Pes is not null
		and E_mix.num_proc is null	
		and Doc.Anexado_Em is null 	
		and Numero_PO_HIM like '%-%'
		and isnull(StopSend.Campo_Dados,'2') = '2'


Union all


select 
		'102'								[id_cliente],
		'139'								[id_integracao],
		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],
		'1'									[id_servico],
		ID_Empresa.Campo_Dados				[id_empresa] ,
		ID_CNPJ.Campo_Dados					[id_cnpj],
		'8'									[id_consulta_tipo]	,
		'13'								[id_parametro_grupo],
		'13'								[id_parametro_tipo],
		replace(P05.Numero_PO_HIA,' ','')					[valor],
		P05.Num_Proc_HIA					[num_proc],
		P05.dt_ins,
		StopSend.Cd_Pes,
		StopSend.Campo_Dados
	from 
		PO_HIA P05
		join House_Imp_Aer		HOU with(nolock) on HOU.Num_Proc_HIA = P05.Num_Proc_HIA
		left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Consig_HIA = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Consig_HIA = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		left join Campo_Pessoa	StopSend with(nolock) on HOU.Cd_Consig_HIA = StopSend.Cd_Pes and StopSend.Id_Campo = 26
		left join E_Mix_Consulta E_Mix with(nolock) on E_mix.num_proc = P05.Num_Proc_HIA and E_mix.id_consulta_tipo = '8'
		Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=Hou.Num_Proc_HIA and DOC.ID_DC=5 
	where 	
		P05.ID_DC = 5 
		--and P05.dt_ins > GETDATE() - 90
		and P05.dt_ins > '2015-06-01'
		and ID_Empresa.Cd_Pes is not null
		and ID_CNPJ.Cd_Pes is not null
		and E_mix.num_proc is null	
		and Doc.Anexado_Em is null 	
		and Numero_PO_HIA like '%-%'
		and isnull(StopSend.Campo_Dados,'2') = '2'

Union all


select 
		'102'								[id_cliente],
		'139'								[id_integracao],
		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],
		'1'									[id_servico],
		ID_Empresa.Campo_Dados				[id_empresa] ,
		ID_CNPJ.Campo_Dados					[id_cnpj],
		'8'									[id_consulta_tipo]	,
		'13'								[id_parametro_grupo],
		'13'								[id_parametro_tipo],
		replace(P05.Numero_PO_HIO,' ','')					[valor],
		P05.Num_Proc_HIO					[num_proc],
		P05.dt_ins,
		StopSend.Cd_Pes,
		StopSend.Campo_Dados
	from 
		PO_HIO P05
		join House_Imp_Out		HOU with(nolock) on HOU.Num_Proc_HIO = P05.Num_Proc_HIO
		left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Consig_HIO = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Consig_HIO = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		left join Campo_Pessoa	StopSend with(nolock) on HOU.Cd_Consig_HIO = StopSend.Cd_Pes and StopSend.Id_Campo = 26
		left join E_Mix_Consulta E_Mix with(nolock) on E_mix.num_proc = P05.Num_Proc_HIO and E_mix.id_consulta_tipo = '8'
		Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=Hou.Num_Proc_HIO and DOC.ID_DC=5 
	where 	
		P05.ID_DC = 5 
		--and P05.dt_ins > GETDATE() - 90
		and P05.dt_ins > '2015-06-01'
		and ID_Empresa.Cd_Pes is not null
		and ID_CNPJ.Cd_Pes is not null
		and E_mix.num_proc is null	
		and Doc.Anexado_Em is null 	
		and Numero_PO_HIO like '%-%'
		and isnull(StopSend.Campo_Dados,'2') = '2'
OPTION(HASH JOIN)
GO
