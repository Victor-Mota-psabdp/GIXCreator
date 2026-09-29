SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_E_Mix_Consulta_Extrato_Teste_Sel] '6','9','13','13','I'
--[spE_Mix_Consulta_ExtratoCI_SEL]
--[spE_Mix_Consulta_ExtratoDI_SEL]
CREATE Procedure [dbo].[spATL_E_Mix_Consulta_Extrato_Teste_Sel]--'204','31',
(
	@ID_DC				INT,
	@Id_Consulta_Tipo	int,
	@Id_Parametro_Grupo	INT,
	@Id_Parametro_Tipo	int,
	@Tipo				varchar(1)
)
			
AS

if @Tipo = 'D'
	BEGIN
		select		
			E_Mix.Id,
			'102'								[id_cliente],
			'139'								[id_integracao],
			'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],
			'1'									[id_servico],
			ID_Empresa.Campo_Dados				[id_empresa] ,
			ID_CNPJ.Campo_Dados					[id_cnpj],
			--'31'								[id_consulta_tipo],
			@Id_Consulta_Tipo					[id_consulta_tipo],
			@Id_Parametro_Grupo 				[id_parametro_grupo],--'25'								[id_parametro_grupo],
			@Id_Parametro_Tipo					[id_parametro_tipo], --'89'								[id_parametro_tipo],
			P.Numero_PO_HEM						[valor],
			P.Num_Proc_HEM						[num_proc],
			P.dt_ins,
			LLP.ATD_Lem [ATD],
			ORG.Nome_Local [Origem]
			,llp.ID_Status,
			llp.Canal_Lem channel
		from 
			PO_HEM P with(nolock)
			join House_Exp_Mar		HOU with(nolock) on HOU.Num_Proc_HEM = P.Num_Proc_HEM
			join llp_Exp_Mar		llp with(nolock) on HOU.Num_Proc_HEM = llp.Num_Proc_Lem
			join Localidade		    ORG with(nolock) on HOU.Cd_Org_HEM = ORG.Cd_Local
			join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Export_HEM = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
			join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Export_HEM = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
			left join E_Mix_Consulta E_Mix with(nolock) on E_mix.num_proc = P.Num_Proc_HEM and E_mix.id_consulta_tipo = @Id_Consulta_Tipo
			Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=Hou.Num_Proc_HEM and DOC.ID_DC=@ID_DC
		where 	
			P.ID_DC = @ID_DC
			and ID_Empresa.Cd_Pes is not null
			and ID_CNPJ.Cd_Pes is not null
			and E_mix.num_proc is null	
			and Doc.Anexado_Em is null
			and LEN(P.Numero_PO_HEM) = 15
			and isnull(llp.ID_Status,'0') < 9
			and P.Numero_PO_HEM like '%-%'

	 Union all

 		select  		
 			E_Mix.Id,
 			'102'								[id_cliente],
 			'139'								[id_integracao],
 			'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],
 			'1'									[id_servico],
 			ID_Empresa.Campo_Dados				[id_empresa] ,
 			ID_CNPJ.Campo_Dados					[id_cnpj],
 			--'31'								[id_consulta_tipo]	,
 			@Id_Consulta_Tipo					[id_consulta_tipo],
 			@Id_Parametro_Grupo 				[id_parametro_grupo],--'25'								[id_parametro_grupo],
 			@Id_Parametro_Tipo					[id_parametro_tipo], --'89'								[id_parametro_tipo],
 			--replace(replace(P.Numero_PO_HEA,'/',''),'-','')					[valor],
 			P.Numero_PO_HEA					 [valor],
 			P.Num_Proc_HEA					[num_proc],
 			P.dt_ins,
			 LLP.ATD_Lea [ATD],
			 ORG.Nome_Local [Origem]
			 ,llp.ID_Status,
			llp.Canal_Lea channel
 		from 
 			PO_HEA P with(nolock)
 			join House_Exp_Aer		HOU with(nolock) on HOU.Num_Proc_HEA = P.Num_Proc_HEA
			 join LLP_Exp_Aer		llp with(nolock) on HOU.Num_Proc_HEa = llp.Num_Proc_Lea
			 join Localidade		    ORG with(nolock) on HOU.Cd_Org_HEa = ORG.Cd_Local
 			join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Export_HEA = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
 			join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Export_HEA = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
 			left join E_Mix_Consulta E_Mix with(nolock) on E_mix.num_proc = P.Num_Proc_HEA and E_mix.id_consulta_tipo = @Id_Consulta_Tipo
 			Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=Hou.Num_Proc_HEA and DOC.ID_DC=@ID_DC
 		where 	
 			P.ID_DC = @ID_DC		
 			-- and P.dt_ins > GETDATE() -120
 			and ID_Empresa.Cd_Pes is not null
 			and ID_CNPJ.Cd_Pes is not null
 			and E_mix.num_proc is null	
 			and Doc.Anexado_Em is null 			
 			and LEN(P.Numero_PO_HEA) = 15
			and isnull(llp.ID_Status,'0') < 9
			and P.Numero_PO_HEA like '%-%'

	 Union all

 		select 
 			E_Mix.Id,
 			'102'								[id_cliente],
 			'139'								[id_integracao],
 			'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],
 			'1'									[id_servico],
 			ID_Empresa.Campo_Dados				[id_empresa] ,
 			ID_CNPJ.Campo_Dados					[id_cnpj],
 			--'31'								[id_consulta_tipo]	,
 			@Id_Consulta_Tipo					[id_consulta_tipo],
 			@Id_Parametro_Grupo 				[id_parametro_grupo],--'25'								[id_parametro_grupo],
 			@Id_Parametro_Tipo					[id_parametro_tipo], --'89'								[id_parametro_tipo],
 			--replace(replace(P.Numero_PO_HEO,'/',''),'-','')					[valor],
 			P.Numero_PO_HEO					 [valor],
 			P.Num_Proc_HEO					[num_proc],
 			P.dt_ins,
			 LLP.ATD_Leo [ATD],
			 ORG.Nome_Local [Origem]
			 ,llp.ID_Status,
			llp.Canal_Leo channel
 		from 
 			PO_HEO P with(nolock)
 			join House_Exp_Out		HOU with(nolock) on HOU.Num_Proc_HEO = P.Num_Proc_HEO
			 join LLP_Exp_out		llp with(nolock) on HOU.Num_Proc_HEo = llp.Num_Proc_Leo
			 join Localidade		    ORG with(nolock) on HOU.Cd_Org_HEO = ORG.Cd_Local
 			join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Export_HEO = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
 			join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Export_HEO = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
 			left join E_Mix_Consulta E_Mix with(nolock) on E_mix.num_proc = P.Num_Proc_HEO and E_mix.id_consulta_tipo = @Id_Consulta_Tipo
 			Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=Hou.Num_Proc_HEO and DOC.ID_DC=@ID_DC
 		where 	
 			P.ID_DC = @ID_DC 
 			-- and P.dt_ins > GETDATE()-120
 			and ID_Empresa.Cd_Pes is not null
 			and ID_CNPJ.Cd_Pes is not null
 			and E_mix.num_proc is null	
 			and Doc.Anexado_Em is null 	
 			and LEN(P.Numero_PO_HEO)  = 15
			and isnull(llp.ID_Status,'0') < 9
			and P.Numero_PO_HEO like '%-%'

		union all

		select		
			E_Mix.Id,
			'102'								[id_cliente],
			'139'								[id_integracao],
			'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],
			'1'									[id_servico],
			ID_Empresa.Campo_Dados				[id_empresa] ,
			ID_CNPJ.Campo_Dados					[id_cnpj],
			@Id_Consulta_Tipo					[id_consulta_tipo],
			@Id_Parametro_Grupo 				[id_parametro_grupo],--'25'								[id_parametro_grupo],
			@Id_Parametro_Tipo					[id_parametro_tipo], --'89'								[id_parametro_tipo],
			P.Numero_PO_HIM						[valor],
			UPPER(P.Num_Proc_HIM)				[num_proc],
			P.dt_ins,
			LLP.ATD_LIM [ATD],
			ORG.Nome_Local [OrigIM]
			,llp.ID_Status,
			llp.Canal_LIM channel
		from 
			PO_HIM P with(nolock)
			join House_Imp_Mar			HOU			with(nolock) on HOU.Num_Proc_HIM = P.Num_Proc_HIM
			join LLP_Imp_Mar			LLP			with(nolock) on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
			join Localidade				ORG			with(nolock) on HOU.Cd_Org_HIM = ORG.Cd_Local
			left join Campo_Pessoa		ID_Empresa	with(nolock) on HOU.Cd_Consig_HIM = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
			left join Campo_Pessoa		ID_CNPJ		with(nolock) on HOU.Cd_Consig_HIM = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
			left join E_Mix_Consulta	E_Mix		with(nolock) on E_mix.num_proc = P.Num_Proc_HIM and E_mix.id_consulta_tipo = @Id_Consulta_Tipo
			Left Join Doc_Anexos		DOC			with(nolock) on DOC.Num_Proc=Hou.Num_Proc_HIM and DOC.ID_DC=@ID_DC
		where
			P.ID_DC = @ID_DC
			and P.dt_ins > '2018-01-01'
			and ID_Empresa.Cd_Pes is not null
			and ID_CNPJ.Cd_Pes is not null
			and E_mix.num_proc is null
			and Doc.Anexado_Em is null 
			and LEN(P.Numero_PO_HIM) = 12
			and isnull(llp.ID_Status,'0') < 9
			and P.Numero_PO_HIM like '%/%'

	 Union all 

 		select  		
 			E_Mix.Id,
 			'102'								[id_cliente],
 			'139'								[id_integracao],
 			'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],
 			'1'									[id_servico],
 			ID_Empresa.Campo_Dados				[id_empresa] ,
 			ID_CNPJ.Campo_Dados					[id_cnpj],
 			@Id_Consulta_Tipo					[id_consulta_tipo],
 			@Id_Parametro_Grupo 				[id_parametro_grupo],--'25'								[id_parametro_grupo],
 			@Id_Parametro_Tipo					[id_parametro_tipo], --'89'								[id_parametro_tipo],
 			P.Numero_PO_HIA						[valor],
 			UPPER(P.Num_Proc_HIA)				[num_proc],
 			P.dt_ins,
			 LLP.ATD_LIA [ATD],
			 ORG.Nome_Local [Origem]
			 ,llp.ID_Status,
			llp.Canal_LIA channel
 		from 
 			PO_HIA P with(nolock)
 			join House_Imp_Aer		HOU			with(nolock) on HOU.Num_Proc_HIA = P.Num_Proc_HIA
			 join LLP_Imp_Aer		llp			with(nolock) on HOU.Num_Proc_HIA = llp.Num_Proc_LIA
			 join Localidade		ORG			with(nolock) on HOU.Cd_Org_HIA = ORG.Cd_Local
 			left join Campo_Pessoa	ID_Empresa	with(nolock) on HOU.Cd_Consig_HIA = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
 			left join Campo_Pessoa	ID_CNPJ		with(nolock) on HOU.Cd_Consig_HIA = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
 			left join E_Mix_Consulta E_Mix		with(nolock) on E_mix.num_proc = P.Num_Proc_HIA and E_mix.id_consulta_tipo = @Id_Consulta_Tipo
 			Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=Hou.Num_Proc_HIA and DOC.ID_DC=@ID_DC
 		where 	
 			P.ID_DC = @ID_DC
			and P.dt_ins > '2018-01-01'
 			and ID_Empresa.Cd_Pes is not null
 			and ID_CNPJ.Cd_Pes is not null
 			and E_mix.num_proc is null	
			and Doc.Anexado_Em is null 
			and LEN(P.Numero_PO_HIA) = 12
			and isnull(llp.ID_Status,'0') < 9
			and P.Numero_PO_HIA like '%/%'

	 Union all


 		select 
 			-- top 1
 			E_Mix.Id,
 			'102'								[id_cliente],
 			'139'								[id_integracao],
 			'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],
 			'1'									[id_servico],
 			ID_Empresa.Campo_Dados				[id_empresa] ,
 			ID_CNPJ.Campo_Dados					[id_cnpj],
 			@Id_Consulta_Tipo					[id_consulta_tipo],
 			@Id_Parametro_Grupo 				[id_parametro_grupo],--'25'								[id_parametro_grupo],
 			@Id_Parametro_Tipo					[id_parametro_tipo], --'89'								[id_parametro_tipo],
 			P.Numero_PO_HIO						[valor],
 			UPPER(P.Num_Proc_HIO)				[num_proc],
 			P.dt_ins,
			 LLP.ATD_LIO [ATD],
			 ORG.Nome_Local [Origem]
			 ,llp.ID_Status,
			llp.Canal_LIO channel
 		from 
 			PO_HIO P with(nolock)
 			join House_Imp_Out			HOU			with(nolock) on HOU.Num_Proc_HIO = P.Num_Proc_HIO
			 join LLP_Imp_Out			LLP			with(nolock) on HOU.Num_Proc_HIO = LLP.Num_Proc_LIO
			 join Localidade			ORG			with(nolock) on HOU.Cd_Org_HIO = ORG.Cd_Local
 			left join Campo_Pessoa		ID_Empresa with(nolock) on HOU.Cd_Consig_HIO = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
 			left join Campo_Pessoa		ID_CNPJ		with(nolock) on HOU.Cd_Consig_HIO = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
 			left join E_Mix_Consulta	E_Mix		with(nolock) on E_mix.num_proc = P.Num_Proc_HIO and E_mix.id_consulta_tipo = @Id_Consulta_Tipo
 			Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=Hou.Num_Proc_HIO and DOC.ID_DC=@ID_DC
 		where 	
 			P.ID_DC = @ID_DC 
			and P.dt_ins > '2018-01-01'
 			and ID_Empresa.Cd_Pes is not null
 			and ID_CNPJ.Cd_Pes is not null
 			and E_mix.num_proc is null	
 			and Doc.Anexado_Em is null 	
 			and LEN(P.Numero_PO_HIO) = 12
			and isnull(llp.ID_Status,'0') < 9
			and P.Numero_PO_HIO like '%/%'
		
		order by P.dt_ins

		OPTION(HASH JOIN)

	END

if @Tipo = 'C'
	begin
		select		
		E_Mix.Id,
		'102'								[id_cliente],
		'139'								[id_integracao],
		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],
		'1'									[id_servico],
		ID_Empresa.Campo_Dados				[id_empresa] ,
		ID_CNPJ.Campo_Dados					[id_cnpj],
		@Id_Consulta_Tipo					[id_consulta_tipo],
		@Id_Parametro_Grupo 				[id_parametro_grupo],
		@Id_Parametro_Tipo					[id_parametro_tipo], 
		P.Numero_PO_HIM						[valor],
		UPPER(P.Num_Proc_HIM)				[num_proc],
		P.dt_ins,
        LLP.ATD_LIM [ATD],
        ORG.Nome_Local [OrigIM]
        ,llp.ID_Status,
		llp.Canal_LIM channel
	from 
		PO_HIM P with(nolock)
		join House_Imp_Mar			HOU			with(nolock) on HOU.Num_Proc_HIM = P.Num_Proc_HIM
        join LLP_Imp_Mar			LLP			with(nolock) on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
        join Localidade				ORG			with(nolock) on HOU.Cd_Org_HIM = ORG.Cd_Local
		left join Campo_Pessoa		ID_Empresa	with(nolock) on HOU.Cd_Consig_HIM = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		left join Campo_Pessoa		ID_CNPJ		with(nolock) on HOU.Cd_Consig_HIM = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		left join E_Mix_Consulta	E_Mix		with(nolock) on E_mix.num_proc = P.Num_Proc_HIM and E_mix.id_consulta_tipo = @Id_Consulta_Tipo	
		Left Join Tarefas_Processos T4			with(nolock) on T4.Num_Proc = P.Num_Proc_HIM  and T4.ID_Task = 4
	where
		P.ID_DC = @ID_DC
		and P.dt_ins > '2018-01-01'
		and ID_Empresa.Cd_Pes is not null
		and ID_CNPJ.Cd_Pes is not null
		and E_mix.num_proc is null
		and T4.Dt_Conclusao is null
		and LEN(P.Numero_PO_HIM) = 12
		and isnull(llp.ID_Status,'0') < 9
		and P.Numero_PO_HIM like '%/%'

 Union all 

 	select  		
 		E_Mix.Id,
 		'102'								[id_cliente],
 		'139'								[id_integracao],
 		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],
 		'1'									[id_servico],
 		ID_Empresa.Campo_Dados				[id_empresa] ,
 		ID_CNPJ.Campo_Dados					[id_cnpj],
 		@Id_Consulta_Tipo					[id_consulta_tipo],
 		@Id_Parametro_Grupo 				[id_parametro_grupo],
 		@Id_Parametro_Tipo					[id_parametro_tipo],
 		P.Numero_PO_HIA						[valor],
 		UPPER(P.Num_Proc_HIA)				[num_proc],
 		P.dt_ins,
         LLP.ATD_LIA [ATD],
         ORG.Nome_Local [Origem]
         ,llp.ID_Status,
		llp.Canal_LIA channel
 	from 
 		PO_HIA P with(nolock)
 		join House_Imp_Aer		HOU			with(nolock) on HOU.Num_Proc_HIA = P.Num_Proc_HIA
         join LLP_Imp_Aer		llp			with(nolock) on HOU.Num_Proc_HIA = llp.Num_Proc_LIA
         join Localidade		ORG			with(nolock) on HOU.Cd_Org_HIA = ORG.Cd_Local
 		left join Campo_Pessoa	ID_Empresa	with(nolock) on HOU.Cd_Consig_HIA = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
 		left join Campo_Pessoa	ID_CNPJ		with(nolock) on HOU.Cd_Consig_HIA = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
 		left join E_Mix_Consulta E_Mix		with(nolock) on E_mix.num_proc = P.Num_Proc_HIA and E_mix.id_consulta_tipo = @Id_Consulta_Tipo
		Left Join Tarefas_Processos T4		with(nolock) on T4.Num_Proc = P.Num_Proc_HIA  and T4.ID_Task = 4
 	where 	
 		P.ID_DC = @ID_DC
		and P.dt_ins > '2018-01-01'
 		and ID_Empresa.Cd_Pes is not null
 		and ID_CNPJ.Cd_Pes is not null
 		and E_mix.num_proc is null	
		and T4.Dt_Conclusao is null
		and LEN(P.Numero_PO_HIA) = 12
		and isnull(llp.ID_Status,'0') < 9
		and P.Numero_PO_HIA like '%/%'

 Union all

 	select 
 		E_Mix.Id,
 		'102'								[id_cliente],
 		'139'								[id_integracao],
 		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],
 		'1'									[id_servico],
 		ID_Empresa.Campo_Dados				[id_empresa] ,
 		ID_CNPJ.Campo_Dados					[id_cnpj],
 		@Id_Consulta_Tipo					[id_consulta_tipo],
 		@Id_Parametro_Grupo 				[id_parametro_grupo],
 		@Id_Parametro_Tipo					[id_parametro_tipo], 
 		P.Numero_PO_HIO						[valor],
 		UPPER(P.Num_Proc_HIO)				[num_proc],
 		P.dt_ins,
         LLP.ATD_LIO [ATD],
         ORG.Nome_Local [Origem]
         ,llp.ID_Status,
		llp.Canal_LIO channel
 	from 
 		PO_HIO P with(nolock)
 		join House_Imp_Out			HOU			with(nolock) on HOU.Num_Proc_HIO = P.Num_Proc_HIO
         join LLP_Imp_Out			LLP			with(nolock) on HOU.Num_Proc_HIO = LLP.Num_Proc_LIO
         join Localidade			ORG			with(nolock) on HOU.Cd_Org_HIO = ORG.Cd_Local
 		left join Campo_Pessoa		ID_Empresa with(nolock) on HOU.Cd_Consig_HIO = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
 		left join Campo_Pessoa		ID_CNPJ		with(nolock) on HOU.Cd_Consig_HIO = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
 		left join E_Mix_Consulta	E_Mix		with(nolock) on E_mix.num_proc = P.Num_Proc_HIO and E_mix.id_consulta_tipo = @Id_Consulta_Tipo
		Left Join Tarefas_Processos T4			with(nolock) on T4.Num_Proc = P.Num_Proc_HIO  and T4.ID_Task = 4
 	where 	
 		P.ID_DC = @ID_DC 
		and P.dt_ins > '2018-01-01'
 		and ID_Empresa.Cd_Pes is not null
 		and ID_CNPJ.Cd_Pes is not null
 		and E_mix.num_proc is null	
 		and T4.Dt_Conclusao is null 	
 		and LEN(P.Numero_PO_HIO) = 12
		and isnull(llp.ID_Status,'0') < 9
		and P.Numero_PO_HIO like '%/%'
	end

if @Tipo = 'I'
	begin
		select		
		E_Mix.Id,
		'102'								[id_cliente],
		'139'								[id_integracao],
		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],
		'1'									[id_servico],
		ID_Empresa.Campo_Dados				[id_empresa] ,
		ID_CNPJ.Campo_Dados					[id_cnpj],
		@Id_Consulta_Tipo					[id_consulta_tipo],
		@Id_Parametro_Grupo 				[id_parametro_grupo],
		@Id_Parametro_Tipo					[id_parametro_tipo], 
		P.Numero_PO_HIM						[valor],
		UPPER(P.Num_Proc_HIM)				[num_proc],
		P.dt_ins,
        LLP.ATD_LIM [ATD],
        ORG.Nome_Local [OrigIM]
        ,llp.ID_Status,
		llp.Canal_LIM channel
	from 
		PO_HIM P with(nolock)
		join House_Imp_Mar			HOU			with(nolock) on HOU.Num_Proc_HIM = P.Num_Proc_HIM
        join LLP_Imp_Mar			LLP			with(nolock) on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
        join Localidade				ORG			with(nolock) on HOU.Cd_Org_HIM = ORG.Cd_Local
		left join Campo_Pessoa		ID_Empresa	with(nolock) on HOU.Cd_Consig_HIM = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		left join Campo_Pessoa		ID_CNPJ		with(nolock) on HOU.Cd_Consig_HIM = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		left join E_Mix_Consulta	E_Mix		with(nolock) on E_mix.num_proc = P.Num_Proc_HIM and E_mix.id_consulta_tipo = @Id_Consulta_Tipo
		Left Join Doc_Anexos		DOC			with(nolock) on DOC.Num_Proc=Hou.Num_Proc_HIM and DOC.ID_DC=@ID_DC
		Join Tarefas_Processos		T4			with(nolock) on T4.Num_Proc = P.Num_Proc_HIM  and T4.ID_Task = 4
	where 			
		P.ID_DC = @ID_DC
		and P.dt_ins > '2018-01-01'
		and ID_Empresa.Cd_Pes is not null
		and ID_CNPJ.Cd_Pes is not null
		and E_mix.num_proc is null
		and Doc.Anexado_Em is null 	
		and T4.Dt_Conclusao is not null	
		and LEN(P.Numero_PO_HIM) = 12
		and isnull(llp.ID_Status,'0') < 9
		and P.Numero_PO_HIM like '%/%'

 Union all 

 	select  		
 		E_Mix.Id,
 		'102'								[id_cliente],
 		'139'								[id_integracao],
 		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],
 		'1'									[id_servico],
 		ID_Empresa.Campo_Dados				[id_empresa] ,
 		ID_CNPJ.Campo_Dados					[id_cnpj],
 		@Id_Consulta_Tipo					[id_consulta_tipo],
 		@Id_Parametro_Grupo 				[id_parametro_grupo],
 		@Id_Parametro_Tipo					[id_parametro_tipo], 
 		P.Numero_PO_HIA						[valor],
 		UPPER(P.Num_Proc_HIA)				[num_proc],
 		P.dt_ins,
         LLP.ATD_LIA [ATD],
         ORG.Nome_Local [Origem]
         ,llp.ID_Status,
		llp.Canal_LIA channel
 	from 
 		PO_HIA P with(nolock)
 		join House_Imp_Aer			HOU			with(nolock) on HOU.Num_Proc_HIA = P.Num_Proc_HIA
         join LLP_Imp_Aer			LLP			with(nolock) on HOU.Num_Proc_HIA = llp.Num_Proc_LIA
         join Localidade			ORG			with(nolock) on HOU.Cd_Org_HIA = ORG.Cd_Local
 		left join Campo_Pessoa		ID_Empresa	with(nolock) on HOU.Cd_Consig_HIA = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
 		left join Campo_Pessoa		ID_CNPJ		with(nolock) on HOU.Cd_Consig_HIA = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
 		left join E_Mix_Consulta	E_Mix		with(nolock) on E_mix.num_proc = P.Num_Proc_HIA and E_mix.id_consulta_tipo = @Id_Consulta_Tipo
 		Left Join Doc_Anexos		DOC			with(nolock) on DOC.Num_Proc=Hou.Num_Proc_HIA and DOC.ID_DC=@ID_DC
		Join Tarefas_Processos		T4			with(nolock) on T4.Num_Proc = P.Num_Proc_HIA  and T4.ID_Task = 4
 	where 	
 		P.ID_DC = @ID_DC
		and P.dt_ins > '2018-01-01'
 		and ID_Empresa.Cd_Pes is not null
 		and ID_CNPJ.Cd_Pes is not null
 		and E_mix.num_proc is null	
		and Doc.Anexado_Em is null 	
		and T4.Dt_Conclusao is not null	
		and LEN(P.Numero_PO_HIA) = 12
		and isnull(llp.ID_Status,'0') < 9
		and P.Numero_PO_HIA like '%/%'

 Union all

 	select  		
 		E_Mix.Id,
 		'102'								[id_cliente],
 		'139'								[id_integracao],
 		'b71b7b989a9dcb68026483c1c5ffe47d'	[contra_senha],
 		'1'									[id_servico],
 		ID_Empresa.Campo_Dados				[id_empresa] ,
 		ID_CNPJ.Campo_Dados					[id_cnpj],
 		@Id_Consulta_Tipo					[id_consulta_tipo],
 		@Id_Parametro_Grupo 				[id_parametro_grupo],
 		@Id_Parametro_Tipo					[id_parametro_tipo], 
 		P.Numero_PO_HIO						[valor],
 		UPPER(P.Num_Proc_HIO)				[num_proc],
 		P.dt_ins,
         LLP.ATD_LIO [ATD],
         ORG.Nome_Local [Origem]
         ,llp.ID_Status,
		llp.Canal_LIO channel
 	from 
 		PO_HIO P with(nolock)
 		join House_Imp_Out			HOU			with(nolock) on HOU.Num_Proc_HIO = P.Num_Proc_HIO
         join LLP_Imp_Out			LLP			with(nolock) on HOU.Num_Proc_HIO = LLP.Num_Proc_LIO
         join Localidade			ORG			with(nolock) on HOU.Cd_Org_HIO = ORG.Cd_Local
 		left join Campo_Pessoa		ID_Empresa	with(nolock) on HOU.Cd_Consig_HIO = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
 		left join Campo_Pessoa		ID_CNPJ		with(nolock) on HOU.Cd_Consig_HIO = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
 		left join E_Mix_Consulta	E_Mix		with(nolock) on E_mix.num_proc = P.Num_Proc_HIO and E_mix.id_consulta_tipo = @Id_Consulta_Tipo
		Left Join Doc_Anexos		DOC			with(nolock) on DOC.Num_Proc=Hou.Num_Proc_HIO and DOC.ID_DC=@ID_DC
		Join Tarefas_Processos		T4			with(nolock) on T4.Num_Proc = P.Num_Proc_HIO  and T4.ID_Task = 4
 	where 	
 		P.ID_DC = @ID_DC 
		and P.dt_ins > '2018-01-01'
 		and ID_Empresa.Cd_Pes is not null
 		and ID_CNPJ.Cd_Pes is not null
 		and E_mix.num_proc is null	
 		and Doc.Anexado_Em is null 	
		and T4.Dt_Conclusao is not null	
 		and LEN(P.Numero_PO_HIO) = 12
		and isnull(llp.ID_Status,'0') < 9
		and P.Numero_PO_HIO like '%/%'
	end



GO
