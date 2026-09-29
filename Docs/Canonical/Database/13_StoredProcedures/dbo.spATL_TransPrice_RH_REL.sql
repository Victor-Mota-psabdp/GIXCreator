SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------select * from TransPrice_RH_2012 where job = 'IMCSR201109210BR'
----sp_help TransPrice_RH_2012
--select * from pessoa where cd_pes = 'P000000450'

CREATE Procedure [dbo].[spATL_TransPrice_RH_REL]--'Grupo Solutia','2012-06-01','2012-07-10'
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime

as

	Declare @cd_pes_grupo varchar(20)	
	
	if upper(@Grupo) = 'GRUPO DOW'		
			set @grupo = 'CSR'
	else if
		upper(@Grupo) = 'GRUPO ROHM & HAAS'
			set @grupo = 'CSR'
	else if 
		upper(@Grupo) = 'GRUPO STYRON'
			set @grupo = 'CSR'			
	Else
		Begin
			Set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)
			set @grupo = (select grupo from grupo where cd_pes_grupo = @cd_pes_grupo)
		End

	Select distinct
		Job											[Job],
		''											[cd_rfgl__41],
		Right(Left(Planta, 5), 2)					[cd_rf__41],
		Cia											[no_companhia__41],
		[nu_purchase__35]							[nu_purchase__35],
		GMID										[cd_gmid__52],
		Produto_Descr								[dc_produto__52],
		Produto_Descr								[dc_nome_cml__52],
		Vendor										[cd_dow__6],
		Seller										[dc_fornecedor__6],	
		[SumOfvl_quantidade__36]					[SumOfvl_quantidade__36],		
		'KG'										[dc_unidade__34],
		''											[G1],
		''											[G2],
		''											[G3],
		''											[G4],
		T.DI										[nu_di__35],
		''											[DI2],
		ATD											[dt_embarque__35],
		Desemb										[dt_desemb__35],
		Modal										[dc_via_transporte__47],
		Navio										[no_navio__35],
		Origem										[no_porto_origem__8],
		(case cd_tp_carga 
				when 'T' then 'Truck'
				when 'R' then 'Rails'
				else cd_tp_carga end)				[no_modal_transp__48],
		Hist										[dc_obs_processo__35],
		'TAX'										[no_local_arquivo__44],
		'TAX'										[nu_caixa_arquivo__35],		
		[nu_ordem__35]								[nu_ordem__35],
		''											[GI],
		
	--			(cFOB - cFRT - cSEG - cACR - RsTemp!fvlr_II) / fltParidade
		(([vl_fob_me__36] - fVLR_II) / T.Paridade)	[vl_fob_me__36],
--
--	--			cFRT / fltParidade
		([vl_frete_me__36] /	T.Paridade)			[vl_frete_me__36],
--
--	--			(cFOB - cSEG - cACR - RsTemp!fvlr_II) / fltParidade	
		(([vl_cfr_me__36] - fVLR_II) / T.Paridade)	[vl_cfr_me__36],

		fVLR_AFR									[vl_afrmm__36],
		fVLR_THC									[vl_capatazia__36],
		0											[vl_thc2__36],
		fVLR_TUP									[vl_tup__36],
		fVLR_LII									[vl_li__36],
		0											[vl_outras__36],
		0											[vl_cpmf__36],
		T.ALIQ_II									[vl_aliq_ii__36],
		fVLR_II										[vl_ii__36],		
		T.ALIQ_IPI									[vl_aliq_ipi__36],
		fVLR_IPI									[vl_ipi__36],   
		[vl_icms_base__36]							[vl_icms_base__36],
		T.ALIQ_ICMS									[vl_aliq_icms__36],
		fVLR_ICMS									[vl_icms__36],
		fVLR_TRA									[vl_tra_1__36],
		0											[vl_tra_2__36],
		fVLR_SIS									[vl_siscomex__36],
		(fVLR_DEM + fVLR_WHS)						[vl_dpc_acessorias__36],
		fVLR_BRO									[vl_dpc_servico__36],
		T.Paridade									[vl_taxa_moeda__35],
		'BDP SOUTH AMERICA LTDA'					[no_despachante__46],
		Payment										[cd_dow__30],
		''											[dc_cond_pagto__30] ,   
--		dbo.fbusca_DATA_po_modal(JOB,'10')			[dc_dt_nf__35],
		isnull(NF.Data_PO_him,isnull(NFA.Data_PO_hia,NFO.Data_PO_hio)) [dc_dt_nf__35],
		'DD'										[cd_tipo_ordem_imp__35],				        
		[dc_nu_fatura__35]							[dc_nu_fatura__35],	
		[dc_nu_nf__35]								[dc_nu_nf__35],
		Right(Planta, 2)							[cd_dow__29],
		''											[dc_planta__29],
		fVLR_PIS									[vl_PIS],
		fVLR_CFN									[vl_Cofins],
		Nome_Local									[Destino],	
		[NFs]										[Qty.NF],
		Consolidada									[Ref. Consol.],
		fVLR_SDA									[vl_SDA__36],
		Cia_CNPJ									[CNPJ do importador],
		NFE											[Nota fiscal de entrada (NFE) Nº],
		NFE_Date									[Data da NFE],
		CFOP										[CFOP],
		Incoterm									[Incoterm],
		NCM											[NCM],
		Seguro										[Vlr do Seguro],
		Acrescimos									[Valor das despesas aduaneiras que integram a base de cálculo do ICMS],
		Di_Date										[Dt DI],
		LI_PERIODICIDADE							[LI_PERIODICIDADE]
		
	FROM
		TransPrice_RH_2012 T
		Left Outer Join PO_HIM NF on T.JOB = NF.Num_Proc_Him and NF.ID_DC = 10
		Left Outer Join PO_HIA NFA on T.JOB = NFA.Num_Proc_Hia and NFA.ID_DC = 10
		Left Outer Join PO_HIO NFO on T.JOB = NFO.Num_Proc_Hio and NFO.ID_DC = 10
	Where
		Desemb between @DtInicial and @DtFinal 	
		and (
			(@grupo  = 'CSR' and (right(left(Job,5),3) in ('STB','CSR','ROB')))
			OR
			(@grupo  <> 'CSR' and (right(left(Job,5),3) in (@grupo)))
		)


GO
