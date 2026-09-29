SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--28-10-2016 Erbson: Alterado a função de [fNetRevenueV2_Sel] para checar a vwCXA. 

CREATE Procedure [dbo].[spAtualiza_NetRevenueTemp]

As
	declare @TempExc Table (
			[ExcProcesso] varchar(16)
	)

Begin transaction

	insert into @TempExc
			select distinct ExcProcesso from Exchange where ExcDataAlt >= getdate()-2 and excprocesso <> '' and len(excprocesso) = 16
	
	delete Net_Revenue_Temp where Ref_BDP in (select ExcProcesso from @TempExc)
	
	insert Net_Revenue_Temp
		select
			ExcProcesso,
			[dbo].[fBusca_Custo_Processo_SemImpostos](ExcProcesso),	
			[dbo].[fNetRevenueV2_Sel]	(ExcProcesso)		
		from
			@TempExc

Commit Transaction


--insert q eu usei pra começar a usar a tabela
--insert Net_Revenue_Temp
--	select [01_BDP Reference],[dbo].[fBusca_Custo_Processo_SemImpostos]([01_BDP Reference]),[dbo].[fNetRevenue_Sel]	([01_BDP Reference]) from [vwHEA_Sel] where [13_ETD Date] between '2011-01-01' and '2013-12-31'
--	UNION ALL select [01_BDP Reference],[dbo].[fBusca_Custo_Processo_SemImpostos]([01_BDP Reference]),[dbo].[fNetRevenue_Sel]	([01_BDP Reference]) from [vwHEM_Sel] where [13_ETD Date] between '2011-01-01' and '2013-12-31'
--	UNION ALL select [01_BDP Reference],[dbo].[fBusca_Custo_Processo_SemImpostos]([01_BDP Reference]),[dbo].[fNetRevenue_Sel]	([01_BDP Reference]) from [vwHEO_Sel] where [13_ETD Date] between '2011-01-01' and '2013-12-31'
--	UNION ALL select [01_BDP Reference],[dbo].[fBusca_Custo_Processo_SemImpostos]([01_BDP Reference]),[dbo].[fNetRevenue_Sel]	([01_BDP Reference]) from [vwHIA_Sel] where [13_ETD Date] between '2011-01-01' and '2013-12-31'
--	UNION ALL select [01_BDP Reference],[dbo].[fBusca_Custo_Processo_SemImpostos]([01_BDP Reference]),[dbo].[fNetRevenue_Sel]	([01_BDP Reference]) from [vwHIM_Sel] where [13_ETD Date] between '2011-01-01' and '2013-12-31'
--	UNION ALL select [01_BDP Reference],[dbo].[fBusca_Custo_Processo_SemImpostos]([01_BDP Reference]),[dbo].[fNetRevenue_Sel]	([01_BDP Reference]) from [vwHIO_Sel] where [13_ETD Date] between '2011-01-01' and '2013-12-31'














GO
