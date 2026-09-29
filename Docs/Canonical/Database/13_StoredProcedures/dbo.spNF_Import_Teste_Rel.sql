SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from Custo_Cliente where Num_Proc = 'IMEXO202008017BR'
--	select * from vwcta_cte where Num_Proc_hia = 'IMEXO202008017BR'
--	select * from nota_cliente where  Num_Proc = 'IMEXO202008017BR'
--	select Vlr_Frete,* from nota_fiscal_cliente_det where  id_nf = '1026' and Cd_Cliente = 'P000029209'
	
--	select * from Custo_Cliente where Num_Proc = 'IMEXO202008024BR'
--	select * from vwcta_cte where Num_Proc_hia = 'IMEXO202008024BR'
--	select * from nota_cliente where  Num_Proc = 'IMEXO202008024BR'
--	select Vlr_Frete,* from nota_fiscal_cliente_det where  id_nf = '1027' and Cd_Cliente = 'P000029209'
	
	--[spNF_Import_Teste_Rel] 'IMEXO202405059BR'
	--select 
CREATE procedure [dbo].[spNF_Import_Teste_Rel] --[spNF_Import_teste_Rel]'IMEXO202512041BR'

	@Num_Proc varchar(16)
	
as




select 
--HOU.Num_Proc JOB,
--(Case when LO.Cd_Pais = 'US' and HOU.Cd_DstFinal in ('SSZ','NVT','ITJ','SAP') then 
--	'0102'
--		Else 
--			(Case when LO.Cd_Pais = 'SG' and HOU.Cd_DstFinal like '%' then 
--				'1796'
--					Else 
--						(Case when LO.Cd_Pais = 'US' and HOU.Cd_DstFinal = 'GUR' then 
--							'0152'
--								Else 
--									(Case when LO.Cd_Pais = 'GB' and HOU.Cd_DstFinal in ('SSZ','NVT') then --Beatriz 27/10/2021 ticket 100-241314
--										'2149'
--											Else
--												(Case when LO.Cd_Pais = 'BE' and HOU.Cd_DstFinal in ('SSZ','NVT') then --Beatriz 27/10/2021 ticket 100-241314
--													'2149'
--														end)end)end)end)end) [Codigo do Parceiro],
--SUBSTRING(PL.CD_PLANTA, 2, LEN(PL.CD_PLANTA) - 1) as [Codigo do Parceiro], -- comentado devido ao minor 100-502644 - kaique 26/02/25
PL.Cd_Planta as [Codigo do Parceiro],
PC.cd_Proc_Cliente [Numero do Material],
CONVERT(varchar(20),CAST(NFD.Peso_Liquido as Decimal(18,3))) [Quantidade do material],


--CASE 
--    WHEN LCP.Cd_Local IN ('NVT', 'IOA', 'IBB') THEN
--        REPLACE(FORMAT(CAST (NFD.VL_BASE_II / NFD.Peso_Liquido AS decimal(18,6)), 'N6', 'pt-BR'), ',', '')
--    ELSE
--        REPLACE(FORMAT(CAST(NFD.VL_BASE_COFINS / NFD.Peso_Liquido as Decimal(18,6)), 'N6', 'pt-BR'), ',', '')
--END AS [Preco Unitario],

					--Kaique 10/07/24 minor 100-458787
(Case when G.Cd_Pes_Grupo = 'P17774'
	then
		CONVERT(varchar(20),CAST(NFD.VL_BASE_II / NFD.Peso_Liquido as Decimal(18,6)))
			Else
				CONVERT(varchar(20),CAST(NFD.VL_BASE_COFINS / NFD.Peso_Liquido as Decimal(18,6)))end) [Preco Unitario],
					 --100-458787

--CONVERT(varchar(20),CAST(NFD.VL_BASE_COFINS / NFD.Quantidade as Decimal(18,6))) [Preco Unitario],
--NFD.VL_BASE_COFINS / NFD.Peso_Liquido [Preco Unitario],
--CONVERT(varchar(30),CAST(NFD.VL_IMPOSTO_PIS + NFD.VL_IMPOSTO_COFINS + Vlr_Siscomex as Decimal(18,2))) [Despesas Acessorias],
CONVERT(varchar(30),CAST(dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%AFRMM%')+ NFD.Vlr_Siscomex as Decimal(18,2))) [Despesas Acessorias], -- alterado pelo ticket 100-502644 
CONVERT(varchar(30),CAST(NFD.VL_BASE_COFINS as Decimal(18,2))) [Base Cofins],
CONVERT(varchar(30),CAST(NFD.VL_ALIQ_COFINS as Decimal(18,2))) [Percentual Cofins],
--CONVERT(varchar(30),CAST(NFD.VL_BASE_ICMS as Decimal(18,2))) [Base ICMS],
--CONVERT(varchar(30),CAST('0.00' as Decimal(18,2))) [Base ICMS],
CONVERT(varchar(30),CAST(NFD.VL_TRIBUTAVEL_ICMS as Decimal(18,2))) [Base ICMS],
'0.00'															   [Base ICMS Excluida], --Kaique 14/11/24 minor 100-458787
CONVERT(varchar(30),CAST(NFD.ALIQ_ICMS as Decimal(18,2))) [Percentual ICMS],
CONVERT(varchar(30),CAST(NFD.VL_BASE_II as Decimal(18,2))) [Base II],
CONVERT(varchar(30),CAST(NFD.ALIQ_II as Decimal(18,2))) [Percentual II],
CONVERT(varchar(30),CAST(NFD.VL_II as Decimal(18,2))) [Valor II],
CONVERT(varchar(30),CAST(NFD.VL_BASE_IPI as Decimal(18,2))) [Base IPI],
CONVERT(varchar(30),CAST(NFD.ALIQ_IPI as Decimal(18,2))) [Percentual IPI],
CONVERT(varchar(30),CAST(NFD.VL_BASE_PIS as Decimal(18,2))) [Base PIS],
CONVERT(varchar(30),CAST(NFD.VL_ALIQ_PIS as Decimal(18,2))) [Percentual PIS],
case 
    when exists (select 1 from vwPO_ALL where Num_Proc = @Num_Proc AND ID_DC = 237) THEN 
	(select Numero_PO from vwPO_ALL where Num_Proc = @Num_Proc AND ID_DC = 237) else dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc, '5')
end as [Numero da DI],
--					Kaique 10/07/24 minor 100-458787
--(Case when LCP.Cd_Local = 'SSZ' then
--	CONVERT(Varchar, dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'5'),101)
--		Else
--			CONVERT(Varchar, dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'5'),103)end) as [Data da DI], -- comentado devido ao minor 100-502644 - kaique 26/02/25
--					 100-458787

case 
    when exists (select 1 from vwPO_ALL where Num_Proc = @Num_Proc AND ID_DC = 237) THEN 
	(select convert(varchar (10), Data_PO, 101) from vwPO_ALL where Num_Proc = @Num_Proc AND ID_DC = 237) else
CONVERT(Varchar, dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,'5'),101) end as [Data da DI],


LCP.Nome_Local [Local de Desembaraco],

(Case when LCP.Cd_Local = 'SSZ' then
'SP'
	Else
		(Case when LCP.Cd_Local = 'GRU' then
		'SP'
			Else
				(Case when LCP.Cd_Local = 'VCP' then
				'SP'
					Else
						(Case when LCP.Cd_Local in ('NVT','ITJ','IOA') then
						'SC'
							Else
								(Case when LCP.Cd_Local in ('SAP','REC') then
								'PE'
								end)end)end)end)end) [UF Desembaraço],
--TP4.Dt_Conclusao [Data do Desembaraco],

--					Kaique 10/07/24 minor:100-458787
--(Case when LCP.Cd_Local = 'SSZ' 
--	then
--		CONVERT(VARCHAR, TP4.DT_Conclusao, 101)
--			Else
--				CONVERT(VARCHAR, TP4.DT_Conclusao, 103)end) as [Data do Desembaraco],
--					 100-458787
--CONVERT(VARCHAR, TP4.DT_Conclusao, 101) as [Data do Desembaraco], -- comentado devido ao minor 100-502644 - kaique 26/02/25
CONVERT(VARCHAR, TP4.DT_Conclusao, 101) as [Data do Desembaraco],
--(Case when LO.Cd_Pais = 'US' and HOU.Cd_DstFinal in ('SSZ','NVT','ITJ','SAP') then 
--	'0102'
--		Else 
--			(Case when LO.Cd_Pais = 'SG' and HOU.Cd_DstFinal like '%' then 
--			'1796'
--				Else 
--					(Case when LO.Cd_Pais = 'US' and HOU.Cd_DstFinal = 'GUR' then 
--						'0152'
--							end)end)end) [Codigo do Parceiro],
--SUBSTRING(PL.CD_PLANTA, 2, LEN(PL.CD_PLANTA) - 1) as [Codigo do Parceiro],-- comentado devido ao minor 100-502644 - kaique 26/02/25
PL.CD_PLANTA as [Codigo do Parceiro],
(Case when HOU.Modal = 'Ocean Import' then
	'1'
		Else
			(Case when HOU.Modal = 'Air Import' then
				'4'
					Else
						(Case when HOU.Modal = 'Other Import' then
							'7'
								End)End)End) [Meio de Transporte],
								
--					Kaique 10/07/24 minor 100-458787
--(Case when LCP.Cd_Local in ('SSZ','NVT','IOA','IBB')  
--	then
--		'0.00'
--			Else
				--CONVERT(varchar(30),CAST(dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%AFRMM%') as Decimal(18,2)))[Adicional de Frete para Renovação da Marinha Mercante], -- comentado devido ao minor 100-502644 - kaique 26/02/25
--					 100-458787
'0.00' [Adicional de Frete para Renovação da Marinha Mercante],
--CONVERT(varchar(30),CAST(dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%AFRMM%') as Decimal(18,2))) [Adicional de Frete para Renovação da Marinha Mercante],
case 
    when exists (select 1 from vwPO_ALL where Num_Proc = @Num_Proc AND ID_DC = 237) THEN 
	(select Numero_PO from vwPO_ALL where Num_Proc = @Num_Proc AND ID_DC = 237) else dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc, '5')
end as[Numero da DI],
--(Case when LO.Cd_Pais = 'US' and HOU.Cd_DstFinal in ('SSZ','NVT','ITJ','SAP') then 
--	'0102'
--		Else 
--			(Case when LO.Cd_Pais = 'SG' and HOU.Cd_DstFinal like '%' then 
--			'1796'
--				Else 
--					(Case when LO.Cd_Pais = 'US' and HOU.Cd_DstFinal = 'GUR' then 
--						'0152'
--							end)end)end) [Codigo do Parceiro],
--SUBSTRING(PL.CD_PLANTA, 2, LEN(PL.CD_PLANTA) - 1) as [Codigo do Parceiro],-- comentado devido ao minor 100-502644 - kaique 26/02/25
PL.CD_PLANTA [Codigo do Parceiro],
--HOU.vessel [Nome do Navio],
rtrim (HOU.vessel) as [Nome do Navio], --					Kaique 10/07/24 minor 100-458787
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'1')	[Ordem SAP],
--STUFF(STUFF(STUFF(STUFF(P.Num_CPF_CNPJ, 3, 0, '.'), 7, 0, '.'), 11, 0, '/'), 16, 0, '-') AS [CNPJ],  --					Kaique 10/07/24 minor 100-458787
replace(replace(replace((P.Num_CPF_CNPJ),'.',''),'/',''),'-','') [CNPJ],  --					Kaique 10/07/24 minor 100-458787
'0.00' [ICMS Antecipado],

--(case when NFD.CIF IS NULL  then
--	CONVERT(varchar(30),CAST(0 + NFD.VL_IPI  + NFD.VL_IMPOSTO_PIS + NFD.VL_IMPOSTO_COFINS + NFD.Vlr_Siscomex as Decimal(18,2)))
--Else
--	(Case when NFD.CIF is not null then
--		CONVERT(varchar(30),CAST(NFD.CIF + NFD.VL_IPI  + NFD.VL_IMPOSTO_PIS + NFD.VL_IMPOSTO_COFINS + NFD.Vlr_Siscomex as Decimal(18,2))) end)end) [Valor Total NF],

--CAST(NFD.VL_IMPOSTO_PIS + NFD.VL_IMPOSTO_COFINS + Vlr_Siscomex as Decimal(18,2)) + CAST(NFD.VL_BASE_II as Decimal(18,2)) +
--		CAST(NFD.VL_BASE_IPI as Decimal(18,2)) * CAST(NFD.ALIQ_IPI as Decimal(18,2))
--			as [Valor Total NF] --Beatriz 19/10/21  ticket 100-241314

--CONVERT(varchar(30),CAST(NFD.VL_IMPOSTO_PIS + NFD.VL_IMPOSTO_COFINS + Vlr_Siscomex as Decimal(18,2))) 
--	+ CAST(NFD.VL_Base_II as Decimal(18,2))
--	+ 	CAST(NFD.VL_IPI as Decimal(18,2))
--			as [Valor Total NF] --Beatriz 19/10/21  ticket 100-241314

CONVERT(varchar(30),CAST(NFD.VL_TRIBUTAVEL_ICMS as Decimal(18,2))) 
as [Valor Total NF] --					Kaique 10/07/24 minor 100-458787

      ,REPLACE(CONVERT(VARCHAR(30), CAST(CP31.Campo_Dados AS DECIMAL(18,4))), '.', ',') as [TAXA CAMBIAL]
		--,CONVERT(varchar(30),CAST(CP31.Campo_Dados as Decimal(18,6))) [TAXA CAMBIAL]
		--,CONVERT(varchar(30),CAST(dbo.fBusca_Custo(HOU.Num_Proc,PS.cd_pedido, PS.cd_produto,'%FRETE%') as Decimal(18,2))) [FRETE]
	--	,CONVERT(varchar(30),CAST(NFD.Vlr_Frete as Decimal(18,2))) [FRETE]-- comentado devido ao minor 100-502644 - kaique 26/02/25
,'0.00' [FRETE]
--,NFD.Vlr_Frete [FRETE]
,NFD.NCM
--,CAST(NFD.VL_BASE_IPI as Decimal(18,2)) * CAST(NFD.ALIQ_IPI as Decimal(18,2)) as [Valor IPI] --Beatriz 19/10/21  ticket 100-241314
,'' [Seguro]
,'000' [CBS/IBS Tax Situation]
,CONVERT(
    varchar(30),
    CAST(
        COALESCE(NFD.VL_BASE_PIS, 0)
      + COALESCE(dbo.fBusca_Custo(HOU.Num_Proc, PS.cd_pedido, PS.cd_produto, '%AFRMM%'), 0)
      + COALESCE(dbo.fBusca_Custo(HOU.Num_Proc, PS.cd_pedido, PS.cd_produto, '%Taxas Siscomex%'), 0)
      + COALESCE(NFD.VL_II, 0)
    AS decimal(18,2))) [Base CBS]
,'0.9' [Percentual CBS]
,CONVERT(
    varchar(30),
    CAST(
        COALESCE(NFD.VL_BASE_PIS, 0)
      + COALESCE(dbo.fBusca_Custo(HOU.Num_Proc, PS.cd_pedido, PS.cd_produto, '%AFRMM%'), 0)
      + COALESCE(dbo.fBusca_Custo(HOU.Num_Proc, PS.cd_pedido, PS.cd_produto, '%Taxas Siscomex%'), 0)
      + COALESCE(NFD.VL_II, 0)
    AS decimal(18,2))) [Base IBS]
,'0.10' [Percentual IBS]

from vwhouse_imp HOU					with(nolock)
join localidade LO					with(nolock) on HOU.Cd_Org = LO.Cd_Local
join localidade LD					with(nolock) on HOU.Cd_Dst = LD.Cd_Local
join Pedido_Ship PS				with(nolock) on HOU.num_proc = PS.Num_Proc
join Produto_Cliente PC			with(nolock) on PS.cd_produto = PC.cd_prod 
--cadu retirei os left joins
join Nota_Cliente NC				with(nolock) on HOU.num_proc = NC.Num_Proc --Se tivesse algum caso cancelado estava trazendo valor incorreto --Join incluido --Cadu 15/04/2024
join Nota_Fiscal_Cliente_Det NFD	with(nolock) on PS.cd_produto = NFD.Cd_Produto and PS.cd_pedido = NFD.Cd_Pedido and NFD.ID_NF = NC.ID_NF and nfd.Cd_Cliente = nc.CD_Cliente --Ticket 100-447748 --incluido id_nf e cd_cliente --Join incluido --Cadu 15/04/2024


--Left join Nota_Fiscal_Cliente_Det NFD	with(nolock) on PS.cd_produto = NFD.Cd_Produto and PS.cd_pedido = NFD.Cd_Pedido
Left join Campo_Processo CP				with(nolock) on HOU.Num_Proc = CP.Num_Proc and CP.Id_Campo = '25'
Left join Localidade LCP				with(nolock) on CP.Campo_Dados = LCP.Cd_Local
Left Join Tarefas_Processos TP4			with(nolock) on HOU.Num_Proc = TP4.Num_Proc and TP4.ID_Task = '4'
Left Join Pessoa P						with(nolock) on HOU.Cd_Consig = P.Cd_Pes
Left Join Pessoa_LLP PL					with(nolock) on HOU.Cd_export = PL.Cd_Pes
Left join Campo_Processo CP31			with(nolock) on HOU.Num_Proc = CP31.Num_Proc and CP31.Id_Campo = '31'
left join Grupo	G						with(nolock) on P.Cd_Pes = g.Cd_Pes_Grupo
where	
	HOU.Num_Proc = @Num_Proc
	--and TP4.Dt_Conclusao is not null


	
GO
