SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--select 
--	cta.num_proc_hia as [Processo], 
--	apelido			 as [Agente], 
--	nome_tp_tx		 as [Taxa], 
--	cta.dc_hia	     as DC, 
--	cta.cd_tp_moeda	 as [Moeda], 
--	cast(cta.Vlr_Org_HIA as money) as [valor],
--	convert(datetime, CTA.Dt_Ins_HIA, 105) DT_INS,
--	cta.num_nf_hia
--from vwCTA_CTE as cta with(nolock)
--inner join tipo_taxa		as TT  with(nolock) on cta.cd_tp_Tx = tt.cd_tp_Tx
--inner join pessoa			as Pes with(nolock) on Cd_Cred_Dev_HIA = cd_pes
--join [vwAXDocs] AX on AX.Num_proc = cta.num_proc_hia and AX.dc = cta.dc_hia and AX.cd_tp_tx_Atl = cta.cd_tp_tx
--where  
--	--par_nf_him is null and 
--	convert(datetime, CTA.Dt_Ins_HIA, 105) between '2023-01-01' and '2023-12-31'
--	and tt.nome_tp_tx like '%comissao%'
--	and cta.dc_hia = 'D'
--	and apelido like '%' 
--Order by 1



CREATE Procedure [dbo].[spProfitMarAir_Comissao_Rel]--'2020-01-01','2025-12-31',''
(
	@dataincial	datetime,
	@datafinal	datetime,
	@pessoa		varchar(30)
)

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
	cta.dc_him	     as DC, 
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
	convert(datetime, LLP.ATA_Master, 105) between @dataIncial and @datafinal
	and tt.nome_tp_tx like '%comissao%'
	--and (pft_mar='S' or Pft_Aer='S')
	and cta.dc_him = 'D'
	and apelido like @pessoa 


union all


select 
	hawb_hem					as [HAWB],
	cta.num_proc_hem			as [Processo], 
	apelido						as [Agente], 
	nome_tp_tx					as [Taxa], 
	cta.dc_hem					as DC, 
	cta.cd_tp_moeda				as [Moeda],
	cast(vlr_org_hem as money)	as [Valor],
	US.Nome_Usuario				as [CSR Name]   
from cta_cte_hou_exp_mar as cta with(nolock)
inner join tipo_taxa		as TT  with(nolock) on cta.cd_tp_Tx = tt.cd_tp_Tx
inner join housE_exp_mar	as hou with(nolock) on hou.num_proc_hem = cta.num_proc_hem
inner join master_exp_mar	as mas with(nolock) on hou.num_proc_mem = mas.num_proc_mem
inner join LLP_Master		as LLP with(nolock) on LLP.Num_Proc_Master = mas.num_proc_mem
inner join pessoa			as Pes with(nolock) on cd_cred_dev_hem = cd_pes
inner join Job_exp_mar		as JOB with(nolock) on hou.Num_Proc_HEM = JOB.Num_Proc_HEM
inner join Usuario			as US  with(nolock) on JOB.Cd_Usuario = US.Cd_Usuario
where  
	--cta.Num_Proc_HEM = 'EMARC202309010BR' and 
	par_nf_hem is null and 
	convert(datetime, LLP.ETA_Master, 105) between @dataIncial and @datafinal
	and tt.nome_tp_tx like '%comissao%'
	--and (pft_mar='S' or Pft_Aer='S')
	and cta.dc_hem='D'
	and apelido like @pessoa 


UNION ALL
select 
	hawb_hia as [HAWB],
	cta.num_proc_hia as [Processo], 
	apelido as [Agente], 
	nome_tp_tx as [Taxa], 
	cta.dc_hia					as DC, 
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
	and convert(datetime, dt_cheg_mia, 105) between @dataIncial and @datafinal 	
	and tt.nome_tp_tx like '%comissao%'
	and apelido like @pessoa 
	and cta.dc_hia='D'
	and left(cta.num_proc_hia,5)<>'IAJOB'

union

select 
	hawb_hea as [HAWB],
	cta.num_proc_hea as [Proceso], 
	apelido as [Cliente], 
	nome_tp_tx as [Taxa],
	cta.dc_hea	as DC, 
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
	and convert(datetime, LLP.ETA_Master, 105) between @dataIncial and @datafinal  	
	and tt.nome_tp_tx like '%comissao%'
	and apelido like @pessoa 
	and cta.DC_HEA='D'
	and left(cta.num_proc_hea,5)<>'EAJOB'

order by 2






GO
