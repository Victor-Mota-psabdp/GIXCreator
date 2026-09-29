SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
spFMC_IMP06_Ins_Sel 'IMFMC201206010BR','4905','Cabecalho'
spFMC_IMP06_Ins_Sel 'IMFMC201201017BR','3993','Cancel'
spFMC_IMP06_Ins_Sel 'IMFMC201207125BR','132', 'itens'
spFMC_IMP06_Ins_Sel 'IMFMC201105048BR','3390', 'impostos'
spFMC_IMP06_Ins_Sel 'IMFMC201110036BR','3870', 'sped'

cadu alterado o Num_Pedido Varchar(30) - 22/11/ 12:12hs
*/

CREATE Procedure [dbo].[spFMC_IMP06_Ins_Sel]		--spFMC_IMP06_Ins_Sel 'IMFMC201205040BR','5112','itens'
	@NUM_PROC	VARCHAR(16),
	@NF			VARCHAR(10),
	@Tipo		varchar(15)
as
	if @Tipo = 'Cabecalho' OR @Tipo = 'Cancel'
		Begin
			select
				NF.dEmis dtDocumento,
--				@LctoSAP LctoSAP, -- NOVA DEFINIÇÃO (Peso_Liquido > 0) >> Dt_envio, onde o ID_Evento=’I’ ELSE Dt_envio, onde o ID_Evento=’F’ Tabela: Atlantis.dbo.FMC_Miro)
				(case
					when NF.dtCancel is NOT null  then NF.dtCancel
					when DTV.PesoL > 0 then max(MiroI.Dt_Envio) 
					else max(MiroF.Dt_Envio) 
				end) dtLancamento,
				NF.nNF Num_NF,
				Serie,
				(select top 1 nDI from ATL_BR.dbo.Danfe_Item_Prod_DI where Id_Danfe = NF.Id_Danfe) Num_DI,
				/*Alterado por Erbson - 15-08-2012: será aguardado no ITEM*/
				--Max(P.Num_pedido) Num_Pedido,
				NULL Num_Pedido,
				isnull(DTV.PesoL,0) Peso_Liquido,
				isnull(DTV.PesoB,0) Peso_Bruto,
				null Cod_Expedicao,
				null Num_elemento,
				null Num_Log,
				right(NF.cNF,8) Num_Aleatorio,
				cDV Num_Digito_Controle,
				NF.Num_Proc,
				(select top 1 Cd_Vendor from Atlantis.dbo.Pessoa_LLP where cd_pes = P.cd_seller ) ID_Fornecedor,
				(case when @Tipo = 'Cancel' or NF.dtCancel is NOT null then '1' else 0 end) Cancel,
				--'4.00' strVersao,
				'2.00' strVersao,
				--CAPA.str_Protocolo nProt,
				NF.nProt nProt,
				--CAPA.dt_Protocolo dtProtocolo,
				NF.dhRecbto dtProtocolo,
				'1' tpEmis,
				isnull(MiroI.mensagem_retorno,MiroF.mensagem_retorno) [MSG_Miro]
			from 
				ATL_BR.dbo.Danfe_Base NF
				Join ATL_BR.dbo.Danfe_Item_Produto NFD ON NFD.ID_Danfe=NF.ID_Danfe
				Left Join ATL_BR.dbo.Danfe_Transp_Vol DTV on DTV.Id_Danfe = NF.Id_Danfe
				Join Produto_Cliente PC on right(PC.cd_proc_Cliente,8) COLLATE Latin1_General_CI_AI = right(NFD.cProd,8) and cd_Cliente = '362'
				Join Pedido_Ship PS on PS.Cd_Produto=PC.Cd_Prod and PS.Num_Proc=@NUM_PROC
				Join Pedido P on P.Cd_Pedido=PS.Cd_Pedido
				--Join ATL_WEB.dbo.Capa_NF CAPA on CAPA.str_CodigoProcesso = @Num_Proc and str_NF = @NF
				Left Join FMC_Miro MiroI on MiroI.fatura_pc = @NUM_PROC and MiroI.ID_Evento = 'I'
				Left Join FMC_Miro MiroF on MiroF.fatura_pc = @NUM_PROC and MiroF.ID_Evento = 'F'
			where
				NF.Num_Proc like @NUM_PROC and NF.nNF=@NF and NF.dtEnvio is null
				and ((DTV.PesoL > 0 and MiroI.Dt_Envio is NOT null) OR (isnull(DTV.PesoL,0) = 0 and MiroF.Dt_Envio is NOT null) OR @Tipo = 'Cancel' OR NF.dtCancel is NOT null)
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
				--str_Protocolo,
				NF.nProt,
				--dt_Protocolo,
				NF.dhRecbto,
				P.Cd_Buyer,
				NF.dtCancel,
				MiroI.mensagem_retorno,MiroF.mensagem_retorno
		End

	else IF @Tipo = 'Itens'
		Begin
		
			Declare @TotalProdutos Decimal(10,2)
			Declare @Vlr_Siscomex	Decimal(10,2)
			Declare @Num_Pedido		Varchar(10)
			Declare @Item		Varchar(10)
			Declare @Temp Table
			(
				Item varchar(5),
				Material Varchar(9),
				Centro_Custo Varchar(4),
				Quantidade	Float,
				Peso_Liquido Decimal(10,2),
				NCM			Varchar(8),
				DirFiscalICMS Varchar(3),
				DirFiscalIPI varchar(3),
				LeiCofins Varchar(3),
				LeiPais Varchar(3),
				CFOP varchar(4),
				Vlr_SISCOMEX Decimal(10,2),
				CST Varchar(3),
				Num_Pedido Varchar(30)
			)
			Begin
				insert @Temp
				
				select DISTINCT 
				--P.Cd_Pedido,
					right(PS.Item,5) Item,
					right(cProd,9) Material,
					(select top 1 cd_planta from Atlantis.dbo.pessoa_llp where cd_pes=P.Cd_Buyer) Centro_Custo,
					sum(NFD.qCom) *  DBO.fBuscaPorcentagem_CdPedido (@Num_Proc,ps.ITEM,P.cd_pedido)*dbo.fBuscaPorcentagem_Pedido_Prod(@num_proc,ps.cd_pedido,ps.cd_produto) Quantidade,
					sum(NFD.vProd) * DBO.fBuscaPorcentagem_CdPedido (@Num_Proc,ps.ITEM,P.cd_pedido)*dbo.fBuscaPorcentagem_Pedido_Prod(@num_proc,ps.cd_pedido,ps.cd_produto) Peso_Liquido, --o nome do campo na tab está errado "peso_liquido" o correto seria Vlr_Item
					--sum(NFD.vProd) TESTE1,
					NFD.NCM,
					'IC0' DirFiscalICMS,
					'IP0' DirFiscalIPI,
					'ZC0' LeiCofins,
					'ZP0' LeiPais,
					NFD.CFOP,
					Min(NFT.vOutros)* DBO.fBuscaPorcentagem_CdPedido (@Num_Proc,ps.ITEM,P.cd_pedido)* dbo.fBuscaPorcentagem_Pedido_Prod(@num_proc,ps.cd_pedido,ps.cd_produto)*[dbo].[fBuscaPorcentagem_CdProduto](@Num_Proc,ps.cd_produto) Vlr_SISCOMEX,
					'1' + NFI.CST CST,
					P.Num_Pedido Num_Pedido
				from
					ATL_BR.dbo.Danfe_Base NF
					Join ATL_BR.dbo.Danfe_Item_Produto NFD ON NFD.ID_Danfe=NF.ID_Danfe
					Join ATL_BR.dbo.Danfe_Totais NFT ON NFT.ID_Danfe=NF.ID_Danfe
					Join ATL_BR.dbo.Danfe_Item_Impostos NFI ON NFI.ID_Danfe=NF.ID_Danfe and NFI.ID_Item = NFD.ID_Item and NFI.cImpostos='ICMS'
					Join Produto_Cliente PC on right(PC.cd_proc_Cliente,8) COLLATE Latin1_General_CI_AI = right(NFD.cProd,8) and cd_Cliente = '362'
					Join Pedido_Ship PS on PS.Cd_Produto=PC.Cd_Prod and PS.Num_Proc=@NUM_PROC
					Join Pedido P on P.Cd_Pedido=PS.Cd_Pedido
				where
					NF.Num_Proc like @NUM_PROC  and nNF=@NF and NF.dtEnvio is null
				group by
					PS.Item,cProd,NFD.NCM,NFD.CFOP,NFI.CST,P.Cd_Buyer,PS.Cd_Pedido,P.Num_Pedido, PS.cd_produto, P.cd_pedido
			End
			
			select @TotalProdutos=vProd,@Vlr_Siscomex=vOutros from ATL_BR.dbo.danfe_totais DT
			Join ATL_BR.dbo.Danfe_Base NF on NF.id_danfe=DT.id_danfe
			Where NF.Num_Proc like @NUM_PROC  and nNF=@NF and NF.dtEnvio is null
			
			Select Top 1 @Item=Item, @Num_Pedido=Num_Pedido from @temp
			
			SEt @TotalProdutos=@TotalProdutos - (select Sum(peso_liquido) from @Temp)
			Set @Vlr_Siscomex=@Vlr_Siscomex - (select Sum(Vlr_Siscomex) from @Temp)
			
			Update @Temp set Peso_Liquido=Peso_Liquido+@TotalProdutos,Vlr_Siscomex=Vlr_Siscomex + @Vlr_Siscomex
			Where num_pedido=@Num_Pedido and item=@item
			
			Select * From @Temp
		End
	Else IF @Tipo = 'Impostos'
		Begin
			select DISTINCT
				right(PS.Item,5) Item, 
				TI.cd_FMC Tipo_Imposto, 
				sum(isnull(NFI.vBC,0)) *  DBO.fBuscaPorcentagem_CdPedido (@Num_Proc,ps.ITEM,P.cd_pedido)*dbo.fBuscaPorcentagem_Pedido_Prod(@num_proc,ps.cd_pedido,ps.cd_produto) Outra_Base,
				sum(isnull(NFI.vImposto,0)) *  DBO.fBuscaPorcentagem_CdPedido (@Num_Proc,ps.ITEM,P.cd_pedido)*dbo.fBuscaPorcentagem_Pedido_Prod(@num_proc,ps.cd_pedido,ps.cd_produto) Vlr_Despesa,
				P.Num_Pedido Num_Pedido
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
				NF.Num_Proc like @NUM_PROC  and nNF=@NF  and NF.dtEnvio is null-- and NFI.cImpostos <> 'II'  
			group by
				PS.Item, TI.cd_FMC, PS.Cd_Pedido,PS.cd_produto, P.cd_pedido,P.Num_Pedido
			order by P.Num_Pedido
		End

	Else IF @Tipo = 'SPED'
		Begin
			select distinct 'FMC' COD_HOLDING, --pp.cd_vendor,cd_planta,
				(case when right(DC.CNPJ,5) = '00430' then 'SFBZ' else 'AABZ' end) COD_Matriz,
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
				end) COD_FILIAL,
				1 Id_NF_Entrada,cfop COD_CFOP_LEGAL,@NF num_NF,DB.serie,'' subSerie,F6.dtLancamento DT_LANCAMENTO,dEmis DT_ENTRADA,DC.CNPJ,Ndi NUMERO_DI,'DI' tipo_DI,dDesemb DT_DESEMBARACO,DT.vProd-DT.vII VALOR_CIF,vPIS VALOR_PIS,vCofins VALOR_COFINS,0 VALOR_IOF,vII VALOR_II,vOutros VALOR_DESP_ADUAN_ICMS,null DT_Envio,demis DT_Emissao,@NUM_PROC num_proc,dDI Data_DI, getdate() Dt_Ins, F6.Cancel Cancel
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




GO
