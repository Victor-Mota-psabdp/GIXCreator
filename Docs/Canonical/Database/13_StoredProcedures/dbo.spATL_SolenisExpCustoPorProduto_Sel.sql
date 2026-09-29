SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_SolenisExpCustoPorProduto_Sel]
		@DataInicial Datetime,
		@DataFinal	Datetime,
		@Grupo		Varchar(50)
as

select 
	H.Num_Proc,

	[dbo].[fBusca_Docs_PO_Modal](H.num_proc,3) [Numero da Ordem],
	[dbo].[fBusca_Docs_PO_Modal](H.num_proc,204) [Numero da DUE],
	PP.Nome_Raz_Soc Shipper,
	case 
		WHEN len(PP.Num_CPF_CNPJ)>14 then substring(PP.Num_CPF_CNPJ,2,2) + '.' + substring(PP.Num_CPF_CNPJ,4,3) + '.' + substring(PP.Num_CPF_CNPJ,7,3) + '/' + substring(PP.Num_CPF_CNPJ,10,4) + '-' + substring(PP.Num_CPF_CNPJ,14,2)    
		ELSE  substring(PP.Num_CPF_CNPj,1,2) + '.' + substring(PP.Num_CPF_CNPj,3,3) + '.' + substring(PP.Num_CPF_CNPj,6,3) + '/' + substring(PP.Num_CPF_CNPj,9,4) + '-' + substring(PP.Num_CPF_CNPj,13,2)    
	End CNPJ  , 
	CN.Nome_Raz_Soc Consignee,
	H.Cd_Tp_Oper Incoterm,
	[dbo].[fBusca_Docs_PO_Modal](H.num_proc,2) [Numero da Invoice],
	H.HAWB [House],
	Modal,
	Org.Nome_Local Origem,
	Dst.Nome_Local Destino,

	ETD,
	ATD,
	ETA,
	ATA,
	(select top 1 fatura_pc  from fatura_chb with(nolock) where Status_pc='E' and processo_pc=h.num_proc order by 1 desc) [Numero Prestação de Contas],
	TP40.Dt_Conclusao	[Envio do Faturamento Efetivo],
	PC.cd_Proc_Cliente [Codigo do Produto], 
	PC.Produto_Descr [Descrição do Produto],
	PD.Peso_Bruto_TOT [Quantidade Produto/KG],
	PD.Vlr_Item [Preço Unitário],
	P.cd_tp_moeda [Moeda],
	ISNULL(LLP.Vlr_Invoice,ISNULL(LLO.VLR_INVOICE,LLA.VLR_INVOICE)) [Valor Total Invoice],
	iSNULL(LLP.Cd_Moeda_Invoice,ISNULL(LLO.Cd_Moeda_Invoice,LLA.Cd_Moeda_Invoice)) [Moeda Invoice],
	[dbo].[fBusca_Docs_PO_Modal](H.num_proc,10) [Número NF],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'%Cargas Perigosas%') [Adicional de Cargas Perigosas],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'AMS%') [AMS],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Armazenagem%') [Armazenagem],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Capatazias%') + [dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'THC%') [Capatazias/THC],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Carta de Correção%')  [Carta de Correção],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Consularização%')  [Consularização],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Emissão de BL%')  [Emissão de BL],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'DESPESA CONTAINER%')  [Despesa Container],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Despesas Portuárias%')  [Despesas Portuárias],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Emissão Certificado%')  [Emissão Certificado],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Estadia%')  [Estadia],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Frete%')  [Frete Internacional],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Handling%')  [Handling],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Inspeção%')  [Inspeção],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'ISPS%')  [ISPS],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'ISS%')  [ISS],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Lacre%')  [Lacre],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'%Certificado%')  [Certificado de Origem],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Logistic Fee 1%')  [Logistic Fee 1],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Motoboy%')  [Motoboy],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Movimentacao CNTR%')  [Movimentacao CNTR],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Organização de Arquivo%')  [Organização de Arquivo],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Posicionamento de CNTR%')  [Posicionamento de CNTR],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Reetiquetagem%')  [Reetiquetagem],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Serviços Prestados%DESPACHO%')  [Serviços de Despacho],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Taxa administrativa financeira%')  [Taxa administrativa financeira],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Taxa de origem%')  [Taxa de origem],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Taxa VGM%')  [Taxa VGM],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Terminal Security%')  [Terminal Security],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Transporte Mercadoria%')  [Frete Interno]

from vwHouse_Exp H
	Join Pedido_Ship PS with(nolock)  on PS.num_proc=H.num_proc
	Join Pedido_det PD with(nolock)  on PD.cd_pedido = PS.cd_pedido and PS.cd_produto = PD.Cd_Produto and PS.Item=PD.item and Ps.Lote=PD.Lote
	Join Produto_Cliente PC with(nolock)  on PC.cd_prod = PS.Cd_Produto
	Join Pedido P with(nolock) on P.cd_pedido = PD.cd_pedido 
	Join Pessoa PP with(nolock)  on pp.cd_pes=Cd_Export
	Join Pessoa CN with(nolock)  on CN.cd_pes=Cd_Consig
	Left Join LLP_Exp_Mar LLP with(nolock) on H.Num_Proc= LLP.Num_Proc_Lem
	Left Join LLP_Exp_oUT LLo with(nolock) on H.Num_Proc= LLo.Num_Proc_LeO
	Left Join LLP_Exp_aer LLA with(nolock) on H.Num_Proc= LLA.Num_Proc_LeA
	
    ---- foi trocado h.Cd_Consig por h.Cd_Export  17/11/2020 JACG ----
    Join Pessoa_LLP PL with(nolock) on PL.Cd_Pes =h.Cd_Export
	------------------------------------------------------------------

    Join Pessoa GRUPO with(nolock) on GRUPO.cd_pes=PL.cd_pes
	Left Join Tarefas_Processos TP40 with(nolock) on H.Num_Proc=TP40.Num_Proc and TP40.ID_Task=40
	Join localidade org with(nolock) on org.cd_local=cd_org
	Join Localidade dst with(nolock) on dst.cd_local=Cd_Dst
	where 

h.num_proc like '%SOL%'
and TP40.Dt_Conclusao between @DataInicial  and @DataFinal 
--and GRupo.apelido=@Grupo

GO
