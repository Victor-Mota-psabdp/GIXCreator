SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spATL_SolenisImpCustoPorProduto_Sel]
		@DataInicial Datetime,
		@DataFinal	Datetime,
		@Grupo		Varchar(50)
as
--spATL_SolenisImpCustoPorProduto_Sel '2020-08-01','2020-08-30','%'
---08.24.2020 added Valor CIF BRL,Porto de Origem,Porto de Destino,Peso Bruto,Peso cubado
-- 09.23.2020 - added CNPJ (Anderson Oliveira)
select 
	H.Num_Proc,

	[dbo].[fBusca_Docs_PO_Modal](H.num_proc,3) [Numero da Ordem],
	[dbo].[fBusca_Docs_PO_Modal](H.num_proc,5) [Numero da DI],
	PP.Nome_Raz_Soc Shipper,
	CN.Nome_Raz_Soc Consignee,
	case 
		WHEN len(CN.Num_CPF_CNPJ)>14 then substring(CN.Num_CPF_CNPJ,2,2) + '.' + substring(CN.Num_CPF_CNPJ,4,3) + '.' + substring(CN.Num_CPF_CNPJ,7,3) + '/' + substring(CN.Num_CPF_CNPJ,10,4) + '-' + substring(CN.Num_CPF_CNPJ,14,2)    
		ELSE  substring(CN.Num_CPF_CNPj,1,2) + '.' + substring(CN.Num_CPF_CNPj,3,3) + '.' + substring(CN.Num_CPF_CNPj,6,3) + '/' + substring(CN.Num_CPF_CNPj,9,4) + '-' + substring(CN.Num_CPF_CNPj,13,2)    
	End CNPJ  ,
	H.Cd_Tp_Oper Incoterm,
	[dbo].[fBusca_Docs_PO_Modal](H.num_proc,2) [Numero da Invoice],
	H.HAWB [House],
	Modal,
	Org.Nome_Local [Origem],
	Dst.Nome_Local [Destino],
	H.Peso_Bruto [Peso Bruto],
	H.Peso_Cubado [Peso Cubado],
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
		[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'FOB CHARGES%')+[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Frete (consta na DI)') + [dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Seguro%') + [dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'VALOR DOS ACRÉSCIMOS (DI)') [CIF],

	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'FOB CHARGES%') [FOB CHARGES],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Seguro%')  [Seguro],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'FRETE - CHB%') + [dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'FRETE COMPLEMENTAR%') + [dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Frete Importação%') [Frete Internacional],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Taxas Siscomex%') [Taxas Siscomex],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Imposto de Importação%') [Imposto de Importação],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Juros Imposto de Importação%') [Juros Imposto de Importação],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Multa Imposto de Importação%') [Multa Imposto de Importação],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'IPI - CHB%') [IPI],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Juros PIS%') [Juros PIS],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'ICMS - CHB%') [ICMS],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Juros ICMS 1 - CHB%') [Juros ICMS],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'MULTA ICMS 1 - CHB%') [Multa ICMS],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'PIS - CHB%') [PIS],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'COFINS%') [COFINS],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Juros COFINS%') [Juros COFINS],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'AFRMM%') [AFRMM],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Armazenagem%') [Armazenagem],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'CAPATAZIAS%') + [dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'THC%') [Capatazias / THC],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Carta de Correção%')  [Carta de Correção],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'CARTÓRIO%')  [Cartório],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'CORREÇÃO SISCARGA%')  [Correção Siscarga],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'CORREÇÃO SISCARGA%')  [Correio],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Damage Protection charge%')  [Damage Protection charge],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Demurrage - CHB%')  [Demurrage],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Desconsolidação%')  [Desconsolidação],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'DESPESA CONTAINER%')  [DESPESA CONTAINER],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Devolução de CNTR%')  [Devolução de CNTR],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Drop Off%')  [Drop Off],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Emissão de BL%')  [Emissão de BL],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Exame Laboratorial%')  [Exame Laboratorial],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Handling%')  [Handling],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Inspeção de Madeira%')  [Inspeção de Madeira],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'IOF%')  [IOF],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'ISPS%')  [ISPS],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Lavagem CNTR%')  [Lavagem CNTR],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Liberação de BL%')  [Liberação de BL],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Liberação de Documentos%')  [Liberação de Documentos],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Organização de Arquivo%')  [Organização de Arquivo],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Reparo de Container%')  [Reparo de Container],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Retificação de DI%')  [Retificação de DI],
	
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Serviços de Despacho%') +[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Serviços Prestados%')  [Serviços de Despacho],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Taxa administrativa financeira%')  [Taxa administrativa financeira],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Taxa de retirada de Doc%')  [Taxa de retirada de Doc],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Taxa do Agente%')  [Taxa do Agente],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'TAXA SISCARGA%')  [TAXA SISCARGA],
	[dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Transporte Mercadoria%') + [dbo].[fBusca_Custo_Produto](H.Num_Proc,PS.cd_produto,'Pickup%')  [Frete Interno]

from vwHouse_imp H
	
	Join Localidade Org on Org.cd_local=Cd_Org
	Join Localidade Dst on Dst.Cd_Local = Cd_dst
	Join Pedido_Ship PS with(nolock)  on PS.num_proc=H.num_proc
	Join Pedido_det PD with(nolock)  on PD.cd_pedido = PS.cd_pedido and PS.cd_produto = PD.Cd_Produto and PS.Item=PD.item and Ps.Lote=PD.Lote
	Join Produto_Cliente PC with(nolock)  on PC.cd_prod = PS.Cd_Produto
	Join Pedido P with(nolock) on P.cd_pedido = PD.cd_pedido 
	Join Pessoa PP with(nolock)  on pp.cd_pes=Cd_Export
	Join Pessoa CN with(nolock)  on CN.cd_pes=Cd_Consig
	Left Join LLP_imp_Mar LLP with(nolock) on H.Num_Proc= LLP.Num_Proc_Lim
	Left Join LLP_imp_oUT LLo with(nolock) on H.Num_Proc= LLo.Num_Proc_LiO
	Left Join LLP_imp_aer LLA with(nolock) on H.Num_Proc= LLA.Num_Proc_Lia
	left Join Pessoa_LLP PL on PL.Cd_Pes =h.Cd_Import
	Join Pessoa GRUPO on GRUPO.cd_pes=PL.cd_pes
	Join Tarefas_Processos TP40 with(nolock) on H.Num_Proc=TP40.Num_Proc and TP40.ID_Task=40

	where 

	h.num_proc like '%SOL%'
	and TP40.Dt_Conclusao between @DataInicial  and @DataFinal 

GO
