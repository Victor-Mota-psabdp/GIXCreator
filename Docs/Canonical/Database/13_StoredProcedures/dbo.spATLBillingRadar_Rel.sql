SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATLBillingRadar_Rel]--'','' [dbo].[spATLBillingRadar_Rel] '07-01-2014','07-30-2014'
	@DtInicial datetime,
	@DtFinal datetime
As

Declare @Table Table
	(
		Num_proc	Varchar(16),
		Tipo		Char(3)
		)
		
insert @Table

	select num_proc,'CHB' from tarefas_processos
	--where (dt_conclusao + 10 ) between '07-01-2013' and '07-31-2013'
	where (dt_conclusao + 10 ) between @DtInicial and @DtFinal
	and id_Task=4
	
	Union
	
	select C.num_proc,'FF' from vwcliente  C
	LEft Join Tarefas_Processos TP on Tp.num_proc=c.num_proc and id_task=4
	--where (data + 10) between '07-01-2013' and '07-31-2013'	
	where (data + 10) between @DtInicial and @DtFinal
	and Master <> 'JOB' and dt_conclusao is null 

/*
select Num_Proc,sum(dbo.valor(vlr_pgto_nf_hia,dc_hia)) From vwcta_Cte 
Left Join Base_Nota_Fiscal NF on Nota_Fiscal=num_nf_hia and ref_Acesso=ref_Acesso_nf_hia
Join @table T on T.num_proc=Num_proc_hia
Group by num_proc
*/


Declare @TableNF Table
	(
		Num_PRoc	Varchar(16),
		Vlr_NF		Decimal(10,2)
		)
		
insert @TableNF
	Select Num_Proc,sum(dbo.valor(vlr_pgto_nf_hia,dc_hia)) From  @Table
		Left Join vwcta_cte Cta on cta.num_proc_hia=num_proc
		Left Join Base_Nota_Fiscal NF on Nota_Fiscal=num_nf_hia and ref_Acesso=ref_Acesso_nf_hia
	where 
		cd_status <> '2'	
	group by num_proc

--Cliente,Grupo,CHB[Y/N],CSR,Origin,Destino

--IM
select 
	nf.num_proc [JOB],Vlr_NF [NF Value],sum(vlr_rs) [RS Value] , P.Apelido [Cliente],PG.Apelido [Grupo],
	(case when CP32.Campo_Dados='2' then 'NO' else 'YES'	end) [CHB(Y/N)],	
	U.nome_usuario [CSR],ORG.Nome_Local [Origin], DST. Nome_Local [Destino]
from @TableNF NF
	join @Table T on T.num_proc = NF.num_proc
	Left Join dbo.vwFaturasValidas FV on FV.num_proc=NF.num_proc
	join house_imp_mar HOU with(nolock) on HOU.Num_proc_Him =FV.num_proc
	join job_imp_mar JOB with(nolock) on HOU.Num_proc_Him =JOB.Num_proc_Him
	join usuario U on U.cd_usuario = JOB.cd_usuario
	join pessoa P with(nolock) on P.cd_pes = HOU.cd_consig_him
	join Grupo	G With (Nolock) on G.grupo = right(left(FV.num_proc,5),3)
	join pessoa	PG With (Nolock) on PG.cd_pes=G.cd_pes_grupo
	join localidade Org on ORg.cd_local = HOU.cd_org_him
	join localidade Dst on Dst.cd_local = HOU.cd_dst_him
	left join campo_processo CP32 with(nolock) on CP32.num_proc=NF.num_proc and CP32.id_campo=32
--where 
--	FV.num_proc = 'IMCSR201305014BR'
group  by Nf.num_proc,Vlr_NF,
	P.Apelido,PG.Apelido,
	U.nome_usuario, ORG.Nome_Local, DST. Nome_Local,
	T.Tipo,CP32.Campo_Dados

UNION ALL

--IA
select 
	nf.num_proc,Vlr_NF,sum(vlr_rs), P.Apelido [Cliente],PG.Apelido [Grupo],
	(case when CP32.Campo_Dados='2' then 'NO' else 'YES'	end) [CHB(Y/N)],
	U.nome_usuario [CSR],ORG.Nome_Local [Origin], DST. Nome_Local [Destino]
from @TableNF NF
	join @Table T on T.num_proc = NF.num_proc
	Left Join dbo.vwFaturasValidas FV on FV.num_proc=NF.num_proc
	join house_imp_aer HOU with(nolock) on HOU.Num_proc_Hia =FV.num_proc
	join job_imp_aer JOB with(nolock) on HOU.Num_proc_Hia =JOB.Num_proc_Hia
	join usuario U on U.cd_usuario = JOB.cd_usuario
	join pessoa P with(nolock) on P.cd_pes = HOU.cd_consig_hia
	join Grupo	G With (Nolock) on G.grupo = right(left(FV.num_proc,5),3)
	join pessoa	PG With (Nolock) on PG.cd_pes=G.cd_pes_grupo
	join localidade Org on ORg.cd_local = HOU.cd_org_hia
	join localidade Dst on Dst.cd_local = HOU.cd_dst_hia
	left join campo_processo CP32 with(nolock) on CP32.num_proc=NF.num_proc and CP32.id_campo=32
group  by Nf.num_proc,Vlr_NF,
	P.Apelido,PG.Apelido,
	U.nome_usuario, ORG.Nome_Local, DST. Nome_Local,
	T.Tipo,CP32.Campo_Dados



--IO
UNION ALL

	select 
	nf.num_proc,Vlr_NF,sum(vlr_rs), P.Apelido [Cliente],PG.Apelido [Grupo],
	(case when CP32.Campo_Dados='2' then 'NO' else 'YES'	end) [CHB(Y/N)],
	U.nome_usuario [CSR],ORG.Nome_Local [Origin], DST. Nome_Local [Destino]
from @TableNF NF
	join @Table T on T.num_proc = NF.num_proc
	Left Join dbo.vwFaturasValidas FV on FV.num_proc=NF.num_proc
	join house_imp_out HOU with(nolock) on HOU.Num_proc_Hio =FV.num_proc
	join LLP_imp_out JOB with(nolock) on HOU.Num_proc_Hio =JOB.Num_proc_lio
	join usuario U on U.cd_usuario = JOB.cd_usuario
	join pessoa P with(nolock) on P.cd_pes = HOU.cd_consig_hio
	join Grupo	G With (Nolock) on G.grupo = right(left(FV.num_proc,5),3)
	join pessoa	PG With (Nolock) on PG.cd_pes=G.cd_pes_grupo
	join localidade Org on ORg.cd_local = HOU.cd_org_hio
	join localidade Dst on Dst.cd_local = HOU.cd_dst_hio
	left join campo_processo CP32 with(nolock) on CP32.num_proc=NF.num_proc and CP32.id_campo=32
group  by Nf.num_proc,Vlr_NF,
	P.Apelido,PG.Apelido,
	U.nome_usuario, ORG.Nome_Local, DST. Nome_Local,
	T.Tipo,CP32.Campo_Dados


UNION ALL

--EM
select 
	nf.num_proc,Vlr_NF,sum(vlr_rs), P.Apelido [Cliente],PG.Apelido [Grupo],
	(case when CP32.Campo_Dados='2' then 'NO' else 'YES'	end) [CHB(Y/N)],
	U.nome_usuario [CSR],ORG.Nome_Local [Origin], DST. Nome_Local [Destino]
from @TableNF NF
	join @Table T on T.num_proc = NF.num_proc
	Left Join dbo.vwFaturasValidas FV on FV.num_proc=NF.num_proc
	join house_exp_mar HOU with(nolock) on HOU.Num_proc_Hem =FV.num_proc
	join job_exp_mar JOB with(nolock) on HOU.Num_proc_Hem =JOB.Num_proc_Hem
	join usuario U on U.cd_usuario = JOB.cd_usuario
	join pessoa P with(nolock) on P.cd_pes = HOU.cd_export_hem
	join Grupo	G With (Nolock) on G.grupo = right(left(FV.num_proc,5),3)
	join pessoa	PG With (Nolock) on PG.cd_pes=G.cd_pes_grupo
	join localidade Org on ORg.cd_local = HOU.cd_org_hem
	join localidade Dst on Dst.cd_local = HOU.cd_dst_hem
	left join campo_processo CP32 with(nolock) on CP32.num_proc=NF.num_proc and CP32.id_campo=32
group  by Nf.num_proc,Vlr_NF,
	P.Apelido,PG.Apelido,
	U.nome_usuario, ORG.Nome_Local, DST. Nome_Local,
	T.Tipo,CP32.Campo_Dados

UNION ALL

--EA
select 
	nf.num_proc,Vlr_NF,sum(vlr_rs), P.Apelido [Cliente],PG.Apelido [Grupo],
	(case when CP32.Campo_Dados='2' then 'NO' else 'YES'	end) [CHB(Y/N)],
	U.nome_usuario [CSR],ORG.Nome_Local [Origin], DST. Nome_Local [Destino]
from @TableNF NF
	join @Table T on T.num_proc = NF.num_proc
	Left Join dbo.vwFaturasValidas FV on FV.num_proc=NF.num_proc
	join house_exp_aer HOU with(nolock) on HOU.Num_proc_Hea =FV.num_proc
	join job_exp_aer JOB with(nolock) on HOU.Num_proc_Hea =JOB.Num_proc_Hea
	join usuario U on U.cd_usuario = JOB.cd_usuario
	join pessoa P with(nolock) on P.cd_pes = HOU.cd_export_hea
	join Grupo G With (Nolock) on G.grupo = right(left(FV.num_proc,5),3)
	join pessoa	PG With (Nolock) on PG.cd_pes=G.cd_pes_grupo
	join localidade Org on ORg.cd_local = HOU.cd_org_hea
	join localidade Dst on Dst.cd_local = HOU.cd_dst_hea
	left join campo_processo CP32 with(nolock) on CP32.num_proc=NF.num_proc and CP32.id_campo=32
group  by Nf.num_proc,Vlr_NF,
	P.Apelido,PG.Apelido,
	U.nome_usuario, ORG.Nome_Local, DST. Nome_Local,
	T.Tipo,CP32.Campo_Dados
	
	UNION ALL

--EO
select 
	nf.num_proc,Vlr_NF,sum(vlr_rs), P.Apelido [Cliente],PG.Apelido [Grupo],
	(case when CP32.Campo_Dados='2' then 'NO' else 'YES'	end) [CHB(Y/N)],
	U.nome_usuario [CSR],ORG.Nome_Local [Origin], DST. Nome_Local [Destino]
from @TableNF NF
	join @Table T on T.num_proc = NF.num_proc
	Left Join dbo.vwFaturasValidas FV on FV.num_proc=NF.num_proc
	join house_exp_out HOU with(nolock) on HOU.Num_proc_Heo =FV.num_proc
	join llp_exp_out JOB with(nolock) on HOU.Num_proc_Heo =JOB.Num_proc_Leo
	join usuario U on U.cd_usuario = JOB.cd_usuario
	join pessoa P with(nolock) on P.cd_pes = HOU.cd_export_heo
	join Grupo G With (Nolock) on G.grupo = right(left(FV.num_proc,5),3)
	join pessoa	PG With (Nolock) on PG.cd_pes=G.cd_pes_grupo
	join localidade Org on ORg.cd_local = HOU.cd_org_heo
	join localidade Dst on Dst.cd_local = HOU.cd_dst_heo
	left join campo_processo CP32 with(nolock) on CP32.num_proc=NF.num_proc and CP32.id_campo=32
group  by Nf.num_proc,Vlr_NF,
	P.Apelido,PG.Apelido,
	U.nome_usuario, ORG.Nome_Local, DST. Nome_Local,
	T.Tipo,CP32.Campo_Dados

GO
