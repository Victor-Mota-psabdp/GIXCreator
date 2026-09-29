SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spBDP_CustoCategoria_EA_Rel] 
(
	@Grupo as char(3)
)

as

	select --top 100
		num_proc_lea	BDP_Job,
		SHP.Apelido		Shipper,
		dbo.fBusca_Docs_PO_Modal(LLP.Num_Proc_LEA,'3') Ref_EXP,
		ORG.nome_local	AeroPortoOrigem,
		LLP.ATD_LEA		ATD,
		DST.nome_local	AeroPortoDestino,
		CAR.Nome_Cia_Aer Carrier,
		HOU.MAWB_HEA	MAWB,
		Peso_Real_HEA	Peso_Liquido,
		HOU.Vlr_Frete_Tot_HEA Frete,
		'' Frete_Consol,
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LEA,'Forwarding%') Forwarding,
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LEA,'%Fuel%Surcharge%') Fuel_Surcharge,
		'' Airport_Transfers,
		dbo.fBusca_Custo_Processo_FMC(LLP.Num_Proc_LEA,'War Risk%') MISC_Charges

	from
		LLP_Exp_Aer LLP
		join House_Exp_AEr HOU on HOU.Num_Proc_HEA = LLP.Num_Proc_LEA
		join Pessoa SHP on SHP.cd_pes = HOU.Cd_Export_HEA
		left join Cia_Aerea CAR on CAR.cd_cia_Aer = LLP.cd_CiaAerea_LEA
		join Localidade ORG on ORG.cd_local = HOU.cd_org_hea
		join Localidade DST on DST.cd_local = HOU.cd_dst_hea
	where
		right(left(LLP.Num_Proc_LEA,5),3) = @Grupo
		AND LLP.ATD_LEA is not null




GO
