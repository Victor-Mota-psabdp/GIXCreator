SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--26/11/2015 incluido and CTA.Ref_Acesso_NF_HIA <> 'P' cadu
CREATE procedure [dbo].[spPrestCC_Complementar_SEL]-- 'IMWAL20100701401', '06-03-2008'

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
		-- CtaCte A Crédito Contra o Consignee, sem ser ADT
			select
				APELIDO, TT.nome_tp_tx,	CTA.DC_HIA DC, CTA.Vlr_Org_HIA Vlr_Org, CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
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
				
				UPPER(CTA.CD_TP_TX),Null DebitoCC,CTA.Num_Proc_HIA Processo,Ref_Ctb_Tx
				,isnull(convert(varchar(12),CTA.Num_NF_HIA),'') NF, 
				isnull(CTA.Ref_Acesso_NF_HIA,'') [Site],
				Repasse_TX ,
				isnull(FARG.Dt_Fatura,GETDATE()) Emissao
			from 
				vwCliente HOU with(nolock)
				Left Join vwcta_Cte		CtA with(nolock)on HOU.num_proc=CtA.Num_Proc_HIA and HOU.cd_cliente = CTA.Cd_Cred_Dev_HIA and CtA.DC_HIA='C'
				Left Join vwCXAS		CXA with(nolock)on Cta.Num_Proc_HIA=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='C'
				Left Join Tipo_Taxa		TT	with(nolock)on CTA.CD_tp_tx = TT.CD_tp_tx
				Left Join Pessoa		PS	with(nolock)on HOU.cd_cliente = PS.cd_pes			
				Left Join vwFaturasValidas		FAt with(nolock)on fat.num_proc=CtA.Num_Proc_HIA and FAt.cd_tp_tx = CtA.cd_tp_Tx and fat.dc=CtA.DC_HIA
				Left Join vwFaturasValidasCHB	ITT with (nolock) on itt.FatCod <> @Fatcod and itt.Num_Proc=CTA.Num_Proc_HIA and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.DC_HIA						
				left join vwFaturasValidasArg FARG With(nolock) on CtA.Num_Proc_HIA= FARG.Num_Proc and CtA.cd_tp_tx = FARG.cd_tp_tx and CtA.DC_HIA = FARG.DC
			where 
				--CTA.Num_Proc_HIA=@Processo and CTA.Cd_tp_tx <> 'XCA'			
				--and fat.fatura_pc is null
				CTA.Num_Proc_HIA=@Processo and TT.Ref_Ctb_Tx not in ('PTC','ADT') --and CTA.Cd_tp_tx <> 'XCA'
				and Desp_Org_HIA='N' and itt.FatCod is null	and Fat.num_proc is null
				
		UNION
			-- CtaCte A Crédito Contra o Consignee,  ADT e com CXA
			select
				APELIDO, TT.nome_tp_tx,	CTA.DC_HIA DC, CTA.Vlr_Org_HIA Vlr_Org, CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
				CTA.cd_tp_moeda cd_tp_moeda,	
				
				(Case When CTA.Num_NF_HIA is not NULL and CTA.Ref_Acesso_NF_HIA <> 'P' Then --CC.Par_NF_HIA 
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
				
				UPPER(CTA.CD_TP_TX),Null DebitoCC,CTA.Num_Proc_HIA Processo,Ref_Ctb_Tx
				,isnull(convert(varchar(12),CTA.Num_NF_HIA),'') NF, 
				isnull(CTA.Ref_Acesso_NF_HIA,'') [Site],
				Repasse_TX ,
				isnull(FARG.Dt_Fatura,GETDATE()) Emissao
			from 
				vwCliente HOU with(nolock)
				Left Join vwcta_Cte		CtA with(nolock)on HOU.num_proc=CtA.Num_Proc_HIA and HOU.cd_cliente = CTA.Cd_Cred_Dev_HIA and CtA.DC_HIA='C'
				Left Join vwCXAS		CXA with(nolock)on Cta.Num_Proc_HIA=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='C'
				Left Join Tipo_Taxa		TT	with(nolock)on CTA.CD_tp_tx = TT.CD_tp_tx
				Left Join Pessoa		PS	with(nolock)on HOU.cd_cliente = PS.cd_pes				
				Left Join vwFaturasValidas		FAt with(nolock)on fat.num_proc=CtA.Num_Proc_HIA and FAt.cd_tp_tx = CtA.cd_tp_Tx and fat.dc=CtA.DC_HIA
				Left Join vwFaturasValidasCHB	ITT with (nolock) on itt.FatCod <> @Fatcod and itt.Num_Proc=CTA.Num_Proc_HIA and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.DC_HIA						
				left join vwFaturasValidasArg FARG With(nolock) on CtA.Num_Proc_HIA= FARG.Num_Proc and CtA.cd_tp_tx = FARG.cd_tp_tx and CtA.DC_HIA = FARG.DC
			where 
				--CTA.Num_Proc_HIA=@Processo and CTA.Cd_tp_tx <> 'XCA'			
				--and fat.fatura_pc is null
				CTA.Num_Proc_HIA=@Processo and TT.Ref_Ctb_Tx in ('ADT') --and CTA.Cd_tp_tx <> 'XCA'
				and Desp_Org_HIA='N' and itt.FatCod is null	and Fat.num_proc is null
				and cxa.Num_Lcto is not null
				

		UNION
		--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
			select
				APELIDO, TT.nome_tp_tx,'D' DC, CC.Vlr_Item_Custo Vlr_Org, 
				CC.vlr_Item_Custo Vlr_PG,
				'REL' cd_tp_moeda,	1 Paridade,				
				UPPER(CTA.CD_TP_TX),UPPER(CC.CD_tp_tx) DebitoCC,	CC.num_proc Processo,
				Ref_Ctb_Tx,
				isnull(convert(varchar(12),CTA.Num_NF_HIA),'') NF,
				isnull(CTA.Ref_Acesso_NF_HIA,'') [Site],
				Repasse_TX ,
				isnull(FARG.Dt_Fatura,GETDATE()) Emissao
			from 
				custo_cliente cc with(nolock)
				Left Join vwCXAS 		CXA	with(nolock)on CC.num_proc=CXA.num_proc_Hia and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
				Left Join vwcta_Cte		CtA with(nolock)on CC.num_proc=CtA.Num_Proc_HIA and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.DC_HIA='D'
				Left Join Tipo_Taxa		TT	with(nolock)on CC.CD_tp_tx = TT.CD_tp_tx
				Left Join vwCliente		HOU with(nolock)on CC.Num_proc = HOU.num_proc
				Left Join Pessoa		PS	with(nolock)on HOU.cd_cliente = PS.CD_pes				
				Left Join vwFaturasValidas	FAt with (nolock)on fat.num_proc=CtA.Num_Proc_HIA and FAt.cd_tp_tx = CtA.cd_tp_Tx and fat.dc=CtA.DC_HIA
				Left Join vwFaturasValidasCHB ITT with (nolock) on itt.FatCod <> @Fatcod and itt.Num_Proc=CTA.Num_Proc_HIA and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.DC_HIA						
				left join vwFaturasValidasArg FARG With(nolock) on CtA.Num_Proc_HIA= FARG.Num_Proc and CtA.cd_tp_tx = FARG.cd_tp_tx and CtA.DC_HIA = FARG.DC
			where 
				CC.num_proc=@Processo and num_lcto is null and cta.Num_Proc_HIA is null 
				and (Prestacao = 'S' or Prestacao is null)
				--and fat.fatura_pc is null
				and itt.FatCod is null and Fat.FatCod is null
				
		UNION 
		--Cta_Cte à D que está no Custo também
			select
				PS.APELIDO, TT.nome_tp_tx,	CTA.DC_HIA DC,CTA.Vlr_Org_HIA Vlr_Org,	CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
				CTA.cd_tp_moeda cd_tp_moeda,
				(Case When CTA.Num_NF_HIA is not NULL and CTA.Ref_Acesso_NF_HIA <> 'P' Then --CC.Par_NF_HIA 
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
				
				UPPER(CTA.CD_TP_TX),UPPER(CC.CD_tp_tx) DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx,
				isnull(convert(varchar(12),CTA.Num_NF_HIA),'') NF,
				isnull(CTA.Ref_Acesso_NF_HIA,'') [Site],
				Repasse_TX ,
				isnull(FARG.Dt_Fatura,GETDATE()) Emissao
			from 
				custo_cliente cc with(nolock)
				Left Join vwcta_Cte	CtA with(nolock)on CC.num_proc=CtA.Num_Proc_HIA and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.DC_HIA='D'
				Left Join vwCXAS	CXA with(nolock)on Cta.Num_Proc_HIA=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
				Left Join Tipo_Taxa	TT	with(nolock)on CC.CD_tp_tx = TT.CD_tp_tx
				Left Join vwCliente	HOU with(nolock)on CC.Num_proc = HOU.Num_proc
				Join Pessoa			PS	with(nolock)on HOU.cd_cliente = PS.CD_pes		
				Left Join vwFaturasValidas	FAt with (nolock)on fat.num_proc=CtA.Num_Proc_HIA and FAt.cd_tp_tx = CtA.cd_tp_Tx and fat.dc=CtA.DC_HIA
				Left Join vwFaturasValidasCHB ITT with (nolock) on itt.FatCod <> @Fatcod and itt.Num_Proc=CTA.Num_Proc_HIA and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.DC_HIA						
				left join vwFaturasValidasArg FARG With(nolock) on CtA.Num_Proc_HIA= FARG.Num_Proc and CtA.cd_tp_tx = FARG.cd_tp_tx and CtA.DC_HIA = FARG.DC
			where 
				CXA.num_proc_Hia=@Processo 
				and (Prestacao = 'S' or Prestacao is null) 
				and LEFT(CXA.CD_TP_tX,1)='X'
				--and fat.fatura_pc is null
				and ITT.FatCod is null and Fat.FatCod is null
				
		UNION			
		--Cta_Cte à D que não está no Custo também
			select
				APELIDO, TT.nome_tp_tx,	CTA.DC_HIA DC,DBO.VALOR(CTA.Vlr_Org_HIA,CTA.DC_HIA) Vlr_Org, 	
				CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
				'REL' cd_tp_moeda,	1 Paridade,				
				UPPER(CTA.CD_TP_TX) CD_TP_TX, 	Null DebitoCC,CTA.Num_Proc_HIA Processo,Ref_Ctb_Tx,
				isnull(convert(varchar(12),CTA.Num_NF_HIA),'') NF,
				isnull(CTA.Ref_Acesso_NF_HIA,'') [Site],
				Repasse_TX,
				isnull(FARG.Dt_Fatura,GETDATE()) Emissao
			from 
				vwCliente			HOU with(nolock)
				Left Join vwcta_Cte CtA with(nolock)on HOU.num_proc=CtA.Num_Proc_HIA and HOU.cd_cliente = CTA.Cd_Cred_Dev_HIA and CtA.DC_HIA='D'
				Left Join vwCXAS	CXA with(nolock)on Cta.Num_Proc_HIA=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
				Left Join Tipo_Taxa TT with(nolock)on CTA.CD_tp_tx = TT.CD_tp_tx
				Left Join Pessoa	PS with(nolock)on HOU.cd_cliente = PS.cd_pes				
				Left Join vwFaturasValidas		FAt with (nolock) on fat.num_proc=CtA.Num_Proc_HIA and CtA.cd_tp_Tx=FAt.cd_tp_tx and CtA.DC_HIA=fat.dc    
				Left Join vwFaturasValidasCHB	ITT with (nolock) on itt.FatCod <> @Fatcod and itt.Num_Proc=CTA.Num_Proc_HIA and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.DC_HIA
				left join vwFaturasValidasArg FARG With(nolock) on CtA.Num_Proc_HIA= FARG.Num_Proc and CtA.cd_tp_tx = FARG.cd_tp_tx and CtA.DC_HIA = FARG.DC
			where 
				CTA.Num_Proc_HIA=@Processo 
				and CTA.CD_TP_TX in ('IRT','PIS','IRR','cO2','RIS','IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
				--and CTA.CD_TP_TX in ('RIS','IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
				--and fat.fatura_pc is null
				and Fat.FatCod is null and ITT.FatCod is null

		UNION
		--Cta_Cte D que começa com X
			SELECT
				APELIDO,TT.NOME_TP_TX,CXA.dc_Hia DC, CXA.Vlr_Pgto_Rcto_Hia Vlr_Org, 
				CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,'REL' cd_tp_moeda,	
				--iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,
				1 Paridade,
				UPPER(CXA.CD_TP_TX) CD_TP_TX,NULL DebitoCC,CXA.num_proc_Hia Processo,Ref_Ctb_Tx
				,'' NF, 
				'' [Site],
				Repasse_TX,
				GETDATE() Emissao 
			FROM
				vwCXAS CXA with(nolock)
				JOIN TIPO_TAXA		TT with(nolock) ON TT.CD_TP_TX=CXA.CD_TP_TX
				Left Join Custo_Cliente CC with(nolock)on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.num_proc_Hia=CC.NUM_PROC
				JOIN vwCliente		HOU with(nolock)ON HOU.NUM_PROC=CXA.num_proc_Hia
				JOIN PESSOA			PP with(nolock)ON PP.CD_PES=cd_cliente				
				Left Join vwFaturasValidas		FAt with (nolock) on fat.num_proc=CXA.Num_Proc_HIA and CXA.cd_tp_Tx=FAt.cd_tp_tx and CXA.DC_HIA=fat.dc
				Left Join vwFaturasValidasCHB ITT with (nolock) on itt.FatCod <> @Fatcod and itt.Num_Proc=CXA.Num_Proc_HIA and itt.cd_tp_Tx=CXA.cd_tp_Tx and itt.dc=cxa.DC_HIA	
			WHERE
				CXA.num_proc_Hia=@Processo AND CXA.dc_Hia='D' AND CC.NUM_PROC IS NULL 
				AND  LEFT(CXA.CD_TP_tX,1)='X' and TT.Ref_Ctb_Tx <> 'PTC' --and CXA.CD_TP_TX NOT IN ('XBA') 
				--AND fat.fatura_pc IS NULL
				and Fat.FatCod is null and ITT.FatCod is null
			
		UNION
		--Cta_Cte D que começa com X sem cxa e com solicitação de pagamento
			SELECT
				APELIDO,TT.NOME_TP_TX,SOL.dc DC, SOL.Vlr_Pgto_Rcto Vlr_Org, 
				SOL.Vlr_Pgto_Rcto Vlr_PG,
				'REL' cd_tp_moeda,	1 Paridade,			
				UPPER(SOL.CD_TP_TX) CD_TP_TX,NULL DebitoCC,SOL.num_proc Processo,Ref_Ctb_Tx,'' NF,'' [Site],
				Repasse_TX,	GETDATE() Emissao 
			FROM
				vwSolPgtoCtaCteAprovadas	SOL with(nolock)
				Left Join vwCXAS			CXA with(nolock)on SOL.num_proc=CXA.num_proc_Hia and SOL.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia=SOL.DC
				JOIN TIPO_TAXA				TT with(nolock)ON TT.CD_TP_TX=SOL.CD_TP_TX
				Left Join Custo_Cliente		CC with(nolock)on SOL.CD_TP_TX=CC.CD_TP_TX AND SOL.num_proc=CC.NUM_PROC
				JOIN vwCliente				HOU with(nolock)ON HOU.NUM_PROC=SOL.num_proc
				JOIN PESSOA					PP with(nolock)ON PP.CD_PES=cd_cliente				
				Left Join vwFaturasValidas		FAt with (nolock) on fat.num_proc=SOL.num_proc and FAt.cd_tp_tx=SOL.cd_tp_Tx and SOL.DC=fat.dc
				Left Join vwFaturasValidasCHB ITT with (nolock) on itt.FatCod <> @Fatcod and itt.Num_Proc=SOL.num_proc and itt.cd_tp_Tx=SOL.CD_TP_TX and itt.dc=SOL.DC		
			WHERE
				SOL.num_proc=@Processo AND SOL.dc='D' 
				AND CC.NUM_PROC IS NULL 
				and CXA.Num_Proc_HIA is null
				AND LEFT(SOL.CD_TP_tX,1)='X' and TT.Ref_Ctb_Tx <> 'PTC'	
				--and CXA.CD_TP_TX NOT IN ('XBA') 
				--AND fat.fatura_pc IS NULL
				and Fat.FatCod is null and ITT.FatCod is null
					
		UNION
		--Cta_Cte à D que está no Custo também sem cxa e com solicitação de pagamento
			select
				PS.APELIDO, TT.nome_tp_tx,	CTA.DC_HIA DC,CTA.Vlr_Org_HIA Vlr_Org, 
				SOL.Vlr_Pgto_Rcto Vlr_PG,CTA.cd_tp_moeda cd_tp_moeda,
				(Case When CTA.Num_NF_HIA is not NULL and CTA.Ref_Acesso_NF_HIA <> 'P' Then --CC.Par_NF_HIA 
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
				
				UPPER(CTA.CD_TP_TX),UPPER(CC.CD_tp_tx) DebitoCC,CC.num_proc Processo,
				Ref_Ctb_Tx,
				isnull(convert(varchar(12),CTA.Num_NF_HIA),'') NF,
				isnull(CTA.Ref_Acesso_NF_HIA,'') [Site],
				Repasse_TX,
				isnull(FARG.Dt_Fatura,GETDATE()) Emissao
			from 
				custo_cliente cc with(nolock)
				Left Join vwcta_Cte		CtA with(nolock)on CC.num_proc=CtA.Num_Proc_HIA and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.DC_HIA='D'
				Left Join vwSolPgtoCtaCteAprovadas SOL with(nolock)on Cta.Num_Proc_HIA=SOL.num_proc and CtA.cd_tp_tx=SOL.cd_tp_tx and SOL.dc='D'
				Left Join vwCXAS		CXA with(nolock)on Cta.Num_Proc_HIA=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
				Left Join Tipo_Taxa		TT	with(nolock)on CC.CD_tp_tx = TT.CD_tp_tx
				Left Join vwCliente		HOU with(nolock)on CC.Num_proc = HOU.num_proc
				Join Pessoa				PS	with(nolock)on HOU.cd_cliente = PS.CD_pes				
				Left Join vwFaturasValidas		FAt with (nolock) on fat.num_proc=SOL.num_proc and FAt.cd_tp_tx=SOL.cd_tp_Tx and fat.dc=SOL.DC
				Left Join vwFaturasValidasCHB	ITT with (nolock) on itt.FatCod <> @Fatcod and itt.Num_Proc=SOL.num_proc and itt.cd_tp_Tx=SOL.CD_TP_TX and itt.dc=SOL.DC
				left join vwFaturasValidasArg FARG With(nolock) on CtA.Num_Proc_HIA= FARG.Num_Proc and CtA.cd_tp_tx = FARG.cd_tp_tx and CtA.DC_HIA = FARG.DC
			where 
				SOL.num_proc=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(SOL.CD_TP_tX,1)='X'
				--and fat.fatura_pc is null
				and CXA.Num_Proc_HIA is null
				and Fat.FatCod is null and ITT.FatCod is null 
			
	END
	
	update 
		T  
	set 
		T.Paridade=T1.Paridade
	from 
		@TempTaxas as T
	JOIN
		@TempTaxas  as T1
		on T.cd_tp_Moeda = T1.cd_tp_moeda and T1.NF is not NULL
			
	select * from @TempTaxas where month(Emissao) = MONTH(getdate())


/*Menos velha
--incluido a taxa IRR - Imposto Retido na Fonte em todos os modais
/*incluido os itens: NF, SITE e Repasse TX pra regra de:
Verifica se há alguma taxa com Repasse_NF como N e nao tem numero de NF amarrado 
Carrega_bdp - dia 25/7/13 - Cadu*/ 
--incluido a paridade,23/09/2013
--incluido pra verificar a solicitacao de pagamento no local do caixa = cadu 20/3/15
--incluido verificar a data de emissao da nf, pra so trazer o que for do mes  - cadu 30-07-2015

ALTER procedure [dbo].[spPrestCC_Complementar]-- 'IMWAL20100701401', '06-03-2008'

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
		Repasse_TX		varchar(1),
		Emissao			Datetime	
	)
IF len(@Processo) = 16
	BEGIN
		if left(@Processo,2) = 'EO'
			Begin
			Insert @TempTaxas
			-- CtaCte A Crédito Contra o Consignee
				select
 					APELIDO, TT.nome_tp_tx,	CTA.dc_HEO DC, 	CTA.vlr_org_HEO Vlr_Org, CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda, 
--					ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					(case When
							CTA.Num_NF_HEO is not NULL and CTA.ref_acesso_nf_heO <> 'P'
						Then 
							CTA.Par_NF_HeO 
						else 
							dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
					CTA.CD_TP_TX,
					Null DebitoCC,CTA.Num_proc_HEO Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_heo,'') NF, 
					isnull(CTA.ref_acesso_nf_heo,'') [Site],
					Repasse_TX ,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					House_EXP_OUT HOU
					Left Join cta_cte_hou_EXP_OUT CtA on HOU.num_proc_HEO=CtA.num_proc_HEO and HOU.cd_Export_HEO = CTA.cd_cred_dev_HEO and CtA.dc_HEO='C'
					Left Join vwCXAS CXA on Cta.num_proc_HEO=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.cd_Export_HEO = PS.cd_pes
					Left Join Fatura_CHB_ITEM ITT on left(fatura_cc,16)=CTA.num_proc_heo and itt.cd_tp_Tx=CTA.cd_tp_Tx 
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'						
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HEO and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HEO
				where 
					CTA.num_proc_HEO=@Processo and CTA.Cd_tp_tx <> 'XCA'			
					and fat.fatura_pc is null

			Union
				--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
				select
					APELIDO, TT.nome_tp_tx,'D' DC, CC.Vlr_Item_Custo Vlr_Org, 
					CC.vlr_Item_Custo Vlr_PG,'REL' cd_tp_moeda,	ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,	CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_heo,'') NF, 
					isnull(CTA.ref_acesso_nf_heo,'') [Site],
					Repasse_TX ,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					custo_cliente cc
					Left Join vwCXAS		CXA	on CC.num_proc=CXA.num_proc_Hia and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join cta_cte_hou_EXP_OUT	CtA on CC.num_proc=CtA.num_proc_HEO and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_HEO='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_EXP_OUT			HOU on CC.Num_proc = HOU.Num_proc_HEO
					Left Join Pessoa				PS	on HOU.cd_Export_HEO = PS.CD_pes
--					Left Join item_fat ITT on ITT.num_proc=CC.num_proc and itt.cd_tp_Tx=CC.cd_tp_Tx --and itt.dc=CC.dc_heo
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_heo and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HEO and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HEO
				where 
					CC.num_proc=@Processo and num_lcto is null and cta.num_proc_HEO is null 
					and (Prestacao = 'S' or Prestacao is null)
					and fat.fatura_pc is null
				
			Union 
				--Cta_Cte à D que está no Custo também
				select
 					PS.APELIDO, TT.nome_tp_tx,	CTA.dc_heo DC,CTA.vlr_org_heo Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,CTA.cd_tp_moeda cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_heo,'') NF, 
					isnull(CTA.ref_acesso_nf_heo,'') [Site],
					Repasse_TX ,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					custo_cliente cc
					Left Join cta_cte_hou_exp_OUT	CtA on CC.num_proc=CtA.num_proc_heo and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_heo='D'
					Left Join vwCXAS		CXA on Cta.num_proc_heo=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_exp_OUT			HOU on CC.Num_proc = HOU.Num_proc_heo
					Join Pessoa				PS	on HOU.cd_export_heo = PS.CD_pes
--					Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_heo and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_heo
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_heo and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HEO and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HEO
				where 
					CXA.num_proc_Hia=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					and fat.fatura_pc is null
				
			union			
				--Cta_Cte à D que não está no Custo também
				select
 					APELIDO, TT.nome_tp_tx,	CTA.dc_HEO DC,CTA.vlr_org_HEO Vlr_Org, 	CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
					'REL' cd_tp_moeda,	iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,CTA.Num_proc_Heo Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_heo,'') NF, 
					isnull(CTA.ref_acesso_nf_heo,'') [Site],
					Repasse_TX ,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					House_exp_out HOU
					Left Join cta_cte_hou_exp_out CtA on HOU.num_proc_HEO=CtA.num_proc_HEO and HOU.cd_export_HEO = CTA.cd_cred_dev_HEO and CtA.dc_HEO='D'
					Left Join vwCXAS CXA on Cta.num_proc_Heo=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.cd_export_heo = PS.cd_pes
--					Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_heo and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_heo
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_heo and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HEO and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HEO
				where 
					CTA.num_proc_heo=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and fat.fatura_pc is null

			union
				--Cta_Cte D que começa com X
				SELECT
					APELIDO,TT.NOME_TP_TX,CXA.dc_Hia DC, CXA.Vlr_Pgto_Rcto_Hia Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,'REL' cd_tp_moeda,	iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,
					CXA.CD_TP_TX CD_TP_TX,NULL DebitoCC,CXA.num_proc_Hia Processo,Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX,
					GETDATE() Emissao 
				FROM
					vwCXAS CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.num_proc_Hia=CC.NUM_PROC
					JOIN HOUSE_EXP_OUT HOU ON HOU.NUM_PROC_HEO=CXA.num_proc_Hia
					JOIN PESSOA PP ON PP.CD_PES=CD_Export_HEO
--					Left Join item_fat ITT on ITT.num_proc=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.cd_tp_Tx and ITT.dc=CXA.dc_Hia
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'	
				WHERE
					CXA.num_proc_Hia=@Processo AND CXA.dc_Hia='D' AND CC.NUM_PROC IS NULL 
					AND  LEFT(CXA.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
					AND fat.fatura_pc IS NULL
			
			union
				--Cta_Cte D que começa com X sem cxa e com solicitação de pagamento
				SELECT
					APELIDO,TT.NOME_TP_TX,SOL.dc DC, SOL.Vlr_Pgto_Rcto Vlr_Org, 
					SOL.Vlr_Pgto_Rcto Vlr_PG,'REL' cd_tp_moeda,	iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,
					SOL.CD_TP_TX CD_TP_TX,NULL DebitoCC,SOL.num_proc Processo,Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX,
					GETDATE() Emissao 
				FROM
					vwSolPgtoCtaCteAprovadas SOL
					Left Join vwCXAS CXA on SOL.num_proc=CXA.num_proc_Hia and SOL.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia=SOL.DC
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=SOL.CD_TP_TX
					Left Join Custo_Cliente CC on SOL.CD_TP_TX=CC.CD_TP_TX AND SOL.num_proc=CC.NUM_PROC
					JOIN HOUSE_EXP_OUT HOU ON HOU.NUM_PROC_HEO=SOL.num_proc
					JOIN PESSOA PP ON PP.CD_PES=CD_Export_HEO
--					Left Join item_fat ITT on ITT.num_proc=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.cd_tp_Tx and ITT.dc=CXA.dc_Hia
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=SOL.num_proc and itt.cd_tp_Tx=SOL.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'	
				WHERE
					SOL.num_proc=@Processo AND SOL.dc='D' AND CC.NUM_PROC IS NULL 
					and CXA.Num_Proc_HIA is null
					AND LEFT(SOL.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
					AND fat.fatura_pc IS NULL
					
			Union 
				--Cta_Cte à D que está no Custo também sem cxa e com solicitação de pagamento
				select
 					PS.APELIDO, TT.nome_tp_tx,	CTA.dc_heo DC,CTA.vlr_org_heo Vlr_Org, 
					SOL.Vlr_Pgto_Rcto Vlr_PG,CTA.cd_tp_moeda cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_heo,'') NF, 
					isnull(CTA.ref_acesso_nf_heo,'') [Site],
					Repasse_TX ,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					custo_cliente cc
					Left Join cta_cte_hou_exp_OUT	CtA on CC.num_proc=CtA.num_proc_heo and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_heo='D'
					Left Join vwSolPgtoCtaCteAprovadas SOL on Cta.num_proc_heo=SOL.num_proc and CtA.cd_tp_tx=SOL.cd_tp_tx and SOL.dc='D'
					Left Join vwCXAS		CXA on Cta.num_proc_heo=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join Tipo_Taxa		TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_exp_OUT	HOU on CC.Num_proc = HOU.Num_proc_heo
					Join Pessoa				PS	on HOU.cd_export_heo = PS.CD_pes
--					Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_heo and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_heo
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_heo and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HEO and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HEO
				where 
					SOL.num_proc=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(SOL.CD_TP_tX,1)='X'
					and fat.fatura_pc is null
					and CXA.Num_Proc_HIA is null 
			
			end
	
	else
		if left(@Processo,2) = 'IO'
			Begin
			Insert @TempTaxas
				-- CtaCte A Crédito Contra o Consignee
				select
 					APELIDO, TT.nome_tp_tx,	CTA.dc_HIO DC, 	CTA.vlr_org_HIO Vlr_Org, CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
--					ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					(case When
							CTA.Num_NF_HIO is not NULL and CTA.ref_acesso_nf_HIO <> 'P'
						Then 
							CTA.Par_NF_HIO 
						else 
							dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,

					CTA.CD_TP_TX,Null DebitoCC,	CTA.Num_proc_HIO Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hio,'') NF, 
					isnull(CTA.ref_acesso_nf_hio,'') [Site],
					Repasse_TX ,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					House_IMP_OUT HOU
					Left Join cta_cte_hou_IMP_OUT CtA on HOU.num_proc_HIO=CtA.num_proc_HIO and HOU.CD_CONSIG_HIO = CTA.cd_cred_dev_HIO and CtA.dc_HIO='C'
					Left Join vwCXAS CXA on Cta.num_proc_HIO=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.CD_CONSIG_HIO = PS.cd_pes
	--				Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_HIO and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_HIO
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hio and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HIO and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HIO
				where 
					CTA.num_proc_HIO=@Processo and CTA.Cd_tp_tx <> 'XCA'			
					and fat.fatura_pc is null
			Union
				--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
				select
 					APELIDO, TT.nome_tp_tx,	'D' DC, CC.Vlr_Item_Custo Vlr_Org, CC.vlr_Item_Custo Vlr_PG,
					'REL' cd_tp_moeda,ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hio,'') NF, 
					isnull(CTA.ref_acesso_nf_hio,'') [Site],
					Repasse_TX ,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					custo_cliente cc
					Left Join vwCXAS		CXA	on CC.num_proc=CXA.num_proc_Hia and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join cta_cte_hou_IMP_OUT	CtA on CC.num_proc=CtA.num_proc_HIO and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_HIO='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_IMP_OUT			HOU on CC.Num_proc = HOU.Num_proc_HIO
					Left Join Pessoa				PS	on HOU.CD_CONSIG_HIO = PS.CD_pes
	--				Left Join item_fat ITT on ITT.num_proc=CC.num_proc and itt.cd_tp_Tx=CC.cd_tp_Tx --and itt.dc=CC.dc_HIO
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hio and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HIO and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HIO
				where 
					CC.num_proc=@Processo and num_lcto is null and cta.num_proc_HIO is null 
					and (Prestacao = 'S' or Prestacao is null) and fat.fatura_pc is null
				
			Union
				--Cta_Cte à D que está no Custo também
				select
 					PS.APELIDO, TT.nome_tp_tx,CTA.dc_HIO DC,CTA.vlr_org_HIO Vlr_Org, CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hio,'') NF, 
					isnull(CTA.ref_acesso_nf_hio,'') [Site],
					Repasse_TX ,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					custo_cliente cc
					Left Join cta_cte_hou_IMP_OUT	CtA on CC.num_proc=CtA.num_proc_HIO and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_HIO='D'
					Left Join vwCXAS		CXA on Cta.num_proc_HIO=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_IMP_OUT			HOU on CC.Num_proc = HOU.Num_proc_HIO
					Join Pessoa				PS	on HOU.CD_CONSIG_HIO = PS.CD_pes
	--				Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_HIO and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_HIO
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hio and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HIO and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HIO
				where 
					CXA.num_proc_Hia=@Processo and 
					(Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					and fat.fatura_pc is null
			
			Union
				--Cta_Cte à D que não está no Custo também
				select
 					APELIDO, TT.nome_tp_tx,	CTA.dc_HIO DC, CTA.vlr_org_HIO Vlr_Org, CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
					'REL' cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,	CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,CTA.Num_proc_HIO Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hio,'') NF, 
					isnull(CTA.ref_acesso_nf_hio,'') [Site],
					Repasse_TX ,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					House_IMP_OUT HOU
					Left Join cta_cte_hou_IMP_OUT CtA on HOU.num_proc_HIO=CtA.num_proc_HIO and HOU.CD_CONSIG_HIO = CTA.cd_cred_dev_HIO and CtA.dc_HIO='D'
					Left Join vwCXAS CXA on Cta.num_proc_HIO=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.CD_CONSIG_HIO = PS.cd_pes
	--				Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_HIO and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_HIO
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hio and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HIO and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HIO
				where 
					CTA.num_proc_HIO=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and fat.fatura_pc is null

			union
				--Cta_Cte D que começa com X
				SELECT
					APELIDO,TT.NOME_TP_TX,CXA.dc_Hia DC,CXA.Vlr_Pgto_Rcto_Hia Vlr_Org, 	CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
					'REL' cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,CXA.CD_TP_TX CD_TP_TX,
					NULL DebitoCC,CXA.num_proc_Hia Processo,Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX ,
					GETDATE() Emissao
				FROM
					vwCXAS CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.num_proc_Hia=CC.NUM_PROC
					JOIN HOUSE_IMP_OUT HOU ON HOU.NUM_PROC_HIO=CXA.num_proc_Hia
					JOIN PESSOA PP ON PP.CD_PES=CD_CONSIG_HIO
	--				Left Join item_fat ITT on ITT.num_proc=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.cd_tp_Tx and ITT.dc=CXA.dc_Hia
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					CXA.num_proc_Hia=@Processo AND CXA.dc_Hia='D' AND CC.NUM_PROC IS NULL 
					AND  LEFT(CXA.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
					AND fat.fatura_pc IS NULL
					
			union
				--Cta_Cte D que começa com X sem cxa e com solicitação de pagamento
				SELECT
					APELIDO,TT.NOME_TP_TX,SOL.dc DC,SOL.Vlr_Pgto_Rcto Vlr_Org, 	SOL.Vlr_Pgto_Rcto Vlr_PG,
					'REL' cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,SOL.CD_TP_TX CD_TP_TX,
					NULL DebitoCC,SOL.num_proc Processo,Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX ,
					GETDATE() Emissao
				FROM
					vwSolPgtoCtaCteAprovadas SOL
					left join vwCXAS CXA on SOL.num_proc=CXA.num_proc_HIA and SOL.cd_tp_tx=CXA.cd_tp_tx and SOL.DC=cxa.DC_HIA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=SOL.CD_TP_TX
					Left Join Custo_Cliente CC on SOL.CD_TP_TX=CC.CD_TP_TX AND SOL.num_proc=CC.NUM_PROC
					JOIN HOUSE_IMP_OUT HOU ON HOU.NUM_PROC_HIO=SOL.num_proc
					JOIN PESSOA PP ON PP.CD_PES=CD_CONSIG_HIO
	--				Left Join item_fat ITT on ITT.num_proc=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.cd_tp_Tx and ITT.dc=CXA.dc_Hia
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=SOL.num_proc and itt.cd_tp_Tx=SOL.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					SOL.num_proc=@Processo AND SOL.dc='D' AND CC.NUM_PROC IS NULL 
					and CXA.Num_Proc_HIA is null
					AND  LEFT(SOL.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
					AND fat.fatura_pc IS NULL
					
			Union
				--Cta_Cte à D que está no Custo também sem cxa e com solicitação de pagamento
				select
 					PS.APELIDO, TT.nome_tp_tx,CTA.dc_HIO DC,CTA.vlr_org_HIO Vlr_Org, SOL.Vlr_Pgto_Rcto Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hio,'') NF, 
					isnull(CTA.ref_acesso_nf_hio,'') [Site],
					Repasse_TX ,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					custo_cliente cc
					Left Join cta_cte_hou_IMP_OUT	CtA on CC.num_proc=CtA.num_proc_HIO and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_HIO='D'
					Left Join vwSolPgtoCtaCteAprovadas SOL on Cta.num_proc_HIO=SOL.num_proc and CtA.cd_tp_tx=SOL.cd_tp_tx and SOL.dc='D'
					Left Join vwCXAS		CXA on Cta.num_proc_HIO=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join Tipo_Taxa		TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_IMP_OUT	HOU on CC.Num_proc = HOU.Num_proc_HIO
					Join Pessoa				PS	on HOU.CD_CONSIG_HIO = PS.CD_pes
	--				Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_HIO and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_HIO
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hio and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HIO and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HIO
				where 
					SOL.num_proc=@Processo and 
					(Prestacao = 'S' or Prestacao is null) and LEFT(SOL.CD_TP_tX,1)='X'
					and fat.fatura_pc is null				
					and CXA.Num_Proc_HIA is null 
					
			end
			
	else	
		if left(@Processo,2) = 'IA'
			Begin
			Insert @TempTaxas
			-- CtaCte A Crédito Contra o Consignee
				select
					APELIDO, TT.nome_tp_tx,	CTA.dc_hia DC, 	CTA.vlr_org_hia Vlr_Org, CXA.Vlr_Pgto_Rcto_hia Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
--					ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					(case When
							CTA.Num_NF_HIA is not NULL and CTA.ref_acesso_nf_HIA <> 'P'
						Then 
							CTA.Par_NF_HIA 
						else 
							dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
					CTA.CD_TP_TX,Null DebitoCC,	CTA.Num_proc_hia Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hia,'') NF, 
					isnull(CTA.ref_acesso_nf_hia,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					House_imp_aer HOU
					Left Join cta_cte_hou_imp_aer CtA on HOU.num_proc_hia=CtA.num_proc_hia and HOU.CD_CONSIG_hia = CTA.cd_cred_dev_hia and CtA.dc_hia='C'
					Left Join vwCXAS CXA on Cta.num_proc_hia=CXA.num_proc_hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.CD_CONSIG_hia = PS.cd_pes
	--				Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_hia and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hia
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hia and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HIA and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HIA
				where 
					CTA.num_proc_hia=@Processo and CTA.Cd_tp_tx <> 'XCA'			
					and fat.fatura_pc is null
				
			Union
			--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
				select
					APELIDO, TT.nome_tp_tx,	'D' DC, CC.Vlr_Item_Custo Vlr_Org, CC.vlr_Item_Custo Vlr_PG,
					'REL' cd_tp_moeda,ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hia,'') NF, 
					isnull(CTA.ref_acesso_nf_hia,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					custo_cliente cc
					Left Join vwCXAS		CXA	on CC.num_proc=CXA.num_proc_hia and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='D'
					Left Join cta_cte_hou_imp_aer	CtA on CC.num_proc=CtA.num_proc_hia and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_hia='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_imp_aer			HOU on CC.Num_proc = HOU.Num_proc_hia
					Left Join Pessoa				PS	on HOU.CD_CONSIG_hia = PS.CD_pes
	--				Left Join item_fat ITT on ITT.num_proc=CC.num_proc and itt.cd_tp_Tx=CC.cd_tp_Tx --and itt.dc=CC.dc_him
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hia and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HIA and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HIA
				where 
					CC.num_proc=@Processo and num_lcto is null and cta.num_proc_hia is null 
					and (Prestacao = 'S' or Prestacao is null) and fat.fatura_pc is null
				
			Union
				--Cta_Cte à D que está no Custo também
				select
					PS.APELIDO, TT.nome_tp_tx,CTA.dc_hia DC,CTA.vlr_org_hia Vlr_Org, CXA.vlr_pgto_rcto_hia Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hia,'') NF, 
					isnull(CTA.ref_acesso_nf_hia,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					custo_cliente cc
					Left Join cta_cte_hou_imp_aer	CtA on CC.num_proc=CtA.num_proc_hia and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_hia='D'
					Left Join vwCXAS		CXA on Cta.num_proc_hia=CXA.num_proc_hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_imp_aer			HOU on CC.Num_proc = HOU.Num_proc_hia
					Join Pessoa						PS	on HOU.CD_CONSIG_hia = PS.CD_pes
	--				Left Join item_fat				ITT on ITT.num_proc=CTA.num_proc_hia and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hia
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hia and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HIA and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HIA
				where 
					CXA.num_proc_hia=@Processo and 
					(Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					and fat.fatura_pc is null
			
			Union
				--Cta_Cte à D que não está no Custo também
				select
					APELIDO, TT.nome_tp_tx,	CTA.dc_hia DC, CTA.vlr_org_hia Vlr_Org, CXA.Vlr_Pgto_Rcto_hia Vlr_PG,
					'REL' cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,	CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,CTA.Num_proc_hia Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hia,'') NF, 
					isnull(CTA.ref_acesso_nf_hia,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					House_imp_aer HOU
					Left Join cta_cte_hou_imp_aer CtA on HOU.num_proc_hia=CtA.num_proc_hia and HOU.CD_CONSIG_hia = CTA.cd_cred_dev_hia and CtA.dc_hia='D'
					Left Join vwCXAS CXA on Cta.num_proc_hia=CXA.num_proc_hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.CD_CONSIG_hia = PS.cd_pes
	--				Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_hia and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hia
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hia and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HIA and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HIA
				where 
					CTA.num_proc_hia=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and fat.fatura_pc is null

			union
				--Cta_Cte D que começa com X
				SELECT
					APELIDO,TT.NOME_TP_TX,CXA.dc_hia DC,CXA.vlr_pgto_rcto_hia Vlr_Org, 	CXA.vlr_pgto_rcto_hia Vlr_PG,
					'REL' cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,CXA.CD_TP_TX CD_TP_TX,
					NULL DebitoCC,CXA.num_proc_hia Processo,Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX ,
					GETDATE() Emissao
				FROM
					vwCXAS CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_hia=CC.NUM_PROC
					JOIN HOUSE_imp_aer HOU ON HOU.NUM_PROC_hia=CXA.NUM_PROC_hia
					JOIN PESSOA PP ON PP.CD_PES=CD_CONSIG_hia
	--				Left Join item_fat ITT on ITT.num_proc=CXA.num_proc_hia and itt.cd_tp_Tx=CXA.cd_tp_Tx and ITT.dc=CXA.dc_hia
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CXA.NUM_PROC_hia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					CXA.num_proc_hia=@Processo AND CXA.DC_hia='D' AND CC.NUM_PROC IS NULL 
					AND  LEFT(CXA.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
					AND fat.fatura_pc IS NULL
			
			union
				--Cta_Cte D que começa com X sem cxa e com solicitação de pagamento
				SELECT
					APELIDO,TT.NOME_TP_TX,SOL.dc DC,SOL.vlr_pgto_rcto Vlr_Org, 	SOL.vlr_pgto_rcto Vlr_PG,
					'REL' cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,SOL.CD_TP_TX CD_TP_TX,
					NULL DebitoCC,SOL.num_proc Processo,Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX ,
					GETDATE() Emissao
				FROM
					vwSolPgtoCtaCteAprovadas SOL
					left join vwCXAS CXA on SOL.num_proc=CXA.num_proc_HIA and SOL.cd_tp_tx=CXA.cd_tp_tx and SOL.DC=cxa.DC_HIA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=SOL.CD_TP_TX
					Left Join Custo_Cliente CC on SOL.CD_TP_TX=CC.CD_TP_TX AND SOL.NUM_PROC=CC.NUM_PROC
					JOIN HOUSE_imp_aer HOU ON HOU.NUM_PROC_hia=SOL.NUM_PROC
					JOIN PESSOA PP ON PP.CD_PES=CD_CONSIG_hia
	--				Left Join item_fat ITT on ITT.num_proc=CXA.num_proc_hia and itt.cd_tp_Tx=CXA.cd_tp_Tx and ITT.dc=CXA.dc_hia
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=SOL.NUM_PROC and itt.cd_tp_Tx=SOL.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					SOL.num_proc=@Processo AND SOL.DC='D' AND CC.NUM_PROC IS NULL 
					and CXA.num_proc_HIA is null
					AND  LEFT(SOL.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
					AND fat.fatura_pc IS NULL
					
			Union
				--Cta_Cte à D que está no Custo também sem cxa e com solicitação de pagamento
				select
					PS.APELIDO, TT.nome_tp_tx,CTA.dc_hia DC,CTA.vlr_org_hia Vlr_Org, SOL.vlr_pgto_rcto Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hia,'') NF, 
					isnull(CTA.ref_acesso_nf_hia,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					custo_cliente cc
					Left Join cta_cte_hou_imp_aer	CtA on CC.num_proc=CtA.num_proc_hia and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_hia='D'
					Left Join vwSolPgtoCtaCteAprovadas SOL on Cta.num_proc_hia=SOL.num_proc and CtA.cd_tp_tx=SOL.cd_tp_tx and SOL.dc='D'
					Left Join vwCXAS		CXA on Cta.num_proc_hia=CXA.num_proc_hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_imp_aer			HOU on CC.Num_proc = HOU.Num_proc_hia
					Join Pessoa						PS	on HOU.CD_CONSIG_hia = PS.CD_pes
	--				Left Join item_fat				ITT on ITT.num_proc=CTA.num_proc_hia and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hia
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hia and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HIA and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HIA
				where 
					SOL.num_proc=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(SOL.CD_TP_tX,1)='X'
					and fat.fatura_pc is null
					and CXA.num_proc_HIA is null
			
			end

	else
		if left(@Processo,2) = 'EA'
			Begin
			Insert @TempTaxas
		-- CtaCte A Crédito Contra o Consignee
				select
					APELIDO, TT.nome_tp_tx,	CTA.dc_hea DC, 	CTA.vlr_org_hea Vlr_Org, CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda, 
--					ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					(case When
							CTA.Num_NF_HEA is not NULL and CTA.ref_acesso_nf_HEA <> 'P'
						Then 
							CTA.Par_NF_HEA 
						else 
							dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
					CTA.CD_TP_TX,
					Null DebitoCC,CTA.Num_proc_hea Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hea,'') NF, 
					isnull(CTA.ref_acesso_nf_hea,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					House_exp_aer HOU
					Left Join cta_cte_hou_exp_aer CtA on HOU.num_proc_hea=CtA.num_proc_hea and HOU.cd_Export_hea = CTA.cd_cred_dev_hea and CtA.dc_hea='C'
					Left Join vwCXAS CXA on Cta.num_proc_hea=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.cd_Export_hea = PS.cd_pes
--					Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_hea and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hea
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hea and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HEA and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HEA
				where 
					CTA.num_proc_hea=@Processo and CTA.Cd_tp_tx <> 'XCA'			
					and fat.fatura_pc is null

			Union
				--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
				select
					APELIDO, TT.nome_tp_tx,'D' DC, CC.Vlr_Item_Custo Vlr_Org, 
					CC.vlr_Item_Custo Vlr_PG,'REL' cd_tp_moeda,	ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,	CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hea,'') NF, 
					isnull(CTA.ref_acesso_nf_hea,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					custo_cliente cc
					Left Join vwCXAS		CXA	on CC.num_proc=CXA.num_proc_Hia and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join cta_cte_hou_exp_aer	CtA on CC.num_proc=CtA.num_proc_hea and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_hea='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_exp_aer			HOU on CC.Num_proc = HOU.Num_proc_hea
					Left Join Pessoa				PS	on HOU.cd_Export_hea = PS.CD_pes
--					Left Join item_fat				ITT on ITT.num_proc=CC.num_proc and itt.cd_tp_Tx=CC.cd_tp_Tx --and itt.dc=CC.dc_hem
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hea and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HEA and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HEA
				where 
					CC.num_proc=@Processo and num_lcto is null and cta.num_proc_hea is null 
					and (Prestacao = 'S' or Prestacao is null)
					and fat.fatura_pc is null
				
			Union 
				--Cta_Cte à D que está no Custo também
				select
					PS.APELIDO, TT.nome_tp_tx,	CTA.dc_hea DC,CTA.vlr_org_hea Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,CTA.cd_tp_moeda cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hea,'') NF, 
					isnull(CTA.ref_acesso_nf_hea,'') [Site],
					Repasse_TX ,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					custo_cliente cc
					Left Join cta_cte_hou_exp_aer	CtA on CC.num_proc=CtA.num_proc_hea and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_hea='D'
					Left Join vwCXAS		CXA on Cta.num_proc_hea=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_exp_aer			HOU on CC.Num_proc = HOU.Num_proc_hea
					Join Pessoa						PS	on HOU.cd_export_hea = PS.CD_pes
--					Left Join item_fat				ITT on ITT.num_proc=CTA.num_proc_hea and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hea
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hea and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HEA and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HEA
				where 
					CXA.num_proc_Hia=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					and fat.fatura_pc is null
				
			union			
				--Cta_Cte à D que não está no Custo também
				select
					APELIDO, TT.nome_tp_tx,	CTA.dc_hea DC,CTA.vlr_org_hea Vlr_Org, 	CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
					'REL' cd_tp_moeda,	iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,CTA.Num_proc_hea Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hea,'') NF, 
					isnull(CTA.ref_acesso_nf_hea,'') [Site],
					Repasse_TX ,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					House_exp_aer HOU
					Left Join cta_cte_hou_exp_aer	CtA on HOU.num_proc_hea=CtA.num_proc_hea and HOU.cd_export_hea = CTA.cd_cred_dev_hea and CtA.dc_hea='D'
					Left Join vwCXAS		CXA on Cta.num_proc_hea=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join Tipo_Taxa				TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa				PS on HOU.cd_export_hea = PS.cd_pes
--					Left Join item_fat				ITT on ITT.num_proc=CTA.num_proc_hea and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hea
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hea and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HEA and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HEA
				where 
					CTA.num_proc_hea=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and fat.fatura_pc is null

			union
				--Cta_Cte D que começa com X
				SELECT
					APELIDO,TT.NOME_TP_TX,CXA.dc_Hia DC, CXA.Vlr_Pgto_Rcto_Hia Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,'REL' cd_tp_moeda,	iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,
					CXA.CD_TP_TX CD_TP_TX,NULL DebitoCC,CXA.num_proc_Hia Processo,Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX ,
					GETDATE() Emissao
				FROM
					vwCXAS CXA
					JOIN TIPO_TAXA			TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.num_proc_Hia=CC.NUM_PROC
					JOIN HOUSE_exp_aer		HOU ON HOU.NUM_PROC_hea=CXA.num_proc_Hia
					JOIN PESSOA				PP ON PP.CD_PES=CD_Export_hea
--					Left Join item_fat		ITT on ITT.num_proc=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.cd_tp_Tx and ITT.dc=CXA.dc_Hia
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					CXA.num_proc_Hia=@Processo AND CXA.dc_Hia='D' AND CC.NUM_PROC IS NULL 
					AND  LEFT(CXA.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
					AND fat.fatura_pc IS NULL
					
			union
				--Cta_Cte D que começa com X sem cxa e com solicitação de pagamento
				SELECT
					APELIDO,TT.NOME_TP_TX,SOL.dc DC, SOL.Vlr_Pgto_Rcto Vlr_Org, 
					SOL.Vlr_Pgto_Rcto Vlr_PG,'REL' cd_tp_moeda,	iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,
					SOL.CD_TP_TX CD_TP_TX,NULL DebitoCC,SOL.num_proc Processo,Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX ,
					GETDATE() Emissao
				FROM
					vwSolPgtoCtaCteAprovadas SOL
					left join vwCXAS CXA on SOL.num_proc=CXA.num_proc_HIA and SOL.cd_tp_tx=CXA.cd_tp_tx and SOL.DC=cxa.DC_HIA
					JOIN TIPO_TAXA			TT ON TT.CD_TP_TX=SOL.CD_TP_TX
					Left Join Custo_Cliente CC on SOL.CD_TP_TX=CC.CD_TP_TX AND SOL.num_proc=CC.NUM_PROC
					JOIN HOUSE_exp_aer		HOU ON HOU.NUM_PROC_hea=SOL.num_proc
					JOIN PESSOA				PP ON PP.CD_PES=CD_Export_hea
--					Left Join item_fat		ITT on ITT.num_proc=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.cd_tp_Tx and ITT.dc=CXA.dc_Hia
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=SOL.num_proc and itt.cd_tp_Tx=SOL.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					SOL.num_proc=@Processo AND SOL.dc='D' AND CC.NUM_PROC IS NULL 
					and CXA.num_proc_HIA is null
					AND  LEFT(SOL.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
					AND fat.fatura_pc IS NULL
					
			Union 
				--Cta_Cte à D que está no Custo também sem cxa e com solicitação de pagamento
				select
					PS.APELIDO, TT.nome_tp_tx,	CTA.dc_hea DC,CTA.vlr_org_hea Vlr_Org, 
					SOL.Vlr_Pgto_Rcto Vlr_PG,CTA.cd_tp_moeda cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hea,'') NF, 
					isnull(CTA.ref_acesso_nf_hea,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao 
				from 
					custo_cliente cc
					Left Join cta_cte_hou_exp_aer	CtA on CC.num_proc=CtA.num_proc_hea and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_hea='D'
					Left Join vwSolPgtoCtaCteAprovadas SOL on Cta.num_proc_hea=SOL.num_proc and CtA.cd_tp_tx=SOL.cd_tp_tx and SOL.dc='D'
					Left Join vwCXAS		CXA on Cta.num_proc_hea=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_exp_aer			HOU on CC.Num_proc = HOU.Num_proc_hea
					Join Pessoa						PS	on HOU.cd_export_hea = PS.CD_pes
--					Left Join item_fat				ITT on ITT.num_proc=CTA.num_proc_hea and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hea
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hea and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HEA and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HEA
				where 
					SOL.num_proc=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(SOL.CD_TP_tX,1)='X'
					and fat.fatura_pc is null	
					and CXA.num_proc_HIA is null	
			
			end
			
	else
		if left(@Processo,2) = 'IM'
			Begin
			Insert @TempTaxas
				-- CtaCte A Crédito Contra o Consignee
				select
					APELIDO, TT.nome_tp_tx,	CTA.dc_him DC, 	CTA.vlr_org_him Vlr_Org, CXA.Vlr_Pgto_Rcto_hia Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
--					ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					(case When
							CTA.Num_NF_HIM is not NULL and CTA.ref_acesso_nf_HIM <> 'P'
						Then 
							CTA.Par_NF_HIM 
						else 
							dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
					CTA.CD_TP_TX,Null DebitoCC,	CTA.Num_proc_him Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_him,'') NF, 
					isnull(CTA.ref_acesso_nf_him,'') [Site],
					Repasse_TX ,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					House_Imp_Mar HOU
					Left Join cta_cte_hou_Imp_Mar CtA on HOU.num_proc_him=CtA.num_proc_him and HOU.cd_consig_him = CTA.cd_cred_dev_him and CtA.dc_him='C'
					Left Join vwCXAS CXA on Cta.num_proc_him=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.cd_consig_him = PS.cd_pes
				--	Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_him and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_him
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_him and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HIM and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HIM	

				where 
					CTA.num_proc_him=@Processo and CTA.Cd_tp_tx <> 'XCA'			
					and  fatura_Pc is null
				
			Union
				--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
				select
					APELIDO, TT.nome_tp_tx,	'D' DC, CC.Vlr_Item_Custo Vlr_Org, CC.vlr_Item_Custo Vlr_PG,
					'REL' cd_tp_moeda,ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_him,'') NF, 
					isnull(CTA.ref_acesso_nf_him,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					custo_cliente cc
					Left Join vwCXAS		CXA	on CC.num_proc=CXA.num_proc_Hia and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join cta_cte_hou_Imp_Mar	CtA on CC.num_proc=CtA.num_proc_him and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_him='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_Imp_Mar			HOU on CC.Num_proc = HOU.Num_proc_him
					Left Join Pessoa				PS	on HOU.cd_consig_him = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_him and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HIM and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HIM	
				where 
					CC.num_proc=@Processo and num_lcto is null and cta.num_proc_him is null 
					and (Prestacao = 'S' or Prestacao is null) and fatura_pc is null
			
			Union 
				--Cta_Cte à D que está no Custo também
				select
					PS.APELIDO, TT.nome_tp_tx,CTA.dc_him DC,CTA.vlr_org_him Vlr_Org, CXA.Vlr_Pgto_Rcto_hia Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_him,'') NF, 
					isnull(CTA.ref_acesso_nf_him,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					custo_cliente cc
					Left Join cta_cte_hou_Imp_Mar	CtA on CC.num_proc=CtA.num_proc_him and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_him='D'
					Left Join vwCXAS		CXA on Cta.num_proc_him=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_Imp_Mar			HOU on CC.Num_proc = HOU.Num_proc_him
					Join Pessoa				PS	on HOU.cd_consig_him = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_him and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HIM and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HIM
				where 
					CXA.num_proc_Hia=@Processo and 
					(Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					and fatura_pc is null
			
			Union
				--Cta_Cte à D que não está no Custo também
				select
					APELIDO, TT.nome_tp_tx,	CTA.dc_him DC, CTA.vlr_org_him Vlr_Org, CXA.Vlr_Pgto_Rcto_hia Vlr_PG,
					'REL' cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,	CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,CTA.Num_proc_him Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_him,'') NF, 
					isnull(CTA.ref_acesso_nf_him,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					House_Imp_Mar HOU
					Left Join cta_cte_hou_Imp_Mar CtA on HOU.num_proc_him=CtA.num_proc_him and HOU.cd_consig_him = CTA.cd_cred_dev_him and CtA.dc_him='D'
					Left Join vwCXAS CXA on Cta.num_proc_him=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.cd_consig_him = PS.cd_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_him and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HIM and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HIM
				where 
					CTA.num_proc_him=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and fatura_pc is null

			union
				--Cta_Cte D que começa com X
				SELECT
					APELIDO,TT.NOME_TP_TX,CXA.dc_Hia DC,CXA.Vlr_Pgto_Rcto_hia Vlr_Org, 	CXA.Vlr_Pgto_Rcto_hia Vlr_PG,
					'REL' cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,CXA.CD_TP_TX CD_TP_TX,
					NULL DebitoCC,CXA.num_proc_Hia Processo,Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX ,
					GETDATE() Emissao
				FROM
					vwCXAS CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.num_proc_Hia=CC.NUM_PROC
					JOIN HOUSE_Imp_Mar HOU ON HOU.NUM_PROC_him=CXA.num_proc_Hia
					JOIN PESSOA PP ON PP.CD_PES=cd_consig_him
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CXA.num_proc_Hia and itt.cd_tp_Tx=cxa.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'	
				WHERE
					CXA.num_proc_Hia=@Processo AND CXA.dc_Hia='D' AND CC.NUM_PROC IS NULL 
					AND  LEFT(CXA.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
					AND fat.fatura_pc is null
					
			union
				--Cta_Cte D que começa com X sem cxa e com solicitação de pagamento
				SELECT
					APELIDO,TT.NOME_TP_TX,SOL.dc DC,SOL.Vlr_Pgto_Rcto Vlr_Org, 	SOL.Vlr_Pgto_Rcto Vlr_PG,
					'REL' cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,SOL.CD_TP_TX CD_TP_TX,
					NULL DebitoCC,SOL.num_proc Processo,Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX ,
					GETDATE() Emissao
				FROM
					vwSolPgtoCtaCteAprovadas SOL 
					left join vwCXAS CXA on SOL.num_proc=CXA.num_proc_HIA and SOL.cd_tp_tx=CXA.cd_tp_tx and SOL.DC=cxa.DC_HIA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=SOL.CD_TP_TX
					Left Join Custo_Cliente CC on SOL.CD_TP_TX=CC.CD_TP_TX AND SOL.num_proc=CC.NUM_PROC
					JOIN HOUSE_Imp_Mar HOU ON HOU.NUM_PROC_him=SOL.num_proc
					JOIN PESSOA PP ON PP.CD_PES=cd_consig_him
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=SOL.num_proc and itt.cd_tp_Tx=SOL.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'	
				WHERE
					SOL.num_proc=@Processo AND SOL.dc='D' AND CC.NUM_PROC IS NULL
					and CXA.Num_Proc_HIA is null 
					AND  LEFT(SOL.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
					AND fat.fatura_pc is null
					
			Union 
				--Cta_Cte à D que está no Custo também sem cxa e com solicitação de pagamento
				select
					PS.APELIDO, TT.nome_tp_tx,CTA.dc_him DC,CTA.vlr_org_him Vlr_Org, SOL.Vlr_Pgto_Rcto Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_him,'') NF, 
					isnull(CTA.ref_acesso_nf_him,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					custo_cliente cc
					Left Join cta_cte_hou_Imp_Mar	CtA on CC.num_proc=CtA.num_proc_him and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_him='D'
					Left Join vwSolPgtoCtaCteAprovadas SOL  on Cta.num_proc_him=SOL.num_proc and CtA.cd_tp_tx=SOL.cd_tp_tx and SOL.dc='D'
					Left Join vwCXAS		CXA on Cta.num_proc_him=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_Imp_Mar			HOU on CC.Num_proc = HOU.Num_proc_him
					Join Pessoa				PS	on HOU.cd_consig_him = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_him and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HIM and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HIM
				where 
					SOL.num_proc=@Processo and 
					(Prestacao = 'S' or Prestacao is null) and LEFT(SOL.CD_TP_tX,1)='X'
					and fatura_pc is null
					and CXA.Num_Proc_HIA is null 

			end

	else
		if left(@Processo,2) = 'EM'
			Begin
			Insert @TempTaxas
			-- CtaCte A Crédito Contra o Consignee
				select
					APELIDO, TT.nome_tp_tx,	CTA.dc_hem DC, 	CTA.vlr_org_hem Vlr_Org, CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda, 
--					ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					(case When
							CTA.Num_NF_HEM is not NULL and CTA.ref_acesso_nf_HEM <> 'P'
						Then 
							CTA.Par_NF_HEM 
						else 
							dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
					CTA.CD_TP_TX,
					Null DebitoCC,CTA.Num_proc_hem Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hem,'') NF, 
					isnull(CTA.ref_acesso_nf_hem,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					House_exp_mar HOU
					Left Join cta_cte_hou_exp_mar CtA on HOU.num_proc_hem=CtA.num_proc_hem and HOU.cd_Export_hem = CTA.cd_cred_dev_hem and CtA.dc_hem='C'
					Left Join vwCXAS CXA on Cta.num_proc_hem=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.cd_Export_hem = PS.cd_pes
--					Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hem
					--Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					
					--Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					Left join vwFaturasValidas F on F.num_proc=Hou.num_proc_hem and CTA.cd_tp_tx=F.cd_tp_Tx and cta.dc_hem=f.dc
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HEM and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HEM
				where 
					CTA.num_proc_hem=@Processo and CTA.Cd_tp_tx <> 'XCA'			
					--and fat.fatura_pc is null
					and F.num_proc is null 
			Union
				--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
				select
					APELIDO, TT.nome_tp_tx,'D' DC, CC.Vlr_Item_Custo Vlr_Org, 
					CC.vlr_Item_Custo Vlr_PG,'REL' cd_tp_moeda,	ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,	CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hem,'') NF, 
					isnull(CTA.ref_acesso_nf_hem,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					custo_cliente cc
					Left Join vwCXAS		CXA	on CC.num_proc=CXA.num_proc_Hia and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join cta_cte_hou_exp_mar	CtA on CC.num_proc=CtA.num_proc_hem and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_hem='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_exp_mar			HOU on CC.Num_proc = HOU.Num_proc_hem
					Left Join Pessoa				PS	on HOU.cd_Export_hem = PS.CD_pes
--					Left Join item_fat ITT on ITT.num_proc=CC.num_proc and itt.cd_tp_Tx=CC.cd_tp_Tx --and itt.dc=CC.dc_hem
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HEM and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HEM	
				where 
					CC.num_proc=@Processo and num_lcto is null and cta.num_proc_hem is null 
					and (Prestacao = 'S' or Prestacao is null)
					and fat.fatura_pc is null
				
			Union 
				--Cta_Cte à D que está no Custo também
				select
					PS.APELIDO, TT.nome_tp_tx,	CTA.dc_hem DC,CTA.vlr_org_hem Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,CTA.cd_tp_moeda cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hem,'') NF, 
					isnull(CTA.ref_acesso_nf_hem,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					custo_cliente cc
					Left Join cta_cte_hou_exp_mar	CtA on CC.num_proc=CtA.num_proc_hem and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_hem='D'
					Left Join vwCXAS		CXA on Cta.num_proc_hem=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_exp_mar			HOU on CC.Num_proc = HOU.Num_proc_hem
					Join Pessoa				PS	on HOU.cd_export_hem = PS.CD_pes
--					Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hem
--ALTERADO POR ANDERSON
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HEM and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HEM	
				where 
					CXA.num_proc_Hia=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					and fat.fatura_pc is null
				
			union			
				--Cta_Cte à D que não está no Custo também
				select
					APELIDO, TT.nome_tp_tx,	CTA.dc_hem DC,CTA.vlr_org_hem Vlr_Org, 	CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
					'REL' cd_tp_moeda,	iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,CTA.Num_proc_hem Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hem,'') NF, 
					isnull(CTA.ref_acesso_nf_hem,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					House_exp_mar HOU
					Left Join cta_cte_hou_exp_mar CtA on HOU.num_proc_hem=CtA.num_proc_hem and HOU.cd_export_hem = CTA.cd_cred_dev_hem and CtA.dc_hem='D'
					Left Join vwCXAS CXA on Cta.num_proc_hem=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.cd_export_hem = PS.cd_pes
---					Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hem
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HEM and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HEM	
				where 
					CTA.num_proc_hem=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and fat.fatura_pc is null
			union
				--Cta_Cte D que começa com X
				SELECT
					APELIDO,TT.NOME_TP_TX,CXA.dc_Hia DC, CXA.Vlr_Pgto_Rcto_Hia Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,'REL' cd_tp_moeda,	iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,
					CXA.CD_TP_TX CD_TP_TX,NULL DebitoCC,CXA.num_proc_Hia Processo,Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX ,
					GETDATE() Emissao
				FROM
					vwCXAS CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.num_proc_Hia=CC.NUM_PROC
					JOIN HOUSE_exp_mar HOU ON HOU.NUM_PROC_hem=CXA.num_proc_Hia
					JOIN PESSOA PP ON PP.CD_PES=CD_Export_hem
--					Left Join item_fat ITT on ITT.num_proc=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.cd_tp_Tx and ITT.dc=CXA.dc_Hia
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					CXA.num_proc_Hia=@Processo AND CXA.dc_Hia='D' AND CC.NUM_PROC IS NULL 
					AND  LEFT(CXA.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
					AND fat.fatura_pc IS NULL
					
			union
				--Cta_Cte D que começa com X sem cxa e com solicitação de pagamento
				SELECT
					APELIDO,TT.NOME_TP_TX,SOL.dc DC, SOL.Vlr_Pgto_Rcto Vlr_Org, 
					SOL.Vlr_Pgto_Rcto Vlr_PG,'REL' cd_tp_moeda,	iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,
					SOL.CD_TP_TX CD_TP_TX,NULL DebitoCC,SOL.num_proc Processo,Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX ,
					GETDATE()
					 Emissao
				FROM
					vwSolPgtoCtaCteAprovadas SOL
					left join vwCXAS CXA on SOL.num_proc=CXA.num_proc_HIA and SOL.cd_tp_tx=CXA.cd_tp_tx and SOL.DC=cxa.DC_HIA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=SOL.CD_TP_TX
					Left Join Custo_Cliente CC on SOL.CD_TP_TX=CC.CD_TP_TX AND SOL.num_proc=CC.NUM_PROC
					JOIN HOUSE_exp_mar HOU ON HOU.NUM_PROC_hem=SOL.num_proc
					JOIN PESSOA PP ON PP.CD_PES=CD_Export_hem
--					Left Join item_fat ITT on ITT.num_proc=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.cd_tp_Tx and ITT.dc=CXA.dc_Hia
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=SOL.num_proc and itt.cd_tp_Tx=SOL.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					SOL.num_proc=@Processo AND SOL.dc='D' AND CC.NUM_PROC IS NULL
					and CXA.num_proc_HIA is null 
					AND  LEFT(SOL.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
					AND fat.fatura_pc IS NULL
					
			Union 
				--Cta_Cte à D que está no Custo também sem cxa e com solicitação de pagamento
				select
					PS.APELIDO, TT.nome_tp_tx,	CTA.dc_hem DC,CTA.vlr_org_hem Vlr_Org, 
					SOL.Vlr_Pgto_Rcto Vlr_PG,CTA.cd_tp_moeda cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hem,'') NF, 
					isnull(CTA.ref_acesso_nf_hem,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					custo_cliente cc
					Left Join cta_cte_hou_exp_mar	CtA on CC.num_proc=CtA.num_proc_hem and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_hem='D'
					Left Join vwSolPgtoCtaCteAprovadas SOL on Cta.num_proc_hem=SOL.num_proc and CtA.cd_tp_tx=SOL.cd_tp_tx and SOL.DC='D'
					Left Join vwCXAS		CXA on Cta.num_proc_hem=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_exp_mar			HOU on CC.Num_proc = HOU.Num_proc_hem
					Join Pessoa				PS	on HOU.cd_export_hem = PS.CD_pes
--					Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hem
--ALTERADO POR ANDERSON
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'	
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_HEM and BA.Ref_Acesso =ctA.Ref_Acesso_NF_HEM
				where 
					SOL.num_proc=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(SOL.CD_TP_tX,1)='X'
					and fat.fatura_pc is null
					and CXA.num_proc_HIA is null
					
			
			end

	
	END
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
					CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
--					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXM'),1) Paridade,
					(case When 
						CTA.Num_NF_MEM is not NULL and CTA.ref_acesso_nf_mem <> 'P'
					Then 
						CTA.Par_NF_MEM 
					else 
						dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade, 
					CTA.CD_TP_TX,
					Null DebitoCC,
					CTA.Num_proc_MEM Processo,
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mem,'') NF, 
					isnull(CTA.ref_acesso_nf_mem,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					MASter_EXP_MAR MAS
					Left Join cta_cte_mas_EXP_MAR CtA on MAS.num_proc_MEM=CtA.num_proc_MEM and MAS.cd_EXPORT_MEM = CTA.cd_cred_dev_MEM and CtA.dc_MEM='C'
					Left Join vwCXAS CXA on Cta.num_proc_MEM=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_export_MEM = PS.cd_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_MEM and BA.Ref_Acesso =ctA.Ref_Acesso_NF_MEM
				where 
					CTA.num_proc_MEM=@Processo and CTA.Cd_tp_tx <> 'XCA'
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mem,'') NF, 
					isnull(CTA.ref_acesso_nf_mem,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					custo_processo cc
					Left Join vwCXAS		CXA	on CC.num_proc=CXA.num_proc_Hia and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join cta_cte_mas_EXP_MAR	CtA on CC.num_proc=CtA.num_proc_MEM and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_MEM='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_exp_mar			MAS on CC.Num_proc = MAS.Num_proc_MEM
					Left Join Pessoa				PS	on MAS.cd_export_MEM = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_MEM and BA.Ref_Acesso =ctA.Ref_Acesso_NF_MEM
				where 
					num_proc=@Processo and num_lcto is null and cta.num_proc_MEM is null --and (Prestacao = 'S' or Prestacao is null)
					AND fat.fatura_pc IS NULL

			Union 
				--Cta_Cte à D que está no Custo também
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_MEM DC, 
					CTA.vlr_org_MEM Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXM'),1) Paridade,
					CC.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,
					CC.num_proc Processo,
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mem,'') NF, 
					isnull(CTA.ref_acesso_nf_mem,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					custo_cliente cc
					Left Join cta_cte_mas_EXP_MAR CtA on CC.num_proc=CtA.num_proc_MEM and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_MEM='D'
					Left Join vwCXAS CXA on Cta.num_proc_MEM=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join Tipo_Taxa TT on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_exp_mar			MAS on CC.Num_proc = MAS.Num_proc_MEM
					Left Join Pessoa				PS	on MAS.cd_export_MEM = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_MEM and BA.Ref_Acesso =ctA.Ref_Acesso_NF_MEM
				where 
					CXA.num_proc_Hia=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					AND fat.fatura_pc IS NULL

			union			
				--Cta_Cte à D que não está no Custo também
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_MEM DC, 							
					CTA.vlr_org_MEM Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXM'),1) Paridade,
					CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,
					CTA.Num_proc_MEM Processo,
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mem,'') NF, 
					isnull(CTA.ref_acesso_nf_mem,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao 
				from 
					MASter_exp_mar MAS
					Left Join cta_cte_mas_exp_mar CtA on MAS.num_proc_MEM=CtA.num_proc_MEM and MAS.cd_export_MEM = CTA.cd_cred_dev_MEM and CtA.dc_MEM='D'
					Left Join vwCXAS CXA on Cta.num_proc_MEM=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_export_MEM = PS.cd_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_MEM and BA.Ref_Acesso =ctA.Ref_Acesso_NF_MEM
				where 
					CTA.num_proc_MEM=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					AND fat.fatura_pc IS NULL

			union
				--Cta_Cte D que começa com X
				SELECT
					APELIDO,
					TT.NOME_TP_TX,
					CXA.dc_Hia DC, 
					CXA.Vlr_Pgto_Rcto_Hia Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,'REL','EXM'),1) Paridade,
					CXA.CD_TP_TX CD_TP_TX,
					NULL DebitoCC,
					CXA.num_proc_Hia Processo,
					Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX ,
					GETDATE() Emissao
				FROM
					vwCXAS CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.num_proc_Hia=CC.NUM_PROC
					JOIN MASter_EXP_MAR MAS ON MAS.NUM_PROC_MEM=CXA.num_proc_Hia
					JOIN PESSOA PP ON PP.CD_PES=CD_Export_MEM
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					CXA.num_proc_Hia=@Processo AND CXA.dc_Hia='D' AND CC.NUM_PROC IS NULL 
					AND LEFT(CXA.CD_TP_tX,1)='X' --AND CXA.CD_TP_TX NOT IN ('XBA')
					AND fat.fatura_pc IS NULL
			 
			End

	else
		if left(@Processo,2) = 'EA'
			Begin
			Insert @TempTaxas
				-- CtaCte A Crédito Contra o Consignee
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_mea DC, 
					CTA.vlr_org_mea Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
--					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXA'),1) Paridade,
					(case When 
						CTA.Num_NF_MEA is not NULL and CTA.ref_acesso_nf_mea <> 'P'
					Then 
						CTA.Par_NF_MEA 
					else 
						dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
					CTA.CD_TP_TX,
					Null DebitoCC,
					CTA.Num_proc_mea Processo,
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mea,'') NF, 
					isnull(CTA.ref_acesso_nf_mea,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					MASter_EXP_aer MAS
					Left Join cta_cte_mas_EXP_aer CtA on MAS.num_proc_mea=CtA.num_proc_mea and MAS.cd_EXPORT_mea = CTA.cd_cred_dev_mea and CtA.dc_mea='C'
					Left Join vwCXAS CXA on Cta.num_proc_mea=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_export_mea = PS.cd_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_MEA and BA.Ref_Acesso =ctA.Ref_Acesso_NF_MEA
				where 
					CTA.num_proc_mea=@Processo and CTA.Cd_tp_tx <> 'XCA'
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mea,'') NF, 
					isnull(CTA.ref_acesso_nf_mea,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					custo_processo cc
					Left Join vwCXAS		CXA	on CC.num_proc=CXA.num_proc_Hia and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join cta_cte_mas_EXP_aer	CtA on CC.num_proc=CtA.num_proc_mea and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_mea='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_exp_aer			MAS on CC.Num_proc = MAS.Num_proc_mea
					Left Join Pessoa				PS	on MAS.cd_export_mea = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_MEA and BA.Ref_Acesso =ctA.Ref_Acesso_NF_MEA
				where 
					num_proc=@Processo and num_lcto is null and cta.num_proc_mea is null --and (Prestacao = 'S' or Prestacao is null)
					AND fat.fatura_pc IS NULL

			Union 
				--Cta_Cte à D que está no Custo também
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_mea DC, 
					CTA.vlr_org_mea Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXA'),1) Paridade,
					CC.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,
					CC.num_proc Processo,
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mea,'') NF, 
					isnull(CTA.ref_acesso_nf_mea,'') [Site],
					Repasse_TX ,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					custo_cliente cc
					Left Join cta_cte_mas_EXP_aer CtA on CC.num_proc=CtA.num_proc_mea and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_mea='D'
					Left Join vwCXAS CXA on Cta.num_proc_mea=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join Tipo_Taxa TT on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_exp_aer			MAS on CC.Num_proc = MAS.Num_proc_mea
					Left Join Pessoa				PS	on MAS.cd_export_mea = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_MEA and BA.Ref_Acesso =ctA.Ref_Acesso_NF_MEA
				where 
					CXA.num_proc_Hia=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					AND fat.fatura_pc IS NULL

			union			
				--Cta_Cte à D que não está no Custo também
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_mea DC, 
					CTA.vlr_org_mea Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'EXA'),1) Paridade,
					CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,
					CTA.Num_proc_mea Processo,
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mea,'') NF, 
					isnull(CTA.ref_acesso_nf_mea,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					MASter_exp_aer MAS
					Left Join cta_cte_mas_exp_aer CtA on MAS.num_proc_mea=CtA.num_proc_mea and MAS.cd_export_mea = CTA.cd_cred_dev_mea and CtA.dc_mea='D'
					Left Join vwCXAS CXA on Cta.num_proc_mea=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_export_mea = PS.cd_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_MEA and BA.Ref_Acesso =ctA.Ref_Acesso_NF_MEA
				where 
					CTA.num_proc_mea=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					AND fat.fatura_pc IS NULL

			union
				--Cta_Cte D que começa com X
				SELECT
					APELIDO,
					TT.NOME_TP_TX,
					CXA.dc_Hia DC, 
					CXA.Vlr_Pgto_Rcto_Hia Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,'REL','EXA'),1) Paridade,
					CXA.CD_TP_TX CD_TP_TX,
					NULL DebitoCC,
					CXA.num_proc_Hia Processo,
					Ref_Ctb_Tx
					,'' NF, 
					''[Site],
					Repasse_TX ,
					GETDATE() Emissao
				FROM
					vwCXAS CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.num_proc_Hia=CC.NUM_PROC
					JOIN MASter_EXP_aer MAS ON MAS.NUM_PROC_mea=CXA.num_proc_Hia
					JOIN PESSOA PP ON PP.CD_PES=CD_Export_mea
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					CXA.num_proc_Hia=@Processo AND CXA.dc_Hia='D' AND CC.NUM_PROC IS NULL 
					AND LEFT(CXA.CD_TP_tX,1)='X' --AND CXA.CD_TP_TX NOT IN ('XBA')
					AND fat.fatura_pc IS NULL
		 
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
					CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
--					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMA'),1) Paridade,
					(case When 
						CTA.Num_NF_MIA is not NULL and CTA.ref_acesso_nf_mia <> 'P'
					Then 
						CTA.Par_NF_MIA 
					else 
						dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
					CTA.CD_TP_TX,
					Null DebitoCC,
					CTA.Num_proc_mia Processo,
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mia,'') NF, 
					isnull(CTA.ref_acesso_nf_mia,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					MASter_imp_aer MAS
					Left Join cta_cte_mas_imp_aer CtA on MAS.num_proc_mia=CtA.num_proc_mia and MAS.cd_consig_mia = CTA.cd_cred_dev_mia and CtA.dc_mia='C'
					Left Join vwCXAS CXA on Cta.num_proc_mia=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_consig_mia = PS.cd_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_MIA and BA.Ref_Acesso =ctA.Ref_Acesso_NF_MIA
				where 
					CTA.num_proc_mia=@Processo and CTA.Cd_tp_tx <> 'XCA'
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mia,'') NF, 
					isnull(CTA.ref_acesso_nf_mia,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					custo_processo cc
					Left Join vwCXAS		CXA	on CC.num_proc=CXA.num_proc_Hia and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join cta_cte_mas_imp_aer	CtA on CC.num_proc=CtA.num_proc_mia and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_mia='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_imp_aer			MAS on CC.Num_proc = MAS.Num_proc_mia
					Left Join Pessoa				PS	on MAS.cd_consig_mia = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_MIA and BA.Ref_Acesso =ctA.Ref_Acesso_NF_MIA
				where 
					num_proc=@Processo and num_lcto is null and cta.num_proc_mia is null --and (Prestacao = 'S' or Prestacao is null)
					AND fat.fatura_pc IS NULL

			Union 
				--Cta_Cte à D que está no Custo também
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_mia DC, 
					CTA.vlr_org_mia Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMA'),1) Paridade,
					CC.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,
					CC.num_proc Processo,
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mia,'') NF, 
					isnull(CTA.ref_acesso_nf_mia,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					custo_cliente cc
					Left Join cta_cte_mas_imp_aer CtA on CC.num_proc=CtA.num_proc_mia and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_mia='D'
					Left Join vwCXAS CXA on Cta.num_proc_mia=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join Tipo_Taxa TT on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_imp_aer			MAS on CC.Num_proc = MAS.Num_proc_mia
					Left Join Pessoa				PS	on MAS.cd_consig_mia = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_MIA and BA.Ref_Acesso =ctA.Ref_Acesso_NF_MIA
				where 
					CXA.num_proc_Hia=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					AND fat.fatura_pc IS NULL

			union			
				--Cta_Cte à D que não está no Custo também
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_mia DC, 
					CTA.vlr_org_mia Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMA'),1) Paridade,
					CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,
					CTA.Num_proc_mia Processo,
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mia,'') NF, 
					isnull(CTA.ref_acesso_nf_mia,'') [Site],
					Repasse_TX,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					MASter_imp_aer MAS
					Left Join cta_cte_mas_imp_aer CtA on MAS.num_proc_mia=CtA.num_proc_mia and MAS.cd_consig_mia = CTA.cd_cred_dev_mia and CtA.dc_mia='D'
					Left Join vwCXAS CXA on Cta.num_proc_mia=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_consig_mia = PS.cd_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_MIA and BA.Ref_Acesso =ctA.Ref_Acesso_NF_MIA
				where 
					CTA.num_proc_mia=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					AND fat.fatura_pc IS NULL

			union
				--Cta_Cte D que começa com X
				SELECT
					APELIDO,
					TT.NOME_TP_TX,
					CXA.dc_Hia DC, 
					CXA.Vlr_Pgto_Rcto_Hia Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,'REL','IMA'),1) Paridade,
					CXA.CD_TP_TX CD_TP_TX,
					NULL DebitoCC,
					CXA.num_proc_Hia Processo,
					Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX,
					GETDATE() Emissao 
				FROM
					vwCXAS CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.num_proc_Hia=CC.NUM_PROC
					JOIN MASter_imp_aer MAS ON MAS.NUM_PROC_mia=CXA.num_proc_Hia
					JOIN PESSOA PP ON PP.CD_PES=CD_consig_mia
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					CXA.num_proc_Hia=@Processo AND CXA.dc_Hia='D' AND CC.NUM_PROC IS NULL 
					AND LEFT(CXA.CD_TP_tX,1)='X' --AND CXA.CD_TP_TX NOT IN ('XBA')
					AND fat.fatura_pc IS NULL
			 
			End

	else
		if left(@Processo,2) = 'IM'
			Begin
			Insert @TempTaxas
			-- CtaCte A Crédito Contra o Consignee
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_Mim DC, 
					CTA.vlr_org_Mim Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
--					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMM'),1) Paridade,
					(case When 
						CTA.Num_NF_MIM is not NULL and CTA.ref_acesso_nf_mim <> 'P'
					Then 
						CTA.Par_NF_MIM 
					else 
						dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
					CTA.CD_TP_TX,
					Null DebitoCC,
					CTA.Num_proc_Mim Processo,
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mim,'') NF, 
					isnull(CTA.ref_acesso_nf_mim,'') [Site],
					Repasse_TX ,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					MASter_imp_mar MAS
					Left Join cta_cte_mas_imp_mar CtA on MAS.num_proc_Mim=CtA.num_proc_Mim and MAS.cd_consig_Mim = CTA.cd_cred_dev_Mim and CtA.dc_Mim='C'
					Left Join vwCXAS CXA on Cta.num_proc_Mim=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_consig_Mim = PS.cd_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_MIM and BA.Ref_Acesso =ctA.Ref_Acesso_NF_MIM
				where 
					CTA.num_proc_Mim=@Processo and CTA.Cd_tp_tx <> 'XCA'
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mim,'') NF, 
					isnull(CTA.ref_acesso_nf_mim,'') [Site],
					Repasse_TX ,
					isnull(BA.Emissao,GETDATE()) Emissao 
				from 
					custo_processo cc
					Left Join vwCXAS		CXA	on CC.num_proc=CXA.num_proc_Hia and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='D'
					Left Join cta_cte_mas_imp_mar	CtA on CC.num_proc=CtA.num_proc_Mim and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_Mim='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_imp_mar			MAS on CC.Num_proc = MAS.Num_proc_Mim
					Left Join Pessoa				PS	on MAS.cd_consig_Mim = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_MIM and BA.Ref_Acesso =ctA.Ref_Acesso_NF_MIM
				where 
					num_proc=@Processo and num_lcto is null and cta.num_proc_Mim is null --and (Prestacao = 'S' or Prestacao is null)
					AND fat.fatura_pc IS NULL

			Union
				--Cta_Cte à D que está no Custo também
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_Mim DC, 
					CTA.vlr_org_Mim Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMM'),1) Paridade,
					CC.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,
					CC.num_proc Processo,
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mim,'') NF, 
					isnull(CTA.ref_acesso_nf_mim,'') [Site],
					Repasse_TX ,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					custo_cliente cc
					Left Join cta_cte_mas_imp_mar CtA on CC.num_proc=CtA.num_proc_Mim and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_Mim='D'
					Left Join vwCXAS CXA on Cta.num_proc_Mim=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='D'
					Left Join Tipo_Taxa TT on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_imp_mar			MAS on CC.Num_proc = MAS.Num_proc_Mim
					Left Join Pessoa				PS	on MAS.cd_consig_Mim = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_MIM and BA.Ref_Acesso =ctA.Ref_Acesso_NF_MIM
				where 
					CXA.num_proc_Hia=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					AND fat.fatura_pc IS NULL

			union			
				--Cta_Cte à D que não está no Custo também
				select
					APELIDO, 
					TT.nome_tp_tx,
					CTA.dc_Mim DC, 
					CTA.vlr_org_Mim Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'IMM'),1) Paridade,
					CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,
					CTA.Num_proc_Mim Processo,
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mim,'') NF, 
					isnull(CTA.ref_acesso_nf_mim,'') [Site],
					Repasse_TX ,
					isnull(BA.Emissao,GETDATE()) Emissao
				from 
					MASter_imp_mar MAS
					Left Join cta_cte_mas_imp_mar CtA on MAS.num_proc_Mim=CtA.num_proc_Mim and MAS.cd_consig_Mim = CTA.cd_cred_dev_Mim and CtA.dc_Mim='D'
					Left Join vwCXAS CXA on Cta.num_proc_Mim=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_consig_Mim = PS.cd_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
					left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CTA.Num_NF_MIM and BA.Ref_Acesso =ctA.Ref_Acesso_NF_MIM
				where 
					CTA.num_proc_Mim=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					AND fat.fatura_pc IS NULL

			union
				--Cta_Cte D que começa com X
				SELECT
					APELIDO,
					TT.NOME_TP_TX,
					CXA.dc_hia DC, 
					CXA.Vlr_Pgto_Rcto_Hia Vlr_Org, 
					CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
					'REL' cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,'REL','IMM'),1) Paridade,
					CXA.CD_TP_TX CD_TP_TX,
					NULL DebitoCC,
					CXA.num_proc_Hia Processo,
					Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX ,
					GETDATE() Emissao
				FROM
					vwCXAS CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.num_proc_Hia=CC.NUM_PROC
					JOIN MASter_imp_mar MAS ON MAS.NUM_PROC_Mim=CXA.num_proc_Hia
					JOIN PESSOA PP ON PP.CD_PES=CD_consig_Mim
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.num_proc_Hia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					CXA.num_proc_Hia=@Processo AND CXA.dc_hia='D' AND CC.NUM_PROC IS NULL 
					AND LEFT(CXA.CD_TP_tX,1)='X' --AND CXA.CD_TP_TX NOT IN ('XBA')
					AND fat.fatura_pc IS NULL
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
		on T.cd_tp_Moeda = T1.cd_tp_moeda and T1.NF is not NULL
	--select Moeda,Paridade from @TempTaxas as T2 where NF is not NULL
	--where NF is NULL
		
	select * from @TempTaxas where month(Emissao) = MONTH(getdate())
/*
IF len(@Processo) = 16
	BEGIN
		if left(@Processo,2) = 'EO'
			Begin
			Insert @TempTaxas
	-- CtaCte A Crédito Contra o Consignee
				select
 					APELIDO, TT.nome_tp_tx,	CTA.dc_HEO DC, 	CTA.vlr_org_HEO Vlr_Org, CXA.Vlr_Pgto_Rcto_Heo Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda, 
--					ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					(case When
							CTA.Num_NF_HEO is not NULL and CTA.ref_acesso_nf_heO <> 'P'
						Then 
							CTA.Par_NF_HeO 
						else 
							dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
					CTA.CD_TP_TX,
					Null DebitoCC,CTA.Num_proc_HEO Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_heo,'') NF, 
					isnull(CTA.ref_acesso_nf_heo,'') [Site],
					Repasse_TX 
				from 
					House_EXP_OUT HOU
					Left Join cta_cte_hou_EXP_OUT CtA on HOU.num_proc_HEO=CtA.num_proc_HEO and HOU.cd_Export_HEO = CTA.cd_cred_dev_HEO and CtA.dc_HEO='C'
					Left Join caixa_hou_EXP_OUT CXA on Cta.num_proc_HEO=CXA.num_proc_HEO and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HEO='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.cd_Export_HEO = PS.cd_pes
					Left Join Fatura_CHB_ITEM ITT on left(fatura_cc,16)=CTA.num_proc_heo and itt.cd_tp_Tx=CTA.cd_tp_Tx 
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'						
				where 
					CTA.num_proc_HEO=@Processo and CTA.Cd_tp_tx <> 'XCA'			
					and fat.fatura_pc is null

			Union
				--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
				select
					APELIDO, TT.nome_tp_tx,'D' DC, CC.Vlr_Item_Custo Vlr_Org, 
					CC.vlr_Item_Custo Vlr_PG,'REL' cd_tp_moeda,	ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,	CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_heo,'') NF, 
					isnull(CTA.ref_acesso_nf_heo,'') [Site],
					Repasse_TX 
				from 
					custo_cliente cc
					Left Join caixa_hou_EXP_OUT		CXA	on CC.num_proc=CXA.num_proc_HEO and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HEO='D'
					Left Join cta_cte_hou_EXP_OUT	CtA on CC.num_proc=CtA.num_proc_HEO and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_HEO='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_EXP_OUT			HOU on CC.Num_proc = HOU.Num_proc_HEO
					Left Join Pessoa				PS	on HOU.cd_Export_HEO = PS.CD_pes
--					Left Join item_fat ITT on ITT.num_proc=CC.num_proc and itt.cd_tp_Tx=CC.cd_tp_Tx --and itt.dc=CC.dc_heo
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_heo and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CC.num_proc=@Processo and num_lcto is null and cta.num_proc_HEO is null 
					and (Prestacao = 'S' or Prestacao is null)
					and fat.fatura_pc is null
				
			Union 
				--Cta_Cte à D que está no Custo também
				select
 					PS.APELIDO, TT.nome_tp_tx,	CTA.dc_heo DC,CTA.vlr_org_heo Vlr_Org, 
					CXA.vlr_pgto_rcto_heo Vlr_PG,CTA.cd_tp_moeda cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_heo,'') NF, 
					isnull(CTA.ref_acesso_nf_heo,'') [Site],
					Repasse_TX 
				from 
					custo_cliente cc
					Left Join cta_cte_hou_exp_OUT	CtA on CC.num_proc=CtA.num_proc_heo and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_heo='D'
					Left Join caixa_hou_exp_OUT		CXA on Cta.num_proc_heo=CXA.num_proc_heo and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_heo='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_exp_OUT			HOU on CC.Num_proc = HOU.Num_proc_heo
					Join Pessoa				PS	on HOU.cd_export_heo = PS.CD_pes
--					Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_heo and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_heo
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_heo and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CXA.num_proc_heo=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					and fat.fatura_pc is null
				
			union			
				--Cta_Cte à D que não está no Custo também
				select
 					APELIDO, TT.nome_tp_tx,	CTA.dc_HEO DC,CTA.vlr_org_HEO Vlr_Org, 	CXA.Vlr_Pgto_Rcto_HEO Vlr_PG,
					'REL' cd_tp_moeda,	iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,CTA.Num_proc_Heo Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_heo,'') NF, 
					isnull(CTA.ref_acesso_nf_heo,'') [Site],
					Repasse_TX 
				from 
					House_exp_out HOU
					Left Join cta_cte_hou_exp_out CtA on HOU.num_proc_HEO=CtA.num_proc_HEO and HOU.cd_export_HEO = CTA.cd_cred_dev_HEO and CtA.dc_HEO='D'
					Left Join caixa_hou_exp_out CXA on Cta.num_proc_Heo=CXA.num_proc_Heo and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Heo='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.cd_export_heo = PS.cd_pes
--					Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_heo and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_heo
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_heo and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_heo=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and fat.fatura_pc is null

			union
				--Cta_Cte D que começa com X
				SELECT
					APELIDO,TT.NOME_TP_TX,CXA.dc_HEO DC, CXA.vlr_pgto_rcto_HEO Vlr_Org, 
					CXA.vlr_pgto_rcto_HEO Vlr_PG,'REL' cd_tp_moeda,	iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,
					CXA.CD_TP_TX CD_TP_TX,NULL DebitoCC,CXA.num_proc_HEO Processo,Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_HOU_EXP_OUT CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_HEO=CC.NUM_PROC
					JOIN HOUSE_EXP_OUT HOU ON HOU.NUM_PROC_HEO=CXA.NUM_PROC_HEO
					JOIN PESSOA PP ON PP.CD_PES=CD_Export_HEO
--					Left Join item_fat ITT on ITT.num_proc=CXA.num_proc_heo and itt.cd_tp_Tx=CXA.cd_tp_Tx and ITT.dc=CXA.dc_heo
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CXA.NUM_PROC_HEO and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'	
				WHERE
					CXA.num_proc_HEO=@Processo AND CXA.DC_HEO='D' AND CC.NUM_PROC IS NULL 
					AND  LEFT(CXA.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
					AND fat.fatura_pc IS NULL
			end
	
	else
		if left(@Processo,2) = 'IO'
			Begin
			Insert @TempTaxas
				-- CtaCte A Crédito Contra o Consignee
				select
 					APELIDO, TT.nome_tp_tx,	CTA.dc_HIO DC, 	CTA.vlr_org_HIO Vlr_Org, CXA.Vlr_Pgto_Rcto_HIO Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
--					ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					(case When
							CTA.Num_NF_HIO is not NULL and CTA.ref_acesso_nf_HIO <> 'P'
						Then 
							CTA.Par_NF_HIO 
						else 
							dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,

					CTA.CD_TP_TX,Null DebitoCC,	CTA.Num_proc_HIO Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hio,'') NF, 
					isnull(CTA.ref_acesso_nf_hio,'') [Site],
					Repasse_TX 
				from 
					House_IMP_OUT HOU
					Left Join cta_cte_hou_IMP_OUT CtA on HOU.num_proc_HIO=CtA.num_proc_HIO and HOU.CD_CONSIG_HIO = CTA.cd_cred_dev_HIO and CtA.dc_HIO='C'
					Left Join caixa_hou_IMP_OUT CXA on Cta.num_proc_HIO=CXA.num_proc_HIO and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HIO='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.CD_CONSIG_HIO = PS.cd_pes
	--				Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_HIO and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_HIO
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hio and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_HIO=@Processo and CTA.Cd_tp_tx <> 'XCA'			
					and fat.fatura_pc is null
			Union
				--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
				select
 					APELIDO, TT.nome_tp_tx,	'D' DC, CC.Vlr_Item_Custo Vlr_Org, CC.vlr_Item_Custo Vlr_PG,
					'REL' cd_tp_moeda,ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hio,'') NF, 
					isnull(CTA.ref_acesso_nf_hio,'') [Site],
					Repasse_TX 
				from 
					custo_cliente cc
					Left Join caixa_hou_IMP_OUT		CXA	on CC.num_proc=CXA.num_proc_HIO and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HIO='D'
					Left Join cta_cte_hou_IMP_OUT	CtA on CC.num_proc=CtA.num_proc_HIO and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_HIO='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_IMP_OUT			HOU on CC.Num_proc = HOU.Num_proc_HIO
					Left Join Pessoa				PS	on HOU.CD_CONSIG_HIO = PS.CD_pes
	--				Left Join item_fat ITT on ITT.num_proc=CC.num_proc and itt.cd_tp_Tx=CC.cd_tp_Tx --and itt.dc=CC.dc_HIO
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hio and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CC.num_proc=@Processo and num_lcto is null and cta.num_proc_HIO is null 
					and (Prestacao = 'S' or Prestacao is null) and fat.fatura_pc is null
				
			Union
				--Cta_Cte à D que está no Custo também
				select
 					PS.APELIDO, TT.nome_tp_tx,CTA.dc_HIO DC,CTA.vlr_org_HIO Vlr_Org, CXA.vlr_pgto_rcto_HIO Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hio,'') NF, 
					isnull(CTA.ref_acesso_nf_hio,'') [Site],
					Repasse_TX 
				from 
					custo_cliente cc
					Left Join cta_cte_hou_IMP_OUT	CtA on CC.num_proc=CtA.num_proc_HIO and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_HIO='D'
					Left Join caixa_hou_IMP_OUT		CXA on Cta.num_proc_HIO=CXA.num_proc_HIO and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HIO='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_IMP_OUT			HOU on CC.Num_proc = HOU.Num_proc_HIO
					Join Pessoa				PS	on HOU.CD_CONSIG_HIO = PS.CD_pes
	--				Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_HIO and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_HIO
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hio and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CXA.num_proc_HIO=@Processo and 
					(Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					and fat.fatura_pc is null
			
			Union
				--Cta_Cte à D que não está no Custo também
				select
 					APELIDO, TT.nome_tp_tx,	CTA.dc_HIO DC, CTA.vlr_org_HIO Vlr_Org, CXA.Vlr_Pgto_Rcto_HIO Vlr_PG,
					'REL' cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,	CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,CTA.Num_proc_HIO Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hio,'') NF, 
					isnull(CTA.ref_acesso_nf_hio,'') [Site],
					Repasse_TX 
				from 
					House_IMP_OUT HOU
					Left Join cta_cte_hou_IMP_OUT CtA on HOU.num_proc_HIO=CtA.num_proc_HIO and HOU.CD_CONSIG_HIO = CTA.cd_cred_dev_HIO and CtA.dc_HIO='D'
					Left Join caixa_hou_IMP_OUT CXA on Cta.num_proc_HIO=CXA.num_proc_HIO and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HIO='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.CD_CONSIG_HIO = PS.cd_pes
	--				Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_HIO and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_HIO
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hio and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_HIO=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and fat.fatura_pc is null

			union
				--Cta_Cte D que começa com X
				SELECT
					APELIDO,TT.NOME_TP_TX,CXA.dc_HIO DC,CXA.vlr_pgto_rcto_HIO Vlr_Org, 	CXA.vlr_pgto_rcto_HIO Vlr_PG,
					'REL' cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,CXA.CD_TP_TX CD_TP_TX,
					NULL DebitoCC,CXA.num_proc_HIO Processo,Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_HOU_IMP_OUT CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_HIO=CC.NUM_PROC
					JOIN HOUSE_IMP_OUT HOU ON HOU.NUM_PROC_HIO=CXA.NUM_PROC_HIO
					JOIN PESSOA PP ON PP.CD_PES=CD_CONSIG_HIO
	--				Left Join item_fat ITT on ITT.num_proc=CXA.num_proc_HIO and itt.cd_tp_Tx=CXA.cd_tp_Tx and ITT.dc=CXA.dc_HIO
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CXA.NUM_PROC_HIO and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					CXA.num_proc_HIO=@Processo AND CXA.DC_HIO='D' AND CC.NUM_PROC IS NULL 
					AND  LEFT(CXA.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
					AND fat.fatura_pc IS NULL
			end
	else
		if left(@Processo,2) = 'IM'
			Begin
			Insert @TempTaxas
				-- CtaCte A Crédito Contra o Consignee
				select
					APELIDO, TT.nome_tp_tx,	CTA.dc_him DC, 	CTA.vlr_org_him Vlr_Org, CXA.Vlr_Pgto_Rcto_him Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
--					ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					(case When
							CTA.Num_NF_HIM is not NULL and CTA.ref_acesso_nf_HIM <> 'P'
						Then 
							CTA.Par_NF_HIM 
						else 
							dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
					CTA.CD_TP_TX,Null DebitoCC,	CTA.Num_proc_him Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_him,'') NF, 
					isnull(CTA.ref_acesso_nf_him,'') [Site],
					Repasse_TX 
				from 
					House_Imp_Mar HOU
					Left Join cta_cte_hou_Imp_Mar CtA on HOU.num_proc_him=CtA.num_proc_him and HOU.cd_consig_him = CTA.cd_cred_dev_him and CtA.dc_him='C'
					Left Join caixa_hou_Imp_Mar CXA on Cta.num_proc_him=CXA.num_proc_him and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_him='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.cd_consig_him = PS.cd_pes
				--	Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_him and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_him
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_him and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'	

				where 
					CTA.num_proc_him=@Processo and CTA.Cd_tp_tx <> 'XCA'			
					and  fatura_Pc is null
				
			Union
				--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
				select
					APELIDO, TT.nome_tp_tx,	'D' DC, CC.Vlr_Item_Custo Vlr_Org, CC.vlr_Item_Custo Vlr_PG,
					'REL' cd_tp_moeda,ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_him,'') NF, 
					isnull(CTA.ref_acesso_nf_him,'') [Site],
					Repasse_TX
				from 
					custo_cliente cc
					Left Join caixa_hou_Imp_Mar		CXA	on CC.num_proc=CXA.num_proc_him and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_him='D'
					Left Join cta_cte_hou_Imp_Mar	CtA on CC.num_proc=CtA.num_proc_him and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_him='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_Imp_Mar			HOU on CC.Num_proc = HOU.Num_proc_him
					Left Join Pessoa				PS	on HOU.cd_consig_him = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_him and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'	
				where 
					CC.num_proc=@Processo and num_lcto is null and cta.num_proc_him is null 
					and (Prestacao = 'S' or Prestacao is null) and fatura_pc is null
			
			Union 
				--Cta_Cte à D que está no Custo também
				select
					PS.APELIDO, TT.nome_tp_tx,CTA.dc_him DC,CTA.vlr_org_him Vlr_Org, CXA.vlr_pgto_rcto_him Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_him,'') NF, 
					isnull(CTA.ref_acesso_nf_him,'') [Site],
					Repasse_TX
				from 
					custo_cliente cc
					Left Join cta_cte_hou_Imp_Mar	CtA on CC.num_proc=CtA.num_proc_him and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_him='D'
					Left Join caixa_hou_Imp_Mar		CXA on Cta.num_proc_him=CXA.num_proc_him and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_him='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_Imp_Mar			HOU on CC.Num_proc = HOU.Num_proc_him
					Join Pessoa				PS	on HOU.cd_consig_him = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_him and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CXA.num_proc_him=@Processo and 
					(Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					and fatura_pc is null
			
			Union
				--Cta_Cte à D que não está no Custo também
				select
					APELIDO, TT.nome_tp_tx,	CTA.dc_him DC, CTA.vlr_org_him Vlr_Org, CXA.Vlr_Pgto_Rcto_him Vlr_PG,
					'REL' cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,	CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,CTA.Num_proc_him Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_him,'') NF, 
					isnull(CTA.ref_acesso_nf_him,'') [Site],
					Repasse_TX
				from 
					House_Imp_Mar HOU
					Left Join cta_cte_hou_Imp_Mar CtA on HOU.num_proc_him=CtA.num_proc_him and HOU.cd_consig_him = CTA.cd_cred_dev_him and CtA.dc_him='D'
					Left Join caixa_hou_Imp_Mar CXA on Cta.num_proc_him=CXA.num_proc_him and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_him='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.cd_consig_him = PS.cd_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_him and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_him=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and fatura_pc is null

			union
				--Cta_Cte D que começa com X
				SELECT
					APELIDO,TT.NOME_TP_TX,CXA.dc_him DC,CXA.vlr_pgto_rcto_him Vlr_Org, 	CXA.vlr_pgto_rcto_him Vlr_PG,
					'REL' cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,CXA.CD_TP_TX CD_TP_TX,
					NULL DebitoCC,CXA.num_proc_him Processo,Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_HOU_Imp_Mar CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_him=CC.NUM_PROC
					JOIN HOUSE_Imp_Mar HOU ON HOU.NUM_PROC_him=CXA.NUM_PROC_him
					JOIN PESSOA PP ON PP.CD_PES=cd_consig_him
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=cxa.num_proc_him and itt.cd_tp_Tx=cxa.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'	
				WHERE
					CXA.num_proc_him=@Processo AND CXA.DC_him='D' AND CC.NUM_PROC IS NULL 
					AND  LEFT(CXA.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
					AND fat.fatura_pc is null

			end

	else
		if left(@Processo,2) = 'EM'
			Begin
			Insert @TempTaxas
			-- CtaCte A Crédito Contra o Consignee
				select
					APELIDO, TT.nome_tp_tx,	CTA.dc_hem DC, 	CTA.vlr_org_hem Vlr_Org, CXA.Vlr_Pgto_Rcto_hem Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda, 
--					ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					(case When
							CTA.Num_NF_HEM is not NULL and CTA.ref_acesso_nf_HEM <> 'P'
						Then 
							CTA.Par_NF_HEM 
						else 
							dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
					CTA.CD_TP_TX,
					Null DebitoCC,CTA.Num_proc_hem Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hem,'') NF, 
					isnull(CTA.ref_acesso_nf_hem,'') [Site],
					Repasse_TX
				from 
					House_exp_mar HOU
					Left Join cta_cte_hou_exp_mar CtA on HOU.num_proc_hem=CtA.num_proc_hem and HOU.cd_Export_hem = CTA.cd_cred_dev_hem and CtA.dc_hem='C'
					Left Join caixa_hou_exp_mar CXA on Cta.num_proc_hem=CXA.num_proc_hem and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hem='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.cd_Export_hem = PS.cd_pes
--					Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hem
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_hem=@Processo and CTA.Cd_tp_tx <> 'XCA'			
					and fat.fatura_pc is null

			Union
				--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
				select
					APELIDO, TT.nome_tp_tx,'D' DC, CC.Vlr_Item_Custo Vlr_Org, 
					CC.vlr_Item_Custo Vlr_PG,'REL' cd_tp_moeda,	ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,	CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hem,'') NF, 
					isnull(CTA.ref_acesso_nf_hem,'') [Site],
					Repasse_TX
				from 
					custo_cliente cc
					Left Join caixa_hou_exp_mar		CXA	on CC.num_proc=CXA.num_proc_hem and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hem='D'
					Left Join cta_cte_hou_exp_mar	CtA on CC.num_proc=CtA.num_proc_hem and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_hem='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_exp_mar			HOU on CC.Num_proc = HOU.Num_proc_hem
					Left Join Pessoa				PS	on HOU.cd_Export_hem = PS.CD_pes
--					Left Join item_fat ITT on ITT.num_proc=CC.num_proc and itt.cd_tp_Tx=CC.cd_tp_Tx --and itt.dc=CC.dc_hem
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'	
				where 
					CC.num_proc=@Processo and num_lcto is null and cta.num_proc_hem is null 
					and (Prestacao = 'S' or Prestacao is null)
					and fat.fatura_pc is null
				
			Union 
				--Cta_Cte à D que está no Custo também
				select
					PS.APELIDO, TT.nome_tp_tx,	CTA.dc_hem DC,CTA.vlr_org_hem Vlr_Org, 
					CXA.vlr_pgto_rcto_hem Vlr_PG,CTA.cd_tp_moeda cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hem,'') NF, 
					isnull(CTA.ref_acesso_nf_hem,'') [Site],
					Repasse_TX
				from 
					custo_cliente cc
					Left Join cta_cte_hou_exp_mar	CtA on CC.num_proc=CtA.num_proc_hem and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_hem='D'
					Left Join caixa_hou_exp_mar		CXA on Cta.num_proc_hem=CXA.num_proc_hem and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hem='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_exp_mar			HOU on CC.Num_proc = HOU.Num_proc_hem
					Join Pessoa				PS	on HOU.cd_export_hem = PS.CD_pes
--					Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hem
--ALTERADO POR ANDERSON
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'	
				where 
					CXA.num_proc_hem=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					and fat.fatura_pc is null
				
			union			
				--Cta_Cte à D que não está no Custo também
				select
					APELIDO, TT.nome_tp_tx,	CTA.dc_hem DC,CTA.vlr_org_hem Vlr_Org, 	CXA.Vlr_Pgto_Rcto_hem Vlr_PG,
					'REL' cd_tp_moeda,	iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,CTA.Num_proc_hem Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hem,'') NF, 
					isnull(CTA.ref_acesso_nf_hem,'') [Site],
					Repasse_TX
				from 
					House_exp_mar HOU
					Left Join cta_cte_hou_exp_mar CtA on HOU.num_proc_hem=CtA.num_proc_hem and HOU.cd_export_hem = CTA.cd_cred_dev_hem and CtA.dc_hem='D'
					Left Join caixa_hou_exp_mar CXA on Cta.num_proc_hem=CXA.num_proc_hem and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hem='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.cd_export_hem = PS.cd_pes
---					Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hem
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'	
				where 
					CTA.num_proc_hem=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and fat.fatura_pc is null
			union
				--Cta_Cte D que começa com X
				SELECT
					APELIDO,TT.NOME_TP_TX,CXA.dc_hem DC, CXA.vlr_pgto_rcto_hem Vlr_Org, 
					CXA.vlr_pgto_rcto_hem Vlr_PG,'REL' cd_tp_moeda,	iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,
					CXA.CD_TP_TX CD_TP_TX,NULL DebitoCC,CXA.num_proc_hem Processo,Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_HOU_exp_mar CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_hem=CC.NUM_PROC
					JOIN HOUSE_exp_mar HOU ON HOU.NUM_PROC_hem=CXA.NUM_PROC_hem
					JOIN PESSOA PP ON PP.CD_PES=CD_Export_hem
--					Left Join item_fat ITT on ITT.num_proc=CXA.num_proc_hem and itt.cd_tp_Tx=CXA.cd_tp_Tx and ITT.dc=CXA.dc_hem
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CXA.NUM_PROC_hem and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					CXA.num_proc_hem=@Processo AND CXA.DC_hem='D' AND CC.NUM_PROC IS NULL 
					AND  LEFT(CXA.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
					AND fat.fatura_pc IS NULL
			end

	else	
		if left(@Processo,2) = 'IA'
			Begin
			Insert @TempTaxas
			-- CtaCte A Crédito Contra o Consignee
				select
					APELIDO, TT.nome_tp_tx,	CTA.dc_hia DC, 	CTA.vlr_org_hia Vlr_Org, CXA.Vlr_Pgto_Rcto_hia Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
--					ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					(case When
							CTA.Num_NF_HIA is not NULL and CTA.ref_acesso_nf_HIA <> 'P'
						Then 
							CTA.Par_NF_HIA 
						else 
							dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
					CTA.CD_TP_TX,Null DebitoCC,	CTA.Num_proc_hia Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hia,'') NF, 
					isnull(CTA.ref_acesso_nf_hia,'') [Site],
					Repasse_TX
				from 
					House_imp_aer HOU
					Left Join cta_cte_hou_imp_aer CtA on HOU.num_proc_hia=CtA.num_proc_hia and HOU.CD_CONSIG_hia = CTA.cd_cred_dev_hia and CtA.dc_hia='C'
					Left Join caixa_hou_imp_aer CXA on Cta.num_proc_hia=CXA.num_proc_hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.CD_CONSIG_hia = PS.cd_pes
	--				Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_hia and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hia
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hia and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_hia=@Processo and CTA.Cd_tp_tx <> 'XCA'			
					and fat.fatura_pc is null
				
			Union
			--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
				select
					APELIDO, TT.nome_tp_tx,	'D' DC, CC.Vlr_Item_Custo Vlr_Org, CC.vlr_Item_Custo Vlr_PG,
					'REL' cd_tp_moeda,ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hia,'') NF, 
					isnull(CTA.ref_acesso_nf_hia,'') [Site],
					Repasse_TX
				from 
					custo_cliente cc
					Left Join caixa_hou_imp_aer		CXA	on CC.num_proc=CXA.num_proc_hia and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='D'
					Left Join cta_cte_hou_imp_aer	CtA on CC.num_proc=CtA.num_proc_hia and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_hia='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_imp_aer			HOU on CC.Num_proc = HOU.Num_proc_hia
					Left Join Pessoa				PS	on HOU.CD_CONSIG_hia = PS.CD_pes
	--				Left Join item_fat ITT on ITT.num_proc=CC.num_proc and itt.cd_tp_Tx=CC.cd_tp_Tx --and itt.dc=CC.dc_him
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hia and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CC.num_proc=@Processo and num_lcto is null and cta.num_proc_hia is null 
					and (Prestacao = 'S' or Prestacao is null) and fat.fatura_pc is null
				
			Union
				--Cta_Cte à D que está no Custo também
				select
					PS.APELIDO, TT.nome_tp_tx,CTA.dc_hia DC,CTA.vlr_org_hia Vlr_Org, CXA.vlr_pgto_rcto_hia Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hia,'') NF, 
					isnull(CTA.ref_acesso_nf_hia,'') [Site],
					Repasse_TX
				from 
					custo_cliente cc
					Left Join cta_cte_hou_imp_aer	CtA on CC.num_proc=CtA.num_proc_hia and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_hia='D'
					Left Join caixa_hou_imp_aer		CXA on Cta.num_proc_hia=CXA.num_proc_hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_imp_aer			HOU on CC.Num_proc = HOU.Num_proc_hia
					Join Pessoa						PS	on HOU.CD_CONSIG_hia = PS.CD_pes
	--				Left Join item_fat				ITT on ITT.num_proc=CTA.num_proc_hia and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hia
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hia and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CXA.num_proc_hia=@Processo and 
					(Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					and fat.fatura_pc is null
			
			Union
				--Cta_Cte à D que não está no Custo também
				select
					APELIDO, TT.nome_tp_tx,	CTA.dc_hia DC, CTA.vlr_org_hia Vlr_Org, CXA.Vlr_Pgto_Rcto_hia Vlr_PG,
					'REL' cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,	CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,CTA.Num_proc_hia Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hia,'') NF, 
					isnull(CTA.ref_acesso_nf_hia,'') [Site],
					Repasse_TX
				from 
					House_imp_aer HOU
					Left Join cta_cte_hou_imp_aer CtA on HOU.num_proc_hia=CtA.num_proc_hia and HOU.CD_CONSIG_hia = CTA.cd_cred_dev_hia and CtA.dc_hia='D'
					Left Join caixa_hou_imp_aer CXA on Cta.num_proc_hia=CXA.num_proc_hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.CD_CONSIG_hia = PS.cd_pes
	--				Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_hia and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hia
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hia and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_hia=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and fat.fatura_pc is null

			union
				--Cta_Cte D que começa com X
				SELECT
					APELIDO,TT.NOME_TP_TX,CXA.dc_hia DC,CXA.vlr_pgto_rcto_hia Vlr_Org, 	CXA.vlr_pgto_rcto_hia Vlr_PG,
					'REL' cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,CXA.CD_TP_TX CD_TP_TX,
					NULL DebitoCC,CXA.num_proc_hia Processo,Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_HOU_imp_aer CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_hia=CC.NUM_PROC
					JOIN HOUSE_imp_aer HOU ON HOU.NUM_PROC_hia=CXA.NUM_PROC_hia
					JOIN PESSOA PP ON PP.CD_PES=CD_CONSIG_hia
	--				Left Join item_fat ITT on ITT.num_proc=CXA.num_proc_hia and itt.cd_tp_Tx=CXA.cd_tp_Tx and ITT.dc=CXA.dc_hia
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CXA.NUM_PROC_hia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					CXA.num_proc_hia=@Processo AND CXA.DC_hia='D' AND CC.NUM_PROC IS NULL 
					AND  LEFT(CXA.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
					AND fat.fatura_pc IS NULL
			end

	else
		if left(@Processo,2) = 'EA'
			Begin
			Insert @TempTaxas
		-- CtaCte A Crédito Contra o Consignee
				select
					APELIDO, TT.nome_tp_tx,	CTA.dc_hea DC, 	CTA.vlr_org_hea Vlr_Org, CXA.Vlr_Pgto_Rcto_hea Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda, 
--					ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					(case When
							CTA.Num_NF_HEA is not NULL and CTA.ref_acesso_nf_HEA <> 'P'
						Then 
							CTA.Par_NF_HEA 
						else 
							dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
					CTA.CD_TP_TX,
					Null DebitoCC,CTA.Num_proc_hea Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hea,'') NF, 
					isnull(CTA.ref_acesso_nf_hea,'') [Site],
					Repasse_TX
				from 
					House_exp_aer HOU
					Left Join cta_cte_hou_exp_aer CtA on HOU.num_proc_hea=CtA.num_proc_hea and HOU.cd_Export_hea = CTA.cd_cred_dev_hea and CtA.dc_hea='C'
					Left Join caixa_hou_exp_aer CXA on Cta.num_proc_hea=CXA.num_proc_hea and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hea='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.cd_Export_hea = PS.cd_pes
--					Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_hea and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hea
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hea and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_hea=@Processo and CTA.Cd_tp_tx <> 'XCA'			
					and fat.fatura_pc is null

			Union
				--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
				select
					APELIDO, TT.nome_tp_tx,'D' DC, CC.Vlr_Item_Custo Vlr_Org, 
					CC.vlr_Item_Custo Vlr_PG,'REL' cd_tp_moeda,	ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,	CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hea,'') NF, 
					isnull(CTA.ref_acesso_nf_hea,'') [Site],
					Repasse_TX
				from 
					custo_cliente cc
					Left Join caixa_hou_exp_aer		CXA	on CC.num_proc=CXA.num_proc_hea and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hea='D'
					Left Join cta_cte_hou_exp_aer	CtA on CC.num_proc=CtA.num_proc_hea and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_hea='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_exp_aer			HOU on CC.Num_proc = HOU.Num_proc_hea
					Left Join Pessoa				PS	on HOU.cd_Export_hea = PS.CD_pes
--					Left Join item_fat				ITT on ITT.num_proc=CC.num_proc and itt.cd_tp_Tx=CC.cd_tp_Tx --and itt.dc=CC.dc_hem
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hea and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CC.num_proc=@Processo and num_lcto is null and cta.num_proc_hea is null 
					and (Prestacao = 'S' or Prestacao is null)
					and fat.fatura_pc is null
				
			Union 
				--Cta_Cte à D que está no Custo também
				select
					PS.APELIDO, TT.nome_tp_tx,	CTA.dc_hea DC,CTA.vlr_org_hea Vlr_Org, 
					CXA.vlr_pgto_rcto_hea Vlr_PG,CTA.cd_tp_moeda cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hea,'') NF, 
					isnull(CTA.ref_acesso_nf_hea,'') [Site],
					Repasse_TX 
				from 
					custo_cliente cc
					Left Join cta_cte_hou_exp_aer	CtA on CC.num_proc=CtA.num_proc_hea and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_hea='D'
					Left Join caixa_hou_exp_aer		CXA on Cta.num_proc_hea=CXA.num_proc_hea and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hea='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_exp_aer			HOU on CC.Num_proc = HOU.Num_proc_hea
					Join Pessoa						PS	on HOU.cd_export_hea = PS.CD_pes
--					Left Join item_fat				ITT on ITT.num_proc=CTA.num_proc_hea and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hea
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hea and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CXA.num_proc_hea=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					and fat.fatura_pc is null
				
			union			
				--Cta_Cte à D que não está no Custo também
				select
					APELIDO, TT.nome_tp_tx,	CTA.dc_hea DC,CTA.vlr_org_hea Vlr_Org, 	CXA.Vlr_Pgto_Rcto_hea Vlr_PG,
					'REL' cd_tp_moeda,	iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,CTA.Num_proc_hea Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hea,'') NF, 
					isnull(CTA.ref_acesso_nf_hea,'') [Site],
					Repasse_TX 
				from 
					House_exp_aer HOU
					Left Join cta_cte_hou_exp_aer	CtA on HOU.num_proc_hea=CtA.num_proc_hea and HOU.cd_export_hea = CTA.cd_cred_dev_hea and CtA.dc_hea='D'
					Left Join caixa_hou_exp_aer		CXA on Cta.num_proc_hea=CXA.num_proc_hea and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hea='D'
					Left Join Tipo_Taxa				TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa				PS on HOU.cd_export_hea = PS.cd_pes
--					Left Join item_fat				ITT on ITT.num_proc=CTA.num_proc_hea and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hea
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hea and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_hea=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and fat.fatura_pc is null

			union
				--Cta_Cte D que começa com X
				SELECT
					APELIDO,TT.NOME_TP_TX,CXA.dc_hea DC, CXA.vlr_pgto_rcto_hea Vlr_Org, 
					CXA.vlr_pgto_rcto_hea Vlr_PG,'REL' cd_tp_moeda,	iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,
					CXA.CD_TP_TX CD_TP_TX,NULL DebitoCC,CXA.num_proc_hea Processo,Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_HOU_exp_aer CXA
					JOIN TIPO_TAXA			TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_hea=CC.NUM_PROC
					JOIN HOUSE_exp_aer		HOU ON HOU.NUM_PROC_hea=CXA.NUM_PROC_hea
					JOIN PESSOA				PP ON PP.CD_PES=CD_Export_hea
--					Left Join item_fat		ITT on ITT.num_proc=CXA.num_proc_hea and itt.cd_tp_Tx=CXA.cd_tp_Tx and ITT.dc=CXA.dc_hea
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CXA.NUM_PROC_hea and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					CXA.num_proc_hea=@Processo AND CXA.DC_hea='D' AND CC.NUM_PROC IS NULL 
					AND  LEFT(CXA.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
					AND fat.fatura_pc IS NULL
			end
	END
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
						dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade, 
					CTA.CD_TP_TX,
					Null DebitoCC,
					CTA.Num_proc_MEM Processo,
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mem,'') NF, 
					isnull(CTA.ref_acesso_nf_mem,'') [Site],
					Repasse_TX
				from 
					MASter_EXP_MAR MAS
					Left Join cta_cte_mas_EXP_MAR CtA on MAS.num_proc_MEM=CtA.num_proc_MEM and MAS.cd_EXPORT_MEM = CTA.cd_cred_dev_MEM and CtA.dc_MEM='C'
					Left Join caixa_mas_EXP_MAR CXA on Cta.num_proc_MEM=CXA.num_proc_MEM and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_MEM='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_export_MEM = PS.cd_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mem and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_MEM=@Processo and CTA.Cd_tp_tx <> 'XCA'
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mem,'') NF, 
					isnull(CTA.ref_acesso_nf_mem,'') [Site],
					Repasse_TX
				from 
					custo_processo cc
					Left Join caixa_mas_EXP_MAR		CXA	on CC.num_proc=CXA.num_proc_MEM and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_MEM='D'
					Left Join cta_cte_mas_EXP_MAR	CtA on CC.num_proc=CtA.num_proc_MEM and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_MEM='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_exp_mar			MAS on CC.Num_proc = MAS.Num_proc_MEM
					Left Join Pessoa				PS	on MAS.cd_export_MEM = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mem and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					num_proc=@Processo and num_lcto is null and cta.num_proc_MEM is null --and (Prestacao = 'S' or Prestacao is null)
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mem,'') NF, 
					isnull(CTA.ref_acesso_nf_mem,'') [Site],
					Repasse_TX
				from 
					custo_cliente cc
					Left Join cta_cte_mas_EXP_MAR CtA on CC.num_proc=CtA.num_proc_MEM and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_MEM='D'
					Left Join caixa_mas_EXP_MAR CXA on Cta.num_proc_MEM=CXA.num_proc_MEM and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_MEM='D'
					Left Join Tipo_Taxa TT on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_exp_mar			MAS on CC.Num_proc = MAS.Num_proc_MEM
					Left Join Pessoa				PS	on MAS.cd_export_MEM = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mem and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CXA.num_proc_MEM=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mem,'') NF, 
					isnull(CTA.ref_acesso_nf_mem,'') [Site],
					Repasse_TX 
				from 
					MASter_exp_mar MAS
					Left Join cta_cte_mas_exp_mar CtA on MAS.num_proc_MEM=CtA.num_proc_MEM and MAS.cd_export_MEM = CTA.cd_cred_dev_MEM and CtA.dc_MEM='D'
					Left Join caixa_mas_exp_mar CXA on Cta.num_proc_MEM=CXA.num_proc_MEM and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_MEM='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_export_MEM = PS.cd_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mem and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_MEM=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_mas_EXP_MAR CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_MEM=CC.NUM_PROC
					JOIN MASter_EXP_MAR MAS ON MAS.NUM_PROC_MEM=CXA.NUM_PROC_MEM
					JOIN PESSOA PP ON PP.CD_PES=CD_Export_MEM
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mem and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					CXA.num_proc_MEM=@Processo AND CXA.DC_MEM='D' AND CC.NUM_PROC IS NULL 
					AND LEFT(CXA.CD_TP_tX,1)='X' --AND CXA.CD_TP_TX NOT IN ('XBA')
					AND fat.fatura_pc IS NULL
			 
			End

	else
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
						dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
					CTA.CD_TP_TX,
					Null DebitoCC,
					CTA.Num_proc_mea Processo,
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mea,'') NF, 
					isnull(CTA.ref_acesso_nf_mea,'') [Site],
					Repasse_TX
				from 
					MASter_EXP_aer MAS
					Left Join cta_cte_mas_EXP_aer CtA on MAS.num_proc_mea=CtA.num_proc_mea and MAS.cd_EXPORT_mea = CTA.cd_cred_dev_mea and CtA.dc_mea='C'
					Left Join caixa_mas_EXP_aer CXA on Cta.num_proc_mea=CXA.num_proc_mea and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_mea='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_export_mea = PS.cd_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mea and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_mea=@Processo and CTA.Cd_tp_tx <> 'XCA'
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mea,'') NF, 
					isnull(CTA.ref_acesso_nf_mea,'') [Site],
					Repasse_TX
				from 
					custo_processo cc
					Left Join caixa_mas_EXP_aer		CXA	on CC.num_proc=CXA.num_proc_mea and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_mea='D'
					Left Join cta_cte_mas_EXP_aer	CtA on CC.num_proc=CtA.num_proc_mea and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_mea='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_exp_aer			MAS on CC.Num_proc = MAS.Num_proc_mea
					Left Join Pessoa				PS	on MAS.cd_export_mea = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mea and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					num_proc=@Processo and num_lcto is null and cta.num_proc_mea is null --and (Prestacao = 'S' or Prestacao is null)
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mea,'') NF, 
					isnull(CTA.ref_acesso_nf_mea,'') [Site],
					Repasse_TX 
				from 
					custo_cliente cc
					Left Join cta_cte_mas_EXP_aer CtA on CC.num_proc=CtA.num_proc_mea and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_mea='D'
					Left Join caixa_mas_EXP_aer CXA on Cta.num_proc_mea=CXA.num_proc_mea and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_mea='D'
					Left Join Tipo_Taxa TT on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_exp_aer			MAS on CC.Num_proc = MAS.Num_proc_mea
					Left Join Pessoa				PS	on MAS.cd_export_mea = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mea and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CXA.num_proc_mea=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mea,'') NF, 
					isnull(CTA.ref_acesso_nf_mea,'') [Site],
					Repasse_TX
				from 
					MASter_exp_aer MAS
					Left Join cta_cte_mas_exp_aer CtA on MAS.num_proc_mea=CtA.num_proc_mea and MAS.cd_export_mea = CTA.cd_cred_dev_mea and CtA.dc_mea='D'
					Left Join caixa_mas_exp_aer CXA on Cta.num_proc_mea=CXA.num_proc_mea and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_mea='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_export_mea = PS.cd_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mea and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_mea=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					AND fat.fatura_pc IS NULL

			union
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
					Ref_Ctb_Tx
					,'' NF, 
					''[Site],
					Repasse_TX 
				FROM
					CAIXA_mas_EXP_aer CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_mea=CC.NUM_PROC
					JOIN MASter_EXP_aer MAS ON MAS.NUM_PROC_mea=CXA.NUM_PROC_mea
					JOIN PESSOA PP ON PP.CD_PES=CD_Export_mea
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mea and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					CXA.num_proc_mea=@Processo AND CXA.DC_mea='D' AND CC.NUM_PROC IS NULL 
					AND LEFT(CXA.CD_TP_tX,1)='X' --AND CXA.CD_TP_TX NOT IN ('XBA')
					AND fat.fatura_pc IS NULL
		 
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
						dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
					CTA.CD_TP_TX,
					Null DebitoCC,
					CTA.Num_proc_mia Processo,
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mia,'') NF, 
					isnull(CTA.ref_acesso_nf_mia,'') [Site],
					Repasse_TX
				from 
					MASter_imp_aer MAS
					Left Join cta_cte_mas_imp_aer CtA on MAS.num_proc_mia=CtA.num_proc_mia and MAS.cd_consig_mia = CTA.cd_cred_dev_mia and CtA.dc_mia='C'
					Left Join caixa_mas_imp_aer CXA on Cta.num_proc_mia=CXA.num_proc_mia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_mia='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_consig_mia = PS.cd_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_mia=@Processo and CTA.Cd_tp_tx <> 'XCA'
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mia,'') NF, 
					isnull(CTA.ref_acesso_nf_mia,'') [Site],
					Repasse_TX
				from 
					custo_processo cc
					Left Join caixa_mas_imp_aer		CXA	on CC.num_proc=CXA.num_proc_mia and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_mia='D'
					Left Join cta_cte_mas_imp_aer	CtA on CC.num_proc=CtA.num_proc_mia and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_mia='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_imp_aer			MAS on CC.Num_proc = MAS.Num_proc_mia
					Left Join Pessoa				PS	on MAS.cd_consig_mia = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					num_proc=@Processo and num_lcto is null and cta.num_proc_mia is null --and (Prestacao = 'S' or Prestacao is null)
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mia,'') NF, 
					isnull(CTA.ref_acesso_nf_mia,'') [Site],
					Repasse_TX
				from 
					custo_cliente cc
					Left Join cta_cte_mas_imp_aer CtA on CC.num_proc=CtA.num_proc_mia and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_mia='D'
					Left Join caixa_mas_imp_aer CXA on Cta.num_proc_mia=CXA.num_proc_mia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_mia='D'
					Left Join Tipo_Taxa TT on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_imp_aer			MAS on CC.Num_proc = MAS.Num_proc_mia
					Left Join Pessoa				PS	on MAS.cd_consig_mia = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CXA.num_proc_mia=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mia,'') NF, 
					isnull(CTA.ref_acesso_nf_mia,'') [Site],
					Repasse_TX
				from 
					MASter_imp_aer MAS
					Left Join cta_cte_mas_imp_aer CtA on MAS.num_proc_mia=CtA.num_proc_mia and MAS.cd_consig_mia = CTA.cd_cred_dev_mia and CtA.dc_mia='D'
					Left Join caixa_mas_imp_aer CXA on Cta.num_proc_mia=CXA.num_proc_mia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_mia='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_consig_mia = PS.cd_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_mia=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_mas_imp_aer CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_mia=CC.NUM_PROC
					JOIN MASter_imp_aer MAS ON MAS.NUM_PROC_mia=CXA.NUM_PROC_mia
					JOIN PESSOA PP ON PP.CD_PES=CD_consig_mia
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					CXA.num_proc_mia=@Processo AND CXA.DC_mia='D' AND CC.NUM_PROC IS NULL 
					AND LEFT(CXA.CD_TP_tX,1)='X' --AND CXA.CD_TP_TX NOT IN ('XBA')
					AND fat.fatura_pc IS NULL
			 
			End

	else
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
						dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
					CTA.CD_TP_TX,
					Null DebitoCC,
					CTA.Num_proc_Mim Processo,
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mim,'') NF, 
					isnull(CTA.ref_acesso_nf_mim,'') [Site],
					Repasse_TX 
				from 
					MASter_imp_mar MAS
					Left Join cta_cte_mas_imp_mar CtA on MAS.num_proc_Mim=CtA.num_proc_Mim and MAS.cd_consig_Mim = CTA.cd_cred_dev_Mim and CtA.dc_Mim='C'
					Left Join caixa_mas_imp_mar CXA on Cta.num_proc_Mim=CXA.num_proc_Mim and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Mim='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_consig_Mim = PS.cd_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mim and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_Mim=@Processo and CTA.Cd_tp_tx <> 'XCA'
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mim,'') NF, 
					isnull(CTA.ref_acesso_nf_mim,'') [Site],
					Repasse_TX  
				from 
					custo_processo cc
					Left Join caixa_mas_imp_mar		CXA	on CC.num_proc=CXA.num_proc_Mim and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Mim='D'
					Left Join cta_cte_mas_imp_mar	CtA on CC.num_proc=CtA.num_proc_Mim and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_Mim='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_imp_mar			MAS on CC.Num_proc = MAS.Num_proc_Mim
					Left Join Pessoa				PS	on MAS.cd_consig_Mim = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mim and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					num_proc=@Processo and num_lcto is null and cta.num_proc_Mim is null --and (Prestacao = 'S' or Prestacao is null)
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mim,'') NF, 
					isnull(CTA.ref_acesso_nf_mim,'') [Site],
					Repasse_TX 
				from 
					custo_cliente cc
					Left Join cta_cte_mas_imp_mar CtA on CC.num_proc=CtA.num_proc_Mim and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_Mim='D'
					Left Join caixa_mas_imp_mar CXA on Cta.num_proc_Mim=CXA.num_proc_Mim and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Mim='D'
					Left Join Tipo_Taxa TT on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_imp_mar			MAS on CC.Num_proc = MAS.Num_proc_Mim
					Left Join Pessoa				PS	on MAS.cd_consig_Mim = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mim and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CXA.num_proc_Mim=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mim,'') NF, 
					isnull(CTA.ref_acesso_nf_mim,'') [Site],
					Repasse_TX 
				from 
					MASter_imp_mar MAS
					Left Join cta_cte_mas_imp_mar CtA on MAS.num_proc_Mim=CtA.num_proc_Mim and MAS.cd_consig_Mim = CTA.cd_cred_dev_Mim and CtA.dc_Mim='D'
					Left Join caixa_mas_imp_mar CXA on Cta.num_proc_Mim=CXA.num_proc_Mim and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Mim='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_consig_Mim = PS.cd_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mim and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_Mim=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_mas_imp_mar CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_Mim=CC.NUM_PROC
					JOIN MASter_imp_mar MAS ON MAS.NUM_PROC_Mim=CXA.NUM_PROC_Mim
					JOIN PESSOA PP ON PP.CD_PES=CD_consig_Mim
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mim and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					CXA.num_proc_Mim=@Processo AND CXA.DC_Mim='D' AND CC.NUM_PROC IS NULL 
					AND LEFT(CXA.CD_TP_tX,1)='X' --AND CXA.CD_TP_TX NOT IN ('XBA')
					AND fat.fatura_pc IS NULL
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
		on T.cd_tp_Moeda = T1.cd_tp_moeda and T1.NF is not NULL
	--select Moeda,Paridade from @TempTaxas as T2 where NF is not NULL
	--where NF is NULL
		
	select * from @TempTaxas


*/




















































	
--	if left(@Processo,2) = 'IO'
--		Begin
---- CtaCte A Crédito Contra o Consignee
--			select
-- 				APELIDO, TT.nome_tp_tx,	CTA.dc_him DC, 	CTA.vlr_org_him Vlr_Org, CXA.Vlr_Pgto_Rcto_him Vlr_PG,
--				CTA.cd_tp_moeda cd_tp_moeda,ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
--				CTA.CD_TP_TX,Null DebitoCC,	CTA.Num_proc_him Processo
--			from 
--				House_Imp_Mar HOU
--				Left Join cta_cte_hou_Imp_Mar CtA on HOU.num_proc_him=CtA.num_proc_him and HOU.cd_consig_him = CTA.cd_cred_dev_him and CtA.dc_him='C'
--				Left Join caixa_hou_Imp_Mar CXA on Cta.num_proc_him=CXA.num_proc_him and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_him='C'
--				Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
--				Left Join Pessoa PS on HOU.cd_consig_him = PS.cd_pes
--				Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_him and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_him
--			where 
--				CTA.num_proc_him=@Processo and CTA.Cd_tp_tx <> 'XCA'			
--				and itt.num_proc is null
--			
--			Union
----Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
--			select
-- 				APELIDO, TT.nome_tp_tx,	'D' DC, CC.Vlr_Item_Custo Vlr_Org, CC.vlr_Item_Custo Vlr_PG,
--				'REL' cd_tp_moeda,ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
--				CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,CC.num_proc Processo
--			from 
--				custo_cliente cc
--				Left Join caixa_hou_Imp_Mar		CXA	on CC.num_proc=CXA.num_proc_him and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_him='D'
--				Left Join cta_cte_hou_Imp_Mar	CtA on CC.num_proc=CtA.num_proc_him and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_him='D'
--				Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
--				Left Join House_Imp_Mar			HOU on CC.Num_proc = HOU.Num_proc_him
--				Left Join Pessoa				PS	on HOU.cd_consig_him = PS.CD_pes
--				Left Join item_fat ITT on ITT.num_proc=CC.num_proc and itt.cd_tp_Tx=CC.cd_tp_Tx --and itt.dc=CC.dc_him
--			where 
--				CC.num_proc=@Processo and num_lcto is null and cta.num_proc_him is null 
--				and (Prestacao = 'S' or Prestacao is null) and itt.num_proc is null
--			
--			Union 
--
----Cta_Cte à D que está no Custo também
--			select
-- 				PS.APELIDO, TT.nome_tp_tx,CTA.dc_him DC,CTA.vlr_org_him Vlr_Org, CXA.vlr_pgto_rcto_him Vlr_PG,
--				CTA.cd_tp_moeda cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
--				CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,CC.num_proc Processo
--			from 
--				custo_cliente cc
--				Left Join cta_cte_hou_Imp_Mar	CtA on CC.num_proc=CtA.num_proc_him and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_him='D'
--				Left Join caixa_hou_Imp_Mar		CXA on Cta.num_proc_him=CXA.num_proc_him and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_him='D'
--				Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
--				Left Join House_Imp_Mar			HOU on CC.Num_proc = HOU.Num_proc_him
--				Join Pessoa				PS	on HOU.cd_consig_him = PS.CD_pes
--				Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_him and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_him
--			where 
--				CXA.num_proc_him=@Processo and 
--				(Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
--				and itt.num_proc is null
--		
--			Union
----Cta_Cte à D que não está no Custo também
--			select
-- 				APELIDO, TT.nome_tp_tx,	CTA.dc_him DC, CTA.vlr_org_him Vlr_Org, CXA.Vlr_Pgto_Rcto_him Vlr_PG,
--				'REL' cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,	CTA.CD_TP_TX CD_TP_TX, 
--				Null DebitoCC,CTA.Num_proc_him Processo
--			from 
--				House_Imp_Mar HOU
--				Left Join cta_cte_hou_Imp_Mar CtA on HOU.num_proc_him=CtA.num_proc_him and HOU.cd_consig_him = CTA.cd_cred_dev_him and CtA.dc_him='D'
--				Left Join caixa_hou_Imp_Mar CXA on Cta.num_proc_him=CXA.num_proc_him and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_him='D'
--				Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
--				Left Join Pessoa PS on HOU.cd_consig_him = PS.cd_pes
--				Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_him and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_him
--			where 
--				CTA.num_proc_him=@Processo and CTA.CD_TP_TX in ('C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
--				and itt.num_proc is null
--
--			union
--
----Cta_Cte D que começa com X
--			SELECT
--				APELIDO,TT.NOME_TP_TX,CXA.dc_him DC,CXA.vlr_pgto_rcto_him Vlr_Org, 	CXA.vlr_pgto_rcto_him Vlr_PG,
--				'REL' cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,CXA.CD_TP_TX CD_TP_TX,
--				NULL DebitoCC,CXA.num_proc_him Processo
--			FROM
--				CAIXA_HOU_Imp_Mar CXA
--				JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
--				Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_him=CC.NUM_PROC
--				JOIN HOUSE_Imp_Mar HOU ON HOU.NUM_PROC_him=CXA.NUM_PROC_him
--				JOIN PESSOA PP ON PP.CD_PES=cd_consig_him
--				Left Join item_fat ITT on ITT.num_proc=CXA.num_proc_him and itt.cd_tp_Tx=CXA.cd_tp_Tx and ITT.dc=CXA.dc_him
--			WHERE
--				CXA.num_proc_him=@Processo AND CXA.DC_him='D' AND CC.NUM_PROC IS NULL 
--				AND  LEFT(CXA.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
--				AND ITT.NUM_PROC IS NULL
--
--	END


--END

--
--if left(@Processo,2) = 'EM'
--			Begin 
--				-- CtaCte A Crédito Contra o Consignee
--				select
--					APELIDO, TT.nome_tp_tx,	CTA.dc_hem DC, 	CTA.vlr_org_hem Vlr_Org, CXA.Vlr_Pgto_Rcto_hem Vlr_PG,
--					CTA.cd_tp_moeda cd_tp_moeda, ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX,
--					Null DebitoCC,CTA.Num_proc_hem Processo
--				from 
--					House_exp_mar HOU
--					Left Join cta_cte_hou_exp_mar CtA on HOU.num_proc_hem=CtA.num_proc_hem and HOU.cd_Export_hem = CTA.cd_cred_dev_hem and CtA.dc_hem='C'
--					Left Join caixa_hou_exp_mar CXA on Cta.num_proc_hem=CXA.num_proc_hem and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hem='C'
--					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
--					Left Join Pessoa PS on HOU.cd_Export_hem = PS.cd_pes
----					Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hem
--					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
--					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
--				where 
--					CTA.num_proc_hem=@Processo and CTA.Cd_tp_tx <> 'XCA'			
--					and fat.fatura_pc is null
--
--				Union
--				--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
--				select
--					APELIDO, TT.nome_tp_tx,'D' DC, CC.Vlr_Item_Custo Vlr_Org, 
--					CC.vlr_Item_Custo Vlr_PG,'REL' cd_tp_moeda,	ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
--					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,	CC.num_proc Processo
--				from 
--					custo_cliente cc
--					Left Join caixa_hou_exp_mar		CXA	on CC.num_proc=CXA.num_proc_hem and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hem='D'
--					Left Join cta_cte_hou_exp_mar	CtA on CC.num_proc=CtA.num_proc_hem and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_hem='D'
--					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
--					Left Join House_exp_mar			HOU on CC.Num_proc = HOU.Num_proc_hem
--					Left Join Pessoa				PS	on HOU.cd_Export_hem = PS.CD_pes
----					Left Join item_fat ITT on ITT.num_proc=CC.num_proc and itt.cd_tp_Tx=CC.cd_tp_Tx --and itt.dc=CC.dc_hem
--					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
--					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
--				where 
--					CC.num_proc=@Processo and num_lcto is null and cta.num_proc_hem is null 
--					and (Prestacao = 'S' or Prestacao is null)
--					and fat.fatura_pc is null
--				
--				Union 
--
--				--Cta_Cte à D que está no Custo também
--				select
--					PS.APELIDO, TT.nome_tp_tx,	CTA.dc_hem DC,CTA.vlr_org_hem Vlr_Org, 
--					CXA.vlr_pgto_rcto_hem Vlr_PG,CTA.cd_tp_moeda cd_tp_moeda,
--					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX,
--					CC.CD_tp_tx DebitoCC,CC.num_proc Processo
--				from 
--					custo_cliente cc
--					Left Join cta_cte_hou_exp_mar	CtA on CC.num_proc=CtA.num_proc_hem and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_hem='D'
--					Left Join caixa_hou_exp_mar		CXA on Cta.num_proc_hem=CXA.num_proc_hem and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hem='D'
--					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
--					Left Join House_exp_mar			HOU on CC.Num_proc = HOU.Num_proc_hem
--					Join Pessoa				PS	on HOU.cd_export_hem = PS.CD_pes
----					Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hem
--					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
--					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
--				where 
--					CXA.num_proc_hem=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
--					and fat.fatura_pc is null
--				
--				union			
--				--Cta_Cte à D que não está no Custo também
--				select
--					APELIDO, TT.nome_tp_tx,	CTA.dc_hem DC,CTA.vlr_org_hem Vlr_Org, 	CXA.Vlr_Pgto_Rcto_hem Vlr_PG,
--					'REL' cd_tp_moeda,	iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX CD_TP_TX, 
--					Null DebitoCC,CTA.Num_proc_hem Processo
--				from 
--					House_exp_mar HOU
--					Left Join cta_cte_hou_exp_mar CtA on HOU.num_proc_hem=CtA.num_proc_hem and HOU.cd_export_hem = CTA.cd_cred_dev_hem and CtA.dc_hem='D'
--					Left Join caixa_hou_exp_mar CXA on Cta.num_proc_hem=CXA.num_proc_hem and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hem='D'
--					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
--					Left Join Pessoa PS on HOU.cd_export_hem = PS.cd_pes
----					Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hem
--					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
--					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
--				where 
--					CTA.num_proc_hem=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
--					and fat.fatura_pc is null
--
--				union
--				--Cta_Cte D que começa com X
--				SELECT
--					APELIDO,TT.NOME_TP_TX,CXA.dc_hem DC, CXA.vlr_pgto_rcto_hem Vlr_Org, 
--					CXA.vlr_pgto_rcto_hem Vlr_PG,'REL' cd_tp_moeda,	iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,
--					CXA.CD_TP_TX CD_TP_TX,NULL DebitoCC,CXA.num_proc_hem Processo
--				FROM
--					CAIXA_HOU_exp_mar CXA
--					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
--					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_hem=CC.NUM_PROC
--					JOIN HOUSE_exp_mar HOU ON HOU.NUM_PROC_hem=CXA.NUM_PROC_hem
--					JOIN PESSOA PP ON PP.CD_PES=CD_Export_hem
----					Left Join item_fat ITT on ITT.num_proc=CXA.num_proc_hem and itt.cd_tp_Tx=CXA.cd_tp_Tx and ITT.dc=CXA.dc_hem
--					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CXA.NUM_PROC_hem and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
--					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
--				WHERE
--					CXA.num_proc_hem=@Processo AND CXA.DC_hem='D' AND CC.NUM_PROC IS NULL 
--					AND  LEFT(CXA.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
--					AND fat.fatura_pc IS NULL
--			end


*/	

/* Velha
IF len(@Processo) = 16
	BEGIN
		if left(@Processo,2) = 'EO'
			Begin
			Insert @TempTaxas
	-- CtaCte A Crédito Contra o Consignee
				select
 					APELIDO, TT.nome_tp_tx,	CTA.dc_HEO DC, 	CTA.vlr_org_HEO Vlr_Org, CXA.Vlr_Pgto_Rcto_Heo Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda, 
--					ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					(case When
							CTA.Num_NF_HEO is not NULL and CTA.ref_acesso_nf_heO <> 'P'
						Then 
							CTA.Par_NF_HeO 
						else 
							dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
					CTA.CD_TP_TX,
					Null DebitoCC,CTA.Num_proc_HEO Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_heo,'') NF, 
					isnull(CTA.ref_acesso_nf_heo,'') [Site],
					Repasse_TX 
				from 
					House_EXP_OUT HOU
					Left Join cta_cte_hou_EXP_OUT CtA on HOU.num_proc_HEO=CtA.num_proc_HEO and HOU.cd_Export_HEO = CTA.cd_cred_dev_HEO and CtA.dc_HEO='C'
					Left Join caixa_hou_EXP_OUT CXA on Cta.num_proc_HEO=CXA.num_proc_HEO and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HEO='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.cd_Export_HEO = PS.cd_pes
					Left Join Fatura_CHB_ITEM ITT on left(fatura_cc,16)=CTA.num_proc_heo and itt.cd_tp_Tx=CTA.cd_tp_Tx 
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'						
				where 
					CTA.num_proc_HEO=@Processo and CTA.Cd_tp_tx <> 'XCA'			
					and fat.fatura_pc is null

			Union
				--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
				select
					APELIDO, TT.nome_tp_tx,'D' DC, CC.Vlr_Item_Custo Vlr_Org, 
					CC.vlr_Item_Custo Vlr_PG,'REL' cd_tp_moeda,	ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,	CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_heo,'') NF, 
					isnull(CTA.ref_acesso_nf_heo,'') [Site],
					Repasse_TX 
				from 
					custo_cliente cc
					Left Join caixa_hou_EXP_OUT		CXA	on CC.num_proc=CXA.num_proc_HEO and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HEO='D'
					Left Join cta_cte_hou_EXP_OUT	CtA on CC.num_proc=CtA.num_proc_HEO and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_HEO='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_EXP_OUT			HOU on CC.Num_proc = HOU.Num_proc_HEO
					Left Join Pessoa				PS	on HOU.cd_Export_HEO = PS.CD_pes
--					Left Join item_fat ITT on ITT.num_proc=CC.num_proc and itt.cd_tp_Tx=CC.cd_tp_Tx --and itt.dc=CC.dc_heo
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_heo and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CC.num_proc=@Processo and num_lcto is null and cta.num_proc_HEO is null 
					and (Prestacao = 'S' or Prestacao is null)
					and fat.fatura_pc is null
				
			Union 
				--Cta_Cte à D que está no Custo também
				select
 					PS.APELIDO, TT.nome_tp_tx,	CTA.dc_heo DC,CTA.vlr_org_heo Vlr_Org, 
					CXA.vlr_pgto_rcto_heo Vlr_PG,CTA.cd_tp_moeda cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_heo,'') NF, 
					isnull(CTA.ref_acesso_nf_heo,'') [Site],
					Repasse_TX 
				from 
					custo_cliente cc
					Left Join cta_cte_hou_exp_OUT	CtA on CC.num_proc=CtA.num_proc_heo and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_heo='D'
					Left Join caixa_hou_exp_OUT		CXA on Cta.num_proc_heo=CXA.num_proc_heo and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_heo='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_exp_OUT			HOU on CC.Num_proc = HOU.Num_proc_heo
					Join Pessoa				PS	on HOU.cd_export_heo = PS.CD_pes
--					Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_heo and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_heo
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_heo and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CXA.num_proc_heo=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					and fat.fatura_pc is null
				
			union			
				--Cta_Cte à D que não está no Custo também
				select
 					APELIDO, TT.nome_tp_tx,	CTA.dc_HEO DC,CTA.vlr_org_HEO Vlr_Org, 	CXA.Vlr_Pgto_Rcto_HEO Vlr_PG,
					'REL' cd_tp_moeda,	iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,CTA.Num_proc_Heo Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_heo,'') NF, 
					isnull(CTA.ref_acesso_nf_heo,'') [Site],
					Repasse_TX 
				from 
					House_exp_out HOU
					Left Join cta_cte_hou_exp_out CtA on HOU.num_proc_HEO=CtA.num_proc_HEO and HOU.cd_export_HEO = CTA.cd_cred_dev_HEO and CtA.dc_HEO='D'
					Left Join caixa_hou_exp_out CXA on Cta.num_proc_Heo=CXA.num_proc_Heo and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Heo='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.cd_export_heo = PS.cd_pes
--					Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_heo and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_heo
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_heo and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_heo=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and fat.fatura_pc is null

			union
				--Cta_Cte D que começa com X
				SELECT
					APELIDO,TT.NOME_TP_TX,CXA.dc_HEO DC, CXA.vlr_pgto_rcto_HEO Vlr_Org, 
					CXA.vlr_pgto_rcto_HEO Vlr_PG,'REL' cd_tp_moeda,	iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,
					CXA.CD_TP_TX CD_TP_TX,NULL DebitoCC,CXA.num_proc_HEO Processo,Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_HOU_EXP_OUT CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_HEO=CC.NUM_PROC
					JOIN HOUSE_EXP_OUT HOU ON HOU.NUM_PROC_HEO=CXA.NUM_PROC_HEO
					JOIN PESSOA PP ON PP.CD_PES=CD_Export_HEO
--					Left Join item_fat ITT on ITT.num_proc=CXA.num_proc_heo and itt.cd_tp_Tx=CXA.cd_tp_Tx and ITT.dc=CXA.dc_heo
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CXA.NUM_PROC_HEO and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'	
				WHERE
					CXA.num_proc_HEO=@Processo AND CXA.DC_HEO='D' AND CC.NUM_PROC IS NULL 
					AND  LEFT(CXA.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
					AND fat.fatura_pc IS NULL
			end
	
	else
		if left(@Processo,2) = 'IO'
			Begin
			Insert @TempTaxas
				-- CtaCte A Crédito Contra o Consignee
				select
 					APELIDO, TT.nome_tp_tx,	CTA.dc_HIO DC, 	CTA.vlr_org_HIO Vlr_Org, CXA.Vlr_Pgto_Rcto_HIO Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
--					ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					(case When
							CTA.Num_NF_HIO is not NULL and CTA.ref_acesso_nf_HIO <> 'P'
						Then 
							CTA.Par_NF_HIO 
						else 
							dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,

					CTA.CD_TP_TX,Null DebitoCC,	CTA.Num_proc_HIO Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hio,'') NF, 
					isnull(CTA.ref_acesso_nf_hio,'') [Site],
					Repasse_TX 
				from 
					House_IMP_OUT HOU
					Left Join cta_cte_hou_IMP_OUT CtA on HOU.num_proc_HIO=CtA.num_proc_HIO and HOU.CD_CONSIG_HIO = CTA.cd_cred_dev_HIO and CtA.dc_HIO='C'
					Left Join caixa_hou_IMP_OUT CXA on Cta.num_proc_HIO=CXA.num_proc_HIO and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HIO='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.CD_CONSIG_HIO = PS.cd_pes
	--				Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_HIO and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_HIO
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hio and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_HIO=@Processo and CTA.Cd_tp_tx <> 'XCA'			
					and fat.fatura_pc is null
			Union
				--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
				select
 					APELIDO, TT.nome_tp_tx,	'D' DC, CC.Vlr_Item_Custo Vlr_Org, CC.vlr_Item_Custo Vlr_PG,
					'REL' cd_tp_moeda,ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hio,'') NF, 
					isnull(CTA.ref_acesso_nf_hio,'') [Site],
					Repasse_TX 
				from 
					custo_cliente cc
					Left Join caixa_hou_IMP_OUT		CXA	on CC.num_proc=CXA.num_proc_HIO and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HIO='D'
					Left Join cta_cte_hou_IMP_OUT	CtA on CC.num_proc=CtA.num_proc_HIO and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_HIO='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_IMP_OUT			HOU on CC.Num_proc = HOU.Num_proc_HIO
					Left Join Pessoa				PS	on HOU.CD_CONSIG_HIO = PS.CD_pes
	--				Left Join item_fat ITT on ITT.num_proc=CC.num_proc and itt.cd_tp_Tx=CC.cd_tp_Tx --and itt.dc=CC.dc_HIO
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hio and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CC.num_proc=@Processo and num_lcto is null and cta.num_proc_HIO is null 
					and (Prestacao = 'S' or Prestacao is null) and fat.fatura_pc is null
				
			Union
				--Cta_Cte à D que está no Custo também
				select
 					PS.APELIDO, TT.nome_tp_tx,CTA.dc_HIO DC,CTA.vlr_org_HIO Vlr_Org, CXA.vlr_pgto_rcto_HIO Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hio,'') NF, 
					isnull(CTA.ref_acesso_nf_hio,'') [Site],
					Repasse_TX 
				from 
					custo_cliente cc
					Left Join cta_cte_hou_IMP_OUT	CtA on CC.num_proc=CtA.num_proc_HIO and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_HIO='D'
					Left Join caixa_hou_IMP_OUT		CXA on Cta.num_proc_HIO=CXA.num_proc_HIO and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HIO='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_IMP_OUT			HOU on CC.Num_proc = HOU.Num_proc_HIO
					Join Pessoa				PS	on HOU.CD_CONSIG_HIO = PS.CD_pes
	--				Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_HIO and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_HIO
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hio and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CXA.num_proc_HIO=@Processo and 
					(Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					and fat.fatura_pc is null
			
			Union
				--Cta_Cte à D que não está no Custo também
				select
 					APELIDO, TT.nome_tp_tx,	CTA.dc_HIO DC, CTA.vlr_org_HIO Vlr_Org, CXA.Vlr_Pgto_Rcto_HIO Vlr_PG,
					'REL' cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,	CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,CTA.Num_proc_HIO Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hio,'') NF, 
					isnull(CTA.ref_acesso_nf_hio,'') [Site],
					Repasse_TX 
				from 
					House_IMP_OUT HOU
					Left Join cta_cte_hou_IMP_OUT CtA on HOU.num_proc_HIO=CtA.num_proc_HIO and HOU.CD_CONSIG_HIO = CTA.cd_cred_dev_HIO and CtA.dc_HIO='D'
					Left Join caixa_hou_IMP_OUT CXA on Cta.num_proc_HIO=CXA.num_proc_HIO and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HIO='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.CD_CONSIG_HIO = PS.cd_pes
	--				Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_HIO and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_HIO
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hio and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_HIO=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and fat.fatura_pc is null

			union
				--Cta_Cte D que começa com X
				SELECT
					APELIDO,TT.NOME_TP_TX,CXA.dc_HIO DC,CXA.vlr_pgto_rcto_HIO Vlr_Org, 	CXA.vlr_pgto_rcto_HIO Vlr_PG,
					'REL' cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,CXA.CD_TP_TX CD_TP_TX,
					NULL DebitoCC,CXA.num_proc_HIO Processo,Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_HOU_IMP_OUT CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_HIO=CC.NUM_PROC
					JOIN HOUSE_IMP_OUT HOU ON HOU.NUM_PROC_HIO=CXA.NUM_PROC_HIO
					JOIN PESSOA PP ON PP.CD_PES=CD_CONSIG_HIO
	--				Left Join item_fat ITT on ITT.num_proc=CXA.num_proc_HIO and itt.cd_tp_Tx=CXA.cd_tp_Tx and ITT.dc=CXA.dc_HIO
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CXA.NUM_PROC_HIO and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					CXA.num_proc_HIO=@Processo AND CXA.DC_HIO='D' AND CC.NUM_PROC IS NULL 
					AND  LEFT(CXA.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
					AND fat.fatura_pc IS NULL
			end
	else
		if left(@Processo,2) = 'IM'
			Begin
			Insert @TempTaxas
				-- CtaCte A Crédito Contra o Consignee
				select
					APELIDO, TT.nome_tp_tx,	CTA.dc_him DC, 	CTA.vlr_org_him Vlr_Org, CXA.Vlr_Pgto_Rcto_him Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
--					ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					(case When
							CTA.Num_NF_HIM is not NULL and CTA.ref_acesso_nf_HIM <> 'P'
						Then 
							CTA.Par_NF_HIM 
						else 
							dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
					CTA.CD_TP_TX,Null DebitoCC,	CTA.Num_proc_him Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_him,'') NF, 
					isnull(CTA.ref_acesso_nf_him,'') [Site],
					Repasse_TX 
				from 
					House_Imp_Mar HOU
					Left Join cta_cte_hou_Imp_Mar CtA on HOU.num_proc_him=CtA.num_proc_him and HOU.cd_consig_him = CTA.cd_cred_dev_him and CtA.dc_him='C'
					Left Join caixa_hou_Imp_Mar CXA on Cta.num_proc_him=CXA.num_proc_him and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_him='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.cd_consig_him = PS.cd_pes
				--	Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_him and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_him
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_him and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'	

				where 
					CTA.num_proc_him=@Processo and CTA.Cd_tp_tx <> 'XCA'			
					and  fatura_Pc is null
				
			Union
				--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
				select
					APELIDO, TT.nome_tp_tx,	'D' DC, CC.Vlr_Item_Custo Vlr_Org, CC.vlr_Item_Custo Vlr_PG,
					'REL' cd_tp_moeda,ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_him,'') NF, 
					isnull(CTA.ref_acesso_nf_him,'') [Site],
					Repasse_TX
				from 
					custo_cliente cc
					Left Join caixa_hou_Imp_Mar		CXA	on CC.num_proc=CXA.num_proc_him and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_him='D'
					Left Join cta_cte_hou_Imp_Mar	CtA on CC.num_proc=CtA.num_proc_him and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_him='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_Imp_Mar			HOU on CC.Num_proc = HOU.Num_proc_him
					Left Join Pessoa				PS	on HOU.cd_consig_him = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_him and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'	
				where 
					CC.num_proc=@Processo and num_lcto is null and cta.num_proc_him is null 
					and (Prestacao = 'S' or Prestacao is null) and fatura_pc is null
			
			Union 
				--Cta_Cte à D que está no Custo também
				select
					PS.APELIDO, TT.nome_tp_tx,CTA.dc_him DC,CTA.vlr_org_him Vlr_Org, CXA.vlr_pgto_rcto_him Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_him,'') NF, 
					isnull(CTA.ref_acesso_nf_him,'') [Site],
					Repasse_TX
				from 
					custo_cliente cc
					Left Join cta_cte_hou_Imp_Mar	CtA on CC.num_proc=CtA.num_proc_him and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_him='D'
					Left Join caixa_hou_Imp_Mar		CXA on Cta.num_proc_him=CXA.num_proc_him and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_him='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_Imp_Mar			HOU on CC.Num_proc = HOU.Num_proc_him
					Join Pessoa				PS	on HOU.cd_consig_him = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_him and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CXA.num_proc_him=@Processo and 
					(Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					and fatura_pc is null
			
			Union
				--Cta_Cte à D que não está no Custo também
				select
					APELIDO, TT.nome_tp_tx,	CTA.dc_him DC, CTA.vlr_org_him Vlr_Org, CXA.Vlr_Pgto_Rcto_him Vlr_PG,
					'REL' cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,	CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,CTA.Num_proc_him Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_him,'') NF, 
					isnull(CTA.ref_acesso_nf_him,'') [Site],
					Repasse_TX
				from 
					House_Imp_Mar HOU
					Left Join cta_cte_hou_Imp_Mar CtA on HOU.num_proc_him=CtA.num_proc_him and HOU.cd_consig_him = CTA.cd_cred_dev_him and CtA.dc_him='D'
					Left Join caixa_hou_Imp_Mar CXA on Cta.num_proc_him=CXA.num_proc_him and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_him='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.cd_consig_him = PS.cd_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_him and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_him=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and fatura_pc is null

			union
				--Cta_Cte D que começa com X
				SELECT
					APELIDO,TT.NOME_TP_TX,CXA.dc_him DC,CXA.vlr_pgto_rcto_him Vlr_Org, 	CXA.vlr_pgto_rcto_him Vlr_PG,
					'REL' cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,CXA.CD_TP_TX CD_TP_TX,
					NULL DebitoCC,CXA.num_proc_him Processo,Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_HOU_Imp_Mar CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_him=CC.NUM_PROC
					JOIN HOUSE_Imp_Mar HOU ON HOU.NUM_PROC_him=CXA.NUM_PROC_him
					JOIN PESSOA PP ON PP.CD_PES=cd_consig_him
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=cxa.num_proc_him and itt.cd_tp_Tx=cxa.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'	
				WHERE
					CXA.num_proc_him=@Processo AND CXA.DC_him='D' AND CC.NUM_PROC IS NULL 
					AND  LEFT(CXA.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
					AND fat.fatura_pc is null

			end

	else
		if left(@Processo,2) = 'EM'
			Begin
			Insert @TempTaxas
			-- CtaCte A Crédito Contra o Consignee
				select
					APELIDO, TT.nome_tp_tx,	CTA.dc_hem DC, 	CTA.vlr_org_hem Vlr_Org, CXA.Vlr_Pgto_Rcto_hem Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda, 
--					ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					(case When
							CTA.Num_NF_HEM is not NULL and CTA.ref_acesso_nf_HEM <> 'P'
						Then 
							CTA.Par_NF_HEM 
						else 
							dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
					CTA.CD_TP_TX,
					Null DebitoCC,CTA.Num_proc_hem Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hem,'') NF, 
					isnull(CTA.ref_acesso_nf_hem,'') [Site],
					Repasse_TX
				from 
					House_exp_mar HOU
					Left Join cta_cte_hou_exp_mar CtA on HOU.num_proc_hem=CtA.num_proc_hem and HOU.cd_Export_hem = CTA.cd_cred_dev_hem and CtA.dc_hem='C'
					Left Join caixa_hou_exp_mar CXA on Cta.num_proc_hem=CXA.num_proc_hem and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hem='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.cd_Export_hem = PS.cd_pes
--					Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hem
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_hem=@Processo and CTA.Cd_tp_tx <> 'XCA'			
					and fat.fatura_pc is null

			Union
				--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
				select
					APELIDO, TT.nome_tp_tx,'D' DC, CC.Vlr_Item_Custo Vlr_Org, 
					CC.vlr_Item_Custo Vlr_PG,'REL' cd_tp_moeda,	ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,	CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hem,'') NF, 
					isnull(CTA.ref_acesso_nf_hem,'') [Site],
					Repasse_TX
				from 
					custo_cliente cc
					Left Join caixa_hou_exp_mar		CXA	on CC.num_proc=CXA.num_proc_hem and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hem='D'
					Left Join cta_cte_hou_exp_mar	CtA on CC.num_proc=CtA.num_proc_hem and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_hem='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_exp_mar			HOU on CC.Num_proc = HOU.Num_proc_hem
					Left Join Pessoa				PS	on HOU.cd_Export_hem = PS.CD_pes
--					Left Join item_fat ITT on ITT.num_proc=CC.num_proc and itt.cd_tp_Tx=CC.cd_tp_Tx --and itt.dc=CC.dc_hem
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'	
				where 
					CC.num_proc=@Processo and num_lcto is null and cta.num_proc_hem is null 
					and (Prestacao = 'S' or Prestacao is null)
					and fat.fatura_pc is null
				
			Union 
				--Cta_Cte à D que está no Custo também
				select
					PS.APELIDO, TT.nome_tp_tx,	CTA.dc_hem DC,CTA.vlr_org_hem Vlr_Org, 
					CXA.vlr_pgto_rcto_hem Vlr_PG,CTA.cd_tp_moeda cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hem,'') NF, 
					isnull(CTA.ref_acesso_nf_hem,'') [Site],
					Repasse_TX
				from 
					custo_cliente cc
					Left Join cta_cte_hou_exp_mar	CtA on CC.num_proc=CtA.num_proc_hem and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_hem='D'
					Left Join caixa_hou_exp_mar		CXA on Cta.num_proc_hem=CXA.num_proc_hem and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hem='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_exp_mar			HOU on CC.Num_proc = HOU.Num_proc_hem
					Join Pessoa				PS	on HOU.cd_export_hem = PS.CD_pes
--					Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hem
--ALTERADO POR ANDERSON
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'	
				where 
					CXA.num_proc_hem=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					and fat.fatura_pc is null
				
			union			
				--Cta_Cte à D que não está no Custo também
				select
					APELIDO, TT.nome_tp_tx,	CTA.dc_hem DC,CTA.vlr_org_hem Vlr_Org, 	CXA.Vlr_Pgto_Rcto_hem Vlr_PG,
					'REL' cd_tp_moeda,	iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,CTA.Num_proc_hem Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hem,'') NF, 
					isnull(CTA.ref_acesso_nf_hem,'') [Site],
					Repasse_TX
				from 
					House_exp_mar HOU
					Left Join cta_cte_hou_exp_mar CtA on HOU.num_proc_hem=CtA.num_proc_hem and HOU.cd_export_hem = CTA.cd_cred_dev_hem and CtA.dc_hem='D'
					Left Join caixa_hou_exp_mar CXA on Cta.num_proc_hem=CXA.num_proc_hem and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hem='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.cd_export_hem = PS.cd_pes
---					Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hem
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'	
				where 
					CTA.num_proc_hem=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and fat.fatura_pc is null
			union
				--Cta_Cte D que começa com X
				SELECT
					APELIDO,TT.NOME_TP_TX,CXA.dc_hem DC, CXA.vlr_pgto_rcto_hem Vlr_Org, 
					CXA.vlr_pgto_rcto_hem Vlr_PG,'REL' cd_tp_moeda,	iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,
					CXA.CD_TP_TX CD_TP_TX,NULL DebitoCC,CXA.num_proc_hem Processo,Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_HOU_exp_mar CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_hem=CC.NUM_PROC
					JOIN HOUSE_exp_mar HOU ON HOU.NUM_PROC_hem=CXA.NUM_PROC_hem
					JOIN PESSOA PP ON PP.CD_PES=CD_Export_hem
--					Left Join item_fat ITT on ITT.num_proc=CXA.num_proc_hem and itt.cd_tp_Tx=CXA.cd_tp_Tx and ITT.dc=CXA.dc_hem
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CXA.NUM_PROC_hem and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					CXA.num_proc_hem=@Processo AND CXA.DC_hem='D' AND CC.NUM_PROC IS NULL 
					AND  LEFT(CXA.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
					AND fat.fatura_pc IS NULL
			end

	else	
		if left(@Processo,2) = 'IA'
			Begin
			Insert @TempTaxas
			-- CtaCte A Crédito Contra o Consignee
				select
					APELIDO, TT.nome_tp_tx,	CTA.dc_hia DC, 	CTA.vlr_org_hia Vlr_Org, CXA.Vlr_Pgto_Rcto_hia Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,
--					ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					(case When
							CTA.Num_NF_HIA is not NULL and CTA.ref_acesso_nf_HIA <> 'P'
						Then 
							CTA.Par_NF_HIA 
						else 
							dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
					CTA.CD_TP_TX,Null DebitoCC,	CTA.Num_proc_hia Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hia,'') NF, 
					isnull(CTA.ref_acesso_nf_hia,'') [Site],
					Repasse_TX
				from 
					House_imp_aer HOU
					Left Join cta_cte_hou_imp_aer CtA on HOU.num_proc_hia=CtA.num_proc_hia and HOU.CD_CONSIG_hia = CTA.cd_cred_dev_hia and CtA.dc_hia='C'
					Left Join caixa_hou_imp_aer CXA on Cta.num_proc_hia=CXA.num_proc_hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.CD_CONSIG_hia = PS.cd_pes
	--				Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_hia and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hia
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hia and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_hia=@Processo and CTA.Cd_tp_tx <> 'XCA'			
					and fat.fatura_pc is null
				
			Union
			--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
				select
					APELIDO, TT.nome_tp_tx,	'D' DC, CC.Vlr_Item_Custo Vlr_Org, CC.vlr_Item_Custo Vlr_PG,
					'REL' cd_tp_moeda,ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hia,'') NF, 
					isnull(CTA.ref_acesso_nf_hia,'') [Site],
					Repasse_TX
				from 
					custo_cliente cc
					Left Join caixa_hou_imp_aer		CXA	on CC.num_proc=CXA.num_proc_hia and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='D'
					Left Join cta_cte_hou_imp_aer	CtA on CC.num_proc=CtA.num_proc_hia and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_hia='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_imp_aer			HOU on CC.Num_proc = HOU.Num_proc_hia
					Left Join Pessoa				PS	on HOU.CD_CONSIG_hia = PS.CD_pes
	--				Left Join item_fat ITT on ITT.num_proc=CC.num_proc and itt.cd_tp_Tx=CC.cd_tp_Tx --and itt.dc=CC.dc_him
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hia and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CC.num_proc=@Processo and num_lcto is null and cta.num_proc_hia is null 
					and (Prestacao = 'S' or Prestacao is null) and fat.fatura_pc is null
				
			Union
				--Cta_Cte à D que está no Custo também
				select
					PS.APELIDO, TT.nome_tp_tx,CTA.dc_hia DC,CTA.vlr_org_hia Vlr_Org, CXA.vlr_pgto_rcto_hia Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hia,'') NF, 
					isnull(CTA.ref_acesso_nf_hia,'') [Site],
					Repasse_TX
				from 
					custo_cliente cc
					Left Join cta_cte_hou_imp_aer	CtA on CC.num_proc=CtA.num_proc_hia and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_hia='D'
					Left Join caixa_hou_imp_aer		CXA on Cta.num_proc_hia=CXA.num_proc_hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_imp_aer			HOU on CC.Num_proc = HOU.Num_proc_hia
					Join Pessoa						PS	on HOU.CD_CONSIG_hia = PS.CD_pes
	--				Left Join item_fat				ITT on ITT.num_proc=CTA.num_proc_hia and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hia
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hia and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CXA.num_proc_hia=@Processo and 
					(Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					and fat.fatura_pc is null
			
			Union
				--Cta_Cte à D que não está no Custo também
				select
					APELIDO, TT.nome_tp_tx,	CTA.dc_hia DC, CTA.vlr_org_hia Vlr_Org, CXA.Vlr_Pgto_Rcto_hia Vlr_PG,
					'REL' cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,	CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,CTA.Num_proc_hia Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hia,'') NF, 
					isnull(CTA.ref_acesso_nf_hia,'') [Site],
					Repasse_TX
				from 
					House_imp_aer HOU
					Left Join cta_cte_hou_imp_aer CtA on HOU.num_proc_hia=CtA.num_proc_hia and HOU.CD_CONSIG_hia = CTA.cd_cred_dev_hia and CtA.dc_hia='D'
					Left Join caixa_hou_imp_aer CXA on Cta.num_proc_hia=CXA.num_proc_hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.CD_CONSIG_hia = PS.cd_pes
	--				Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_hia and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hia
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hia and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_hia=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and fat.fatura_pc is null

			union
				--Cta_Cte D que começa com X
				SELECT
					APELIDO,TT.NOME_TP_TX,CXA.dc_hia DC,CXA.vlr_pgto_rcto_hia Vlr_Org, 	CXA.vlr_pgto_rcto_hia Vlr_PG,
					'REL' cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,CXA.CD_TP_TX CD_TP_TX,
					NULL DebitoCC,CXA.num_proc_hia Processo,Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_HOU_imp_aer CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_hia=CC.NUM_PROC
					JOIN HOUSE_imp_aer HOU ON HOU.NUM_PROC_hia=CXA.NUM_PROC_hia
					JOIN PESSOA PP ON PP.CD_PES=CD_CONSIG_hia
	--				Left Join item_fat ITT on ITT.num_proc=CXA.num_proc_hia and itt.cd_tp_Tx=CXA.cd_tp_Tx and ITT.dc=CXA.dc_hia
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CXA.NUM_PROC_hia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					CXA.num_proc_hia=@Processo AND CXA.DC_hia='D' AND CC.NUM_PROC IS NULL 
					AND  LEFT(CXA.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
					AND fat.fatura_pc IS NULL
			end

	else
		if left(@Processo,2) = 'EA'
			Begin
			Insert @TempTaxas
		-- CtaCte A Crédito Contra o Consignee
				select
					APELIDO, TT.nome_tp_tx,	CTA.dc_hea DC, 	CTA.vlr_org_hea Vlr_Org, CXA.Vlr_Pgto_Rcto_hea Vlr_PG,
					CTA.cd_tp_moeda cd_tp_moeda, 
--					ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					(case When
							CTA.Num_NF_HEA is not NULL and CTA.ref_acesso_nf_HEA <> 'P'
						Then 
							CTA.Par_NF_HEA 
						else 
							dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
					CTA.CD_TP_TX,
					Null DebitoCC,CTA.Num_proc_hea Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hea,'') NF, 
					isnull(CTA.ref_acesso_nf_hea,'') [Site],
					Repasse_TX
				from 
					House_exp_aer HOU
					Left Join cta_cte_hou_exp_aer CtA on HOU.num_proc_hea=CtA.num_proc_hea and HOU.cd_Export_hea = CTA.cd_cred_dev_hea and CtA.dc_hea='C'
					Left Join caixa_hou_exp_aer CXA on Cta.num_proc_hea=CXA.num_proc_hea and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hea='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on HOU.cd_Export_hea = PS.cd_pes
--					Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_hea and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hea
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hea and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_hea=@Processo and CTA.Cd_tp_tx <> 'XCA'			
					and fat.fatura_pc is null

			Union
				--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
				select
					APELIDO, TT.nome_tp_tx,'D' DC, CC.Vlr_Item_Custo Vlr_Org, 
					CC.vlr_Item_Custo Vlr_PG,'REL' cd_tp_moeda,	ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,	CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hea,'') NF, 
					isnull(CTA.ref_acesso_nf_hea,'') [Site],
					Repasse_TX
				from 
					custo_cliente cc
					Left Join caixa_hou_exp_aer		CXA	on CC.num_proc=CXA.num_proc_hea and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hea='D'
					Left Join cta_cte_hou_exp_aer	CtA on CC.num_proc=CtA.num_proc_hea and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_hea='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_exp_aer			HOU on CC.Num_proc = HOU.Num_proc_hea
					Left Join Pessoa				PS	on HOU.cd_Export_hea = PS.CD_pes
--					Left Join item_fat				ITT on ITT.num_proc=CC.num_proc and itt.cd_tp_Tx=CC.cd_tp_Tx --and itt.dc=CC.dc_hem
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hea and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CC.num_proc=@Processo and num_lcto is null and cta.num_proc_hea is null 
					and (Prestacao = 'S' or Prestacao is null)
					and fat.fatura_pc is null
				
			Union 
				--Cta_Cte à D que está no Custo também
				select
					PS.APELIDO, TT.nome_tp_tx,	CTA.dc_hea DC,CTA.vlr_org_hea Vlr_Org, 
					CXA.vlr_pgto_rcto_hea Vlr_PG,CTA.cd_tp_moeda cd_tp_moeda,
					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX,
					CC.CD_tp_tx DebitoCC,CC.num_proc Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hea,'') NF, 
					isnull(CTA.ref_acesso_nf_hea,'') [Site],
					Repasse_TX 
				from 
					custo_cliente cc
					Left Join cta_cte_hou_exp_aer	CtA on CC.num_proc=CtA.num_proc_hea and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_hea='D'
					Left Join caixa_hou_exp_aer		CXA on Cta.num_proc_hea=CXA.num_proc_hea and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hea='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join House_exp_aer			HOU on CC.Num_proc = HOU.Num_proc_hea
					Join Pessoa						PS	on HOU.cd_export_hea = PS.CD_pes
--					Left Join item_fat				ITT on ITT.num_proc=CTA.num_proc_hea and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hea
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hea and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CXA.num_proc_hea=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					and fat.fatura_pc is null
				
			union			
				--Cta_Cte à D que não está no Custo também
				select
					APELIDO, TT.nome_tp_tx,	CTA.dc_hea DC,CTA.vlr_org_hea Vlr_Org, 	CXA.Vlr_Pgto_Rcto_hea Vlr_PG,
					'REL' cd_tp_moeda,	iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX CD_TP_TX, 
					Null DebitoCC,CTA.Num_proc_hea Processo,Ref_Ctb_Tx
					,isnull(CTA.num_nf_hea,'') NF, 
					isnull(CTA.ref_acesso_nf_hea,'') [Site],
					Repasse_TX 
				from 
					House_exp_aer HOU
					Left Join cta_cte_hou_exp_aer	CtA on HOU.num_proc_hea=CtA.num_proc_hea and HOU.cd_export_hea = CTA.cd_cred_dev_hea and CtA.dc_hea='D'
					Left Join caixa_hou_exp_aer		CXA on Cta.num_proc_hea=CXA.num_proc_hea and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hea='D'
					Left Join Tipo_Taxa				TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa				PS on HOU.cd_export_hea = PS.cd_pes
--					Left Join item_fat				ITT on ITT.num_proc=CTA.num_proc_hea and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hea
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hea and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_hea=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					and fat.fatura_pc is null

			union
				--Cta_Cte D que começa com X
				SELECT
					APELIDO,TT.NOME_TP_TX,CXA.dc_hea DC, CXA.vlr_pgto_rcto_hea Vlr_Org, 
					CXA.vlr_pgto_rcto_hea Vlr_PG,'REL' cd_tp_moeda,	iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,
					CXA.CD_TP_TX CD_TP_TX,NULL DebitoCC,CXA.num_proc_hea Processo,Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_HOU_exp_aer CXA
					JOIN TIPO_TAXA			TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_hea=CC.NUM_PROC
					JOIN HOUSE_exp_aer		HOU ON HOU.NUM_PROC_hea=CXA.NUM_PROC_hea
					JOIN PESSOA				PP ON PP.CD_PES=CD_Export_hea
--					Left Join item_fat		ITT on ITT.num_proc=CXA.num_proc_hea and itt.cd_tp_Tx=CXA.cd_tp_Tx and ITT.dc=CXA.dc_hea
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CXA.NUM_PROC_hea and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					CXA.num_proc_hea=@Processo AND CXA.DC_hea='D' AND CC.NUM_PROC IS NULL 
					AND  LEFT(CXA.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
					AND fat.fatura_pc IS NULL
			end
	END
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
						dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade, 
					CTA.CD_TP_TX,
					Null DebitoCC,
					CTA.Num_proc_MEM Processo,
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mem,'') NF, 
					isnull(CTA.ref_acesso_nf_mem,'') [Site],
					Repasse_TX
				from 
					MASter_EXP_MAR MAS
					Left Join cta_cte_mas_EXP_MAR CtA on MAS.num_proc_MEM=CtA.num_proc_MEM and MAS.cd_EXPORT_MEM = CTA.cd_cred_dev_MEM and CtA.dc_MEM='C'
					Left Join caixa_mas_EXP_MAR CXA on Cta.num_proc_MEM=CXA.num_proc_MEM and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_MEM='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_export_MEM = PS.cd_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mem and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_MEM=@Processo and CTA.Cd_tp_tx <> 'XCA'
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mem,'') NF, 
					isnull(CTA.ref_acesso_nf_mem,'') [Site],
					Repasse_TX
				from 
					custo_processo cc
					Left Join caixa_mas_EXP_MAR		CXA	on CC.num_proc=CXA.num_proc_MEM and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_MEM='D'
					Left Join cta_cte_mas_EXP_MAR	CtA on CC.num_proc=CtA.num_proc_MEM and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_MEM='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_exp_mar			MAS on CC.Num_proc = MAS.Num_proc_MEM
					Left Join Pessoa				PS	on MAS.cd_export_MEM = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mem and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					num_proc=@Processo and num_lcto is null and cta.num_proc_MEM is null --and (Prestacao = 'S' or Prestacao is null)
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mem,'') NF, 
					isnull(CTA.ref_acesso_nf_mem,'') [Site],
					Repasse_TX
				from 
					custo_cliente cc
					Left Join cta_cte_mas_EXP_MAR CtA on CC.num_proc=CtA.num_proc_MEM and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_MEM='D'
					Left Join caixa_mas_EXP_MAR CXA on Cta.num_proc_MEM=CXA.num_proc_MEM and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_MEM='D'
					Left Join Tipo_Taxa TT on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_exp_mar			MAS on CC.Num_proc = MAS.Num_proc_MEM
					Left Join Pessoa				PS	on MAS.cd_export_MEM = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mem and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CXA.num_proc_MEM=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mem,'') NF, 
					isnull(CTA.ref_acesso_nf_mem,'') [Site],
					Repasse_TX 
				from 
					MASter_exp_mar MAS
					Left Join cta_cte_mas_exp_mar CtA on MAS.num_proc_MEM=CtA.num_proc_MEM and MAS.cd_export_MEM = CTA.cd_cred_dev_MEM and CtA.dc_MEM='D'
					Left Join caixa_mas_exp_mar CXA on Cta.num_proc_MEM=CXA.num_proc_MEM and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_MEM='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_export_MEM = PS.cd_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mem and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_MEM=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_mas_EXP_MAR CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_MEM=CC.NUM_PROC
					JOIN MASter_EXP_MAR MAS ON MAS.NUM_PROC_MEM=CXA.NUM_PROC_MEM
					JOIN PESSOA PP ON PP.CD_PES=CD_Export_MEM
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mem and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					CXA.num_proc_MEM=@Processo AND CXA.DC_MEM='D' AND CC.NUM_PROC IS NULL 
					AND LEFT(CXA.CD_TP_tX,1)='X' --AND CXA.CD_TP_TX NOT IN ('XBA')
					AND fat.fatura_pc IS NULL
			 
			End

	else
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
						dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
					CTA.CD_TP_TX,
					Null DebitoCC,
					CTA.Num_proc_mea Processo,
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mea,'') NF, 
					isnull(CTA.ref_acesso_nf_mea,'') [Site],
					Repasse_TX
				from 
					MASter_EXP_aer MAS
					Left Join cta_cte_mas_EXP_aer CtA on MAS.num_proc_mea=CtA.num_proc_mea and MAS.cd_EXPORT_mea = CTA.cd_cred_dev_mea and CtA.dc_mea='C'
					Left Join caixa_mas_EXP_aer CXA on Cta.num_proc_mea=CXA.num_proc_mea and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_mea='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_export_mea = PS.cd_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mea and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_mea=@Processo and CTA.Cd_tp_tx <> 'XCA'
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mea,'') NF, 
					isnull(CTA.ref_acesso_nf_mea,'') [Site],
					Repasse_TX
				from 
					custo_processo cc
					Left Join caixa_mas_EXP_aer		CXA	on CC.num_proc=CXA.num_proc_mea and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_mea='D'
					Left Join cta_cte_mas_EXP_aer	CtA on CC.num_proc=CtA.num_proc_mea and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_mea='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_exp_aer			MAS on CC.Num_proc = MAS.Num_proc_mea
					Left Join Pessoa				PS	on MAS.cd_export_mea = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mea and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					num_proc=@Processo and num_lcto is null and cta.num_proc_mea is null --and (Prestacao = 'S' or Prestacao is null)
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mea,'') NF, 
					isnull(CTA.ref_acesso_nf_mea,'') [Site],
					Repasse_TX 
				from 
					custo_cliente cc
					Left Join cta_cte_mas_EXP_aer CtA on CC.num_proc=CtA.num_proc_mea and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_mea='D'
					Left Join caixa_mas_EXP_aer CXA on Cta.num_proc_mea=CXA.num_proc_mea and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_mea='D'
					Left Join Tipo_Taxa TT on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_exp_aer			MAS on CC.Num_proc = MAS.Num_proc_mea
					Left Join Pessoa				PS	on MAS.cd_export_mea = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mea and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CXA.num_proc_mea=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mea,'') NF, 
					isnull(CTA.ref_acesso_nf_mea,'') [Site],
					Repasse_TX
				from 
					MASter_exp_aer MAS
					Left Join cta_cte_mas_exp_aer CtA on MAS.num_proc_mea=CtA.num_proc_mea and MAS.cd_export_mea = CTA.cd_cred_dev_mea and CtA.dc_mea='D'
					Left Join caixa_mas_exp_aer CXA on Cta.num_proc_mea=CXA.num_proc_mea and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_mea='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_export_mea = PS.cd_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mea and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_mea=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					AND fat.fatura_pc IS NULL

			union
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
					Ref_Ctb_Tx
					,'' NF, 
					''[Site],
					Repasse_TX 
				FROM
					CAIXA_mas_EXP_aer CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_mea=CC.NUM_PROC
					JOIN MASter_EXP_aer MAS ON MAS.NUM_PROC_mea=CXA.NUM_PROC_mea
					JOIN PESSOA PP ON PP.CD_PES=CD_Export_mea
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mea and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					CXA.num_proc_mea=@Processo AND CXA.DC_mea='D' AND CC.NUM_PROC IS NULL 
					AND LEFT(CXA.CD_TP_tX,1)='X' --AND CXA.CD_TP_TX NOT IN ('XBA')
					AND fat.fatura_pc IS NULL
		 
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
						dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
					CTA.CD_TP_TX,
					Null DebitoCC,
					CTA.Num_proc_mia Processo,
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mia,'') NF, 
					isnull(CTA.ref_acesso_nf_mia,'') [Site],
					Repasse_TX
				from 
					MASter_imp_aer MAS
					Left Join cta_cte_mas_imp_aer CtA on MAS.num_proc_mia=CtA.num_proc_mia and MAS.cd_consig_mia = CTA.cd_cred_dev_mia and CtA.dc_mia='C'
					Left Join caixa_mas_imp_aer CXA on Cta.num_proc_mia=CXA.num_proc_mia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_mia='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_consig_mia = PS.cd_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_mia=@Processo and CTA.Cd_tp_tx <> 'XCA'
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mia,'') NF, 
					isnull(CTA.ref_acesso_nf_mia,'') [Site],
					Repasse_TX
				from 
					custo_processo cc
					Left Join caixa_mas_imp_aer		CXA	on CC.num_proc=CXA.num_proc_mia and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_mia='D'
					Left Join cta_cte_mas_imp_aer	CtA on CC.num_proc=CtA.num_proc_mia and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_mia='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_imp_aer			MAS on CC.Num_proc = MAS.Num_proc_mia
					Left Join Pessoa				PS	on MAS.cd_consig_mia = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					num_proc=@Processo and num_lcto is null and cta.num_proc_mia is null --and (Prestacao = 'S' or Prestacao is null)
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mia,'') NF, 
					isnull(CTA.ref_acesso_nf_mia,'') [Site],
					Repasse_TX
				from 
					custo_cliente cc
					Left Join cta_cte_mas_imp_aer CtA on CC.num_proc=CtA.num_proc_mia and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_mia='D'
					Left Join caixa_mas_imp_aer CXA on Cta.num_proc_mia=CXA.num_proc_mia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_mia='D'
					Left Join Tipo_Taxa TT on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_imp_aer			MAS on CC.Num_proc = MAS.Num_proc_mia
					Left Join Pessoa				PS	on MAS.cd_consig_mia = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CXA.num_proc_mia=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mia,'') NF, 
					isnull(CTA.ref_acesso_nf_mia,'') [Site],
					Repasse_TX
				from 
					MASter_imp_aer MAS
					Left Join cta_cte_mas_imp_aer CtA on MAS.num_proc_mia=CtA.num_proc_mia and MAS.cd_consig_mia = CTA.cd_cred_dev_mia and CtA.dc_mia='D'
					Left Join caixa_mas_imp_aer CXA on Cta.num_proc_mia=CXA.num_proc_mia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_mia='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_consig_mia = PS.cd_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_mia=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_mas_imp_aer CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_mia=CC.NUM_PROC
					JOIN MASter_imp_aer MAS ON MAS.NUM_PROC_mia=CXA.NUM_PROC_mia
					JOIN PESSOA PP ON PP.CD_PES=CD_consig_mia
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mia and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					CXA.num_proc_mia=@Processo AND CXA.DC_mia='D' AND CC.NUM_PROC IS NULL 
					AND LEFT(CXA.CD_TP_tX,1)='X' --AND CXA.CD_TP_TX NOT IN ('XBA')
					AND fat.fatura_pc IS NULL
			 
			End

	else
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
						dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
					CTA.CD_TP_TX,
					Null DebitoCC,
					CTA.Num_proc_Mim Processo,
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mim,'') NF, 
					isnull(CTA.ref_acesso_nf_mim,'') [Site],
					Repasse_TX 
				from 
					MASter_imp_mar MAS
					Left Join cta_cte_mas_imp_mar CtA on MAS.num_proc_Mim=CtA.num_proc_Mim and MAS.cd_consig_Mim = CTA.cd_cred_dev_Mim and CtA.dc_Mim='C'
					Left Join caixa_mas_imp_mar CXA on Cta.num_proc_Mim=CXA.num_proc_Mim and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Mim='C'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_consig_Mim = PS.cd_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mim and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_Mim=@Processo and CTA.Cd_tp_tx <> 'XCA'
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mim,'') NF, 
					isnull(CTA.ref_acesso_nf_mim,'') [Site],
					Repasse_TX  
				from 
					custo_processo cc
					Left Join caixa_mas_imp_mar		CXA	on CC.num_proc=CXA.num_proc_Mim and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Mim='D'
					Left Join cta_cte_mas_imp_mar	CtA on CC.num_proc=CtA.num_proc_Mim and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_Mim='D'
					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_imp_mar			MAS on CC.Num_proc = MAS.Num_proc_Mim
					Left Join Pessoa				PS	on MAS.cd_consig_Mim = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mim and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					num_proc=@Processo and num_lcto is null and cta.num_proc_Mim is null --and (Prestacao = 'S' or Prestacao is null)
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mim,'') NF, 
					isnull(CTA.ref_acesso_nf_mim,'') [Site],
					Repasse_TX 
				from 
					custo_cliente cc
					Left Join cta_cte_mas_imp_mar CtA on CC.num_proc=CtA.num_proc_Mim and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_Mim='D'
					Left Join caixa_mas_imp_mar CXA on Cta.num_proc_Mim=CXA.num_proc_Mim and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Mim='D'
					Left Join Tipo_Taxa TT on CC.CD_tp_tx = TT.CD_tp_tx
					Left Join MASter_imp_mar			MAS on CC.Num_proc = MAS.Num_proc_Mim
					Left Join Pessoa				PS	on MAS.cd_consig_Mim = PS.CD_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mim and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CXA.num_proc_Mim=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,isnull(CTA.num_nf_mim,'') NF, 
					isnull(CTA.ref_acesso_nf_mim,'') [Site],
					Repasse_TX 
				from 
					MASter_imp_mar MAS
					Left Join cta_cte_mas_imp_mar CtA on MAS.num_proc_Mim=CtA.num_proc_Mim and MAS.cd_consig_Mim = CTA.cd_cred_dev_Mim and CtA.dc_Mim='D'
					Left Join caixa_mas_imp_mar CXA on Cta.num_proc_Mim=CXA.num_proc_Mim and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Mim='D'
					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
					Left Join Pessoa PS on MAS.cd_consig_Mim = PS.cd_pes
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mim and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				where 
					CTA.num_proc_Mim=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
					AND fat.fatura_pc IS NULL

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
					Ref_Ctb_Tx
					,'' NF, 
					'' [Site],
					Repasse_TX 
				FROM
					CAIXA_mas_imp_mar CXA
					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_Mim=CC.NUM_PROC
					JOIN MASter_imp_mar MAS ON MAS.NUM_PROC_Mim=CXA.NUM_PROC_Mim
					JOIN PESSOA PP ON PP.CD_PES=CD_consig_Mim
					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,14)=CXA.NUM_PROC_mim and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
				WHERE
					CXA.num_proc_Mim=@Processo AND CXA.DC_Mim='D' AND CC.NUM_PROC IS NULL 
					AND LEFT(CXA.CD_TP_tX,1)='X' --AND CXA.CD_TP_TX NOT IN ('XBA')
					AND fat.fatura_pc IS NULL
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
		on T.cd_tp_Moeda = T1.cd_tp_moeda and T1.NF is not NULL
	--select Moeda,Paridade from @TempTaxas as T2 where NF is not NULL
	--where NF is NULL
		
	select * from @TempTaxas


*/




















































	
--	if left(@Processo,2) = 'IO'
--		Begin
---- CtaCte A Crédito Contra o Consignee
--			select
-- 				APELIDO, TT.nome_tp_tx,	CTA.dc_him DC, 	CTA.vlr_org_him Vlr_Org, CXA.Vlr_Pgto_Rcto_him Vlr_PG,
--				CTA.cd_tp_moeda cd_tp_moeda,ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
--				CTA.CD_TP_TX,Null DebitoCC,	CTA.Num_proc_him Processo
--			from 
--				House_Imp_Mar HOU
--				Left Join cta_cte_hou_Imp_Mar CtA on HOU.num_proc_him=CtA.num_proc_him and HOU.cd_consig_him = CTA.cd_cred_dev_him and CtA.dc_him='C'
--				Left Join caixa_hou_Imp_Mar CXA on Cta.num_proc_him=CXA.num_proc_him and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_him='C'
--				Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
--				Left Join Pessoa PS on HOU.cd_consig_him = PS.cd_pes
--				Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_him and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_him
--			where 
--				CTA.num_proc_him=@Processo and CTA.Cd_tp_tx <> 'XCA'			
--				and itt.num_proc is null
--			
--			Union
----Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
--			select
-- 				APELIDO, TT.nome_tp_tx,	'D' DC, CC.Vlr_Item_Custo Vlr_Org, CC.vlr_Item_Custo Vlr_PG,
--				'REL' cd_tp_moeda,ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
--				CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,CC.num_proc Processo
--			from 
--				custo_cliente cc
--				Left Join caixa_hou_Imp_Mar		CXA	on CC.num_proc=CXA.num_proc_him and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_him='D'
--				Left Join cta_cte_hou_Imp_Mar	CtA on CC.num_proc=CtA.num_proc_him and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_him='D'
--				Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
--				Left Join House_Imp_Mar			HOU on CC.Num_proc = HOU.Num_proc_him
--				Left Join Pessoa				PS	on HOU.cd_consig_him = PS.CD_pes
--				Left Join item_fat ITT on ITT.num_proc=CC.num_proc and itt.cd_tp_Tx=CC.cd_tp_Tx --and itt.dc=CC.dc_him
--			where 
--				CC.num_proc=@Processo and num_lcto is null and cta.num_proc_him is null 
--				and (Prestacao = 'S' or Prestacao is null) and itt.num_proc is null
--			
--			Union 
--
----Cta_Cte à D que está no Custo também
--			select
-- 				PS.APELIDO, TT.nome_tp_tx,CTA.dc_him DC,CTA.vlr_org_him Vlr_Org, CXA.vlr_pgto_rcto_him Vlr_PG,
--				CTA.cd_tp_moeda cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
--				CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,CC.num_proc Processo
--			from 
--				custo_cliente cc
--				Left Join cta_cte_hou_Imp_Mar	CtA on CC.num_proc=CtA.num_proc_him and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_him='D'
--				Left Join caixa_hou_Imp_Mar		CXA on Cta.num_proc_him=CXA.num_proc_him and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_him='D'
--				Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
--				Left Join House_Imp_Mar			HOU on CC.Num_proc = HOU.Num_proc_him
--				Join Pessoa				PS	on HOU.cd_consig_him = PS.CD_pes
--				Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_him and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_him
--			where 
--				CXA.num_proc_him=@Processo and 
--				(Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
--				and itt.num_proc is null
--		
--			Union
----Cta_Cte à D que não está no Custo também
--			select
-- 				APELIDO, TT.nome_tp_tx,	CTA.dc_him DC, CTA.vlr_org_him Vlr_Org, CXA.Vlr_Pgto_Rcto_him Vlr_PG,
--				'REL' cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,	CTA.CD_TP_TX CD_TP_TX, 
--				Null DebitoCC,CTA.Num_proc_him Processo
--			from 
--				House_Imp_Mar HOU
--				Left Join cta_cte_hou_Imp_Mar CtA on HOU.num_proc_him=CtA.num_proc_him and HOU.cd_consig_him = CTA.cd_cred_dev_him and CtA.dc_him='D'
--				Left Join caixa_hou_Imp_Mar CXA on Cta.num_proc_him=CXA.num_proc_him and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_him='D'
--				Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
--				Left Join Pessoa PS on HOU.cd_consig_him = PS.cd_pes
--				Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_him and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_him
--			where 
--				CTA.num_proc_him=@Processo and CTA.CD_TP_TX in ('C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
--				and itt.num_proc is null
--
--			union
--
----Cta_Cte D que começa com X
--			SELECT
--				APELIDO,TT.NOME_TP_TX,CXA.dc_him DC,CXA.vlr_pgto_rcto_him Vlr_Org, 	CXA.vlr_pgto_rcto_him Vlr_PG,
--				'REL' cd_tp_moeda,iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,CXA.CD_TP_TX CD_TP_TX,
--				NULL DebitoCC,CXA.num_proc_him Processo
--			FROM
--				CAIXA_HOU_Imp_Mar CXA
--				JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
--				Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_him=CC.NUM_PROC
--				JOIN HOUSE_Imp_Mar HOU ON HOU.NUM_PROC_him=CXA.NUM_PROC_him
--				JOIN PESSOA PP ON PP.CD_PES=cd_consig_him
--				Left Join item_fat ITT on ITT.num_proc=CXA.num_proc_him and itt.cd_tp_Tx=CXA.cd_tp_Tx and ITT.dc=CXA.dc_him
--			WHERE
--				CXA.num_proc_him=@Processo AND CXA.DC_him='D' AND CC.NUM_PROC IS NULL 
--				AND  LEFT(CXA.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
--				AND ITT.NUM_PROC IS NULL
--
--	END


--END

--
--if left(@Processo,2) = 'EM'
--			Begin 
--				-- CtaCte A Crédito Contra o Consignee
--				select
--					APELIDO, TT.nome_tp_tx,	CTA.dc_hem DC, 	CTA.vlr_org_hem Vlr_Org, CXA.Vlr_Pgto_Rcto_hem Vlr_PG,
--					CTA.cd_tp_moeda cd_tp_moeda, ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX,
--					Null DebitoCC,CTA.Num_proc_hem Processo
--				from 
--					House_exp_mar HOU
--					Left Join cta_cte_hou_exp_mar CtA on HOU.num_proc_hem=CtA.num_proc_hem and HOU.cd_Export_hem = CTA.cd_cred_dev_hem and CtA.dc_hem='C'
--					Left Join caixa_hou_exp_mar CXA on Cta.num_proc_hem=CXA.num_proc_hem and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hem='C'
--					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
--					Left Join Pessoa PS on HOU.cd_Export_hem = PS.cd_pes
----					Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hem
--					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
--					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
--				where 
--					CTA.num_proc_hem=@Processo and CTA.Cd_tp_tx <> 'XCA'			
--					and fat.fatura_pc is null
--
--				Union
--				--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
--				select
--					APELIDO, TT.nome_tp_tx,'D' DC, CC.Vlr_Item_Custo Vlr_Org, 
--					CC.vlr_Item_Custo Vlr_PG,'REL' cd_tp_moeda,	ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
--					CTA.CD_TP_TX,CC.CD_tp_tx DebitoCC,	CC.num_proc Processo
--				from 
--					custo_cliente cc
--					Left Join caixa_hou_exp_mar		CXA	on CC.num_proc=CXA.num_proc_hem and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hem='D'
--					Left Join cta_cte_hou_exp_mar	CtA on CC.num_proc=CtA.num_proc_hem and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_hem='D'
--					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
--					Left Join House_exp_mar			HOU on CC.Num_proc = HOU.Num_proc_hem
--					Left Join Pessoa				PS	on HOU.cd_Export_hem = PS.CD_pes
----					Left Join item_fat ITT on ITT.num_proc=CC.num_proc and itt.cd_tp_Tx=CC.cd_tp_Tx --and itt.dc=CC.dc_hem
--					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
--					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
--				where 
--					CC.num_proc=@Processo and num_lcto is null and cta.num_proc_hem is null 
--					and (Prestacao = 'S' or Prestacao is null)
--					and fat.fatura_pc is null
--				
--				Union 
--
--				--Cta_Cte à D que está no Custo também
--				select
--					PS.APELIDO, TT.nome_tp_tx,	CTA.dc_hem DC,CTA.vlr_org_hem Vlr_Org, 
--					CXA.vlr_pgto_rcto_hem Vlr_PG,CTA.cd_tp_moeda cd_tp_moeda,
--					iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX,
--					CC.CD_tp_tx DebitoCC,CC.num_proc Processo
--				from 
--					custo_cliente cc
--					Left Join cta_cte_hou_exp_mar	CtA on CC.num_proc=CtA.num_proc_hem and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.dc_hem='D'
--					Left Join caixa_hou_exp_mar		CXA on Cta.num_proc_hem=CXA.num_proc_hem and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hem='D'
--					Left Join Tipo_Taxa				TT	on CC.CD_tp_tx = TT.CD_tp_tx
--					Left Join House_exp_mar			HOU on CC.Num_proc = HOU.Num_proc_hem
--					Join Pessoa				PS	on HOU.cd_export_hem = PS.CD_pes
----					Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hem
--					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
--					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
--				where 
--					CXA.num_proc_hem=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(CXA.CD_TP_tX,1)='X'
--					and fat.fatura_pc is null
--				
--				union			
--				--Cta_Cte à D que não está no Custo também
--				select
--					APELIDO, TT.nome_tp_tx,	CTA.dc_hem DC,CTA.vlr_org_hem Vlr_Org, 	CXA.Vlr_Pgto_Rcto_hem Vlr_PG,
--					'REL' cd_tp_moeda,	iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,CTA.CD_TP_TX CD_TP_TX, 
--					Null DebitoCC,CTA.Num_proc_hem Processo
--				from 
--					House_exp_mar HOU
--					Left Join cta_cte_hou_exp_mar CtA on HOU.num_proc_hem=CtA.num_proc_hem and HOU.cd_export_hem = CTA.cd_cred_dev_hem and CtA.dc_hem='D'
--					Left Join caixa_hou_exp_mar CXA on Cta.num_proc_hem=CXA.num_proc_hem and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hem='D'
--					Left Join Tipo_Taxa TT on CTA.CD_tp_tx = TT.CD_tp_tx
--					Left Join Pessoa PS on HOU.cd_export_hem = PS.cd_pes
----					Left Join item_fat ITT on ITT.num_proc=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.dc_hem
--					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CTA.num_proc_hem and itt.cd_tp_Tx=CTA.cd_tp_Tx --and itt.dc=CTA.dc_him
--					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
--				where 
--					CTA.num_proc_hem=@Processo and CTA.CD_TP_TX in ('IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
--					and fat.fatura_pc is null
--
--				union
--				--Cta_Cte D que começa com X
--				SELECT
--					APELIDO,TT.NOME_TP_TX,CXA.dc_hem DC, CXA.vlr_pgto_rcto_hem Vlr_Org, 
--					CXA.vlr_pgto_rcto_hem Vlr_PG,'REL' cd_tp_moeda,	iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,
--					CXA.CD_TP_TX CD_TP_TX,NULL DebitoCC,CXA.num_proc_hem Processo
--				FROM
--					CAIXA_HOU_exp_mar CXA
--					JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
--					Left Join Custo_Cliente CC on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_hem=CC.NUM_PROC
--					JOIN HOUSE_exp_mar HOU ON HOU.NUM_PROC_hem=CXA.NUM_PROC_hem
--					JOIN PESSOA PP ON PP.CD_PES=CD_Export_hem
----					Left Join item_fat ITT on ITT.num_proc=CXA.num_proc_hem and itt.cd_tp_Tx=CXA.cd_tp_Tx and ITT.dc=CXA.dc_hem
--					Left Join Fatura_chb_item ITT on left(ITT.fatura_cc,16)=CXA.NUM_PROC_hem and itt.cd_tp_Tx=CXA.CD_TP_TX --and itt.dc=CTA.dc_him
--					Left Join Fatura_CHB FAT on FAT.fatura_pc=ITT.fatura_cc and status_pc='E'
--				WHERE
--					CXA.num_proc_hem=@Processo AND CXA.DC_hem='D' AND CC.NUM_PROC IS NULL 
--					AND  LEFT(CXA.CD_TP_tX,1)='X' --and CXA.CD_TP_TX NOT IN ('XBA') 
--					AND fat.fatura_pc IS NULL
--			end



GO
