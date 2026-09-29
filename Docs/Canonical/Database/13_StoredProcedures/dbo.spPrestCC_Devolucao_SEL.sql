SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spPrestCC_Devolucao_SEL]--[dbo].[spPrestCC] 'IMUPL201502002BR', '19-03-2015'

		@Processo varchar(16),
		@DT_PAR  CHAR(10),
		@Fatcod varchar(17)

as
SET NOCOUNT ON

	Declare @TempTaxas Table
	(
		APELIDO			varchar(100),
		nome_tp_tx		varchar(50),
		DC				varchar(1),
		Vlr_org			decimal(10,2),
		Vlr_Pg			decimal(10,2),
		Cd_tp_moeda		varchar(3),
		Paridade		float,
		cd_tp_tx		varchar(3),
		DebitoCC		varchar(3),
		Processo		varchar(17),
		Ref_ctb_tx		varchar(3),
		NF				varchar(12),
		Site			varchar(1),
		Repasse_TX		varchar(1),
		Emissao			Datetime
	)
	
	BEGIN
		Insert @TempTaxas
		-- CtaCte A Crédito Contra o Consignee com ADT
			select
				APELIDO,TT.nome_tp_tx,CTA.DC_HIA DC,CTA.Vlr_Org_HIA Vlr_Org,CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
				CTA.cd_tp_moeda cd_tp_moeda,
				
				(Case When CTA.Num_NF_HIA is not NULL and CTA.Ref_Acesso_NF_HIA <> 'P' Then 
							FARG.Paridade
				Else					
					(case when LEFT(CTA.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'EXM')
						else 
					(case when LEFT(CTA.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'EXA')
						else 
					(case when LEFT(CTA.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'IMM')
						else 
					(case when LEFT(CTA.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'IMA')					
						else
							dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') 
					end)end)end)end)end)	Paridade,
				
				
				CTA.CD_TP_TX,Null DebitoCC,CTA.Num_Proc_HIA Processo,Ref_Ctb_Tx,
				isnull(CTA.Num_NF_HIA,'') NF, isnull(CTA.Ref_Acesso_NF_HIA,'') [Site],
				Repasse_TX ,
				isnull(FARG.Dt_Fatura,GETDATE()) Emissao
			from 					
				vwCliente					HOU with (nolock)
				Left Join vwcta_Cte			CtA with (nolock) on HOU.num_proc=CtA.Num_Proc_HIA and HOU.cd_cliente = CTA.Cd_Cred_Dev_HIA and CtA.DC_HIA='C'
				Left Join vwCXAS			CXA with (nolock) on Cta.num_proc_Hia=CXA.num_proc_HIA and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HIA='C'
				Left Join Tipo_Taxa			TT  with (nolock)on CTA.CD_tp_tx = TT.CD_tp_tx 
				Left Join Pessoa			PS with (nolock) on HOU.cd_cliente = PS.cd_pes
				Left Join vwFaturasValidas	FAt with (nolock)on fat.num_proc=CtA.Num_Proc_HIA and FAt.cd_tp_tx = CtA.cd_tp_Tx and fat.dc=CtA.DC_HIA
				Left Join vwFaturasValidasCHB ITT with (nolock) on itt.FatCod <> @Fatcod and itt.Num_Proc=CTA.Num_Proc_HIA and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.DC_HIA
				left join vwFaturasValidasArg FARG With(nolock) on CtA.Num_Proc_HIA= FARG.Num_Proc and CtA.cd_tp_tx = FARG.cd_tp_tx and CtA.DC_HIA = FARG.DC
			where 
				CTA.Num_Proc_HIA=@Processo and TT.Ref_Ctb_Tx = 'ADT' --and CTA.Cd_tp_tx <> 'XCA'
				and Desp_Org_HIA='N' and itt.FatCod is null	and Fat.num_proc is null
				and cxa.Num_Lcto is not null						 
	
	END
	
	update 
		T  
	set 
		T.Paridade=T1.Paridade
	from 
		@TempTaxas as T
	JOIN
		@TempTaxas  as T1
		on T.cd_tp_Moeda = T1.cd_tp_moeda and T1.NF <> ''
		
	select * from @TempTaxas where month(Emissao) = MONTH(getdate())



/* velha
ALTER procedure [dbo].[spPrestCC_Devolucao]--[dbo].[spPrestCC] 'IMUPL201502002BR', '19-03-2015'

		@Processo varchar(16),
		@DT_PAR  CHAR(10)

as
SET NOCOUNT ON

	Declare @TempTaxas Table
	(
		APELIDO			varchar(100),
		nome_tp_tx		varchar(50),
		DC				varchar(1),
		Vlr_org			decimal(10,2),
		Vlr_Pg			decimal(10,2),
		Cd_tp_moeda		varchar(3),
		Paridade		float,
		cd_tp_tx		varchar(3),
		DebitoCC		varchar(3),
		Processo		varchar(17),
		Ref_ctb_tx		varchar(3),
		NF				varchar(12),
		Site			varchar(1),
		Repasse_TX		varchar(1)
	)
	
IF len(@Processo) = 16
	BEGIN
		if left(@Processo,2) = 'EO'
			Begin
				Insert @TempTaxas
				-- CtaCte A Crédito Contra o Consignee com ADT
					select
 						APELIDO, 
						TT.nome_tp_tx,
						CTA.dc_HEO DC, 
						CTA.vlr_org_HEO Vlr_Org, 
						CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
						CTA.cd_tp_moeda cd_tp_moeda,
						(case When
								CTA.Num_NF_HEO is not NULL and CTA.ref_acesso_nf_heO <> 'P'
							Then 
								CTA.Par_NF_HeO 
							else 
								dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
						CTA.CD_TP_TX,
						Null DebitoCC,
						CTA.Num_proc_HEO Processo,
						Ref_Ctb_Tx,
						--
						isnull(CTA.num_nf_heo,'') NF, 
						isnull(CTA.ref_acesso_nf_heo,'') [Site],
						Repasse_TX 
					from 
						House_EXP_OUT HOU
						Left Join cta_cte_hou_EXP_OUT CtA on HOU.num_proc_HEO=CtA.num_proc_HEO and HOU.cd_Export_HEO = CTA.cd_cred_dev_HEO and CtA.dc_HEO='C'
						Left Join vwCXAS CXA on Cta.num_proc_HEO=CXA.num_proc_HIA and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HIA='C'
						Left Join Tipo_Taxa TT  on CTA.CD_tp_tx = TT.CD_tp_tx 
						Left Join Pessoa PS on HOU.cd_Export_HEO = PS.cd_pes
	--					left join item_fat FAT on FAT.Num_Proc = CTA.num_proc_heo and FAT.cd_tp_tx = CTA.cd_tp_tx and FAT.DC = CTA.dc_heo and FAT.FatCod in (select fatcod from fatura where fatcod=fat.fatcod and fatstatus='1')
						Left Join vwFaturasValidas FAt on fat.num_proc=CtA.num_proc_heo and CtA.cd_tp_Tx=FAt.cd_tp_tx and CtA.dc_heo=fat.dc    
					where 
						CTA.num_proc_HEO=@Processo
						and TT.Ref_Ctb_Tx = 'ADT'
						and desp_org_heo='N'
						and Fat.num_proc is null			 
			
			End
	
	else if left(@Processo,2) = 'IO'
			Begin
				Insert @TempTaxas
				-- CtaCte A Crédito Contra o Consignee
					select
 						APELIDO, 
						TT.nome_tp_tx,
						CTA.dc_HIO DC, 
						CTA.vlr_org_HIO Vlr_Org, 
						CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
						CTA.cd_tp_moeda cd_tp_moeda,
	--					ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
						(case When
								CTA.Num_NF_HIO is not NULL and CTA.ref_acesso_nf_HIO <> 'P'
							Then 
								CTA.Par_NF_HIO 
							else 
								dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
						CTA.CD_TP_TX,
						Null DebitoCC,
						CTA.Num_proc_HIO Processo,
						Ref_Ctb_Tx,
						isnull(CTA.num_nf_hio,'') NF,
						isnull(CTA.ref_acesso_nf_hio,'') [Site],
						Repasse_TX 
					from 
						House_imp_OUT HOU
						Left Join cta_cte_hou_imp_OUT CtA on HOU.num_proc_HIO=CtA.num_proc_HIO and HOU.cd_consig_HIO = CTA.cd_cred_dev_HIO and CtA.dc_HIO='C'
						Left Join vwCXAS CXA on Cta.num_proc_HIO=CXA.num_proc_HIA and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HIA='C'
						Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx 
						Left Join Pessoa PS on HOU.cd_consig_HIO = PS.cd_pes	
						Left Join vwFaturasValidas FAt on Fat.num_proc=cta.num_proc_hio and cta.cd_tp_Tx=FAt.cd_tp_tx and cta.dc_hio=fat.dc 
					where 
						CTA.num_proc_HIO=@Processo and TT.Ref_Ctb_Tx = 'ADT' --and CTA.Cd_tp_tx <> 'XCA'
						and desp_org_hio='N'
						and Fat.num_proc is null							
			End

	else if left(@Processo,2) = 'IA'
			Begin
				Insert @TempTaxas
				-- CtaCte A Crédito Contra o Consignee
					select
 						APELIDO, 
						TT.nome_tp_tx,
						CTA.dc_hia DC, 
						CTA.vlr_org_hia Vlr_Org, 
						CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
						CTA.cd_tp_moeda cd_tp_moeda,
						(case When
								CTA.Num_NF_HIA is not NULL and CTA.ref_acesso_nf_HIA <> 'P'
							Then 
								CTA.Par_NF_HIA 
							else 
								dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'IMA') end ) Paridade,
						CTA.CD_TP_TX,
						Null DebitoCC,
						CTA.Num_proc_hia Processo,
						Ref_Ctb_Tx,
						isnull(CTA.num_nf_hia,'') NF, 
						isnull(CTA.ref_acesso_nf_hia,'') [Site],
						Repasse_TX 
					from 
						House_imp_aer HOU with(nolock)
						Left Join cta_cte_hou_imp_aer CtA on HOU.num_proc_hia=CtA.num_proc_hia and HOU.cd_consig_hia = CTA.cd_cred_dev_hia and CtA.dc_hia='C'
						Left Join vwCXAS CXA on Cta.num_proc_hia=CXA.num_proc_hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='C'
						Left Join Tipo_Taxa TT with(nolock) on CTA.CD_tp_tx = TT.CD_tp_tx 
						Left Join Pessoa PS with(nolock) on HOU.cd_consig_hia = PS.cd_pes
						Left Join vwFaturasValidas FAt on fat.num_proc=cta.num_proc_hia and cta.cd_tp_Tx=FAt.cd_tp_tx and cta.dc_hia=fat.dc 
					where 
						CTA.num_proc_hia=@Processo 
						and TT.Ref_Ctb_Tx = 'ADT'
						and desp_org_hia='N'
						and Fat.num_proc is null			
			End

	else if left(@Processo,2) = 'EA'
			Begin
				Insert @TempTaxas
				-- CtaCte A Crédito Contra o EXPOrTADOR
					select
						APELIDO, 
						TT.nome_tp_tx,
						CTA.dc_HEA DC, 
						CTA.vlr_org_HEA Vlr_Org, 
						CXA.Vlr_Pgto_Rcto_HIa Vlr_PG,
						CTA.cd_tp_moeda cd_tp_moeda,
						(case When
								CTA.Num_NF_HEA is not NULL and CTA.ref_acesso_nf_HEA <> 'P'
							Then 
								CTA.Par_NF_HEA 
							else 
								dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'EXA') end ) Paridade,
						CTA.CD_TP_TX,
						Null DebitoCC,
						CTA.Num_proc_HEA Processo,
						Ref_Ctb_Tx,
						isnull(CTA.num_nf_hea,'') NF, 
						isnull(CTA.ref_acesso_nf_hea,'') [Site],
						Repasse_TX 
					from 
						House_EXP_aer HOU
						Left Join cta_cte_hou_EXP_aer CtA on HOU.num_proc_HEA=CtA.num_proc_HEA and HOU.cd_EXPORT_HEA = CTA.cd_cred_dev_HEA and CtA.dc_HEA='C'
						Left Join vwCXAS CXA on Cta.num_proc_HEA=CXA.num_proc_HIA and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HIA='C'
						Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx 
						Left Join Pessoa PS on HOU.cd_export_hea = PS.cd_pes
						Left Join vwFaturasValidas FAt on fat.num_proc=cta.num_proc_hea and cta.cd_tp_Tx=FAt.cd_tp_tx and cta.dc_hea=fat.dc 
					where 
						CTA.num_proc_HEA=@Processo  
						and isnull(TT.Ref_Ctb_Tx,'') = 'ADT' 
						and desp_dst_hea='N'
						and Fat.num_proc is null				 		 
			End

	else If left(@Processo,2) = 'IM'
			Begin
				Insert @TempTaxas
				-- CtaCte A Crédito Contra o Consignee
					select
						APELIDO, 
						TT.nome_tp_tx,
						CTA.dc_HIM DC, 
						CTA.vlr_org_HIM Vlr_Org, 
						CXA.Vlr_Pgto_Rcto_HIA Vlr_PG,
	--					'REL' cd_tp_moeda,alterado pq no fim ele estava pegando a paridade em real, 
						--mas tem q pegar a paridade da nf					
						CTA.cd_tp_moeda cd_tp_moeda,
	--					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMM'),1) Paridade,
						(case When
								CTA.Num_NF_HIM is not NULL and CTA.ref_acesso_nf_HIM <> 'P'
							Then 
								CTA.Par_NF_HIM 
							else 
								dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'IMM') end ) Paridade,
						CTA.CD_TP_TX CD_TP_TX, 
						Null DebitoCC,
						CTA.Num_proc_HIM Processo,
						Ref_Ctb_Tx,
						isnull(CTA.num_nf_him,'') NF, 
						isnull(CTA.ref_acesso_nf_him,'') [Site],
						Repasse_TX 
					from 
						House_imp_MAR HOU With(nolock)
						Left Join cta_cte_hou_imp_MAR CtA on HOU.num_proc_HIM=CtA.num_proc_HIM and HOU.cd_consig_HIM = CTA.cd_cred_dev_HIM and CtA.dc_HIM='C'
						Left Join vwCXAS CXA on Cta.num_proc_HIM=CXA.num_proc_HIA and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HIA='C'
						Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx 
						Left Join Pessoa PS on HOU.cd_consig_him = PS.cd_pes
						Left Join vwFaturasValidas FAt on fat.num_proc=cta.num_proc_him and cta.cd_tp_Tx=FAt.cd_tp_tx and cta.dc_him=fat.dc 
					where 
						CTA.num_proc_HIM=@Processo  
						and TT.Ref_Ctb_Tx  = 'ADT'
						and desp_org_him='N'
						and Fat.num_proc is null
			End

	else
		if left(@Processo,2) = 'EM'
			Begin
				Insert @TempTaxas
				-- CtaCte A Crédito Contra o Consignee
					select
						APELIDO, 
						TT.nome_tp_tx,
						CTA.dc_HEM DC, 
						CTA.vlr_org_HEM Vlr_Org, 
						CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
						CTA.cd_tp_moeda cd_tp_moeda,
	--					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXM'),1) Paridade,
						(case When
								CTA.Num_NF_HEM is not NULL and CTA.ref_acesso_nf_HEM <> 'P'
							Then 
								CTA.Par_NF_HEM 
							else 
								dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'EXM') end ) Paridade,
						CTA.CD_TP_TX,
						Null DebitoCC,
						CTA.Num_proc_HEM Processo,
						Ref_Ctb_Tx,
						isnull(CTA.num_nf_hem,'') NF, 
						isnull(CTA.ref_acesso_nf_hem,'') [Site],
						Repasse_TX 
					from 
						House_EXP_MAR HOU
						Left Join cta_cte_hou_EXP_MAR CtA on HOU.num_proc_HEM=CtA.num_proc_HEM and HOU.cd_EXPORT_HEM = CTA.cd_cred_dev_HEM and CtA.dc_HEM='C'
						Left Join vwCXAS CXA on Cta.num_proc_HEM=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='C'
						Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx 
						Left Join Pessoa PS on HOU.cd_export_hem = PS.cd_pes
						Left Join vwFaturasValidas FAt on fat.num_proc=cta.num_proc_hem and cta.cd_tp_Tx=FAt.cd_tp_tx and cta.dc_hem=fat.dc 
					where 
						CTA.num_proc_HEM=@Processo 
						and TT.Ref_Ctb_Tx = 'ADT' 
						and desp_dst_hem='N'
						and Fat.num_proc is null
					 
			End
	END

----------Master
ELSE
	BEGIN
		if left(@Processo,2) = 'EM'
			Begin
				Insert @TempTaxas
				-- CtaCte A Crédito Contra o Consignee
					select
						APELIDO, 
						TT.nome_tp_tx,
						CTA.dc_MEM DC, 
						CTA.vlr_org_MEM Vlr_Org, 
						CXA.Vlr_Pgto_Rcto_HIA Vlr_PG,
						CTA.cd_tp_moeda cd_tp_moeda,
	--					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXM'),1) Paridade,
						(case When 
							CTA.Num_NF_MEM is not NULL and CTA.ref_acesso_nf_mem <> 'P'
						Then 
							CTA.Par_NF_MEM 
						else 
							dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'EXM') end ) Paridade, 
						CTA.CD_TP_TX,
						Null DebitoCC,
						CTA.Num_proc_MEM Processo,
						Ref_Ctb_Tx,
						isnull(CTA.num_nf_mem,'') NF, 
						isnull(CTA.ref_acesso_nf_mem,'') [Site],
						Repasse_TX 
					from 
						MASter_EXP_MAR MAS
						Left Join cta_cte_mas_EXP_MAR CtA on MAS.num_proc_MEM=CtA.num_proc_MEM and MAS.cd_EXPORT_MEM = CTA.cd_cred_dev_MEM and CtA.dc_MEM='C'
						Left Join vwCXAS CXA on Cta.num_proc_MEM=CXA.num_proc_HIA and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HIA='C'
						Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
						Left Join Pessoa PS on MAS.cd_export_MEM = PS.cd_pes
						Left Join vwFaturasValidas FAt on fat.num_proc=CtA.num_proc_mem and CtA.cd_tp_Tx=FAt.cd_tp_tx and CtA.dc_mem=fat.dc    
					where 
						CTA.num_proc_MEM=@Processo  
						and TT.Ref_Ctb_Tx = 'ADT'
						and desp_dst_mem='N'
						and Fat.num_proc is null					 
			End
	Else 
		if left(@Processo,2) = 'EA'
			Begin
				Insert @TempTaxas
				-- CtaCte A Crédito Contra o Consignee
					select
						APELIDO, 
						TT.nome_tp_tx,
						CTA.dc_mea DC, 
						CTA.vlr_org_mea Vlr_Org, 
						CXA.Vlr_Pgto_Rcto_hia Vlr_PG,
						CTA.cd_tp_moeda cd_tp_moeda,
	--					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXA'),1) Paridade,
						(case When 
							CTA.Num_NF_MEA is not NULL and CTA.ref_acesso_nf_mea <> 'P'
						Then 
							CTA.Par_NF_MEA 
						else 
							dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'EXA') end ) Paridade,
						CTA.CD_TP_TX,
						Null DebitoCC,
						CTA.Num_proc_mea Processo,
						Ref_Ctb_Tx,
						isnull(CTA.num_nf_mea,'') NF, 
						isnull(CTA.ref_acesso_nf_mea,'') [Site],
						Repasse_TX 
					from 
						MASter_EXP_aer MAS
						Left Join cta_cte_mas_EXP_aer CtA on MAS.num_proc_mea=CtA.num_proc_mea and MAS.cd_EXPORT_mea = CTA.cd_cred_dev_mea and CtA.dc_mea='C'
						Left Join vwCXAS CXA on Cta.num_proc_mea=CXA.num_proc_hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='C'
						Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx 
						Left Join Pessoa PS on MAS.cd_export_mea = PS.cd_pes
						Left Join vwFaturasValidas FAt on fat.num_proc=CtA.num_proc_mea and CtA.cd_tp_Tx=FAt.cd_tp_tx and CtA.dc_mea=fat.dc    												
					where 
						CTA.num_proc_mea=@Processo  
						and TT.Ref_Ctb_Tx = 'ADT'
						and desp_dst_mea='N'
						and Fat.num_proc is null			 
			End
			
	else if left(@Processo,2) = 'IA'
			Begin
				Insert @TempTaxas
				-- CtaCte A Crédito Contra o Consignee
					select
						APELIDO, 
						TT.nome_tp_tx,
						CTA.dc_mia DC, 
						CTA.vlr_org_mia Vlr_Org, 
						CXA.Vlr_Pgto_Rcto_hia Vlr_PG,
						CTA.cd_tp_moeda cd_tp_moeda,
	--					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMA'),1) Paridade,
						(case When 
							CTA.Num_NF_MIA is not NULL and CTA.ref_acesso_nf_mia <> 'P'
						Then 
							CTA.Par_NF_MIA 
						else 
							dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'IMA') end ) Paridade,
						CTA.CD_TP_TX,
						Null DebitoCC,
						CTA.Num_proc_mia Processo,
						Ref_Ctb_Tx,
						isnull(CTA.num_nf_mia,'') NF,
						isnull(CTA.ref_acesso_nf_mia,'') [Site],
						Repasse_TX 
					from 
						MASter_imp_aer MAS
						Left Join cta_cte_mas_imp_aer CtA on MAS.num_proc_mia=CtA.num_proc_mia and MAS.cd_consig_mia = CTA.cd_cred_dev_mia and CtA.dc_mia='C'
						Left Join vwCXAS CXA on Cta.num_proc_mia=CXA.num_proc_hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='C'
						Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
						Left Join Pessoa PS on MAS.cd_consig_mia = PS.cd_pes
						Left Join vwFaturasValidas FAt on fat.num_proc=CtA.num_proc_mia and CtA.cd_tp_Tx=FAt.cd_tp_tx and CtA.dc_mia=fat.dc    
					where 
						CTA.num_proc_mia=@Processo  
						and TT.Ref_Ctb_Tx = 'ADT'
						and desp_org_mia='N'
						and Fat.num_proc is null			 
			End
			
	Else if left(@Processo,2) = 'IM'
			Begin
				Insert @TempTaxas
				-- CtaCte A Crédito Contra o Consignee
					select
						APELIDO, 
						TT.nome_tp_tx,
						CTA.dc_Mim DC, 
						CTA.vlr_org_Mim Vlr_Org, 
						CXA.Vlr_Pgto_Rcto_hia Vlr_PG,
						CTA.cd_tp_moeda cd_tp_moeda,
	--					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMM'),1) Paridade,
						(case When 
							CTA.Num_NF_MIM is not NULL and CTA.ref_acesso_nf_mim <> 'P'
						Then 
							CTA.Par_NF_MIM 
						else 
							dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'IMM') end ) Paridade,
						CTA.CD_TP_TX,
						Null DebitoCC,
						CTA.Num_proc_Mim Processo,
						Ref_Ctb_Tx,
						isnull(CTA.num_nf_mim,'') NF, 
						isnull(CTA.ref_acesso_nf_mim,'') [Site],
						Repasse_TX 
					from 
						MASter_imp_mar MAS
						Left Join cta_cte_mas_imp_mar CtA on MAS.num_proc_Mim=CtA.num_proc_Mim and MAS.cd_consig_Mim = CTA.cd_cred_dev_Mim and CtA.dc_Mim='C'
						Left Join vwCXAS CXA on Cta.num_proc_Mim=CXA.num_proc_hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='C'
						Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
						Left Join Pessoa PS on MAS.cd_consig_Mim = PS.cd_pes
						Left Join vwFaturasValidas FAt on fat.num_proc=CtA.num_proc_mim and CtA.cd_tp_Tx=FAt.cd_tp_tx and CtA.dc_mim=fat.dc    
					where 
						CTA.num_proc_Mim=@Processo 
						and TT.Ref_Ctb_Tx <> 'ADT'
						and desp_org_mim='N'
						and Fat.num_proc is null
			End

	END

	update 
		T  
	set 
		T.Paridade=T1.Paridade
	from 
		@TempTaxas as T
	JOIN
		@TempTaxas  as T1
		on T.cd_tp_Moeda = T1.cd_tp_moeda and T1.NF <> ''
	--select Moeda,Paridade from @TempTaxas as T2 where NF is not NULL
	--where NF is NULL
		
	select * from @TempTaxas

*/




































GO
