SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spATL_JSON_FComex_Documento_Line_Sel]
	@Id_Processo	[bigint],
	@Id_Empresa		[bigint],
	@Id_Item		[bigint],
	@FileName		varchar(200),
	@Tipo			[varchar](1) NULL
AS
/*
  -  A todos os documentos do processo 
  -  C Documento sem estarem incluidos no ATL
  -  D Documento unico, pelo nome e sem estarem incluidos no ATL  
  -  F Documento unico pelo id processo e id item 
  -  G Separar todos os xmls de nota fiscal por empresa 
*/

	if @Tipo ='A'
		Begin
			Select	
				[Id_Processo],
				[Id_Item],
				[filename],
				NULL [file],
				[Tipo_Documento],
				[Palavras_Chave],
				[Data_Documento],
				[Transmitir],
				[Painel],
				[Identificacao],
				[Dt_Ins_Atl]
				,Line.[MEssage]
				,Line.ID
				,Line.FileFullPath
				,Line.PC_codigo
				,Line.PC_descricao
				,Line.PC_valor
				,Line.TD_codigo
				,Line.TD_descricao
			from ATL_INT.dbo.JSON_FComex_Documento_Line Line with(nolock)
			order by Id_Processo, Id_Item asc
		End

	if @Tipo ='C'
		Begin
			Select
				Line.[Id_Processo],
				Line.[Id_Item],
				Line.[filename],
				J.Num_proc,
				--Line.[file],
				NULL [file],
				Case when Line.[Tipo_Documento] is not null then Line.[Tipo_Documento] else
					Case when J.Id_Empresa = 1 then BDP.CD_DST else
					Case when J.Id_Empresa = 2 then Pibernat.CD_DST END END END [Tipo_Documento],
				--Line.[Tipo_Documento],
				Line.[Palavras_Chave],
				Line.[Data_Documento],
				Line.[Transmitir],
				Line.[Painel],
				--Line.[Identificacao],
				Left(E.Nome_empresa,1) + Convert(varchar(25),Line.[Id_Processo]) + '_' + Convert(varchar(25),Line.[Id_Item]) [Identificacao],
				Line.[Dt_Ins_Atl]
				,J.Id_Empresa
				--,DA.Nome_Arquivo
				,Line.[Message]
				,Line.ID
				,Line.FileFullPath
				,Line.PC_codigo
				,Line.PC_descricao
				,Line.PC_valor
				,Line.TD_codigo
				,Line.TD_descricao

				,BDP.CD_DST
				,Pibernat.CD_DST
				,HOU.ID_Status
				from ATL_INT.dbo.JSON_FComex_Documento_Line Line  with(nolock) 
				join ATL_INT.dbo.JSON_FComex_JobReferences_Line j with(nolock) on  Line.[Id_Processo] = J.[Id_Processo] 
				join ATL_INT.dbo.Empresa_FComex E with(nolock) on J.ID_Empresa = E.ID_Empresa
				join ATlantis.dbo.vwHouse_Imp HOU with(nolock) on HOU.Num_Proc = J.Num_Proc
				--35	FazComex - BDP
				left join De_Para BDP with(nolock) on BDP.cd_tipo ='35' and BDP.Cd_org = Line.TD_codigo and BDP.CD_Cliente = '10017' and BDP.Ativo = 1
				--36	FazComex - Pibernat
				left join De_Para Pibernat with(nolock) on Pibernat.cd_tipo ='36' and Pibernat.Cd_org = Line.TD_codigo and Pibernat.CD_Cliente = '10017' and Pibernat.Ativo = 1				
			Where	
				--j.num_proc in () and
				J.Num_proc = 'IMEXO202605079BR' and 
				Line.Dt_Ins_Atl is null	and
				--line.Identificacao like '%Duimp%' and
				isnull(Line.[FileFullPath],'') <> '' and  
				 Line.Id_Processo not in(
					11582,11585,12291,19649,19693,19794,19795,21228,21386,21388,21663,21718,21744,22529,28439,29159,29167,29175,29214,29235,29368,29727,30436,
					30824,31671,31700,32365,32532,32830,32848,32895,32988,34382,34495,37435,37471,37736,37989,38383,38453,38484,38613,39117,39140,39168,39169,39189,39666,39667,39668,39691,39959,40024)
					--39162,39738,39882,
				And isnull(Line.Tipo_Documento,'') <> '263'

				--and Line.Dt_Ins_Atl > '2025-09-24 13:10:22.000'
				--and Line.[Message] like 'Document:Nota Fiscal already saved in the JOB%'
				And 
					(
						isnull(Line.[Tipo_Documento],'') <> ''
					or 
						J.Id_Empresa = 1 and isnull(BDP.CD_DST,'') <> ''
					or 
						J.Id_Empresa = 2 and isnull(Pibernat.CD_DST,'') <> ''
					)
			
			Order by J.Num_proc

		End

	if @Tipo ='D'
		Begin
			Select
				Line.[Id_Processo],
				Line.[Id_Item],
				Line.[filename],
				NULL [file],
				Line.[Tipo_Documento],
				Line.[Palavras_Chave],
				Line.[Data_Documento],
				Line.[Transmitir],
				Line.[Painel],
				Line.[Identificacao],
				Line.[Dt_Ins_Atl]
				,Line.[Message]
				,Line.ID
				,Line.FileFullPath
				,Line.PC_codigo
				,Line.PC_descricao
				,Line.PC_valor
				,Line.TD_codigo
				,Line.TD_descricao
				from ATL_INT.dbo.JSON_FComex_Documento_Line Line with(nolock)
			Where Dt_Ins_Atl is null
			And Tipo_Documento <> ''
			And FileName = @FileName 
		End

	if @Tipo ='E'
		Begin
			Select
				Line.[Id_Processo],
				Line.[Id_Item],
				Line.[filename],
				NULL [file],
				Line.[Tipo_Documento],
				Line.[Palavras_Chave],
				Line.[Data_Documento],
				Line.[Transmitir],
				Line.[Painel],
				Line.[Identificacao],
				Line.[Dt_Ins_Atl]
				,Line.[Message]
				,Line.ID
				,Line.FileFullPath
				,Line.PC_codigo
				,Line.PC_descricao
				,Line.PC_valor
				,Line.TD_codigo
				,Line.TD_descricao
				from ATL_INT.dbo.JSON_FComex_Documento_Line Line with(nolock)
				join atl_int.dbo.JSON_FComex_JobReferences_Line j with(nolock) on j.Id_Processo = Line.Id_Processo
			Where Line.Dt_Ins_Atl is null
			And Line.Tipo_Documento <> ''
			And Line.[FileName] = @FileName 
			and j.Id_Empresa = @Id_Empresa
		End

	if @Tipo ='F'
		Begin
			Select
  			    Line.[Id_Processo],
				Line.[Id_Item],
				Line.[filename],
				NULL [file],
				Line.[Tipo_Documento],
				Line.[Palavras_Chave],
				Line.[Data_Documento],
				Line.[Transmitir],
				Line.[Painel],
				Line.[Identificacao],
				Line.[Dt_Ins_Atl]
				,Line.[Message]
				,Line.ID
				,Line.FileFullPath
				,Line.PC_codigo
				,Line.PC_descricao
				,Line.PC_valor
				,Line.TD_codigo
				,Line.TD_descricao
				from ATL_INT.dbo.JSON_FComex_Documento_Line Line with(nolock)
			Where Id_Processo = @Id_Processo
            And Id_Item = @Id_Item    
		End

-- separar os xmls das notas fiscais
	if @Tipo ='G'
		Begin
			Select
				Line.[Id_Processo],
				Line.[Id_Item],
				Line.[filename],
				J.Num_proc,
				NULL [file],
				Line.[Tipo_Documento],
				Line.[Palavras_Chave],
				Line.[Data_Documento],
				Line.[Transmitir],
				Line.[Painel],
				Line.[Identificacao],
				Line.[Dt_Ins_Atl]
				,Line.[Message]
				,Line.ID
				,Line.FileFullPath
				,Line.PC_codigo
				,Line.PC_descricao
				,Line.PC_valor
				,Line.TD_codigo
				,Line.TD_descricao
				from ATL_INT.dbo.JSON_FComex_Documento_Line Line with(nolock)
				join atl_int.dbo.JSON_FComex_JobReferences_Line j with(nolock) on j.Id_Processo = Line.Id_Processo
				join VwHouse_Imp HOU with(nolock) on HOU.Num_Proc = J.Num_proc
			Where Line.Dt_Ins_Atl is null
			and isnull(Line.[FileFullPath],'') <> ''			
			And Line.Tipo_Documento = '263'
			--and j.Id_Empresa = @Id_Empresa			
		End



--só p ver se esqueci algo
if @Tipo ='Z'
		Begin
			Select
				Line.[Id_Processo],
				Line.[Id_Item],
				Line.[filename],
				J.Num_proc,
				--Line.[file],
				NULL [file],
				Line.[Tipo_Documento],
				Line.[Palavras_Chave],
				Line.[Data_Documento],
				Line.[Transmitir],
				Line.[Painel],
				Line.[Identificacao],
				Line.[Dt_Ins_Atl]
				,J.Id_Empresa
				--,DA.Nome_Arquivo
				,Line.[Message]
				,Line.ID
				,Line.FileFullPath
				,Line.PC_codigo
				,Line.PC_descricao
				,Line.PC_valor
				,Line.TD_codigo
				,Line.TD_descricao
				from ATL_INT.dbo.JSON_FComex_Documento_Line Line  with(nolock) 
				join ATL_INT.dbo.JSON_FComex_JobReferences_Line j with(nolock) on  Line.[Id_Processo] = J.[Id_Processo] 
				--join ATL_INT.dbo.Exchange_FComex Exc with(nolock) on  Exc.num_proc = J.Num_proc and  Exc.Id_Empresa = J.Id_Empresa
				--join VwHouse_Imp HOU with(nolock) on HOU.Num_Proc = J.Num_proc
				--left join Doc_anexos DA with(nolock) on HOU.Num_Proc = DA.Num_Proc and DA.Id_dc = Convert(int,Line.[Tipo_Documento])
			Where 
			Line.Dt_Ins_Atl is null
			and isnull(Line.[FileFullPath],'') <> ''	
			--and J.Id_Empresa = @Id_Empresa
			and isnull(Line.[Tipo_Documento],'') <> ''
			--and isnull(DA.Nome_Arquivo,'') = ''
			and Line.Id_Processo not in(
			11582,11585,12291,19649,19693,19794,19795,21228,21386,21388,21663,21718,21744,22529,28439,29159,29167,29175,29214,29235,29368,29727,30436,
			30824,31671,31700,32365,32532,32830,32848,32895,32988,34382,34495,37435,37471,37736,37989,38383,38453,38484,38613,39117,39140,
			--39162,
			39168,39169,39189,39666,39667,39668,39691,
			--39738,
			--39882,
			39959,40024)
			--incluido p nao trazer o xml, pois qdo a rotina envia ao ddnfe o doc eh salvo no job - cadu 20250831
			And isnull(Line.Tipo_Documento,'') <> '263'
			

		End

GO
