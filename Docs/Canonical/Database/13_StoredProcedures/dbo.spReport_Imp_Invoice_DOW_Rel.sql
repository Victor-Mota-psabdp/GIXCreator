SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spReport_Imp_Invoice_DOW_Rel]-- '2015-01-01', '2015-12-31'
	@DtInicial datetime,
	@DtFinal datetime
		
AS

	--Declare @DtInicial datetime
	--set @DtInicial = '2015-01-01'
	--Declare @DtFinal datetime
	--set @DtFinal = '2015-12-31'
		

select
	isnull(PA2.Numero_PO_HIA,PM2.Numero_PO_HIM)	[Invoice],
	--dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'2') [Invoice],
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'1')[PO Number],
	(case when P.cd_tipo='2' then 'Third'
			when P.cd_tipo='3' then 'Inter-company'
				when P.cd_tipo='4' then 'Sample'
	end)   [Order Type],
	HOU.Moeda_Invoice [Invoice Currency],
	HOU.Vlr_Invoice [Invoice Value],	
	dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc,'5') [Entry Number],
	Cast(sum(NFDet.Vlr_Total_ITem-isnull(NFDet.vlr_frete,0)-isnull(NFDet.vlr_seguro,0)-isnull(NFDet.vl_ii,0)-isnull(NFDet.ACRESCIMOS,0)) /[Paridade] as decimal(18,2))  [FOB - USD],
	Cast(sum(NFDet.vlr_frete) / [Paridade] as decimal(18,2))[Freight - USD],
	Cast(sum(NFDet.Vlr_Total_ITem-isnull(NFDet.vlr_frete,0)-isnull(NFDet.vlr_seguro,0)-isnull(NFDet.vl_ii,0)-isnull(NFDet.ACRESCIMOS,0)) /[Paridade] as decimal(18,2)) + Cast(sum(NFDet.vlr_frete) / [Paridade] as decimal(18,2)) [CFR - USD],	
	TP4.Dt_Conclusao [Customs Transmission Date],
	TP4.Dt_Conclusao [Customs Clearance Date],
	HOU.Canal [Channel],
	CONSIG.Apelido	[Consignee],
	CONSIG.Num_CPF_CNPJ [CNPJ],
	SHIP.Apelido	[Shipper],
	TC.Nome_Tp_Carga	[Type of cargo],
	DP.Business_Group_Descr [Business Group],
	DP.Business_Descr [Business Name],
	PC.Produto_Descr [Product Description],
	PC.cd_Proc_Cliente [Product ID], 
	HOU.Num_Proc [BDP Ref.]
from vwHouse_Imp HOU with(nolock)
Left Join PO_HIA PA2	with(nolock) on HOU.Num_Proc = PA2.Num_Proc_HIA AND PA2.ID_DC = '2' 
Left Join PO_HIM PM2	with(nolock) on HOU.Num_Proc = PM2.Num_Proc_HIM AND PM2.ID_DC = '2' 
Left Join Pedido_Ship PS		with(nolock) on HOU.Num_Proc = PS.Num_Proc
Join Pedido_Det PD				with(nolock) on PS.cd_pedido = PD.Cd_pedido and PS.cd_produto = PD.Cd_Produto
Join Pedido P					with(nolock) on PD.cd_pedido = P.Cd_pedido
Join Produto_Cliente PC			with(nolock) on PD.Cd_Produto = PC.cd_prod and PD.Cd_Produto = PC.cd_prod
Left Outer Join DE_Para_Produto DP	with(nolock) on DP.gmid=cd_proc_cliente
Join Pessoa CONSIG				with(nolock) on HOU.Cd_Consig = CONSIG.Cd_Pes
Join Pessoa SHIP				with(nolock) on Hou.Cd_Export = SHIP.Cd_Pes
Left Outer Join Pessoa_LLP PLL	with(nolock) on SHIP.Cd_Pes = PLL.Cd_Pes
Left Outer Join Grupo G			with(nolock) on G.cd_pes_grupo=PLL.cd_pes_grupo
Left Outer Join pessoa	PG		with(nolock) on PG.cd_pes=PLL.Cd_Pes_Grupo
Left Outer Join Nota_Cliente NC with(nolock) on HOU.Num_Proc = NC.Num_Proc
Left Outer Join Nota_Fiscal_Cliente_Det NFDet with(nolock) on NC.ID_NF = NFDet.ID_NF and NC.CD_Cliente = NFDet.Cd_Cliente and PS.cd_pedido = NFDet.Cd_Pedido and PS.cd_produto = NFDet.Cd_Produto
Left Outer Join Tipo_Carga TC with(nolock) on HOU.Tp_Carga = TC.Cd_Tp_Carga
Left Outer Join Tarefas_Processos TP4  with(nolock) on HOU.Num_Proc = TP4.Num_Proc and TP4.ID_Task = '4'
Join Tipo_Status_Processo TS	with(nolock) on HOU.ID_status = TS.ID_status
where 
	convert(Datetime,TP4.Dt_Conclusao,105)  between @DtInicial and @DtFinal 
	--and (PG.Apelido = @Grupo or @Grupo = 'GRUPO ALL')
	and Cd_Grupo in ('1','P000022997','P000022998','P000022999','P19015','P20904')
	and isnull(HOU.ID_status,1) < 9
	and (CONSIG.Apelido not like '%DOW AGROCIENCE%')
	and [Paridade]>=1 

GROUP BY 
Paridade,PA2.Numero_PO_HIA,PM2.Numero_PO_HIM,HOU.Num_Proc,P.Cd_tipo,HOU.Moeda_Invoice ,
	HOU.Vlr_Invoice ,TP4.Dt_Conclusao ,HOU.Canal,CONSIG.Apelido,CONSIG.Num_CPF_CNPJ,
	SHIP.Apelido,TC.Nome_Tp_Carga,DP.Business_Group_Descr,DP.Business_Descr,
	PC.Produto_Descr,PC.cd_Proc_Cliente

GO
