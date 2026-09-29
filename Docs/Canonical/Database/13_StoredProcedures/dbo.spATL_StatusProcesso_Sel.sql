SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from vwClienteALLJOBS where num_proc = 'BORHO201811001BR'

--20-12-2018 - alterado para a view
/*
("A - All Process")
("N - Negative Process only")
("W - without defined status")
*/
--spATL_StatusProcesso_Sel'%',NULL,NULL,'%','''IMCSR201712007BR'',''IMCSR201711077BR'',''IMIFB201811006BR'',''IMARB201811001BR'''
--spATL_StatusProcesso_Sel '%',NULL,NULL,'%','''IMCBT201812007BR'',''IMSWB201811077BR'',''IMIFB201811006BR'',''IMARB201811001BR'''
--[spATL_StatusProcesso_Sel]'%,
CREATE Procedure [dbo].[spATL_StatusProcesso_Sel]--'Grupo Rhodia','2018-01-01','2018-01-05',8
		@Grupo			Varchar(50),
		@DataInicial	Datetime,
		@DataFinal		Datetime,
		@Tipo			Varchar(1),
		@Num_Proc			Varchar(max)

AS	

Set NOCOUNT ON

Declare @strSQL nvarchar(max)

if @Num_Proc = ''
	Begin
		Select 
			Apelido Grupo,
			HOU.num_proc Job,
			isnull(Nome_Local,'') Porto,
			convert(Datetime,HOU.Dt_Criacao,105) Data_Job,
			Status_Descricao,
			'OK' [LOG]
		From 
			vwClienteALLJOBS HOU with(nolock)	
			Join Pessoa_LLP PPL with(nolock) on PPL.cd_pes=HOU.cd_cliente
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_pes_Grupo
			left Join Localidade DST with(nolock) on DST.cd_local=HOU.Cd_local
			Left Join tipo_status_processo TS with(nolock) on HOU.id_status=TS.id_status
		Where
			(@Grupo='%' or Apelido=@Grupo)
			and convert(Datetime,HOU.Dt_Criacao,105) between @DataInicial and @DataFinal
			and (cast(HOU.ID_status as varchar(1))= @tipo or @Tipo = '%')	
	End

else
	Begin
	
	set @Num_Proc = (Select (replace(@Num_Proc,'''','')))
	
	set @strSQL=N'	

	Declare @ALLJOBS table(
		Num_Proc varchar(100)
	)
	insert @ALLJOBS
	SELECT * FROM Split('''+ @Num_Proc+''','','')
	
	Select isnull(Apelido,'''') Grupo,
			AL.num_proc Job,
			isnull(Nome_Local,'''') Porto,
			convert(Datetime,HOU.Dt_Criacao,105) Data_Job,
			(case when Status_Descricao is null then null else cast(TS.ID_Status as varchar(2)) + '' - '' +  Status_Descricao END) Status_Descricao,
			(Case when HOU.Num_proc is null then ''JOB not found!'' else ''OK'' END) LOG
		From @ALLJOBS AL
			left join vwClienteALLJOBS HOU with(nolock)	on AL.Num_Proc = HOU.Num_proc
			left Join Pessoa_LLP PPL with(nolock) on PPL.cd_pes=HOU.cd_cliente
			left Join Pessoa PP with(nolock) on PP.cd_pes=cd_pes_Grupo
			left Join Localidade DST with(nolock) on DST.cd_local=HOU.Cd_local
			Left Join tipo_status_processo TS with(nolock) on HOU.id_status=TS.id_status
		Where
			AL.Num_proc in (select num_proc from @ALLJOBS) order by Apelido'
	
		print @strSQL
		execute (@strSQL)
	End
GO
