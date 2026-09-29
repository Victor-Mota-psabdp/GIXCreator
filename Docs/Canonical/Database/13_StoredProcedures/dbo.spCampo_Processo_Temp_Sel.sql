SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------select * from Campo_Processo_Temp
--SELECT * FROM PO_Temp WHERE Num_Proc IS NOT NULL
--[spCampo_Processo_Temp_Sel]'8888','IMFMC201909001BR','B'
--SELECT * FROM House_Temp WHERE ID = 11285 Num_Proc IS NOT NULL AND Cd_Consig IS NOT NULL
--SELECT * FROM House_Temp WHERE Num_Proc IS NOT NULL = 'IMCSR201909296BR'
--11285	1708703	US1007541891
--SELECT * FROM House_Temp WHERE ID = 8888
--SELECT * FROM PO_Temp WHERE ID = 8888 --Intl_Reference = 'US1007541891'
--11285	1708703	US1007541891
--SELECT * FROM Campo_Processo_Temp WHERE ID = 8888 
--SELECT * FROM ATL_INT.DBO.GIX_XML WHERE ID_Req = 1708703 
CREATE Procedure [dbo].[spCampo_Processo_Temp_Sel]--'11409','D'
(
	@ID			BIGINT,
	@JOB		varchar(16),
	@Tipo		char(1)
)

as

if @Tipo = 'A'  or @Tipo = 'B' 
	Begin
		select 
			convert(varchar(25),'Saved') [Status],
			H.ID						[ID],
			H.ID_Req					[ID Req],
			H.Intl_Reference			[Intl Reference],
			--HOU.ID_House_Temp,
			H.Num_Proc					[JOB],
			
			tcc.id_campo				[Field Code],			
			tcc.Descr_Campo				[Field Description],			
			isnull(H.Campo_Dados,'')	[Information Code],	
			convert(varchar(500),'')						[Information Value],		
			
			tcc.cod_busca				[Search Code],	
			tcc.Tab_Relacionada			[Related Table],
			tcc.Tipo					[Type Code],
			T.Nome_Tipo					[Type Name],
			tcc.Campo_Exibicao			[Display Field],
			TCC.Where_Field				[Where Field],
			TCC.Cd_Pes_Grupo			[Group Code],
			A.Apelido					[Group Name],
			H.Cd_Usuario				[User Code],
			Us.Nome_Usuario				[User],
			H.dt_insert					[Insert Date],
			''							[View]			
		from Tipo_Campo_Cliente tcc with(nolock)
		left join Campo_Processo_Temp H with(nolock) on tcc.Id_Campo  = H.Id_Campo  and H.ID = @ID
		left join Usuario Us with(nolock)	on  Us.Cd_Usuario  = H.cd_usuario
		left join Pessoa A with(nolock)	on A.CD_PES = tcc.Cd_Pes_Grupo
		LEFT JOIN Tipo_Variavel T  with(nolock) ON T.Cd_Tipo = tcc.TIPO
		LEFT JOIN House_Temp hou  with(nolock) ON hou.ID = H.ID -- hou.Num_Proc = H.Num_Proc	
		left join Pessoa_LLP P with(nolock) on P.Cd_Pes = hou.Cd_Consig
		LEFT join tipo_campo_cliente_modais M with (nolock) on M.id_campo = TCC.id_campo
	where
		
		TCC.cd_pes_grupo in ('10017',p.Cd_Pes_Grupo) -- @Grupo) 
		and TCC.Tipo <> 'X'
		and (( len(@JOB)=16 and M.house=1) or (len(@JOB)=14 and M.master=1 ))
		and ((left(@JOB,1) = 'E' and Export = '1') or (left(@JOB,1) = 'I' and Import = '1'))
		and ((substring(@JOB,2,1) = 'A' and Air = '1') 
			or (substring(@JOB,2,1) = 'M' and Ocean = '1') 
			or (substring(@JOB,2,1) = 'O' and Other = '1'))

	order by
		Descr_Campo			
	End
	
if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select 
			convert(varchar(25),'Saved') [Status],
				H.ID						[ID],
				H.ID_Req					[ID Req],
				H.Intl_Reference			[Intl Reference],
				--HOU.ID_House_Temp,
				H.Num_Proc					[JOB],
				
				tcc.id_campo				[Field Code],			
				tcc.Descr_Campo				[Field Description],			
					isnull(H.Campo_Dados,'')	[Information Code],	
		convert(varchar(500),'')						[Information Value],
						
				tcc.cod_busca				[Search Code],	
				tcc.Tab_Relacionada			[Related Table],
				tcc.Tipo					[Type Code],
				T.Nome_Tipo					[Type Name],
				tcc.Campo_Exibicao			[Display Field],
				TCC.Where_Field				[Where Field],
				TCC.Cd_Pes_Grupo			[Group Code],
				A.Apelido					[Group Name],
				H.Cd_Usuario				[User Code],
				Us.Nome_Usuario				[User],
				H.dt_insert					[Insert Date],
			''							[View]			
			from Tipo_Campo_Cliente tcc 
			left join Campo_Processo_Temp H with(nolock) on tcc.Id_Campo  = H.Id_Campo  and H.ID = @ID
			left join Usuario Us with(nolock)	on Us.Cd_Usuario  = H.cd_usuario
			left join Pessoa A with(nolock)	on A.CD_PES = tcc.Cd_Pes_Grupo
			LEFT JOIN Tipo_Variavel T with(nolock) ON T.Cd_Tipo = tcc.TIPO
			LEFT JOIN House_Temp hou with(nolock) ON hou.ID = H.ID -- hou.Num_Proc = H.Num_Proc	
			left join Pessoa_LLP P with(nolock) on P.Cd_Pes = hou.Cd_Consig
			LEFT join tipo_campo_cliente_modais M with (nolock) on M.id_campo = TCC.id_campo
		where
		
			TCC.cd_pes_grupo in ('10017',p.Cd_Pes_Grupo) -- @Grupo) 
			and TCC.Tipo <> 'X'
			and (( len(@JOB)=16 and M.house=1) or (len(@JOB)=14 and M.master=1 ))
			and ((left(@JOB,1) = 'E' and Export = '1') or (left(@JOB,1) = 'I' and Import = '1'))
			and ((substring(@JOB,2,1) = 'A' and Air = '1') 
				or (substring(@JOB,2,1) = 'M' and Ocean = '1') 
				or (substring(@JOB,2,1) = 'O' and Other = '1'))

		order by
			Descr_Campo			
	End
	
	
GO
