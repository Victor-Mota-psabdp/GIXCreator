SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spNF2SAP_Solenis_LeandroTeste_Rel]--.[spNF2SAP_Solenis_LeandroTeste_Rel] 'IMSOL202510108BR','22028'  spNF2SAP_Solenis_Rel

	@Num_Proc varchar(16),
	@nNF varchar(20)
as
			
		Declare @TabelaHeader Table
		
	(
			[ITMTYP]							varchar (200),
			[MATNR]								varchar (200),
			[MAKTX]								varchar (200),
			[WERKS]								varchar (200),
			[MENGE]								varchar (200),
			[MEINS]								varchar (200),
			[NETPR]								varchar (200),
			[NETDIS]							varchar (200),
			[NETINS]							varchar (200),
			[NETOTH]							varchar (200),
			[NETFRE]							varchar (200),
			[CFOP_10]							varchar (200),
			[MATORG]							varchar (200),
			[MATUSE]							varchar (200),
			[STEUC]								varchar (200),
			[MATKL]								varchar (200),
			[BASE_II]							varchar (200),
			[OTHBAS_II]							varchar (200),
			[EXCBAS_II]							varchar (200),
			[RATE_II]							varchar (200),
			[TAXVAL_II]							varchar (200),
			[BASE_ICMS]							varchar (200),
			[OTHBAS_ICMS]						varchar (200),
			[EXCBAS_ICMS]						varchar (200),
			[RATE_ICMS]							varchar (200),
			[TAXVAL_ICMS]						Decimal (18,2),
			[TAXLW1]							varchar	(200),
			[BASE_IPI]							varchar (200),
			[OTHBAS_IPI]						varchar (200),
			[EXCBAS_IPI]						varchar (200),
			[RATE_IPI]							varchar (200),
			[TAXVAL_IPI]						varchar (200),
			[TAXLW2]							varchar	(200),
			[BASE_COFINS]						varchar (200),
			[OTHBAS_COFINS]						varchar (200),
			[EXCBAS_COFINS]						varchar (200),
			[RATE_COFINS]						varchar (200),
			[TAXVAL_COFINS]						Decimal (18,2),
			[TAXLW4]							varchar (200),
			[BASE_PIS]							varchar (200),
			[OTHBAS_PIS]						varchar (200),
			[EXCBAS_PIS]						varchar (200),
			[RATE_PIS]							varchar (200),
			[TAXVAL_PIS]						Decimal (18,2),
			[TAXLW5]							varchar (200),

			--LEANDRO 20/01/2026 - 100-563090
			[BASE_IBS]                          varchar (200),
			[OTHBAS_IBS]						varchar (200),
			[EXCBAS_IBS]						varchar (200),
			[RATE_IBS]							varchar (200),
			[TAXVAL_IBS]						varchar (200),
			[BASE_IBSM]							varchar (200),
			[OTHBAS_IBSM]						varchar (200),
			[EXCBAS_IBSM]						varchar (200),
			[RATE_IBSM]							varchar (200),
			[TAXVAL_IBSM]						varchar (200),
			[BASE_CBS]							varchar (200),
			[OTHBAS_CBS]						varchar (200),
			[EXCBAS_CBS]						varchar (200),
			[RATE_CBS]							varchar (200),
			[TAXVAL_CBS]						varchar (200),
			[TAXSITUATION]						varchar (200),
			[CST]								varchar (200),
			[CCLASSTRIB]						varchar (200),
			--

			[NDI]								varchar (200),
			[NADICAO]							varchar (200),
			[NSEQADIC]							varchar (200),
			[CFABRICANTE]						varchar (200),
			[VDESCDI]							varchar (200),
			[DRAW_BACK]							varchar (200),
			[NDI_ADIC]							varchar (200),
			[DDI]								varchar	(200),
			[XLOCDESEMB]						varchar (200),
			[UFDESEMB]							varchar (200),
			[DDESEMB]							varchar (200),
			[CEXPORTADOR]						varchar	(200),
			[COD_DOC_IMP]						varchar (200),
			[NUM_ACDRAW]						varchar (200),
			[TRANSPORT_MODE]					varchar (200),
			[MARITIME_FREIGHT]					Decimal (18,2),
			[INTERMEDIATE_MODE]					varchar (200),
			[CNPJ]								varchar (200),
			[REGIO]								varchar (200),
			[PARVW]								varchar (200),
			[PARID]								varchar (200),
			[TRATY]								varchar	(200),
			[TRAID]								varchar	(200),
			[INCO1]								varchar	(200),
			[INCO2]								varchar	(200),
			[VSTEL]								varchar	(200),
			[ANZPK]								varchar	(200),
			[SHPUNT]							varchar	(200),
			[SHPMRK]							varchar	(200),
			[SHPNUM]							varchar	(200),
			[NTGEW]								varchar (200),
			[BRGEW]								varchar (200),
			[MODFRETE]							varchar (200),
			[XPED]								varchar	(200),
			[NITEMPED]							varchar	(2000),
			[SISCOMEX]							Decimal (18,2),
			[AFRMM]								Decimal (18,2),
			[OUTROS]							Decimal (18,2),
			[CFOP]								bigint
	)

	insert into @TabelaHeader
		
		select
			'1'																		[ITMTYP],			--[Tipo de Item NFe],
			IP.cProd																[MATNR],			--[N° do Material],
			NULL																	[MAKTX],			--[Descrição do item],
			(Case when e.CNPJ = '55720908000242' then '6103' else
			(Case when e.CNPJ = '55720908001303' then '6113' else
			(Case when e.CNPJ = '55720908001133' then '6111'  End) End) End)		[WERKS],			--[CENTRO],
			format(IP.qCom, 'n3', 'pt')												[MENGE],			--[Qtd],
			IP.uCOM																	[MEINS],			--[UM],
			(case when II.vBC is not null then cast (II.vBC / ip.qCom AS DECIMAL(18, 6)) else
			convert(varchar(20), convert(decimal(18,6),ip.vUNCom)) end)				[NETPR],			--[Preço Líquido],
			NULL																	[NETDIS],			--[Desconto],
			NULL																	[NETINS],			--[Seguro],
			
			--(case when IP.CFOP = 3127 then null else
			--(CASE WHEN lag(DI.cprod) OVER (ORDER BY di.cprod) = DI.cprod THEN null ELSE
			--format(T.vICMS + T.vPIS + T.vCofins + t.vOutros - di.vAFRMM + ip.vfrete, 'N2','pt-BR') end) end)    [NETOTH],--[Despesas]
			NULL																	[NETOTH],--[Despesas],
			NULL																	[NETFRE],			--[Frete],
			IP.CFOP + '/AA'															[CFOP_10],			--[CFOP],
			'1'																		[MATORG],			--[Origem do Material],
			NULL																	[MATUSE],			--[Origem do material],
			NULL																	[STEUC],			--[NCM],
			NULL																	[MATKL],			--[Grupo de mercadoria],
			(Case when IP.CFOP = 3127 then null else
			format(II.vbc, 'N2','pt-BR') end)										[BASE_II],			--[Base de II],T.vProd
			(Case when IP.CFOP = 3127 then format((T.vbc), 'N2','pt-BR') else
			null end)																[OTHBAS_II],		--[Outra Base II],
			NULL																	[EXCBAS_II],		--[Base Excl. II],
			(Case when IP.CFOP = 3127 then '0' else
			(Case when II.vBC = null then '0' else
			(Case when II.vBC = 0 then '0' else
			convert(varchar(20), convert(decimal(18,2),(II.vImposto / II.vBC) * 100)) end) end) end)[RATE_II],			--[Alíquota de II],
			(Case when IP.CFOP = 3127 then '0' else
			format(II.vImposto, 'N2','pt-BR') end)									[TAXVAL_II],		--[Valor de II],
			(Case when IP.CFOP = 3127 then null else
			format(ICMS.vBC, 'N2','pt-BR') end)										[BASE_ICMS],		--[Base de ICMS],
			(Case when IP.CFOP = 3127 then format((T.vbc), 'N2','pt-BR') else
			null end)																[OTHBAS_ICMS],		--[Outra Base ICMS],
			NULL																	[EXCBAS_ICMS],		--[Base Excl. ICMS],
			(Case when IP.CFOP = 3127 then null else
			(Case when ICMS.vBC = null then '0' else
			convert(varchar(20), convert(decimal(18,2),(ICMS.vImposto / ICMS.vBC) * 100)) end)end) [RATE_ICMS],		--[Alíquota de ICMS],
			
			(Case when IP.CFOP = 3127 then '0' else
			convert(decimal(18,2),icms.vImposto) end)								[TAXVAL_ICMS],		--[Valor de ICMS],
			

			(Case when IP.CFOP = 3127 then 'IC4' else
			'IC0' end)																[TAXLW1],			--[Direito Fiscal ICMS],
			(Case when IP.CFOP = 3127 then null else
			format(IPI.vBC, 'N2','pt-BR')end)										[BASE_IPI],			--[Base de IPI],
			(Case when IP.CFOP = 3127 then format((T.vbc), 'N2','pt-BR') else
			null end)																[OTHBAS_IPI],		--[Outra Base IPI],
			NULL																	[EXCBAS_IPI],		--[Base Excl. IPI],
			(Case when IP.CFOP = 3127 then '0' else
			(Case when IPI.vBC = null then '0' else
			(Case when IPI.vBC = 0 then '0' else
			convert(varchar(20), convert(decimal(18,2),(IPI.vImposto / IPI.vBC) * 100)) end)end)end)[RATE_IPI],			--[Alíquota de IPI],
			(Case when IP.CFOP = 3127 then '0' else
			format(IPI.vImposto, 'N2','pt-BR')end)									[TAXVAL_IPI],		--[Valor de IPI],
			(Case when IP.CFOP = 3127 then 'IP3' else
			(Case when ipi.pImposto = 0 then 'I01' else 'I00' end) end)				[TAXLW2],			--[Direito Fiscal IPI],
			(Case when IP.CFOP = 3127 then null else
			format(COFINS.vbc, 'N2','pt-BR')end)									[BASE_COFINS],		--[Base Cofins],
			(Case when IP.CFOP = 3127 then format((T.vbc), 'N2','pt-BR') else
			null end)																[OTHBAS_COFINS],	--[Outra Base Cofins],
			NULL																	[EXCBAS_COFINS],	--[Base Excl. Confins],
			(Case when IP.CFOP = 3127 then null else
			(Case when COFINS.vBC = null then '0' else
			(Case when COFINS.vBC = 0 then '0' else
			convert(varchar(20), convert(decimal(18,2),(COFINS.vImposto / COFINS.vBC) * 100))end)end)end)[RATE_COFINS],		--[Alíquota de Cofins],
			(Case when IP.CFOP = 3127 then null else
			convert(decimal(18,2),COFINS.vImposto)end)								[TAXVAL_COFINS],	--[Valor de Cofins],
			(Case when IP.CFOP = 3127 then 'C70' else
			'C56' end)																[TAXLW4],			--[Leis Cofins],
			(Case when IP.CFOP = 3127 then null else
			format(PIS.vbc, 'N2','pt-BR')end)										[BASE_PIS],			--[Base PIS],
			(Case when IP.CFOP = 3127 then format((T.vbc), 'N2','pt-BR') else
			null end)																[OTHBAS_PIS],		--[Outra Base PIS],
			NULL																	[EXCBAS_PIS],		--[Base Excl. PIS],
			(Case when IP.CFOP = 3127 then null else
			(Case when PIS.vBC = null then '0' else
			(Case when PIS.vBC = 0 then '0' else
			convert(varchar(20), convert(decimal(18,2),(PIS.vImposto / PIS.vBC) * 100))	end)end)end)[RATE_PIS],			--[Alíquota de PIS],
			(Case when IP.CFOP = 3127 then null else
			convert(decimal(18,2),PIS.vImposto) end)								[TAXVAL_PIS],		--[Valor de PIS],
			(Case when IP.CFOP = 3127 then 'P70' else
			'P56'	end)															[TAXLW5],			--[Leis PIS],

			--LEANDRO - 100-563090
			NULL																	[BASE_IBS], --Base IBS
			NULL																	[OTHBAS_IBS], --Outra Base IBS
			NULL																	[EXCBAS_IBS], --Base Excl. Confins
			0.10																		[RATE_IBS], --Alíquota de IBS
			NULL																	[TAXVAL_IBS], --Valor de IBS
			NULL																	[BASE_IBSM], --Base IBSM
			NULL																	[OTHBAS_IBSM], --Outra Base IBSM
			NULL																	[EXCBAS_IBSM], --Base Excl. Confins
			NULL																	[RATE_IBSM], --Alíquota de IBSM
			NULL																	[TAXVAL_IBSM], --Valor de IBSM
			NULL																	[BASE_CBS], --Base CBS
			NULL																	[OTHBAS_CBS], --Outra Base CBS
			NULL																	[EXCBAS_CBS], --Base Excl. Confins
			0.90																		[RATE_CBS], --Alíquota de CBS
			NULL																	[TAXVAL_CBS], --Valor de CBS
			'000'																	[TAXSITUATION], --TAXSITUATION
			'000'																	[CST], --CST
			'000001'																[CCLASSTRIB], --CCLASSTRIB
			--

			DI.nDI																	[NDI],				--[No DI],
			IPDA.nAdicao															[NADICAO],			--[No Suplemento <nAdicao>],
			IPDA.nSeqAdic															[NSEQADIC],			--[No Item Supl. <nSeqAdic>],
			llp.Cd_Vendor															[CFABRICANTE],		--[Cód. Fab. <cFabricante>],
			NULL																	[VDESCDI],			--[Valor Red.Item Supl.<vDescDI>],
			--CP44.Campo_Dados														[DRAW_BACK],		--[No Benefício DRAW_BACK],
			(Case when ip.CFOP = 3101 then null else
			vp.numero_po end)														[DRAW_BACK],		--[No Benefício DRAW_BACK],
			DI.nDI																	[NDI_ADIC],			--[No DI],
			convert(varchar (10),DI.dDI,103)										[DDI],				--[Data Reg.(DI/DSI/DA)/tag <dDI>],
			(case when DI.xLocDesemb = 'SANTOS' then 'PORTO DE SANTOS' else
			(case when DI.xLocDesemb = 'CAMPINAS' then 'VIRACOPOS' else DI.xLocDesemb end) end)	[XLOCDESEMB],		--[Local Desemb. <xLocDesemb>],
			DI.UFDesemb																[UFDESEMB],			--[Reg. Fiscal Desemb <UFDesemb>],
			convert(varchar (10),DI.dDesemb,103)									[DDESEMB],			--[Data Desemb <dDesemb>],
			llp.Cd_Vendor															[CEXPORTADOR],		--[Cód. Exportador <cExportador>],
			'1'																		[COD_DOC_IMP],		--[Tipo Decl. Import.],
			'001'																	[NUM_ACDRAW],		--[No Proc. Reembolso alfand.],
			(case when left (hg.Num_Proc,2) = 'IM' then '1' else
			(case when left (hg.Num_Proc,2) = 'IA' then '4' else '7' end) end)		[TRANSPORT_MODE],	--[Meio de transporte],
			--convert(decimal(18,2),IP.vFrete)										[MARITIME_FREIGHT],	--[Frete marítimo],
			convert(decimal(18,2),di.vAFRMM)										[MARITIME_FREIGHT],
			'1'																		[INTERMEDIATE_MODE],--[Modo intermediário],
			e.CNPJ																	[CNPJ],				--[CNPJ do Comprador],
			'SP'																	[REGIO],			--[Região Terceiro],
			'SP'																	[PARVW],			--[NF Funçãoparc.],
			DP.Cd_Dst																[PARID],			--[ID Parceiro],
			(case when hg.Tp_Carga = 1 then '0002' else
			(case when hg.Tp_Carga = 2 then '0001' else
			(case when hg.tp_carga = 3 then '0004' end) end) end)					[TRATY],			--[TP Veículo Transporte],
			TRV.esp																	[TRAID],			--[ID veíc.transp.],
			HG.Cd_Tp_Oper															[INCO1],			--[Incoterms],
			TR.xMun																	[INCO2],			--[Local],
			NULL																	[VSTEL],			--[71],
			TRV.qVol																[ANZPK],			--[VOLUME],
			IP.uCOM																	[SHPUNT],			--[73],
			TRV.Marca																[SHPMRK],			--[Código elem Exp],
			TRV.nVol																[SHPNUM],			--[Nº elemento exp],
			format(TRV.PesoL, 'n3', 'pt-br')										[NTGEW],			--[Peso líquido],
			format(TRV.PesoB,'n3','pt-br')											[BRGEW],			--[Peso bruto],
			'1'																		[MODFRETE],			--[Modalid. frete],
			atlantis.dbo.fBusca_TipoDocCliente('N',@Num_Proc,1)						[XPED],	--[Número do Pedido],
			''																		[NITEMPED],			--[Linha do pedido],
			convert(decimal(18,2), ip.vOutrasDesp - di.vAFRMM)						[SISCOMEX],
			--convert(decimal(18,2), dbo.fBusca_Custo_Processo (@num_proc, '%Siscomex%'))	[SISCOMEX],
			convert(decimal(18,2),di.vAFRMM)										[AFRMM],
			convert(decimal(18,2), NULL)											[OUTROS],
			IP.CFOP																	[CFOP]

		from 
			ATL_BR.dbo.Danfe_Base D with(nolock)
			join ATL_BR.dbo.Danfe_Item I with(nolock) on I.Id_Danfe = i.id_Item
			join ATL_BR.dbo.Danfe_Item_Produto IP with(nolock) on IP.Id_Danfe = D.Id_Danfe
			join ATL_BR.dbo.Danfe_Item_Prod_DI DI with(nolock) on DI.Id_Danfe = D.Id_Danfe and DI.id_item=IP.id_Item and Ip.cProd = Di.cProd
			join ATL_BR.dbo.Danfe_Totais T with(nolock) on T.Id_Danfe = D.Id_Danfe
			join vwHouse_Imp HG	with(nolock) on HG.Num_Proc = D.Num_Proc
						
			
			left join ATL_BR.dbo.Danfe_Cia E with(nolock) on e.Id_Danfe = D.Id_Danfe and e.Tipo = 'E'
			left join ATL_BR.dbo.Danfe_Cia DC with(nolock) on DC.Id_Danfe = D.Id_Danfe and DC.Tipo = 'D'
			left Join ATL_BR.dbo.Danfe_Item_Impostos II with(nolock) on II.id_danfe = D.id_danfe and II.id_item=IP.id_Item and II.cImpostos='II'
			left Join ATL_BR.dbo.Danfe_Item_Impostos ICMS with(nolock) on ICMS.id_danfe = D.id_danfe and ICMS.id_item=IP.id_Item and ICMS.cImpostos='ICMS'
			left Join ATL_BR.dbo.Danfe_Item_Impostos IPI with(nolock) on IPI.id_danfe = D.id_danfe and IPI.id_item=IP.id_Item and IPI.cImpostos='IPI'
			left Join ATL_BR.dbo.Danfe_Item_Impostos COFINS with(nolock) on COFINS.id_danfe = D.id_danfe and COFINS.id_item=IP.id_Item and COFINS.cImpostos='COFINS'
			left Join ATL_BR.dbo.Danfe_Item_Impostos PIS with(nolock) on PIS.id_danfe = D.id_danfe and PIS.id_item=IP.id_Item and PIS.cImpostos='PIS'
			left join ATL_BR.dbo.Danfe_Item_Prod_DI_Adicao IPDA with(nolock) on IPDA.nDI = DI.nDI and IPDA.Id_Danfe = DI.Id_Danfe and IPDA.id_item=DI.id_Item
			left join ATL_BR.dbo.Danfe_Transp TR with(nolock) on TR.id_danfe = D.id_danfe
			left join ATL_BR.dbo.Danfe_Transp_Vol TRV with(nolock) on TRV.id_danfe = D.id_danfe
			left join Campo_Processo CP44 with(nolock)  on CP44.Num_Proc = HG.Num_Proc and CP44.Id_Campo = 44  
			left join Pessoa IT With(Nolock) on IT.Cd_pes = HG.Cd_Transportadora
			left join DE_PARA DP With(Nolock) on DP.Cd_Tipo = 11 and dp.Cd_Cliente = 'P000030340' and dp.Cd_Org = IT.Apelido
			left join Pessoa_LLP LLP with(nolock) on LLP.Cd_Pes = HG.Cd_Export 
			Left Join vwPO_ALL  vp with(nolock) on vp.num_proc=HG.num_proc and vp.ID_DC=24
			Left Outer Join Tarefas_processos	T24	with(nolock) on HG.Num_Proc = T24.Num_proc and T24.ID_Task = 24

		where
			--D.num_proc = 'IMSOL202303012BR'
			D.num_proc = @Num_Proc
			and ( nNF = @nNF )

--	DECLARE @NETOTH decimal(18,2)
--	UPDATE H
--SET H.NETOTH =
--    CASE
--        WHEN H.CFOP = 3127 THEN NULL
--        ELSE FORMAT(
--              ISNULL(H.TAXVAL_ICMS, 0)
--            + ISNULL(H.TAXVAL_COFINS, 0)
--            + ISNULL(H.TAXVAL_PIS, 0)
--            + ISNULL(H.AFRMM, 0)
--            + ISNULL(CAST(REPLACE(REPLACE(H.BRGEW, '.', ''), ',', '.') 
--    AS DECIMAL(15,3)) / H.SISCOMEX, 0), 'N2', 'pt-BR')
--    END
--FROM @TabelaHeader H;
	DECLARE @NETOTH decimal(18,2)
	UPDATE H
SET H.NETOTH =
    CASE
        WHEN H.CFOP = 3127 THEN NULL
        ELSE FORMAT(
              ISNULL(H.TAXVAL_ICMS, 0)
            + ISNULL(H.TAXVAL_COFINS, 0)
            + ISNULL(H.TAXVAL_PIS, 0)
            + ISNULL(H.AFRMM, 0)
            + ISNULL(H.SISCOMEX, 0)
        , 'N2', 'pt-BR')
    END
FROM @TabelaHeader H;


DECLARE @BASE_IBS decimal(18,2)

UPDATE H
SET H.BASE_IBS =
    FORMAT(
          (
                ISNULL(
                    TRY_CONVERT(decimal(18,6),
                        REPLACE(REPLACE(H.MENGE,'.',''),',','.')
                    ),0
                )
                *
                ISNULL(
                    COALESCE(
                        TRY_CONVERT(decimal(18,6),H.NETPR),
                        TRY_CONVERT(decimal(18,6),
                            REPLACE(REPLACE(H.NETPR,'.',''),',','.')
                        )
                    ),0
                )
          )
        + ISNULL(
              TRY_CONVERT(decimal(18,2),
                  REPLACE(REPLACE(H.TAXVAL_II,'.',''),',','.')
              )
          ,0)
        + ISNULL(H.AFRMM,0)
        + ISNULL(H.SISCOMEX,0)
    ,'N2','pt-BR')
FROM @TabelaHeader H;

--UPDATE H
--SET H.BASE_IBS =
--    FORMAT(
--          (
--                ISNULL(TRY_CONVERT(decimal(18,6), REPLACE(REPLACE(H.MENGE, '.', ''), ',', '.')), 0)
--              * ISNULL(
--                    COALESCE(
--                        TRY_CONVERT(decimal(18,6), H.NETPR),
--                        TRY_CONVERT(decimal(18,6), REPLACE(REPLACE(H.NETPR, '.', ''), ',', '.'))
--                    ), 0
--                )
--          )
--        + ISNULL(H.MARITIME_FREIGHT, 0)
--        + ISNULL(
--              COALESCE(
--                  TRY_CONVERT(decimal(18,2), H.NETINS),
--                  TRY_CONVERT(decimal(18,2), REPLACE(REPLACE(H.NETINS, '.', ''), ',', '.'))
--              ), 0
--          )
--        + (
--                ISNULL(TRY_CONVERT(decimal(18,2), REPLACE(REPLACE(H.NETOTH, '.', ''), ',', '.')), 0)
--              - ISNULL(H.TAXVAL_ICMS, 0)
--              - ISNULL(H.TAXVAL_COFINS, 0)
--              - ISNULL(H.TAXVAL_PIS, 0)
--           --   - ISNULL(H.MARITIME_FREIGHT, 0)
--          )
--    , 'N2', 'pt-BR')
--FROM @TabelaHeader H;

DECLARE @TAXVAL_IBS decimal(18,2)

UPDATE H
SET H.TAXVAL_IBS =
    FORMAT(
        ISNULL(
            TRY_CONVERT(decimal(18,6),
                REPLACE(REPLACE(H.BASE_IBS,'.',''),',','.')
            )
        ,0)
        *
        (
            ISNULL(
                TRY_CONVERT(decimal(18,6),
                    REPLACE(H.RATE_IBS,',','.')
                )
            ,0) --/ 100
        )
    ,'N2','pt-BR')
FROM @TabelaHeader H;

--UPDATE H
--SET H.TAXVAL_IBS = 
--    REPLACE(
--        REPLACE(
--            REPLACE(H.BASE_IBS, '.', '#'),
--        ',', ''),
--    '#', ',') 
--	*
--	   (
--            ISNULL(
--                TRY_CONVERT(decimal(18,6), REPLACE(H.RATE_IBS,',','.'))
--            ,0) / 100
--        )
--FROM @TabelaHeader H;

DECLARE @BASE_CBS decimal(18,2)
UPDATE H
SET H.BASE_CBS = H.BASE_IBS
FROM @TabelaHeader H;

DECLARE @TAXVAL_CBS decimal(18,2)
UPDATE H
SET H.TAXVAL_CBS =
    FORMAT(
        ISNULL(
            TRY_CONVERT(decimal(18,6), REPLACE(REPLACE(H.BASE_CBS,'.',''),',','.'))
        ,0)
        *
        (
            ISNULL(
                TRY_CONVERT(decimal(18,6), REPLACE(H.RATE_CBS,',','.'))
            ,0) --/ 100
        )
    ,'N2','pt-BR')
FROM @TabelaHeader H;

		select
		'ITMTYP'[Tipo de Item NFe],
		'MATNR'[N° do material],
		'MAKTX'[Descrição do item],
		'WERKS'[CENTRO],
		'MENGE'[Qtd],
		'MEINS'[UM],
		'NETPR'[Preço Líquido],
		'NETDIS'[Desconto],
		'NETINS'[Seguro],
		'NETOTH'[Despesas],
		'NETFRE'[Frete],
		'CFOP_10'[CFOP],
		'MATORG'[Origem do Material],
		'MATUSE'[Origem do material],
		'STEUC'[NCM],
		'MATKL'[Grupo de mercadoria],
		'BASE_II'[Base de II],
		'OTHBAS_II'[Outra Base II],
		'EXCBAS_II'[Base Excl. II],
		'RATE_II'[Alíquota de II],
		'TAXVAL_II'[Valor de II],
		'BASE_ICMS'[Base de ICMS],
		'OTHBAS_ICMS'[Outra Base ICMS],
		'EXCBAS_ICMS'[Base Excl. ICMS],
		'RATE_ICMS'[Alíquota de ICMS],
		'TAXVAL_ICMS'[Valor de ICMS],
		'TAXLW1'[Direito Fiscal ICMS],
		'BASE_IPI'[Base de IPI],
		'OTHBAS_IPI'[Outra Base IPI],
		'EXCBAS_IPI'[Base Excl. IPI],
		'RATE_IPI'[Alíquota de IPI],
		'TAXVAL_IPI'[Valor de IPI],
		'TAXLW2'[Direito Fiscal IPI],
		'BASE_COFINS'[Base Cofins],
		'OTHBAS_COFINS'[Outra Base Cofins],
		'EXCBAS_COFINS'[Base Excl. Confins],
		'RATE_COFINS'[Alíquota de Cofins],
		'TAXVAL_COFINS'[Valor de Cofins],
		'TAXLW4'[Leis Cofins],
		'BASE_PIS'[Base PIS],
		'OTHBAS_PIS'[Outra Base PIS],
		'EXCBAS_PIS'[Base Excl. PIS],
		'RATE_PIS'[Alíquota de PIS],
		'TAXVAL_PIS'[Valor de PIS],
		'TAXLW5'[Leis PIS],
		'BASE_IBS'[Base IBS],
		'OTHBAS_IBS'[Outra Base IBS],
		'EXCBAS_IBS'[Base Excl. Confins],
		'RATE_IBS'[Alíquota de IBS],
		'TAXVAL_IBS'[Valor de IBS],
		'BASE_IBSM'[Base IBSM],
		'OTHBAS_IBSM'[Outra Base IBSM],
		'EXCBAS_IBSM'[Base Excl. Confins],
		'RATE_IBSM'[Alíquota de IBSM],
		'TAXVAL_IBSM'[Valor de IBSM],
		'BASE_CBS'[Base CBS],
		'OTHBAS_CBS'[Outra Base CBS],
		'EXCBAS_CBS'[Base Excl. Confins],
		'RATE_CBS'[Alíquota de CBS],
		'TAXVAL_CBS'[Valor de CBS],
		'TAXSITUATION'[TAXSITUATION],
		'CST'[CST],
		'CCLASSTRIB'[CCLASSTRIB],
		'NDI'[No DI],
		'NADICAO'[No Suplemento <nAdicao>],
		'NSEQADIC'[No Item Supl. <nSeqAdic>],
		'CFABRICANTE'[Cód. Fab. <cFabricante>],
		'VDESCDI'[Valor Red.Item Supl.<vDescDI>],
		'DRAW_BACK'[No Benefício DRAW_BACK],
		'NDI_ADIC'[No DI],
		'DDI'[Data Reg.(DI/DSI/DA)/tag <dDI>],
		'XLOCDESEMB'[Local Desemb. <xLocDesemb>],
		'UFDESEMB'[Reg. Fiscal Desemb <UFDesemb>],
		'DDESEMB'[Data Desemb <dDesemb>],
		'CEXPORTADOR'[Cód. Exportador <cExportador>],
		'COD_DOC_IMP'[Tipo Decl. Import.],
		'NUM_ACDRAW'[No Proc. Reembolso alfand.],
		'TRANSPORT_MODE'[Meio de transporte],
		'MARITIME_FREIGHT'[Frete marítimo],
		'INTERMEDIATE_MODE'[Modo intermediário],
		'CNPJ'[CNPJ do Comprador],
		'REGIO'[Região Terceiro],
		'PARVW'[NF Funçãoparc.],
		'PARID'[ID Parceiro],
		'TRATY'[TP Veículo Transporte],
		'TRAID'[ID veíc.transp.],
		'INCO1'[Incoterms],
		'INCO2'[Local],
		'VSTEL'[71],
		'ANZPK'[VOLUME],
		'SHPUNT'[73],
		'SHPMRK'[Código elem Exp],
		'SHPNUM'[Nº elemento exp],
		'NTGEW'[Peso líquido],
		'BRGEW'[Peso bruto],
		'MODFRETE'[Modalid. frete],
		'XPED'[Número do Pedido],
		'NITEMPED'[Linha do pedido]

union all
			select 
			[ITMTYP],
			[MATNR],
			[MAKTX],
			[WERKS],
			[MENGE],
			[MEINS],
			replace([NETPR],'.',','),
			[NETDIS],
			replace([NETINS],'.',','),
			[NETOTH],
			replace([NETFRE],'.',','),
			[CFOP_10],
			[MATORG],
			[MATUSE],
			[STEUC],
			[MATKL],
			[BASE_II],
			[OTHBAS_II],
			[EXCBAS_II],
			replace([RATE_II],'.',','),
			[TAXVAL_II],
			[BASE_ICMS],
			[OTHBAS_ICMS],
			[EXCBAS_ICMS],
			replace([RATE_ICMS],'.',','),
			--convert(varchar(20),[TAXVAL_ICMS]),
			FORMAT(CONVERT(NUMERIC(10,2), [TAXVAL_ICMS]), 'N2', 'pt-br'),			
			[TAXLW1],
			[BASE_IPI],
			[OTHBAS_IPI],
			[EXCBAS_IPI],
			replace([RATE_IPI],'.',','),
			[TAXVAL_IPI],
			[TAXLW2],
			[BASE_COFINS],
			[OTHBAS_COFINS],
			[EXCBAS_COFINS],
			replace([RATE_COFINS],'.',','),
			--convert(varchar(20),[TAXVAL_COFINS]),
			FORMAT(CONVERT(NUMERIC(10,2), [TAXVAL_COFINS]), 'N2', 'pt-br'),
			[TAXLW4],
			[BASE_PIS],
			[OTHBAS_PIS],
			[EXCBAS_PIS],
			replace([RATE_PIS],'.',','),
			--convert(varchar(20),[TAXVAL_PIS]),
			FORMAT(CONVERT(NUMERIC(10,2), [TAXVAL_PIS]), 'N2', 'pt-br'),
			[TAXLW5],
			[BASE_IBS],
			[OTHBAS_IBS],
			[EXCBAS_IBS],
			replace([RATE_IBS],'.',','),
			[TAXVAL_IBS],
			[BASE_IBSM],
			[OTHBAS_IBSM],
			[EXCBAS_IBSM],
			[RATE_IBSM],
			[TAXVAL_IBSM],
			[BASE_CBS],
			[OTHBAS_CBS],
			[EXCBAS_CBS],
			replace([RATE_CBS],'.',','),
			[TAXVAL_CBS],
			[TAXSITUATION],
			[CST],
			[CCLASSTRIB],
			[NDI],
			[NADICAO],
			[NSEQADIC],
			[CFABRICANTE],
			[VDESCDI],
			[DRAW_BACK],
			[NDI_ADIC],
			replace([DDI],'/',''),
			[XLOCDESEMB],
			[UFDESEMB],
			replace([DDESEMB],'/',''),
			[CEXPORTADOR],
			[COD_DOC_IMP],
			[NUM_ACDRAW],
			[TRANSPORT_MODE],
			--convert(varchar(20),[MARITIME_FREIGHT]),
			FORMAT(CONVERT(NUMERIC(10,2), [MARITIME_FREIGHT]), 'N2', 'pt-br'),
			[INTERMEDIATE_MODE],
			[CNPJ],
			[REGIO],
			[PARVW],
			[PARID],
			[TRATY],
			[TRAID],
			[INCO1],
			[INCO2],
			[VSTEL],
			[ANZPK],
			[SHPUNT],
			[SHPMRK],
			[SHPNUM],
			[NTGEW],
			[BRGEW],
			[MODFRETE],
			[XPED],
			[NITEMPED]							

		from @TabelaHeader
GO
