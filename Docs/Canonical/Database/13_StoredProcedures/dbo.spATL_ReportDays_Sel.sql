SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_ReportDays_Sel]
--Select usada no ReportXLS >> Send by Email >>  qdo o parametro for tipo "D" (date)
As
	select 'Current Day' [TD], convert(datetime,convert(varchar(10),getdate(),103),103) D union all	
	select 'Last 10 days', convert(datetime,convert(varchar(10),getdate() - 10 ,103),103) union all
	select 'Last 30 days', convert(datetime,convert(varchar(10),getdate() - 30,103),103) union all
	select 'Last 60 days', convert(datetime,convert(varchar(10),getdate() - 60,103),103) union all
	select 'Last 90 days', convert(datetime,convert(varchar(10),getdate() - 90,103),103) union all
	select 'Last 120 days', convert(datetime,convert(varchar(10),getdate()- 120,103),103) union all
	select 'Last 180 days', convert(datetime,convert(varchar(10),getdate()- 180,103),103) union all
	select 'Last 365 days', convert(datetime,convert(varchar(10),getdate()-365,103),103) union all
	--select 'Last 720 days', convert(datetime,convert(varchar(10),getdate()-720,103),103) union all
	select 'Next 10 days', convert(datetime,convert(varchar(10),getdate()+ 10 ,103),103) union all
	select 'Next 30 days', convert(datetime,convert(varchar(10),getdate()+ 30,103),103) union all
	select 'Next 60 days', convert(datetime,convert(varchar(10),getdate()+ 60,103),103) union all
	select 'Next 90 days', convert(datetime,convert(varchar(10),getdate()+ 90,103),103) union all
	select 'Next 120 days', convert(datetime,convert(varchar(10),getdate()+ 120,103),103) union all
	
	Select 'Inicio: 01/08/2011', '2011-08-01' union all
	Select 'Inicio: 01/01/2014', '2014-01-01' union all
	Select 'Inicio: 01/01/2011', '2011-01-01' union all
	Select 'Inicio: 01/12/2017', '2017-12-01' union all
	Select 'Inicio: 01/01/2021', '2021-01-01' union all
	
	select 'Last Month', convert(datetime,convert(varchar(10),dateadd(dd,-day(getdate()),getdate()),103),103) union all
	select 'Yesterday', convert(datetime,convert(varchar(10),getdate() - 1 ,103),103) 
--	union all
--	select '30/11/2012', convert(datetime,convert(varchar(10),getdate() - 3 ,103),103)
	


--OLD
--	select 'Current Day' [TD], getdate() D union all
--	select 'Last 10 days', getdate()-10 union all
--	select 'Last 30 days', getdate()-30 union all
--	select 'Last 60 days', getdate()-60 union all
--	select 'Last 90 days', getdate()-90 union all
--	select 'Last 120 days', getdate()-120 union all
--	select 'Last 180 days', getdate()-180 union all
--	select 'Last 365 days', getdate()-365 union all
--	select 'Next 10 days', getdate()+10 union all
--	select 'Next 30 days', getdate()+30 union all
--	select 'Next 60 days', getdate()+60 union all
--	select 'Next 90 days', getdate()+90 union all
--	select 'Next 120 days', getdate()+120 union all
--	
--	Select 'Inicio: 01/08/2011', '2011-08-01'

GO
