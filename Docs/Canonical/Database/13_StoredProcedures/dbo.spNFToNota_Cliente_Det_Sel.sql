SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spNFToNota_Cliente_Det_Sel '88028'
--25-09-2018 incluido o charindex para qdo vier a mensagem em outro padrão
CREATE Procedure [dbo].[spNFToNota_Cliente_Det_Sel]--18894
		@id_danfe int
as

select distinct
	PE.Apelido Cliente,
	P.Num_Pedido Pedido,
	cProd Produto,	 
	(Case when SUBSTRING(DB.Num_Proc,2,1) = 'M' then '2' else
		(Case when SUBSTRING(DB.Num_Proc,2,1) = 'O' then '1' else
			(Case when SUBSTRING(DB.Num_Proc,2,1) = 'A' then '3'
	end)end)end) Modal,
	NCM,	
	qCOM Quantidade,	
	vUNCom Vlr_Item,
	DIPI.vBC Vlr_Total_Item,	
	DIP.vFrete vlr_frete,
	DT.vSeg Vlr_Seguro,
	DIP.vOutrasDesp Vlr_Outras_Despesas,
	DII.pImposto ALIQ_II,
	DII.vImposto VLr_II,	
	DIPI.pImposto ALIQ_IPI,
	DIPI.vBC VLr_BASE_IPI,	
	DIPI.vBC VLr_TRIBUTAVEL_IPI,
	DIPI.vImposto VLr_IPI, 
	PIS.pImposto VLr_ALIQ_PIS,
	PIS.vBC VLr_BASE_PIS,
	PIS.vImposto VLr_IMPOSTO_PIS,
	
	Cofins.pImposto VLr_ALIQ_COFINS,
	Cofins.vBC VLr_BASE_COFINS,
	Cofins.vImposto VLr_IMPOSTO_COFINS,	
	
	ICMS.pImposto ALIQ_ICMS,
	ICMS.vBC VLr_BASE_ICMS,	
	ICMS.vImposto VLr_ICMS,
	ICMS.vBC VLr_TRIBUTAVEL_ICMS,
	DIPI.vBC Vlr_Total_NF,
	DV.PesoL Peso_Liquido,
	DV.PesoB Peso_Bruto,
	100 SITT,
	(case when CHARINDEX('Imp. Importacao R$ ................', infCompl) > 0 then
		Ltrim(rtrim(replace(substring(infCompl,CHARINDEX('TAXA SISCOMEX......................', infCompl),CHARINDEX('TAXA SISCOMEX......................', infCompl)-CHARINDEX('Imp. Importacao R$ ................', infCompl)),'TAXA SISCOMEX......................','')))
	else
		Ltrim(rtrim(replace(substring(infCompl,CHARINDEX('TAXA SISCOMEX......................', infCompl),CHARINDEX('TAXA SISCOMEX......................', infCompl)-CHARINDEX(' VALOR DESPESAS ACESSORIAS INCLUINDO O II:', infCompl) +8),'TAXA SISCOMEX......................','')))
	end)Vlr_Siscomex,
	--Ltrim(rtrim(replace(substring(infCompl,CHARINDEX('TAXA SISCOMEX......................', infCompl),CHARINDEX('TAXA SISCOMEX......................', infCompl)-CHARINDEX('Imp. Importacao R$ ................', infCompl)),'TAXA SISCOMEX......................',''))) Vlr_Siscomex,
	DII.vBC VL_BASE_II,
	DB.Num_Proc,
	DIP.id_Item,
	null ACRESCIMOS ,
	DII.vBC CIF,
	null FOB,
	0 FreteCollect
	
from ATL_BR.dbo.danfe_base DB with(nolock)
	Join ATL_BR.dbo.Danfe_Cia DC with(nolock) on DC.id_danfe=DB.id_danfe and Tipo='E'
	join dbo.vwClienteALLJOBS A with(nolock) on A.Num_Proc = DB.Num_Proc
	join dbo.Pedido_Ship PS with(nolock) on PS.num_proc = DB.Num_Proc
	join dbo.Pedido P with(nolock) on PS.cd_pedido = P.cd_pedido
	join dbo.Pessoa PE with(nolock) on PE.Cd_Pes = A.cd_cliente
	Join ATL_BR.dbo.Danfe_Item_Produto DIP with(nolock) on DIP.id_danfe=DB.id_danfe
	Join ATL_BR.dbo.Danfe_Totais DT with(nolock) on DT.id_danfe=DB.id_danfe
	Left Join ATL_BR.dbo.Danfe_Item_Impostos DII with(nolock) on DII.id_danfe=DIP.id_danfe and DIP.id_item=DII.id_Item and DII.cImpostos='II'
	Left Join ATL_BR.dbo.Danfe_Item_Impostos DIPI with(nolock) on DIP.id_danfe=DIPI.id_danfe and DIP.id_item=DIPI.id_Item and DIPI.cImpostos='IPI'
	Left Join ATL_BR.dbo.Danfe_Item_Impostos PIS with(nolock) on DIP.id_danfe=PIS.id_danfe and DIP.id_item=PIS.id_Item and PIS.cImpostos='PIS'
	Left Join ATL_BR.dbo.Danfe_Item_Impostos COFINS with(nolock) on DIP.id_danfe=COFINS.id_danfe and DIP.id_item=COFINS.id_Item and COFINS.cImpostos='COFINS'
	Left Join ATL_BR.dbo.Danfe_Item_Impostos ICMS with(nolock) on DIP.id_danfe=ICMS.id_danfe and DIP.id_item=ICMS.id_Item and ICMS.cImpostos='ICMS'
	Left join ATL_BR.dbo.Danfe_Transp_Vol DV with(nolock) on DV.id_danfe=DB.id_danfe
where 
	DB.id_danfe=@id_danfe

--select
--	PE.Apelido Cliente,
--	P.Num_Pedido Pedido,
--	cProd Produto,	 
--	(Case when SUBSTRING(DB.Num_Proc,2,1) = 'M' then '2' else
--		(Case when SUBSTRING(DB.Num_Proc,2,1) = 'O' then '1' else
--			(Case when SUBSTRING(DB.Num_Proc,2,1) = 'A' then '3'
--	end)end)end) Modal,
--	NCM,	
--	qCOM Quantidade,	
--	vUNCom Vlr_Item,
--	DIPI.vBC Vlr_Total_Item,	
--	DIP.vFrete vlr_frete,
--	DT.vSeg Vlr_Seguro,
--	DIP.vOutrasDesp Vlr_Outras_Despesas,
--	DII.pImposto ALIQ_II,
--	DII.vImposto VLr_II,	
--	DIPI.pImposto ALIQ_IPI,
--	DIPI.vBC VLr_BASE_IPI,	
--	DIPI.vBC VLr_TRIBUTAVEL_IPI,
--	DIPI.vImposto VLr_IPI, 
--	PIS.pImposto VLr_ALIQ_PIS,
--	PIS.vBC VLr_BASE_PIS,
--	PIS.vImposto VLr_IMPOSTO_PIS,
	
--	Cofins.pImposto VLr_ALIQ_COFINS,
--	Cofins.vBC VLr_BASE_COFINS,
--	Cofins.vImposto VLr_IMPOSTO_COFINS,	
	
--	ICMS.pImposto ALIQ_ICMS,
--	ICMS.vBC VLr_BASE_ICMS,	
--	ICMS.vImposto VLr_ICMS,
--	ICMS.vBC VLr_TRIBUTAVEL_ICMS,
--	DIPI.vBC Vlr_Total_NF,
--	DV.PesoL Peso_Liquido,
--	DV.PesoB Peso_Bruto,
--	100 SITT,
--	null Vlr_Siscomex ,
--	DII.vBC VL_BASE_II,
--	DB.Num_Proc,
--	DIP.id_Item,
--	null ACRESCIMOS ,
--	DII.vBC CIF,
--	null FOB,
--	0 FreteCollect
--from ATL_BR.dbo.danfe_base DB
--	Join ATL_BR.dbo.Danfe_Cia DC on DC.id_danfe=DB.id_danfe and Tipo='E'
--	join dbo.vwClienteALLJOBS A on A.Num_Proc = DB.Num_Proc
--	join dbo.Pedido_Ship PS on PS.num_proc = DB.Num_Proc
--	join dbo.Pedido P on PS.cd_pedido = P.cd_pedido
--	join dbo.Pessoa PE on PE.Cd_Pes = A.cd_cliente
--	Join ATL_BR.dbo.Danfe_Item_Produto DIP on DIP.id_danfe=DB.id_danfe
--	Join ATL_BR.dbo.Danfe_Totais DT on DT.id_danfe=DB.id_danfe
--	Left Join ATL_BR.dbo.Danfe_Item_Impostos DII on DII.id_danfe=DIP.id_danfe and DIP.id_item=DII.id_Item and DII.cImpostos='II'
--	Left Join ATL_BR.dbo.Danfe_Item_Impostos DIPI on DIP.id_danfe=DIPI.id_danfe and DIP.id_item=DIPI.id_Item and DIPI.cImpostos='IPI'
--	Left Join ATL_BR.dbo.Danfe_Item_Impostos PIS on DIP.id_danfe=PIS.id_danfe and DIP.id_item=PIS.id_Item and PIS.cImpostos='PIS'
--	Left Join ATL_BR.dbo.Danfe_Item_Impostos COFINS on DIP.id_danfe=COFINS.id_danfe and DIP.id_item=COFINS.id_Item and COFINS.cImpostos='COFINS'
--	Left Join ATL_BR.dbo.Danfe_Item_Impostos ICMS on DIP.id_danfe=ICMS.id_danfe and DIP.id_item=ICMS.id_Item and ICMS.cImpostos='ICMS'
--	Left join ATL_BR.dbo.Danfe_Transp_Vol DV on DV.id_danfe=DB.id_danfe
--where 
--	DB.id_danfe=@id_danfe








GO
