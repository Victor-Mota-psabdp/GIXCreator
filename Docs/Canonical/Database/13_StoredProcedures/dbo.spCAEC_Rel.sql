SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













--11-05 Reprogramacao do Report - Anderson
--29/05 Acerto Custos - Claudio
-- 09-09 Alteracao do Processo_PC - Anderson

--05-06-2008
--Week 23
--inclusão Join com Pessoa_LLP - Claudio


CREATE	  Procedure	 [dbo].[spCAEC_Rel] 

As
	select 
		HOU.Num_Proc_HIM										BDP_Reference,
		convert(datetime,HOU.Dt_Emis_Him,105)					Register_Date,
		IsNull(PO.numero_po_him,P.Num_PO)						PO_Number,
		PS.Item													PO_Item,
		Isnull(SO.numero_po_him,P.Num_Pedido)					Sap_Order_Number,
		dbo.fBusca_GMID(HOU.Num_Proc_HIM)						GMIDs,
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIM)					Produtos,
		DC.Cd_Planta 											Delivering_Plant_ID,
		DC.Planta_Nome											Delivering_Company,
		P.Planta												Receiving_Company_Code,
		RC.Planta_Nome											Receiving_Plant,
--		Isnull(dbo.fBusca_NotaFiscal_CNPJ(HOU.Num_Proc_Him),left(num_cpf_cnpj),len(num_cpf_cnpj)-1))	Receiving_Company_CNPJ,
num_cpf_cnpj Receiving_Company_CNPJ,
		LC.Pais_Local											Country_Destination,
		'Sea Import' 											Mode_Transportation,
		INV.numero_po_him										Invoice_Number,
		INV.Data_po_him											Invoice_Data,
		LLP.ATD_Lim												Sailing_Date,
		LLP.ATA_Lim												Date_Arrival,
		TP.Dt_Conclusao											Good_receipt,

--		cast(Isnull(sum(PD.Peso_Item * PD.Qty),0)/1000 as float)	
		dbo.fBusca_UoM(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,PS.Item,'Qty')/ IsNull(dbo.fBusca_NotaFiscal_Paridade(HOU.Num_Proc_Him),1) Qty_UOM,
		dbo.fBusca_UoM(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,PS.Item,'UOM') UOM,

		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'Quantidade') Quantidade,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'Vlr_FRETE') Vlr_FRETE,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'ALIQ_II') ALIQ_II,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'VL_II') VL_II,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'ALIQ_IPI') ALIQ_IPI,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_Him,PS.CD_Pedido, PS.Cd_Produto,'VL_IPI') VL_BASE_IPI,

		dbo.fBusca_Custo_Processo(HOU.Num_Proc_Him,'%PIS%')	vlrPIS,
		dbo.fBusca_Custo_Processo(HOU.Num_Proc_Him,'%COFINS%') vlrCOFINS,
		dbo.fBusca_Custo_Processo (HOU.Num_Proc_Him,'%ICMS%')	vlrICMS,
		dbo.fBusca_Custo_Processo (HOU.Num_Proc_Him,'%AFRMM%') +
		dbo.fBusca_Custo_Processo (HOU.Num_Proc_Him,'%Frete Interno%') +
		dbo.fBusca_Custo_Processo (HOU.Num_Proc_Him,'%Armazenagem%') +
		dbo.fBusca_Custo_Processo (HOU.Num_Proc_Him,'%Demurrage%') vlrOutrosCustos,
		dbo.fBusca_Custo_Processo (HOU.Num_Proc_Him,'%AFRMM%') AFRMM,
		dbo.fBusca_Custo_Processo (HOU.Num_Proc_Him,'%Frete Interno%') FRETE,
		dbo.fBusca_Custo_Processo (HOU.Num_Proc_Him,'%Armazenagem%') ARMAZENAGEM,
		dbo.fBusca_Custo_Processo (HOU.Num_Proc_Him,'%Demurrage%') DEMURRAGE,		
		NF.Numero_PO_Him	Nr_Nota_Fiscal,
		NF.Data_PO_HIM		Data_NF,
		max(Processo_PC)			Status,
		Business_Descr
	from
		House_IMP_Mar HOU
		Join LLP_IMP_Mar			LLP	on HOU.Num_Proc_Him = LLP.Num_Proc_LIM
		Left outer join Fatura_CHB	FCHB on HOU.Num_Proc_Him = FCHB.Processo_PC
		Left Join Pedido_Ship 		PS	on HOU.Num_Proc_HIM = PS.Num_Proc
		Left Join Pedido_Det		PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
		Join Pedido					P	on PS.Cd_Pedido = P.Cd_Pedido
		Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
		Left Join De_Para_Produto	DPP	on PC.Cd_Proc_Cliente = DPP.GMID 
		Left Join Pessoa_LLP		RC	on P.Planta = RC.cd_planta and RC.Planta_Nome is not null and RC.Cd_Pes_Grupo='1'
		Left Join Pessoa_LLP		DC	on P.Cd_Seller = DC.Cd_Pes and DC.Planta_Nome is not null and DC.Cd_Pes_Grupo='1'
		Left Join Pessoa			RCC	on cd_consig_him = RCC.Cd_Pes --and num_cpf_cnpj <> ''
		Left Join Localidade		LC	on Hou.Cd_Dst_HIM = Lc.Cd_Local
		Left Join PO_HIM			PO  on hou.num_proc_him = po.num_proc_him and PO.Id_Dc=1
		Left Join PO_HIM			SO	on hou.num_proc_him = SO.num_proC_him and SO.ID_DC=3
		Left Join PO_HIM			INV on HOU.num_proc_him=INV.num_proc_him and INV.ID_DC=2
		Left Join PO_HIM			NF  on hou.num_proc_him = NF.num_proc_him and NF.Id_Dc=10
		Left Join Tarefas_Processos	TP	on hou.num_proc_him=TP.num_proc and TP.id_task=13
		Join Pessoa_LLP				PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIM and PLL.Cd_Pes_Grupo='1'
	where
		right(left(HOU.Num_Proc_HIM,9),4) = '2009' and dt_conclusao is not null
	Group by
			HOU.Num_Proc_HIM,
			HOU.Dt_Emis_Him,
			P.Num_PO,
			PS.Item,
			P.Num_Pedido,
			DC.Cd_Planta,
			DC.Planta_Nome,
			P.Planta,
			RC.Planta_Nome,
			LC.Pais_Local,
			INV.numero_po_him,
			INV.Data_po_him,
			LLP.ATD_Lim,
			LLP.ATA_Lim,
			PS.CD_Pedido, PS.Cd_Produto,
			PO.numero_po_him,
			SO.numero_po_him,
			num_cpf_cnpj,
			Dt_conclusao,
			
			NF.Numero_PO_Him,
			NF.Data_PO_HIM,Business_Descr

UNION all
	select 
		HOU.Num_Proc_HIA										BDP_Reference,
		convert(datetime,HOU.Dt_Emis_HIA,105)					Register_Date,
		IsNull(PO.numero_po_HIA,P.Num_PO)						PO_Number,
		PS.Item													PO_Item,
		Isnull(SO.numero_po_HIA,P.Num_Pedido)					Sap_Order_Number,
		dbo.fBusca_GMID(HOU.Num_Proc_HIA)						GMIDs,
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIA)					Produtos,
		DC.Cd_Planta 											Delivering_Plant_ID,
		DC.Planta_Nome											Delivering_Company,
		P.Planta												Receiving_Company_Code,
		RC.Planta_Nome											Receiving_Plant,
		Isnull(dbo.fBusca_NotaFiscal_CNPJ(HOU.Num_Proc_HIA),left(num_cpf_cnpj,len(num_cpf_cnpj)-1))	Receiving_Company_CNPJ,
		LC.Pais_Local											Country_Destination,
		'Air Import' 											Mode_Transportation,
		INV.numero_po_HIA										Invoice_Number,
		INV.Data_po_HIA											Invoice_Data,
		LLP.ATD_LIA												Sailing_Date,
		LLP.ATA_LIA												Date_Arrival,
		TP.Dt_Conclusao											Good_receipt,

--		cast(Isnull(sum(PD.Peso_Item * PD.Qty),0)/1000 as float)	
		dbo.fBusca_UoM(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,PS.Item,'Qty')/ IsNull(dbo.fBusca_NotaFiscal_Paridade(HOU.Num_Proc_HIA),1) Qty_UOM,
		dbo.fBusca_UoM(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,PS.Item,'UOM') UOM,

		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'Quantidade') Quantidade,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'Vlr_FRETE') Vlr_FRETE,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'ALIQ_II') ALIQ_II,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'VL_II') VL_II,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'ALIQ_IPI') ALIQ_IPI,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'VL_IPI') VL_BASE_IPI,

		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'%PIS%')	vlrPIS,
		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'%COFINS%') vlrCOFINS,
		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'%ICMS%')	vlrICMS,
		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'%AFRMM%') +
		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'%Frete Interno%') +
		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'%Armazenagem%') +
		dbo.fBusca_Custo(HOU.Num_Proc_HIA,PS.CD_Pedido, PS.Cd_Produto,'%Demurrage%') vlrOutrosCustos,
		dbo.fBusca_Custo_Processo (HOU.Num_Proc_Hia,'%AFRMM%') AFRMM,
		dbo.fBusca_Custo_Processo (HOU.Num_Proc_Hia,'%Frete Interno%') FRETE,
		dbo.fBusca_Custo_Processo (HOU.Num_Proc_Hia,'%Armazenagem%') ARMAZENAGEM,
		dbo.fBusca_Custo_Processo (HOU.Num_Proc_Hia,'%Demurrage%') DEMURRAGE,
		NF.Numero_PO_HIA	Nr_Nota_Fiscal,
		NF.Data_PO_HIA		Data_NF,
		max(Processo_PC)			Status,	
		Business_Descr
	from
		House_IMP_Aer HOU
		Join LLP_IMP_Aer			LLP	on HOU.Num_Proc_HIA = LLP.Num_Proc_LIA
		Left outer join Fatura_CHB	FCHB on HOU.Num_Proc_HIA = FCHB.Processo_PC
		Left Join Pedido_Ship 		PS	on HOU.Num_Proc_HIA = PS.Num_Proc
		Left Join Pedido_Det		PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
		Join Pedido					P	on PS.Cd_Pedido = P.Cd_Pedido
		Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
		Left Join De_Para_Produto	DPP	on PC.Cd_Proc_Cliente = DPP.GMID 
		Left Join Pessoa_LLP		RC	on P.Planta = RC.cd_planta and RC.Planta_Nome is not null and RC.Cd_Pes_Grupo='1'
		Left Join Pessoa_LLP		DC	on P.Cd_Seller = DC.Cd_Pes and DC.Planta_Nome is not null and DC.Cd_Pes_Grupo='1'
		Left Join Pessoa			RCC	on Cd_Consig_Hia = RCC.Cd_Pes --and num_cpf_cnpj <> ''
		Left Join Localidade		LC	on Hou.Cd_Dst_HIA = Lc.Cd_Local
		Left Join PO_HIA			PO  on hou.num_proc_HIA = po.num_proc_HIA and PO.Id_Dc=1
		Left Join PO_HIA			SO	on hou.num_proc_HIA = SO.num_proC_HIA and SO.ID_DC=3
		Left Join PO_HIA			INV on HOU.num_proc_HIA=INV.num_proc_HIA and INV.ID_DC=2
		Left Join PO_HIA			NF  on hou.num_proc_hia = NF.num_proc_hia and NF.Id_Dc=10
		Left Join Tarefas_Processos	TP	on hou.num_proc_HIA=TP.num_proc and TP.id_task=13
		Join Pessoa_LLP				PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIA and PLL.Cd_Pes_Grupo='1'
	where
		right(left(HOU.Num_Proc_HIA,9),4) = '2009' and dt_conclusao is not null
	Group by
			HOU.Num_Proc_HIA,
			HOU.Dt_Emis_HIA,
			P.Num_PO,
			PS.Item,
			P.Num_Pedido,
			DC.Cd_Planta,
			DC.Planta_Nome,
			P.Planta,
			RC.Planta_Nome,
			LC.Pais_Local,
			INV.numero_po_HIA,
			INV.Data_po_HIA,
			LLP.ATD_LIA,
			LLP.ATA_LIA,
			PS.CD_Pedido, PS.Cd_Produto,
			PO.numero_po_HIA,
			SO.numero_po_HIA,
			num_cpf_cnpj,
			Dt_conclusao,
			NF.Numero_PO_HIA,
			NF.Data_PO_HIA,
			Business_Descr

UNION all
	select 
		HOU.Num_Proc_HIO										BDP_Reference,
		convert(datetime,HOU.Dt_Emis_HIO,105)					Register_Date,
		IsNull(PO.numero_po_HIO,P.Num_PO)						PO_Number,
		PS.Item													PO_Item,
		Isnull(SO.numero_po_HIO,P.Num_Pedido)					Sap_Order_Number,
		dbo.fBusca_GMID(HOU.Num_Proc_HIO)						GMIDs,
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIO)					Produtos,
		DC.Cd_Planta 											Delivering_Plant_ID,
		DC.Planta_Nome											Delivering_Company,
		P.Planta												Receiving_Company_Code,
		RC.Planta_Nome											Receiving_Plant,
		Isnull(dbo.fBusca_NotaFiscal_CNPJ(HOU.Num_Proc_HIO),left(num_cpf_cnpj,len(num_cpf_cnpj)-1))	Receiving_Company_CNPJ,
		LC.Pais_Local											Country_Destination,
		'Import' 											Mode_Transportation,
		INV.numero_po_HIO										Invoice_Number,
		INV.Data_po_HIO											Invoice_Data,
		LLP.ATD_LIO												Sailing_Date,
		LLP.ATA_LIO												Date_Arrival,
		TP.Dt_Conclusao											Good_receipt,

		dbo.fBusca_UoM(HOU.Num_Proc_HIO,PS.CD_Pedido, PS.Cd_Produto,PS.Item,'Qty')/ IsNull(dbo.fBusca_NotaFiscal_Paridade(HOU.Num_Proc_HIO),1) Qty_UOM,
		dbo.fBusca_UoM(HOU.Num_Proc_HIO,PS.CD_Pedido, PS.Cd_Produto,PS.Item,'UOM') UOM,

		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_HIO,PS.CD_Pedido, PS.Cd_Produto,'Quantidade') Quantidade,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_HIO,PS.CD_Pedido, PS.Cd_Produto,'Vlr_FRETE') Vlr_FRETE,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_HIO,PS.CD_Pedido, PS.Cd_Produto,'ALIQ_II') ALIQ_II,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_HIO,PS.CD_Pedido, PS.Cd_Produto,'VL_II') VL_II,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_HIO,PS.CD_Pedido, PS.Cd_Produto,'ALIQ_IPI') ALIQ_IPI,
		dbo.fBusca_Vlr_NF_Det(HOU.Num_Proc_HIO,PS.CD_Pedido, PS.Cd_Produto,'VL_IPI') VL_BASE_IPI,

		dbo.fBusca_Custo(HOU.Num_Proc_HIO,PS.CD_Pedido, PS.Cd_Produto,'%PIS%')	vlrPIS,
		dbo.fBusca_Custo(HOU.Num_Proc_HIO,PS.CD_Pedido, PS.Cd_Produto,'%COFINS%') vlrCOFINS,
		dbo.fBusca_Custo(HOU.Num_Proc_HIO,PS.CD_Pedido, PS.Cd_Produto,'%ICMS%')	vlrICMS,
		dbo.fBusca_Custo(HOU.Num_Proc_HIO,PS.CD_Pedido, PS.Cd_Produto,'%AFRMM%') +
		dbo.fBusca_Custo(HOU.Num_Proc_HIO,PS.CD_Pedido, PS.Cd_Produto,'%Frete Interno%') +
		dbo.fBusca_Custo(HOU.Num_Proc_HIO,PS.CD_Pedido, PS.Cd_Produto,'%Armazenagem%') +
		dbo.fBusca_Custo(HOU.Num_Proc_HIO,PS.CD_Pedido, PS.Cd_Produto,'%Demurrage%') vlrOutrosCustos,
		dbo.fBusca_Custo_Processo (HOU.Num_Proc_Hio,'%AFRMM%') AFRMM,
		dbo.fBusca_Custo_Processo (HOU.Num_Proc_Hio,'%Frete Interno%') FRETE,
		dbo.fBusca_Custo_Processo (HOU.Num_Proc_Hio,'%Armazenagem%') ARMAZENAGEM,
		dbo.fBusca_Custo_Processo (HOU.Num_Proc_Hio,'%Demurrage%') DEMURRAGE,
		NF.Numero_PO_HIO	Nr_Nota_Fiscal,
		NF.Data_PO_HIO		Data_NF,
		max(Processo_PC)			Status,
		Business_Descr
	from
		House_IMP_Out HOU
		Join LLP_IMP_Out			LLP	on HOU.Num_Proc_HIO = LLP.Num_Proc_LIO
		Left outer join Fatura_CHB	FCHB on HOU.Num_Proc_HIO = FCHB.Processo_PC
		Left Join Pedido_Ship 		PS	on HOU.Num_Proc_HIO = PS.Num_Proc
		Left Join Pedido_Det		PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
		Join Pedido					P	on PS.Cd_Pedido = P.Cd_Pedido
		Join Produto_Cliente		PC	on PS.Cd_Produto =PC.Cd_Prod
		Left Join De_Para_Produto	DPP	on PC.Cd_Proc_Cliente = DPP.GMID 
		Left Join Pessoa_LLP		RC	on P.Planta = RC.cd_planta and RC.Planta_Nome is not null and RC.Cd_Pes_Grupo='1'
		Left Join Pessoa_LLP		DC	on P.Cd_Seller = DC.Cd_Pes and DC.Planta_Nome is not null and DC.Cd_Pes_Grupo='1'
		Left Join Pessoa			RCC	on RC.Cd_Pes = RCC.Cd_Pes and num_cpf_cnpj <> ''
		Left Join Localidade		LC	on Hou.Cd_Dst_HIO = Lc.Cd_Local
		Left Join PO_HIO			PO  on hou.num_proc_HIO = po.num_proc_HIO and PO.Id_Dc=1
		Left Join PO_HIO			SO	on hou.num_proc_HIO = SO.num_proC_HIO and SO.ID_DC=3
		Left Join PO_HIO			INV on HOU.num_proc_HIO=INV.num_proc_HIO and INV.ID_DC=2
		Left Join PO_HIO			NF  on hou.num_proc_hio = NF.num_proc_hio and NF.Id_Dc=10
		Left Join Tarefas_Processos	TP	on hou.num_proc_HIO=TP.num_proc and TP.id_task=13
		Join Pessoa_LLP				PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIO and PLL.Cd_Pes_Grupo='1'
	where
		right(left(HOU.Num_Proc_HIO,9),4) = '2009' and dt_conclusao is not null
	Group by
			HOU.Num_Proc_HIO,
			HOU.Dt_Emis_HIO,
			P.Num_PO,
			PS.Item,
			P.Num_Pedido,
			DC.Cd_Planta,
			DC.Planta_Nome,
			P.Planta,
			RC.Planta_Nome,
			LC.Pais_Local,
			INV.numero_po_HIO,
			INV.Data_po_HIO,
			LLP.ATD_LIO,
			LLP.ATA_LIO,
			PS.CD_Pedido, PS.Cd_Produto,
			PO.numero_po_HIO,
			SO.numero_po_HIO,
			num_cpf_cnpj,
			Dt_conclusao,
			NF.Numero_PO_HIO,
			NF.Data_PO_HIO,
			Business_Descr












GO
