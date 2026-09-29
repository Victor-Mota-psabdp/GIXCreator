SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_DesembSemNota_Rel]--'GRUPO DOW','2015-01-01','2015-08-17'
(
	@Group varchar(50),
	@DataInicial datetime,
	@DataFinal datetime	
)

as

if @Group = '' or @Group = 'GRUPO ALL'
	set @Group = '%'

select 
	tp.num_proc			[JOB],
	tp.dt_conclusao		[Data do Desembaraço],
	l.nome_local		[Destino Final],
	--cast(getdate()-tp.dt_conclusao as int) Dias,
	DATEDIFF(day,tp.dt_conclusao,GETDATE()) Dias,
	GRP.Apelido		Grupo
from tarefas_processos		TP  with(nolock)
	left join nota_cliente	NC with(nolock) on nc.num_proc=tp.num_proc
	left join llp_imp_mar	LLP with(nolock) on llp.num_proc_lim=tp.num_proc
	left join localidade	L with(nolock) on l.cd_local=llp.cd_dstfinal_lim
	left join House_imp_mar HOU with(nolock) on llp.num_proc_lim=HOU.Num_Proc_HIM
	Left Join Pessoa_LLP	PLLP With(Nolock)  on PLLP.cd_pes=hou.Cd_Consig_HIM
	Left Join Pessoa		GRP with(nolock) on GRP.cd_pes=cd_pes_Grupo and GRP.cd_pes <> 'GRATL' 
where 
	nc.num_proc is null
	--and dt_conclusao <= getdate()-2
	and tp.id_task='4'
	and left(tp.num_proc,1)='I'
	--and right(left(tp.num_proc,5),3)='CSR'
	and tp.dt_conclusao between @DataInicial and @DataFinal
	and l.nome_local is not null
	and GRP.apelido like @Group

union all

select	
	tp.num_proc Referencia,
	tp.dt_conclusao Dt_Desembaraco,
	l.nome_local Destino_Final,
	--cast(getdate()-tp.dt_conclusao as int) Dias,
	DATEDIFF(day,tp.dt_conclusao,GETDATE()) Dias,
	GRP.Apelido		Grupo
from tarefas_processos		TP with(nolock) 
	left join nota_cliente	NC with(nolock) on nc.num_proc=tp.num_proc
	left join llp_imp_aer	LLP with(nolock) on llp.num_proc_lia=tp.num_proc
	left join localidade	L with(nolock) on l.cd_local=llp.cd_dstfinal_lia 
	left Join PO_HIA		DI with(nolock) on DI.num_proc_hia=tp.num_proc AND ID_DC=5
	left join House_Imp_Aer HOU with(nolock) on llp.num_proc_lia=HOU.Num_Proc_HIA
	Left Join Pessoa_LLP	PLLP With(Nolock)  on PLLP.cd_pes=hou.Cd_Consig_HIa
	Left Join Pessoa		GRP with(nolock) on GRP.cd_pes=cd_pes_Grupo and GRP.cd_pes <> 'GRATL' 
where 
	nc.num_proc is null
	--and dt_conclusao <= getdate()-2
	and tp.id_task='4'
	and left(tp.num_proc,1)='I'
	--and right(left(tp.num_proc,5),3)='CSR'
	and tp.dt_conclusao between @DataInicial and @DataFinal
	and l.nome_local is not null
	AND NUMERO_PO_hIa <> 'Courier'
	and GRP.apelido like @Group


union all

select	
	tp.num_proc Referencia,
	tp.dt_conclusao Dt_Desembaraco,
	l.nome_local Destino_Final,
	--cast(getdate()-tp.dt_conclusao as int) Dias,
	DATEDIFF(day,tp.dt_conclusao,GETDATE()) Dias,
	GRP.Apelido		Grupo
from tarefas_processos		TP	with(nolock) 
	left join nota_cliente	NC	with(nolock) on nc.num_proc=tp.num_proc
	left join llp_imp_out	LLP with(nolock) on llp.num_proc_lio=tp.num_proc
	left join localidade	L	with(nolock) on l.cd_local=llp.cd_dstfinal_lio 
	left join House_Imp_Out HOU with(nolock) on llp.num_proc_lio=HOU.Num_Proc_HIo
	Left Join Pessoa_LLP	PLLP With(Nolock)  on PLLP.cd_pes=hou.Cd_Consig_HIO
	Left Join Pessoa		GRP with(nolock) on GRP.cd_pes=cd_pes_Grupo and GRP.cd_pes <> 'GRATL' 
where	
	nc.num_proc is null
	--and dt_conclusao <= getdate()-5
	and tp.id_task='4'
	and left(tp.num_proc,1)='I'
	--and right(left(tp.num_proc,5),3)='CSR'
	and tp.dt_conclusao between @DataInicial and @DataFinal
	and l.nome_local is not null
	and GRP.apelido like @Group

order by Dias desc

OPTION(HASH JOIN)


GO
