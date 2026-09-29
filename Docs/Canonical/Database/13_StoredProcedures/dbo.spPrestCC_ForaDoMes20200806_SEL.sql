SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spPrestCC_ForaDoMes20200806_SEL]--[dbo].[spPrestCC] 'IMUPL201502002BR', '19-03-2015'

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
		
		-- CtaCte A Crédito Contra o Consignee	
			select
				APELIDO,TT.nome_tp_tx,CTA.DC_HIA DC,CTA.Vlr_Org_HIA Vlr_Org,CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
				CTA.cd_tp_moeda cd_tp_moeda,
				--(case When	CTA.Num_NF_HIA is not NULL and CTA.Ref_Acesso_NF_HIA <> 'P'	Then CTA.Par_NF_HIA 
				--	else 
				--	dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') 
				--end) Paridade,
						
				(Case When CTA.Num_NF_HIA is not NULL and CTA.Ref_Acesso_NF_HIA <> 'P' Then --CC.Par_NF_HIA 
							FARG.Paridade
				Else
					--dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
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
				
				UPPER(CTA.CD_TP_TX),
				Null DebitoCC,
				CTA.Num_Proc_HIA Processo,
				Ref_Ctb_Tx,
				isnull(convert(varchar(12),CTA.Num_NF_HIA),'') NF,
				 isnull(CTA.Ref_Acesso_NF_HIA,'') [Site],
				Repasse_TX ,
				isnull(FARG.Dt_Fatura,GETDATE()) Emissao
			from 					
				vwCliente					HOU with (nolock)
				Left Join vwcta_Cte			CTA with (nolock) on HOU.num_proc=CtA.Num_Proc_HIA and HOU.cd_cliente = CTA.Cd_Cred_Dev_HIA and CtA.DC_HIA='C'
				Left Join vwCXAS			CXA with (nolock) on Cta.num_proc_Hia=CXA.num_proc_HIA and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HIA='C'
				Left Join Tipo_Taxa			TT  with (nolock)on CTA.CD_tp_tx = TT.CD_tp_tx 
				Left Join Pessoa			PS with (nolock) on HOU.cd_cliente = PS.cd_pes
				Left Join vwFaturasValidas	FAt with (nolock)on fat.num_proc=CtA.Num_Proc_HIA and FAt.cd_tp_tx = CtA.cd_tp_Tx and fat.dc=CtA.DC_HIA
				Left Join vwFaturasValidasCHB ITT with (nolock) on itt.FatCod <> @Fatcod and itt.Num_Proc=CTA.Num_Proc_HIA and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.DC_HIA
				left join vwFaturasValidasArg FARG With(nolock) on CtA.Num_Proc_HIA= FARG.Num_Proc and CtA.cd_tp_tx = FARG.cd_tp_tx and CtA.DC_HIA = FARG.DC
			where 
				CTA.Num_Proc_HIA=@Processo and TT.Ref_Ctb_Tx <> 'PTC' --and CTA.Cd_tp_tx <> 'XCA'
				and Desp_Org_HIA='N' and itt.FatCod is null	and Fat.num_proc is null

		Union
		
		--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
			select
				PS.APELIDO,TT.nome_tp_tx,'D' DC, CC.Vlr_Item_Custo Vlr_Org,CC.vlr_Item_Custo Vlr_PG,
				'REL' cd_tp_moeda,1 Paridade,
				--ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
				upper(CTA.CD_TP_TX),CC.CD_tp_tx DebitoCC,CC.num_proc Processo,
				Ref_Ctb_Tx,
				isnull(convert(varchar(12),CTA.Num_NF_HIA),'') NF,
				isnull(CTA.Ref_Acesso_NF_HIA,'') [Site],
				Repasse_TX,
				isnull(FARG.Dt_Fatura,GETDATE()) Emissao
			from custo_cliente		cc with (nolock)
				Left Join vwCXAS	CXA with (nolock)on CC.num_proc=CXA.num_proc_HIA and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HIA='D'
				Left Join vwcta_Cte	CtA with (nolock) on CC.num_proc=CtA.num_proc_Hia and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.DC_HIA='D'
				Left Join Tipo_Taxa	TT	with (nolock) on CC.CD_tp_tx = TT.CD_tp_tx
				Left Join vwCliente	HOU with (nolock) on CC.Num_proc = HOU.Num_proc
				Left Join Pessoa	PS	with (nolock) on HOU.cd_cliente = PS.CD_pes
				Left Join vwFaturasValidas	FAt with (nolock)on fat.num_proc=CtA.Num_Proc_HIA and FAt.cd_tp_tx = CtA.cd_tp_Tx and fat.dc=CtA.DC_HIA
				Left Join vwFaturasValidasCHB ITT with (nolock) on itt.FatCod <> @Fatcod and itt.Num_Proc=CTA.Num_Proc_HIA and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.DC_HIA						
				left join vwFaturasValidasArg FARG With(nolock) on CtA.Num_Proc_HIA= FARG.Num_Proc and CtA.cd_tp_tx = FARG.cd_tp_tx and CtA.DC_HIA = FARG.DC
			where 
				CC.Num_Proc=@Processo and num_lcto is null and cta.num_proc_hia is null 
				and (Prestacao = 'S' or Prestacao is null)
				and itt.FatCod is null	and Fat.num_proc is null

		Union
		
		--Cta_Cte à D que está no Custo também
			select
				PS.APELIDO,	TT.nome_tp_tx,CTA.DC_HIA DC, CTA.Vlr_Org_HIA Vlr_Org, CXA.vlr_pgto_rcto_hia Vlr_PG,
				CTA.cd_tp_moeda cd_tp_moeda,
				--iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
				
				(Case When CTA.Num_NF_HIA is not NULL and CTA.Ref_Acesso_NF_HIA <> 'P' Then --CC.Par_NF_HIA 
							FARG.Paridade
				Else
					--dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
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
				
				
				UPPER(CTA.CD_TP_TX),UPPER(CC.CD_tp_tx) DebitoCC,CC.num_proc Processo,	Ref_Ctb_Tx,
				isnull(convert(varchar(12),CTA.Num_NF_HIA),'') NF,
				isnull(CTA.Ref_Acesso_NF_HIA,'') [Site],
				Repasse_TX ,
				isnull(FARG.Dt_Fatura,GETDATE()) Emissao				
			from custo_cliente				cc with (nolock)
				Left Join vwcta_Cte			CtA with (nolock) on CC.num_proc=CtA.Num_Proc_HIA and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.DC_HIA='D'
				Left Join vwCXAS			CXA with (nolock) on Cta.Num_Proc_HIA=CXA.num_proc_hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='D'
				Left Join Tipo_Taxa			TT	with (nolock)on CC.CD_tp_tx = TT.CD_tp_tx
				Left Join vwCliente			HOU with (nolock) on CC.Num_proc = HOU.num_proc
				Join Pessoa					PS	with (nolock)on HOU.cd_cliente = PS.CD_pes
				Left Join vwFaturasValidas	FAt with (nolock)on fat.num_proc=CtA.Num_Proc_HIA and FAt.cd_tp_tx = CtA.cd_tp_Tx and fat.dc=CtA.DC_HIA
				Left Join vwFaturasValidasCHB ITT with (nolock) on itt.FatCod <> @Fatcod and itt.Num_Proc=CTA.Num_Proc_HIA and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.DC_HIA						
				left join vwFaturasValidasArg FARG With(nolock) on CtA.Num_Proc_HIA= FARG.Num_Proc and CtA.cd_tp_tx = FARG.cd_tp_tx and CtA.DC_HIA = FARG.DC
			where 
				CXA.num_proc_hia=@Processo 
				and (Prestacao = 'S' or Prestacao is null) 
				and LEFT(CXA.CD_TP_tX,1)='X'
				and itt.FatCod is null	and Fat.num_proc is null
		Union
					
		--Cta_Cte à D que não está no Custo também
			select
				APELIDO,TT.nome_tp_tx,CTA.DC_HIA DC,DBO.VALOR(CTA.Vlr_Org_HIA,CTA.DC_HIA) Vlr_Org,
				CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
				'REL' cd_tp_moeda,	1 Paridade,
				--iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1 Paridade,
				UPPER(CTA.CD_TP_TX) CD_TP_TX,Null DebitoCC,CTA.Num_Proc_HIA Processo,
				Ref_Ctb_Tx,	
				isnull(convert(varchar(12),CTA.Num_NF_HIA),'') NF,
				isnull(CTA.Ref_Acesso_NF_HIA,'') [Site],
				Repasse_TX,
				isnull(FARG.Dt_Fatura,GETDATE()) Emissao
			from 
				vwCliente HOU with (nolock)
				Left Join vwcta_Cte CtA with (nolock) on HOU.num_proc=CtA.Num_Proc_HIA and HOU.cd_cliente = CTA.Cd_Cred_Dev_HIA and CtA.DC_HIA='D'
				Left Join vwCXAS CXA with (nolock) on Cta.Num_Proc_HIA=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
				Left Join Tipo_Taxa TT with (nolock) on CTA.CD_tp_tx = TT.CD_tp_tx
				Left Join Pessoa PS with (nolock) on HOU.cd_cliente = PS.cd_pes					
				Left Join vwFaturasValidas FAt with (nolock) on fat.num_proc=CtA.Num_Proc_HIA and CtA.cd_tp_Tx=FAt.cd_tp_tx and CtA.DC_HIA=fat.dc    
				Left Join vwFaturasValidasCHB ITT with (nolock) on itt.FatCod <> @Fatcod and itt.Num_Proc=CTA.Num_Proc_HIA and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.DC_HIA
				left join vwFaturasValidasArg FARG With(nolock) on CtA.Num_Proc_HIA= FARG.Num_Proc and CtA.cd_tp_tx = FARG.cd_tp_tx and CtA.DC_HIA = FARG.DC
			where 
				CTA.Num_Proc_HIA=@Processo 
				and CTA.CD_TP_TX in ('RIS','IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
				and Fat.FatCod is null
				and ITT.FatCod is null
					
		Union
		
		--Cta_Cte D que começa com X
			SELECT
				APELIDO,TT.NOME_TP_TX,CXA.dc_HIA DC,CXA.vlr_pgto_rcto_Hia Vlr_Org,CXA.vlr_pgto_rcto_Hia Vlr_PG,
				'REL' cd_tp_moeda,1 Paridade,
				--iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,
				UPPER(CXA.CD_TP_TX) CD_TP_TX,NULL DebitoCC,CXA.num_proc_Hia Processo,
				Ref_Ctb_Tx,'' NF, '' [Site],
				Repasse_TX,GETDATE() Emissao
			FROM vwCXAS CXA with (nolock)
				JOIN TIPO_TAXA TT with (nolock) ON TT.CD_TP_TX=CXA.CD_TP_TX
				Left Join Custo_Cliente CC with (nolock) on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_HIA=CC.NUM_PROC
				JOIN vwCliente HOU with (nolock) ON HOU.NUM_PROC=CXA.NUM_PROC_HIA
				JOIN PESSOA PP with (nolock) ON PP.CD_PES=HOU.cd_cliente
				Left Join vwFaturasValidas	FAt with (nolock)on fat.num_proc=CXA.Num_Proc_HIA and FAt.cd_tp_tx = CXA.cd_tp_Tx and fat.dc=CXA.DC_HIA
				Left Join vwFaturasValidasCHB ITT with (nolock) on itt.FatCod <> @Fatcod and itt.Num_Proc=CXA.Num_Proc_HIA and itt.cd_tp_Tx=CXA.cd_tp_Tx and itt.dc=cxa.DC_HIA
			WHERE
				CXA.num_proc_HIA=@Processo AND CXA.DC_HIA='D' AND CC.NUM_PROC IS NULL 
				AND  LEFT(CXA.CD_TP_tX,1)='X'  and TT.Ref_Ctb_Tx <> 'PTC' --and CXA.CD_TP_TX NOT IN ('XBA') 
				and Fat.FatCod is null
				and ITT.FatCod is null
					
		UNION
		
		--Cta_Cte D que começa com X sem cxa e com solicitação de pagamento
			SELECT
				APELIDO,TT.NOME_TP_TX,SOL.dc DC,SOL.vlr_pgto_rcto Vlr_Org,SOL.vlr_pgto_rcto Vlr_PG,
				'REL' cd_tp_moeda,1 Paridade,
				--iSNULL(dbo.fPar_M(@dt_par,'REL','IMA'),1) Paridade,
				UPPER(SOL.CD_TP_TX) CD_TP_TX,
				NULL DebitoCC,SOL.num_proc Processo,Ref_Ctb_Tx,
				'' NF,'' [Site],
				Repasse_TX,GETDATE() Emissao 
			FROM vwSolPgtoCtaCteAprovadas SOL with (nolock)
				left join vwCXAS CXA with (nolock) on SOL.num_proc=CXA.num_proc_HIA and SOL.cd_tp_tx=CXA.cd_tp_tx and SOL.DC=cxa.DC_HIA
				JOIN TIPO_TAXA TT with(nolock) ON TT.CD_TP_TX=SOL.CD_TP_TX 
				Left Join Custo_Cliente CC with(nolock) ON SOL.CD_TP_TX=CC.CD_TP_TX AND SOL.NUM_PROC=CC.NUM_PROC
				JOIN vwCliente HOU with(nolock) ON HOU.NUM_PROC=Sol.Num_Proc
				JOIN PESSOA PP with(nolock) ON PP.CD_PES=HOU.cd_cliente
				Left Join vwFaturasValidas	FAt with (nolock)on fat.num_proc=SOL.num_proc and FAt.cd_tp_tx = SOL.cd_tp_Tx and fat.dc=SOL.DC
				Left Join vwFaturasValidasCHB ITT with (nolock) on itt.FatCod <> @Fatcod and itt.Num_Proc=SOL.num_proc and itt.cd_tp_Tx=SOL.CD_TP_TX and itt.dc=Sol.DC
			WHERE
				SOL.num_proc=@Processo AND SOL.DC='D' 
				AND CC.NUM_PROC IS NULL
				and CXA.Num_Proc_HIA is null
				AND LEFT(SOL.CD_TP_tX,1)='X' and TT.Ref_Ctb_Tx <> 'PTC'	
				and Fat.FatCod is null
				and ITT.FatCod is null
					
		Union
		
		--Cta_Cte à D que está no Custo também sem cxa e com solicitação de pagamento
			select
				PS.APELIDO,TT.nome_tp_tx,CTA.DC_HIA DC,	CTA.Vlr_Org_HIA Vlr_Org, 
				SOL.vlr_pgto_rcto Vlr_PG,CTA.cd_tp_moeda cd_tp_moeda,
				--iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
				
				(Case When CTA.Num_NF_HIA is not NULL and CTA.Ref_Acesso_NF_HIA <> 'P' Then --CC.Par_NF_HIA 
							FARG.Paridade
				Else
					--dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
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
				Left Join vwcta_Cte CtA With(nolock) on CC.num_proc=CtA.Num_Proc_HIA and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.DC_HIA='D'
				Left Join vwSolPgtoCtaCteAprovadas SOL on Cta.Num_Proc_HIA=SOL.num_proc and CtA.cd_tp_tx=SOL.cd_tp_tx and SOL.dc='D'
				Left Join vwCXAS CXA on Cta.Num_Proc_HIA=CXA.num_proc_hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='D'
				Left Join Tipo_Taxa	TT	With(nolock) on CC.CD_tp_tx = TT.CD_tp_tx
				Left Join vwCliente	HOU With(nolock) on CC.Num_proc = HOU.Num_proc
				Join Pessoa PS	With(nolock) on HOU.cd_cliente = PS.CD_pes
				Left Join vwFaturasValidas	FAt with (nolock)on fat.num_proc=SOL.num_proc and FAt.cd_tp_tx = SOL.cd_tp_Tx and SOL.DC=fat.dc
				Left Join vwFaturasValidasCHB ITT with (nolock) on itt.FatCod <> @Fatcod and itt.Num_Proc=SOL.num_proc and itt.cd_tp_Tx=SOL.CD_TP_TX and itt.dc=SOL.DC		
				left join vwFaturasValidasArg FARG With(nolock) on CtA.Num_Proc_HIA= FARG.Num_Proc and CtA.cd_tp_tx = FARG.cd_tp_tx and CtA.DC_HIA = FARG.DC
			where 
				SOL.num_proc=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(SOL.CD_TP_tX,1)='X'
				and CXA.Num_Proc_HIA is null 
				and Fat.FatCod is null
				and ITT.FatCod is null 
			
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
			
	select * from @TempTaxas --where month(Emissao) = MONTH(getdate())
	
	
	--where month(Emissao) = MONTH(getdate())
	
	

/*
ALTER procedure [dbo].[spPrestCC_ForaDoMes20200806_SEL]--[dbo].[spPrestCC] 'IMUPL201502002BR', '19-03-2015'

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
		
		-- CtaCte A Crédito Contra o Consignee	
			select
				APELIDO,TT.nome_tp_tx,CTA.DC_HIA DC,CTA.Vlr_Org_HIA Vlr_Org,CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
				CTA.cd_tp_moeda cd_tp_moeda,
				--(case When	CTA.Num_NF_HIA is not NULL and CTA.Ref_Acesso_NF_HIA <> 'P'	Then CTA.Par_NF_HIA 
				--	else 
				--	dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') 
				--end) Paridade,
						
				(Case When CTA.Num_NF_HIA is not NULL and CTA.Ref_Acesso_NF_HIA <> 'P' Then --CC.Par_NF_HIA 
							FARG.Paridade
				Else
					--dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
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
				
				UPPER(CTA.CD_TP_TX),
				Null DebitoCC,
				CTA.Num_Proc_HIA Processo,
				Ref_Ctb_Tx,
				isnull(convert(varchar(12),CTA.Num_NF_HIA),'') NF,
				 isnull(CTA.Ref_Acesso_NF_HIA,'') [Site],
				Repasse_TX ,
				isnull(FARG.Dt_Fatura,GETDATE()) Emissao
			from 					
				vwCliente					HOU with (nolock)
				Left Join vwcta_Cte			CTA with (nolock) on HOU.num_proc=CtA.Num_Proc_HIA and HOU.cd_cliente = CTA.Cd_Cred_Dev_HIA and CtA.DC_HIA='C'
				Left Join vwCXAS			CXA with (nolock) on Cta.num_proc_Hia=CXA.num_proc_HIA and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HIA='C'
				Left Join Tipo_Taxa			TT  with (nolock)on CTA.CD_tp_tx = TT.CD_tp_tx 
				Left Join Pessoa			PS with (nolock) on HOU.cd_cliente = PS.cd_pes
				Left Join vwFaturasValidas	FAt with (nolock)on fat.num_proc=CtA.Num_Proc_HIA and FAt.cd_tp_tx = CtA.cd_tp_Tx and fat.dc=CtA.DC_HIA
				Left Join vwFaturasValidasCHB ITT with (nolock) on itt.FatCod <> @Fatcod and itt.Num_Proc=CTA.Num_Proc_HIA and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.DC_HIA
				left join vwFaturasValidasArg FARG With(nolock) on CtA.Num_Proc_HIA= FARG.Num_Proc and CtA.cd_tp_tx = FARG.cd_tp_tx and CtA.DC_HIA = FARG.DC
			where 
				CTA.Num_Proc_HIA=@Processo and TT.Ref_Ctb_Tx <> 'PTC' --and CTA.Cd_tp_tx <> 'XCA'
				and Desp_Org_HIA='N' and itt.FatCod is null	and Fat.num_proc is null

		Union
		
		--Custo (IMPOSTOS) que não tem Cta_Cte e sem Invoicing <>'N'  
			select
				PS.APELIDO,TT.nome_tp_tx,'D' DC, CC.Vlr_Item_Custo Vlr_Org,CC.vlr_Item_Custo Vlr_PG,
				'REL' cd_tp_moeda,1 Paridade,
				--ISNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
				upper(CTA.CD_TP_TX),CC.CD_tp_tx DebitoCC,CC.num_proc Processo,
				Ref_Ctb_Tx,
				isnull(convert(varchar(12),CTA.Num_NF_HIA),'') NF,
				isnull(CTA.Ref_Acesso_NF_HIA,'') [Site],
				Repasse_TX,
				isnull(FARG.Dt_Fatura,GETDATE()) Emissao
			from custo_cliente		cc with (nolock)
				Left Join vwCXAS	CXA with (nolock)on CC.num_proc=CXA.num_proc_HIA and CC.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_HIA='D'
				Left Join vwcta_Cte	CtA with (nolock) on CC.num_proc=CtA.num_proc_Hia and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.DC_HIA='D'
				Left Join Tipo_Taxa	TT	with (nolock) on CC.CD_tp_tx = TT.CD_tp_tx
				Left Join vwCliente	HOU with (nolock) on CC.Num_proc = HOU.Num_proc
				Left Join Pessoa	PS	with (nolock) on HOU.cd_cliente = PS.CD_pes
				Left Join vwFaturasValidas	FAt with (nolock)on fat.num_proc=CtA.Num_Proc_HIA and FAt.cd_tp_tx = CtA.cd_tp_Tx and fat.dc=CtA.DC_HIA
				Left Join vwFaturasValidasCHB ITT with (nolock) on itt.FatCod <> @Fatcod and itt.Num_Proc=CTA.Num_Proc_HIA and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.DC_HIA						
				left join vwFaturasValidasArg FARG With(nolock) on CtA.Num_Proc_HIA= FARG.Num_Proc and CtA.cd_tp_tx = FARG.cd_tp_tx and CtA.DC_HIA = FARG.DC
			where 
				CC.Num_Proc=@Processo and num_lcto is null and cta.num_proc_hia is null 
				and (Prestacao = 'S' or Prestacao is null)
				and itt.FatCod is null	and Fat.num_proc is null

		Union
		
		--Cta_Cte à D que está no Custo também
			select
				PS.APELIDO,	TT.nome_tp_tx,CTA.DC_HIA DC, CTA.Vlr_Org_HIA Vlr_Org, CXA.vlr_pgto_rcto_hia Vlr_PG,
				CTA.cd_tp_moeda cd_tp_moeda,
				--iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
				
				(Case When CTA.Num_NF_HIA is not NULL and CTA.Ref_Acesso_NF_HIA <> 'P' Then --CC.Par_NF_HIA 
							FARG.Paridade
				Else
					--dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
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
				
				
				UPPER(CTA.CD_TP_TX),UPPER(CC.CD_tp_tx) DebitoCC,CC.num_proc Processo,	Ref_Ctb_Tx,
				isnull(convert(varchar(12),CTA.Num_NF_HIA),'') NF,
				isnull(CTA.Ref_Acesso_NF_HIA,'') [Site],
				Repasse_TX ,
				isnull(FARG.Dt_Fatura,GETDATE()) Emissao				
			from custo_cliente				cc with (nolock)
				Left Join vwcta_Cte			CtA with (nolock) on CC.num_proc=CtA.Num_Proc_HIA and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.DC_HIA='D'
				Left Join vwCXAS			CXA with (nolock) on Cta.Num_Proc_HIA=CXA.num_proc_hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='D'
				Left Join Tipo_Taxa			TT	with (nolock)on CC.CD_tp_tx = TT.CD_tp_tx
				Left Join vwCliente			HOU with (nolock) on CC.Num_proc = HOU.num_proc
				Join Pessoa					PS	with (nolock)on HOU.cd_cliente = PS.CD_pes
				Left Join vwFaturasValidas	FAt with (nolock)on fat.num_proc=CtA.Num_Proc_HIA and FAt.cd_tp_tx = CtA.cd_tp_Tx and fat.dc=CtA.DC_HIA
				Left Join vwFaturasValidasCHB ITT with (nolock) on itt.FatCod <> @Fatcod and itt.Num_Proc=CTA.Num_Proc_HIA and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.DC_HIA						
				left join vwFaturasValidasArg FARG With(nolock) on CtA.Num_Proc_HIA= FARG.Num_Proc and CtA.cd_tp_tx = FARG.cd_tp_tx and CtA.DC_HIA = FARG.DC
			where 
				CXA.num_proc_hia=@Processo 
				and (Prestacao = 'S' or Prestacao is null) 
				and LEFT(CXA.CD_TP_tX,1)='X'
				and itt.FatCod is null	and Fat.num_proc is null
		Union
					
		--Cta_Cte à D que não está no Custo também
			select
				APELIDO,TT.nome_tp_tx,CTA.DC_HIA DC,DBO.VALOR(CTA.Vlr_Org_HIA,CTA.DC_HIA) Vlr_Org,
				CXA.Vlr_Pgto_Rcto_Hia Vlr_PG,
				'REL' cd_tp_moeda,	1 Paridade,
				--iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1 Paridade,
				UPPER(CTA.CD_TP_TX) CD_TP_TX,Null DebitoCC,CTA.Num_Proc_HIA Processo,
				Ref_Ctb_Tx,	
				isnull(convert(varchar(12),CTA.Num_NF_HIA),'') NF,
				isnull(CTA.Ref_Acesso_NF_HIA,'') [Site],
				Repasse_TX,
				isnull(FARG.Dt_Fatura,GETDATE()) Emissao
			from 
				vwCliente HOU with (nolock)
				Left Join vwcta_Cte CtA with (nolock) on HOU.num_proc=CtA.Num_Proc_HIA and HOU.cd_cliente = CTA.Cd_Cred_Dev_HIA and CtA.DC_HIA='D'
				Left Join vwCXAS CXA with (nolock) on Cta.Num_Proc_HIA=CXA.num_proc_Hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_Hia='D'
				Left Join Tipo_Taxa TT with (nolock) on CTA.CD_tp_tx = TT.CD_tp_tx
				Left Join Pessoa PS with (nolock) on HOU.cd_cliente = PS.cd_pes					
				Left Join vwFaturasValidas FAt with (nolock) on fat.num_proc=CtA.Num_Proc_HIA and CtA.cd_tp_Tx=FAt.cd_tp_tx and CtA.DC_HIA=fat.dc    
				Left Join vwFaturasValidasCHB ITT with (nolock) on itt.FatCod <> @Fatcod and itt.Num_Proc=CTA.Num_Proc_HIA and itt.cd_tp_Tx=CTA.cd_tp_Tx and itt.dc=CTA.DC_HIA
				left join vwFaturasValidasArg FARG With(nolock) on CtA.Num_Proc_HIA= FARG.Num_Proc and CtA.cd_tp_tx = FARG.cd_tp_tx and CtA.DC_HIA = FARG.DC
			where 
				CTA.Num_Proc_HIA=@Processo 
				and CTA.CD_TP_TX in ('RIS','IRR','C01','c02','C03','C04','C05','C06','C07','c08','c09','p01','p02','p03','P04','P05','P06','P07','P08','P09','CF1','CF3','CF4','cf5','CF6','CF7','CF8','CF9')
				and Fat.FatCod is null
				and ITT.FatCod is null
					
		Union
		
		--Cta_Cte D que começa com X
			SELECT
				APELIDO,TT.NOME_TP_TX,CXA.dc_HIA DC,CXA.vlr_pgto_rcto_Hia Vlr_Org,CXA.vlr_pgto_rcto_Hia Vlr_PG,
				'REL' cd_tp_moeda,1 Paridade,
				--iSNULL(dbo.fPar_M(@dt_par,'REL','OFC'),1) Paridade,
				UPPER(CXA.CD_TP_TX) CD_TP_TX,NULL DebitoCC,CXA.num_proc_Hia Processo,
				Ref_Ctb_Tx,'' NF, '' [Site],
				Repasse_TX,GETDATE() Emissao
			FROM vwCXAS CXA with (nolock)
				JOIN TIPO_TAXA TT with (nolock) ON TT.CD_TP_TX=CXA.CD_TP_TX
				Left Join Custo_Cliente CC with (nolock) on CXA.CD_TP_TX=CC.CD_TP_TX AND CXA.NUM_PROC_HIA=CC.NUM_PROC
				JOIN vwCliente HOU with (nolock) ON HOU.NUM_PROC=CXA.NUM_PROC_HIA
				JOIN PESSOA PP with (nolock) ON PP.CD_PES=HOU.cd_cliente
				Left Join vwFaturasValidas	FAt with (nolock)on fat.num_proc=CXA.Num_Proc_HIA and FAt.cd_tp_tx = CXA.cd_tp_Tx and fat.dc=CXA.DC_HIA
				Left Join vwFaturasValidasCHB ITT with (nolock) on itt.FatCod <> @Fatcod and itt.Num_Proc=CXA.Num_Proc_HIA and itt.cd_tp_Tx=CXA.cd_tp_Tx and itt.dc=cxa.DC_HIA
			WHERE
				CXA.num_proc_HIA=@Processo AND CXA.DC_HIA='D' AND CC.NUM_PROC IS NULL 
				AND  LEFT(CXA.CD_TP_tX,1)='X'  and TT.Ref_Ctb_Tx <> 'PTC' --and CXA.CD_TP_TX NOT IN ('XBA') 
				and Fat.FatCod is null
				and ITT.FatCod is null
					
		UNION
		
		--Cta_Cte D que começa com X sem cxa e com solicitação de pagamento
			SELECT
				APELIDO,TT.NOME_TP_TX,SOL.dc DC,SOL.vlr_pgto_rcto Vlr_Org,SOL.vlr_pgto_rcto Vlr_PG,
				'REL' cd_tp_moeda,1 Paridade,
				--iSNULL(dbo.fPar_M(@dt_par,'REL','IMA'),1) Paridade,
				UPPER(SOL.CD_TP_TX) CD_TP_TX,
				NULL DebitoCC,SOL.num_proc Processo,Ref_Ctb_Tx,
				'' NF,'' [Site],
				Repasse_TX,GETDATE() Emissao 
			FROM vwSolPgtoCtaCteAprovadas SOL with (nolock)
				left join vwCXAS CXA with (nolock) on SOL.num_proc=CXA.num_proc_HIA and SOL.cd_tp_tx=CXA.cd_tp_tx and SOL.DC=cxa.DC_HIA
				JOIN TIPO_TAXA TT with(nolock) ON TT.CD_TP_TX=SOL.CD_TP_TX 
				Left Join Custo_Cliente CC with(nolock) ON SOL.CD_TP_TX=CC.CD_TP_TX AND SOL.NUM_PROC=CC.NUM_PROC
				JOIN vwCliente HOU with(nolock) ON HOU.NUM_PROC=Sol.Num_Proc
				JOIN PESSOA PP with(nolock) ON PP.CD_PES=HOU.cd_cliente
				Left Join vwFaturasValidas	FAt with (nolock)on fat.num_proc=SOL.num_proc and FAt.cd_tp_tx = SOL.cd_tp_Tx and fat.dc=SOL.DC
				Left Join vwFaturasValidasCHB ITT with (nolock) on itt.FatCod <> @Fatcod and itt.Num_Proc=SOL.num_proc and itt.cd_tp_Tx=SOL.CD_TP_TX and itt.dc=Sol.DC
			WHERE
				SOL.num_proc=@Processo AND SOL.DC='D' 
				AND CC.NUM_PROC IS NULL
				and CXA.Num_Proc_HIA is null
				AND LEFT(SOL.CD_TP_tX,1)='X' and TT.Ref_Ctb_Tx <> 'PTC'	
				and Fat.FatCod is null
				and ITT.FatCod is null
					
		Union
		
		--Cta_Cte à D que está no Custo também sem cxa e com solicitação de pagamento
			select
				PS.APELIDO,TT.nome_tp_tx,CTA.DC_HIA DC,	CTA.Vlr_Org_HIA Vlr_Org, 
				SOL.vlr_pgto_rcto Vlr_PG,CTA.cd_tp_moeda cd_tp_moeda,
				--iSNULL(dbo.fPar_M(@dt_par,cta.cd_tp_moeda,'OFC'),1) Paridade,
				
				(Case When CTA.Num_NF_HIA is not NULL and CTA.Ref_Acesso_NF_HIA <> 'P' Then --CC.Par_NF_HIA 
							FARG.Paridade
				Else
					--dbo.verparidade(convert(varchar(10),getdate(),103),CTA.cd_tp_moeda,'OFC') end ) Paridade,
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
				Left Join vwcta_Cte CtA With(nolock) on CC.num_proc=CtA.Num_Proc_HIA and CC.cd_tp_tx=CtA.cd_tp_tx and CtA.DC_HIA='D'
				Left Join vwSolPgtoCtaCteAprovadas SOL on Cta.Num_Proc_HIA=SOL.num_proc and CtA.cd_tp_tx=SOL.cd_tp_tx and SOL.dc='D'
				Left Join vwCXAS CXA on Cta.Num_Proc_HIA=CXA.num_proc_hia and CtA.cd_tp_tx=CXA.cd_tp_tx and CXA.dc_hia='D'
				Left Join Tipo_Taxa	TT	With(nolock) on CC.CD_tp_tx = TT.CD_tp_tx
				Left Join vwCliente	HOU With(nolock) on CC.Num_proc = HOU.Num_proc
				Join Pessoa PS	With(nolock) on HOU.cd_cliente = PS.CD_pes
				Left Join vwFaturasValidas	FAt with (nolock)on fat.num_proc=SOL.num_proc and FAt.cd_tp_tx = SOL.cd_tp_Tx and SOL.DC=fat.dc
				Left Join vwFaturasValidasCHB ITT with (nolock) on itt.FatCod <> @Fatcod and itt.Num_Proc=SOL.num_proc and itt.cd_tp_Tx=SOL.CD_TP_TX and itt.dc=SOL.DC		
				left join vwFaturasValidasArg FARG With(nolock) on CtA.Num_Proc_HIA= FARG.Num_Proc and CtA.cd_tp_tx = FARG.cd_tp_tx and CtA.DC_HIA = FARG.DC
			where 
				SOL.num_proc=@Processo and (Prestacao = 'S' or Prestacao is null) and LEFT(SOL.CD_TP_tX,1)='X'
				and CXA.Num_Proc_HIA is null 
				and Fat.FatCod is null
				and ITT.FatCod is null 
			
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
			
	select * from @TempTaxas
*/

GO
