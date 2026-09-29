SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
spFMC_IMP06_Sel 'IMFMC201201017BR','3993','Cancel'
spFMC_IMP06_Sel 'IMFMC201110036BR','3870', 'Cancel'

spFMC_IMP06_Sel 'IMFMC201105048BR','3390', 'itens'
spFMC_IMP06_Sel 'IMFMC201105048BR','3390', 'impostos'
spFMC_IMP06_Sel 'IMFMC201110036BR','3870', 'sped'

select * from ATL_BR.dbo.Danfe_Transp_Vol where id_danfe=9661

*/

CREATE Procedure [dbo].[spFMC_IMP06_Sel]
	@NUM_PROC	VARCHAR(16),
	@NF			VARCHAR(10),
--	@LctoSAP	datetime,
	@Tipo		varchar(15)
as
	if @Tipo = 'Cabecalho' OR @Tipo = 'Cancel'
		Begin
			select NF.id_danfe,
				NF.dEmis,
--				@LctoSAP LctoSAP, -- NOVA DEFINIÇÃO (Peso_Liquido > 0) >> Dt_envio, onde o ID_Evento=’I’ ELSE Dt_envio, onde o ID_Evento=’F’ Tabela: Atlantis.dbo.FMC_Miro)
				(case 
					when DTV.PesoL > 0 then max(MiroI.Dt_Envio)
					else max(MiroF.Dt_Envio)
				end) LctoSAP,
				NF.nNF,
				Serie,
				(select top 1 nDI from ATL_BR.dbo.Danfe_Item_Prod_DI where Id_Danfe = NF.Id_Danfe) nDI,
				Max(P.Num_pedido) PO,
				isnull(DTV.PesoL,0) pesoL,
				isnull(DTV.PesoB,0) pesoB,
				null Cod_Expedicao,
				null Num_elemento,
				null Num_Log,
				right(NF.cNF,8) Num_Aleatorio,
				cDV Num_Digito_Contr,
				NF.Num_Proc,
				(select top 1 Cd_Vendor from Atlantis.dbo.Pessoa_LLP where cd_pes = P.cd_seller ) ID_Fornecedor,
--				'2011-11-11 11:11' Dt_Envio,
				getdate() Dt_Ins,
				(case when @Tipo = 'Cancel' then '1' else 0 end) Cancel,
				'2.00' strVersao,
				CAPA.str_Protocolo nProt,
				CAPA.dt_Protocolo dtProtocolo,
				'1' tpEmis,
				(case when DTV.PesoL > 0 then MiroI.Dt_Envio else MiroF.Dt_Envio end) dtMiro
			from 
				ATL_BR.dbo.Danfe_Base NF
				Join ATL_BR.dbo.Danfe_Item_Produto NFD ON NFD.ID_Danfe=NF.ID_Danfe
				Join ATL_BR.dbo.Danfe_Transp_Vol DTV on DTV.Id_Danfe = NF.Id_Danfe
				Join Produto_Cliente PC on right(PC.cd_proc_Cliente,8) COLLATE Latin1_General_CI_AI = right(NFD.cProd,8) and cd_Cliente = '362'
				Join Pedido_Ship PS on PS.Cd_Produto=PC.Cd_Prod and PS.Num_Proc=@NUM_PROC
				Join Pedido P on P.Cd_Pedido=PS.Cd_Pedido
				Join ATL_WEB.dbo.Capa_NF CAPA on CAPA.str_CodigoProcesso = @Num_Proc and str_NF = @NF
				Left Join FMC_Miro MiroI on MiroI.fatura_pc = @NUM_PROC and MiroI.ID_Evento = 'I'
				Left Join FMC_Miro MiroF on MiroF.fatura_pc = @NUM_PROC and MiroF.ID_Evento = 'F'
			where
				NF.Num_Proc like @NUM_PROC and NF.nNF=@NF and NF.dtEnvio is null
				and ((DTV.PesoL > 0 and MiroI.Dt_Envio is NOT null) OR (isnull(DTV.PesoL,0) = 0 and MiroF.Dt_Envio is NOT null) OR @Tipo = 'Cancel')
			group by
				NF.dEmis,
				NF.nNF,
				NF.Serie,
				DTV.PesoL,
				DTV.PesoB,
				NF.cNF,
				cDV,
				NF.Num_Proc,
				P.cd_seller,
				NF.Id_Danfe,
				str_Protocolo,
				dt_Protocolo,
				P.Cd_Buyer,
				MiroI.Dt_Envio, MiroF.Dt_Envio
		End

	else IF @Tipo = 'Itens'
		Begin
			select DISTINCT 
				right(PS.Item,5) Item,
				cProd Material,
				(select top 1 cd_planta from Atlantis.dbo.pessoa_llp where cd_pes=P.Cd_Buyer) Centro_Custo,
				sum(NFD.qCom) * Atlantis.dbo.fBuscaPorcentagem_CdPedido(@Num_Proc,PS.Item,PS.Cd_Pedido) Qtd,
				sum(NFD.vProd) * Atlantis.dbo.fBuscaPorcentagem_CdPedido(@Num_Proc,PS.Item,PS.Cd_Pedido) Vlr_Item, --o nome do campo na tab está errado "peso_liquido" o correto seria Vlr_Item
				NFD.NCM,
				'IC0' DirFiscalICMS,
				'IP0' DirFiscalIPI,
				'ZC0' LeiCofins,
				'ZP0' LeiPais,
				NFD.CFOP,
				(NFT.vOutros)  * Atlantis.dbo.fBuscaPorcentagem_CdPedido(@Num_Proc,PS.Item,PS.Cd_Pedido) Valor,
				'1' + NFI.CST CST
			from
				ATL_BR.dbo.Danfe_Base NF
				Join ATL_BR.dbo.Danfe_Item_Produto NFD ON NFD.ID_Danfe=NF.ID_Danfe
				Join ATL_BR.dbo.Danfe_Totais NFT ON NFT.ID_Danfe=NF.ID_Danfe
				Join ATL_BR.dbo.Danfe_Item_Impostos NFI ON NFI.ID_Danfe=NF.ID_Danfe and NFI.ID_Item = NFD.ID_Item and NFI.cImpostos='ICMS'
				Join Produto_Cliente PC on right(PC.cd_proc_Cliente,8) COLLATE Latin1_General_CI_AI = right(NFD.cProd,8) and cd_Cliente = '362'
				Join Pedido_Ship PS on PS.Cd_Produto=PC.Cd_Prod and PS.Num_Proc=@NUM_PROC
				Join Pedido P on P.Cd_Pedido=PS.Cd_Pedido
			where
				NF.Num_Proc like @NUM_PROC and NF.dtEnvio is null and nNF=@NF
			group by
				PS.Item,cProd,NFD.NCM,NFD.CFOP,NFI.CST,P.Cd_Buyer,PS.Cd_Pedido ,NFT.vOutros
		End
	Else IF @Tipo = 'Impostos'
		Begin
			select DISTINCT
				right(PS.Item,5) Item, TI.cd_FMC, sum(isnull(NFI.vBC,0)) * Atlantis.dbo.fBuscaPorcentagem_CdPedido(@Num_Proc,PS.Item,PS.Cd_Pedido) Outra_Base, sum(isnull(NFI.vImposto,0)) * Atlantis.dbo.fBuscaPorcentagem_CdPedido(@Num_Proc,PS.Item,PS.Cd_Pedido) Vlr_Despesa
			from
				ATL_BR.dbo.Danfe_Base NF
				Join ATL_BR.dbo.Danfe_Item_Produto NFD ON NFD.ID_Danfe=NF.ID_Danfe
				Join ATL_BR.dbo.Danfe_Totais NFT ON NFT.ID_Danfe=NF.ID_Danfe
				Join ATL_BR.dbo.Danfe_Item_Impostos NFI ON NFI.ID_Danfe=NF.ID_Danfe and NFI.ID_Item = NFD.ID_Item
				Join ATL_BR.dbo.Tipo_Impostos TI on TI.cImpostos COLLATE Latin1_General_CI_AI = NFI.cImpostos
				Join Produto_Cliente PC on right(PC.cd_proc_Cliente,8) COLLATE Latin1_General_CI_AI = right(NFD.cProd,8) and cd_Cliente = '362'
				Join Pedido_Ship PS on PS.Cd_Produto=PC.Cd_Prod and PS.Num_Proc=@NUM_PROC
				Join Pedido P on P.Cd_Pedido=PS.Cd_Pedido
			where
				NF.Num_Proc like @NUM_PROC and NF.dtEnvio is null and nNF=@NF --and NFI.cImpostos <> 'II' 
			group by
				PS.Item, TI.cd_FMC, PS.Cd_Pedido
		End

	Else IF @Tipo = 'SPED'
		Begin
			select distinct 'FMC' cod, --pp.cd_vendor,cd_planta,
				(case when right(DC.CNPJ,5) = '00430' then 'SFBZ' else 'AABZ' end) Matriz,
				(case 
					when right(DC.CNPJ,5) = '00198' then '7550'
					when right(DC.CNPJ,5) = '00279' then '7551'
					when right(DC.CNPJ,5) = '00350' then '7558'
					when right(DC.CNPJ,5) = '00430' then '7571'
					when right(DC.CNPJ,5) = '00511' then '7553'
					when right(DC.CNPJ,5) = '00600' then '7552'
					when right(DC.CNPJ,5) = '00783' then '7556'
					when right(DC.CNPJ,5) = '00864' then '7557'
					when right(DC.CNPJ,5) = '01089' then '7559'
					when right(DC.CNPJ,5) = '01160' then '7560'
					when right(DC.CNPJ,5) = '01240' then '7561'
					when right(DC.CNPJ,5) = '01402' then '7564'
					when right(DC.CNPJ,5) = '01593' then '7565'
					when right(DC.CNPJ,5) = '01674' then '7563'
					when right(DC.CNPJ,5) = '01755' then '7562'
					when right(DC.CNPJ,5) = '01836' then '7566'
					when right(DC.CNPJ,5) = '01917' then '7567'
					when right(DC.CNPJ,5) = '02050' then '7568'
				end) Filial,
				1 Id_NF_Entrada,cfop,@NF num_NF,DB.serie,'' subSerie,F6.dtLancamento LctoSAP,dEmis,DC.CNPJ,Ndi,'DI' tipo_DI,dDesemb,DT.vProd-DT.vII CIF,vPIS,vCofins,0,vII,vOutros,null dtEnvio,demis,@NUM_PROC num_proc,dDI, getdate() Dt_Ins, F6.Cancel Cancel
			from
				ATL_BR.dbo.danfe_base DB
				Join ATL_BR.dbo.Danfe_Item_Produto DIP on DIP.id_danfe=DB.id_danfe
				Join ATL_BR.dbo.Danfe_Cia DC on DC.id_danfe=DB.id_danfe and Tipo='E'
				Join ATL_BR.dbo.Danfe_Item_Prod_DI DIPD on DIPD.id_danfe=DB.id_Danfe
				Join ATL_BR.dbo.danfe_totais DT on DT.id_Danfe=DB.id_danfe
				Join Pedido_Ship PS on PS.num_proc=DB.num_proc
				Join pedido PD on PD.cd_pedido=ps.cd_pedido
				Join Pessoa_LLP PP on pp.cd_pes=cd_buyer
				Join ATL_WEB.dbo.FMC_Imp_06 F6 on F6.num_nf = @NF and F6.num_proc = @Num_Proc
			Where
				db.num_proc = @NUM_PROC and nNF = @NF
		End

/*
select * from 
--update
ATL_BR.dbo.Tipo_Impostos 
--set cd_fmc = 'II01'
where cImpostos = 'II'

select top 1 * from atl_web.dbo.FMC_Imp_06
*/



GO
