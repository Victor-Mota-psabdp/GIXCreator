SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE procedure [dbo].[spBDP_CustoCategoria_IMP_Rel] --'FMC'
(
	@Grupo as char(3)
)

as

	select --top 100
		num_proc_lim	BDP_Job,
		SHP.Apelido		Shipper,
		dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIM,'1') PO,
		HOU.MAWB_HIM	MAWB,
		CAR.Nome_Armador Carrier,
		'OCEAN'			Mode_Transp,
		ORG.nome_local	Origem,
		DST.nome_local	Destino,
		LLP.ATA_LIM		Entry_Date,
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIM,'War Risk%') MISC_Charges,
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIM,'Frete Interno%') Inland,

		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIM,'Frete (ALL IN)') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIM,'Frete Complementar') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIM,'Frete Complementar 2') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIM,'Fretes - CHB') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIM,'Frete (ALL IN) - CHB') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIM,'FRETE COMPLEMENTAR - CHB 2') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIM,'FRETE - CHB') Freight,
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIM,'ICMS%') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIM,'%Impo%Impo%') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIM,'%PIS%') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIM,'%Cofins%') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIM,'%IPI%') + dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIM,'II %') Duty,

		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIM,'%Demurrage%') Demurrage,
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIM,'%Serv%Despac%') Brokerage,
		'0' ISF
	from
		LLP_Imp_MAr LLP
		join House_Imp_Mar HOU on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
		join JOB_Imp_Mar JOB on JOB.Num_Proc_HIM = LLP.Num_Proc_LIM
		join Pessoa SHP on SHP.cd_pes = HOU.Cd_Export_HIM
		left join Armador CAR on CAR.cd_armador = JOB.cd_armador
		join Localidade ORG on ORG.cd_local = HOU.cd_org_him
		join Localidade DST on DST.cd_local = HOU.cd_dst_him
	where
		right(left(LLP.Num_Proc_LIM,5),3) = @Grupo
		AND LLP.ATA_LIM is not null

UNION ALL

	select --top 100
		num_proc_lia	BDP_Job,
		SHP.Apelido		Shipper,
		dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIA,'1') PO,
		HOU.MAWB_HIA	MAWB,
		CAR.Nome_Cia_Aer Carrier,
		'AIR'			Mode_Transp,
		ORG.nome_local	Origem,
		DST.nome_local	Destino,
		LLP.ATA_LIA		Entry_Date,
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIA,'War Risk%') MISC_Charges,
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIA,'Frete Interno%') Inland,

		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIA,'Frete (ALL IN)') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIA,'Frete Complementar') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIA,'Frete Complementar 2') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIA,'Fretes - CHB') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIA,'Frete (ALL IN) - CHB') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIA,'FRETE COMPLEMENTAR - CHB 2') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIA,'FRETE - CHB') Freight,

		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIA,'%ICMS%') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIA,'%Impo%Impo%') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIA,'%PIS%') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIA,'%Cofins%') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIA,'%IPI%') Duty,

		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIA,'%Demurrage%') Demurrage,
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIA,'%Serv%Despac%') Brokerage,
		'0' ISF
	from
		LLP_Imp_AEr LLP
		join House_Imp_AEr HOU on HOU.Num_Proc_HIA = LLP.Num_Proc_LIA
		join JOB_Imp_AEr JOB on JOB.Num_Proc_HIA = LLP.Num_Proc_LIA
		join Pessoa SHP on SHP.cd_pes = HOU.Cd_Export_HIA
		left join Cia_Aerea CAR on CAR.cd_cia_Aer = JOB.cd_cia_aer
		join Localidade ORG on ORG.cd_local = HOU.cd_org_hia
		join Localidade DST on DST.cd_local = HOU.cd_dst_hia
	where
		right(left(LLP.Num_Proc_LIA,5),3) = @Grupo
		AND LLP.ATA_LIA is not null

UNION ALL

	select --top 100
		num_proc_liO	BDP_Job,
		SHP.Apelido		Shipper,
		dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LIO,'1') PO,
		HOU.MAWB_HIO	MAWB,
		CAR.Apelido		Carrier,
		'OCEAN'			Mode_Transp,
		ORG.nome_local	Origem,
		DST.nome_local	Destino,
		LLP.ATA_LIO		Entry_Date,
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIO,'War Risk%') MISC_Charges,
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIO,'Frete Interno%') Inland,

		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIO,'Frete (ALL IN)') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIO,'Frete Complementar') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIO,'Frete Complementar 2') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIO,'Fretes - CHB') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIO,'Frete (ALL IN) - CHB') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIO,'FRETE COMPLEMENTAR - CHB 2') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIO,'FRETE - CHB') Freight,

		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIO,'%ICMS%') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIO,'%Impo%Impo%') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIO,'%PIS%') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIO,'%Cofins%') +
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIO,'%IPI%') Duty,

		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIO,'%Demurrage%') Demurrage,
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LIO,'%Serv%Despac%') Brokerage,
		'0' ISF
	from
		LLP_Imp_OUT LLP
		join House_Imp_OUT HOU on HOU.Num_Proc_HIO = LLP.Num_Proc_LIO
		join Pessoa SHP on SHP.cd_pes = HOU.Cd_Export_HIO
		left join Pessoa CAR on CAR.cd_pes = LLP.Cd_Carrier
		join Localidade ORG on ORG.cd_local = HOU.cd_org_hio
		join Localidade DST on DST.cd_local = HOU.cd_dst_hio
	where
		right(left(LLP.Num_Proc_LIO,5),3) = @Grupo
		AND LLP.ATA_LIO is not null



GO
