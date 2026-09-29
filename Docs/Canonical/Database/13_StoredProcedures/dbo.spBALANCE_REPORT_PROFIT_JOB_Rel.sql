SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spBALANCE REPORT_PROFIT_JOB_Rel]'EMFMC201602003BR'
--select * from vwcta_Cte where Num_Proc_HIA = 'EMFMC201602003BR'
CREATE procedure [dbo].[spBALANCE_REPORT_PROFIT_JOB_Rel]--'EMFMC201602003BR'
(
	@JOB as Varchar(16)
)
AS

SET NOCOUNT ON
SET ANSI_WARNINGS OFF

--Declare @JOB as Varchar(16)
--set @JOB = 'IMGVD201605010BR'

Declare @TempNF Table
	(		
		JOB						varchar(50),
		[Nome_Taxa]				varchar(200),
		[D/C]					varchar(2),
		[Currency]				varchar(6),
		--[Caixa]					varchar(200),	
		[1 - Sales]				float,
		[1 - Sales_Original]	float,
		[2 - Sales Tax]			float,
		[3 - Cost]				float,
		[(G) / P]				float,	
		[4 - Advance]			float,
		[5 - PT Revenue]		float,
		[6 - PT Cost]			float,	
		[Balance]				float
	)

	insert into @TempNF
		([Nome_Taxa],[D/C],[Currency],[1 - Sales_Original],[1 - Sales])
	exec spATL_BuscaConferenciaJOB_Sel @JOB,'ResultadoR'

	insert into @TempNF
		([Nome_Taxa],[D/C],[Currency],[1 - Sales_Original],[3 - Cost])
	exec spATL_BuscaConferenciaJOB_Sel @JOB,'ResultadoC'			

	insert into @TempNF
		([Nome_Taxa],[D/C],[Currency],[1 - Sales_Original],[5 - PT Revenue])
	exec spATL_BuscaConferenciaJOB_Sel @JOB,'ReceitaR'

	insert into @TempNF
		([Nome_Taxa],[D/C],[Currency],[1 - Sales_Original],[6 - PT Cost])
	exec spATL_BuscaConferenciaJOB_Sel @JOB,'ReceitaC'
	
	update @TempNF set
		[JOB] = @JOB,		
		[2 - Sales Tax]	= [dbo].[fBusca_CalculaImposto](@JOB,[Nome_Taxa],[D/C],ISNULL([1 - Sales],0)) * -1

	update @TempNF set 
		[Balance]=ISNULL([4 - Advance],0) + ISNULL([5 - PT Revenue],0) + ISNULL([6 - PT Cost],0),
		[(G) / P]=ISNULL([1 - Sales],0) + ISNULL([2 - Sales Tax],0) + ISNULL([3 - Cost],0)
					
		insert into @TempNF	
			select 'Total ' + @JOB,'','','',
				SUM([1 - Sales])						[1 - Sales], 
				SUM([1 - Sales_Original])				[1 - Sales_Original], 
				SUM([2 - Sales Tax])					[2 - Sales Tax],		
				SUM([3 - Cost])							[3 - Cost],
				sum([(G) / P])							[(G) / P], 
				SUM([4 - Advance])						[4 - Advance],
				sum([5 - PT Revenue])					[5 - PT Revenue],
				sum([6 - PT Cost])						[6 - PT Cost],		
				SUM([Balance])							[Balance]
			from @TempNF
			where [Nome_Taxa] is not null
			
			

select 
	[JOB],[JOB] + ' - ' + [Nome_Taxa] [Descrição],[1 - Sales],[2 - Sales Tax],[3 - Cost],[(G) / P],
	[4 - Advance],[5 - PT Revenue],[6 - PT Cost],[Balance],[D/C],[Currency]
from 
	@TempNF  
order by 
	JOB,Nome_Taxa
	


/*
--[spBALANCE REPORT_PROFIT_JOB_Rel]'EMFMC201602003BR'
--select * from vwcta_Cte where Num_Proc_HIA = 'EMFMC201602003BR'
ALTER procedure [dbo].[spBALANCE_REPORT_PROFIT_JOB_Rel]--'EMFMC201602003BR'
(
	@JOB as Varchar(16)
)
AS

SET NOCOUNT ON
SET ANSI_WARNINGS OFF

--Declare @JOB as Varchar(16)
--set @JOB = 'EMFMC201602003BR'

Declare @TempNF Table
	(		
		JOB						varchar(16),
		[Nome_Taxa]				varchar(200),
		[D/C]					varchar(2),
		[Currency]				varchar(6),
		--[DESCRIÇÃO]				varchar(200),		
		[1 - Sales]				float,
		[1 - Sales_Original]	float,
		[2 - Sales Tax]			float,
		[3 - Cost]				float,
		[(G) / P]				float,	
		[4 - Advance]			float,
		[5 - PT Revenue]		float,
		[6 - PT Cost]			float,	
		[Balance]				float
	)

insert into @TempNF
	([Nome_Taxa],[D/C],[Currency],[1 - Sales_Original],[1 - Sales])
exec spATL_BuscaConferenciaJOB_Sel @JOB,'ResultadoR'

insert into @TempNF
	([Nome_Taxa],[D/C],[Currency],[1 - Sales_Original],[5 - PT Revenue])
exec spATL_BuscaConferenciaJOB_Sel @JOB,'ReceitaR'

insert into @TempNF
	([Nome_Taxa],[D/C],[Currency],[1 - Sales_Original],[6 - PT Cost])
exec spATL_BuscaConferenciaJOB_Sel @JOB,'ReceitaC'


update @TempNF set
[JOB] = @JOB,
[2 - Sales Tax]	= [dbo].[fBusca_CalculaImposto](@JOB,[Nome_Taxa],[D/C],isnull([1 - Sales],0))

update @TempNF set 
[Balance]=isnull([4 - Advance],0) - isnull([5 - PT Revenue],0) - isnull([6 - PT Cost],0),
[(G) / P]=isnull([1 - Sales],0) - isnull([2 - Sales Tax],0) - isnull([3 - Cost],0)


--select * from @TempNF

--spATL_BuscaConferenciaJOB_Sel 'EMFMC201602003BR','ReceitaR' @JOB
--spATL_BuscaConferenciaJOB_Sel 'EMFMC201602003BR','ReceitaC' @JOB
--spATL_BuscaConferenciaJOB_Sel 'EMFMC201602003BR','ResultadoR' @JOB

--insert into @TempNF
----Nota Fiscal
--	select		
--		HOU.Num_proc	[JOB],
--		TT.Nome_Tp_Tx,
--		HOU.Num_proc + ' - ' + TT.Nome_Tp_Tx, 	
--		sum(dbo.valor(FAD.Valor_ARP,fad.DC))[1 - Sales],		
--		null [2 - Sales Tax]	,
--		null [3 - Cost],
--		null [(G) / P],	
--		null [4 - Advance],
--		null [5 - PT Revenue],
--		null [6 - PT Cost],
--		null [Balance]	
--	from 
--		vwcta_Cte CTA	
--		join vwFaturasValidasArg FAD with(nolock) on FAD.Num_Proc = CTA.Num_Proc_HIA and FAD.Cd_Tp_Tx = CTA.Cd_Tp_Tx and FAD.DC = CTA.DC_HIA
--		--Join Fatura_ARG FAT with(nolock) on FAD.ID_FAT = FAT.ID_FAT and Status <>2
--		Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
--		Join vwClienteALLJOBS hou with(nolock) on hou.num_proc=CTA.Num_Proc_HIA		
--	Where
--		CTA.Num_Proc_HIA = @JOB
--		--CTA.Num_Proc_HIA = 'IMATL21502082BR' 
--	Group by
--		TT.Nome_Tp_Tx,HOU.Num_proc
		
--UNION ALL
----NF Master
--	select		
--		HOU.Master			[JOB],
--		TT.Nome_Tp_Tx,
--		HOU.Master + ' - ' + TT.Nome_Tp_Tx, 	
--		sum(dbo.valor(FAD.Valor_ARP,fad.DC))[1 - Sales],
--		null [2 - Sales Tax]	,
--		null [3 - Cost],
--		null [(G) / P],	
--		null [4 - Advance],
--		null [5 - PT Revenue],
--		null [6 - PT Cost],
--		null [Balance]		
--	from 
--		vwcta_Cte CTA	
--		Join vwClienteALLJOBS HOU on HOU.Master=cta.Num_Proc_HIA 
--		join vwFaturasValidasArg FAD with(nolock) on FAD.Num_Proc = CTA.Num_Proc_HIA and FAD.Cd_Tp_Tx = CTA.Cd_Tp_Tx and FAD.DC = CTA.DC_HIA		
--		Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
--	Where
--		HOU.num_proc = @JOB
--		--CTA.Num_Proc_HIA = 'IMATL21502082BR' 
--	Group by
--		TT.Nome_Tp_Tx,HOU.Master,HOU.Num_proc

----UNION ALL
------DOC register	
----	select		
----		HOU.Num_proc		[JOB],
----		HOU.Num_proc + ' - ' + TT.Nome_Tp_Tx,
----		null,null,null,	
----		sum(dbo.valor(RFI.Valor_Total,RFI.DC)) [Custos Total],
		
----		(case when TT.Tipo_Prod_Code = 1 then
----			sum(dbo.valor(RFI.Valor_Total,RFI.DC))		
----		end) [Custos CHB], 
		
----		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
----			sum(dbo.valor(RFI.Valor_Total,RFI.DC))		
----		end) [Custos Transp] 
----		,null,null,null,null,null
----	from 
----		vwCXAS CTA	
----		join vwRegistroFinanceiroItem RFI  with(nolock) on RFI.Num_Proc = CTA.Num_Proc_HIa and RFI.Cd_Tp_Tx = CTA.Cd_Tp_Tx and RFI.DC = CTA.DC_HIA
----		--Join registro_financeiro RF on RF.mes=RFI.mes and RF.ano=rfi.ano and rfi.num_registro=RF.num_registro and RF.ativo = 1 
----		Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
----		Join vwClienteALLJOBS hou with(nolock) on hou.num_proc=CTA.Num_Proc_HIA		
----	Where
----		CTA.Num_Proc_HIA = @JOB 
----		--CTA.Num_Proc_HIA = 'IMATL21502082BR'  
----	Group by
----		TT.Tipo_Prod_Code,TT.Nome_Tp_Tx,
----		HOU.Num_proc

----UNION ALL
------Master
----	select
----		HOU.Master			[JOB],
----		HOU.Master + ' - ' + TT.Nome_Tp_Tx, 
----		null,null,null,	
----		sum(dbo.valor(RFI.Valor_Total,RFI.DC)) [Custos Total],
		
----		(case when TT.Tipo_Prod_Code = 1 then
----			sum(dbo.valor(RFI.Valor_Total,RFI.DC))		
----		end) [Custos CHB], 
		
----		(case when isnull(TT.Tipo_Prod_Code,2) <> 1 then
----			sum(dbo.valor(RFI.Valor_Total,RFI.DC))		
----		end) [Custos Transp] 
----		,null,null,null,null,null
----	from 
----		vwCXAS CTA
----		Join vwClienteALLJOBS hou with(nolock) on hou.Master=CTA.Num_Proc_HIA	
----		join vwRegistroFinanceiroItem RFI  with(nolock) on RFI.Num_Proc = CTA.Num_Proc_HIa and RFI.Cd_Tp_Tx = CTA.Cd_Tp_Tx and RFI.DC = CTA.DC_HIA		
----		Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx		
----	Where
----		HOU.num_proc = @JOB 
----		--CTA.Num_Proc_HIA = 'IMATL21502082BR'  
----	Group by
----		TT.Tipo_Prod_Code,TT.Nome_Tp_Tx,
----		HOU.Master,HOU.Num_proc
			

--UNION ALL
----Cta
--	select
--		HOU.Num_proc		[JOB],
--		TT.Nome_Tp_Tx,
--		HOU.Num_proc + ' - ' + TT.Nome_Tp_Tx,
--		null [1 - Sales],
--		null [2 - Sales Tax],
--		null [3 - Cost],
--		null [(G) / P],	
--		null [4 - Advance],	
--		(case when CTA.Cd_Tp_Tx IN ('XCA','XCQ','XEQ','XEU') then
--			sum(dbo.verparidade(convert(varchar(10),cta.Dt_Ins_HIA,103),'REL','OFC') * CTA.Vlr_Org_HIA)
--		else null end)	[5 - PT Revenue],
--		(case when CTA.Cd_Tp_Tx not IN ('XCA','XCQ','XEQ','XEU') then
--			sum(dbo.verparidade(convert(varchar(10),cta.Dt_Ins_HIA,103),'REL','OFC') * CTA.Vlr_Org_HIA)
--		else null end)	[6 - PT Cost],
--		--sum(dbo.verparidade(convert(varchar(10),cta.Dt_Ins_HIA,103),'REL','OFC') * CTA.Vlr_Org_HIA) [5 - PT Revenue],
--		--null [6 - PT Cost],
--		null [Balance]		
--	from 
--		vwcta_Cte CTA	
--		left join vwFaturasValidasArg FAD with(nolock) on FAD.Num_Proc = CTA.Num_Proc_HIA and FAD.Cd_Tp_Tx = CTA.Cd_Tp_Tx and FAD.DC = CTA.DC_HIA
--		--left join vwRegistroFinanceiroItem RFI  with(nolock) on RFI.Num_Proc = CTA.Num_Proc_HIA and RFI.Cd_Tp_Tx = CTA.Cd_Tp_Tx and RFI.DC = CTA.DC_HIA
--		Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx
--		Join vwClienteALLJOBS hou with(nolock) on hou.num_proc=CTA.Num_Proc_HIA		
--	Where
--		CTA.Num_Proc_HIA = @JOB 
--		--CTA.Num_Proc_HIA = 'IMATL21502082BR'  
--		and FAD.Num_Proc is null
--		--and RFI.Num_Proc is null
--		--and convert(datetime,HOU.Dt_Emis_HIM,103) between @Data_Inicial and @Data_Final			
--	Group by 
--		TT.Nome_Tp_Tx,HOU.Num_proc,CTA.Cd_Tp_Tx		
			
--UNION ALL
----Master
--	select
--		HOU.Master			[JOB],
--		TT.Nome_Tp_Tx,
--		HOU.Master + ' - ' + TT.Nome_Tp_Tx, 
--		null [1 - Sales],
--		null [2 - Sales Tax]	,
--		null [3 - Cost],
--		null [(G) / P],	
--		null [4 - Advance],
--		(case when CTA.Cd_Tp_Tx IN ('XCA','XCQ','XEQ','XEU') then
--			sum(dbo.verparidade(convert(varchar(10),cta.Dt_Ins_HIA,103),'REL','OFC') * CTA.Vlr_Org_HIA)
--		else null end)	[5 - PT Revenue],
--		(case when CTA.Cd_Tp_Tx not IN ('XCA','XCQ','XEQ','XEU') then
--			sum(dbo.verparidade(convert(varchar(10),cta.Dt_Ins_HIA,103),'REL','OFC') * CTA.Vlr_Org_HIA)
--		else null end)	[6 - PT Cost],
--		--sum(dbo.verparidade(convert(varchar(10),cta.Dt_Ins_HIA,103),'REL','OFC') * CTA.Vlr_Org_HIA) [5 - PT Revenue],
--		--null [6 - PT Cost],
--		null [Balance]
--	from 
--		vwcta_Cte CTA
--		Join vwClienteALLJOBS hou with(nolock) on hou.Master=CTA.Num_Proc_HIA	
--		left join vwFaturasValidasArg FAD with(nolock) on FAD.Num_Proc = CTA.Num_Proc_HIA and FAD.Cd_Tp_Tx = CTA.Cd_Tp_Tx and FAD.DC = CTA.DC_HIA
--		--left join vwRegistroFinanceiroItem RFI  with(nolock) on RFI.Num_Proc = CTA.Num_Proc_HIA and RFI.Cd_Tp_Tx = CTA.Cd_Tp_Tx and RFI.DC = CTA.DC_HIA
--		Join Tipo_Taxa TT with(nolock) on CTA.Cd_Tp_Tx = TT.Cd_Tp_Tx	
		
--	Where
--		HOU.num_proc = @JOB 
--		--CTA.Num_Proc_HIA = 'IMATL21502082BR'  
--		and FAD.Num_Proc is null
--		--and RFI.Num_Proc is null				
--	Group by 
--		TT.Nome_Tp_Tx,HOU.Master,HOU.Num_proc,CTA.Cd_Tp_Tx
			
insert into @TempNF	
	select 'Total','','','',
		SUM([1 - Sales])						[1 - Sales], 
		SUM([1 - Sales_Original])				[1 - Sales_Original], 
		SUM([2 - Sales Tax])					[2 - Sales Tax],		
		SUM([3 - Cost])							[3 - Cost],
		sum([(G) / P])							[(G) / P], 
		SUM([4 - Advance])						[4 - Advance],
		sum([5 - PT Revenue])					[5 - PT Revenue],
		sum([6 - PT Cost])						[6 - PT Cost],		
		SUM([Balance])							[Balance]	
	from @TempNF 
			

select 
	[JOB],[JOB] + ' - ' + [Nome_Taxa] [Descrição],[1 - Sales],[2 - Sales Tax],[3 - Cost],[(G) / P],
	[4 - Advance],[5 - PT Revenue],[6 - PT Cost],[Balance],[D/C],[Currency]
from 
	@TempNF  
order by 
	JOB,Nome_Taxa
	

*/


GO
