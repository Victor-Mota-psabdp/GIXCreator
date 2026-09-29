SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help E_MIX_XML
-- select * from vwCliente_Alerta where num_proc = 'EMCSR202008074BR'
-- [spATL_E_MIX_XML_Sel]'31','','B'
-- [spATL_E_MIX_XML_Sel]'31','','D'
--cadu inclui as outras regas pq estava buscando caso de 2021
CREATE PROCEDURE [dbo].[spATL_E_MIX_XML_Sel]--'31','','B'
(
	@Id_Consulta_Tipo	int,	
	@Num_Proc			varchar(16),
	@Tipo				char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
Z /// Verifica Nome X Codigo

*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin			
		select 			
			C.id								[Id], --ID_Envio
			C.id_servico						[Id_Servico],	
			C.id_empresa						[Id_Empresa],
			C.id_cnpj							[Id_Cnpj],
			C.id_consulta_tipo					[Id_Consulta_Tipo],
			C.id_parametro_grupo				[Id_Parametro_Grupo],
			C.id_parametro_tipo					[Id_Parametro_Tipo],
			C.valor								[Valor],	
			C.num_proc							[Num_Proc],
			C.id_parametro_grupo				[Id_Recuperacao],
			
			E.ID								[ID_XML],
			E.Dt_Envio							[Dt_Envio],
			E.Envio_Erro						[Envio_Erro],
			E.XML_DOC							[XML_DOC],
			E.Nome_Arquivo						[Nome_Arquivo],
			E.XML_DOC2							[XML_DOC2],
			E.Dt_Retorno						[Dt_Retorno],
			E.Retorno_Erro						[Retorno_Erro]			
		from E_MIX_XML E  with(nolock)
			Join  E_Mix_Consulta C with(nolock) on E.id=C.id	
			join vwHouse_Exp HOU with(nolock) on HOU.Num_Proc = E.Num_Proc
		where
			E.id_consulta_tipo = @Id_Consulta_Tipo
			and E.Dt_Envio is null
			and HOU.ETD > GETDATE() -365
			
	End
	
if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 			
			C.id								[Id], --ID_Envio
			C.id_servico						[Id_Servico],	
			C.id_empresa						[Id_Empresa],
			C.id_cnpj							[Id_Cnpj],
			C.id_consulta_tipo					[Id_Consulta_Tipo],
			C.id_parametro_grupo				[Id_Parametro_Grupo],
			C.id_parametro_tipo					[Id_Parametro_Tipo],
			C.valor								[Valor],	
			C.num_proc							[Num_Proc],
			C.id_parametro_grupo				[Id_Recuperacao],
			
			E.ID								[ID_XML],
			E.Dt_Envio							[Dt_Envio],
			E.Envio_Erro						[Envio_Erro],
			E.XML_DOC							[XML_DOC],
			E.Nome_Arquivo						[Nome_Arquivo],
			E.XML_DOC2							[XML_DOC2],
			E.Dt_Retorno						[Dt_Retorno],
			E.Retorno_Erro						[Retorno_Erro],
            --V.ATD,
			vwExp.ATD,	

			vwExp.Canal
			--,
			--PO209.Numero_PO [PO209],
			--PO205.Numero_PO [PO205],
			--TP4.Dt_Conclusao [TP4],
			--TP15.Dt_Conclusao [TP15],
			--DA204.Nome_Arquivo [DA204],
			--DA236.Nome_Arquivo [DA236]
		from E_MIX_XML E  with(nolock)
			Join  E_Mix_Consulta C with(nolock) on E.id=C.id
            --left Join vwCliente_Alerta	V 	with(nolock) on E.Num_Proc=V.Num_Proc
			left Join vwHouse_Exp	vwExp	with(nolock) on E.Num_Proc=vwExp.Num_Proc
			--left Join vwHouse_Imp	vwImp 	with(nolock) on E.Num_Proc=vwImp.Num_Proc

			----209	Chave Acesso DUE
			--left Join vwPO_ALL	PO209	with(nolock) on E.Num_Proc=PO209.Num_Proc and PO209.ID_DC = 209
			----205	RUC
			--left Join vwPO_ALL	PO205	with(nolock) on E.Num_Proc=PO205.Num_Proc and PO205.ID_DC = 205
			----Desembaraco
			--left Join Tarefas_Processos	TP4	with(nolock) on E.Num_Proc=TP4.Num_Proc and TP4.ID_Task = 4
			----15	Averbação
			--left Join Tarefas_Processos	TP15	with(nolock) on E.Num_Proc=TP15.Num_Proc and TP15.ID_Task = 15
			----204	DUE
			--left Join Doc_Anexos	DA204	with(nolock) on E.Num_Proc=DA204.Num_Proc and DA204.Id_DC = 204
			----236	DUE - Desembaraçada
			--left Join Doc_Anexos	DA236	with(nolock) on E.Num_Proc=DA236.Num_Proc and DA236.Id_DC = 236

		where
			E.id_consulta_tipo = @Id_Consulta_Tipo
			and E.Dt_Retorno is null
			and vwExp.Id_Status not in (9)
			and ISNULL(E.Dt_Envio,'2022-01-01') > GETDATE() -365 --cadu 2026-04-21

			--and E.num_proc in ('EMOXT202603075BR')
            -- and V.ATD is not null
			--and E.Num_proc in	('EMOXT202012052BR')
			--,'EMCSR202010025BR','EMOXT202009256BR','EMOXT202010014BR','EMOXT202010207BR','EMSOL202010018BR')
			
			--and 
			-- (
			--	 vwExp.Canal is null
			--	 or
			--	 PO209.Numero_PO is null
			--	 or
			--	 PO205.Numero_PO is null
			--	 or
			--	 TP4.Dt_Conclusao is null
			--	 or
			--	 TP15.Dt_Conclusao is null
			--	 or
			--	 DA204.Nome_Arquivo is null
			--	 or
			--	 DA236.Nome_Arquivo is null
			-- )
		Order by
			E.Dt_Envio
        
	
	End

if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 			
			C.id								[Id], --ID_Envio
			C.id_servico						[Id_Servico],	
			C.id_empresa						[Id_Empresa],
			C.id_cnpj							[Id_Cnpj],
			C.id_consulta_tipo					[Id_Consulta_Tipo],
			C.id_parametro_grupo				[Id_Parametro_Grupo],
			C.id_parametro_tipo					[Id_Parametro_Tipo],
			C.valor								[Valor],	
			C.num_proc							[Num_Proc],
			C.id_parametro_grupo				[Id_Recuperacao],
			
			E.ID								[ID_XML],
			E.Dt_Envio							[Dt_Envio],
			E.Envio_Erro						[Envio_Erro],
			E.XML_DOC							[XML_DOC],
			E.Nome_Arquivo						[Nome_Arquivo],
			E.XML_DOC2							[XML_DOC2],
			E.Dt_Retorno						[Dt_Retorno],
			E.Retorno_Erro						[Retorno_Erro]
		from E_MIX_XML E  with(nolock)
			Join  E_Mix_Consulta C with(nolock) on E.id=C.id		
		where
			E.id_consulta_tipo = @Id_Consulta_Tipo
			and C.Num_Proc = @Num_Proc
	End	




if @Tipo = 'T'
	Begin			
		select 			
			C.id								[Id], --ID_Envio
			C.num_proc							[JOB],
			C.valor								[Reference],
			C.id_consulta_tipo					[Type Code],
			T.Nome_Consulta_Tipo				[Type Name],
			E.Dt_Envio							[Sent Date],
			E.Dt_Retorno						[Return Date],
			E.Retorno_Erro						[Return Message]

			----C.id_servico						[Id_Servico],	
			--C.id_empresa						[Id_Empresa],
			--C.id_cnpj							[Id_Cnpj],
			--C.id_consulta_tipo					[Id_Consulta_Tipo],
			--C.id_parametro_grupo				[Id_Parametro_Grupo],
			--C.id_parametro_tipo					[Id_Parametro_Tipo],			
			--C.id_parametro_grupo				[Id_Recuperacao],
			
			--E.ID								[ID_XML],
			
			--E.Envio_Erro						[Envio_Erro],
			--E.XML_DOC							[XML_DOC],
			--E.Nome_Arquivo						[Nome_Arquivo],
			--E.XML_DOC2							[XML_DOC2],
			
		from E_MIX_XML E  with(nolock)
			Join  E_Mix_Consulta C with(nolock) on E.id=C.id
			join E_Mix_Consulta_Tipo T with(nolock) on T.id_consulta_tipo = @Id_Consulta_Tipo
		where
			E.id_consulta_tipo = @Id_Consulta_Tipo
			and E.Dt_Envio > getdate() - 30
			
	End

if @Tipo = 'P'
	Begin			
		select 			
			C.id								[Id], --ID_Envio
			C.num_proc							[JOB],
			C.valor								[Reference],
			C.id_consulta_tipo					[Type Code],
			T.Nome_Consulta_Tipo				[Type Name],
			E.Dt_Envio							[Sent Date],
			E.Dt_Retorno						[Return Date],
			E.Retorno_Erro						[Return Message]			
		from E_MIX_XML E  with(nolock)
			Join  E_Mix_Consulta C with(nolock) on E.id=C.id
			join E_Mix_Consulta_Tipo T with(nolock) on T.id_consulta_tipo = E.Id_Consulta_Tipo
		where
			E.id_consulta_tipo = @Id_Consulta_Tipo
			and C.Num_Proc = @Num_Proc
			
	End

	

GO
