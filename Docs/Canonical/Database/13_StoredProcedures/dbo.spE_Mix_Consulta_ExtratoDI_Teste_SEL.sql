SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spE_Mix_Consulta_SEL
--spEmixXMLParaCadastro_Sel
CREATE Procedure [dbo].[spE_Mix_Consulta_ExtratoDI_Teste_SEL]
			
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
		P05.Numero_PO_HIM					[valor],
		P05.Num_Proc_HIM					[num_proc],
		P05.dt_ins
	from 
		PO_HIM P05
		join House_Imp_Mar		HOU with(nolock) on HOU.Num_Proc_HIM = P05.Num_Proc_HIM
		left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Consig_HIM = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Consig_HIM = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		left join E_Mix_Consulta E_Mix with(nolock) on E_mix.num_proc = P05.Num_Proc_HIM and E_mix.id_consulta_tipo = '8'
		Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=Hou.Num_Proc_HIM and DOC.ID_DC=5 
	where 	
		P05.ID_DC = 5 
		--and P05.dt_ins > GETDATE() -30
		and ID_Empresa.Cd_Pes is not null
		and ID_CNPJ.Cd_Pes is not null
		and E_mix.num_proc is null	
		--and Doc.Anexado_Em is null 	
		and Numero_PO_HIM like '%-%'
		and P05.Num_Proc_HIM in
		('IMFMC201201062BR',
'IMFMC201210027BR',
'IMFMC201112004BR',
'IMFMC201208099BR',
'IMFMC201208110BR',
'IMFMC201210011BR',
'IMFMC201212009BR',
'IMFMC201112001BR',
'IMFMC201201015BR',
'IMFMC201201032BR',
'IMFMC201208101BR',
'IMFMC201210032BR',
'IMFMC201208104BR',
'IMFMC201204012BR',
'IMFMC201204016BR',
'IMFMC201204067BR',
'IMFMC201112002BR',
'IMFMC201111053BR',
'IMFMC201208032BR',
'IMFMC201212015BR',
'IMFMC201204065BR',
'IMFMC201205002BR',
'IMFMC201201038BR',
'IMFMC201201031BR',
'IMFMC201210023BR',
'IMFMC201210025BR',
'IMFMC201212017BR',
'IMFMC201112003BR',
'IMFMC201201016BR',
'IMFMC201206036BR',
'IMFMC201210031BR',
'IMFMC201205004BR',
'IMFMC201210029BR',
'IMFMC201203063BR',
'IMFMC201203061BR',
'IMFMC201206022BR',
'IMFMC201206032BR',
'IMFMC201210022BR',
'IMFMC201208108BR',
'IMFMC201208112BR',
'IMFMC201212018BR',
'IMFMC201212042BR',
'IMFMC201212008BR',
'IMFMC201112029BR',
'IMFMC201201019BR',
'IMFMC201201025BR',
'IMFMC201201035BR',
'IMFMC201206031BR',
'IMFMC201212043BR',
'IMFMC201112027BR',
'IMFMC201201018BR',
'IMFMC201210033BR',
'IMFMC201208042BR',
'IMFMC201208106BR',
'IMFMC201204068BR',
'IMFMC201205048BR',
'IMFMC201201033BR',
'IMFMC201210024BR',
'IMFMC201212013BR',
'IMFMC201205001BR',
'IMFMC201205007BR',
'IMFMC201205003BR',
'IMFMC201112028BR',
'IMFMC201112026BR',
'IMFMC201203062BR',
'IMFMC201202041BR',
'IMFMC201202043BR',
'IMFMC201207037BR',
'IMFMC201208102BR',
'IMFMC201208107BR',
'IMFMC201210026BR',
'IMFMC201212012BR',
'IMFMC201112005BR',
'IMFMC201201034BR',
'IMFMC201201036BR',
'IMFMC201201065BR',
'IMFMC201208109BR',
'IMFMC201208111BR',
'IMFMC201205005BR',
'IMFMC201205006BR',
'IMFMC201203060BR',
'IMFMC201201014BR',
'IMFMC201202042BR',
'IMFMC201203047BR',
'IMFMC201201064BR',
'IMFMC201210035BR',
'IMFMC201212014BR',
'IMFMC201201063BR',
'IMFMC201112040BR',
'IMFMC201112025BR',
'IMFMC201208105BR',
'IMFMC201111055BR',
'IMFMC201204066BR',
'IMFMC201201017BR',
'IMFMC201206021BR',
'IMFMC201210028BR',
'IMFMC201210034BR',
'IMFMC201111054BR',
'IMFMC201202039BR',
'IMFMC201202040BR',
'IMFMC201201037BR',
'IMFMC201208100BR',
'IMFMC201208113BR',
'IMFMC201210010BR',
'IMFMC201212016BR',
'IMFMC201210030BR',
'IMFMC201210036BR')


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
		P05.Numero_PO_HIA					[valor],
		P05.Num_Proc_HIA					[num_proc],
		P05.dt_ins
	from 
		PO_HIA P05
		join House_Imp_Aer		HOU with(nolock) on HOU.Num_Proc_HIA = P05.Num_Proc_HIA
		left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Consig_HIA = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Consig_HIA = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		left join E_Mix_Consulta E_Mix with(nolock) on E_mix.num_proc = P05.Num_Proc_HIA and E_mix.id_consulta_tipo = '8'
		Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=Hou.Num_Proc_HIA and DOC.ID_DC=5 
	where 	
		P05.ID_DC = 5 
		--and P05.dt_ins > GETDATE() -30
		and ID_Empresa.Cd_Pes is not null
		and ID_CNPJ.Cd_Pes is not null
		and E_mix.num_proc is null	
		--and Doc.Anexado_Em is null 	
		and Numero_PO_HIA like '%-%'
		and P05.Num_Proc_HIA  in 
		('IAFMC201204001BR',
'IAFMC201204002BR',
'IAFMC201204003BR',
'IAFMC201204004BR',
'ÍAFMC201204007BR',
'IAFMC201204016BR',
'ÍAFMC201204006BR',
'IAFMC201204010BR',
'IAFMC201204011BR',
'IAFMC201204012BR',
'IAFMC201204013BR',
'IAFMC201204014BR',
'IAFMC201204015BR',
'IAFMC201204017BR',
'IAFMC201204018BR',
'IAFMC201204005BR')
		

----Union all


----select 
----		'102'								[id_cliente],
----		'139'								[id_integracao],
----		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],
----		'1'									[id_servico],
----		ID_Empresa.Campo_Dados				[id_empresa] ,
----		ID_CNPJ.Campo_Dados					[id_cnpj],
----		'8'									[id_consulta_tipo]	,
----		'13'								[id_parametro_grupo],
----		'13'								[id_parametro_tipo],
----		P05.Numero_PO_HIO					[valor],
----		P05.Num_Proc_HIO					[num_proc],
----		P05.dt_ins
----	from 
----		PO_HIO P05
----		join House_Imp_Out		HOU with(nolock) on HOU.Num_Proc_HIO = P05.Num_Proc_HIO
----		left join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Consig_HIO = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
----		left join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Consig_HIO = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
----		left join E_Mix_Consulta E_Mix with(nolock) on E_mix.num_proc = P05.Num_Proc_HIO and E_mix.id_consulta_tipo = '8'
----		Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=Hou.Num_Proc_HIO and DOC.ID_DC=5 
----	where 	
----		P05.ID_DC = 5 
----		and P05.dt_ins > GETDATE() -30
----		and ID_Empresa.Cd_Pes is not null
----		and ID_CNPJ.Cd_Pes is not null
----		and E_mix.num_proc is null	
----		and Doc.Anexado_Em is null 	
----		and Numero_PO_HIO like '%-%'
--OPTION(HASH JOIN)
GO
