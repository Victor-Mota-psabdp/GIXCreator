SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--incluido a taxa IRR - Imposto Retido na Fonte em todos os modais - 25-05
--incluido o DBO.VALOR(CTA.vlr_org_Heo,CTA.DC_Heo) Vlr_Org, - para todos os modais de house 25-05
--incluido um left join com item fat pra nao trazer os casos q ja possuem fatura criada pelo FF - 15-02-2013
/*incluido os itens: NF, SITE e Repasse TX pra regra de:
Verifica se há alguma taxa com Repasse_NF como N e nao tem numero de NF amarrado 
Carrega_bdp - dia 25/7/13 - Cadu*/ 
--incluido a paridade,23/09/2013 - cadu
--incluido o fat no --Cta_Cte à D que não está no Custo também - 23/09/2013 cadu
--30-09-13 - alterado o verParidade do :CtaCte A Crédito Contra o Consignee dos modais de Exportação Maritma(EM e IA)estavam como official
--[spPrestCC] 'EMFMC201309001BR','27-10-2013'
--
--select * from cta_cte_hou_exp_mar where num_proc_hem = 'EMFMC201309001BR' and cd_tp_tx = 'AWA'
--2,37

CREATE procedure [dbo].[spPrestCC_TESTES]--[dbo].[spPrestCC] 'IMFMC201306066BR', '27-09-2013'

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

	Declare @Fatura Table
		(
			Num_proc	varchar(16),
			Cd_tp_Tx	Varchar(3),
			DC			Varchar(1)			
		)
	
	Begin 		
		Insert @Fatura	
			Select
				(case when len(i.fatcod)= 15 
					then left(i.fatcod,14) else	left(i.fatcod,16) end),	
--				left(i.fatcod,16),
				cd_tp_Tx,dc 
			from item_fat I
				Join Fatura F on F.fatcod=i.fatcod 
			where
				left(f.fatcod,16)= @Processo and fatstatus =1
	End	

IF len(@Processo) = 16
	BEGIN
		if left(@Processo,2) = 'EO'
			Begin
			Insert @TempTaxas
			-- CtaCte A Crédito Contra o Consignee
				select
 					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_HEO DC, 
					CTA.vlr_org_HEO Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_Heo Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
--					ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
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
					Left Join caixa_hou_EXP_OUT CXA on Cta.num_proc_HEO=CXA.num_proc_HEO and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HEO='C'
					Left Join Tipo_Taxa TT  on CTA.CD_tp_tx = TT.CD_tp_tx 
					Left Join Pessoa PS on HOU.cd_Export_HEO = PS.cd_pes
--					left join item_fat FAT on FAT.Num_Proc = CTA.num_proc_heo and FAT.cd_tp_tx = CTA.cd_tp_tx and FAT.DC = CTA.dc_heo and FAT.FatCod in (select fatcod from fatura where fatcod=fat.fatcod and fatstatus='1')
					Left Join @Fatura FAt on fat.num_proc=CtA.num_proc_heo and CtA.cd_tp_Tx=FAt.cd_tp_tx and CtA.dc_heo=fat.dc    
				where 
					CTA.num_proc_HEO=@Processo and TT.Ref_Ctb_Tx <> 'PTC' --and CTA.Cd_tp_tx <> 'XCA'
					and desp_org_heo='N'
--					and FAT.fatcod is null
					and Fat.num_proc is null

			Union
			--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
				select
 					APELIDO, 
					TT.nome_tp_tx,
					'D' DC, 
					CC.Vlr_Item_Custo Vlr_Org, 
					CC.vlr_Item_Custo Vlr_PG,
					'REL' cd_tp_moeda,
					ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,
					CC.num_proc Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_heo,'') NF, 
					isnull(CTA.ref_acesso_nf_heo,'') [Site],
					Repasse_TX 
				from 
					custo_cliente cc
					Left Join caixa_hou_EXP_OUT		CXA	on CC.num_proc=CXA.num_proc_HEO and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HEO='D'
					Left Join cta_cte_hou_EXP_OUT	CtA on CC.num_proc=CtA.num_proc_HEO and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_HEO='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_EXP_OUT			HOU on CC.Num_proc = HOU.Num_proc_HEO
					Left Join Pessoa				PS	on HOU.cd_Export_HEO = PS.CD_pes
				where 
					num_proc=@Processo and num_lcto is null and cta.num_proc_HEO is null and (Prestacao = 'S' or Prestacao is null)

			Union
				--Cta_Cte à D que está no Custo também
				select
 					PS.APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_heo DC, 
					CTA.vlr_org_heo Vlr_Org, 
					CXA.vlr_pgto_rcto_heo Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,
					CC.num_proc Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_heo,'') NF, 
					isnull(CTA.ref_acesso_nf_heo,'') [Site],
					Repasse_TX 
				from 
					custo_cliente cc
					Left Join cta_cte_hou_exp_OUT	CtA on CC.num_proc=CtA.num_proc_heo and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_heo='D'
					Left Join caixa_hou_exp_OUT		CXA on Cta.num_proc_heo=CXA.num_proc_heo and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_heo='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_exp_OUT			HOU on CC.Num_proc = HOU.Num_proc_heo
					Join Pessoa				PS	on HOU.cd_export_heo = PS.CD_pes
				where 
					CXA.num_proc_heo=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'

			Union			
				--Cta_Cte à D que não está no Custo também
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_HEO DC,
					DBO.VALOR(CTA.vlr_org_Heo,CTA.DC_Heo) Vlr_Org,
					--CTA.vlr_org_HEO Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_HEO Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,
					CTA.Num_proc_Heo Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_heo,'') NF, 
					isnull(CTA.ref_acesso_nf_heo,'') [Site],
					Repasse_TX 
				from 
					House_exp_out HOU
					Left Join cta_cte_hou_exp_out CtA on HOU.num_proc_HEO=CtA.num_proc_HEO and HOU.cd_export_HEO = CTA.cd_cred_dev_HEO and CtA.dc_HEO='D'
					Left Join caixa_hou_exp_out CXA on Cta.num_proc_Heo=CXA.num_proc_Heo and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Heo='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.cd_export_heo = PS.cd_pes
					Left Join @Fatura FAt on fat.num_proc=CtA.num_proc_heo and CtA.cd_tp_Tx=FAt.cd_tp_tx and CtA.dc_heo=fat.dc    
				where 
					CTA.num_proc_heo=@Processo and CTA.CD_TP_TX in ('RIS','IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and Fat.num_proc is null
			Union
			--Cta_Cte D que começa com X
				SELECT
					APELIDO,
					TT.NOME_TP_TX,
					CXA.dc_HEO DC, 
					CXA.vlr_pgto_rcto_HEO Vlr_Org, 
					CXA.vlr_pgto_rcto_HEO Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,
					CXA.CD_TP_TX CD_TP_TX,
					NULL DebitoCC,
					CXA.num_proc_HEO Processo,
					Ref_Ctb_Tx,
					'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_HOU_EXP_OUT CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_HEO=CC.NUM_PROC
					JOIN HOUSE_EXP_OUT HOU ON HOU.NUM_PROC_HEO=CXA.NUM_PROC_HEO
					JOIN PESSOA PP ON PP.CD_PES=CD_Export_HEO
				WHERE
					CXA.num_proc_HEO=@Processo AND CXA.DC_HEO='D' AND CC.NUM_PROC IS NULL 
					AND  LEFT(CXA.CD_TP_tX,1)='X'  and TT.Ref_Ctb_Tx <> 'PTC' --and CXA.CD_TP_TX NOT IN ('XBA') 
			End

	else
		if left(@Processo,2) = 'IO'
			Begin
			Insert @TempTaxas
			-- CtaCte A Crédito Contra o Consignee
				select
 					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_HIO DC, 
					CTA.vlr_org_HIO Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_Hio Vlr_PG,
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
					Left Join caixa_hou_imp_OUT CXA on Cta.num_proc_HIO=CXA.num_proc_HIO and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HIO='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx 
					Left Join Pessoa PS on HOU.cd_consig_HIO = PS.cd_pes
--					left join item_fat FAT on FAT.Num_Proc = CTA.num_proc_hio and FAT.cd_tp_tx = CTA.cd_tp_tx and FAT.DC = CTA.dc_hio and FAT.FatCod in (select fatcod from fatura where fatcod=fat.fatcod and fatstatus='1')
					Left Join @Fatura FAt on Fat.num_proc=cta.num_proc_hio and cta.cd_tp_Tx=FAt.cd_tp_tx and cta.dc_hio=fat.dc 
				where 
					CTA.num_proc_HIO=@Processo and TT.Ref_Ctb_Tx <> 'PTC' --and CTA.Cd_tp_tx <> 'XCA'
					and desp_org_hio='N'
--					and FAT.fatcod is null
					and Fat.num_proc is null

			Union
			--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
				select
 					APELIDO, 
					TT.nome_tp_tx,
					'D' DC, 
					CC.Vlr_Item_Custo Vlr_Org, 
					CC.vlr_Item_Custo Vlr_PG,
					'REL' cd_tp_moeda,
					ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,
					CC.num_proc Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_hio,'') NF,
					isnull(CTA.ref_acesso_nf_hio,'') [Site],
					Repasse_TX  
				from 
					custo_cliente cc
					Left Join caixa_hou_imp_OUT		CXA	on CC.num_proc=CXA.num_proc_HIO and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HIO='D'
					Left Join cta_cte_hou_imp_OUT	CtA on CC.num_proc=CtA.num_proc_HIO and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_HIO='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_imp_OUT			HOU on CC.Num_proc = HOU.Num_proc_HIO
					Left Join Pessoa				PS	on HOU.cd_consig_HIO = PS.CD_pes
				where 
					num_proc=@Processo and num_lcto is null and cta.num_proc_HIO is null and (Prestacao = 'S' or Prestacao is null)

			Union 
			--Cta_Cte à D que está no Custo também
				select
 					PS.APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_HIO DC, 
					CTA.vlr_org_HIO Vlr_Org, 
					CXA.vlr_pgto_rcto_HIO Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,
					CC.num_proc Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_hio,'') NF,
					isnull(CTA.ref_acesso_nf_hio,'') [Site],
					Repasse_TX 
				from 
					custo_cliente cc
					Left Join cta_cte_hou_imp_OUT	CtA on CC.num_proc=CtA.num_proc_HIO and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_HIO='D'
					Left Join caixa_hou_imp_OUT		CXA on Cta.num_proc_HIO=CXA.num_proc_HIO and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HIO='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_imp_OUT			HOU on CC.Num_proc = HOU.Num_proc_HIO
					Join Pessoa				PS	on HOU.cd_consig_HIO = PS.CD_pes
				where 
					CXA.num_proc_HIO=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'

			union
			--Cta_Cte à D que não está no Custo também
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_HIO DC,
					DBO.VALOR(CTA.vlr_org_Hio,CTA.DC_Hio) Vlr_Org, 
					--CTA.vlr_org_HIO Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_HIO Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,
					CTA.Num_proc_HIO Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_hio,'') NF,
					isnull(CTA.ref_acesso_nf_hio,'') [Site],
					Repasse_TX 
				from 
					House_imp_OUT HOU
					Left Join cta_cte_hou_imp_OUT CtA on HOU.num_proc_HIO=CtA.num_proc_HIO and HOU.cd_consig_HIO = CTA.cd_cred_dev_HIO and CtA.dc_HIO='D'
					Left Join caixa_hou_imp_OUT CXA on Cta.num_proc_HIO=CXA.num_proc_HIO and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HIO='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.cd_consig_HIO = PS.cd_pes
					Left Join @Fatura FAt on Fat.num_proc=cta.num_proc_hio and cta.cd_tp_Tx=FAt.cd_tp_tx and cta.dc_hio=fat.dc 
				where 
					CTA.num_proc_HIO=@Processo and CTA.CD_TP_TX in ('RIS','IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and Fat.num_proc is null
			union
			--Cta_Cte D que começa com X
				SELECT
					APELIDO,
					TT.NOME_TP_TX,
					CXA.dc_HIO DC, 
					CXA.vlr_pgto_rcto_HIO Vlr_Org, 
					CXA.vlr_pgto_rcto_HIO Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,
					CXA.CD_TP_TX CD_TP_TX,
					NULL DebitoCC,
					CXA.num_proc_HIO Processo,
					Ref_Ctb_Tx,
					'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_HOU_IMP_OUT CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX 
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_HIO=CC.NUM_PROC
					JOIN HOUSE_IMP_OUT HOU ON HOU.NUM_PROC_HIO=CXA.NUM_PROC_HIO
					JOIN PESSOA PP ON PP.CD_PES=CD_CONSIG_HIO
				WHERE
					CXA.num_proc_HIO=@Processo AND CXA.DC_HIO='D' AND CC.NUM_PROC IS NULL 
					AND LEFT(CXA.CD_TP_tX,1)='X' and TT.Ref_Ctb_Tx <> 'PTC' --and CXA.CD_TP_TX NOT IN ('XBA') AND
			End

	else
		if left(@Processo,2) = 'IA'
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
--					ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMA'),1) Paridade,
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
					Left Join caixa_hou_imp_aer CXA on Cta.num_proc_hia=CXA.num_proc_hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='C'
					Left Join Tipo_Taxa TT with(nolock) on CTA.CD_tp_tx = TT.CD_tp_tx 
					Left Join Pessoa PS with(nolock) on HOU.cd_consig_hia = PS.cd_pes
--					left join item_fat FAT on FAT.Num_Proc = CTA.num_proc_hia and FAT.cd_tp_tx = CTA.cd_tp_tx and FAT.DC = CTA.dc_hia and FAT.FatCod in (select fatcod from fatura where fatcod=fat.fatcod and fatstatus='1')
					Left Join @Fatura FAt on fat.num_proc=cta.num_proc_hia and cta.cd_tp_Tx=FAt.cd_tp_tx and cta.dc_hia=fat.dc 
				where 
					CTA.num_proc_hia=@Processo and TT.Ref_Ctb_Tx <> 'PTC' --and CTA.Cd_tp_tx <> 'XCA'
					and desp_org_hia='N'
--					and FAT.fatcod is null
					and Fat.num_proc is null

			Union
			--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
				select
 					APELIDO, 
					TT.nome_tp_tx,
					'D' DC, 
					CC.Vlr_Item_Custo Vlr_Org, 
					CC.vlr_Item_Custo Vlr_PG,
					'REL' cd_tp_moeda,
					ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMA'),1) Paridade,
					CTA.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,
					CC.num_proc Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_hia,'') NF, 
					isnull(CTA.ref_acesso_nf_hia,'') [Site],
					Repasse_TX 
				from 
					custo_cliente cc
					Left Join caixa_hou_imp_aer		CXA	on CC.num_proc=CXA.num_proc_hia and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='D'
					Left Join cta_cte_hou_imp_aer	CtA on CC.num_proc=CtA.num_proc_hia and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_hia='D'
					Left Join Tipo_Taxa				TT with(nolock)	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_imp_aer			HOU with(nolock) on CC.Num_proc = HOU.Num_proc_hia
					Left Join Pessoa				PS with(nolock)	on HOU.cd_consig_hia = PS.CD_pes
				where 
					num_proc=@Processo and num_lcto is null and cta.num_proc_hia is null and (Prestacao = 'S' or Prestacao is null)

			Union 
			--Cta_Cte à D que está no Custo também
				select
 					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_hia DC, 
					CTA.vlr_org_hia Vlr_Org, 
					CXA.vlr_pgto_rcto_hia Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMA'),1) Paridade,
					CTA.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,
					CC.num_proc Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_hia,'') NF, 
					isnull(CTA.ref_acesso_nf_hia,'') [Site],
					Repasse_TX  
				from 
					custo_cliente cc
					Left Join cta_cte_hou_imp_aer	CtA on CC.num_proc=CtA.num_proc_hia and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_hia='D'
					Left Join caixa_hou_imp_aer		CXA on Cta.num_proc_hia=CXA.num_proc_hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='D'
					Left Join Tipo_Taxa				TT with(nolock)	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_imp_aer			HOU with(nolock) on CC.Num_proc = HOU.Num_proc_hia
					Left Join Pessoa				PS with(nolock)	on HOU.cd_consig_hia = PS.CD_pes
				where 
					CXA.num_proc_hia=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'

			union
			--Cta_Cte à D que não está no Custo também
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_HIA DC,
					DBO.VALOR(CTA.vlr_org_Hia,CTA.DC_Hia) Vlr_Org, 
					--CTA.vlr_org_HIA Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_HIA Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMA'),1) Paridade,
					CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,
					CTA.Num_proc_HIA Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_hia,'') NF, 
					isnull(CTA.ref_acesso_nf_hia,'') [Site],
					Repasse_TX  
				from 
					House_imp_AER HOU with(nolock)
					Left Join cta_cte_hou_imp_AER CtA on HOU.num_proc_HIA=CtA.num_proc_HIA and HOU.cd_consig_HIA = CTA.cd_cred_dev_HIA and CtA.dc_HIA='D'
					Left Join caixa_hou_imp_AER CXA on Cta.num_proc_HIA=CXA.num_proc_HIA and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HIA='D'
					Left Join Tipo_Taxa TT with(nolock) on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS with(nolock) on HOU.cd_consig_HIA = PS.cd_pes	
					Left Join @Fatura FAt on fat.num_proc=cta.num_proc_hia and cta.cd_tp_Tx=FAt.cd_tp_tx and cta.dc_hia=fat.dc 
				where 
					CTA.num_proc_HIA=@Processo and CTA.CD_TP_TX in ('RIS','IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and Fat.num_proc is null
			union
			--Cta_Cte D que começa com X
				SELECT
					APELIDO,
					TT.NOME_TP_TX,
					CXA.dc_HIA DC, 
					CXA.vlr_pgto_rcto_HIA Vlr_Org, 
					CXA.vlr_pgto_rcto_HIA Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,'REL','IMA'),1) Paridade,
					CXA.CD_TP_TX CD_TP_TX,
					NULL DebitoCC,
					CXA.num_proc_HIA Processo,
					Ref_Ctb_Tx,
					'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_HOU_IMP_AER CXA 
					JOIN TIPO_TAXA TT with(nolock) ON TT.CD_TP_TX=CXA.CD_TP_TX 
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_HIA=CC.NUM_PROC
					JOIN HOUSE_IMP_AER HOU with(nolock) ON HOU.NUM_PROC_HIA=CXA.NUM_PROC_HIA
					JOIN PESSOA PP with(nolock) ON PP.CD_PES=CD_CONSIG_HIA
				WHERE
					CXA.num_proc_HIA=@Processo AND CXA.DC_HIA='D' AND CC.NUM_PROC IS NULL 
					 AND LEFT(CXA.CD_TP_tX,1)='X' and TT.Ref_Ctb_Tx <> 'PTC' -- and CXA.CD_TP_TX NOT IN ('XBA') 
			End

	else
		if left(@Processo,2) = 'EA'
			Begin
			Insert @TempTaxas
			-- CtaCte A Crédito Contra o EXPOTADOR
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_HEA DC, 
					CTA.vlr_org_HEA Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_Hea Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
--					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXA'),1) Paridade,
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
					Left Join caixa_hou_EXP_aer CXA on Cta.num_proc_HEA=CXA.num_proc_HEA and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HEA='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx 
					Left Join Pessoa PS on HOU.cd_export_hea = PS.cd_pes
--					left join item_fat FAT on FAT.Num_Proc = CTA.num_proc_hea and FAT.cd_tp_tx = CTA.cd_tp_tx and FAT.DC = CTA.dc_hea and FAT.FatCod in (select fatcod from fatura where fatcod=fat.fatcod and fatstatus='1')											
					Left Join @Fatura FAt on fat.num_proc=cta.num_proc_hea and cta.cd_tp_Tx=FAt.cd_tp_tx and cta.dc_hea=fat.dc 
				where 
					CTA.num_proc_HEA=@Processo  and TT.Ref_Ctb_Tx <> 'PTC' --and CTA.Cd_tp_tx <> 'XCA'
					and desp_dst_hea='N'
--					and FAT.fatcod is null
					and Fat.num_proc is null	

			Union
			--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N' 
				select
					APELIDO, 
					TT.nome_tp_tx,
					'D' DC, 
					CC.Vlr_Item_Custo Vlr_Org, 
					CC.vlr_Item_Custo Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXA'),1) Paridade,
					CTA.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,
					CC.num_proc Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_hea,'') NF, 
					isnull(CTA.ref_acesso_nf_hea,'') [Site],
					Repasse_TX  
				from 
					custo_cliente cc
					Left Join caixa_hou_EXP_aer		CXA	on CC.num_proc=CXA.num_proc_HEA and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HEA='D'
					Left Join cta_cte_hou_EXP_aer	CtA on CC.num_proc=CtA.num_proc_HEA and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_HEA='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_exp_aer			HOU on CC.Num_proc = HOU.Num_proc_hea
					Left Join Pessoa				PS	on HOU.cd_export_hea = PS.CD_pes
				where 
					num_proc=@Processo and num_lcto is null and cta.num_proc_HEA is null and (Prestacao = 'S' or Prestacao is null)

			Union 
			--Cta_Cte à D que está no Custo também
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_HEA DC, 
					CTA.vlr_org_HEA Vlr_Org, 
					CXA.vlr_pgto_rcto_HEA Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXA'),1) Paridade,
					CTA.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,
					CC.num_proc Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_hea,'') NF, 
					isnull(CTA.ref_acesso_nf_hea,'') [Site],
					Repasse_TX 
				from 
					custo_cliente cc
					Left Join cta_cte_hou_EXP_aer	CtA on CC.num_proc=CtA.num_proc_HEA and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_HEA='D'
					Left Join caixa_hou_EXP_aer		CXA on Cta.num_proc_HEA=CXA.num_proc_HEA and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HEA='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_exp_aer			HOU on CC.Num_proc = HOU.Num_proc_hea
					Left Join Pessoa				PS	on HOU.cd_export_hea = PS.CD_pes
				where 
					CXA.num_proc_HEA=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'

			union
			--Cta_Cte à D que não está no Custo também
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_HEA DC,
					DBO.VALOR(CTA.vlr_org_Hea,CTA.DC_Hea) Vlr_Org, 
					--CTA.vlr_org_HEA Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_HEA Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXA'),1) Paridade,
					CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,
					CTA.Num_proc_HEA Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_hea,'') NF, 
					isnull(CTA.ref_acesso_nf_hea,'') [Site],
					Repasse_TX  
				from 
					House_exp_AER HOU
					Left Join cta_cte_hou_exp_AER CtA on HOU.num_proc_HEA=CtA.num_proc_HEA and HOU.cd_export_HEA = CTA.cd_cred_dev_HEA and CtA.dc_HEA='D'
					Left Join caixa_hou_exp_AER CXA on Cta.num_proc_HEA=CXA.num_proc_HEA and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HEA='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.cd_export_HEA = PS.cd_pes
					Left Join @Fatura FAt on fat.num_proc=cta.num_proc_hea and cta.cd_tp_Tx=FAt.cd_tp_tx and cta.dc_hea=fat.dc 
				where 
					CTA.num_proc_HEA=@Processo and CTA.CD_TP_TX in ('RIS''IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and Fat.num_proc is null
			union
			--Cta_Cte D que começa com X
				SELECT
					APELIDO,
					TT.NOME_TP_TX,
					CXA.dc_HEA DC, 
					CXA.vlr_pgto_rcto_HEA Vlr_Org, 
					CXA.vlr_pgto_rcto_HEA Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,'REL','EXA'),1) Paridade,
					CXA.CD_TP_TX CD_TP_TX,
					NULL DebitoCC,
					CXA.num_proc_HEA Processo,
					Ref_Ctb_Tx,
					'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_HOU_EXP_AER CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX 
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_HEA=CC.NUM_PROC
					JOIN HOUSE_EXP_AER HOU ON HOU.NUM_PROC_HEA=CXA.NUM_PROC_HEA
					JOIN PESSOA PP ON PP.CD_PES=HOU.cd_export_hea
				WHERE
					CXA.num_proc_HEA=@Processo AND CXA.DC_HEA='D' AND CC.NUM_PROC IS NULL 
					 AND LEFT(CXA.CD_TP_tX,1)='X' and TT.Ref_Ctb_Tx <> 'PTC' --and CXA.CD_TP_TX NOT IN ('XBA') 		 
			End

	else
		If left(@Processo,2) = 'IM'
			Begin
			Insert @TempTaxas
			-- CtaCte A Crédito Contra o Consignee
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_HIM DC, 
					CTA.vlr_org_HIM Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_HIM Vlr_PG,
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
					Left Join caixa_hou_imp_MAR CXA on Cta.num_proc_HIM=CXA.num_proc_HIM and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HIM='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx 
					Left Join Pessoa PS on HOU.cd_consig_him = PS.cd_pes
--					left join item_fat FAT on FAT.Num_Proc = CTA.num_proc_him and FAT.cd_tp_tx = CTA.cd_tp_tx and FAT.DC = CTA.dc_him and FAT.FatCod in (select fatcod from fatura where fatcod=fat.fatcod and fatstatus='1')
					Left Join @Fatura FAt on fat.num_proc=cta.num_proc_him and cta.cd_tp_Tx=FAt.cd_tp_tx and cta.dc_him=fat.dc 
				where 
					CTA.num_proc_HIM=@Processo  and TT.Ref_Ctb_Tx <> 'PTC' --and CTA.Cd_tp_tx <> 'XCA'
					and desp_org_him='N'
--					and FAT.fatcod is null
					and Fat.num_proc is null

			Union
			--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
				select
					APELIDO, 
					TT.nome_tp_tx,
					'D' DC, 
					sum(CC.Vlr_Item_Custo) Vlr_Org, 
					sum(CC.vlr_Item_Custo) Vlr_PG,
					'REL' cd_tp_moeda,
					1  Paridade,
					CTA.CD_TP_TX CD_TP_TX,
					CC.CD_tp_tx DebitoCC,
					CC.num_proc Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_him,'') NF, 
					isnull(CTA.ref_acesso_nf_him,'') [Site],
					Repasse_TX 
				from 
					custo_cliente cc With(nolock)
					Left Join caixa_hou_imp_MAR		CXA	on CC.num_proc=CXA.num_proc_HIM and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HIM='D'
					Left Join cta_cte_hou_imp_MAR	CtA on CC.num_proc=CtA.num_proc_HIM and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_HIM='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_imp_mar			HOU with(nolock) on CC.Num_proc = HOU.Num_proc_him
					Left Join Pessoa				PS	on HOU.cd_consig_him = PS.CD_pes
				where 
					num_proc=@Processo and num_lcto is null and cta.num_proc_HIM is null and (Prestacao = 'S' or Prestacao is null)
				Group by apelido, tt.nome_tp_tx,cta.cd_tp_Tx,cc.cd_tp_tx,cc.num_proc,Ref_Ctb_Tx,CTA.num_nf_him,CTA.ref_acesso_nf_him,Repasse_TX 
			
			Union
			--Cta_Cte à D que está no Custo também
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_HIM DC, 
					CTA.vlr_org_HIM Vlr_Org, 
					CXA.vlr_pgto_rcto_HIM Vlr_PG,
					'REL' cd_tp_moeda,
					1 Paridade,
					CTA.CD_TP_TX CD_TP_TX,
					CC.CD_tp_tx DebitoCC,
					CC.num_proc Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_him,'') NF, 
					isnull(CTA.ref_acesso_nf_him,'') [Site],
					Repasse_TX 
				from 
					custo_cliente cc With(nolock)
					Left Join cta_cte_hou_imp_MAR	CtA on CC.num_proc=CtA.num_proc_HIM and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_HIM='D'
					Left Join caixa_hou_imp_MAR		CXA on Cta.num_proc_HIM=CXA.num_proc_HIM and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HIM='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_imp_mar			HOU with(nolock) on Cta.Num_proc_him = HOU.Num_proc_him
					Left Join Pessoa				PS	on HOU.cd_consig_him = PS.CD_pes
				where 
					CXA.num_proc_HIM=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'

			union			
			--Cta_Cte à D que não está no Custo também
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_HIM DC, 
					DBO.VALOR(CTA.vlr_org_HIM,CTA.DC_HIM) Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_HIM Vlr_PG,
					'REL' cd_tp_moeda,
					1 Paridade,
					CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,
					CTA.Num_proc_HIM Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_him,'') NF, 
					isnull(CTA.ref_acesso_nf_him,'') [Site],
					Repasse_TX 
				from 
					House_imp_MAR HOU With(nolock)
					Left Join cta_cte_hou_imp_MAR CtA on HOU.num_proc_HIM=CtA.num_proc_HIM and HOU.cd_consig_HIM = CTA.cd_cred_dev_HIM and CtA.dc_HIM='D'
					Left Join caixa_hou_imp_MAR CXA on Cta.num_proc_HIM=CXA.num_proc_HIM and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HIM='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.cd_consig_him = PS.cd_pes
					Left Join @Fatura FAt on fat.num_proc=cta.num_proc_him and cta.cd_tp_Tx=FAt.cd_tp_tx and cta.dc_him=fat.dc 
				where 
					CTA.num_proc_HIM=@Processo and CTA.CD_TP_TX in ('RIS','IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and Fat.num_proc is null
			union
			--Cta_Cte D que começa com X
				SELECT
					APELIDO,
					TT.NOME_TP_TX,
					CXA.dc_HIM DC, 
					CXA.vlr_pgto_rcto_HIM Vlr_Org, 
					CXA.vlr_pgto_rcto_HIM Vlr_PG,
					'REL' cd_tp_moeda,
					1 Paridade,
					CXA.CD_TP_TX CD_TP_TX,
					NULL DebitoCC,
					CXA.num_proc_HIM Processo,
					Ref_Ctb_Tx,
					'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_HOU_IMP_MAR CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX 
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_HIM=CC.NUM_PROC
					JOIN HOUSE_IMP_MAR HOU With(nolock) ON HOU.NUM_PROC_HIM=CXA.NUM_PROC_HIM
					JOIN PESSOA PP ON PP.CD_PES=CD_CONSIG_HIM
				WHERE
					CXA.num_proc_HIM=@Processo AND CXA.DC_HIM='D' AND CC.NUM_PROC IS NULL 
					AND LEFT(CXA.CD_TP_tX,1)='X' and TT.Ref_Ctb_Tx <> 'PTC'  -- and CXA.CD_TP_TX NOT IN ('XBA') 

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
					CXA.Vlr_Pgto_Rcto_Hem Vlr_PG,
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
					Left Join caixa_hou_EXP_MAR CXA on Cta.num_proc_HEM=CXA.num_proc_HEM and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HEM='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx 
					Left Join Pessoa PS on HOU.cd_export_hem = PS.cd_pes
--					left join item_fat FAT on FAT.Num_Proc = CTA.num_proc_hem and FAT.cd_tp_tx = CTA.cd_tp_tx and FAT.DC = CTA.dc_hem and FAT.FatCod in (select fatcod from fatura where fatcod=fat.fatcod and fatstatus='1')
					Left Join @Fatura FAt on fat.num_proc=cta.num_proc_hem and cta.cd_tp_Tx=FAt.cd_tp_tx and cta.dc_hem=fat.dc 
				where 
					CTA.num_proc_HEM=@Processo and TT.Ref_Ctb_Tx <> 'PTC' --and CTA.Cd_tp_tx <> 'XCA'
					and desp_dst_hem='N'
--					and FAT.fatcod is null
					and Fat.num_proc is null

			Union
			--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
				select
					APELIDO, 
					TT.nome_tp_tx,
					'D' DC, 
					CC.Vlr_Item_Custo Vlr_Org, 
					CC.vlr_Item_Custo Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXM'),1) Paridade,
					CTA.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,
					CC.num_proc Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_hem,'') NF, 
					isnull(CTA.ref_acesso_nf_hem,'') [Site],
					Repasse_TX
				from 
					custo_cliente cc
					Left Join caixa_hou_EXP_MAR		CXA	on CC.num_proc=CXA.num_proc_HEM and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HEM='D'
					Left Join cta_cte_hou_EXP_MAR	CtA on CC.num_proc=CtA.num_proc_HEM and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_HEM='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_exp_mar			HOU on CC.Num_proc = HOU.Num_proc_hem
					Left Join Pessoa				PS	on HOU.cd_export_hem = PS.CD_pes
				where 
					num_proc=@Processo and num_lcto is null and cta.num_proc_HEM is null and (Prestacao = 'S' or Prestacao is null)

			Union
			--Cta_Cte à D que está no Custo também
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_HEM DC, 
					CTA.vlr_org_HEM Vlr_Org, 
					CXA.vlr_pgto_rcto_HEM Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXM'),1) Paridade,
					CC.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,
					CC.num_proc Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_hem,'') NF, 
					isnull(CTA.ref_acesso_nf_hem,'') [Site],
					Repasse_TX
				from 
					custo_cliente cc
					Left Join cta_cte_hou_EXP_MAR CtA on CC.num_proc=CtA.num_proc_HEM and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_HEM='D'
					Left Join caixa_hou_EXP_MAR CXA on Cta.num_proc_HEM=CXA.num_proc_HEM and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HEM='D'
					Left Join Tipo_Taxa TT on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_exp_mar			HOU on CC.Num_proc = HOU.Num_proc_hem
					Left Join Pessoa				PS	on HOU.cd_export_hem = PS.CD_pes
				where 
					CXA.num_proc_HEM=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'

			union			
			--Cta_Cte à D que não está no Custo também
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_hem DC, 
					DBO.VALOR(CTA.vlr_org_Hem,CTA.DC_Hem) Vlr_Org,
					--CTA.vlr_org_hem Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_hem Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXM'),1) Paridade,
					CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,
					CTA.Num_proc_hem Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_hem,'') NF, 
					isnull(CTA.ref_acesso_nf_hem,'') [Site],
					Repasse_TX
				from 
					House_exp_mar HOU
					Left Join cta_cte_hou_exp_mar CtA on HOU.num_proc_hem=CtA.num_proc_hem and HOU.cd_export_hem = CTA.cd_cred_dev_hem and CtA.dc_hem='D'
					Left Join caixa_hou_exp_mar CXA on Cta.num_proc_hem=CXA.num_proc_hem and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hem='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.cd_export_hem = PS.cd_pes
					Left Join @Fatura FAt on fat.num_proc=cta.num_proc_hem and cta.cd_tp_Tx=FAt.cd_tp_tx and cta.dc_hem=fat.dc 
				where 
					CTA.num_proc_hem=@Processo and CTA.CD_TP_TX in ('RIS','IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and Fat.num_proc is null
			union
			--Cta_Cte D que começa com X
				SELECT
					APELIDO,
					TT.NOME_TP_TX,
					CXA.dc_HEM DC, 
					CXA.vlr_pgto_rcto_HEM Vlr_Org, 
					CXA.vlr_pgto_rcto_HEM Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,'REL','EXM'),1) Paridade,
					CXA.CD_TP_TX CD_TP_TX,
					NULL DebitoCC,
					CXA.num_proc_HEM Processo,
					Ref_Ctb_Tx,
					'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_HOU_EXP_MAR CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX 
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_HEM=CC.NUM_PROC
					JOIN HOUSE_EXP_MAR HOU ON HOU.NUM_PROC_HEM=CXA.NUM_PROC_HEM
					JOIN PESSOA PP ON PP.CD_PES=CD_Export_HEM
				WHERE
					CXA.num_proc_HEM=@Processo AND CXA.DC_HEM='D' AND CC.NUM_PROC IS NULL 
					AND LEFT(CXA.CD_TP_tX,1)='X' and TT.Ref_Ctb_Tx <> 'PTC' --AND CXA.CD_TP_TX NOT IN ('XBA')
			 
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
					CXA.Vlr_Pgto_Rcto_MEM Vlr_PG,
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
					Left Join caixa_mas_EXP_MAR CXA on Cta.num_proc_MEM=CXA.num_proc_MEM and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_MEM='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_export_MEM = PS.cd_pes
					Left Join @Fatura FAt on fat.num_proc=CtA.num_proc_mem and CtA.cd_tp_Tx=FAt.cd_tp_tx and CtA.dc_mem=fat.dc    
				where 
					CTA.num_proc_MEM=@Processo  and TT.Ref_Ctb_Tx <> 'PTC' --and CTA.Cd_tp_tx <> 'XCA'
					and desp_dst_mem='N'
					and Fat.num_proc is null

			Union
			--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
				select
					APELIDO, 
					TT.nome_tp_tx,
					'D' DC, 
					CC.Valor Vlr_Org, 
					CC.valor Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXM'),1) Paridade,
					CTA.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,
					CC.num_proc Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_mem,'') NF, 
					isnull(CTA.ref_acesso_nf_mem,'') [Site],
					Repasse_TX 
				from 
					custo_processo cc
					Left Join caixa_mas_EXP_MAR		CXA	on CC.num_proc=CXA.num_proc_MEM and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_MEM='D'
					Left Join cta_cte_mas_EXP_MAR	CtA on CC.num_proc=CtA.num_proc_MEM and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_MEM='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_exp_mar			MAS on CC.Num_proc = MAS.Num_proc_MEM
					Left Join Pessoa				PS	on MAS.cd_export_MEM = PS.CD_pes
				where 
					num_proc=@Processo and num_lcto is null and cta.num_proc_MEM is null --and (Prestacao = 'S' or Prestacao is null)

			Union
			--Cta_Cte à D que está no Custo também
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_MEM DC, 
					CTA.vlr_org_MEM Vlr_Org, 
					CXA.vlr_pgto_rcto_MEM Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXM'),1) Paridade,
					CC.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,
					CC.num_proc Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_mem,'') NF, 
					isnull(CTA.ref_acesso_nf_mem,'') [Site],
					Repasse_TX 
				from 
					custo_cliente cc
					Left Join cta_cte_mas_EXP_MAR CtA on CC.num_proc=CtA.num_proc_MEM and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_MEM='D'
					Left Join caixa_mas_EXP_MAR CXA on Cta.num_proc_MEM=CXA.num_proc_MEM and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_MEM='D'
					Left Join Tipo_Taxa TT on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_exp_mar			MAS on CC.Num_proc = MAS.Num_proc_MEM
					Left Join Pessoa				PS	on MAS.cd_export_MEM = PS.CD_pes
				where 
					CXA.num_proc_MEM=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'

			union			
			--Cta_Cte à D que não está no Custo também
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_MEM DC, 							
					CTA.vlr_org_MEM Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_MEM Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXM'),1) Paridade,
					CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,
					CTA.Num_proc_MEM Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_mem,'') NF, 
					isnull(CTA.ref_acesso_nf_mem,'') [Site],
					Repasse_TX 
				from 
					MASter_exp_mar MAS
					Left Join cta_cte_mas_exp_mar CtA on MAS.num_proc_MEM=CtA.num_proc_MEM and MAS.cd_export_MEM = CTA.cd_cred_dev_MEM and CtA.dc_MEM='D'
					Left Join caixa_mas_exp_mar CXA on Cta.num_proc_MEM=CXA.num_proc_MEM and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_MEM='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_export_MEM = PS.cd_pes
					Left Join @Fatura FAt on fat.num_proc=CtA.num_proc_mem and CtA.cd_tp_Tx=FAt.cd_tp_tx and CtA.dc_mem=fat.dc    
				where 
					CTA.num_proc_MEM=@Processo and CTA.CD_TP_TX in ('RIS','IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and Fat.num_proc is null
			union
			--Cta_Cte D que começa com X
				SELECT
					APELIDO,
					TT.NOME_TP_TX,
					CXA.dc_MEM DC, 
					CXA.vlr_pgto_rcto_MEM Vlr_Org, 
					CXA.vlr_pgto_rcto_MEM Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,'REL','EXM'),1) Paridade,
					CXA.CD_TP_TX CD_TP_TX,
					NULL DebitoCC,
					CXA.num_proc_MEM Processo,
					Ref_Ctb_Tx,
					'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_mas_EXP_MAR CXA 
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX 
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_MEM=CC.NUM_PROC
					JOIN MASter_EXP_MAR MAS ON MAS.NUM_PROC_MEM=CXA.NUM_PROC_MEM
					JOIN PESSOA PP ON PP.CD_PES=CD_Export_MEM
				WHERE
					CXA.num_proc_MEM=@Processo AND CXA.DC_MEM='D' AND CC.NUM_PROC IS NULL 
					AND LEFT(CXA.CD_TP_tX,1)='X' and TT.Ref_Ctb_Tx <> 'PTC' --AND CXA.CD_TP_TX NOT IN ('XBA')
		 
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
					CXA.Vlr_Pgto_Rcto_mea Vlr_PG,
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
					Left Join caixa_mas_EXP_aer CXA on Cta.num_proc_mea=CXA.num_proc_mea and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_mea='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx 
					Left Join Pessoa PS on MAS.cd_export_mea = PS.cd_pes
					Left Join @Fatura FAt on fat.num_proc=CtA.num_proc_mea and CtA.cd_tp_Tx=FAt.cd_tp_tx and CtA.dc_mea=fat.dc    												
				where 
					CTA.num_proc_mea=@Processo  and TT.Ref_Ctb_Tx <> 'PTC'--and CTA.Cd_tp_tx <> 'XCA'
					and desp_dst_mea='N'
					and Fat.num_proc is null

			Union
			--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
				select
					APELIDO, 
					TT.nome_tp_tx,
					'D' DC, 
					CC.Valor Vlr_Org, 
					CC.valor Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXA'),1) Paridade,
					CTA.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,
					CC.num_proc Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_mea,'') NF, 
					isnull(CTA.ref_acesso_nf_mea,'') [Site],
					Repasse_TX  
				from 
					custo_processo cc
					Left Join caixa_mas_EXP_aer		CXA	on CC.num_proc=CXA.num_proc_mea and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_mea='D'
					Left Join cta_cte_mas_EXP_aer	CtA on CC.num_proc=CtA.num_proc_mea and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_mea='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_exp_aer			MAS on CC.Num_proc = MAS.Num_proc_mea
					Left Join Pessoa				PS	on MAS.cd_export_mea = PS.CD_pes
				where 
					num_proc=@Processo and num_lcto is null and cta.num_proc_mea is null --and (Prestacao = 'S' or Prestacao is null)

			Union
			--Cta_Cte à D que está no Custo também
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_mea DC, 
					CTA.vlr_org_mea Vlr_Org, 
					CXA.vlr_pgto_rcto_mea Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXA'),1) Paridade,
					CC.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,
					CC.num_proc Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_mea,'') NF, 
					isnull(CTA.ref_acesso_nf_mea,'') [Site],
					Repasse_TX  
				from 
					custo_cliente cc
					Left Join cta_cte_mas_EXP_aer CtA on CC.num_proc=CtA.num_proc_mea and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_mea='D'
					Left Join caixa_mas_EXP_aer CXA on Cta.num_proc_mea=CXA.num_proc_mea and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_mea='D'
					Left Join Tipo_Taxa TT on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_exp_aer			MAS on CC.Num_proc = MAS.Num_proc_mea
					Left Join Pessoa				PS	on MAS.cd_export_mea = PS.CD_pes
				where 
					CXA.num_proc_mea=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'

			union			
			--Cta_Cte à D que não está no Custo também
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_mea DC, 
					CTA.vlr_org_mea Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_mea Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXA'),1) Paridade,
					CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,
					CTA.Num_proc_mea Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_mea,'') NF, 
					isnull(CTA.ref_acesso_nf_mea,'') [Site],
					Repasse_TX 
				from 
					MASter_exp_aer MAS
					Left Join cta_cte_mas_exp_aer CtA on MAS.num_proc_mea=CtA.num_proc_mea and MAS.cd_export_mea = CTA.cd_cred_dev_mea and CtA.dc_mea='D'
					Left Join caixa_mas_exp_aer CXA on Cta.num_proc_mea=CXA.num_proc_mea and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_mea='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_export_mea = PS.cd_pes
					Left Join @Fatura FAt on fat.num_proc=CtA.num_proc_mea and CtA.cd_tp_Tx=FAt.cd_tp_tx and CtA.dc_mea=fat.dc    												
				where 
					CTA.num_proc_mea=@Processo and CTA.CD_TP_TX in ('RIS','IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and Fat.num_proc is null
			Union
			--Cta_Cte D que começa com X
				SELECT
					APELIDO,
					TT.NOME_TP_TX,
					CXA.dc_mea DC, 
					CXA.vlr_pgto_rcto_mea Vlr_Org, 
					CXA.vlr_pgto_rcto_mea Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,'REL','EXA'),1) Paridade,
					CXA.CD_TP_TX CD_TP_TX,
					NULL DebitoCC,
					CXA.num_proc_mea Processo,
					Ref_Ctb_Tx,
					'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_mas_EXP_aer CXA 
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX 
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_mea=CC.NUM_PROC
					JOIN MASter_EXP_aer MAS ON MAS.NUM_PROC_mea=CXA.NUM_PROC_mea
					JOIN PESSOA PP ON PP.CD_PES=CD_Export_mea
				WHERE
					CXA.num_proc_mea=@Processo AND CXA.DC_mea='D' AND CC.NUM_PROC IS NULL 
					AND LEFT(CXA.CD_TP_tX,1)='X' and TT.Ref_Ctb_Tx <> 'PTC' --AND CXA.CD_TP_TX NOT IN ('XBA')
			 
			End
	else
		if left(@Processo,2) = 'IA'
			Begin
			Insert @TempTaxas
			-- CtaCte A Crédito Contra o Consignee
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_mia DC, 
					CTA.vlr_org_mia Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_mia Vlr_PG,
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
					Left Join caixa_mas_imp_aer CXA on Cta.num_proc_mia=CXA.num_proc_mia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_mia='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_consig_mia = PS.cd_pes
					Left Join @Fatura FAt on fat.num_proc=CtA.num_proc_mia and CtA.cd_tp_Tx=FAt.cd_tp_tx and CtA.dc_mia=fat.dc    
				where 
					CTA.num_proc_mia=@Processo  and TT.Ref_Ctb_Tx <> 'PTC' --and CTA.Cd_tp_tx <> 'XCA'
					and desp_org_mia='N'
					and Fat.num_proc is null

			Union
			--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
				select
					APELIDO, 
					TT.nome_tp_tx,
					'D' DC, 
					CC.Valor Vlr_Org, 
					CC.valor Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMA'),1) Paridade,
					CTA.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,
					CC.num_proc Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_mia,'') NF,
					isnull(CTA.ref_acesso_nf_mia,'') [Site],
					Repasse_TX
				from 
					custo_processo cc
					Left Join caixa_mas_imp_aer		CXA	on CC.num_proc=CXA.num_proc_mia and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_mia='D'
					Left Join cta_cte_mas_imp_aer	CtA on CC.num_proc=CtA.num_proc_mia and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_mia='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_imp_aer			MAS on CC.Num_proc = MAS.Num_proc_mia
					Left Join Pessoa				PS	on MAS.cd_consig_mia = PS.CD_pes
				where 
					num_proc=@Processo and num_lcto is null and cta.num_proc_mia is null --and (Prestacao = 'S' or Prestacao is null)

			Union
			--Cta_Cte à D que está no Custo também
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_mia DC, 
					CTA.vlr_org_mia Vlr_Org, 
					CXA.vlr_pgto_rcto_mia Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMA'),1) Paridade,
					CC.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,
					CC.num_proc Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_mia,'') NF,
					isnull(CTA.ref_acesso_nf_mia,'') [Site],
					Repasse_TX 
				from 
					custo_cliente cc
					Left Join cta_cte_mas_imp_aer CtA on CC.num_proc=CtA.num_proc_mia and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_mia='D'
					Left Join caixa_mas_imp_aer CXA on Cta.num_proc_mia=CXA.num_proc_mia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_mia='D'
					Left Join Tipo_Taxa TT on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_imp_aer			MAS on CC.Num_proc = MAS.Num_proc_mia
					Left Join Pessoa				PS	on MAS.cd_consig_mia = PS.CD_pes
				where 
					CXA.num_proc_mia=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'

			union			
			--Cta_Cte à D que não está no Custo também
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_mia DC, 
					CTA.vlr_org_mia Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_mia Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMA'),1) Paridade,
					CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,
					CTA.Num_proc_mia Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_mia,'') NF,
					isnull(CTA.ref_acesso_nf_mia,'') [Site],
					Repasse_TX
				from 
					MASter_imp_aer MAS
					Left Join cta_cte_mas_imp_aer CtA on MAS.num_proc_mia=CtA.num_proc_mia and MAS.cd_consig_mia = CTA.cd_cred_dev_mia and CtA.dc_mia='D'
					Left Join caixa_mas_imp_aer CXA on Cta.num_proc_mia=CXA.num_proc_mia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_mia='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_consig_mia = PS.cd_pes
					Left Join @Fatura FAt on fat.num_proc=CtA.num_proc_mia and CtA.cd_tp_Tx=FAt.cd_tp_tx and CtA.dc_mia=fat.dc    
				where 
					CTA.num_proc_mia=@Processo and CTA.CD_TP_TX in ('RIS','IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and Fat.num_proc is null
			union
			--Cta_Cte D que começa com X
				SELECT
					APELIDO,
					TT.NOME_TP_TX,
					CXA.dc_mia DC, 
					CXA.vlr_pgto_rcto_mia Vlr_Org, 
					CXA.vlr_pgto_rcto_mia Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,'REL','IMA'),1) Paridade,
					CXA.CD_TP_TX CD_TP_TX,
					NULL DebitoCC,
					CXA.num_proc_mia Processo,
					Ref_Ctb_Tx,
					'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_mas_imp_aer CXA 
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_mia=CC.NUM_PROC
					JOIN MASter_imp_aer MAS ON MAS.NUM_PROC_mia=CXA.NUM_PROC_mia
					JOIN PESSOA PP ON PP.CD_PES=CD_consig_mia
				WHERE
					CXA.num_proc_mia=@Processo AND CXA.DC_mia='D' AND CC.NUM_PROC IS NULL 
					AND LEFT(CXA.CD_TP_tX,1)='X'  and TT.Ref_Ctb_Tx <> 'PTC' --AND CXA.CD_TP_TX NOT IN ('XBA')
			 
			End
	Else
		if left(@Processo,2) = 'IM'
			Begin
			Insert @TempTaxas
			-- CtaCte A Crédito Contra o Consignee
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_Mim DC, 
					CTA.vlr_org_Mim Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_Mim Vlr_PG,
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
					Left Join caixa_mas_imp_mar CXA on Cta.num_proc_Mim=CXA.num_proc_Mim and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Mim='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_consig_Mim = PS.cd_pes
					Left Join @Fatura FAt on fat.num_proc=CtA.num_proc_mim and CtA.cd_tp_Tx=FAt.cd_tp_tx and CtA.dc_mim=fat.dc    
				where 
					CTA.num_proc_Mim=@Processo  and TT.Ref_Ctb_Tx <> 'PTC' --and CTA.Cd_tp_tx <> 'XCA'
					and desp_org_mim='N'
					and Fat.num_proc is null

			Union
			--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
				select
					APELIDO, 
					TT.nome_tp_tx,
					'D' DC, 
					CC.Valor Vlr_Org, 
					CC.Valor Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMM'),1) Paridade,
					Cta.CD_tp_tx,
					 CC.CD_tp_tx DebitoCC,
					CC.num_proc Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_mim,'') NF, 
					isnull(CTA.ref_acesso_nf_mim,'') [Site],
					Repasse_TX 
				from 
					custo_processo cc
					Left Join caixa_mas_imp_mar		CXA	on CC.num_proc=CXA.num_proc_Mim and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Mim='D'
					Left Join cta_cte_mas_imp_mar	CtA on CC.num_proc=CtA.num_proc_Mim and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_Mim='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_imp_mar			MAS on CC.Num_proc = MAS.Num_proc_Mim
					Left Join Pessoa				PS	on MAS.cd_consig_Mim = PS.CD_pes
				where 
					num_proc=@Processo and num_lcto is null and cta.num_proc_Mim is null --and (Prestacao = 'S' or Prestacao is null)

			Union
			--Cta_Cte à D que está no Custo também
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_Mim DC, 
					CTA.vlr_org_Mim Vlr_Org, 
					CXA.vlr_pgto_rcto_Mim Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMM'),1) Paridade,
					CC.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,
					CC.num_proc Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_mim,'') NF, 
					isnull(CTA.ref_acesso_nf_mim,'') [Site],
					Repasse_TX 
				from 
					custo_cliente cc
					Left Join cta_cte_mas_imp_mar CtA on CC.num_proc=CtA.num_proc_Mim and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_Mim='D'
					Left Join caixa_mas_imp_mar CXA on Cta.num_proc_Mim=CXA.num_proc_Mim and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Mim='D'
					Left Join Tipo_Taxa TT on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_imp_mar			MAS on CC.Num_proc = MAS.Num_proc_Mim
					Left Join Pessoa				PS	on MAS.cd_consig_Mim = PS.CD_pes
				where 
					CXA.num_proc_Mim=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'

			union			
			--Cta_Cte à D que não está no Custo também
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_Mim DC, 
					CTA.vlr_org_Mim Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_Mim Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMM'),1) Paridade,
					CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,
					CTA.Num_proc_Mim Processo,
					Ref_Ctb_Tx,
					isnull(CTA.num_nf_mim,'') NF, 
					isnull(CTA.ref_acesso_nf_mim,'') [Site],
					Repasse_TX 
				from 
					MASter_imp_mar MAS
					Left Join cta_cte_mas_imp_mar CtA on MAS.num_proc_Mim=CtA.num_proc_Mim and MAS.cd_consig_Mim = CTA.cd_cred_dev_Mim and CtA.dc_Mim='D'
					Left Join caixa_mas_imp_mar CXA on Cta.num_proc_Mim=CXA.num_proc_Mim and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Mim='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_consig_Mim = PS.cd_pes
					Left Join @Fatura FAt on fat.num_proc=CtA.num_proc_mim and CtA.cd_tp_Tx=FAt.cd_tp_tx and CtA.dc_mim=fat.dc    
				where 
					CTA.num_proc_Mim=@Processo and CTA.CD_TP_TX in ('RIS','IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and Fat.num_proc is null
			union
			--Cta_Cte D que começa com X
				SELECT
					APELIDO,
					TT.NOME_TP_TX,
					CXA.dc_Mim DC, 
					CXA.vlr_pgto_rcto_Mim Vlr_Org, 
					CXA.vlr_pgto_rcto_Mim Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,'REL','IMM'),1) Paridade,
					CXA.CD_TP_TX CD_TP_TX,
					NULL DebitoCC,
					CXA.num_proc_Mim Processo,
					Ref_Ctb_Tx,
					'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_mas_imp_mar CXA
				JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX 
				Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_Mim=CC.NUM_PROC
				JOIN MASter_imp_mar MAS ON MAS.NUM_PROC_Mim=CXA.NUM_PROC_Mim
				JOIN PESSOA PP ON PP.CD_PES=CD_consig_Mim
				WHERE
					CXA.num_proc_Mim=@Processo AND CXA.DC_Mim='D' AND CC.NUM_PROC IS NULL 
					AND LEFT(CXA.CD_TP_tX,1)='X' and TT.Ref_Ctb_Tx <> 'PTC' --AND CXA.CD_TP_TX NOT IN ('XBA')
			 
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


--ja estava comentado
	--end
--ELSE
--	BEGIN
--		select 
--			Apelido APELIDO, nome_tp_tx,cta.dc_him DC, 
--			vlr_org_him Vlr_Org, vlr_pgto_rcto_him Vlr_PG,cta.cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMM'),1) Paridade,CTA.CD_TP_TX, CC.CD_tp_tx DebitoCC,hou.num_proc_him Processo
--		from 
--			house_imp_mar hou
--			join cta_cte_hou_imp_mar CTA ON cta.num_proc_him=hou.num_proc_him and (left(cta.cd_tp_tx,1)='X' or cta.cd_cred_dev_him=hou.cd_consig_him) --and (cta.cd_tp_tx <> 'XBA')-- and cta.dc_him = 'D')
--			join pessoa pp on pp.cd_pes=hou.cd_consig_hiM
--			join tipo_taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
--			left Join Caixa_hou_imp_mar cxa on cta.num_proc_him=cxa.num_proc_him and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him and num_lcto <> 'PROVISÓRIO'
--			left Join Custo_Cliente CC on Cta.num_proc_him = CC.Num_Proc and CTA.Cd_tp_tx = CC.Cd_tp_tx
--			--left join paridade par on par.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='IMM' AND CONVERT(datetime,DT_PAR,105)=@Dt_Par
--		WHERE 
--			(HOU.NUM_PROC_HIM=@Processo or hou.job_him=@processo or hou.hawb_him=@processo) and (cta.cd_tp_tx) <> 'XCA' and desp_org_him='N'
--
--UNION 
--
--		select 
--			Apelido APELIDO, nome_tp_tx,cta.dc_hia DC, 
--			vlr_org_hia Vlr_Org, vlr_pgto_rcto_hia Vlr_PG,cta.cd_tp_moeda,iSnULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMA'),1) Paridade,CTA.CD_TP_TX, CC.CD_tp_tx DebitoCC,hou.num_proc_hia Processo
--		from 
--			house_imp_aer hou
--			join cta_cte_hou_imp_aer CTA ON cta.num_proc_hia=hou.num_proc_hia and (left(cta.cd_tp_tx,1)='X' or cta.cd_cred_dev_hia=hou.cd_consig_hia) --and (cta.cd_tp_tx <> 'XBA')-- and cta.dc_hia = 'D')
--			join pessoa pp on pp.cd_pes=hou.cd_consig_hia
--			join tipo_taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
--			left Join Caixa_hou_imp_aer cxa on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO'
--			left Join Custo_Cliente CC on Cta.num_proc_hia = CC.Num_Proc and CTA.Cd_tp_tx = CC.Cd_tp_tx
--			--left join paridade par on par.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='IMM' AND CONVERT(datetime,DT_PAR,105)=@Dt_Par
--		WHERE 
--			(HOU.NUM_PROC_hia=@Processo or hou.job_hia=@processo or hou.hawb_hia=@processo) and (cta.cd_tp_tx) <> 'XCA' and desp_org_hia='N'
--
--Union
--		select 
--			Apelido APELIDO, nome_tp_tx,cta.dc_hea DC, 
--			vlr_org_hea Vlr_Org, vlr_pgto_rcto_hea Vlr_PG,cta.cd_tp_moeda,iSnULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMA'),1) Paridade,CTA.CD_TP_TX, CC.CD_tp_tx DebitoCC,hou.num_proc_hea Processo
--		from 
--			house_exp_aer hou
--			join cta_cte_hou_exp_aer CTA ON cta.num_proc_hea=hou.num_proc_hea and (left(cta.cd_tp_tx,1)='X' or cta.cd_cred_dev_hea=hou.cd_export_hea) --and (cta.cd_tp_tx <> 'XBA')-- and cta.dc_hea = 'D')
--			join pessoa pp on pp.cd_pes=hou.cd_export_hea
--			join tipo_taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
--			left Join Caixa_hou_exp_aer cxa on cta.num_proc_hea=cxa.num_proc_hea and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hea and num_lcto <> 'PROVISÓRIO'
--			left Join Custo_Cliente CC on Cta.num_proc_hea = CC.Num_Proc and CTA.Cd_tp_tx = CC.Cd_tp_tx
--			--left join paridade par on par.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='IMM' AND CONVERT(datetime,DT_PAR,105)=@Dt_Par
--		WHERE 
--			(HOU.NUM_PROC_hea=@Processo or hou.job_hea=@Processo or hou.hawb_hea=@Processo) and (cta.cd_tp_tx) <> 'XCA' and desp_dst_hea='N'
--Union
--
--		select 
--			Apelido APELIDO, nome_tp_tx,cta.dc_hem DC, 
--			vlr_org_hem Vlr_Org, vlr_pgto_rcto_hem Vlr_PG,cta.cd_tp_moeda,iSnULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMA'),1) Paridade,CTA.CD_TP_TX, CC.CD_tp_tx DebitoCC,hou.num_proc_hem Processo
--		from 
--			house_exp_mar hou
--			join cta_cte_hou_exp_mar CTA ON cta.num_proc_hem=hou.num_proc_hem and (left(cta.cd_tp_tx,1)='X' or cta.cd_cred_dev_hem=hou.cd_export_hem) --and (cta.cd_tp_tx <> 'XBA')-- and cta.dc_hem = 'D')
--			join pessoa pp on pp.cd_pes=hou.cd_export_hem
--			join tipo_taxa tt on tt.cd_tp_tx=cta.cd_tp_tx
--			left Join Caixa_hou_exp_mar cxa on cta.num_proc_hem=cxa.num_proc_hem and cta.cd_Tp_tx=cxa.cd_tp_tx and cta.dc_hem=cxa.dc_hem and num_lcto <> 'PROVISÓRIO'
--			left Join Custo_Cliente CC on Cta.num_proc_hem = CC.Num_Proc and CTA.Cd_tp_tx = CC.Cd_tp_tx
--			--left join paridade par on par.cd_tp_moeda=cta.cd_tp_moeda and PAR.cd_tp_par='IMM' AND CONVERT(datetime,DT_PAR,105)=@Dt_Par
--		WHERE 
--			(HOU.NUM_PROC_hem=@Processo or hou.job_hem=@processo or hou.hawb_hem=@processo) and (cta.cd_tp_tx) <> 'XCA' and desp_dst_hem='N'
--	
--
--
--	
--END







































GO
