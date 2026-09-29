SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_E_Mix_Consulta_Extrato_Sel '204','31','25','89','D'
CREATE Procedure [dbo].[spATL_E_Mix_Consulta_Extrato_Sel]--'204','31',
(
	@ID_DC				INT,
	@Id_Consulta_Tipo	int,
	@Id_Parametro_Grupo	INT,
	@Id_Parametro_Tipo	int,
	@Tipo				varchar(1)
)
			
AS

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
		PO_HEM P
		join House_Exp_Mar		HOU with(nolock) on HOU.Num_Proc_HEM = P.Num_Proc_HEM
        join llp_Exp_Mar		llp with(nolock) on HOU.Num_Proc_HEM = llp.Num_Proc_Lem
        join Localidade		    ORG with(nolock) on HOU.Cd_Org_HEM = ORG.Cd_Local
		join Campo_Pessoa	ID_Empresa with(nolock) on HOU.Cd_Export_HEM = ID_Empresa.Cd_Pes and ID_Empresa.Id_Campo = 12
		join Campo_Pessoa	ID_CNPJ with(nolock) on HOU.Cd_Export_HEM = ID_CNPJ.Cd_Pes and ID_CNPJ.Id_Campo = 13
		left join E_Mix_Consulta E_Mix with(nolock) on E_mix.num_proc = P.Num_Proc_HEM and E_mix.id_consulta_tipo = @Id_Consulta_Tipo
		Left Join Doc_Anexos DOC with(nolock) on DOC.Num_Proc=Hou.Num_Proc_HEM and DOC.ID_DC=@ID_DC
	where 	
		P.ID_DC = @ID_DC
        --and P.num_proc_hem in ('EMOXT202010022BR','EMOXT202010016BR','EMCSR202010103BR','EMCSR202008074BR')
		-- and P.dt_ins > GETDATE() -120
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
 		PO_HEA P
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
 		-- top 1
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
 		PO_HEO P
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
		
	order by P.dt_ins
OPTION(HASH JOIN)

GO
