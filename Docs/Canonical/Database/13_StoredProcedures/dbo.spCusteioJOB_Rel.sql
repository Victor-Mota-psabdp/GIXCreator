SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spCusteioJOB_Rel]
(
	@JOB varchar(16)
)
as

if left(@JOB,2) = 'IA'
	Begin
		select 
			SHP.apelido [Fornecedor], DI.numero_po_hia [Nº DI], DI.data_po_hia [Data D.I.], INV.numero_po_hia [Nº Fatura], @JOB [Ref. BDP], replace(PAR.campo_dados,'.',',') [Valor Taxa D.I.], HOU.cd_tp_moeda [Moeda], dbo.fBusca_Docs_PO_Modal(@JOB,10) [Nº NF], '' [Centro Custo], '' [Conta Contabil], GR.cd_planta [Filial]
		from
			house_imp_aer HOU with(nolock)
			join pessoa SHP with(nolock) on SHP.cd_pes = HOU.cd_export_hia
			left join po_hia DI with(nolock) on DI.num_proc_hia = @JOB and DI.id_dc = 5
			left join po_hia INV with(nolock) on INV.num_proc_hia = @JOB and INV.id_dc = 2
			left join campo_processo PAR with(nolock) on PAR.num_proc = @JOB and PAR.id_campo = 31
			join pessoa_LLP GR with(nolock) on GR.cd_pes = HOU.cd_consig_hia and GR.cd_pes_grupo = (select cd_pes_grupo from grupo where grupo = substring(@JOB,3,3))
		where
			HOU.num_proc_hia = @JOB
	End
else if left(@JOB,2) = 'IM'
	Begin
		select 
			SHP.apelido [Fornecedor], DI.numero_po_him [Nº DI], DI.data_po_him [Data D.I.], INV.numero_po_him [Nº Fatura], @JOB [Ref. BDP], replace(PAR.campo_dados,'.',',') [Valor Taxa D.I.], HOU.cd_tp_moeda [Moeda], dbo.fBusca_Docs_PO_Modal(@JOB,10) [Nº NF], '' [Centro Custo], '' [Conta Contabil], '' [Filial]
		from
			house_imp_mar HOU with(nolock)
			join pessoa SHP with(nolock) on SHP.cd_pes = HOU.cd_export_him
			left join po_him DI with(nolock) on DI.num_proc_him = @JOB and DI.id_dc = 5
			left join po_him INV with(nolock) on INV.num_proc_him = @JOB and INV.id_dc = 2
			left join campo_processo PAR with(nolock) on PAR.num_proc = @JOB and PAR.id_campo = 31
			join pessoa_LLP GR with(nolock) on GR.cd_pes = HOU.cd_consig_him and GR.cd_pes_grupo = (select cd_pes_grupo from grupo where grupo = substring(@JOB,3,3))
		where
			HOU.num_proc_him = @JOB
	End
else if left(@JOB,2) = 'IO'
	Begin
		select 
			SHP.apelido [Fornecedor], DI.numero_po_hio [Nº DI], DI.data_po_hio [Data D.I.], INV.numero_po_hio [Nº Fatura], @JOB [Ref. BDP], replace(PAR.campo_dados,'.',',') [Valor Taxa D.I.], HOU.cd_tp_moeda [Moeda], dbo.fBusca_Docs_PO_Modal(@JOB,10) [Nº NF], '' [Centro Custo], '' [Conta Contabil], '' [Filial]
		from
			house_imp_out HOU with(nolock)
			join pessoa SHP with(nolock) on SHP.cd_pes = HOU.cd_export_hio
			left join po_hio DI with(nolock) on DI.num_proc_hio = @JOB and DI.id_dc = 5
			left join po_hio INV with(nolock) on INV.num_proc_hio = @JOB and INV.id_dc = 2
			left join campo_processo PAR with(nolock) on PAR.num_proc = @JOB and PAR.id_campo = 31
			join pessoa_LLP GR with(nolock) on GR.cd_pes = HOU.cd_consig_hio and GR.cd_pes_grupo = (select cd_pes_grupo from grupo where grupo = substring(@JOB,3,3))
		where
			HOU.num_proc_hio = @JOB
	End
GO
