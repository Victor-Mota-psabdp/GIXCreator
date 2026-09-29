SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*

Alteração no Qty - Claudio
de:		isnull(cast(PS.Qty as varchar(10)),'NA') QTY,
Para:	PS.Qty

05-06-2008
Week 23
inclusão Join com Pessoa_LLP - Claudio

17-06-2008
Week 25
inclusão PO_Req_Estimated, Modal, NFE, NFE_Data e Historico

spBSCPFollowUp_Rel '01-01-2009'

*/

CREATE        PROCEDURE [dbo].[spBSCPFollowUp_Rel]
(
	@Data	datetime
)

AS
	Select
		HOU.num_proc_HIA						Processo,
		convert(datetime,Dt_Emis_Hia,105)		Emissao,
		Business_Descr 							Business,
		Value_Center_Descr 						Value_Center,
		dbo.fBusca_GMID(HOU.Num_Proc_HIA)		GMIDs,
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIA)	Produtos,
		isnull(SO.Numero_PO_HIA,P.Num_Pedido)	Order_Number,
		isnull(PO.Numero_PO_HIA,P.Num_PO)		PO,
		DEST.Pais_Local 						Destino,
		P.Planta								Receiving_Plant,
		PS.Qty,
		PD.UoM,
		INV.Numero_PO_HIA						Num_Invoice,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_hia,10) Planned_Goods_Issue_Date,
		dbo.fBusca_Tarefa(hou.num_proc_hia,10)	Posted_Goods_Issue_Date,
		INV.Data_PO_HIA							Data_Invoice,
		LLP.ETD_LIA 							ETD,
		LLP.ATD_LIA 							ATD,
		LLP.ETA_LIA 							ETA,
		LLP.ATA_LIA 							ATA,
		dbo.fBusca_Tarefa(hou.num_proc_hia,4)	Clearance_Date,
		Canal_LIA								Canal,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_hia,19) Previsao_Remocao,
		dbo.fBusca_Tarefa(hou.num_proc_hia,13)	Goods_Receipt_Date,
		PO_Req_Date								PO_Req_Date,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_hia,13) PO_Req_Estimated,
		'Air'									Modal,
		NF.Numero_PO_HIA						NFE,
		(case when NF.Data_PO_HIA > getdate() then null else NF.Data_PO_HIA end) NFE_Data,
		dbo.fBusca_HistoricoDescr(hou.num_proc_hia,0,getdate()) Historico
	From
		House_IMP_Aer HOU
		Join LLP_IMP_Aer				LLP	on HOU.Num_proc_HIA = LLP.Num_proc_LIA
		Left Join Localidade			DEST on Cd_Dst_HIA = DEST.Cd_Local 
		Left Join Tarefas_Processos		RP on HOU.Num_Proc_HIA = RP.Num_Proc and RP.ID_Task = 13
		Left Join Pedido_Ship			PS	on HOU.Num_Proc_HIA = PS.Num_Proc
		Left Join Pedido				P	on PS.Cd_Pedido = P.Cd_Pedido
		Join Pedido_Det					PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
		Join Produto_Cliente			PC	on PD.Cd_Produto = PC.Cd_Prod
		Left Join De_Para_Produto		DPP	on PC.CD_Proc_Cliente = DPP.GMID
		Left Join PO_HIA				NF	on NF.Num_Proc_HIA = HOU.Num_Proc_HIA and NF.ID_DC = 10
		Left Join PO_HIA				INV	on INV.Num_proc_HIA = HOU.Num_proc_HIA and INV.ID_DC = 2
		Left Join PO_HIA				PO	on PO.Num_proc_HIA = HOU.Num_proc_HIA and PO.ID_DC = 1
		Left Join PO_HIA				SO	on SO.Num_proc_HIA = HOU.Num_proc_HIA and SO.ID_DC = 3
		Join Pessoa_LLP					PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIA and PLL.Cd_Pes_Grupo='1'
	Where
		Convert(datetime,Dt_Emis_HIA,105) > @Data
	--	and num_proc_lia in (select num_proc from proc_ncm PN Join NCM on PN.ID_NCM=NCM.ID_NCM where left(ncm,2) in ('39','11','40','72','73','74','76','84','85','86','87','90'))
	Group by
		HOU.num_proc_hia,
		convert(Datetime,Dt_Emis_HiA,105),
		Business_Descr,
		Value_Center_Descr,
		P.Num_Pedido,
		P.Num_PO,
		DEST.Pais_Local,
		P.Planta,
		PS.Qty,
		PD.UoM,
		INV.Numero_PO_HiA,
		INV.Data_PO_HiA,
		LLP.ETD_LIA,
		LLP.ATD_LIA,
		LLP.ETA_LIA,
		LLP.ATA_LIA,
		PO_Req_Date,
		Canal_LIA,
		P.DL_Chegada,
		NF.Numero_PO_HIA,
		NF.Data_PO_HIA,
		SO.Numero_PO_HIA,
		PO.Numero_PO_HIA

Union All

	Select  
		HOU.num_proc_HIM						Processo,
		convert(datetime,Dt_Emis_HIM,105)		Emissao,
		Business_Descr 							Business,
		Value_Center_Descr 						Value_Center,
		dbo.fBusca_GMID(HOU.Num_Proc_HIM)		GMIDs,
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIM)	Produtos,
		isnull(SO.Numero_PO_HIM,P.Num_Pedido)	Order_Number,
		isnull(PO.Numero_PO_HIM,P.Num_PO)		PO,
		DEST.Pais_Local 						Destino,
		P.Planta								Receiving_Plant,
		PS.Qty,
		PD.UoM,
		INV.Numero_PO_HIM						Num_Invoice,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_him,10) Planned_Goods_Issue_Date,
		dbo.fBusca_Tarefa(hou.num_proc_him,10)	Posted_Goods_Issue_Date,
		INV.Data_PO_HIM							Data_Invoice,
		LLP.ETD_LIM 							ETD,
		LLP.ATD_LIM								ATD,
		LLP.ETA_LIM 							ETA,
		LLP.ATA_LIM 							ATA,
		dbo.fBusca_Tarefa(hou.num_proc_him,4)	Clearance_Date,
		Canal_LIM								Canal,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_him,19) Previsao_Remocao,
		dbo.fBusca_Tarefa(hou.num_proc_him,13)	Goods_Receipt_Date,
		PO_Req_Date								PO_Req_Date,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_him,13) PO_Req_Estimated,
		'Ocean'									Modal,
		NF.Numero_PO_HIM						NFE,
		(case when NF.Data_PO_HIM > getdate() then null else NF.Data_PO_HIM end) NFE_Data,
		dbo.fBusca_HistoricoDescr(hou.num_proc_him,0,getdate()) Historico
	From
		House_IMP_MAR HOU
		Join LLP_IMP_MAR				LLP	on HOU.Num_proc_HIM = LLP.Num_proc_LIM
		Join Localidade					DEST on Cd_Dst_HIM = DEST.Cd_Local 
		Left Join Tarefas_Processos		RP on HOU.Num_Proc_HIM = RP.Num_Proc and RP.ID_Task = 13
		Join Pedido_Ship				PS	on HOU.Num_Proc_HIM = PS.Num_Proc
		Join Pedido						P	on PS.Cd_Pedido = P.Cd_Pedido
		Join Pedido_Det					PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
		Join Produto_Cliente			PC	on PS.Cd_Produto = PC.Cd_Prod
		Left Join De_Para_Produto		DPP	on PC.CD_Proc_Cliente = DPP.GMID
		Left Join PO_HIM				NF	on NF.Num_Proc_HIM=HOU.Num_Proc_HIM and NF.ID_DC = 10
		Left Join PO_HIM				INV	on INV.Num_proc_HIM = HOU.Num_proc_HIM and INV.ID_DC = 2
		Left Join PO_HIM				PO	on PO.Num_proc_HIM = HOU.Num_proc_HIM and PO.ID_DC = 1
		Left Join PO_HIM				SO	on SO.Num_proc_HIM = HOU.Num_proc_HIM and SO.ID_DC = 3
		Join Pessoa_LLP					PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIM and PLL.Cd_Pes_Grupo='1'
	Where
		Convert(datetime,Dt_Emis_HIM,105) > @Data
	--	and num_proc_lim in (select num_proc from proc_ncm PN Join NCM on PN.ID_NCM=NCM.ID_NCM where left(ncm,2) in ('39','11','40','72','73','74','76','84','85','86','87','90'))

	Group by 
		HOU.num_proc_hIM,
		convert(Datetime,Dt_Emis_HIM,105),
		Business_Descr,
		Value_Center_Descr,
		P.Num_Pedido,
		P.Num_PO,
		DEST.Pais_Local,
		P.Planta,
		PS.Qty,
		PD.UoM,
		INV.Numero_PO_HIM,
		INV.Data_PO_HIM,
		LLP.ETD_LIM,
		LLP.ATD_LIM,
		LLP.Canal_Lim,
		LLP.ETA_LIM,
		LLP.ATA_LIM,
		PO_Req_Date,
		Canal_LIM,
		P.DL_Chegada,
		NF.Numero_PO_HIM,
		NF.Data_PO_HIM,
		SO.Numero_PO_HIM,
		PO.Numero_PO_HIM

Union All

	Select  
		HOU.num_proc_HIO						Processo,
		Convert(datetime,Dt_Emis_HIO,105)		Emissao,
		Business_Descr 							Business,
		Value_Center_Descr 						Value_Center,
		dbo.fBusca_GMID(HOU.Num_Proc_HIO)		GMIDs,
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIO)	Produtos,
		isnull(SO.Numero_PO_HIO,P.Num_Pedido)	Order_Number,
		isnull(PO.Numero_PO_HIO,P.Num_PO)		PO,
		DEST.Pais_Local 						Destino,
		P.Planta								Receiving_Plant,
		PS.Qty,
		PD.UoM,
		INV.Numero_PO_HIO						Num_Invoice,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_hio,10) Planned_Goods_Issue_Date,
		dbo.fBusca_Tarefa(hou.num_proc_hio,10)	Posted_Goods_Issue_Date,
		INV.Data_PO_HIO							Data_Invoice,
		LLP.ETD_LIO 							ETD,
		LLP.ATD_LIO 							ATD,
		LLP.ETA_LIO 							ETA,
		LLP.ATA_LIO 							ATA,
		dbo.fBusca_Tarefa(hou.num_proc_hio,4)	Clearance_Date,
		Canal_LIO								Canal,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_hio,19) Previsao_Remocao,
		dbo.fBusca_Tarefa(hou.num_proc_hio,13)	Goods_Receipt_Date,
		PO_Req_Date								PO_Req_Date,
		dbo.fBusca_Tarefa_Prev(hou.num_proc_hio,13) PO_Req_Estimated,
		(case when LLP.Tipo_LIO = 'T' then 'Truck' else 'Rail' end)	Modal,
		NF.Numero_PO_HIO						NFE,
		(case when NF.Data_PO_HIO > getdate() then null else NF.Data_PO_HIO end) NFE_Data,
		dbo.fBusca_HistoricoDescr(hou.num_proc_hio,0,getdate()) Historico
	From
		House_IMP_OUT HOU
		Join LLP_IMP_OUT				LLP	on HOU.Num_proc_HIO = LLP.Num_proc_LIO
		Left Join Localidade			DEST on Cd_Dst_HIO = DEST.Cd_Local 
		Left Join Tarefas_Processos		RP on HOU.Num_Proc_HIO = RP.Num_Proc and RP.ID_Task = 13
		Join Pedido_Ship				PS	on HOU.Num_Proc_HIO = PS.Num_Proc
		Join Pedido						P	on PS.Cd_Pedido = P.Cd_Pedido
		Join Pedido_Det					PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
		Join Produto_Cliente			PC	on PD.Cd_Produto = PC.Cd_Prod
		Left Join De_Para_Produto		DPP	on PC.CD_Proc_Cliente = DPP.GMID
		Left Join PO_HIO				NF	on NF.Num_Proc_HIO=HOU.Num_Proc_HIO and NF.ID_DC = 10
		Left Join PO_HIO				INV	on INV.Num_proc_HIO = HOU.Num_proc_HIO and INV.ID_DC = 2
		Left Join PO_HIO				PO	on PO.Num_proc_HIO = HOU.Num_proc_HIO and PO.ID_DC = 1
		Left Join PO_HIO				SO	on SO.Num_proc_HIO = HOU.Num_proc_HIO and SO.ID_DC = 3
		Join Pessoa_LLP					PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIO and PLL.Cd_Pes_Grupo='1'
	Where
		Convert(datetime,Dt_Emis_HIO,105) > @Data
	--	and num_proc_lio in (select num_proc from proc_ncm PN Join NCM on PN.ID_NCM=NCM.ID_NCM where left(ncm,2) in ('39','11','40','72','73','74','76','84','85','86','87','90'))
	
Group by 
		HOU.num_proc_hIO,
		convert(Datetime,Dt_Emis_HIO,105),
		Business_Descr,
		Value_Center_Descr,
		P.Num_Pedido,
		P.Num_PO,
		DEST.Pais_Local,
		P.Planta,
		PS.Qty,
		PD.UoM,
		INV.Numero_PO_HIO,
		INV.Data_PO_HIO,
		LLP.ETD_LIO,
		LLP.ATD_LIO,
		LLP.ETA_LIO,
		LLP.ATA_LIO,
		PO_Req_Date,
		Canal_LIO,
		P.DL_Chegada,
		NF.Numero_PO_HIO,
		NF.Data_PO_HIO,
		LLP.Tipo_LIO,
		SO.Numero_PO_HIO,
		PO.Numero_PO_HIO




GO
