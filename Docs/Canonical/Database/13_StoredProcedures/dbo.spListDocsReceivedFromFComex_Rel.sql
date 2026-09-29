SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[spListDocsReceivedFromFComex_Rel] 

	@ALL varchar(16)
	
as

Select
	Line.[Id_Processo],
	Line.[Id_Processo],
	Line.[filename],
	J.Num_proc,
	Line.[Tipo_Documento],
	Left(E.Nome_empresa,1) + Convert(varchar(25),Line.[Id_Processo]) + '_' + Convert(varchar(25),Line.[Id_Processo]) [Identificacao],
	Line.[Dt_Ins_Atl]
	,J.Id_Empresa
	,Line.[Message]
	--,Line.ID
	--,Line.FileFullPath
	,Line.TD_codigo
	,Line.TD_descricao

	,BDP.CD_DST BDPDST
	,BDP.Ativo BDPEnabled
	,Pibernat.CD_DST PibernatCD_DST
	,Pibernat.Ativo PibernatEnabled
	from ATL_INT.dbo.JSON_FComex_Documento_Line Line  with(nolock) 
	join ATL_INT.dbo.JSON_FComex_JobReferences_Line j with(nolock) on  Line.[Id_Processo] = J.[Id_Processo] 
	join ATL_INT.dbo.Empresa_FComex E with(nolock) on J.ID_Empresa = E.ID_Empresa
	join ATlantis.dbo.vwHouse_Imp HOU with(nolock) on HOU.Num_Proc = J.Num_Proc
	--35	FazComex - BDP
	left join De_Para BDP with(nolock) on BDP.cd_tipo ='35' and BDP.Cd_org = Line.TD_codigo and BDP.CD_Cliente = '10017' and BDP.Ativo = 1
	--36	FazComex - Pibernat
	left join De_Para Pibernat with(nolock) on Pibernat.cd_tipo ='36' and Pibernat.Cd_org = Line.TD_codigo and Pibernat.CD_Cliente = '10017' and Pibernat.Ativo = 1
Where 
Line.TD_codigo is not null and
isnull(Line.[FileFullPath],'') <> ''
And isnull(Line.Tipo_Documento,'') <> '263'

GO
