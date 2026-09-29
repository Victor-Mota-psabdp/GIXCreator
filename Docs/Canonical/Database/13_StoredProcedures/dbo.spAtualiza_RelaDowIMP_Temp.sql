SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spAtualiza_RelaDowIMP_Temp]

As
	declare @TempExc Table (
			[ExcProcesso] varchar(16)
	)

Begin transaction

	insert into @TempExc
			select distinct ExcProcesso
			from exchange with(nolock) where substring([ExcProcesso],3,3) in ('CSR','ROB','STB')
			and left([ExcProcesso],1) ='I'
			and ExcDataAlt >= getdate()- 0.5 --pra pegar 12hs apenas
			and excprocesso <> '' 
			and len(excprocesso) = 16
			OPTION (HASH JOIN)
	delete RelaDowIMP where Ref_BDP in (select ExcProcesso from @TempExc)
	
	insert RelaDowIMP
		select
			ExcProcesso,
			[dbo].FBusca_Adto(ExcProcesso),	
			[dbo].[FBusca_Caixa_DOW](ExcProcesso),	
			[dbo].fBusca_HistoricoDescr_Completo (ExcProcesso)				
		from
			@TempExc

Commit Transaction

--insert q eu usei pra começar a usar a tabela
--insert RelaDowIMP
	--select 
	--	num_proc_lia,
	--	[dbo].FBusca_Adto(num_proc_lia),
	--	[dbo].[FBusca_Caixa_DOW](num_proc_lia),
	--	[dbo].fBusca_HistoricoDescr_Completo(num_proc_lia)	
	--from llp_imp_aer
	--where 
	--	ETD_LIA between '2013-01-01' and '2013-12-31'
	--	and substring(num_proc_lia,3,3) in ('CSR','ROB','STB') 
	--	and isnull(id_status,0) <> '9'
		
	--UNION ALL
	
	--select 
	--	num_proc_lim,
	--	[dbo].FBusca_Adto(num_proc_lim),
	--	[dbo].[FBusca_Caixa_DOW](num_proc_lim),
	--	[dbo].fBusca_HistoricoDescr_Completo(num_proc_lim)	
	--from llp_imp_mar
	--where 
	--	ETD_LIM between '2013-01-01' and '2013-12-31'
	--	and substring(num_proc_lim,3,3) in ('CSR','ROB','STB') 
	--	and isnull(id_status,0) <> '9'
		
	--UNION ALL
	--select 
	--	num_proc_lio,
	--	[dbo].FBusca_Adto(num_proc_lio),
	--	[dbo].[FBusca_Caixa_DOW](num_proc_lio),
	--	[dbo].fBusca_HistoricoDescr_Completo(num_proc_lio)	
	--from llp_imp_out
	--where 
	--	ETD_LIO between '2013-01-01' and '2013-12-31'
	--	and substring(num_proc_lio,3,3) in ('CSR','ROB','STB') 
	--	and isnull(id_status,0) <> '9'












GO
