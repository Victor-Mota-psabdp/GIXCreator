SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--alterado: criada a funcao de somar o que eh Agent e Carrier e inclusão do tp_frete pra saber se eh collect ou prepaid- Carlos Eduardo - 18/01

CREATE Procedure [dbo].[spManifestoMEA_Sel]--'EAVCP201101004' --'EAGRU201012005'

	@Processo varchar(14)

As

	select distinct
		MAS.Num_Proc_MEA		Processo,
		HOU.Num_Proc_HEA		JOB,
		MAS.Dt_Emis_Mea			Dt_Emissao,
		CSGM.Nome_Raz_Soc		ConsigneeMas,
		ENDCM.Cidade			Cidade_CSGM,
		ENDCM.Pais				Pais_CSGM,	
		SHPM.Nome_Raz_Soc		ShipperMas,
		ENDSM.Cidade			Cidade_SHPM,
		ENDSM.Pais				Pais_SHPM,
		MAS.MAWB_MEA			MAWB,
		HOU.HAWB_HEA			HAWB,
		MAS.Voo_MEA				Flight,
		HOU.Peso_Bruto_HEA		Peso_Bruto,
		HOU.vlr_frete_tot_hea	VlrFrete,
		MAS.Qtd_Tot_Vol_Mea		Qtd_Total,
		MAS.Cd_Org_MEA			Origem,
		MAS.Cd_Dst_MEA			Destino,
		left(convert(varchar(10),LLP.ETD_Master,105),5)Dt_Voo,
		left(replace(replace(NG.Descr, char(13),' '), char(10),' '),100)Descr_Goods,
		CON.Nome_Raz_Soc		Consignee,
		ENDCON.Rua				RuaCON,
		ENDCON.Numero			NumCON,
		ENDCON.Compl_End		CompCON,
		ENDCON.Cidade			CidadeCON,
		ENDCON.UF				EstadoCON,
		ENDCON.Pais				PaisCON,
		SHIP.Nome_Raz_Soc		Shipper,
		ENDSHIP.Rua				RuaSHIP,
		ENDSHIP.Numero			NumSHIP,
		ENDSHIP.Compl_End		CompSHIP,
		ENDSHIP.Cidade			CidadeSHIP,
		ENDSHIP.UF				EstadoSHIP,
		ENDSHIP.Pais			PaisSHIP,
		dbo.fBusca_CampoCliente(MAS.Num_Proc_MEA,98) Manifesto,
		dbo.fSomaVlrAgentCarrier (HOU.num_proc_hea) valor,
		hou.Tp_frete_HEA tipo_frete,
		--isnull(Sum(FTA.vlr_org_HEA),0) Vlr_Agt_HEA,
		--isnull(Sum(FTC.vlr_org_HEA),0) Vlr_Crr_HEA,
		MAS.Peso_Bruto_MEA		Peso_BrutoMEA,
		HOU.Qtd_Tot_Vol_HEA		Pieces		 			

	from Master_Exp_Aer MAS
		join House_Exp_Aer HOU				on HOU.num_proc_mea = MAS.num_proc_mea
		--left join cta_cte_HOU_exp_aer FTA	on FTA.Num_Proc_HEA = HOU.num_proc_hea and FTA.Comp_Job_HEA = 'A'
		--left join cta_cte_HOU_exp_aer FTC	on FTC.Num_Proc_HEA = HOU.num_proc_hea and FTC.Comp_Job_HEA = 'C'
		left join LLP_Master LLP			on LLP.Num_Proc_Master = HOU.Num_Proc_MEA
		left join Nature_Goods NG			on NG.num_proc = HOU.Num_Proc_HEA
		left join Pessoa CSGM				on CSGM.cd_pes = MAS.Cd_Consig_MEA
		left join Endereco ENDCM			on ENDCM.cd_pes = CSGM.cd_pes
		left join Pessoa SHPM				on SHPM.cd_pes = MAS.cd_Export_MEA
		left join Endereco ENDSM			on ENDSM.cd_pes = SHPM.cd_pes
		left join Pessoa CON				on CON.cd_pes = HOU.Cd_Consig_HEA
		left join Endereco ENDCON			on ENDCON.cd_pes = CON.cd_pes
		left join Pessoa SHIP				on SHIP.cd_pes = HOU.Cd_Export_HEA
		left join Endereco ENDSHIP			on ENDSHIP.cd_pes = SHIP.cd_pes
	where
		HOU.Num_proc_MEA = @Processo
	group by
		MAS.Num_Proc_MEA,
		HOU.Num_Proc_HEA,
		MAS.Dt_Emis_Mea,
		CSGM.Nome_Raz_Soc,
		ENDCM.Cidade,
		ENDCM.Pais,
		SHPM.Nome_Raz_Soc,
		ENDSM.Cidade,
		ENDSM.Pais,
		MAS.MAWB_MEA,
		HOU.HAWB_HEA,
		MAS.Voo_MEA,
		HOU.Peso_Bruto_HEA,
		HOU.vlr_frete_tot_hea,
		MAS.Qtd_Tot_Vol_Mea,
		MAS.Cd_Org_MEA,
		MAS.Cd_Dst_MEA,
		LLP.ETD_Master,
		NG.Descr,
		CON.Nome_Raz_Soc,
		ENDCON.Rua,
		ENDCON.Numero,
		ENDCON.Compl_End,
		ENDCON.Cidade,
		ENDCON.UF,
		ENDCON.Pais,
		SHIP.Nome_Raz_Soc,
		ENDSHIP.Rua,
		ENDSHIP.Numero,
		ENDSHIP.Compl_End,
		ENDSHIP.Cidade,
		ENDSHIP.UF,
		ENDSHIP.Pais,
		--FTA.vlr_org_HEA,
		--FTC.vlr_org_HEA,
		MAS.Peso_Bruto_MEA,
		HOU.Qtd_Tot_Vol_HEA	,
		hou.Tp_frete_HEA

GO
