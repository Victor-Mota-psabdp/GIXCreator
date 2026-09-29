SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spProfit_rel] '2015-01-01','2016-4-29',''
--8/4/2016 - ALterei pra pegar o ATA do EA

CREATE Procedure [dbo].[spProfit_rel]

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
	hawb_hia as [HAWB],
	cta.num_proc_hia as [Processo], 
	apelido as [Agente], 
	nome_tp_tx as [Taxa], 
	--dc_hia, 
	cta.cd_tp_moeda as [Moeda], 
	cast(vlr_org_hia as money) as [Valor],
	US.Nome_Usuario	 as [CSR Name]   
from cta_cte_hou_imp_aer as cta with(nolock)

inner join tipo_taxa		as TT  with(nolock)on cta.cd_tp_Tx = tt.cd_tp_Tx
inner join housE_imp_aer	as hou with(nolock)on hou.num_proc_hia = cta.num_proc_hia
inner join pessoa			as Pes with(nolock)on cd_cred_dev_hia = cd_pes
Join Master_Imp_Aer			as MAS with(nolock)on Mas.num_proc_mia = hou.num_proc_mia
inner join Job_Imp_Aer		as JOB with(nolock)on hou.Num_Proc_HIA = JOB.Num_Proc_HIA
inner join Usuario			as US  with(nolock)on JOB.Cd_Usuario = US.Cd_Usuario
where  
	par_nf_hia is null 
	--convert(datetime, dt_cheg_mia, 105) between convert(datetime, @dataIncial, 105) and convert(datetime, @datafinal, 105)  and pft_aer='S' and cta.dc_hia = 'C'
	and convert(datetime, dt_cheg_mia, 105) between @dataIncial and @datafinal 	
	and apelido like @pessoa 
	and cta.dc_hia='C'
	and left(cta.num_proc_hia,5)<>'IAJOB'

union


select 
	hawb_hea as [HAWB],
	cta.num_proc_hea as [Proceso], 
	apelido as [Cliente], 
	nome_tp_tx as [Taxa], 
	--dc_hea, 
	cta.cd_tp_moeda as [Moeda], 
	cast(vlr_org_hea as money) AS [Valor],
	US.Nome_Usuario	 as [CSR Name] 
from cta_cte_hou_exp_aer as cta with(nolock)

inner join tipo_taxa		as TT  with(nolock)on cta.cd_tp_Tx = tt.cd_tp_Tx
inner join housE_exp_aer	as hou with(nolock)on hou.num_proc_hea = cta.num_proc_hea
inner join pessoa			as Pes with(nolock)on cd_cred_dev_hea = cd_pes
inner join master_exp_aer	as mas with(nolock)on hou.num_proc_mea = mas.num_proc_mea
inner join LLP_Master		as LLP with(nolock) on LLP.Num_Proc_Master = mas.Num_Proc_MEA
inner join Job_Exp_Aer		as JOB with(nolock)on hou.Num_Proc_HEA = JOB.Num_Proc_HEA
inner join Usuario			as US  with(nolock)on JOB.Cd_Usuario = US.Cd_Usuario

where  
	par_nf_hea is null
	--convert(datetime, dt_saida_mea, 105) between convert(datetime, @dataIncial, 105) and convert(datetime, @datafinal, 105)  and pft_aer='S' and cta.dc_hea='C'
	--and convert(datetime, dt_saida_mea, 105) between @dataIncial and @datafinal 
	and convert(datetime, LLP.ETA_Master, 105) between @dataIncial and @datafinal  	
	and apelido like @pessoa 
	and cta.dc_hea='C'
	and left(cta.num_proc_hea,5)<>'EAJOB'





order by 2









GO
