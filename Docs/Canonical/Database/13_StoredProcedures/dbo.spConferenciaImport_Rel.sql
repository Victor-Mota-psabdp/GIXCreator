SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Report Conferencia de Importação

CREATE procedure [dbo].[spConferenciaImport_Rel]--'IAOWE201205002BR'
	@JOB varchar(16)
as
if left(@JOB,2) = 'IM'
	select 
		DI.data_po_him dt_Pgto,
		'BDP' Despachante,
		dbo.fBusca_CampoCliente(@JOB,29) Vcto_Invoice,
		SHP.apelido Shipper,
		DI.numero_po_him DI,
		DI.data_po_him data_DI,
		dbo.fBusca_Docs_PO_Modal(@JOB,1) PO,
		@JOB JOB,
		PLL.cd_planta Filial,
		HOU.cd_tp_oper Incoterm,
		dbo.fBusca_Docs_PO_Modal(@JOB,10) NF,
		TRA.Apelido Transportadora,
		dbo.fBusca_Docs_PO_Modal(@JOB,2) Invoice,
		convert(float,isnull(dbo.fBusca_CampoCliente(@JOB,119),convert(float,isnull(dbo.fBusca_CampoCliente(@JOB,31),1)))) Paridade, 
		LLP.Cd_Moeda_Invoice,
		convert(float,isnull(dbo.fBusca_CampoCliente(@JOB,31),1)) ParidadeUSD,
		(case when cd_dst_him = 'GIG' then '16%' else '18%' end ) Aliq_ICMS
	from
		house_imp_mar HOU with(nolock)
		join llp_imp_mar LLP with(nolock) on LLP.num_proc_lim = HOU.num_proc_him
		left join pessoa_llp PLL with(nolock) on PLL.cd_pes = HOU.cd_consig_him
		join pessoa SHP with(nolock) on SHP.cd_pes = HOU.cd_export_him
--		left join pessoa TRA with(nolock) on TRA.cd_pes = dbo.fBusca_CampoCliente(@JOB,34)
		left join pessoa TRA with(nolock) on TRA.cd_pes = LLp.cd_transportadora
		left join po_him DI with(nolock) on DI.num_proc_him = HOU.num_proc_him and DI.id_dc = 5
	where
		HOU.num_proc_him = @JOB

else if left(@JOB,2) = 'IA'
	select 
		DI.data_po_hia dt_Pgto,
		'BDP' Despachante,
		dbo.fBusca_CampoCliente(@JOB,29) Vcto_Invoice,
		SHP.apelido Shipper,
		DI.numero_po_hia DI,
		DI.data_po_hia data_DI,
		dbo.fBusca_Docs_PO_Modal(@JOB,1) PO,
		@JOB JOB,
		PLL.cd_planta Filial,
		HOU.cd_tp_oper Incoterm,
		dbo.fBusca_Docs_PO_Modal(@JOB,10) NF,
		TRA.Apelido Transportadora,
		dbo.fBusca_Docs_PO_Modal(@JOB,2) Invoice,
		convert(float,isnull(dbo.fBusca_CampoCliente(@JOB,119),convert(float,isnull(dbo.fBusca_CampoCliente(@JOB,31),1)))) Paridade, 
		LLP.Cd_Moeda_Invoice,
		convert(float,isnull(dbo.fBusca_CampoCliente(@JOB,31),1)) ParidadeUSD,
		(case when cd_dst_hia = 'GIG' then '14%' else '18%' end ) Aliq_ICMS
	from
		house_imp_aer HOU with(nolock)
		join llp_imp_aer LLP with(nolock) on LLP.num_proc_lia = HOU.num_proc_hia
		left join pessoa_llp PLL with(nolock) on PLL.cd_pes = HOU.cd_consig_hia
		join pessoa SHP with(nolock) on SHP.cd_pes = HOU.cd_export_hia
--		left join pessoa TRA with(nolock) on TRA.cd_pes = dbo.fBusca_CampoCliente(@JOB,34)
		left join pessoa TRA with(nolock) on TRA.cd_pes = LLp.cd_transportadora
		left join po_hia DI with(nolock) on DI.num_proc_hia = HOU.num_proc_hia and DI.id_dc = 5
	where
		HOU.num_proc_hia = @JOB

if left(@JOB,2) = 'IO'
	select 
		DI.data_po_hio dt_Pgto,
		'BDP' Despachante,
		dbo.fBusca_CampoCliente(@JOB,29) Vcto_Invoice,
		SHP.apelido Shipper,
		DI.numero_po_hio DI,
		DI.data_po_hio data_DI,
		dbo.fBusca_Docs_PO_Modal(@JOB,1) PO,
		@JOB JOB,
		PLL.cd_planta Filial,
		HOU.cd_tp_oper Incoterm,
		dbo.fBusca_Docs_PO_Modal(@JOB,10) NF,
		TRA.Apelido Transportadora,
		dbo.fBusca_Docs_PO_Modal(@JOB,2) Invoice,
		convert(float,isnull(dbo.fBusca_CampoCliente(@JOB,119),convert(float,isnull(dbo.fBusca_CampoCliente(@JOB,31),1)))) Paridade, 
		LLP.Cd_Moeda_Invoice,
		convert(float,isnull(dbo.fBusca_CampoCliente(@JOB,31),1)) ParidadeUSD,
		(case when cd_dst_hio = 'GIG' then '16%' else '18%' end ) Aliq_ICMS
	from
		house_imp_out HOU with(nolock)
		join llp_imp_out LLP with(nolock) on LLP.num_proc_lio = HOU.num_proc_hio
		left join pessoa_llp PLL with(nolock) on PLL.cd_pes = HOU.cd_consig_hio
		join pessoa SHP with(nolock) on SHP.cd_pes = HOU.cd_export_hio
--		left join pessoa TRA with(nolock) on TRA.cd_pes = dbo.fBusca_CampoCliente(@JOB,34)
		left join pessoa TRA with(nolock) on TRA.cd_pes = LLp.cd_transportadora
		left join po_hio DI with(nolock) on DI.num_proc_hio = HOU.num_proc_hio and DI.id_dc = 5
	where
		HOU.num_proc_hio = @JOB
GO
