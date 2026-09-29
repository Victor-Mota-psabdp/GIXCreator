SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Dashboard_v2_Rel]

as
	
Declare @DashTemp Table
		(
			Nome_Rotina varchar(100),
			Tipo_Teste	varchar(100),
			Informacao  varchar(100),
			Data_Info	varchar(50),
			Caminho		Varchar(500),
			DataIns		varchar(50),
			Status		varchar(Max),
			Limit		varchar(50)
			)
SET NOCOUNT ON	
Declare @Caminho varchar(500)

--spBuscaProcessos_ODS_Sel 
Declare @ODSTemp Table
		(
			Processo varchar(16),
			Data datetime
			)
insert @ODSTemp		
Exec spBuscaProcessos_ODS_Sel 


insert into @DashTemp	
	select top 1
		'ODS',
		'Qty Pending',
		RANK() OVER(ORDER BY Processo) Linha,
		CONVERT(CHAR(10), min(data), 103) + ' ' + CONVERT(CHAR(8), min(data), 108) Data,
		'SQL' ,
		getdate(),
		NULL,
		'2500'
	from @ODSTemp  group by Processo order by  3 Desc
update @DashTemp set [Status] = (Case when cast(Informacao as int) > cast(Limit as int)  then 'LIMIT EXCEEDED!' else 'OK' End) where Nome_Rotina = 'ODS' and Tipo_Teste = 'Qty Pending'

--select Dt_Ins from ATL_INT.dbo.Smart_XML where CONVERT(varchar(10), Dt_Ins,103) = convert(varchar(10), GETDATE(),103) order by Dt_Ins
insert into @DashTemp	
select top 1
		'ODS',
		'XML Qty Created',
		RANK() OVER(ORDER BY Num_Proc ) Linha,
		CONVERT(CHAR(10), max(Dt_Ins), 103) + ' ' + CONVERT(CHAR(8), max(Dt_Ins), 108) Data,
		'SQL' ,
		getdate(),
		NULL,
		'500'
	from ATL_INT.dbo.Smart_XML with(nolock) where CONVERT(varchar(10), Dt_Ins,103) = convert(varchar(10), GETDATE(),103)  group by Num_Proc order by  3 Desc
update @DashTemp set [Status] = (Case when cast(Informacao as int) < cast(Limit as int)  then 'Please Check!' else 'OK' End) where Nome_Rotina = 'ODS' and Tipo_Teste = 'XML Qty Created'

--select Dt_Envio from ATL_INT.dbo.Smart_XML where CONVERT(varchar(10), Dt_Envio,103) = convert(varchar(10), GETDATE(),103) order by Dt_Envio
insert into @DashTemp	
select top 1
		'ODS',
		'XML Qty Send',
		RANK() OVER(ORDER BY Num_Proc ) Linha,
		CONVERT(CHAR(10), max(Dt_Envio), 103) + ' ' + CONVERT(CHAR(8), max(Dt_Envio), 108) Data,
		'SQL' ,
		getdate(),
		NULL,
		'500'
	from ATL_INT.dbo.Smart_XML with(nolock) where CONVERT(varchar(10), Dt_Envio,103) = convert(varchar(10), GETDATE(),103)  group by Num_Proc order by  3 Desc
update @DashTemp set [Status] = (Case when cast(Informacao as int) < cast(Limit as int)  then 'Please Check!' else 'OK' End) where Nome_Rotina = 'ODS' and Tipo_Teste = 'XML Qty Send'

--spRManagerv2_Sel
Declare @ReportManagerTemp Table
		(
			Prioridade int,
			Processo varchar(16),
			Data datetime
			)
insert @ReportManagerTemp		
Exec spRManagerv2_Sel 
insert into @DashTemp	
	select top 1
		'Report Manager - XML',
		'QTY Pending',
		RANK() OVER(ORDER BY Processo) Linha,
		CONVERT(CHAR(10), min(data), 103) + ' ' + CONVERT(CHAR(8), min(data), 108) Data,
		'SQL' ,
		getdate(),
		NULL,
		'2500'
	from @ReportManagerTemp  group by Processo order by  3 Desc
update @DashTemp set [Status] = (Case when cast(Informacao as int) > cast(Limit as int)  then 'LIMIT EXCEEDED!' else 'OK' End) where Nome_Rotina = 'Report Manager - XML' and Tipo_Teste = 'QTY Pending'

delete Dashboard

insert into Dashboard
select * from @DashTemp


select Nome_Rotina [Routine_Name],
Tipo_Teste [Test_Type],
Informacao[Information],
Data_Info[Information_Date],
Caminho [Path],
DataIns [Test_Date],
[Status],
[Limit]
 from Dashboard
GO
