SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spSmartBKP_INT] --[dbo].[spSmartBKP_INT '11-01-2012','11-01-2012'
		@DataInicial	Varchar(10),
		@DataFinal		Varchar(10)

AS

SEt @Datainicial='06-21-2010'
SEt @datafinal='06-30-2010'
select num_proc processo from vwcliente
where convert(datetime,dt_criacao,105) between @datainicial and @datafinal
order by convert(datetime,dt_criacao,105) 
GO
