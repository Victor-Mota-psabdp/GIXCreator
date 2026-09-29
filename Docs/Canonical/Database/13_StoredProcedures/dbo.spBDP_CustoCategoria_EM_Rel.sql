SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spBDP_CustoCategoria_EM_Rel] 
(
	@Grupo as char(3)
)

as

	select --top 100
		num_proc_lem	BDP_Job,
		dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LEM,'3') Ref_EXP,
		CNS.Nome_Raz_Soc Consignee,
		SHP.Apelido		Shipper,
		ORG.nome_local	PortoOrigem,
		CAR.Nome_Armador Carrier,
		LLP.ATD_LEM		ATD,
		DST.nome_local	PortoDestino,
		DST.Pais_Local	PaisDestino,
		Peso_Liquido_HEM Peso_Liquido,
		Peso_Bruto_HEM	Peso_Bruto,
		Qtd_Tot_Vol_HEM	Qtd_Tot_Vol,--Teu_NBR,
		Vol_Tot_HEM		Volume,--Tot Fas Nbr
		HOU.Vlr_Frete_Tot_HEM Frete,
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LEM,'Courier%') Courier,
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LEM,'Forwarding%') Forwarding,
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LEM,'Servi%Despa%') Serv_Despacho,
		'' Consular_Preparation,
		'' Consular_Fees,
		'' Fore_Collect_Adnvance

	from
		LLP_Exp_Mar LLP
		join House_Exp_Mar HOU on HOU.Num_Proc_HEM = LLP.Num_Proc_LEM
		join Pessoa CNS on CNS.cd_pes = HOU.Cd_Consig_HEM
		join Pessoa SHP on SHP.cd_pes = HOU.Cd_Export_HEM
		left join Armador CAR on CAR.cd_Armador = LLP.cd_armador_LEM
		join Localidade ORG on ORG.cd_local = HOU.cd_org_hem
		join Localidade DST on DST.cd_local = HOU.cd_dst_hem
	where
		right(left(LLP.Num_Proc_LEM,5),3) = @Grupo
		AND LLP.ATD_LEM is not null



GO
