SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Dashboard_Rel]

as
	
Declare @DashTemp Table
		(
			Nome_Rotina varchar(100),
			Tipo_Teste	varchar(100),
			Informacao  varchar(100),
			Data_Info	varchar(50),
			Caminho		Varchar(500),
			DataIns		varchar(50)
			)
SET NOCOUNT ON	
Declare @Caminho varchar(500)



--****************************
--Report Manager - VB6 ALL
--****************************
--insert into @DashTemp	
--	select top 1 'Report Manager - VB6 ALL','Next Update', upper(excprocesso) Job,CONVERT(CHAR(10), min(excdataalt), 103) + ' ' + CONVERT(CHAR(8), min(excdataalt), 108) Data, NULL, getdate() from exchange EX with(nolock) 
--	join vwALL_JObs AL  with(nolock)  on EX.excprocesso = AL.Num_proc
--	where excreportmanager is null and excdataalt>=getdate()-30  and len(excprocesso)=16
--	group by  excprocesso,excdataalt order by substring(excprocesso,6,4) desc, excdataalt
	
--insert into @DashTemp	
--	select top 1 'Report Manager - VB6 ALL','Last Update', upper(excprocesso) Job,CONVERT(CHAR(10), excdataalt, 103) + ' ' + CONVERT(CHAR(8), excdataalt, 108) Data,NULL , getdate() from exchange EX with(nolock) 
--	join vwALL_JObs AL  with(nolock)  on EX.excprocesso = AL.Num_proc
--	where excreportmanager is not null --and excdataalt>=getdate()-30  and len(excprocesso)=16
--	group by  excprocesso ,excdataalt order by excdataalt desc
	
--insert into @DashTemp	
--	select top 1 'Report Manager - VB6 ALL','#SQL Update',  RANK() OVER(ORDER BY excprocesso) Linha,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,NULL, getdate()   from exchange EX with(nolock) 
--	join vwALL_JObs AL  with(nolock) on EX.excprocesso = AL.Num_proc
--	where excreportmanager is null and excdataalt>=getdate()-30  and len(excprocesso)=16
--	group by  excprocesso order by 3 Desc
	
--insert into @DashTemp	
--	select top 1 'Report Manager - VB6 ALL','#SQL Done - DAY',  RANK() OVER(ORDER BY excprocesso) Linha,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,NULL, getdate()   from exchange EX with(nolock) 
--	join vwALL_JObs AL  with(nolock) on EX.excprocesso = AL.Num_proc
--	where excreportmanager is not null and excreportmanager>=convert(varchar(10),getdate(),102)  and len(excprocesso)=16
--	group by  excprocesso order by 3 Desc
	
--****************************
--Report Manager - XML
--****************************
insert into @DashTemp	
	select top 1 'Report Manager - XML','Next Update', upper(excprocesso) Job,CONVERT(CHAR(10), min(excdataalt), 103) + ' ' + CONVERT(CHAR(8), min(excdataalt), 108) Data,NULL, getdate() from exchange EX with(nolock) 
	join vwALL_JObs AL  with(nolock)  on EX.excprocesso = AL.Num_proc
	where excreportmanager2 is null
	group by excprocesso order by  min(Excdataalt)

insert into @DashTemp	
	select top 1 'Report Manager - XML','Last Update', upper(excprocesso) Job,CONVERT(CHAR(10), excdataalt, 103) + ' ' + CONVERT(CHAR(8), excdataalt, 108) Data,NULL, getdate() from exchange EX with(nolock) 
	join vwALL_JObs AL  with(nolock)  on EX.excprocesso = AL.Num_proc
	where  excreportmanager2 is not null
	group by excprocesso, Excdataalt order by  Excdataalt desc
	
insert into @DashTemp	
	select top 1 'Report Manager - XML','#SQL Update', RANK() OVER(ORDER BY excprocesso) Linha,CONVERT(CHAR(10), min(excdataalt), 103) + ' ' + CONVERT(CHAR(8), min(excdataalt), 108) Data,NULL, getdate() from exchange EX with(nolock) 
	join vwALL_JObs AL  with(nolock)  on EX.excprocesso = AL.Num_proc
	where excreportmanager2 is null
	group by excprocesso order by  3 Desc

insert into @DashTemp	
	select top 1 'Report Manager - XML','#SQL Done - DAY', RANK() OVER(ORDER BY excprocesso) Linha,CONVERT(CHAR(10), min(excdataalt), 103) + ' ' + CONVERT(CHAR(8), min(excdataalt), 108) Data,NULL, getdate() from exchange EX with(nolock) 
	join vwALL_JObs AL  with(nolock)  on EX.excprocesso = AL.Num_proc
	where excreportmanager is not null and excreportmanager2 is not null and excreportmanager2>=convert(varchar(10),getdate(),102)
	group by excprocesso order by  3 Desc
/*
Declare @TableSaidaR table (subdiretory varchar(200), depth int, arquivo int)
Set @Caminho ='\\192.168.11.200\d\Rotinas\ReportManagerV2\Saida'
insert into @TableSaidaR
EXEC master.dbo.xp_dirtree @Caminho, 1, 1
if not exists(select * from @TableSaidaR)
	Begin
		insert into @DashTemp	
			select 'Report Manager - XML','#Files Saida',  '0' Linha,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,@Caminho, getdate()
	End	
else
	Begin
		insert into @DashTemp	
			select top 1 'Report Manager - XML','#Files Saida',  RANK() OVER(ORDER BY subdiretory) Linha,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,@Caminho, getdate() from @TableSaidaR
			order by RANK() OVER(ORDER BY subdiretory) desc
	End

Declare @TableLidosR table (subdiretory varchar(200), depth int, arquivo int)
Set @Caminho = '\\192.168.11.200\d\Rotinas\ReportManagerV2\Lidos'
insert into @TableLidosR
EXEC master.dbo.xp_dirtree @Caminho, 1, 1
if not exists(select * from @TableLidosR)
	Begin
		insert into @DashTemp	
			select 'Report Manager - XML','#Files Lidos',  '0', CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,NULL, getdate()
	End
else
	Begin
	insert into @DashTemp	
		select top 1 'Report Manager - XML','#Files Lidos',  RANK() OVER(ORDER BY subdiretory) Linha,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,@Caminho, getdate() from @TableLidosR
		order by RANK() OVER(ORDER BY subdiretory) desc
	End

*/
--****************************
--MIGO - FMC
--****************************
Declare @TableSaidaM table (subdiretory varchar(200), depth int, arquivo int)
Set @Caminho = N'\\192.168.11.200\d\Rotinas\Integra WebService\Saida'
insert into @TableSaidaM
EXEC master.dbo.xp_dirtree @Caminho, 1, 1

if not exists (select * from @TableSaidaM)
	Begin
		insert into @DashTemp	
			select 'Migo - FMC','#Files Saida',  '0' ,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,@Caminho , getdate()
		End
Else
	Begin

		insert into @DashTemp	
			select top 1 'Migo - FMC','#Files Saida',  RANK() OVER(ORDER BY subdiretory) Linha,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,@Caminho, getdate()   from @TableSaidaM
			order by RANK() OVER(ORDER BY subdiretory) desc
	End
	
Declare @TableLidosM table (subdiretory varchar(200), depth int, arquivo int)
Set @Caminho = N'\\192.168.11.200\d\Rotinas\Integra WebService\Lidos'
insert into @TableLidosM
EXEC master.dbo.xp_dirtree @Caminho, 1, 1

if not exists (select * from @TableLidosM)
	Begin
		insert into @DashTemp	
			select 'Migo - FMC','#Files Lidos',  '0' ,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,@Caminho, getdate() 
		End
Else
	Begin

		insert into @DashTemp	
			select top 1 'Migo - FMC','#Files Lidos',  RANK() OVER(ORDER BY subdiretory) Linha,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,@Caminho, getdate()   from @TableLidosM
			order by RANK() OVER(ORDER BY subdiretory) desc
	End

--****************************
--XML GIP
--****************************
Declare @TableSaidaG table (subdiretory varchar(200), depth int, arquivo int)
Set @Caminho = N'\\192.168.11.2\ftp\admin\XML_Gip\Saida'
insert into @TableSaidaG
EXEC master.dbo.xp_dirtree @Caminho, 1, 1

if not exists (select * from @TableSaidaG)
	Begin
		insert into @DashTemp	
			select 'XML GIP','#Files Saida',  '0' ,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,@Caminho, getdate() 
		End
Else
	Begin

		insert into @DashTemp	
			select top 1 'XML GIP','#Files Saida',  RANK() OVER(ORDER BY subdiretory) Linha,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,@Caminho, getdate()   from @TableSaidaG
			order by RANK() OVER(ORDER BY subdiretory) desc
	End
	
Declare @TableLidosG table (subdiretory varchar(200), depth int, arquivo int)
Set @Caminho = N'\\192.168.11.2\ftp\admin\XML_Gip\Lidos'
insert into @TableLidosG
EXEC master.dbo.xp_dirtree @Caminho, 1, 1

if not exists (select * from @TableLidosG)
	Begin
		insert into @DashTemp	
			select 'XML GIP','#Files Lidos',  '0' ,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,@Caminho, getdate() 
		End
Else
	Begin

		insert into @DashTemp	
			select top 1 'XML GIP','#Files Lidos',  RANK() OVER(ORDER BY subdiretory) Linha,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,@Caminho, getdate()   from @TableLidosG
			order by RANK() OVER(ORDER BY subdiretory) desc
	End
--****************************
--XML GIP TIME
--****************************	
Declare @TableSaidaGT table (subdiretory varchar(200), depth int, arquivo int)
Set @Caminho = N'\\192.168.11.200\d\admin\XML_Gip_Time\Saida'
insert into @TableSaidaGT
EXEC master.dbo.xp_dirtree @Caminho, 1, 1

if not exists (select * from @TableSaidaGT)
	Begin
		insert into @DashTemp	
			select 'XML GIP TIME','#Files Saida',  '0' ,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,@Caminho, getdate() 
		End
Else
	Begin

		insert into @DashTemp	
			select top 1 'XML GIP TIME','#Files Saida',  RANK() OVER(ORDER BY subdiretory) Linha,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,@Caminho, getdate()   from @TableSaidaGT
			order by RANK() OVER(ORDER BY subdiretory) desc
	End
	
Declare @TableLidosGT table (subdiretory varchar(200), depth int, arquivo int)
Set @Caminho = N'\\192.168.11.200\d\admin\XML_Gip_Time\Lidos'
insert into @TableLidosGT
EXEC master.dbo.xp_dirtree @Caminho, 1, 1

if not exists (select * from @TableLidosGT)
	Begin
		insert into @DashTemp	
			select 'XML GIP TIME','#Files Lidos',  '0' ,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,@Caminho, getdate() 
		End
Else
	Begin

		insert into @DashTemp	
			select top 1 'XML GIP TIME','#Files Lidos',  RANK() OVER(ORDER BY subdiretory) Linha,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,@Caminho, getdate()   from @TableLidosGT
			order by RANK() OVER(ORDER BY subdiretory) desc
	End


--****************************
--XML - BDP SMART
--****************************
insert into @DashTemp	
	select top 1 'XML - BDP SMART','Next Update', upper(excprocesso) Job,CONVERT(CHAR(10), min(excdataalt), 103) + ' ' + CONVERT(CHAR(8), min(excdataalt), 108) Data,NULL, getdate() from exchange EX with(nolock) 
	Join vwcliente C with(nolock) on C.num_proc = Ex.excprocesso 
	Join PEssoa PP with(nolock) on PP.cd_pes=cd_cliente and Global_Entity_ID is not null
	where excreportmanager is not null and excreportmanager2 is null
	group by excprocesso order by  min(Excdataalt)

insert into @DashTemp	
	select top 1 'XML - BDP SMART','Last Update', upper(excprocesso) Job,CONVERT(CHAR(10), excdataalt, 103) + ' ' + CONVERT(CHAR(8), excdataalt, 108) Data,NULL, getdate() from exchange EX with(nolock) 
	Join vwcliente C with(nolock) on C.num_proc=Ex.excprocesso 
	Join PEssoa PP with(nolock) on PP.cd_pes=cd_cliente and Global_Entity_ID is not null
	where excreportmanager is not null and excreportmanager2 is not null
	group by excprocesso, Excdataalt order by  Excdataalt desc
	
insert into @DashTemp	
	select top 1 'XML - BDP SMART','#SQL Update', RANK() OVER(ORDER BY excprocesso) Linha,CONVERT(CHAR(10), min(excdataalt), 103) + ' ' + CONVERT(CHAR(8), min(excdataalt), 108) Data,NULL, getdate() from exchange EX with(nolock) 
	Join vwcliente C with(nolock) on C.num_proc=Ex.excprocesso 
	Join PEssoa PP with(nolock) on PP.cd_pes=cd_cliente and Global_Entity_ID is not null
	where  excdtenvio is null and len(Ex.excprocesso)=16  group by  EX.excprocesso order by 3 Desc
	
insert into @DashTemp	
	select top 1 'XML - BDP SMART','#SQL Done - DAY', RANK() OVER(ORDER BY excprocesso) Linha,CONVERT(CHAR(10), min(excdataalt), 103) + ' ' + CONVERT(CHAR(8), min(excdataalt), 108) Data,NULL, getdate() from exchange EX with(nolock) 
	Join vwcliente C with(nolock) on C.num_proc=Ex.excprocesso 
	Join PEssoa PP with(nolock) on PP.cd_pes=cd_cliente and Global_Entity_ID is not null
	where  excdtenvio is not null and excdtenvio >= convert(varchar(10),getdate(),102) and len(Ex.excprocesso)=16  group by  EX.excprocesso order by 3 Desc

Declare @TableSaidaSM table (subdiretory varchar(200), depth int, arquivo int)
Set @Caminho = N'\\192.168.11.200\d\Rotinas\XML\Saida'
insert into @TableSaidaSM
EXEC master.dbo.xp_dirtree @Caminho, 1, 1

if not exists (select * from @TableSaidaSM)
	Begin
		insert into @DashTemp	
			select 'XML - BDP SMART','#Files Saida',  '0' ,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,@Caminho, getdate() 
		End
Else
	Begin

		insert into @DashTemp	
			select top 1 'XML - BDP SMART','#Files Saida',  RANK() OVER(ORDER BY subdiretory) Linha,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,@Caminho, getdate()   from @TableSaidaSM
			order by RANK() OVER(ORDER BY subdiretory) desc
	End
	
Declare @TableLidosSM table (subdiretory varchar(200), depth int, arquivo int)
Set @Caminho = N'\\192.168.11.200\d\Rotinas\XML\Lidos'
insert into @TableLidosSM
EXEC master.dbo.xp_dirtree @Caminho, 1, 1

if not exists (select * from @TableLidosSM)
	Begin
		insert into @DashTemp	
			select 'XML - BDP SMART','#Files Lidos',  '0' ,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,@Caminho, getdate() 
		End
Else
	Begin

		insert into @DashTemp	
			select top 1 'XML - BDP SMART','#Files Lidos',  RANK() OVER(ORDER BY subdiretory) Linha,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,@Caminho, getdate()   from @TableLidosSM
			order by RANK() OVER(ORDER BY subdiretory) desc
	End

----****************************
----ECC DOW
----****************************
Declare @TableSaidaED table (subdiretory varchar(200), depth int, arquivo int)
Set @Caminho = N'\\192.168.11.200\d\Rotinas\ECC_Dow\Saida'
insert into @TableSaidaED
EXEC master.dbo.xp_dirtree @Caminho, 1, 1

if not exists (select * from @TableSaidaED)
	Begin
		insert into @DashTemp	
			select 'ECC - DOW','#Files Saida',  '0' ,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,@Caminho , getdate()
		End
Else
	Begin

		insert into @DashTemp	
			select top 1 'ECC - DOW','#Files Saida',  RANK() OVER(ORDER BY subdiretory) Linha,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,@Caminho, getdate()   from @TableSaidaED
			order by RANK() OVER(ORDER BY subdiretory) desc
	End
	
Declare @TableLidosED table (subdiretory varchar(200), depth int, arquivo int)
Set @Caminho = N'\\192.168.11.200\d\Rotinas\ECC_Dow\Lidos'
insert into @TableLidosED
EXEC master.dbo.xp_dirtree @Caminho, 1, 1

if not exists (select * from @TableLidosED)
	Begin
		insert into @DashTemp	
			select 'ECC - DOW','#Files Lidos',  '0' ,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,@Caminho, getdate() 
		End
Else
	Begin

		insert into @DashTemp	
			select top 1 'ECC - DOW','#Files Lidos',  RANK() OVER(ORDER BY subdiretory) Linha,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,@Caminho, getdate()   from @TableLidosED
			order by RANK() OVER(ORDER BY subdiretory) desc
	End
	
----****************************
----PIBERNAT - XML
----****************************
Declare @TableSaidaPB table (subdiretory varchar(200), depth int, arquivo int)
Set @Caminho = N'\\192.168.11.2\ftp\Pibernat\saida'
insert into @TableSaidaPB
EXEC master.dbo.xp_dirtree @Caminho, 1, 1

if not exists (select * from @TableSaidaPB)
	Begin
		insert into @DashTemp	
			select 'Pibernat - XML','#Files Saida',  '0' ,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,@Caminho , getdate()
		End
Else
	Begin

		insert into @DashTemp	
			select top 1 'Pibernat - XML','#Files Saida',  RANK() OVER(ORDER BY subdiretory) Linha,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,@Caminho, getdate()   from @TableSaidaPB
			order by RANK() OVER(ORDER BY subdiretory) desc
	End
	
Declare @TableLidosPB table (subdiretory varchar(200), depth int, arquivo int)
Set @Caminho = N'\\192.168.11.2\ftp\Pibernat\saida\Lidos'
insert into @TableLidosPB
EXEC master.dbo.xp_dirtree @Caminho, 1, 1

if not exists (select * from @TableLidosPB)
	Begin
		insert into @DashTemp	
			select 'Pibernat - XML','#Files Lidos',  '0' ,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,@Caminho, getdate() 
		End
Else
	Begin

		insert into @DashTemp	
			select top 1 'Pibernat - XML','#Files Lidos',  RANK() OVER(ORDER BY subdiretory) Linha,CONVERT(CHAR(10), getdate(), 103) + ' ' + CONVERT(CHAR(8), getdate(), 108) Data,@Caminho, getdate()   from @TableLidosPB
			order by RANK() OVER(ORDER BY subdiretory) desc
	End

delete Dashboard

insert into Dashboard
select * from @DashTemp


select * from Dashboard
GO
