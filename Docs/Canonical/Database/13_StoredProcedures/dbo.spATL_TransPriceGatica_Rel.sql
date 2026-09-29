SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_TransPriceSolenis_Rel '2020-09-01','2020-09-20'


create procedure [dbo].[spATL_TransPriceGatica_Rel]
(
@DataInicial datetime,
@DataFinal datetime
)


as

Declare @Grupo varchar(20)

Declare @Cd_Grupo as varchar(10)

set @Grupo = 'Grupo Solenis'


Set @Cd_Grupo = (select top 1 Cd_Pes from pessoa with(nolock) where apelido=@Grupo)

select 
		HOU.Num_Proc [Ref. BDP],
		left(dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,1),500) [PO],
		left(dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc,5),100) [Numero da DI],
		cast(dbo.fBusca_TipoDocCliente('D',HOU.Num_Proc,5) as datetime) [Data da DI],
		--dbo.fBusca_TipoDocCliente('D',HOU.Num_Proc,5)  [Data da DI],
		TP4.Dt_Conclusao [Data do Desembaraço],
		PC.Produto_Descr [Nome do Produto],
		SHIPPER.Nome_Raz_Soc [Exportador],
		(Case when Cd_Tipo = '2' and Left(PS.Num_Proc, 1) = 'I' then 'Third' else
			Case when Cd_Tipo = '2' and Left(PS.Num_Proc, 1) = 'E' then 'Indent' else
			Case when Cd_Tipo = '3' then 'Inter-company' else
			Case when Cd_Tipo = '4' then 'Samples' else 'Samples' End End End End) [Vinculo],
		left(dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,2),80) [Invoice],
		POrigem.Nome_Pais [Origem],
		Dst.Nome_Local [Destino],
		replace(HOU.Moeda_invoice, 'REL','BRL') [Moeda da Invoice],
		cast(replace(CP31.Campo_Dados,'.',',') as varchar(50)) [Paridade da Invoice],
		cast(replace(max(cast(PD.vlr_item as decimal(18,6))),'.',',') as varchar(50)) [Valor Unitario],
		max(cast(replace(cast(PD.vlr_item * CP31.Campo_Dados as decimal(18,6)),'.',',') as varchar(50))) [Valor Unitario R$],
		SUM(ps.qty) [Quantidade],
		PD.UOM [Unidade],
--sum(NDET.Peso_Liquido) [Peso Liquido],
		
	    hOU.Vlr_invoice [Valor da Invoice],
   
      --SUSPENSO (30/10/2020 - JACG)  
	  --cast(replace(cast((max(PD.vlr_item) * CP31.Campo_Dados)*SUM(ps.qty)as decimal(18,6)),'.',',') as varchar(50)) [Valor da Invoice R$],
	   --------------------------eliminado: * CP31.Campo_Dados
	   ----------------------------------------------------------------6 decimais para 2
		cast(replace(cast((max(PD.vlr_item)*SUM(ps.qty)) as decimal(18,2)),'.',',') as varchar(50)) [Valor da Invoice R$],

--SUSPENSO  (30/10/2020 - JACG)
--cast(replace(cast(HOU.Vlr_invoice *dbo.fBuscaPorcentagem_Pedido_Prod(HOU.Num_Proc,PS.CD_Pedido,PS.Cd_Produto)*dbo.fBuscaPorcentagem_CdProduto(HOU.Num_Proc,PS.Cd_Produto)as decimal(18,2)),'.',',') as varchar(50)) [Valor da Invoice],
--sum(NC.Vlr_NF) [Total Cond. Venda R$],
		cast(sum(NDET.ACRESCIMOS) as decimal(10,2)) [Acrescimos da DI],
		cast(sum(NDET.Vlr_Total_ITem-isnull(NDET.vlr_frete,0)-isnull(NDET.vlr_seguro,0)-isnull(NDET.vl_ii,0)-isnull(NDET.ACRESCIMOS,0)) as decimal(18,2)) [FOB - R$],
--(isnull(cast(sum(NDET.Vlr_Total_ITem-isnull(NDET.vlr_frete,0)-isnull(NDET.vlr_seguro,0)-isnull(NDET.vl_ii,0)-isnull(NDET.ACRESCIMOS,0)) as Decimal(18,2)),0) + isnull(cast(sum(NDET.Vlr_Frete) as Decimal(18,2)),0)) [CIF - R$],
		Sum(DItem.Valor_CIF_Reais) [CIF R$],
		Max(NDET.NCM) [NCM],
		cast(max(NDET.ALIQ_II) as decimal(10,2)) [% II],
		sum(dbo.fBusca_Custo_Produto(HOU.Num_Proc,PS.cd_produto,'%Imposto de Importaç%')) [II - R$],
		cast(max(NDET.ALIQ_IPI) as decimal(10,2)) [% IPI],
		sum(dbo.fBusca_Custo_Produto(HOU.Num_Proc,PS.cd_produto,'IPI%')) [IPI - R$],
		cast(max(NDET.vl_aliq_pis) as decimal(10,2)) [% PIS],
		sum(dbo.fBusca_Custo_Produto(HOU.Num_Proc,PS.cd_produto,'PIS%')) [PIS - R$],
		cast(max(NDET.VL_ALIQ_COFINS) as decimal(10,2)) [% Cofins],
		sum(dbo.fBusca_Custo_Produto(HOU.Num_Proc,PS.cd_produto,'Cofins%')) [Cofins - R$],
		sum(dbo.fBusca_Custo_Produto(HOU.Num_Proc,PS.cd_produto,'%Siscomex%')) [Siscomex - R$],
		cast(max(ALIQ_ICMS) as decimal(10,2)) [% ICMS],
		sum(dbo.fBusca_Custo_Produto(HOU.Num_Proc,PS.cd_produto,'ICMS%')) [ICMS - R$],
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'10') [Numero da Danfe],
--sum(NC.Vlr_NF) [Valor da Danfe],
		sum(NDET.VL_BASE_ICMS) [Valor da Danfe],
		HOU.cd_tp_oper [Incoterm],
--TP108.Dt_Conclusao [Danfe Recebida em:],
		cast(dbo.fBusca_TipoDocCliente('D',HOU.Num_Proc,10) as datetime) [Danfe Recebida em:],
		NC.CFOP [CFOP],
		PC.cd_Proc_Cliente [Product ID],
		TMC.Descricao_Termo [Termo de Pagamento],
		HOU.ATD [Embarque],
--(Case when TMC.Dt_Base = 'Invoice'  then   dateadd(day,isnull(TMC.Dias,0),isnull(dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,2),0))  else
--Case when TMC.Dt_Base = 'ATD'  then   dateadd(day,isnull(TMC.Dias,0),isnull(HOU.ATD,0)) else '0' end end)   [Vencimento],
		(Case when TMC.Dt_Base = 'Invoice'  then   (Case when dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,2) is not null  then dateadd(day,isnull(TMC.Dias,0),dbo.fBusca_DATA_PO_Modal(HOU.Num_Proc,2)) else null End)  else
		Case when TMC.Dt_Base = 'ATD'  then   (Case when HOU.ATD is not null then dateadd(day,isnull(TMC.Dias,0),HOU.ATD) else null End) else null end end)   [Vencimento],
		cast(replace(CP31.Campo_Dados,'.',',') as varchar(50))[Paridade do Frete],
--CP176.Campo_Dados  [Exchange Rate Value - USD],
		TM.Nome_Tp_Moeda [Moeda do Frete],
		(Case when isnull(sum(NDET.vlr_frete),0) = 0 or isnull(CP31.Campo_Dados,'0') = '0' then null else  cast(sum(NDET.vlr_frete) /cast(CP31.Campo_Dados as decimal(18,6)) as decimal(18,2)) end) [Frete],
		cast(sum(NDET.vlr_frete)as decimal(18,2)) [Frete - R$],
		--(Case when isnull(sum(dbo.fBusca_Custo_Produto(HOU.Num_Proc,PS.cd_produto,'%Seguro%')),0) = 0 or isnull(CP176.Campo_Dados,'0') = '0' then null else cast(sum(dbo.fBusca_Custo_Produto(HOU.Num_Proc,PS.cd_produto,'%Seguro%')) / cast(CP176.Campo_Dados as decimal(18,6)) as decimal(18,2)) End)  [Seguro - USD],
		cast(sum(NDET.Vlr_Seguro)as decimal(18,2))/CP176.Campo_Dados [Seguro - USD],
		cast(replace(CP176.Campo_Dados,'.',',') as varchar(50)) [Taxa USD],
		cast(sum(NDET.Vlr_Seguro)as decimal(18,2)) [Seguro - R$]
from 
	vwHouse_Imp HOU with(nolock)
	join pessoa_LLP	GR with(nolock) on GR.cd_pes = HOU.Cd_Consig and GR.cd_pes_grupo = @Cd_Grupo
	left join Tarefas_Processos TP4 with(nolock) on TP4.Num_Proc = HOU.Num_Proc and TP4.ID_Task = 4
--left join Tarefas_Processos TP108 with(nolock) on TP108.Num_Proc = HOU.Num_Proc and TP108.ID_Task = 108
	left join Pedido_Ship PS with(nolock) on HOU.Num_Proc = PS.Num_Proc
	left join Pedido P with(nolock) on PS.cd_pedido = P.Cd_pedido
	left join Pedido_Det PD with(nolock) on PD.cd_pedido = P.Cd_pedido  and PS.cd_produto = PD.Cd_Produto and PS.Lote = PD.Lote and PS.Item = PD.Item
	left join Produto_Cliente PC with(nolock) on PD.Cd_Produto = PC.cd_prod
	left join Pessoa SHIPPER with(nolock) on HOU.Cd_Export = SHIPPER.Cd_Pes
	left Join Localidade Org with(nolock) on Org.cd_local=cd_org
	left Join Pais POrigem with(nolock) on POrigem.cd_pais=Org.cd_pais
	Left join Localidade Dst with (nolock) on Dst.cd_local =cd_dst
	left join Campo_Processo CP31 with(nolock) on HOU.Num_Proc = CP31.Num_Proc and CP31.Id_Campo = 31
	left join Nota_Cliente NC with(nolock) on HOU.Num_Proc = NC.Num_Proc
	left join Nota_Fiscal_Cliente_Det NDET with(nolock) on NC.ID_NF = NDET.ID_NF and NC.CD_Cliente = NDET.Cd_Cliente and PS.cd_produto = NDET.Cd_Produto
	left join 	Campo_Processo CP87 with(nolock) on HOU.num_proc = CP87.Num_Proc and CP87.id_campo=87
	left Join Campo_Processo CP176 with(nolock) on CP176.Num_Proc = HOU.Num_Proc and CP176.id_campo=176
	left Join Campo_Processo CP29 with(nolock) on CP29.Num_Proc = HOU.Num_Proc and CP29.id_campo=29
	Left Join Termo_Pagamento TMC with(nolock) on TMC.cd_termo=CP87.campo_Dados
	left join tipo_moeda TM with(nolock) on TM.Cd_tp_Moeda = HOU.Moeda_Frete
	join Tarefas_Processos TP40 with(nolock) on HOU.Num_Proc = TP40.Num_Proc and TP40.ID_Task = '40'
	left join DI_Item_BR DItem with(nolock) on HOU.Num_Proc = DItem.Num_Proc and DItem.cd_Produto = PS.cd_produto
where  
	TP40.Dt_Conclusao between @DataInicial and @DataFinal

group by 
HOU.Num_Proc ,
left(dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,1),500),
left(dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc,5),100),
cast(dbo.fBusca_TipoDocCliente('D',HOU.Num_Proc,5) as datetime) ,
TP4.Dt_Conclusao,
PC.Produto_Descr,
SHIPPER.Nome_Raz_Soc,
(Case when Cd_Tipo = '2' and Left(PS.Num_Proc, 1) = 'I' then 'Third' else
			Case when Cd_Tipo = '2' and Left(PS.Num_Proc, 1) = 'E' then 'Indent' else
			Case when Cd_Tipo = '3' then 'Inter-company' else
			Case when Cd_Tipo = '4' then 'Samples' else 'Samples' End End End End),
left(dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,2),80),
POrigem.Nome_Pais,
replace(HOU.Moeda_invoice, 'REL','BRL'),
CP31.Campo_Dados,
PD.UOM,
HOU.Vlr_invoice,
HOU.Peso_Liquido,
dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'10'),
HOU.cd_tp_oper,
--TP108.Dt_Conclusao [Danfe Recebida em:],
cast(dbo.fBusca_TipoDocCliente('D',HOU.Num_Proc,10) as datetime),
NC.CFOP,
PC.cd_Proc_Cliente,
TMC.Descricao_Termo,
HOU.ATD,
CP176.Campo_Dados ,
TM.Nome_Tp_Moeda,TMC.Dt_Base,
TMC.Dias,
PS.CD_Pedido,PS.Cd_Produto,
Dst.Nome_Local,
CP29.Campo_Dados

--select * from Percentual_Produto_Hexion
--where Num_Proc = 'IMSOL201804038BR'
--dbo.fBusca_Custo_Produto(HOU.Num_Proc,PS.cd_produto,'%Imposto de Importaç%'),
--dbo.fBusca_Custo_Produto(HOU.Num_Proc,PS.cd_produto,'IPI%'),
--dbo.fBusca_Custo_Produto(HOU.Num_Proc,PS.cd_produto,'PIS%') 

GO
