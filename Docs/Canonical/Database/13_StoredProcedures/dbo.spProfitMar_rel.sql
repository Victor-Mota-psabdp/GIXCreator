SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select 'Aereo' union all select 'Maritimo'
--[spProfitMar_rel] '2015-01-01','2016-4-29',''
--8/4/2016 - ALterei pra pegar o ATA do EM
--27/1/2017 - ALterei pra pegar o ATA do IM

CREATE  Procedure [dbo].[spProfitMar_rel]--'2015-05-01','2016-2-29',''

			--@dataincial	varchar(10),
			--@datafinal	varchar(10),
			@dataincial	datetime,
			@datafinal	datetime,
			@pessoa		varchar(30)

AS

	if @pessoa = ''
		set @pessoa = '%' 
	if @pessoa = ' ALL'
		set @pessoa = '%' 

select 
	hawb_him		 as [HAWB],
	cta.num_proc_him as [Processo], 
	apelido			 as [Agente], 
	nome_tp_tx		 as [Taxa], 
	--dc_him, 
	cta.cd_tp_moeda	 as [Moeda], 
	cast(vlr_org_him as money) as [valor],
	US.Nome_Usuario	 as [CSR Name]   
from cta_cte_hou_imp_mar as cta with(nolock)

inner join tipo_taxa		as TT  with(nolock) on cta.cd_tp_Tx = tt.cd_tp_Tx
inner join housE_imp_mar	as hou with(nolock) on hou.num_proc_him = cta.num_proc_him
inner join pessoa			as Pes with(nolock) on cd_cred_dev_him = cd_pes
inner join master_imp_mar	as mas with(nolock) on mas.num_proc_mim = hou.num_proc_mim
inner join LLP_Master		as LLP with(nolock) on LLP.Num_Proc_Master = mas.num_proc_mim
inner join Job_Imp_Mar		as JOB with(nolock) on hou.Num_Proc_HIM = JOB.Num_Proc_HIM
inner join Usuario			as US  with(nolock) on JOB.Cd_Usuario = US.Cd_Usuario
where  
	par_nf_him is null and 
	--convert(datetime, Dt_atrac_mim, 105) between convert(datetime, @dataIncial, 105) and convert(datetime, @datafinal, 105) 
	--convert(datetime, Dt_atrac_mim, 105) between @dataIncial and @datafinal
	convert(datetime, LLP.ATA_Master, 105) between @dataIncial and @datafinal
	and (pft_mar='S' or Pft_Aer='S')
	and cta.dc_him = 'C'
	and apelido like @pessoa 


union all


select 
	hawb_hem as [HAWB],
	cta.num_proc_hem as [Processo], 
	apelido as [Agente], 
	nome_tp_tx as [Taxa], 
	--dc_hem, 
	cta.cd_tp_moeda as [Moeda],
	cast(vlr_org_hem as money) AS [Valor],
	US.Nome_Usuario as [CSR Name]   
from cta_cte_hou_exp_mar as cta with(nolock)

inner join tipo_taxa		as TT  with(nolock) on cta.cd_tp_Tx = tt.cd_tp_Tx
inner join housE_exp_mar	as hou with(nolock) on hou.num_proc_hem = cta.num_proc_hem
inner join master_exp_mar	as mas with(nolock) on hou.num_proc_mem = mas.num_proc_mem
inner join LLP_Master		as LLP with(nolock) on LLP.Num_Proc_Master = mas.num_proc_mem
inner join pessoa			as Pes with(nolock) on cd_cred_dev_hem = cd_pes
inner join Job_exp_mar		as JOB with(nolock) on hou.Num_Proc_HEM = JOB.Num_Proc_HEM
inner join Usuario			as US  with(nolock) on JOB.Cd_Usuario = US.Cd_Usuario 

where  
	par_nf_hem is null and 
	--convert(datetime, dt_saida_mem, 105) between convert(datetime, @dataIncial, 105) and convert(datetime, @datafinal, 105)  
	--convert(datetime, dt_saida_mem, 105) between @dataIncial and @datafinal 
	convert(datetime, LLP.ETA_Master, 105) between @dataIncial and @datafinal 
	and (pft_mar='S' or Pft_Aer='S')
	and cta.dc_hem='C'
	and apelido like @pessoa 



order by 2






GO
