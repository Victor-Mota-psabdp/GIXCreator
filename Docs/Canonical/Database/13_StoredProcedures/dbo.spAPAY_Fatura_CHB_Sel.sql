SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select distinct(processo_pc) Referencia from fatura_chb with(nolock) 
--Join Pessoa_LLP with(nolock) on cd_pes_pc=cd_pes where 
--Data_PC between '2018-01-27' and '2018-04-27' 
--and processo_pc like 'I%GVA%'    order by 1 
--[spAPAY_Fatura_CHB_Sel] 'I','2018-01-27','2018-04-27','GVA'
CREATE ProcedurE [dbo].[spAPAY_Fatura_CHB_Sel]
(
	@modal as varchar(1),
	@strDataInicial as datetime,
	@strDataFinal as datetime,
	@grupo as varchar(3)
	
)
As		

select distinct(processo_pc) Referencia 
	from fatura_chb with(nolock) 
	Join Pessoa_LLP with(nolock) on cd_pes_pc=cd_pes 
where 
	Data_PC between @strDataInicial  and @strDataFinal
and 
	processo_pc like @modal + '%' + @grupo + '%' 
 
union all

select distinct(processo_pc) Referencia 
	from fatura_chb FAT with(nolock) 
	Join Pessoa_LLP with(nolock) on cd_pes_pc=cd_pes
where 
	Data_PC between @strDataInicial  and @strDataFinal
and 
	processo_pc like 'B%' + @grupo + '%' 

 order by 1 






















GO
